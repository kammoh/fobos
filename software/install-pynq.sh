#! /bin/bash
#############################################################################
#   install-pynq.sh - FOBOS                                                 #
#   -----------------------                                                 #          
#   script to install FOBOS components on the Xilinx Pynq Z1                #
#                                                                           #
#                                                                           #
#   Copyright 2022 CERG                                                     #
#                                                                           #
#   Licensed under the Apache License, Version 2.0 (the "License");         #
#   you may not use this file except in compliance with the License.        #
#   You may obtain a copy of the License at                                 #
#                                                                           #
#       http://www.apache.org/licenses/LICENSE-2.0                          #
#                                                                           #
#   Unless required by applicable law or agreed to in writing, software     #
#   distributed under the License is distributed on an "AS IS" BASIS,       #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
#   See the License for the specific language governing permissions and     #
#   limitations under the License.                                          #
#                                                                           #
#############################################################################

currentversion="3.0"

function writeconfig
{
echo "Writing configuration file $outfile"
echo "# FOBOS PYNQ Components Configuration
# ----------------------------------------------------
# Don't delete the file $fobosconf
# It will be used during updates and re-installations
#
foboshome=$foboshome
version=$version
ipaddress=$ipaddress
portnumber=$portnumber
overlay=$overlay
export foboshome version ipaddress portnumber overlay
" > $outfile
}

function writepythonconfig
{
echo "Writing python configuration file $outfile"
echo "# FOBOS PYNQ Components Configuration
# ----------------------------------------------------
# Don't edit this file. It was generated by the 
# install-pynq.sh script and will be overwritten 
# during upgraddes. If you want to make changes, run 
# the script again and tell it to not use old 
# configuration files. Then you can provide new 
# answers and this file will be re-created.
#
FOBOS_VERSION = $version
FOBOS_HOME = \"$foboshome\"
IP =  '$ipaddress'
PORT = $portnumber
OVERLAY_FILE = \"$overlay\"
" > $outfile
}


#---Greeting
cat <<EOF








             FOBOS PYNQ Components Installation/Update

Please read the INSTALL or the UPDATE-3.0 file before continuing 
with the installation/update!

EOF

echo "FOBOS PYNQ Components Configuration"
echo "------------------------------------------------------------"
#---Checking for local configuration file from previous run
if [ -f fobos_pynq.conf ]; then
    echo "Found configuration file \"./fobos_pynq.conf\"." 
    echo -n "Do you want to use it? (y/n): [y]"; read input
    if [ -z $input ] || [ $input = "y" ]; then
        echo "Using settings from ./fobos_pynq.conf";
        source fobos_pynq.conf
        # We still test every single time just in case a parameter was
        # added which is not in the old fobos_pynq.conf. This is important
        # when upgrading an installation.
        version=""
    fi
fi

#---Getting path to installation
if [ -z $foboshome ]; then
    echo "Please enter the full path to the FOBOS home directory."
    echo -n "FOBOS home: [/home/xilinx/fobos] "; read foboshome
    if [ -z $foboshome ]; then
        foboshome="/home/xilinx/fobos"
    fi
    foboshome=`echo $foboshome | sed 's/\/$//'`
fi
#---Checking if directory already exists
if [ -f $foboshome ]; then
    echo "ERROR: $foboshome is a file, not a directory. Please enter the name of a directory.";
    exit 1;
fi
if [ -d $foboshome ]; then
    echo "$foboshome already exists, checking for previous installation.";
    fobosconf=$foboshome"/software/fobos_pynq.conf"
    if [ -f $fobosconf ]; then
        echo "Found configuration file $fobosconf."
        echo -n "Do you want to use it? Updates and re-installs usually say y (y/n): [y]"; read input
        if [ -z $input ] || [ $input = "y" ]; then
            echo "Using settings from $fobosconf";
            source $fobosconf
            # We still test every single time just in case a parameter was
            # added which is not in the old fobosconf. This is important
            # when upgrading an installation.
            # If this version is not set than it was a release prior to 3.0
            if [ -z $version ]; then
                version="2.0"
            fi
            installedversion=$version
            echo "Found version $installedversion of FOBOS"
        fi
    fi
fi

# Determining installed version and whether we update or clean install
# and if a previous run was successful
# if localversion is not set, then this install script was not
# run successfully before (ie. this also might be the first time
# it ever ran
# if installedversion is set then there was no previous installation
if [ -z $installedversion ]; then
    state=install
else
  if [ $installedversion = "1.0" ] || [ $installedversion = "2.0" ]; then
      state=update
  else
    if [ $installedversion = "3.0" ]; then
      state=reupdate
    else
      echo "Downgrading is not supported!"
      exit 1;
    fi
  fi
fi
version=$currentversion

# --- show info about intallation ----
if [ $state = "install" ]; then
    echo ""
    echo "New Installation"
    echo "----------------"
    echo "This script will ask you several questions about your Pynq 
board setup and install the FOBOS accordingly. Default values 
are shown in square brackets [default value].
  "
fi

# --- show info about update ----
if [ $state = "update" ]; then
    echo ""
    echo "Updating $installedversion to $currentversion"
    echo "------------------------------------------------------------"
    echo "Please make a full backup of your current installation of"
    echo "FOBOS. Installing an update might erase all your modified"
    echo "files and overwrite your current configuration. Please refer"
    echo "to the file BACKUP for information about how to perform a"
    echo "full backup."
    echo ""
    echo -n "Have you completed a full backup? (y/n)"; read backup
    if [ -z $backup ] || [ $backup != "y" ]; then
        echo "Please perform a backup now."
        exit 1;
    fi
    echo ""
fi

if [ $state = "reupdate" ]; then
    echo ""
    echo "Reinstalling update to $currentversion"
    echo "------------------------------------------------------------"
    echo ""
fi

echo "PART 1: Getting Configuration Information"

#--- IP address
#    someday allow user to select from list
if [ -z $ipaddress ]; then
    ipaddressdefault=192.168.2.99
    ipaddresstest=`ifconfig | grep $ipaddressdefault | wc -l | sed 's/ *//'`
    if [ $ipaddresstest = 0 ]; then 
        ipaddressdefault=""
    fi
    echo ""
    echo "FOBOS needs to know the IP address of your Pynq board that you 
will be using."
    knownaddr=`ifconfig | grep "inet " | sed 's/inet //' | sed 's/  netmas.*//'`
    echo "Your Pynq board knows the following addresses:"
    echo "${knownaddr[0]}"
    echo "Please enter one of these: [$ipaddressdefault]"; read ipaddress
    if [ -z $ipaddress ]; then
        ipaddress=$ipaddressdefault
    fi
    if [ -z $ipaddress ]; then
        echo "ERROR: You did not specify any IP address."
	exit 1;
    fi
    ipaddresstest=`ifconfig | grep $ipaddress | wc -l | sed 's/ *//'`
    if [ $ipaddresstest = 0 ]; then 
        echo "ERROR: IP address $ipaddress does not exist on this system."
	exit 1;
    fi
fi

#--- Port Number
#    someday check if port is free, OK if used by pynqserver
if [ -z $portnumber ]; then
    portnumberdefault="9995"
    echo ""
    echo "Which port number should the pynqserver of FOBOS use?"
    echo "Port: [$portnumberdefault]"; read portnumber
    if [ -z $portnumber ]; then
        portnumber=$portnumberdefault
   fi
fi

#--- Pynq Overlay File
if [ -z $overlay ]; then
    overlay=$foboshome"/software/pynq_ctrl.bit"
fi

# Done collecting all the data

# Writing all settings to a local file so that if the installation
# breaks, at least the user does not have to enter everything
# again.
outfile=fobos_pynq.conf
writeconfig


echo ""
echo "PART 2: Copying all files"

currentdir=`pwd`
if [ $currentdir = $foboshome"/software" ]; then
    echo "You are running this installation script from within an 
existing FOBOS installation. Files will not be copied!"
else
    echo "Creating directory $foboshome/software"
    
    #echo ""
    #--- Creating installation directory
    # checks for directories in the path and creates them too if necessary
    myfoboshome=`echo $foboshome"/software" | sed 's/\//:/g'`;
    #echo $myfoboshome
    # myifs=$IFS
    IFS=:
    for dir in $myfoboshome
    do
       mydir=$mydir"/"$dir;
       # echo $mydir
       if [ -f $mydir ]; then
           echo "$mydir is a file. Please enter a different home directory.";
           foboshome=""
           # write config again without the directory so user gets prompted
           # on next run
           outfile=fobos_pynq.conf
           writeconfig
           exit 1;
       fi
       if [ ! -d $mydir ]; then
           echo "     Creating directory $mydir";
           `mkdir $mydir`
           `chown xilinx:xilinx $mydir`
           `chmod 775 $mydir`
       fi
    done
    IFS=$myifs

    #--- Copying all files
    echo "Copyting all files to $foboshome/software"
    `cp -a . $foboshome/software `
    `chown -R xilinx:xilinx $foboshome`

fi

echo ""
echo "PART 3: Creating Links"
#--- Linking pynq-notebooks to jupyter
jupyternotebooks=/home/xilinx/jupyter_notebooks/fobos
echo "Linking pynq-notebooks to $jupyternotebooks"

# remove if it exists as a link
if [ -L $jupyternotebooks ]; then
   `rm $jupyternotebooks` 
fi

# if its a file or directroy raise an error
if [ -f $jupyternotebooks ] || [ -d $jupyternotebooks ]; then
    echo "$jupyternotebooks exists but its not a link. Please remove."
    exit 1;
fi

# now it should be save to create the link
`ln -s $foboshome/software/pynq-notebooks $jupyternotebooks`

#--- Linking fobos lib
foboslib=$jupyternotebooks/foboslib
echo "Linking FOBOS library to $foboslib"

# remove if it exists as a link
if [ -L $foboslib ]; then
   `rm $foboslib` 
fi

# if its a file or directroy raise an error
if [ -f $foboslib ] || [ -d $foboslib ]; then
    echo "$foboslibexists but its not a link. Please remove."
    exit 1;
fi

# now it should be save to create the link
`ln -s $foboshome/software/foboslib $foboslib`

# write configuration to fobos home in case files were not copied
outfile=$foboshome/software/fobos_pynq.conf
writeconfig
# generate python config and write to fobos home
outfile=$foboshome/software/pynq_conf.py
writepythonconfig

echo ""
echo "PART 4: System modifications for FOBOS' pynqserver"

#--- add sudoers file
echo "Adding python3 executable as no sudo password needed for user xilinx"
sudofile=/etc/sudoers.d/pynqserver
if [ -f $sudofile ]; then
    rm $sudofile
fi

echo "xilinx  ALL=(ALL) NOPASSWD:/usr/local/share/pynq-venv/bin/python3" > $sudofile

#--- add cronjob
echo "Adding cron job to start the pynqserver watchdog every 5 minutes"?
cronfile=/etc/cron.d/pynqserver
if [ -f $cronfile ]; then
    rm $cronfile
fi

echo "*/5  *    * * *   xilinx   cd $foboshome/software/ && sudo python3 $foboshome/software/serverWatchdog.py >>/tmp/fobos.log 2>&1" > $cronfile

echo ""
echo "Installation has ccompleted. 
The pynqserver should start in 5 minutes and then you can connect
to it from your jupyterlab script on your PC."

