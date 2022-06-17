.. _fobos-windows-install:

====================
Windows Installation
====================
Below, we describe how to setup FOBOS 3.0 software and test that everything is working on Windows.


Requirements
------------
#. A PC with Windows 10 installed.
#. FOBOS 3.0 ``fobos-v3.0.zip`` file.

Software Setup
--------------

Note: The following installation procedure is tested on Windows 10.

#. Download FOBOS from the `FOBOS home page <https://cryptography.gmu.edu/fobos/getfobos.php>`_.
#. Extract the archive into the directory of your choice


#. Use the following commands to install pip and few necessary Python packages:

.. code-block:: bash

    $ sudo apt-get install python-pip
    $ sudo apt install make 
    $ cd fobos
    $ sudo pip install -r requirements.txt


