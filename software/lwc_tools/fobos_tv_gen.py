#!/usr/bin/env python3

"""
FOBOS testvector generator
generates testvectors and FOBOS input files from TOML design description
author: Kamyar Mohajerani

- install requirements:
python3 -m pip -r requirements.txt
"""

import logging
import os
import random
import secrets
from functools import reduce
from pathlib import Path
from typing import Dict, Literal, Optional, Sequence, Union

import click
from cryptotvgen.cli import run_cryptotvgen
from xeda import Design
from xeda.dataclass import Extra, Field
from xeda.dataclass import XedaBaseModel as BaseModel

logger = logging.getLogger(__name__)
logger.root.setLevel(logging.INFO)


class Lwc(BaseModel):
    """design.lwc"""

    class Aead(BaseModel):
        class InputSequence(BaseModel):
            encrypt: Optional[Sequence[Literal["ad", "pt", "npub", "tag"]]] = Field(
                ["npub", "ad", "pt", "tag"],
                description="Sequence of inputs during encryption",
            )
            decrypt: Optional[Sequence[Literal["ad", "ct", "npub", "tag"]]] = Field(
                ["npub", "ad", "ct", "tag"],
                description="Sequence of inputs during decryption",
            )

        algorithm: Optional[str] = Field(
            None,
            description="Name of the implemented AEAD algorithm based on [SUPERCOP](https://bench.cr.yp.to/primitives-aead.html) convention",
            examples=["giftcofb128v1", "romulusn1v12", "gimli24v1"],
        )
        key_bits: Optional[int] = Field(description="Size of key in bits.")
        npub_bits: Optional[int] = Field(description="Size of public nonce in bits.")
        tag_bits: Optional[int] = Field(description="Size of tag in bits.")
        input_sequence: Optional[InputSequence] = Field(
            None,
            description="Order in which different input segment types should be fed to PDI.",
        )
        key_reuse: bool = False

    class Hash(BaseModel):
        algorithm: str = Field(
            description="Name of the hashing algorithm based on [SUPERCOP](https://bench.cr.yp.to/primitives-aead.html) convention. Empty string if hashing is not supported",
            examples=["", "gimli24v1"],
        )
        digest_bits: Optional[int] = Field(
            description="Size of hash digest (output) in bits."
        )

    class Ports(BaseModel):
        class Pdi(BaseModel):
            bit_width: Optional[int] = Field(
                32,
                ge=8,
                le=32,
                description="Width of each word of PDI data in bits (`w`). The width of 'pdi_data' signal would be `pdi.bit_width × pdi.num_shares` (`w × n`) bits.",
            )
            num_shares: int = Field(1, description="Number of PDI shares (`n`)")

        class Sdi(BaseModel):
            bit_width: Optional[int] = Field(
                32,
                ge=8,
                le=32,
                description="Width of each word of SDI data in bits (`sw`). The width of `sdi_data` signal would be `sdi.bit_width × sdi.num_shares` (`sw × sn`) bits.",
            )
            num_shares: int = Field(1, description="Number of SDI shares (`sn`)")

        class Rdi(BaseModel):
            bit_width: int = Field(
                0,
                ge=0,
                # le=2048,
                description="Width of the `rdi` port in bits (`rw`), 0 if the port is not used.",
            )

        pdi: Pdi = Field(description="Public Data Input port")
        sdi: Sdi = Field(description="Secret Data Input port")
        rdi: Optional[Rdi] = Field(None, description="Random Data Input port.")

    class ScaProtection(BaseModel):
        class Config:
            extra = Extra.allow

        target: Optional[Sequence[str]] = Field(
            None,
            description="Type of side-channel analysis attack(s) against which this design is assumed to be secure.",
            examples=[["spa", "dpa", "cpa", "timing"], ["dpa", "sifa", "dfia"]],
        )
        masking_schemes: Optional[Sequence[str]] = Field(
            [],
            description='Masking scheme(s) applied in this implementation. Could be name/abbreviation of established schemes (e.g., "DOM", "TI") or reference to a publication.',
            examples=[["TI"], ["DOM", "https://eprint.iacr.org/2022/000.pdf"]],
        )
        order: int = Field(
            ..., description="Claimed order of protectcion. 0 means unprotected."
        )
        notes: Optional[Sequence[str]] = Field(
            [],
            description="Additional notes or comments on the claimed SCA protection.",
        )

    aead: Optional[Aead] = Field(
        None, description="Details about the AEAD scheme and its implementation"
    )
    hash: Optional[Hash] = None
    ports: Ports = Field(description="Description of LWC ports.")
    sca_protection: Optional[ScaProtection] = Field(
        None, description="Implemented countermeasures against side-channel attacks."
    )
    block_size: Dict[str, int] = Field({"xt": 128, "ad": 128, "hm": 128})


class LwcDesign(Design):
    """A Lightweight Cryptography hardware implementations"""

    lwc: Lwc


def gen_tv(
    lwc: Lwc,
    dest_dir: Union[str, os.PathLike],
    blocks_per_segment=None,
    bench=False,
    cref_dir=None,
):
    args = [
        "--dest",
        str(dest_dir),
        "--max_ad",
        "80",
        "--max_d",
        "80",
        "--max_io_per_line",
        "32",
        "--verify_lib",
    ]
    if cref_dir:
        args += [
            "--candidates_dir",
            str(cref_dir),
        ]
    if lwc.aead:
        assert lwc.aead.algorithm
        args += [
            "--aead",
            lwc.aead.algorithm,
        ]
        if lwc.aead.input_sequence:
            args += ["--msg_format", *lwc.aead.input_sequence]

    if lwc.hash:
        args += [
            "--hash",
            lwc.hash.algorithm,
        ]
    args += [
        "--io",
        str(lwc.ports.pdi.bit_width),
        str(lwc.ports.sdi.bit_width),
    ]

    args += ["--gen_custom", "False,False,16,16,False"]

    return run_cryptotvgen(args, logfile=None)  # type: ignore


def xor(l, r):
    return bytes(a ^ b for a, b in zip(l, r))


INS_PREAMBLE = "INS = "
HDR_PREAMBLE = "HDR = "
DAT_PREAMBLE = "DAT = "
STT_PREAMBLE = "STT = "

PREAMBLES_LEN = len(INS_PREAMBLE)


def gen_shared_lines(
    in_lines,
    num_shares,
    w_nbytes,
    keep_comments,
    replace_with_random=False,
):
    num_tests = 0
    shared_lines = []
    all_data = []
    if replace_with_random:
        keep_comments = False
    for line in in_lines:
        line = line.strip()
        if not keep_comments and (line.startswith("#") or not line):
            continue
        if len(line) < PREAMBLES_LEN:
            print("[ERROR] input line is too short")
            continue
        preamble = line[:PREAMBLES_LEN]
        data = line[PREAMBLES_LEN:].strip()
        if preamble == INS_PREAMBLE:
            num_tests += 1
        if (
            preamble == HDR_PREAMBLE or preamble == INS_PREAMBLE
        ):  # set other shares to zeros
            if w_nbytes == 0:
                w_nbytes = (len(data) + 1) // 2
            data = data + ("0" * (num_shares - 1) * len(data))
            line = preamble + data
            all_data.append(data)
        elif preamble == DAT_PREAMBLE:
            data_bytes = bytes.fromhex(data)
            data = ""
            for i in range(0, len(data_bytes), w_nbytes):
                word = data_bytes[i : i + w_nbytes]
                shares = [secrets.token_bytes(w_nbytes) for _ in range(num_shares - 1)]
                if replace_with_random:
                    shares.append(secrets.token_bytes(w_nbytes))
                else:
                    shares.append(reduce(xor, shares + [word]))
                    assert reduce(xor, shares) == word
                data += "".join([x.hex().upper() for x in shares])
            line = preamble + data
            all_data.append(data)
        shared_lines.append(line)
    return shared_lines, all_data


def get_data_only(file: Path):
    data = []
    with open(file, "r") as f:
        for line in f.readlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            if line[:PREAMBLES_LEN] in [
                INS_PREAMBLE,
                HDR_PREAMBLE,
                DAT_PREAMBLE,
                STT_PREAMBLE,
            ]:
                data.append(line[PREAMBLES_LEN:].strip())
    return data


def gen_shares(in_file: Path, num_shares, w_nbytes=0, keep_comments=True):
    out_file = in_file.parent / (in_file.stem + f"_shared_{num_shares}.txt")

    with open(in_file) as f:
        in_lines = f.readlines()

    shared_lines, _ = gen_shared_lines(in_lines, num_shares, w_nbytes, keep_comments)

    with open(out_file, "w") as fo:
        if keep_comments:
            fo.write(
                f"#\n# Shared version of {in_file.name} split into {num_shares} shares\n#\n"
            )
        fo.write("\n".join(shared_lines))
    return out_file


FIFO0_LABEL = "00C0"
FIFO1_LABEL = "00C1"
EXP_OUT_LABEL = "0081"
START_LABEL = "0080"
START_CMD = "0001"


def gen_fobos_tvla(
    num_vectors: int,
    pdi_file: Path,
    pdi_shares: int,
    sdi_file: Optional[Path] = None,
    sdi_shares: Optional[int] = None,
    do_file: Optional[Path] = None,
    fvr_filename=None,
    din_filename=None,
):
    if fvr_filename is None:
        fvr_filename = pdi_file.parent / "fvrchoicefile.txt"
    if din_filename is None:
        din_filename = pdi_file.parent / "dinFile.txt"

    if sdi_file is None:
        sdi_file = pdi_file.parent / "sdi.txt"

    if sdi_shares is None:
        sdi_shares = pdi_shares

    with open(sdi_file) as f:
        sdi_in_lines = f.readlines()
    _, sdi_shared_data = gen_shared_lines(sdi_in_lines, sdi_shares, 0, False)
    sdi_str = "".join(sdi_shared_data)

    with open(pdi_file) as f:
        pdi_in_lines = f.readlines()

    sdi_len = hex(len(sdi_str) // 2)[2:].zfill(4)  # in bytes

    if do_file is None:
        do_file = pdi_file.parent / "do.txt"
    do_data = get_data_only(do_file)
    do_len = sum(len(x) for x in do_data) // 2  # in bytes
    shared_do_len = hex(do_len * pdi_shares)[2:].zfill(4)

    with open(din_filename, "w") as din_file, open(fvr_filename, "w") as fvr_file:
        for _ in range(num_vectors):
            coin = random.randint(0, 1)
            fvr_file.write(str(coin))

            _, pdi_shared_data = gen_shared_lines(
                pdi_in_lines, pdi_shares, 0, False, replace_with_random=coin == 1
            )
            pdi_str = "".join(pdi_shared_data)
            pdi_len = hex(len(pdi_str) // 2)[2:].zfill(4)  # in bytes

            tv = (
                FIFO0_LABEL
                + pdi_len
                + pdi_str
                + FIFO1_LABEL
                + sdi_len
                + sdi_str
                + EXP_OUT_LABEL
                + shared_do_len
                + START_LABEL
                + START_CMD
            )
            din_file.write(tv + "\n")


@click.command()
@click.argument("toml_path")
@click.option(
    "--kats-dir",
    default="FOBOS_KAT",
    type=Path,
    help="directory to write KATs",
)
@click.option(
    "--tvla",
    default=0,
    type=int,
    help="num TVLA testvectors to generate",
)
def cli(toml_path, kats_dir, tvla):
    """toml_path: Path to design description TOML file."""
    design = LwcDesign.from_toml(toml_path)
    lwc = design.lwc
    assert lwc.aead and lwc.aead.algorithm
    pdi_shares = lwc.ports.pdi.num_shares
    sdi_shares = lwc.ports.sdi.num_shares
    tv_dir = kats_dir / design.name
    cref_dir = Path(toml_path).parent / "cref"
    if not cref_dir.exists():
        cref_dir = None
    gen_tv(design.lwc, tv_dir, bench=True, cref_dir=cref_dir)
    kat_dir = tv_dir
    pdi_txt = kat_dir / "pdi.txt"
    sdi_txt = kat_dir / "sdi.txt"
    do_txt = kat_dir / "do.txt"
    if tvla:
        gen_fobos_tvla(tvla, pdi_txt, pdi_shares, sdi_txt, sdi_shares, do_file=do_txt)
    if pdi_shares > 1 or sdi_shares > 1:
        pdi_txt = gen_shares(pdi_txt, pdi_shares, keep_comments=False)
        sdi_txt = gen_shares(sdi_txt, sdi_shares, keep_comments=False)

if __name__ == "__main__":
    cli()
