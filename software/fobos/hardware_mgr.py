import os
class HardwareManager():
    # class to allocate hardware o users
    LOCK_FILE_PATH = '/tmp/fobos.lock'
    
    def lock(self):
        if not self.isLocked():
            open(self.LOCK_FILE_PATH, 'a').close()
            return True
        return False

    def isLocked(self):
        return os.path.isfile(self.LOCK_FILE_PATH)
    
    def unlock(self):
        if self.isLocked():
            os.remove(self.LOCK_FILE_PATH)
