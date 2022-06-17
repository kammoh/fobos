.. _fobos-linux-install:

==================
Linux Installation
==================
Below, we describe how to setup FOBOS 3.0 software and test that everything is working on Linux.


Requirements
------------
#. A PC with Ubuntu 20.04 installed.
#. FOBOS 3.0 ``fobos-v3.0.tgz`` file.
#. ``sudo`` rights

Basic Downloads
---------------

Note: The following installation procedure is tested on Linux Ubuntu 20.04.

#. Download FOBOS from the `FOBOS home page <https://cryptography.gmu.edu/fobos/>`_.
#. Extract the archive into a directory of your choice

   .. code-block:: bash
   
       tar xvfz fobos-v3.0.tgz
    
#. Use the following commands to install pip and few necessary Python packages:

   .. code-block:: bash
   
       sudo apt-get install python-pip
       sudo apt install make 
       cd fobos
       sudo pip install -r requirements.txt


JupyterLab Installation
-----------------------

These installation instructions are based on 
`Install JupyterLab the Hard Way <https://github.com/jupyterhub/jupyterhub-the-hard-way/blob/HEAD/docs/installation-guide-hard.md>`_.

**Install JupyterHub and JupyterLab into a virtual environment**

#.  Install Python support for virtual environments.
    
    .. code-block:: bash

        sudo apt-get install python3-venv
    
#.  Create a virtual environment for JupyterHub and JupyterLab.
    
    .. code-block:: bash

        sudo python3 -m venv /opt/jupyterhub/
    
#.  Install JupyterHub and JupyterLab into this virtual environment.
    
    .. code-block:: bash

        sudo /opt/jupyterhub/bin/python3 -m pip install wheel
        sudo /opt/jupyterhub/bin/python3 -m pip install jupyterhub jupyterlab
        sudo /opt/jupyterhub/bin/python3 -m pip install ipywidgets
    
#.  Then install ``nodejs`` and ``npm`` to support the ``configurable-http-proxy`` that JupyterHub needs.
    
    .. code-block:: bash

        sudo apt install nodejs npm
        sudo npm install -g configurable-http-proxy

**Create JupyterHub configuration**

#.  Create a directory for the configuration files and generate the JupyterHub configuration file.

    .. code-block:: bash

        sudo mkdir -p /opt/jupyterhub/etc/jupyterhub/
        cd /opt/jupyterhub/etc/jupyterhub/
        sudo /opt/jupyterhub/bin/jupyterhub --generate-config

#.  Edit the config file we just created as root ``jupyterhub_config.py``
    and change the following settings.

    .. code-block:: python

        set "c.Spawner.notebook_dir = '~/notebooks/'     "
        set "c.Spawner.default_url = '/lab'              "

**Configure Systemd to automatically start JupyterHub**

#.  Create a folder for the systemd file

    .. code-block:: bash

        sudo mkdir -p /opt/jupyterhub/etc/systemd

#.  Then create as root the file ``/opt/jupyterhub/etc/systemd/jupyterhub.service``
    and past the following instructions into the file:

    .. code-block:: bash

       [Unit]
       Description=JupyterHub
       After=syslog.target network.target
       
       [Service]
       User=root
       Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/opt/jupyterhub/bin"
       ExecStart=/opt/jupyterhub/bin/jupyterhub -f /opt/jupyterhub/etc/jupyterhub/jupyterhub_config.py
       
       [Install]
       WantedBy=multi-user.target

#.  Link this file to the Systemd's dirctory

    .. code-block:: bash

        sudo ln -s /opt/jupyterhub/etc/systemd/jupyterhub.service /etc/systemd/system/jupyterhub.service

#.  Have systemd reload the configuration file

    .. code-block:: bash

        sudo systemctl daemon-reload

#.  Enable this service

    .. code-block:: bash

        sudo systemctl enable jupyterhub.service

#.  And finally start JupyterHub

    .. code-block:: bash

        sudo systemctl start jupyterhub.service

#.  You can always check if its running:

    .. code-block:: bash

        sudo systemctl status jupyterhub.service

Conda Installation
------------------

These installation instructions are based on 
`Install JupyterLab the Hard Way <https://github.com/jupyterhub/jupyterhub-the-hard-way/blob/HEAD/docs/installation-guide-hard.md>`_.
We will use ``conda`` to manage the Python environments.

#.  Get the Anaconda public gpg key

    .. code-block:: bash

        cd 
        curl https://repo.anaconda.com/pkgs/misc/gpgkeys/anaconda.asc | gpg --dearmor > conda.gpg
        sudo install -o root -g root -m 644 conda.gpg /etc/apt/trusted.gpg.d/
        rm conda.gpg

#.  Add Debian repository

    .. code-block:: bash

        echo "deb [arch=amd64] https://repo.anaconda.com/pkgs/misc/debrepo/conda stable main" | sudo tee /etc/apt/sources.list.d/conda.list

#.  Install conda

    .. code-block:: bash

        sudo apt update
        sudo apt install conda

#.  Make conda easily available by running the setup script on login.

    .. code-block:: bash

        sudo ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh

#.  Install a default conda environment for all users

    .. code-block:: bash

        sudo mkdir /opt/conda/envs/
        sudo /opt/conda/bin/conda create --prefix /opt/conda/envs/python python=3.8 ipykernel
        sudo /opt/conda/envs/python/bin/python -m ipykernel install --prefix=/opt/jupyterhub/ --name 'python' --display-name "Python (default)"

FOBOS Software Installation
---------------------------

Finally we get to install FOBOS to run in the JupyterLab we just created.

#.  Install required packages

    .. code-block:: bash

        sudo /opt/jupyterhub/bin/python3 -m pip install numpy
        sudo /opt/jupyterhub/bin/python3 -m pip install matplotlib
        sudo /opt/jupyterhub/bin/python3 -m pip install scipy

#.  Install packages required for PDF export of jupyter notebooks

    .. code-block:: bash

        sudo apt-get install pandoc texlive-xetex texlive-fonts-recommended 

#.  Install FOBOS into ``/opt/fobos`` by simpy moving the whole package.

#.  Create notebooks folders in all users home directories and 
    copy fobos notebooks into the users notbook directories   

    .. code-block:: bash

        cd /home/username/
        mkdir -p notebooks/fobos
        cd notebooks/fobos
        cp -a /opt/fobos/software/notebooks/* .


Install DUT Support
-------------------

---Chipwhisperer DUTs

based on https://chipwhisperer.readthedocs.io/en/latest/linux-install.html
as we only want to program the DUTs we won't install everything.

sudo mkdir /opt/chipwhisperer
sudo chown $USER /opt/chipwhisperer
cd /opt
git clone https://github.com/newaetech/chipwhisperer
sudo cp chipwhisperer/hardware/50-newae.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
sudo usermod -aG dialout $USER
sudo usermod -aG plugdev $USER

## Add chip whisperer to jupyterhub package directory and install require packages
sudo ln -s /opt/chipwhisperer/software/chipwhisperer/ /opt/jupyterhub/lib/python3.8/site-packages/

## install cw required software
sudo /opt/jupyterhub/bin/python3 -m pip install pyusb
sudo /opt/jupyterhub/bin/python3 -m pip install libusb1
sudo /opt/jupyterhub/bin/python3 -m pip install pyserial
sudo /opt/jupyterhub/bin/python3 -m pip install tqdm
sudo /opt/jupyterhub/bin/python3 -m pip install ECPy

---Digilent DUTs

they require djtcfg, Digilent Adept
https://digilent.com/shop/software/digilent-adept/
download for Linux
 Adept for Linux Runtime 
 Adept Utilities 

DONE

