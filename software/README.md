FOBOS-Software
==============

  * `foboslib` contains all common FOBOS functions.
  * `notebooks` contains Jupyter notebooks that run within Jypyter Lab on a PC.
  * `pynq=notebooks` contains Jupyter notebooks that run on within Jupyter Hub on Pynq.
  * `examples` contains command line examples

Installation on Pynq Board
--------------------------

Copy this `software` directory to the Pynq board via scp or sftp. Then run on Pynq the script `sudo ./install-pynq.sh`.

Installation on the SCA Workstation
-----------------------------------

Follow the instructions in the file `jupyterlab-install.txt`. The first part describes the installation on a Linux system. This can be used for a multi-user, remote accessible, installation. The file does not describe how to secure this installation and how to install SSL certificates. Please read the JupyterLab and JupyterHub documentation.

The second part describes the installation for a single user on a Windows 10 system. This part has not been fully tested.

