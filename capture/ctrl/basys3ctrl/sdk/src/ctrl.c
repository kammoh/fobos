//#############################################################################
//#                                                                           #
//#   Copyright 2019 CERG                                                     #
//#                                                                           #
//#   Licensed under the Apache License, Version 2.0 (the "License");         #
//#   you may not use this file except in compliance with the License.        #
//#   You may obtain a copy of the License at                                 #
//#                                                                           #
//#       http://www.apache.org/licenses/LICENSE-2.0                          #
//#                                                                           #
//#   Unless required by applicable law or agreed to in writing, software     #
//#   distributed under the License is distributed on an "AS IS" BASIS,       #
//#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.#
//#   See the License for the specific language governing permissions and     #
//#   limitations under the License.                                          #
//#                                                                           #
//#############################################################################

#include "xparameters.h"
#include "xuartlite.h"
#include "xintc.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "xllfifo.h"
#include "xstatus.h"
#include "xtmrctr.h"
#include "dutcomm.h"
#include "dut_controller.h"
#include "seven_seg.h"
/*Hardware constants***********************************************************/
#define DUTCOMM_BASE        XPAR_DUTCOMM_1_S_AXI_BASEADDR
#define FIFO_DEV_ID              XPAR_AXI_FIFO_0_DEVICE_ID
#define DUT_CTRL_BASE            XPAR_DUT_CONTROLLER_1_S_AXI_BASEADDR
#define UARTLITE_DEVICE_ID       XPAR_UARTLITE_0_DEVICE_ID
#define INTC_DEVICE_ID           XPAR_INTC_0_DEVICE_ID
#define UARTLITE_INT_IRQ_ID      XPAR_INTC_0_UARTLITE_0_VEC_ID
#define DUT_CLKWIZ_BASE          XPAR_CLK_WIZ_1_BASEADDR
#define TMRCTR_DEVICE_ID         XPAR_TMRCTR_0_DEVICE_ID
//test hardware
#define TEST_DUTCOMM_BASE        XPAR_DUTCOMM_0_S_AXI_BASEADDR
#define TEST_DUT_CTRL_BASE       XPAR_DUT_CONTROLLER_0_S_AXI_BASEADDR
#define TEST_FIFO_BASE           XPAR_AXI_FIFO_MM_S_TEST_BASEADDR
#define TEST_FIFO_DEV_ID         XPAR_AXI_FIFO_MM_S_TEST_DEVICE_ID
/*DUT_controller Register offsets*************************************************************/
//Trigger module
#define TRG_LEN_REG_OFFSET       0x00
#define TRG_WAIT_REG_OFFSET      0x04
#define TRG_MODE_REG_OFFSET      0x08
//Reset module
#define FRC_RST_REG_OFFSET       0x1C
#define TIME2RST_REG_OFFSET      0x18
//Timeout module
#define TIMOUT_REG_OFFSET        0x0C
#define CTRL_STATUS_REG_OFFSET   0x14
/*DUT_CTRL status codes******************************************************************/
#define CTRL_TIMEOUT             4
/*DUTCOMM Register offsets*************************************************************/
#define COMM_STATUS_REG_OFFSET   0x00
#define INT_TYPE_REG_OFFSET      0x08
#define OUT_LEN_REG_OFFSET       0x0C
/*Constants********************************************************************/
#define CONFIG_ARR_SIZE          32
#define INPUT_BUFF_SIZE          8192
#define OUTPUT_BUFF_SIZE         4096
#define WORD_SIZE                4         // Size of words in bytes
#define STATUS_LEN               4         //Acknowledgment length in bytes
#define HEADER_SIZE              4         //command field size in bytes
#define PARAM_LEN                4         //config parameter length in bytes
/******************************************************************************/
#define ENABLED                  1
#define DISABLED                 0
#define S_OK                     0  
#define S_ERROR                  1
#define S_TIMEOUT                2
/*PC-to-Ctrl protocol commands*************************************************/
#define PROC_DATA                0xF001   //process data command
#define RD_CONFIG                0xF002   //read configuration command
#define WR_CONFIG                0xF003   //write configuration  command
/*Configuration commands*******************************************************/
//config command numbers. Each number encodes an action to be done by the controller
//command parameter may be stored in a register or array index.
#define OUT_LEN                  0
//trigger module
#define TRG_WAIT                 1
#define TRG_LEN                  2
#define TRG_MODE                 3
//reset module
#define TIME_TO_RST              4
#define FORCE_RST                5
#define RELEASE_RST              6
//timeout module
#define TIMEOUT                  7
#define SET_DUT_CLK              8
#define SET_TEST_MODE            9
/*DUT COMM Status codes********************************************************/
#define DONE                     0x1a
/******************************************************************************/
#define CLKWIZ_mWriteReg(BaseAddress, RegOffset, Data) \
   Xil_Out32((BaseAddress) + (RegOffset), (u32)(Data))

#define CLKWIZ_mReadReg(BaseAddress, RegOffset) \
   Xil_In32((BaseAddress) + (RegOffset))
/**************************************************************************/
u32 okStatus = S_OK;
u32 errorStatus = S_ERROR;
u32 timeoutStatus = S_TIMEOUT;
int testMode = ENABLED;
//configuration parameters
u32 config[CONFIG_ARR_SIZE];

int run();
int SetupInterruptSystem(XUartLite *UartLitePtr);
void SendHandler(void *CallBackRef, unsigned int EventData);
void RecvHandler(void *CallBackRef, unsigned int EventData);
int processData(u32 testVectorSize);
int initFifos(XLlFifo *InstancePtr, u16 DeviceId);
int TxSend(XLlFifo *InstancePtr, u32 *SourceAddr, u32 dataSize);
int RxReceive(XLlFifo *InstancePtr, u32 *DestinationAddr);
void delay(long loops);
u32 writeClk0Div(int divInt, int divFrac);

/*Command service***************************************************************/
void setOutLen(int value);
void forceReset();
void releaseReset();
void setTimeToReset(u32 cycles);
void setTimeOut(u32 timeout);
void setTimeoutAck();
void setTriggerLength(u32 length);
void setTriggerWait(u32 wait);
void setTriggerMode(u32 mode);
int applyConfig(int confNum, u32 value);
void setInterfaceType();
int  setClock0Freq(float clockValue);
int resultReady();
/*Variable definitions ********************************************************/
XUartLite UartLite;
XLlFifo FifoInstance;
XLlFifo TestFifoInstance;
XIntc InterruptController;
XTmrCtr TimerCounter;
u8 SendBuffer[OUTPUT_BUFF_SIZE];
u8 ReceiveBuffer[INPUT_BUFF_SIZE];
u8 headerBuffer[HEADER_SIZE];
static volatile int TotalReceivedCount;
static volatile int TotalSentCount;

/***************************************************************************/
int main(void)
{
   int Status;
   //setClock0Freq(2);
   // clear config array
   for(int i=0; i < CONFIG_ARR_SIZE; i++){
      config[i] = 0;
   }
   //default timeout 5 sec
   testMode = 0;
   setTimeOut(5);
   u16 DeviceId = UARTLITE_DEVICE_ID;
   Status = XUartLite_Initialize(&UartLite, DeviceId);
   if (Status != XST_SUCCESS) {
      return XST_FAILURE;
   }
   Status = XUartLite_SelfTest(&UartLite);
   if (Status != XST_SUCCESS) {
      return XST_FAILURE;
   }
   setInterfaceType();
   Status = initFifos(&FifoInstance, FIFO_DEV_ID);
   if (Status != XST_SUCCESS) {
      xil_printf("Ctrl software failed\n\r");
      return XST_FAILURE;
   }
   Status = initFifos(&TestFifoInstance, TEST_FIFO_DEV_ID);
      if (Status != XST_SUCCESS) {
         xil_printf("Ctrl software failed\n\r");
         return XST_FAILURE;
   }
   //init timer
   XTmrCtr *TmrCtrInstancePtr = &TimerCounter;
   Status = XTmrCtr_Initialize(TmrCtrInstancePtr, DeviceId);
   if (Status != XST_SUCCESS) {
   return XST_FAILURE;
   }

   //logo: CERG
   write7Seg(D_C, D_E, D_R, D_G);
   Status = run();
   if (Status != XST_SUCCESS) {
      xil_printf("Ctrl software failed\r\n");
      return XST_FAILURE;
   }
   xil_printf("Done.\r\n");
   return XST_SUCCESS;
}
/*****************************************************************************/
void delay(long loops)
{
   volatile long i = 0;
   while(i < loops) i++;
}
/****************************************************************************/
int initFifos(XLlFifo *InstancePtr, u16 DeviceId)
{
   XLlFifo_Config *Config;
   int Status;
   Status = XST_SUCCESS;
   /* Init device configuration interface driver */
   Config = XLlFfio_LookupConfig(DeviceId);
   if (!Config) {
      xil_printf("Config not found %d\r\n", DeviceId);
      return XST_FAILURE;
   }

   Status = XLlFifo_CfgInitialize(InstancePtr, Config, Config->BaseAddress);
   if (Status != XST_SUCCESS) {
      xil_printf("Init failed\n\r");
      return Status;
   }
   /* Check reset value */
   Status = XLlFifo_Status(InstancePtr);
   XLlFifo_IntClear(InstancePtr,0xffffffff);
   Status = XLlFifo_Status(InstancePtr);
   if(Status != 0x0) {
      xil_printf("Error wrong reset value.\n");
      return XST_FAILURE;
   }
   return Status;
}
/*****************************************************************************/
int run()
{
   int Status;
   u16 confNum;
   u16 value = 0;
   u16 bytesToRec = 0;
   u16 cmd = 0;
   u32 testVectorSize;
   Status = SetupInterruptSystem(&UartLite);
   if (Status != XST_SUCCESS) {
      return XST_FAILURE;
   }
   XUartLite_SetSendHandler(&UartLite, SendHandler, &UartLite);
   XUartLite_SetRecvHandler(&UartLite, RecvHandler, &UartLite);
   XUartLite_EnableInterrupt(&UartLite);

   while(1){
      TotalReceivedCount = 0;
      TotalSentCount = 0;
      //get header 4 bytes (2-byte command/2-byte length)
      XUartLite_Recv(&UartLite, headerBuffer, HEADER_SIZE);
      //wait until header is received
      while ((TotalReceivedCount != HEADER_SIZE));
      TotalReceivedCount = 0;
      cmd = headerBuffer[0] * 256 + headerBuffer[1];
      bytesToRec = headerBuffer[2] * 256 + headerBuffer[3];
      //get the data
      XUartLite_Recv(&UartLite, ReceiveBuffer, bytesToRec);
      while ((TotalReceivedCount != bytesToRec));

      //process depending on data type
      switch(cmd){
         case WR_CONFIG:
            confNum =  ReceiveBuffer[0] * 256 + ReceiveBuffer[1];
            value =  ReceiveBuffer[2] * 256 * 256 *256 + ReceiveBuffer[3] *
                     256 *256 + ReceiveBuffer[4] * 256 + ReceiveBuffer[5];
            Status = applyConfig(confNum, value);
            //send ack back
            TotalSentCount = 0;
            //send status
            if(Status == S_OK){
               XUartLite_Send(&UartLite, &okStatus, STATUS_LEN);
            }else{
               XUartLite_Send(&UartLite, &errorStatus, STATUS_LEN);
            }
            while (TotalSentCount != STATUS_LEN);
            TotalSentCount = 0;
            break;

         case RD_CONFIG:
            confNum =  ReceiveBuffer[0] * 256 + ReceiveBuffer[1];
            if(confNum > CONFIG_ARR_SIZE - 1){
               XUartLite_Send(&UartLite, &errorStatus, STATUS_LEN);
               break;
            }else{
                  XUartLite_Send(&UartLite, &okStatus, STATUS_LEN);
            }
            while (TotalSentCount != STATUS_LEN);
            TotalSentCount = 0;
            value = config[confNum];
            SendBuffer[0] = (value & 0xff000000) >> 24;
            SendBuffer[1] = (value & 0x00ff0000) >> 16;
            SendBuffer[2] = (value & 0x0000ff00) >> 8;
            SendBuffer[3] = (value & 0xff0000ff);
            //SendBuffer[1] = value % 256;
            //SendBuffer[0] = value / 256;
            //send it back
            TotalSentCount = 0;
            XUartLite_Send(&UartLite, SendBuffer, PARAM_LEN);
            while (TotalSentCount != PARAM_LEN);
            TotalSentCount = 0;
            break;

         case PROC_DATA:
            testVectorSize = bytesToRec;
            Status = processData(testVectorSize);
            //xil_printf("Data size %d \n", testVectorSize);
            if (Status == S_OK){
               //send status
               XUartLite_Send(&UartLite, &okStatus, STATUS_LEN);
               while (TotalSentCount != STATUS_LEN);
               TotalSentCount = 0;
               //send response
               if(config[TIME_TO_RST] == 0){
                  XUartLite_Send(&UartLite, SendBuffer, config[OUT_LEN]);
                  while (TotalSentCount != config[OUT_LEN]);
                  TotalSentCount = 0;
               }
            }else if(Status == S_TIMEOUT){
               XUartLite_Send(&UartLite, &timeoutStatus, STATUS_LEN);
               while (TotalSentCount != STATUS_LEN);
               TotalSentCount = 0;
            }
            break;

         default:
            break;
      }//case
   }//while
   return XST_SUCCESS;
}
/******************************************************************************/
int processData(u32 testVectorSize){
   int Status;
   int i;
   u32 t, t0;
   //
   XTmrCtr_Reset(&TimerCounter, 0); //start timer
   XTmrCtr_Start(&TimerCounter, 0); //start timer
   //clear sendBuffer
   for(i=0; i < config[OUT_LEN]; i++){
      SendBuffer[i] = 0;
   }
   t0 = XTmrCtr_GetValue(&TimerCounter, 0);
   if(testMode == ENABLED){
   Status = TxSend(&TestFifoInstance, ReceiveBuffer,testVectorSize);
   }else{
   Status = TxSend(&FifoInstance, ReceiveBuffer,testVectorSize);
   }
   //xil_printf("Data sent!!\n");
   if (Status != S_OK){
      forceReset();
      //reset fifo
      XLlFifo_Reset(&FifoInstance);
      XLlFifo_Reset(&TestFifoInstance);
      releaseReset();
      return S_TIMEOUT;
   }
   while(!resultReady()){
      //check if timeout
      //reset all
      t = XTmrCtr_GetValue(&TimerCounter, 0);
      //if (DUT_CONTROLLER_mReadReg(DUT_CTRL_BASE, CTRL_STATUS_REG_OFFSET) == CTRL_TIMEOUT){
      if(t > config[TIMEOUT]){
         //resetAll();
         forceReset();
         //reset fifo
         XLlFifo_Reset(&FifoInstance);
         XLlFifo_Reset(&TestFifoInstance);
         releaseReset();
         return S_TIMEOUT;
      }
   }
   if(config[TIME_TO_RST] == 0){//if we will reset dut, expect no result
      if(testMode == ENABLED){
         Status = RxReceive(&TestFifoInstance, SendBuffer);
      }else{
         Status = RxReceive(&FifoInstance, SendBuffer);
      }
   }
   //if (Status != XST_SUCCESS){
   return S_OK;
}

int resultReady(){
   if(testMode == ENABLED)
      return ((DUTCOMM_mReadReg(TEST_DUTCOMM_BASE,4) & 0x000000FF) == DONE);
   else
      return ((DUTCOMM_mReadReg(DUTCOMM_BASE,4) & 0x000000FF) == DONE);
}

/****************************************************************************/
void SendHandler(void *CallBackRef, unsigned int EventData)
{
   TotalSentCount = EventData;
}

void RecvHandler(void *CallBackRef, unsigned int EventData)
{
   TotalReceivedCount = EventData;
}

int SetupInterruptSystem(XUartLite *UartLitePtr)
{

   int Status;
   Status = XIntc_Initialize(&InterruptController, INTC_DEVICE_ID);
   if (Status != XST_SUCCESS) {
      return XST_FAILURE;
   }
   Status = XIntc_Connect(&InterruptController, UARTLITE_INT_IRQ_ID,
            (XInterruptHandler)XUartLite_InterruptHandler,
            (void *)UartLitePtr);
   if (Status != XST_SUCCESS) {
      return XST_FAILURE;
   }
   Status = XIntc_Start(&InterruptController, XIN_REAL_MODE);
   if (Status != XST_SUCCESS) {
      return XST_FAILURE;
   }

   XIntc_Enable(&InterruptController, UARTLITE_INT_IRQ_ID);

   Xil_ExceptionInit();
   Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
          (Xil_ExceptionHandler)XIntc_InterruptHandler,
          &InterruptController);
   Xil_ExceptionEnable();

   return XST_SUCCESS;
}

/******************************************************************************/
int TxSend(XLlFifo *InstancePtr, u32  *SourceAddr, u32 dataSize)
{
   int j;
   u32 sendData;
   u32 tmp;
   int numWords;
   if (dataSize % 4 != 0){
      numWords = dataSize / 4 + 1;
   }else{
      numWords = dataSize/ 4;
   }
   //for (j=0 ; j < (int)dataSize / 4  ; j++){
   for (j=0 ; j < numWords  ; j++){
      if( XLlFifo_iTxVacancy(InstancePtr) ){
         sendData = *(SourceAddr +j);
         //Fix endianess
         tmp = (sendData & 0x000000FF) << 24 | //byte3
               (sendData & 0x0000FF00) << 8  |
               (sendData & 0x00FF0000) >> 8  |
               (sendData & 0xFF000000) >> 24 ;  //byte0
         XLlFifo_TxPutWord(InstancePtr, tmp);
      }
   }
   /* Start transmission */
   XLlFifo_iTxSetLen(InstancePtr, dataSize);
   //xil_printf(" waiting for txDone... \r\n");
   int t;
   while( !(XLlFifo_IsTxDone(InstancePtr)) ){
      //  if(testMode == ENABLED){
      //  status = DUT_CONTROLLER_mReadReg(TEST_DUT_CTRL_BASE, CTRL_STATUS_REG_OFFSET);
      //  }else{
      //  status = DUT_CONTROLLER_mReadReg(DUT_CTRL_BASE, CTRL_STATUS_REG_OFFSET);
      //  }
      t = XTmrCtr_GetValue(&TimerCounter, 0);
      if (t > config[TIMEOUT]){
         return S_TIMEOUT;
      }
   }
   //xil_printf("txDone... \r\n");
   return S_OK;
}
/******************************************************************************/
int RxReceive (XLlFifo *InstancePtr, u32* DestinationAddr)
{
   int i;
   int Status;
   u32 RxWord;
   u32 tmp;
   static u32 ReceiveLength;
   //xil_printf(" Receiving data ....\n");
   /* Read Receive Length */
   ReceiveLength = XLlFifo_iRxGetLen(InstancePtr) / WORD_SIZE;
   /* Start Receiving */
   for ( i=0; i < ReceiveLength; i++){
      RxWord = 0;
      RxWord = XLlFifo_RxGetWord(InstancePtr);
      if(XLlFifo_iRxOccupancy(InstancePtr)){
         RxWord = XLlFifo_RxGetWord(InstancePtr);
      }
      //Fix endianess
      tmp = (RxWord & 0x000000FF) << 24 | //byte3
            (RxWord & 0x0000FF00) << 8  |
            (RxWord & 0x00FF0000) >> 8  |
            (RxWord & 0xFF000000) >> 24 ;  //byte0
      *(DestinationAddr+i) = tmp;
   }
   Status = XLlFifo_IsRxDone(InstancePtr);
   if(Status != TRUE){
      //xil_printf("Failing in receive complete ... \r\n");
      return XST_FAILURE;
   }
   return XST_SUCCESS;
}
/******************************************************************************/
void DUTCOMM_write(u32 offset, u32 value){
   if(testMode == ENABLED){
      DUTCOMM_mWriteReg(TEST_DUTCOMM_BASE, offset, value);
   }else{
      DUTCOMM_mWriteReg(DUTCOMM_BASE, offset, value);
   }
}
/******************************************************************************/
void DUTCTRL_write(u32 offset, u32 value){
   if(testMode == ENABLED){
      DUT_CONTROLLER_mWriteReg(TEST_DUT_CTRL_BASE, offset, value);
   }else{
      DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, offset, value);
   }
}
/******************************************************************************/
void setOutLen(int value){
   DUTCOMM_write(OUT_LEN_REG_OFFSET, 2 * value);//need data length in 4-bit words
}
//Reset module
void forceReset(){
   DUTCTRL_write(FRC_RST_REG_OFFSET, 1);
}

void releaseReset(){
   DUTCTRL_write(FRC_RST_REG_OFFSET, 0);
   setInterfaceType();
}

void setTimeToReset(u32 cycles){
   DUTCTRL_write(TIME2RST_REG_OFFSET, cycles);
   //no output if dut will reset
   if(cycles != 0) config[OUT_LEN] = 0;
}

//Timeout module
void setTimeOut(u32 timeout){
    config[TIMEOUT] = timeout * 100000000;
}

//trigger
void setTriggerLength(u32 length){
   DUTCTRL_write(TRG_LEN_REG_OFFSET, length);
}

void setTriggerWait(u32 wait){
   DUTCTRL_write(TRG_WAIT_REG_OFFSET, wait);
}

void setTriggerMode(u32 mode){
   DUTCTRL_write(TRG_MODE_REG_OFFSET, mode);
}

void setInterfaceType(){
   //This version uses legacy interface only only.
   //for both test and real DUT
   DUTCOMM_mWriteReg(TEST_DUTCOMM_BASE, INT_TYPE_REG_OFFSET, 1);
   DUTCOMM_mWriteReg(DUTCOMM_BASE, INT_TYPE_REG_OFFSET, 1);
}

/*****************************************************************************/
int applyConfig(int confNum, u32 value){
   int status = S_OK;
   config[confNum] = value;
   //write configuration to hardware registers if needed
   switch(confNum){
      case OUT_LEN:
            setOutLen(value);
            break;
      case TRG_WAIT:
            setTriggerWait(value);
            break;
      case TRG_LEN:
            setTriggerLength(value);
            break;
      case TRG_MODE:
            setTriggerMode(value);
            break;
      case TIME_TO_RST:
            setTimeToReset(value);
            break;
      case FORCE_RST:
            forceReset();
            break;
      case RELEASE_RST:
            releaseReset();
            break;
      case TIMEOUT:
            setTimeOut(value);
            break;
      case SET_DUT_CLK:
            setClock0Freq(value/1000); //KHz to MHz
            forceReset();
            //reset fifo
            XLlFifo_Reset(&FifoInstance);
            releaseReset();
            setInterfaceType(); //Interface type is forgotten after clock adjust. Set it back!
      break;
      case SET_TEST_MODE:
        testMode = value;
        break;

      default:
            status = S_ERROR;
            break;
   }
   return status;

}
///*Clock wizard driver********************************************************/
u32 writeClk0Div(int divInt, int divFrac){
   u32 div;
   div = CLKWIZ_mReadReg(DUT_CLKWIZ_BASE, 0x208);
   div = (div & 0xffffff00) | (divInt & 0xFF);
   div = (div & 0xfffc00ff) | ((divFrac & 0x3FF) << 8);
   CLKWIZ_mWriteReg(DUT_CLKWIZ_BASE, 0x208, div);
   return div;

}

int  setClock0Freq(float clockValue){
   int intDiv, conf, intMult, fracMult, divInt;
   float finalClk;
   float clkOut;
   int busClk = 100;
   float divisor, divFrac, divFracStored;
   if (clockValue > 100 || clockValue < 0.4){
      //xil_printf("Clk may only be between 0.5 and 100 MHz");
      return XST_FAILURE;
   }
   if (clockValue > 15){
      CLKWIZ_mWriteReg(DUT_CLKWIZ_BASE, 0x200, 0x00000a01);

   }else{
      CLKWIZ_mWriteReg(DUT_CLKWIZ_BASE, 0x200, 0x00000102);
   }
   conf = CLKWIZ_mReadReg(DUT_CLKWIZ_BASE, 0x00);
   intDiv = conf & 0xff;
   intMult = (conf & 0xff00) >> 8;
   fracMult = (conf & 0x3ff0000) >> 16;
   float tmpFracMult;
   tmpFracMult = fracMult;
   while (tmpFracMult > 1){
      tmpFracMult = tmpFracMult / 10;
   }
   clkOut = (busClk * (intMult + tmpFracMult)) / intDiv;
   divisor = clkOut / clockValue;
   divInt = (int)divisor;
   divFrac = divisor - divInt;
   //printf("%d\n%f\n", divInt, divFrac);
   divFracStored = divFrac;
   if(divFrac != 0){
      while (divFrac < 1024){
            divFrac = divFrac * 10;
      }
      divFrac = (int)(divFrac / 10);
   }
   finalClk = clkOut / (divInt + (int)divFracStored);
   writeClk0Div(divInt, (int)divFrac);
   CLKWIZ_mWriteReg(DUT_CLKWIZ_BASE, 0x25c,  0x00000003);
   return (int)finalClk;
}
