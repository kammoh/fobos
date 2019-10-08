Breaking AES Implementation With CPA
************************************
We present an example of using FOBOS to find the secret key of AES-128 implementation on FPGA.
The AES-128 cipher uses 128-bit key and block size. First, the 128 bit key and data block are xor-ed
. Then the result is passed throw an 8-bi S-box (substitution box). For more details about AES, please refer to [AES-ref]


Step 1: Choose the intermediate value
--------------------------------------
Note: In this example we discuss the first byte of the key (LSB byte). The same can be performed to find all other bytes.

The intermediate value we choose is the output of the sbox after the first round. This value depends on one byte of the key and one byte of
the plain text. That is 

f(d, k) = sbox(pt\ :sub:`i` xor key)

Step 2: Power measurement
--------------------------

We measured power consumption the power consumption of the implementation while it encrypted 100000 blocks of data using the same key.
The cipher was implemented on Digilent Nexys3 board which features a Xilinx Spartan6 FPGA. For more detail about collecting the traces, please refer to [capture_example]

Here are few first blocks of the plain text

.. code-block::

    51720187c36e0c8523acb8535a870703
    b334ba70d60f5af510abd747708bde7b
    45863440e2bff9563604375dad57c226
    f389191bf9bab64d0ad3fe1e0d696105


The traces are stored in a 100000 x 1000 matrix **T** (100000 traces and 1000 samples per trace).
For each trace, the value *d* that goes into the calculation is the first (LSB) byte of the plaintext above. So the vector **d** will be a vector of bytes with dimensions 100000 x 1.

Here are the first few elements in the vector **d**.

.. code-block::

    03
    7b
    26
    05

Step 3: Calculate hypothetical intermediate
-------------------------------------------

The intermediate value we are attacking needs 1 byte of key and 1 byte of plaintext to be calculated. We need to guess the key.
A byte will have the values between 0 and 255 so the vector **k** is the vector [0, 1, 2 ... , 255] with dimensions 256 x 1.
Now for each of the key guesses and the values in **d**, we evaluate the function.

f(d, k) = sbox(pt\ :sub:`i` xor key)

The result will be stored in a martix **V** which is 100000 x 265 where the first column is the value of the intermediate when k=0 for all data values *d*.
Here are few elements of the matrix **V** calculated form the data above.

.. code-block::
   :emphasize-lines: 1

    k=0     k=1     k=2     k=3     k=4   ...
    0x7b    0x77    0x7c    0x63    0xc5  ...
    0x21    0xda    0xb6    0xbc    0xd2  ...
    0xf7    0xcc    0x36    0x3f    0x93  ...
    0x6b    0xf2    0xc5    0x6f    0x7c  ...
    0xd2    0xf3    0xff    0x10    0x21  ...
    .       .       .       .       .     ...
    .       .       .       .       .     ...
    .       .       .       .       .     ...


Step 4: Calculate Hypothetical Power
-------------------------------------
Now we have calculated the intermediate values matrix **V**, we estimate the power consumption when each value in **V** is processed in the device.
We use the hamming distance model to model the power consumption of FPGA CMOS since it consumes more power when gates change state.

For example, when the output of the sbox changes from 0x7b to 0x21, the hamming distance = HD(0x7b, 0x21) = HW(0x7b ^ 0x21) = HW(0x5a) = HW(0b01011010) = 4.

The result is a *100000 x 256* matrix called **H**. These are the same dimensions as the matrix **V**.

.. code-block::
   :emphasize-lines: 1

    k=0  k=1  k=2  k=3  k=4...
    6    6    5    4    4  ...
    4    5    4    7    4  ...
    5    3    1    3    2  ...
    4    5    6    2    7  ...
    5    1    4    7    5  ...
    .       .       .      ...
    .       .       .      ...


Step 5: Correlate the hypothetical power and the real power traces
-------------------------------------------------------------------

We correlate H and T to find the key. The question is: which column in **V** was most likely processed in the device?
We use a correlation algorithm that takes two vectors as input and returns a real number that measures how 'similar' the vectors are.
Each column *i* in **H** is compared with column *j* in the trace matrix **T**. The result is stored in the correlation matrix **R** which is a *K x T* matrix.
Note that column *i* in matrix **H** is the hypothetical power if **k**\ :sub:`i` is used in the device and column *j* in **T** is the real power measurement at sample *j* for all data blocks.

The element **R**\ :sub:`i,j` measures how similar the column *i* in **H** to column *j* in **T**.
The index of the highest element in the matrix **R** *ck*, *ct* are the in index of the key and the sample in time of the supposedly correct key since it indicates that the corresponding columns in **H** and **T** are similar so it is likely that the guessed key was indeed used in the device.

