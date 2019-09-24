import os
import numpy as np
import fobos.traceset as traceset
import fobos.cpa as cpa
import fobos.postprocess as postprocess
import fobos.projmgr as projmgr
import fobos.powermodels.AESFirstLast as powermodel


def main():
    # Configure project directories################################
    WORKSPACE = "/home/aabdulga/fobosworkspace/aes_artix7_openadc/capture"
    PROJECT_NAME = "attempt_shunt_lna_50mhz_samp_1mhz_dut"
    pm = projmgr.ProjectManager()
    pm.setWorkSpaceDir(WORKSPACE)
    pm.setProjName(PROJECT_NAME)
    projDir = pm.getProjDir()
    analysisDir = pm.getAnalysisDir()
    ######
    TRACES_FILE = os.path.join(projDir, 'powerTraces.npy')
    PLAIN_FILE = os.path.join(projDir, 'pdi.txt')
    CIPHER_FILE = os.path.join(projDir, 'do.txt')
    HYPO_FILE = os.path.join(projDir, "hypotheticalPower.npy")

    CROP_START = 175
    CROP_END = 225

    NUM_TRACES = 20000
    MTD_STRIDE = 1000
    traceSet = traceset.TraceSet(traceNum=NUM_TRACES,
                                 fileName=TRACES_FILE,
                                 cropStart=CROP_START,
                                 cropEnd=CROP_END)

    measuredPower = traceSet.traces
    #compressedPower = postprocess.compressData(measuredPower, 'MEAN', 10)
    #np.save(os.path.join(analysisDir, "compressedPower.npy"), compressedPower)
    #compressedPower = np.load(os.path.join(ANALYSIS_DIR, "compressedPower.npy"))
    #print "Compression Done!"
    #print compressedPower.shape
    hypotheticalPower = powermodel.getHypotheticalPower(PLAIN_FILE,
                                                        CIPHER_FILE,
                                                        NUM_TRACES)
    # hypotheticalPower = np.load(HYPO_FILE)
    cpaAttacker = cpa.CPA()
    C = cpaAttacker.doCPA(measuredPower=measuredPower,
                          hypotheticalPower=hypotheticalPower,
                          numTraces=NUM_TRACES,
                          analysisDir=analysisDir,
                          MTDStride=MTD_STRIDE
                          )


if __name__ == '__main__':
    main()
