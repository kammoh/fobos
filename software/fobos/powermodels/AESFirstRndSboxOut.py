def AESSboxOutFirstRound(P):
    """
    calculates one byte of the AES sbox output in the first round
    parameters:
    P : a colomn vector of the plain text matrix (corresponds to the key byte
        to be guessed)
    returns:
    The output of the sbox in round 1
    """
    numKeyHypotheses = 256
    print(P)
    O = np.empty((P.shape[0], numKeyHypotheses))
    for k in range(numKeyHypotheses):
        for i in range(P.shape[0]):
            O[i,k] = sbox[k ^ P[i,0]]
    return O
#################################################################

def getSbox(p, k):
    return sbox[p]



##################################################################




#
def testAESPowerModel(P1, P2):
    #vectFirstRound = np.vectorize(firstRound)
    numPlainTexts = P1.shape[0]
    z = np.zeros((1, P1.shape[1]))
    tmp = np.vstack((z, P1))
    P1 = tmp[0:numPlainTexts,:]
    O = np.empty(P2.shape, dtype=np.uint8)
    for i in range(P2.shape[0]):
        for j in range(P2.shape[1]):
            O[i,j] = getByteHW(int(P1[i,j]) ^ int(P2[i,j]))
    return O


def AESPowerModelFirstRound():
    plaintext = loadTextMatrix('./example_data/plaintexts1.txt')
    #plaintext = loadTextMatrix('./plaintext1.txt', 3)
    print("plaintext=")
    printHexMatrix(plaintext[:,0:5])
    numPlainTexts = plaintext.shape[0]
    hypotheticalPower = []
    for byteNum in range(16):
        sbox_pt_key = vectAESSboxOutFirstRound(plaintext[:, byteNum].reshape(numPlainTexts,1))
        #res =  firstRound(plaintext[:,0], 0)
        print("sbox_pt_key=")
        printHexMatrix(sbox_pt_key[:,0:1])
        #####
        
        #####
        hypotheticalPower.append(sbox_pt_key)
        print("hypothetical power =")
        printHexMatrix(sbox_pt_key[:,0:1])

    return hypotheticalPower

def getPW(p1,p2):
    t = p1 ^ p2
    for i in range(len(t)):
        a = t[i]
        tmp[i] = (a&1) + ((a&2)>>1) + ((a&4)>>2) + ((a&8)>>3) \
                + ((a&16)>>4) + ((a&32)>>5) + ((a&64)>>6) + ((a&128)>>7)

def aesPowerHD(p1, p2):
    tmp = p1 ^ p2

def testFirstRound():
    ## Test genIntermediateMatrix
    D = np.random.randint(0, 10, size=(10,1))
    K = np.random.randint(0, 10, size=(1 ,5))
    cpa = CPA()

    hypotheticalPower = AESPowerModelFirstRound()
    measuredPower = read_raw_traces("./example_data/rawDataAligned.npy", 10000)
    print(measuredPower.shape)
    #print(hypotheticalPower.shape)
    croppedMeasuredPower = measuredPower[:,100:400]
    correctKey = []
    correctSample = []
    for byteNum in range(16):
        C =  correlation_pearson(croppedMeasuredPower, hypotheticalPower[byteNum][0:10000,:])  
        print("C=")
        print(C.shape)
        printHexMatrix(C, dtype='float')
        maxKeyIndex, maxCorr, maxCorrTime = findCorrectKey(C)
        corrFile = './analysis/correlation' + str(byteNum)
        mtdFile = './analysis/MTD' + str(byteNum)
        print("keyIndex= {}, max corr = {}, time= {}".format(hex(maxKeyIndex), maxCorr, maxCorrTime))
        plotCorr(C, maxKeyIndex, fileName= corrFile)
        plotMTDGraph(maxCorrTime, maxKeyIndex, croppedMeasuredPower, hypotheticalPower[byteNum], 
            stride=100, fileName=mtdFile, show='no')
        correctKey.append(format(maxKeyIndex, '02x'))
        correctSample.append(format(maxCorrTime, '02x'))
    print(correctKey)
    print(correctSample)
