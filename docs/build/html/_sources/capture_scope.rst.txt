Data Acquisition - Collecting Traces
************************************

This section explains how to use PicoScope to collect traces. This is best explained by example.

PicoScope Setup
---------------

This example code uses the Picoscope 5000 series (5244D) oscilloscope. To setup the oscilloscope please
refer to the manufacturer website.
We expect that modifying the code to work with other series to be easy since the manufacturer provides an SDK.

Power Measurement
-----------------

The oscilloscope must be able to measure a voltage propotional to the power consumed by the device.
You can use a current probe (e.g Tektronix CT-1). As shown below, we modified the DUT board so that we
have jumper the power line (core FPGA voltage).
we then used a bench power supply to power the FPGA. Note that the power wire goes through the current probe.
The power probe senses the current variations in the power wire and coverts that to volatge for the oscilloscope.

TODO add figg

An alternative method is to inster a hunt resistor in the power line and then measure the volatge drop 
across the resistor.

TODO: add fig

Trace Collection Example
------------------------

.. code-block::
    :linenos:

    import numpy as np
    import fobos
    # Constants###########################################################
    SERIAL_PORT = '/dev/ttyUSB2'
    TRACE_NUM = 5
    OUT_LEN = 7
    # Instantiate FOBOS objects###########################################
    print("Sending configuration...")
    ctrl = fobos.Basys3Ctrl(SERIAL_PORT)
    ctrl.enableTestMode()
    ctrl.setOutLen(OUT_LEN)
    # open file to save traces.
    traceFile = open('powerTraces.npy', 'w')
    # configure oscilloscope
    scope = fobos.picoscope.Picoscope(sampleResolution = 8, # number of bits for each sample.
                        postTriggerSamples = 1000 # samples in one trace.
                        )
    scope.setChannel(channelName = 'CHANNEL_A', rangemv = '100mV')
    scope.setSamplingInterval(samplingIntervalns = 2) # T=2 ns, Sampling rate= 500MHz
    scope.setTrigger(channelName ='EXTERNAL', direction = 'RISING_EDGE', 
                    thresholdmv = 200)
    scope.setDataBuffers()

    # Run DUT operations
    testVectors = ['00c0000761996dc996d4ac00c100070f7821507a22a00081000700800001',
                '00c00007fd8771fe717de400c100073e1fe5b4aa357c0081000700800001',
                '00c0000782051f5484702200c10007980d05d4ea25bc0081000700800001',
                '00c0000767881b702afe5200c10007b08a5e036de72b0081000700800001',
                '00c0000726a1d601ccdf7a00c1000773539e52672d5d0081000700800001']

    print 'Sending data..'
    traceNum = 0
    while traceNum < TRACE_NUM:
        scope.arm() # arm scope. Now, it expects a trigger at any time.
        data = testVectors[traceNum]
        status, result = ctrl.processData(data, OUT_LEN)
        if status != fobos.OK:
            print "TIMEOUT"
        print(result)
        trace = scope.readTrace() # get trace from oscilloscope buffers.
        np.save(traceFile, trace) # save the trace in the trace file.
        traceNum += 1

This is very similar to the capture data example but with few more lines added to capture traces
from the oscilloscope.

Lines 15-22 configure the oscilloscope settings. We first intantiate a Picoscope object (line 15).
Lines  15 sets sampleResolution to 8 bit and number of samples to be collected to 1000 samples per trace.
Line 18 enables channel A and sets its range to 100 mV.
Line 19 sets the sampling interval (T) to 2 nano seconds. This implies that ampling rate is 1/T = 500 M Sample/s.
Line 20 configers the EXTERNAL (Ext) channel to be used for trigger on risinge edge with a threshold of 200 mV.
Line 22 allocates memory buffers to store oscilloscope data.

In the main loop, we use the arm() (line 34) function to tell the oscilloscope to be ready to get the trigger and store the 
data. Once the crypto operation is over, we can collect the trace from the memory as a numpy array using the
readTrace() method (line 40). The trace is saved into a file in line 41.
For more information about the PicoScope class see :class:`Picoscope`.

Visualizing Traces
------------------

TODO: prepare the viewPlots.py for realease.
You can use the plotTrace.py script to plot the traces form the file.
Otherwise you can use matplotlib to plot data as needed.
