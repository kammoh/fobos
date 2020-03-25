import os
import signal
import time
import subprocess

class FobosWatchdog:
    """
    A class to make sure the the server is alive
    """

    def __init__(self):
        self.statusFile = "/tmp/fobos_status.txt"
        self.serverBin = "/home/xilinx/jupyter_notebooks/pynq_fobos/python3/pynqserver.py"
        self.timeout = 10
    
    def checkTimeout(self):
        try:
            stat = os.stat(self.statusFile)
            modifyTime = stat.st_mtime
            currentTime = time.time()
            delta = currentTime - modifyTime
            if delta > self.timeout:
                print(f'Status file not updated for {delta} seconds. Timeout exceeded.')
                return True
            else:
                return False
        except:
            return True
    
    def removeStatusFile(self):
        try:
            print('removing status file.')
            os.remove(self.statusFile)
        except:
            print('could not remove status file')

    def getServerPid(self):
        """
        ps -ef | grep pynqserver | grep -v sudo | grep python | tr -s ' ' | cut -f2 -d ' '
        """
        pids = subprocess.check_output(['pgrep', '-f', 'pynqserver'])
        pids = pids.decode().split('\n')[:-1]
        print(f'pid={pids}')
        return pids

    def restartServer(self):
        cmd = self.serverBin
        # os.spawnl(os.P_NOWAIT, cmd)
        pid = subprocess.Popen(['sudo', 'python3', self.serverBin]).pid
        print(f'Ran server pid = {pid}')

    def killServer(self, pids):
        for pid in pids:
            try:
                # os.kill(pid, signal.SIGINT)
                print(pid)
                subprocess.call(['sudo', 'kill', pid])
            except:
                print('Could not kill server')
def main():
    dog = FobosWatchdog()
    # dog.getServerPid()
    timedout = dog.checkTimeout()
    if timedout:
        print('restarting FOBOS')
        pids = dog.getServerPid()
        dog.killServer(pids)
        dog.removeStatusFile()
        dog.restartServer()
    else:
        print('Timeout not exceeded. Nothing to do. Exiting')
    
if __name__ == '__main__':
    main()



