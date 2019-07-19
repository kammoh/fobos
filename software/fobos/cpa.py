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
import os
import numpy as np
import scipy.stats.stats as statModule
import postprocess
import traceset

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
#######################Testing
def exampleMappingFunction1(x, y):
    return x + y



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

####################################################################

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
    plt.margins(0)
    for i in range(C.shape[0]):
        row = C[i,:]
        plt.plot(row, '#aaaaaa', linewidth = 0.5)
    plt.plot(C[correctIndex, :], 'k', linewidth = 0.5)
    
    plt.xlabel("Sample No.")
    plt.ylabel("Correlation (Pearson's r)")
    if fileName != None:
        plt.savefig(fileName)
    if show == 'yes':
        plt.show()

def  findCorrectKey(C):
    C = np.abs(C)
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
    plt.margins(0)
    for i in range(dataToPlot.shape[0]):
        row = dataToPlot[i,:]
        plt.plot(row, '#aaaaaa', linewidth = 0.5)
    plt.plot(dataToPlot[correctKeyIndex, :], 'k', linewidth = 0.5)
    if stride != 1:
        plt.xlabel("Trace No. ({} traces)".format(stride))
    else:
        plt.xlabel("Trace No.")
    plt.ylabel("Correlation (Pearson's r)")
    if fileName != None:
        plt.savefig(fileName)
    if show == 'yes':
        plt.show()

def plotMTDGraph2(correctTime, correctKeyIndex, measuredPower, 
                hypotheticalPower, numTraces=None, stride=1,
                fileName= None, show='no'):
    if numTraces == None:
        numTraces = measuredPower.shape[0]
    numKeys = hypotheticalPower.shape[1]
    corrData = np.zeros((numKeys,numTraces/ stride))
    interestingPower = measuredPower[:,correctTime].reshape(measuredPower.shape[0],1)
    index = 0
    for i in range(0,numTraces, stride):
        if i % 100 == 0:
            print("MDT step={}".format(i))
        C = correlation_pearson(interestingPower[0:i,:], hypotheticalPower[0:i,:])
        #print(C.shape)
        corrData[:,index] = C.reshape(numKeys)
        index +=1
    ##get only highest and lowest values
    print (corrData.shape)
    print(corrData)
    
    import matplotlib.pyplot as plt
    plt.clf()
    plt.margins(0)
    #plot this first
    plt.plot(corrData[correctKeyIndex, :], 'k', linewidth = 0.5)
    #remove the correct key
    corrData[correctKeyIndex, :] = 0 #zero all elements in row so they are
                                     #min nor max
    # for i in range(dataToPlot.shape[0]):
    #     row = dataToPlot[i,:]
    #     plt.plot(row, '#aaaaaa', linewidth = 0.5)
    highVals = np.nanmax(corrData, axis =0)
    lowVals  = np.nanmin(corrData, axis =0)
    print(highVals.shape)
    print(highVals)
    plt.plot(highVals, 'b', linewidth = 0.5)
    plt.plot(lowVals, 'b', linewidth = 0.5)
    
    if stride != 1:
        plt.xlabel("Trace No. ({} traces)".format(stride))
    else:
        plt.xlabel("Trace No.")
    plt.ylabel("Correlation (Pearson's r)")
    if fileName != None:
        plt.savefig(fileName)
    if show == 'yes':
        plt.show()

def doCPA(measuredPower, hypotheticalPower, numTraces,
                 analysisDir, MTDStride):
    print(measuredPower.shape)
    correctKey = []
    for byteNum in range(16):
        C =  correlation_pearson(measuredPower[0:numTraces,:], hypotheticalPower[byteNum][0:numTraces,:])
        
        #C =  correlationPearsonOnlineVect(croppedMeasuredPower[0:1000,:], hypotheticalPower[byteNum][0:1000,:])
        print("C=")
        print(C.shape)
        printHexMatrix(C, dtype='float')
        maxKeyIndex, maxCorr, maxCorrTime = findCorrectKey(C)
        corrFile = os.path.join(analysisDir, 'correlation' + str(byteNum))
        mtdFile = os.path.join(analysisDir, 'MTD' + str(byteNum))
        print("keyIndex= {}, max corr = {}, time= {}".format(hex(maxKeyIndex), maxCorr, maxCorrTime))
        plotCorr(C, maxKeyIndex, fileName= corrFile)
        plotMTDGraph(maxCorrTime, maxKeyIndex, measuredPower, hypotheticalPower[byteNum], 
            stride=MTDStride, fileName=mtdFile, show='no')
        correctKey.append(format(maxKeyIndex, '02x'))
    print(correctKey)
    return C


def correlationPearsonOnlineVect(t,h):
    D = t.shape[0]
    T = t.shape[1]
    K = h.shape[1]
    r = np.zeros((K, T))
    ##intermediate sums
    print("K={}, T={}".format(K,T))
    sht = np.zeros((K,T))
    sh  = np.zeros(K)
    st  = np.zeros(T)
    sh2 = np.zeros(K)
    st2 = np.zeros(T)
    ##update arrays
    for i in range(K):
        for j in range(T):
            sht[i,j] = np.dot(h[:,i], t[:,j])
    sh  = np.sum(h, axis=0)
    st  = np.sum(t, axis=0)
    sh2 = np.sum(h**2, axis=0)
    st2 = np.sum(t**2, axis=0)
    print(sht)
    print(sh)
    print(st)
    print(sh2)
    print(st2)
    num = D * sht - np.outer(sh, st)
    tmp = np.outer(sh ** 2 - D * sh2, st ** 2 - D * st2 )
    print(tmp)
    den = np.sqrt(tmp)
    r = num / den
    return r

def correlationPearsonOnline(t, h):
    D = t.shape[0]
    T = t.shape[1]
    K = h.shape[1]
    r = np.zeros((K, T))
    for i in range(K):
        for j in range(T):
            ##calc sht
            sht = 0
            sh = 0
            st = 0
            ##calc sh^ and st^2
            sh2 = 0
            st2 = 0
            for d in range(D):
                sht += h[d,i] * t[d,j]
                ##calc sh and st
                sh += h[d,i]
                st += t[d,j]
                sh2 += h[d,i]**2
                st2 += t[d,j]**2
            ##calc r[i,j]
            num = D * sht - sh * st
            den = np.sqrt((sh**2 - D * sh2)*(st**2  - D * st2))
            r[i,j] = num/den
    return r

def main():
    BASE_DIR = "/home/aabdulga/fobosworkspace/zybo_aes/capture/zybo_aes_basys3_1mhz_dut_625_cpu_clk"
    TRACES_FILE = os.path.join(BASE_DIR, 'powerTraces.npy')
    PLAIN_FILE = os.path.join(BASE_DIR, 'plaintext.txt')
    CIPHER_FILE = os.path.join(BASE_DIR, 'ciphertext.txt')
    ANALYSIS_DIR = os.path.join(BASE_DIR, 'analysis')
    HYPO_FILE = os.path.join(BASE_DIR, "hypotheticalPower.npy")


    #CROP_START = 350 worked for 2000 traces
    #CROP_END = 450
    CROP_START = 1500
    CROP_END = 3000
    
    NUM_TRACES = 1000
    MTD_STRIDE = 10
    traceSet = traceset.TraceSet(traceNum = NUM_TRACES, 
                                fileName = TRACES_FILE,
                                cropStart = CROP_START, 
                                cropEnd = CROP_END)

    measuredPower = traceSet.traces
    compressedPower = postprocess.compressData(measuredPower, 'MEAN', 10)
    np.save(os.path.join(ANALYSIS_DIR, "compressedPower.npy"), compressedPower)
    #compressedPower = np.load(os.path.join(ANALYSIS_DIR, "compressedPower.npy"))
    print "Compression Done!"
    print compressedPower.shape
    
    hypotheticalPower = np.load(HYPO_FILE)
    
    C = doCPA(measuredPower = compressedPower, 
                         hypotheticalPower = hypotheticalPower,
                         numTraces = NUM_TRACES,
                         analysisDir =  ANALYSIS_DIR,
                         MTDStride = MTD_STRIDE
                        )

    np.savetxt("C.txt", C)

if __name__ == '__main__':
    main()
