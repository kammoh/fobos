.. _tvgen-label:

Test Vector Generation
**********************

The user must prepare test vectors before running data acquisition. User defined scripts or scripts provided with FOBOS can be used.
The data acquisition scripts will send the test vectors one at a time and collect traces from the oscilloscope.

Cryptographic hardware interfaces typically use multiple data types as input to cryptographic cores. 
For example, some algorithms might need plaintext/ciphertext, cryptographic keys, and random data. 
We provide a simple wrapper to split data provided by the control board to separate streams. 
This wrapper is directly compatible with CAESAR Hardware API interface and is expected to be directly compatible with a future Hardware API for Lightweight Cryptography (LWC API). 
We developed a simple, yet versatile protocol to enable the wrapper to split the data types. 
The wrapper receives data from the control board and distributes it into three FIFOs:

1. The Public Data Input (PDI) FIFO (i.e. plaintext) 
2. The Secret Data Input (SDI) FIFO (i.e. key) 
3. The Random Data Input (RDI) FIFO which stores random data which can be used for protected implementations that use masking schemes.

Once the wrapper prepares the data for the function core, it starts the core which consumes the data in the input FIFOs and produces output. 
The wrapper accumulates the output into a fourth FIFO called the Data Out (DO) FIFO until the expected number of bytes are stored. 
Then, the wrapper returns the data to the control board which forwards it back to the PC.

.. figure::  figures/fobos2-block.png
   :align:   center
   :height: 300 px

   FOBOS2 block diagram


The following is a brief description for the test vector format

Supported commands
==================

- 00C0 # pdi fifo (length in bytes to follow)
- 00C1 # sdi fifo (length in bytes to follow)
- 00C2 # rdi fifo (length in bytes to follow)
- 0081 # store expected output size (expected output size in bytes to follow)
- 0080 # select command register (command to follow)


FOBOS Protocol Example
----------------------

Here is an example of a signle test vector(split into multiple lines)::


    00C0 # pdi fifo (length in bytes to follow)
    0008 # 8 bytes
    FFFF # 8 bytes of pdi
    FFFF
    FFFF
    FFFF 
    00C1 # sdi fifo (length in bytes to follow)
    000A # 10 bytes
    0000 # 10 bytes of sdi
    0000
    0000
    0000
    0000 
    0081 # store expected output size
    0008 # 8 bytes of output expected
    0080 # select command register
    0001 # "start signal"


Using the blockCipherTVGen.py script
====================================
The blockCipherTVGen.py can be used to generate test vectors to be used by block ciphers. The script is located at fobos/software/tvgen/
There are two steps to use it:

1. Set user defined parameters.
2. Run the script. It will generate the test vector file and plaintext file (not required for acquisition).


Example: Generating AES-128 test vectors
----------------------------------------

AES-128 takes 16 bytes (128 bits) plaintext, 16 key and returns 16 byte ciphertext.
Here is an example to generate 4 test vectors with 16 byte blocks, key and ciphertext. Key is fixed in this case.

Settings::

    ############user defined settings
    TRACE_NUM = 1000                           # Number of traces
    PDI_LENGTH = 16                            # In byets
    SDI_LENGTH = 16                            # In bytes
    EXPECTED_OUT = 16                          # Expected output in bytes
    DIN_FILE = 'dinFile.txt'                   # Desitination file name
    PLAINTEXT_FILE = 'plaintext.txt'           # Desitination file name
    FIXED_KEY = 'yes'                          # Fixed key = yes | no
    KEY = '123456789009876ABCDFE12456789ABF'   # Fixed key

To run the script, use the following command::

    $ python blockCipherTVGen.py 

Here is how the generated dinFile.txt looks like.::

    $ cat dinFile.txt 
    00C000103AD5305EBD0C99C7482263E2D7ECEAED00C1001012345...0081001000800001
    00C000105C09504D713BF9B5925601E671EA257800C1001012345...0081001000800001
    00C00010A6D6DE2548E4CCF446ECA8E620E4E55500C1001012345...0081001000800001
    00C00010E0792CDE9AFDA7EAC33A8D0EADE524CB00C1001012345...0081001000800001
    00C000104A09A00A4C4268F0B6F4FCE4F514A6BB00C1001012345...0081001000800001

This file can now be used in FOBOS as a test vector file.

A plaintext.txt file is also generated, it includes only the PDI portion dinFile.txt::

    $ cat plaintext.txt 
    3A D5 30 5E BD 0C 99 C7 48 22 63 E2 D7 EC EA ED
    5C 09 50 4D 71 3B F9 B5 92 56 01 E6 71 EA 25 78
    A6 D6 DE 25 48 E4 CC F4 46 EC A8 E6 20 E4 E5 55
    E0 79 2C DE 9A FD A7 EA C3 3A 8D 0E AD E5 24 CB
    4A 09 A0 0A 4C 42 68 F0 B6 F4 FC E4 F5 14 A6 BB

This file can be used later by the analysis module.