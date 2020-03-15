Jupyterhub instructions

1- Install conda. Download the Anaconda installer for Linux from ansconda.com/distributions and run the installer
bash Anaconda3-2019.10-Linux-x86_64.sh 
2- Make sure that conda is in the PATH (i.e. conda can be run directly from the command line)
3- Run 
conda install -c conda-forge jupyterhub
conda install notebook #only if noteboos servers need to be run locally


4- Check the installation 
jupyterhub -h
configurable-http-proxy -h

You should see the help of both commands if this successful

5- To be able to use Jupyterhub in multiuser mode, it need to run as a priviliged user

sudo jupyterhub
1
5- On your browser, visit http://127.0.0.1:8000

Adding users:

1- Add an admin user

jupyterhub --generate-config

When jupyterhub starts, it looks for a config file in the current directory.
A config file will be generated in the current directory. This file includes commented-out example configuration.
To add an admin user, add the following line to the configuration:

c.Authenticator.admin_users = {'user_name'}

replace the user_name with you linux user name

Now you can add new users from the the browser.



