#!/usr/bin/python
#!/usr/bin/python
import os
import sys
import numpy
import cfg
import matplotlib.pyplot as plt

def plotData(dataToPlot):
	plt.hold(False)
	dataToPlot = numpy.transpose(dataToPlot)
	plt.clf()
	plt.plot(dataToPlot)
	plt.ylabel('volts')
	plt.xlabel('time')
	plt.title('Processed Data')
	sys.stdout.write("->\tSaving %s fig file\n" % cfg.SNAPSHOT_FILE_NAME)
	plt.savefig(cfg.SNAPSHOT_FILE_NAME,dpi=72)
	plt.show()