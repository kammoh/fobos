"""
All tasks related to CPA. These include
1- Generating the intermediate value matrix V given the function that calculates it
2- Applying the power model to V to obtain the matrix H with contains the 
hypothetical power adcording to a powermodel.
3- running correlation e.g pearson's r on the traces matrix T and hypothetical power
matrix H to obtain the correlation matrix R
4- Generate MTD graph
5- Visualize the Matrix R in various was.
6- Generate plots.
"""
import numpy as np
import scipy.stats.stats as statModule

class CPA():
    """
    All tasks related to CPA. These include
    1- Generating the intermediate value matrix V given the function that calculates it
    2- Applying the power model to V to obtain the matrix H with contains the 
    hypothetical power adcording to a powermodel.
    3- running correlation e.g pearson's r on the traces matrix T and hypothetical power
    matrix H to obtain the correlation matrix R
    4- Generate MTD graph
    5- Visualize the Matrix R in various was.
    6- Generate plots.
    """
    def __init__(self):
        pass
    
    def genIntermediateMatrix(self,D , K, fun):
        #TODO: test with np.vectorize
        """
        generates the intermediate matrix V 
        parameters:
        D : The first known data matrix (e.g. plaintext) of shape (numPlainTexts, 1)
        K : The secret (key) matrix                of shape (1, numKeyHypothses)
        fun: the function that maps an element from K and an element form D to an element in V
        returns:
        V: The intermediate matrix of shape (numKeyHypotheses, numPlainTexts)
        """
        numPlainTexts = D.shape[0]
        numKeyHypotheses = K.shape[1]
        V = np.empty([numPlainTexts, numKeyHypotheses])
        print(D.shape)
        print(K.shape)
        print(V.shape)
        for i in range(numPlainTexts):
            for j in range(numKeyHypotheses):
                #do the function
                V[i, j] = fun(D[i, 0], K[0, j])
        return V

    def applyFunctionElementwize(self, A, fun):
        """
        Applies a function for each elemet in A
        can be for example an sbox
        parameters:
        A : a numpy matrix 
        fun : a function to apply to each element
        returns:
        numpy matrix of the same shape as A
        """
        res = np.empty(A.shape)
        for i in rrange(A.shape[0]):
            for j in range(A.shape[1]):
                res[i,j] = fun(A[i,j])
        return res

#######################Testing
def exampleMappingFunction1(x, y):
    return x + y

sbox = [0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5, 0x30, 0x01, 0x67,
        0x2b, 0xfe, 0xd7, 0xab, 0x76, 0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59,
        0x47, 0xf0, 0xad, 0xd4, 0xa2, 0xaf, 0x9c, 0xa4, 0x72, 0xc0, 0xb7,
        0xfd, 0x93, 0x26, 0x36, 0x3f, 0xf7, 0xcc, 0x34, 0xa5, 0xe5, 0xf1,
        0x71, 0xd8, 0x31, 0x15, 0x04, 0xc7, 0x23, 0xc3, 0x18, 0x96, 0x05,
        0x9a, 0x07, 0x12, 0x80, 0xe2, 0xeb, 0x27, 0xb2, 0x75, 0x09, 0x83,
        0x2c, 0x1a, 0x1b, 0x6e, 0x5a, 0xa0, 0x52, 0x3b, 0xd6, 0xb3, 0x29,
        0xe3, 0x2f, 0x84, 0x53, 0xd1, 0x00, 0xed, 0x20, 0xfc, 0xb1, 0x5b,
        0x6a, 0xcb, 0xbe, 0x39, 0x4a, 0x4c, 0x58, 0xcf, 0xd0, 0xef, 0xaa,
        0xfb, 0x43, 0x4d, 0x33, 0x85, 0x45, 0xf9, 0x02, 0x7f, 0x50, 0x3c,
        0x9f, 0xa8, 0x51, 0xa3, 0x40, 0x8f, 0x92, 0x9d, 0x38, 0xf5, 0xbc,
        0xb6, 0xda, 0x21, 0x10, 0xff, 0xf3, 0xd2, 0xcd, 0x0c, 0x13, 0xec,
        0x5f, 0x97, 0x44, 0x17, 0xc4, 0xa7, 0x7e, 0x3d, 0x64, 0x5d, 0x19,
        0x73, 0x60, 0x81, 0x4f, 0xdc, 0x22, 0x2a, 0x90, 0x88, 0x46, 0xee,
        0xb8, 0x14, 0xde, 0x5e, 0x0b, 0xdb, 0xe0, 0x32, 0x3a, 0x0a, 0x49,
        0x06, 0x24, 0x5c, 0xc2, 0xd3, 0xac, 0x62, 0x91, 0x95, 0xe4, 0x79,
        0xe7, 0xc8, 0x37, 0x6d, 0x8d, 0xd5, 0x4e, 0xa9, 0x6c, 0x56, 0xf4,
        0xea, 0x65, 0x7a, 0xae, 0x08, 0xba, 0x78, 0x25, 0x2e, 0x1c, 0xa6,
        0xb4, 0xc6, 0xe8, 0xdd, 0x74, 0x1f, 0x4b, 0xbd, 0x8b, 0x8a, 0x70,
        0x3e, 0xb5, 0x66, 0x48, 0x03, 0xf6, 0x0e, 0x61, 0x35, 0x57, 0xb9,
        0x86, 0xc1, 0x1d, 0x9e, 0xe1, 0xf8, 0x98, 0x11, 0x69, 0xd9, 0x8e,
        0x94, 0x9b, 0x1e, 0x87, 0xe9, 0xce, 0x55, 0x28, 0xdf, 0x8c, 0xa1,
        0x89, 0x0d, 0xbf, 0xe6, 0x42, 0x68, 0x41, 0x99, 0x2d, 0x0f, 0xb0,
        0x54, 0xbb, 0x16]

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

def vectAESSboxOut(P):
    """
    calculates one byte of the AES sbox output 
    parameters:
    P : a colomn vector of the sbox input.
    returns:
    The output of the sbox in round 1
    """
    vectFirstRound = np.vectorize(getSbox)
    numKeyHypotheses = 256
    #print(P)
    numPlainTexts = P.shape[0]
    O = np.empty((numPlainTexts, numKeyHypotheses), dtype=np.uint8)
    for k in range(numKeyHypotheses):
        O[:,k] = vectFirstRound(P.reshape(numPlainTexts,), k)
    return O

##################################################################

def firstRound(p, k):
    return sbox[p ^ k]

def vectAESSboxOutFirstRound(P):
    """
    calculates one byte of the AES sbox output in the first round
    parameters:
    P : a colomn vector of the plain text matrix (corresponds to the key byte
        to be guessed)
    returns:
    The output of the sbox in round 1
    """
    vectFirstRound = np.vectorize(firstRound)
    numKeyHypotheses = 256
    #print(P)
    numPlainTexts = P.shape[0]
    O = np.empty((numPlainTexts, numKeyHypotheses), dtype=np.uint8)
    for k in range(numKeyHypotheses):
        O[:,k] = vectFirstRound(P.reshape(numPlainTexts,), k)
    return O
##################################################################
def printHexMatrix(A, printAll=False, dtype='int'):
    import sys
    lim = 10
    if (printAll == True or A.shape[0] < 10):
        lim = A.shape[0]
    for i in range(lim):
        for j in range(A.shape[1]):
            if dtype == 'float':
                sys.stdout.write(str(A[i,j]) + "\t")
            else:
                sys.stdout.write("0x" + format(int(A[i,j]), '02x') + "\t")
        sys.stdout.write("\n")

def loadTextMatrix(fileName, numCols = 16):
    """
    file format: hex values delimited by spaces
    MAKE sure that there is no space at the end of line
    """
    return np.loadtxt(fileName, dtype='uint8', delimiter=' ',
                 converters={_:lambda s: int(s, 16) for _ in range(numCols)})
##################################################################
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

def correlation_pearson(measuredData, modeledData):
    #measuredData = np.transpose(measuredData)
    corrMatrix = np.zeros(0)
    corrArray =  np.zeros(0)
    corrMatrix = np.empty((modeledData.shape[1], measuredData.shape[1]))
    for i in range( modeledData.shape[1]):
        colH = modeledData[:,i]
        for j in range(measuredData.shape[1]) :
            colM = measuredData[:,j]
            c, p = statModule.pearsonr(colH, colM)
            corrMatrix[i,j] = c
    return corrMatrix

def vectTestAESPowerModel(P1, P2):
    HW = np.array([0, 1, 1, 2, 1, 2, 2, 3, 1, 2, 2, 3, 2, 3, 3, 4, 1, 2, 2, 3, 

        2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 1, 2, 2, 3, 2, 3, 3, 4, 

        2, 3, 3, 4, 3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 

        4, 5, 5, 6, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 3, 4, 4, 5, 

        2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 2, 3, 3, 4, 

        3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 

        4, 5, 5, 6, 5, 6, 6, 7, 1, 2, 2, 3, 2, 3, 3, 4, 2, 3, 3, 4, 

        3, 4, 4, 5, 2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 

        2, 3, 3, 4, 3, 4, 4, 5, 3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 

        4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 2, 3, 3, 4, 3, 4, 4, 5, 

        3, 4, 4, 5, 4, 5, 5, 6, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 

        5, 6, 6, 7, 3, 4, 4, 5, 4, 5, 5, 6, 4, 5, 5, 6, 5, 6, 6, 7, 

        4, 5, 5, 6, 5, 6, 6, 7, 5, 6, 6, 7, 6, 7, 7, 8], dtype=np.uint8)

    vectGetByteHW = np.vectorize(getByteHW)
    numPlainTexts = P1.shape[0]
    z = np.zeros((1, P1.shape[1]), dtype=np.uint8)
    tmp = np.vstack((z, P1))
    P1 = tmp[0:numPlainTexts,:]
    O = np.empty(P2.shape, dtype=np.uint8)
    for k in range(P2.shape[1]):
        x= P1[:,k] ^ P2[:,k]
        O[:,k] = HW[P1[:,k] ^ P2[:,k]]
    return O
####################################################################
def getByteHW(a):
    return (a&1) + ((a&2)>>1) + ((a&4)>>2) + ((a&8)>>3) \
            + ((a&16)>>4) + ((a&32)>>5) + ((a&64)>>6) + ((a&128)>>7)

def getPW(p1,p2):
    t = p1 ^ p2
    for i in range(len(t)):
        a = t[i]
        tmp[i] = (a&1) + ((a&2)>>1) + ((a&4)>>2) + ((a&8)>>3) \
                + ((a&16)>>4) + ((a&32)>>5) + ((a&64)>>6) + ((a&128)>>7)

def aesPowerHD(p1, p2):
    tmp = p1 ^ p2

def testAESPowerModel1():
    plaintext = loadTextMatrix('./example_data/plaintexts1.txt')
    #plaintext = loadTextMatrix('./plaintext1.txt', 3)
    print("plaintext=")
    printHexMatrix(plaintext[:,0:5])
    numPlainTexts = plaintext.shape[0]

    ciphertext = loadTextMatrix('./example_data/ciphertexts1.txt')
    #plaintext = loadTextMatrix('./plaintext1.txt', 3)
    print("ciphertext=")
    printHexMatrix(ciphertext)
    hypotheticalPower = []
    for byteNum in range(16):
        sbox_pt_key = vectAESSboxOutFirstRound(plaintext[:, byteNum].reshape(numPlainTexts,1))
        #res =  firstRound(plaintext[:,0], 0)
        print("sbox_pt_key=")
        printHexMatrix(sbox_pt_key[:,0:1])
        #####
        sbox_ct = vectAESSboxOut(ciphertext[:, byteNum].reshape(numPlainTexts,1))
        #res =  firstRound(plaintext[:,0], 0)
        print("sbox_ct=")
        printHexMatrix(sbox_ct[:,0:1])
        #####
        oneBytePower = vectTestAESPowerModel(sbox_ct, sbox_pt_key)
        hypotheticalPower.append(oneBytePower)
        print("hypothetical power =")
        printHexMatrix(oneBytePower[:,0:1])

    return hypotheticalPower

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

def adjustSampleSize(sampleLength, dataArray):
        #print "\tAdjusting Sample Size to ->" + str(sampleLength)
        temp = dataArray.shape
        newDataArray = dataArray
        arrLen = temp[0]
        #print "Array Length --> " + str(arrLen)
        if (arrLen == sampleLength):
            
            return dataArray
            
        elif (arrLen > sampleLength):
            
            diff = arrLen-sampleLength
            for count in range(0,diff):
                newDataArray = np.delete(newDataArray, -1, 0)
            return newDataArray 
            
        elif (arrLen < sampleLength):
            
            diff = sampleLength-arrLen
            for count in range (0,diff):
                newDataArray = np.append(newDataArray,0)
            return newDataArray 
            
def detectSampleSize(file_name):
    """
    This function calcualates the number of sample per trace. This is needed to do any paddig/truncation to make all 
    traces the same size. We iterate through the first 10 traces and get the max number of traces
    """
    print "DEBUG: Module: analysis, Function: detectSampleSize():"
    print "----Detecting samples per trace"
    maxNumOfSamples = 0
    for traceCount in range (0,10):
        try:
            trace = np.load(file_name)
        except:
            print "----You have less than 10 samples. It looks that the max number of samples is : " + str(maxNumOfSamples)
            return maxNumOfSamples
        numOfSamples = len(trace)
        if maxNumOfSamples < numOfSamples:
            maxNumOfSamples = numOfSamples
    print "----It looks that the max number of samples in the first 10 traces is: " + str(maxNumOfSamples)
    return maxNumOfSamples
    
def read_raw_traces(file_name, num_of_traces):
    print "Loading raw traces from file: " + file_name  
    print "Please wait ..."
    measurementFile = open(file_name, 'r')
    #Get sample size to adjust all traces to the same number of samples. A better solution is to get the data cleaned up upon acquistion.
    global samples_per_trace
    samples_per_trace = detectSampleSize(measurementFile)
    ##create the array
    raw_traces = np.empty((num_of_traces, samples_per_trace))
    #samples_per_trace = 4000
    #need to reset file handle since we used it 
    measurementFile.seek(0)
    for traceCount in range (0,num_of_traces):
        #print "traceCount= " + str(traceCount)
        tempArrayMeasurement = np.load(measurementFile)
        tempArrayMeasurement = adjustSampleSize(samples_per_trace, tempArrayMeasurement)
        raw_traces[traceCount,:] = tempArrayMeasurement
    print "Loading done."
    return raw_traces
def plotCorr3D(C, fileName= None, show='no'):
    import matplotlib.pyplot as plt
    from mpl_toolkits.mplot3d import axes3d
    x = np.linspace(0, 100, 100)
    y = np.linspace(0, 256, 256)
    X, Y = np.meshgrid(x, y)
    Z = C
    ####
    fig = plt.figure()
    ax = plt.axes(projection='3d')
    #ax.contour3D(X, Y, Z, 50, cmap='binary')
    #ax.plot_wireframe(X, Y, Z, 50, cmap='binary')
    #ax.contour(X, Y, Z, 50)
    ax.plot_surface(X,Y,Z, rstride=1, cstride=1,
                cmap='Reds', edgecolor='none')


    ax.set_xlabel('x')
    ax.set_ylabel('y')
    ax.set_zlabel('z')
    if fileName != None:
        fig.savefig(fileName)
    if show == 'yes':
        plt.show()


def plotCorr(C, correctIndex,fileName= None, show='no'):
    import matplotlib.pyplot as plt
    plt.clf()
    for i in range(C.shape[0]):
        row = C[i,:]
        plt.plot(row, '#aaaaaa')
    plt.plot(C[correctIndex, :], 'k')
    if fileName != None:
        plt.savefig(fileName)
    if show == 'yes':
        plt.show()

def  findCorrectKey(C):
    maxCorrs = np.amax(C, 0)
    maxKeyIndexes = np.argmax(C, 0)
    maxKeyIndex = maxKeyIndexes[np.argmax(maxCorrs)]
    maxCorr = np.max(maxCorrs)
    maxCorrTime = np.argmax(maxCorrs)
    return maxKeyIndex, maxCorr, maxCorrTime

def plotMTDGraph(correctTime, correctKeyIndex, measuredPower, 
                hypotheticalPower, numTraces=None, stride=1,
                fileName= None, show='no'):
    if numTraces == None:
        numTraces = measuredPower.shape[0]
    numKeys = hypotheticalPower.shape[1]
    dataToPlot = np.empty((numKeys,numTraces/ stride))
    interestingPower = measuredPower[:,correctTime].reshape(measuredPower.shape[0],1)
    index = 0
    for i in range(0,numTraces, stride):
        if i % 100 == 0:
            print("MDT step={}".format(i))
        C = correlation_pearson(interestingPower[0:i,:], hypotheticalPower[0:i,:])
        #print(C.shape)
        dataToPlot[:,index] = C.reshape(numKeys)
        index +=1
    import matplotlib.pyplot as plt
    plt.clf()
    for i in range(dataToPlot.shape[0]):
        row = dataToPlot[i,:]
        plt.plot(row, '#aaaaaa')
    plt.plot(dataToPlot[correctKeyIndex, :], 'k')
    if fileName != None:
        plt.savefig(fileName)
    if show == 'yes':
        plt.show()

def testModel1():
    ## Test genIntermediateMatrix
    D = np.random.randint(0, 10, size=(10,1))
    K = np.random.randint(0, 10, size=(1 ,5))
    cpa = CPA()

    hypotheticalPower = testAESPowerModel1()
    measuredPower = read_raw_traces("./example_data/rawDataAligned.npy", 10000)
    print(measuredPower.shape)
    #print(hypotheticalPower.shape)
    croppedMeasuredPower = measuredPower[:,100:400]
    correctKey = []
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

    print(correctKey)

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

def main():
    #testFirstRound()
    testModel1()


    

if __name__ == '__main__':
    main()
