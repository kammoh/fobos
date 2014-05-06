#!/usr/bin/python
import array
import time
import sys
import os
import cfg
import re

def clear_screen():
  os.system( [ 'clear', 'cls' ][ os.name == 'nt' ] )
 
def readFile(file_name) :
	#print "Reading File : %s" % file_name
	file_pt = open(file_name, "r")
	indata = file_pt.readlines()
	#print "Number of Lines read : %d" % len(indata)
	return (indata)

def removeComments(data_list) :
	#print "Removing Comments from the Data list"
	newdata_list = []
	for object in data_list:
		item = re.sub(r'#.*$', "", object)
		item = item.rstrip()
		item = item.rstrip('\n')
		if item :
			newdata_list.append(item)
	return(newdata_list)

def extractConfigAttributes():
	data_list = readFile(cfg.CONFIG_FILE)
	data_list = removeComments(data_list)
	for object in data_list:
		if re.match('^SAMPLE_WINDOW', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['SAMPLE_WINDOW'] = int(value[1].strip(" "))
		if re.match('^WINDOW_START_POINT', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['WINDOW_START_POINT'] = int(value[1].strip(" "))
		if re.match('^TRIGGER_THRESHOLD', object) :			
			value = re.split("=", object)
			cfg.analysisConfigAttributes['TRIGGER_THRESHOLD'] = float(value[1].strip(" "))			
		if re.match('^CAPTURE_MODE', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['CAPTURE_MODE'] = value[1].strip(" ")
		if re.match('^COMPRESSION_LENGTH', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPRESSION_LENGTH'] = int(value[1].strip(" "))
		if re.match('^COMPRESSION_TYPE', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPRESSION_TYPE'] = value[1].strip(" ")
		if re.match('^PROCESS_DATA', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['PROCESS_DATA'] = value[1].strip(" ")
		if re.match('^COMPRESS_DATA', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['COMPRESS_DATA'] = value[1].strip(" ")
		if re.match('^CORRELATION_PEARSONS', object) :
			value = re.split("=", object)
			cfg.analysisConfigAttributes['CORRELATION_PEARSONS'] = value[1].strip(" ")
		