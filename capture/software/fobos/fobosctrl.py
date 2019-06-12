##FOBOS control board class
##GMU
##Author: Abubakr Abdulgadir
##Aug 7 2018
##This class hides the Control Board hardware and provides easy to use 
##methods to configure and run operations on the DUT
##this will be an abstract class with each subclass interfacing to a specific board
class FOBOSCtrl:

    ##General Constants
   ACK_LEN = 4    ##acknowledgement length in bytes
   PARAM_LEN = 2  ##config prarameter length in bytes
   ###config parameters numbers. Each number can serve as register number 
   ##or array index. These parameters must be sent to the hardware board.
   OUT_LEN     = 0
   TRIG_WAIT   = 1
   TRG_LEN     = 2
   TRG_TYPE    = 3
   TIME_TO_RST = 4
   FORCE_RST   = 5
   RELEASE_RST = 6
   TIMEOUT     = 7
   SET_DUT_CLK = 8
   #Trigger parameters
   TRG_NORM   =    0                                                            
   TRG_FULL      = 1
   TRG_NORM_CLK  = 2  
   TRG_FULL_CLK  = 3

