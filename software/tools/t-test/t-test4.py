import numpy as np
import argparse
import matplotlib.pyplot as plt
from console_progressbar import ProgressBar

def calcTValue(traces0, traces1):
    mean0 = np.mean(traces0, axis=0)
    mean1 = np.mean(traces1, axis=0)
    var0 = np.var(traces0, axis=0)
    var1 = np.var(traces1, axis=0)
    numTraces = traces0.shape[0]
    
    return np.divide((mean0 - mean1), np.sqrt(((var0/numTraces) + (var1/(numTraces)))))

def doTtest(traceFile0, traceFile1, numTraces, step):
    pb = ProgressBar(total=100,prefix='Progress:', suffix='', decimals=2, length=50, fill='=', zfill='.')
    traces0 = np.load(traceFile0, mmap_mode='r')
    traces1 = np.load(traceFile1, mmap_mode='r')

    samplesPerTrace = traces0.shape[1]
    if numTraces == 'All':
        numTraces = min(traces0.shape[0], traces1.shape[0])
    else:
        numTraces = int(numTraces)
    if step == 'auto':
        step = calculateStep(numTraces, samplesPerTrace)
    else:
        step = int(step)
    print("numTraces = {}, samplesPerTrace = {}, step = {}".format(numTraces, samplesPerTrace, step))
    done =False
    start = 0
    t = np.array([])
    i = 0
    pb.print_progress_bar(0)
    while not done:
        end = start + step
        if end > samplesPerTrace:
            end = samplesPerTrace
            done = True
        # print('i={}, start= {}, end = {}'.format(i, start, end))
        chunk0 = traces0[0:numTraces,start:end]
        chunk1 = traces1[0:numTraces,start:end]
        t = np.append(t,calcTValue(chunk0, chunk1))
        pb.print_progress_bar(float(i * step) / samplesPerTrace * 100)
        #print(t)
        start = end
        i += 1
    pb.print_progress_bar(100)
    return t

def plotTValues(t, startXlim, endXlim, startYlim, endYlim, plotFile):
    #%matplotlib inline
    if endXlim == 'All':
        endXlim  = t.shape[0]
        print('endXlim={}'.format(endXlim))
    threshold = [4.5] * (int(endXlim) - int(startXlim))
    minusThreshold = [-4.5] * (int(endXlim) - int(startXlim))
    plt.plot(threshold, color='b')
    plt.plot(minusThreshold, color='b')

    plt.ylim(int(startYlim), int(endYlim))
    plt.xlim(int(startXlim), int(endXlim))
    plt.xlabel("Sample No.")
    plt.ylabel("t-value")
    plt.plot(t, color='r')
    
    plt.plot(t)
    #plt.show()
    plt.savefig(plotFile)

def calculateStep(numTraces, samplesPerTrace):
    step = int(samplesPerTrace / 50)
    if step < 10:
        step = 10
    return step

def main():
    startYlim = -10
    endYlim = 10
    numTraces = None
    step = 1000
    #tracesFile0 = '/home/aabdulga/fobosworkspace/acorn_1bit_unprotected/capture/leakage-assessment/traces0.npy'
    #tracesFile1 = '/home/aabdulga/fobosworkspace/acorn_1bit_unprotected/capture/leakage-assessment/traces1.npy'
    #t = doTtest(tracesFile0, tracesFile1, numTraces, step)
    #print(t.shape)
    #plotTValues(t, 0, len(t), startYlim, endYlim)
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-traces0", dest='traces0', default="traces0.npy", help=".npy file that store traces as MxN Nupmy array. Default is 'traces0.npy'", type=str)
    parser.add_argument("-traces1", dest='traces1', default="traces1.npy", help=".npy file that store traces as MxN Nupmy array. Default is 'traces0.npy", type=str)
    parser.add_argument("-num_traces", dest='numTraces', default="All", help="Integer. Number of traces to use for t-value calculation. Default is to use all traces.", type=str)
    parser.add_argument("-xlim_start", dest='startXLim', default="0", help="start of plot xlim. Default is 0.", type=str)
    parser.add_argument("-xlim_end", dest='endXLim', default="All", help="end of plot xlim. Default is all samples", type=str)
    parser.add_argument("-ylim_start", dest='startYLim', default="-10", help="start of plot ylim. Default is -10.", type=str)
    parser.add_argument("-ylim_end", dest='endYLim', default="10", help="end of plot ylim. Default is 10. ", type=str)
    parser.add_argument("-plot_file", dest='plotFile', default='t-test-result.png', help="File name to store the output figure. Default is 't-test-result.png", type=str)
    parser.add_argument("-t_values_file", dest='tValuesFile', default='t-test-result.npy', help="File name to store the output t-values. Default is 't-test-result.npy", type=str)
    parser.add_argument("-step", dest='step', default= 'auto', help="The number of samples to load each time to calculate t-values. Default is 10000.", type=str)
    args = parser.parse_args()
    tracesFile0 = args.traces0
    tracesFile1 = args.traces1
    numTraces = args.numTraces
    startXLim = args.startXLim
    endXLim = args.endXLim
    startYLim = args.startYLim
    endYLim = args.endYLim
    plotFile = args.plotFile
    tValuesFile = args.tValuesFile
    step = args.step
    print("The following settings will be used to calculate the t-test:")
    print('traces0 = {}'.format(tracesFile0))   
    print('traces1 = {}'.format(tracesFile1))   
    print('num_traces = {}'.format(numTraces))   
    print('xlim_start = {}'.format(startXLim))   
    print('xlim_end = {}'.format(endXLim))   
    print('ylim_start = {}'.format(startYLim))   
    print('ylim_end = {}'.format(endYLim))   
    print('plot_file = {}'.format(plotFile))
    print('t_values_file = {}'.format(tValuesFile))
    print('step = {}'.format(step))
    print('\nCalculating t-values ...')
    t = doTtest(tracesFile0, tracesFile1, numTraces, step)
    np.save(tValuesFile, t)
    plotTValues(t, startXLim, endXLim, startYLim, endYLim, plotFile)

if __name__ == '__main__':
    main()
