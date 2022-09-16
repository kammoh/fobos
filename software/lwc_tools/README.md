# Generation of FOBOS-ready TVLA test vectors

1. Generate an LWC test vector. This can be a short test vector. For example to generate test vectors for Xoodyak:

    ```
    cryptotvgen --aead xoodyakv1 --gen_custom False,False,16,16,False
    ```
2. Convert into shared format.

    ```
    python3 gen_shared.py  --pdi-file KAT/pdi.txt --sdi-file KAT/sdi.txt --pdi-width 32 --sdi-width 32 --pdi-shares 2 --sdi-shares 2
    ```
3. Convert to FOBOS-ready TVLA test vectors.

    ```
    python3 lwc_2_fobos_tv.py --width 32 --shares 2 --num_vectors 1 --pdi_file KAT/pdi_shared_2.txt --sdi_file KAT/sdi_shared_2.txt --do_file KAT/do.txt
    ```
