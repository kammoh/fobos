#! /bin/bash
cd /home/xilinx

# link notebooks
cd jupyter_notebooks/
ln -s ../fobos/software/pynq-notebooks fobos
# link foboslib
cd fobos
#if exists
rm foboslib
ln -s ../../software/foboslib .
# add entry to /etc/crontab
#*/5  *    * * *   xilinx   cd /home/xilinx/fobos/software/ && sudo python3 /home/xilinx/fobos/software/serverWatchdog.py >>/tmp/fobos.log 2>&1
 
