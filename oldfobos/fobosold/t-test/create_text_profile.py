#!/usr/bin/python
#This scripts takes raw power trace plots a graph
#It can also plot a clock signal on top of the power signal and number the clocks
#if there is a state file, it can print the state on the graph

#Author: William Diehl
#Date : Mar 2018

## legend for aes gcm


aes_ctrl_state = ['FF','00','01','02','03','04','05','06','07','08','09','0A','0B','0C','0D','0E','0F','10','11','12','13','FE']
aes_ctrl_title = ['IDLE','S_0','S_1','S_2','S_3','S_4','S_5','S_6','S_7','S_8','S_9','S_10','S_11','S_12','S_13','S_14','S_15','S_16','S_17','S_18','S_19','S_DONE']

mul_state = ['0','1','2']
mul_title = ['IDLE_ST','INIT_ST','RUN_ST']

cc_ctrl_state = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F', '10']
cc_ctrl_title = ['S_INIT','S_CHECK_KEY','S_LOAD_KEY','S_COMPUTE_H','S_LOAD_NPUB','S_WAIT_AUTH_DATA','S_WAIT_H','S_LOAD_AD','S_PROCESS_AD','S_LOAD_M','S_PROCESS_M','S_M_OUT','S_START_EK0','S_MULT_LEN','S_LOAD_EXP_TAG','S_FINISH','S_TAG_OUT']

preprocessor_ctrl_state = [ '00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '1A', '1B', '1C', '1D', '1E', '1F', '20' , '21']
preprocessor_ctrl_title = ['S_INIT','S_INT_MODE','S_INT_KEY','S_HDR_KEY','S_HDR_KEYLEN','S_HDR_RESKEY','S_HDR_KEYLEN_MSB','S_HDR_KEYLEN_LSB','S_LD_KEY','S_HDR_NPUB','S_HDR_NPUBLEN','S_HDR_RESNPUB','S_HDR_NPUBLEN_MSB','S_HDR_NPUBLEN_LSB','S_LD_NPUB','S_HDR_AD','S_HDR_ADLEN','S_HDR_RESAD','S_HDR_ADLEN_MSB','S_HDR_ADLEN_LSB','S_LD_AD','S_HDR_MSG','S_HDR_MSGLEN','S_HDR_RESMSG','S_HDR_MSGLEN_MSB','S_HDR_MSGLEN_LSB','S_LD_MSG','S_HDR_TAG','S_HDR_TAGLEN','S_HDR_RESTAG','S_HDR_TAGLEN_MSB','S_HDR_TAGLEN_LSB','S_LD_TAG','S_WAIT']

postprocessor_ctrl_state = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '0A', '0B', '0C', '0D', '0E', '0F', '10', '11']
postprocessor_ctrl_title = ['S_INIT','S_HDR_MSG','S_HDR_RESMSG','S_HDR_MSGLEN_MSB','S_HDR_MSGLEN_LSB','S_OUT_MSG','S_HDR_TAG','S_HDR_RESTAG','S_HDR_TAGLEN_MSB','S_HDR_TAGLEN_LSB','S_OUT_TAG','S_VER_TAG_IN','S_VER_TAG_EX','S_STATUS_FAIL','S_STATUS_SUCCESS','S_STATUS_MSB','S_STATUS_LSB','S_STATUS_ZERO']

fobos_do_ctrl_state =['0','1','2']
fobos_do_ctrl_title =['IDLE','READ_FIFO','DUMP']

fobos_sdi_ctrl_state =['0','1','2']
fobos_sdi_ctrl_title = ['IDLE','READ_FIFO','READ_FINISH']

fobos_pdi_ctrl_state =['0','1','2']
fobos_pdi_ctrl_title = ['IDLE','READ_FIFO','READ_FINISH']


def computeAvgPower(start, finish):
    accum = 0
    for i in range (start, finish):
        #print start, finish, i
	accum = accum + float(power_values[i][0:len(power_values[i])-1])
	
    accum = accum / (finish - start)
    return accum
    
def returnTitle(statestr, ctrllist, titlelist):
    #print statestr, ctrllist, titlelist
    
    for i in range (0, len(ctrllist)):
      if (ctrllist[i] == statestr):
	 return titlelist[i]
    

###########CLK GRAPH SETTINGS
num_of_clks = 2401   #num of clocks to in trace
state_file  = 'state_file.txt' #file_name | NONE #text file that includes states. One state in each line.
power_file  = 'power_text.txt' #text file containing average power at each sample
write_file  = 'power_profile.txt'
###END CLK GRAPH SETTINGS
 
num_of_samples = 16007
#########################################################################CLOCK SIGNAL PLOTTING

states = []
f1 = open(state_file, 'r')
states = f1.readlines()
f1.close()

power_values = []
f2 = open(power_file, 'r')
power_values = f2.readlines()
f2.close()

f3 = open(write_file,'w')

period = num_of_samples / float(num_of_clks) #clock period

for i in range (0,num_of_clks): 
   #compute average power per clock cycle
   if (i == 0): # first sample
       avg_power = computeAvgPower(0, int(period/2))
   else:
      if (i == (num_of_clks - 1)): # last sample
         avg_power = computeAvgPower(int(i*period - period/2),int(i*period))
      else:  
         avg_power = computeAvgPower(int(i*period - period/2),int(i*period + period/2))

   #ostr = str(i) + ' ' + states[i][0:len(states[i])-1] + ' ' + str(avg_power * 1000) + '\n'
   ostr = str(i) +  ' ' + returnTitle(states[i][0], fobos_pdi_ctrl_state, fobos_pdi_ctrl_title) + ' '
   ostr = ostr + returnTitle(states[i][1], fobos_sdi_ctrl_state, fobos_sdi_ctrl_title) + ' '
   ostr = ostr + returnTitle(states[i][2], fobos_do_ctrl_state, fobos_do_ctrl_title) + ' '
   ostr = ostr + returnTitle(states[i][3:5], postprocessor_ctrl_state, postprocessor_ctrl_title) + ' '
   ostr = ostr + returnTitle(states[i][5:7], preprocessor_ctrl_state, preprocessor_ctrl_title) + ' '
   ostr = ostr + returnTitle(states[i][7:9], cc_ctrl_state, cc_ctrl_title) + ' '
   ostr = ostr + returnTitle(states[i][9:10], mul_state, mul_title) + ' '
   ostr = ostr + returnTitle(states[i][10:12], aes_ctrl_state, aes_ctrl_title) + ' ' + str(avg_power * 1000) + '\n'
   f3.write(ostr)

f3.close()


