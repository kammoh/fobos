#!/usr/bin/python
import math
import numpy
import argparse

#Author: William Diehl
#Date : Mar 2018

## legend for acorn8_hs_protected


cc_ctrl_state = [ '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '1A', '1B' ]
cc_ctrl_title = ['S_INIT', 'S_WAIT_START', 'S_WAIT_KEY', 'S_INIT_STATE', 'S_INIT_KEY1', 'S_INIT_KEY2', 'S_WAIT_NPUB1', 'S_WAIT_NPUB2', 'S_INIT_REST1', 'S_INIT_REST2', 'S_WAIT_MSG', 'S_PROC_AD1', 'S_PROC_AD2', 'S_PAD_AD_0_1', 'S_PAD_AD_0_2', 'S_PAD_AD1', 'S_PAD_AD2', 'S_PROC_PT', 'S_PROC_PT1_2', 'S_PROC_PT1_2', 'S_PAD_PT0_1', 'S_PAD_PT0_2', 'S_PAD_PT1_1', 'S_PAD_PT1_2', 'S_FINAL1', 'S_FINAL1a', 'S_FINAL2', 'S_WAIT_TAG_AUTH']

preprocessor_pdi_state = [ '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C']
preprocessor_pdi_title = [ 'S_RST', 'S_GET_PRND', 'S_WAIT_INSTR', 'S_INSTR_LAT_KEY', 'S_INSTR_LAT_HDR', 'S_WAIT_HDR', 'S_READ_HDR_0', 'S_READ_HDR_1', 'S_READ_HDR_2', 'S_PREP', 'S_WAIT_PRND', 'S_DATA', 'S_WAIT_READY']

preprocessor_sdi_state = [ '0', '1', '2', '3', '4', '5', '6', '7']
preprocessor_sdi_title = [ 'S_RST', 'S_GET_SRND', 'S_WAIT_INSTR', 'S_INSTR_LAT_HDR', 'S_WAIT_HDR', 'S_READ_HDR', 'S_WAIT_SRND', 'S_DATA']

postprocessor_state = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A']
postprocessor_title = ['S_WAIT_INSTR','S_WAIT_HDR','S_PREP','S_OUT_HDR0','S_OUT_HDR1','S_OUT_HDR2','S_OUT','S_GEN_TAG_HDR','S_GEN_STAT_HDR','S_WAIT_BDO','S_WAIT_BDO_CIPH']
   
def returnTitle(statestr, ctrllist, titlelist):
    #print statestr, ctrllist, titlelist
    
    for i in range (0, len(ctrllist)):
      if (ctrllist[i] == statestr):
	 return titlelist[i]
	 
# start

num_of_samples = 14920   
num_of_clks = 3497 

parser = argparse.ArgumentParser()
parser.add_argument("state_file", help="text file containing the state sequence computed in simulation", type=str)
parser.add_argument("t_array_file", help=".npy file that has traces stored as 1xN Nupmy array", type=str)
parser.add_argument("text_file", help="text file that will contain t values", type=str)
args = parser.parse_args()
state_file = args.state_file
t_array_file = args.t_array_file
text_file = args.text_file
writeFile = open(text_file,'w')

t_array = numpy.load(t_array_file)

num_of_samples = t_array.shape[0]
print "num_of_samples", num_of_samples

states = []
f1 = open(state_file, 'r')
states = f1.readlines()
f1.close()

# user must supply correct values
period = num_of_samples / float(num_of_clks) #clock period

for i in range (0,num_of_samples): 
   clk_cycle = int(i  / period)    
   ostr = str(i) + ' ' + str(clk_cycle) + ' ' 
   ostr = ostr + returnTitle(states[clk_cycle][0], postprocessor_state, postprocessor_title) + ' '
   ostr = ostr + returnTitle(states[clk_cycle][1], preprocessor_sdi_state, preprocessor_sdi_title) + ' '
   ostr = ostr + returnTitle(states[clk_cycle][2:4], preprocessor_pdi_state, preprocessor_pdi_title) + ' '
   ostr = ostr + returnTitle(states[clk_cycle][4:6], cc_ctrl_state, cc_ctrl_title) + ' '
   ostr = ostr + str(t_array[i]) + '\n'
   writeFile.write(ostr)

writeFile.close()
  
# end  