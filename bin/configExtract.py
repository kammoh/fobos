#!/usr/bin/python
import array
import time
import sys
import os
from support import *
from globals import *
from printFunctions import *

def configureWorkspace():
	runNo = 1
	tag = cfg.config_attributes['TAG']
	dateString = currentDateTime()
	cfg.WORKSPACEDIR = os.path.normpath(os.path.join(cfg.ROOTDIR,cfg.config_attributes['WORK_DIR']))
	createDirectory(cfg.WORKSPACEDIR)
	if(tag == 'date'):
		cfg.WORKSPACE = os.path.join(cfg.WORKSPACEDIR,dateString+'-'+cfg.config_attributes['PROJECT_NAME'])
	elif(tag == 'counter'):
		cfg.WORKSPACE = os.path.join(cfg.WORKSPACEDIR,str(runNo)+'-'+cfg.config_attributes['PROJECT_NAME'])
		while os.path.exists(cfg.WORKSPACE):
			runNo += 1
			cfg.WORKSPACE = os.path.join(cfg.WORKSPACEDIR,str(runNo)+'-'+cfg.config_attributes['PROJECT_NAME'])
			
	createDirectory(cfg.WORKSPACE)
	cfg.OUTPUT_FOLDER = os.path.join(cfg.WORKSPACE,OUTPUT_FOLDERNAME)
	cfg.MEASUREMENT_FOLDER = os.path.join(cfg.WORKSPACE,MEASUREMENT_FOLDERNAME)
	cfg.GRAPH_FOLDER = os.path.join(cfg.WORKSPACE,GRAPHS_FOLDERNAME)
	cfg.FOBOS_LOG_FILE = os.path.join(cfg.WORKSPACE,FOBOS_LOG_FILE_NAME)
	cfg.PLAIN_TEXT_FILE = os.path.join(cfg.OUTPUT_FOLDER,PLAIN_TEXT_FILE_NAME)
	cfg.CIPHER_TEXT_FILE = os.path.join(cfg.OUTPUT_FOLDER,CIPHER_TEXT_FILE_NAME)
	cfg.KEY_FILE = os.path.join(cfg.OUTPUT_FOLDER,KEY_FILE_NAME)
	cfg.config_attributes['DATA_FILE'] = os.path.join(cfg.ROOTDIR,cfg.config_attributes['SOURCE_DIR'],cfg.config_attributes['DATA_FILE'])	
	cfg.config_attributes['KEY_FILE'] = os.path.join(cfg.ROOTDIR,cfg.config_attributes['SOURCE_DIR'],cfg.config_attributes['KEY_FILE'])
	createDirectory(cfg.OUTPUT_FOLDER)
	createDirectory(cfg.MEASUREMENT_FOLDER)
	createDirectory(cfg.GRAPH_FOLDER)
 
def extractConfigAttributes():
	data_list = readFile(cfg.CONFIGFILE)
	data_list = removeComments(data_list)
	for object in data_list:
		if re.match('^WORK_DIR', object) :
			value = re.split("=", object)
			cfg.config_attributes['WORK_DIR'] = value[1].strip(" ")
		if re.match('^SOURCE_DIR', object) :
			value = re.split("=", object)
			cfg.config_attributes['SOURCE_DIR'] = value[1].strip(" ")
		if re.match('^VICTIM_RESET', object) :
			value = re.split("=", object)
			cfg.config_attributes['VICTIM_RESET'] = value[1].strip(" ")
		if re.match('^OSC_CONFIG_FILE', object) :
			value = re.split("=", object)
			cfg.config_attributes['OSC_CONFIG_FILE'] = value[1].strip(" ")
		if re.match('^DATA_FILE', object) :
			value = re.split("=", object)
			cfg.config_attributes['DATA_FILE'] = value[1].strip(" ")
		if re.match('^KEY_FILE', object) :
			value = re.split("=", object)
			cfg.config_attributes['KEY_FILE'] = value[1].strip(" ")
		if re.match('^INPUT_FORMAT', object) :
			value = re.split("=", object)
			cfg.config_attributes['INPUT_FORMAT'] = value[1].strip(" ")
		if re.match('^PROJECT_NAME', object) :
			value = re.split("=", object)
			cfg.config_attributes['PROJECT_NAME'] = value[1].strip(" ")
		if re.match('^VERBOSE', object) :
			value = re.split("=", object)
			cfg.config_attributes['VERBOSE'] = value[1].strip(" ")
		if re.match('^TRIGGER_VAL', object) :
			value = re.split("=", object)
			cfg.config_attributes['TRIGGER_VAL'] = value[1].strip(" ")
		if re.match('^OUTPUT_FORMAT', object) :
			value = re.split("=", object)
			cfg.config_attributes['OUTPUT_FORMAT'] = value[1].strip(" ")
		if re.match('^TAG', object) :
			value = re.split("=", object)
			cfg.config_attributes['TAG'] = value[1].strip(" ")
		if re.match('^TIMEOUT_VAL', object) :
			value = re.split("=", object)
			cfg.config_attributes['TIMEOUT_VAL'] = value[1].strip(" ")
		if re.match('^CLK_FREQ', object) :
			value = re.split("=", object)
			cfg.config_attributes['CLK_FREQ'] = value[1].strip(" ")
		if re.match('^MEASUREMENT_FORMAT', object) :
			value = re.split("=", object)
			cfg.config_attributes['MEASUREMENT_FORMAT'] = value[1].strip(" ")
		if re.match('^CONTROL_BOARD', object) :
			value = re.split("=", object)
			cfg.config_attributes['CONTROL_BOARD'] = value[1].strip(" ")
		if re.match('^NUMBER_OF_ENCRYPTIONS', object) :
			value = re.split("=", object)
			cfg.config_attributes['NUMBER_OF_ENCRYPTIONS'] = int(value[1].strip(" "))
		if re.match('^BLOCK_SIZE', object) :
			value = re.split("=", object)
			cfg.config_attributes['BLOCK_SIZE'] = int(value[1].strip(" "))	
		if re.match('^KEY_SIZE', object) :
			value = re.split("=", object)
			cfg.config_attributes['KEY_SIZE'] = int(value[1].strip(" "))				
		if re.match('^PLAINTEXT_GENERATION', object) :
			value = re.split("=", object)
			cfg.config_attributes['PLAINTEXT_GENERATION'] = value[1].strip(" ")
		if re.match('^KEY_GENERATION', object) :
			value = re.split("=", object)
			cfg.config_attributes['KEY_GENERATION'] = value[1].strip(" ")			