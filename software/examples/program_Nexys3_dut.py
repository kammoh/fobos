import os
import fobos
#Constants################################################################################################
WORKSPACE = "/home/aabdulga/fobosworkspace"
PROJECT_NAME ="ntt"
DUT_BIT_FILE = "FOBOS_DUT.bit"

#Configure project directories################################################################################
pm = fobos.ProjectManager()
pm.setWorkSpaceDir(WORKSPACE)
pm.setProjName(PROJECT_NAME)
projDir = pm.getProjDir()
#program DUT
dut = fobos.Nexys3DUT()
bitFile = os.path.join(projDir, DUT_BIT_FILE)
dut.setBitFile(bitFile)
dut.program()
#exit()
#