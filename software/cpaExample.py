#############################################################################
#                                                                           #
#   Copyright 2019 CERG                                                     #
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
import os
import numpy as np
import fobos.traceset as traceset
import fobos.cpa as cpa
import fobos.postprocess as postprocess
import fobos.projmgr as projmgr
import fobos.powermodels.AESFirstLast as powermodel


def main():
    # Configure project directories################################
    WORKSPACE = "../workspace/aes_artix7_picoscope/capture"
    PROJECT_NAME = "aes_artix_pico_62MSps"
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

    CROP_START = 218
    CROP_END = 282

    NUM_TRACES = 220000
    MTD_STRIDE = 10000
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
