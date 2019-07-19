import os
import numpy as np
import fobos.traceset as traceset
import fobos.cpa as cpa
import fobos.postprocess as postprocess
import fobos.projmgr as projmgr
import fobos.powermodels.AESFirstLast as powermodel

def main():
    #Configure project directories###############################################
    WORKSPACE = "/home/aabdulga/fobosworkspace/zybo_aes/capture/"
    PROJECT_NAME = "zybo_aes_basys3_1mhz_dut_625_cpu_clk"
    pm = projmgr.ProjectManager()
    pm.setWorkSpaceDir(WORKSPACE)
    pm.setProjName(PROJECT_NAME)
    projDir = pm.getProjDir()
    analysisDir = pm.getAnalysisDir()
    ######
    TRACES_FILE = os.path.join(projDir, 'powerTraces.npy')
    PLAIN_FILE = os.path.join(projDir, 'plaintext.txt')
    CIPHER_FILE = os.path.join(projDir, 'ciphertext.txt')
    HYPO_FILE = os.path.join(projDir, "hypotheticalPower.npy")

    CROP_START = 1500
    CROP_END = 3000
    
    NUM_TRACES = 100
    MTD_STRIDE = 1
    traceSet = traceset.TraceSet(traceNum = NUM_TRACES, 
                                fileName = TRACES_FILE,
                                cropStart = CROP_START, 
                                cropEnd = CROP_END)

    measuredPower = traceSet.traces
    compressedPower = postprocess.compressData(measuredPower, 'MEAN', 10)
    np.save(os.path.join(analysisDir, "compressedPower.npy"), compressedPower)
    #compressedPower = np.load(os.path.join(ANALYSIS_DIR, "compressedPower.npy"))
    print "Compression Done!"
    print compressedPower.shape
    hypotheticalPower = powermodel.getHypotheticalPower(PLAIN_FILE, CIPHER_FILE, NUM_TRACES)
    #hypotheticalPower = np.load(HYPO_FILE)
    
    C = cpa.doCPA(measuredPower = compressedPower, 
                         hypotheticalPower = hypotheticalPower,
                         numTraces = NUM_TRACES,
                         analysisDir =  analysisDir,
                         MTDStride = MTD_STRIDE
                        )

if __name__ == '__main__':
    main()