#!/usr/bin/python
# -*- coding: utf-8 -*-

# This scripts takes raw power trace and calculates the t value for each traces sample wise

import numpy
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
import argparse
start_ylim = -40
end_ylim = 40

start_xlim = 0
end_xlim = 1000


def ttest(traces0, traces1, numTraces):
    from scipy import stats
    traces0 = traces0[0:numTraces, :]
    traces1 = traces1[0:numTraces, :]
    numSamples = traces0.shape[1]
    t = numpy.empty(numSamples)
    for i in range(numSamples):
        t[i] = stats.ttest_ind(traces0[:, i], traces1[:, i])[0]
    return t


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('trace_file0',
                        help='.npy file that store traces as MxN Nupmy array',
                        type=str)
    parser.add_argument('trace_file1',
                        help='.npy file that store traces as MxN Nupmy array',
                        type=str)
    parser.add_argument('plot_file',
                        help='File name to store the output figure',
                        type=str)
    args = parser.parse_args()
    trace_file0 = args.trace_file0
    trace_file1 = args.trace_file1
    plot_file = args.plot_file

    raw_traces0 = numpy.load(trace_file0)
    raw_traces1 = numpy.load(trace_file1)

    # num_of_traces = raw_traces0.shape[0]

    samples_per_trace = raw_traces0.shape[1]
    print 'samples_per_trace=', samples_per_trace
    t_array = ttest(raw_traces0, raw_traces1, 4956)
    threshold = [4.5] * samples_per_trace
    minus_threshold = [-4.5] * samples_per_trace
    plt.plot(threshold, color='b')
    plt.plot(minus_threshold, color='b')

    plt.ylim(start_ylim, end_ylim)
    plt.xlim(start_xlim, end_xlim)
    plt.xlabel('Sample No.')
    plt.ylabel('t-value')
    plt.plot(t_array, color='r')

    # plt.show()

    plt.savefig(plot_file)


if __name__ == '__main__':
    main()