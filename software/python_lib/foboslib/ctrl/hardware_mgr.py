import os
import time
from contextlib import AbstractContextManager


class HardwareManager(AbstractContextManager):
    # class to allocate hardware to users
    LOCK_FILE_PATH = "/tmp/fobos.lock"
    TIMEOUT = 9 * 60  # timeout in seconds

    def __enter__(self):
        self.lock()
        return self

    def __exit__(self, _type, _value, _traceback):
        self.unlock()

    def lock(self):
        tic = time.time()
        while True:
            toc = time.time()
            if toc - tic > self.TIMEOUT:
                print(
                    "Hardware manager: timeout while waiting for control board. Please try again later."
                )
                return False
            self.unlock()
            if not self.isLocked():
                try:
                    print(f"opening {self.LOCK_FILE_PATH}")
                    open(self.LOCK_FILE_PATH, "w").close()
                except Exception as e:
                    print(e)
                    return False
                return True
            if int(toc - tic) % 20 == 0:
                print("Waiting for current user to release hardware. Please wait ...")
            time.sleep(1)

    def isLocked(self):
        #        return False # WORKAROUND for single user mode
        return os.path.isfile(self.LOCK_FILE_PATH)

    def unlock(self):
        if self.isLocked():
            try:
                os.remove(self.LOCK_FILE_PATH)
            except Exception as e:
                print(e)
            else:
                print("Released hardware lock.")
