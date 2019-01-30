/******************************************************************************
*
* Copyright (C) 2002 - 2015 Xilinx, Inc.  All rights reserved.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* Use of the Software is limited solely to applications:
* (a) running on a Xilinx device, or
* (b) that interact with a Xilinx device through a bus or interconnect.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
* OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*
* Except as contained in this notice, the name of the Xilinx shall not be used
* in advertising or otherwise to promote the sale, use or other dealings in
* this Software without prior written authorization from Xilinx.
*
******************************************************************************/
/******************************************************************************/
/**
*
* @file xuartlite_intr_example.c
*
* This file contains a design example using the UartLite driver (XUartLite) and
* hardware device using the interrupt mode.
*
* @note
*
* The user must provide a physical loopback such that data which is
* transmitted will be received.
*
* MODIFICATION HISTORY:
* <pre>
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00a jhl  02/13/02 First release
* 1.00b rpm  10/01/03 Made XIntc declaration global
* 1.00b sv   06/09/05 Minor changes to comply to Doxygen and coding guidelines
* 2.00a ktn  10/20/09 Updated to use HAL Processor APIs and minor changes
*		      for coding guidelnes.
* 3.2   ms   01/23/17 Added xil_printf statement in main function to
*                     ensure that "Successfully ran" and "Failed" strings
*                     are available in all examples. This is a fix for
*                     CR-965028.
* </pre>
******************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"
#include "xuartlite.h"
#include "xintc.h"
#include "xil_exception.h"
#include "xil_printf.h"
#include "xllfifo.h"
#include "xstatus.h"
#include "dutcomm.h"
#include "dut_controller.h"

#define DUTCOMM_BASE 			XPAR_DUTCOMM_0_S_AXI_BASEADDR

/******Fifo params
 */
#define FIFO_DEV_ID	   	XPAR_AXI_FIFO_0_DEVICE_ID
#define DUT_CTRL_BASE 	XPAR_DUT_CONTROLLER_0_S_AXI_BASEADDR

#define WORD_SIZE 4			/* Size of words in bytes */
#define MAX_PACKET_LEN 12 //tetsing with 48 byte message
#define MAX_DATA_BUFFER_SIZE MAX_PACKET_LEN


/************************** Constant Definitions *****************************/

/*
 * The following constants map to the XPAR parameters created in the
 * xparameters.h file. They are defined here such that a user can easily
 * change all the needed parameters in one place.
 */
#define UARTLITE_DEVICE_ID      XPAR_UARTLITE_0_DEVICE_ID
#define INTC_DEVICE_ID          XPAR_INTC_0_DEVICE_ID
#define UARTLITE_INT_IRQ_ID     XPAR_INTC_0_UARTLITE_0_VEC_ID

/*
 * The following constant controls the length of the buffers to be sent
 * and received with the UartLite device.
 */
#define CONFIG_ARR_SIZE			32
#define TEST_BUFFER_SIZE        100
#define STATUS_LEN              4 //acknowledgement length in bytes
#define HEADER_SIZE             4 //command field size in bytes
#define PARAM_LEN				2 //config prarameter length in bytes
///Operation status Status
#define S_OK						0
#define S_ERROR					1
#define S_TIMEOUT					2

u32 okStatus 			= S_OK;
u32 errorStatus 		= S_ERROR;
u32 timeoutStatus 		= S_TIMEOUT;

//Commands
#define PROC_DATA		0xF001
#define RD_CONFIG		0xF002
#define WR_CONFIG		0xF003


//config parameters numbers. Each number can serve as register number
//or array index. These parameters must be sent to the hardware board.
#define OUT_LEN     0
//trigger module
#define TRG_WAIT    1
#define TRG_LEN     2
#define TRG_MODE    3
//reset module
#define TIME_TO_RST 4
#define FORCE_RST   5
#define RELEASE_RST 6
//timeout module
#define TIMEOUT		7
#define TIMEOUT_ACK 8
#define REL_TIMEOUT_ACK 9
//DUTCOMM status
#define DONE		0x1a
//testing fifo/dutcomm
u32 testBuffer[12] = {0x00C00010,
		0x77446B60,
		0x9E646B7C,
		0x9EDC1E9A,
		0x070DFFB8,
		0x00C10010,
		0x00112233,
		0x44556677,
		0x8899AABB,
		0xCCDDEEFF,
		0x00810010,
		0x00800001};

///configuration parameters
u32 expectedOutLen = 16;
u16 config[CONFIG_ARR_SIZE];

/**************************** Type Definitions *******************************/


/***************** Macros (Inline Functions) Definitions *********************/


/************************** Function Prototypes ******************************/

int UartLiteIntrExample(u16 DeviceId);

int SetupInterruptSystem(XUartLite *UartLitePtr);

void SendHandler(void *CallBackRef, unsigned int EventData);

void RecvHandler(void *CallBackRef, unsigned int EventData);

int processData(void);
int XLlFifoPollingExample(XLlFifo *InstancePtr, u16 DeviceId);
int TxSend(XLlFifo *InstancePtr, u32 *SourceAddr);
int RxReceive(XLlFifo *InstancePtr, u32 *DestinationAddr);

/********************************************************************************/
void forceReset();
void setTimeToReset(u32 cycles);
void setTimeOut(u32 timeout);
void setTimeoutAck();
void setTriggerLength(u32 length);
void setTriggerWait(u32 wait);
void setTriggerMode(u32 mode);

int applyConfig(int confNum, u32 value);

/************************** Variable Definitions *****************************/

 XUartLite UartLite;            /* The instance of the UartLite Device */
 XLlFifo FifoInstance;
// XGpio Gpio;											/* GPIO Device driver instance */


 XIntc InterruptController;     /* The instance of the Interrupt Controller */

/*
 * The following variables are shared between non-interrupt processing and
 * interrupt processing such that they must be global.
 */

/*
 * The following buffers are used in this example to send and receive data
 * with the UartLite.
 */
u8 SendBuffer[TEST_BUFFER_SIZE];
u8 ReceiveBuffer[TEST_BUFFER_SIZE];
u8 headerBuffer[HEADER_SIZE];

/*
 * The following counters are used to determine when the entire buffer has
 * been sent and received.
 */
static volatile int TotalReceivedCount;
static volatile int TotalSentCount;


/******************************************************************************/
/**
*
* Main function to call the UartLite interrupt example.
*
* @param	None
*
* @return	XST_SUCCESS if successful, XST_FAILURE if unsuccessful
*
* @note		None
*
*******************************************************************************/
int main(void)
{
	int Status;
	// clear config array
	for(int i=0; i < CONFIG_ARR_SIZE; i++){
		config[i] = 0;
	}
	u16 DeviceId = UARTLITE_DEVICE_ID;
	Status = XUartLite_Initialize(&UartLite, DeviceId);
		if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}

		/*
		 * Perform a self-test to ensure that the hardware was built correctly.
		 */
		Status = XUartLite_SelfTest(&UartLite);
		if (Status != XST_SUCCESS) {
			return XST_FAILURE;
		}
		//set send_data ro 0
		DUTCOMM_mWriteReg(DUTCOMM_BASE,0,0);// my not be needed since FIOF sends only when a PACKET LEN is written


    //configure GPIO
//	Status = XGpio_Initialize(&Gpio, GPIO_DEVICE_ID);
//	if (Status != XST_SUCCESS) {
//		return XST_FAILURE;
//	}
//	XGpio_SetDataDirection(&Gpio, 1, 0x0);
//	XGpio_DiscreteWrite(&Gpio, 1, 0);
	//xil_printf("Starting\r\n");
	//xil_printf("Configuring FIFOs\n");
	Status = XLlFifoPollingExample(&FifoInstance, FIFO_DEV_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Axi Streaming FIFO Polling Example Test Failed\n\r");
		xil_printf("--- Exiting main() ---\n\r");
		return XST_FAILURE;
	}
	//xil_printf("Successfully configured FIFOs\n");
	/*
	 * Run the UartLite Interrupt example, specify the Device ID that is
	 * generated in xparameters.h.
	 */
	Status = UartLiteIntrExample(UARTLITE_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		xil_printf("Uartlite interrupt Example Failed\r\n");
		return XST_FAILURE;
	}

	xil_printf("Successfully ran Uartlite interrupt Example\r\n");
	return XST_SUCCESS;
}

/****************************************************************************/
/**
*
* This function does a minimal test on the UartLite device and driver as a
* design example. The purpose of this function is to illustrate
* how to use the XUartLite component.
*
* This function sends data and expects to receive the same data through the
* UartLite. The user must provide a physical loopback such that data which is
* transmitted will be received.
*
* This function uses interrupt driver mode of the UartLite device. The calls
* to the UartLite driver in the handlers should only use the non-blocking
* calls.
*
* @param	DeviceId is the Device ID of the UartLite Device and is the
*		XPAR_<uartlite_instance>_DEVICE_ID value from xparameters.h.
*
* @return	XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note
*
* This function contains an infinite loop such that if interrupts are not
* working it may never return.
*
****************************************************************************/
//configure fifo
int XLlFifoPollingExample(XLlFifo *InstancePtr, u16 DeviceId)
{
	XLlFifo_Config *Config;
	int Status;

	Status = XST_SUCCESS;

	/* Initial setup for Uart16550 */
#ifdef XPAR_UARTNS550_0_BASEADDR

	Uart550_Setup();

#endif

	/* Initialize the Device Configuration Interface driver */
	Config = XLlFfio_LookupConfig(DeviceId);
	if (!Config) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	/*
	 * This is where the virtual address would be used, this example
	 * uses physical address.
	 */
	Status = XLlFifo_CfgInitialize(InstancePtr, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed\n\r");
		return Status;
	}

	/* Check for the Reset value */
	Status = XLlFifo_Status(InstancePtr);
	XLlFifo_IntClear(InstancePtr,0xffffffff);
	Status = XLlFifo_Status(InstancePtr);
	if(Status != 0x0) {
		xil_printf("\n ERROR : Reset value of ISR0 : 0x%x\t"
			    "Expected : 0x0\n\r",
			    XLlFifo_Status(InstancePtr));
		return XST_FAILURE;
	}


	return Status;
}


int UartLiteIntrExample(u16 DeviceId)
{
	int Status;
	int Index;
	u16 confNum;
	u16 value = 0;
	u16 bytesToRec = 0;
	u16 cmd = 0;

	/*
	 * Initialize the UartLite driver so that it's ready to use.
	 */


	/*
	 * Connect the UartLite to the interrupt subsystem such that interrupts can
	 * occur. This function is application specific.
	 */
	Status = SetupInterruptSystem(&UartLite);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Setup the handlers for the UartLite that will be called from the
	 * interrupt context when data has been sent and received, specify a
	 * pointer to the UartLite driver instance as the callback reference so
	 * that the handlers are able to access the instance data.
	 */
	XUartLite_SetSendHandler(&UartLite, SendHandler, &UartLite);
	XUartLite_SetRecvHandler(&UartLite, RecvHandler, &UartLite);

	/*
	 * Enable the interrupt of the UartLite so that interrupts will occur.
	 */
	XUartLite_EnableInterrupt(&UartLite);

	/*
	 * Initialize the send buffer bytes with a pattern to send and the
	 * the receive buffer bytes to zero to allow the receive data to be
	 * verified.
	 */
	//for (Index = 0; Index < TEST_BUFFER_SIZE; Index++) {
	//	SendBuffer[Index] = Index;
		//ReceiveBuffer[Index] = 0;
//	}

	/*
	 * Start receiving data before sending it since there is a loopback.
	 *
	 *
	 *
	 *
	 *
	 *
	 *
	 */
	for(int i=0; i<10; i++){
		//xil_printf("encryption: %d \n", i);
		//processData();
	}
	while(1){
		TotalReceivedCount = 0;
		TotalSentCount = 0;
		//get header 4 bytes (2-byte-type/2-byte-length)

		XUartLite_Recv(&UartLite, headerBuffer, HEADER_SIZE);

		//wait until header is received
		while ((TotalReceivedCount != HEADER_SIZE));

		TotalReceivedCount = 0;
		cmd = headerBuffer[0] * 256 + headerBuffer[1];
		bytesToRec = headerBuffer[2] * 256 + headerBuffer[3];

		XUartLite_Recv(&UartLite, ReceiveBuffer, bytesToRec);



		//wait
		while ((TotalReceivedCount != bytesToRec));

	//process depending on data type

		switch(cmd){
		case WR_CONFIG:

			confNum =  ReceiveBuffer[0] * 256 + ReceiveBuffer[1];
			value =  ReceiveBuffer[2] * 256 + ReceiveBuffer[3];

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
			SendBuffer[1] = value % 256;
			SendBuffer[0] = value / 256;
			//send it back
			TotalSentCount = 0;
			XUartLite_Send(&UartLite, SendBuffer, PARAM_LEN);
	        while (TotalSentCount != PARAM_LEN);
			TotalSentCount = 0;
			break;

		case PROC_DATA:
			//process the input here and prepare respons
			//for (Index = 0; Index < TEST_BUFFER_SIZE; Index++) {

			//	ReceiveBuffer[Index]--;
			//}
			//xil_printf("Processing data ...\n");
			/* Transmit the Data Stream */

			Status = processData();
			if (Status == S_OK){
				//send status
				XUartLite_Send(&UartLite, &okStatus, STATUS_LEN);
				while (TotalSentCount != STATUS_LEN);
				TotalSentCount = 0;
				//send response
				TotalSentCount = 0;
				XUartLite_Send(&UartLite, SendBuffer, expectedOutLen);
				while (TotalSentCount != expectedOutLen);
				TotalSentCount = 0;
			}else if(Status == S_TIMEOUT){
				XUartLite_Send(&UartLite, &timeoutStatus, STATUS_LEN);
				while (TotalSentCount != STATUS_LEN);
				TotalSentCount = 0;

			}
			break;

		   /*
	    	* Wait for the entire buffer to be received, letting the interrupt
		  * processing work in the background, this function may get locked
		  * up in this loop if the interrupts are not working correctly.
		   */


		default:
			break;
		}

	}
	/*
	 * Verify the entire receive buffer was successfully received.
	 */
	for (Index = 0; Index < TEST_BUFFER_SIZE; Index++) {
		if (ReceiveBuffer[Index] != SendBuffer[Index]) {
			return XST_FAILURE;
		}
	}

	return XST_SUCCESS;
}

int processData(){
	int Status;
	int timeoutStatus;
	int i;
	volatile long int j;
	//clear sendBuffer
	for(i=0; i<16; i++){
		SendBuffer[i] = 0;
	}
	//xil_printf("processData() called\n");
	//XGpio_DiscreteWrite(&Gpio, 1,1);
	DUTCOMM_mWriteReg(DUTCOMM_BASE,0,1); //set send_data to 1, my not be needed since FIOF sends only when a PACKET LEN is written

	Status = TxSend(&FifoInstance, ReceiveBuffer);
	//xil_printf("Data sent!!\n");

	if (Status != S_OK){
		return S_TIMEOUT;
	}
	//some delay
	//for(j=0; j< 50000; j++);
	//wait until dutcom gets data back from dut
	while((DUTCOMM_mReadReg(DUTCOMM_BASE,4) & 0x000000FF) != DONE){
		//check if timeout
		//reset all
		if (DUT_CONTROLLER_mReadReg(DUT_CTRL_BASE, 20) == 4){
			//resetAll();
			forceReset();
			//reset fifo
			XLlFifo_Reset(&FifoInstance);
			DUTCOMM_mWriteReg(DUTCOMM_BASE,0,0); //release snd_start

			releaseReset();

			return S_TIMEOUT;
		}
	}
	//xil_printf("after delay\n");
	/* Revceive the Data Stream */
	//xil_printf("Recieving data...\n");
	Status = RxReceive(&FifoInstance, SendBuffer);
	//if (Status != XST_SUCCESS){
		//xil_printf("Receiving data failed");
		//return XST_FAILURE;
	//}
	//xil_printf("Received data: \n");
	//for (int i=0; i< 4; i++){
		//xil_printf("%08x\n", ((u32*)SendBuffer)[i]);
	//}
	//send start signal
	/*
	 * Send the buffer using the UartLite.
	*/
	//XGpio_DiscreteWrite(&Gpio, 1, 0);
	DUTCOMM_mWriteReg(DUTCOMM_BASE,0,0); //release send_data my not be needed since FIOF sends only when a PACKET LEN is written


	return S_OK;
}

/*****************************************************************************/
/**
*
* This function is the handler which performs processing to send data to the
* UartLite. It is called from an interrupt context such that the amount of
* processing performed should be minimized. It is called when the transmit
* FIFO of the UartLite is empty and more data can be sent through the UartLite.
*
* This handler provides an example of how to handle data for the UartLite,
* but is application specific.
*
* @param	CallBackRef contains a callback reference from the driver.
*		In this case it is the instance pointer for the UartLite driver.
* @param	EventData contains the number of bytes sent or received for sent
*		and receive events.
*
* @return	None.
*
* @note		None.
*
****************************************************************************/
void SendHandler(void *CallBackRef, unsigned int EventData)
{
	TotalSentCount = EventData;
}

/****************************************************************************/
/**
*
* This function is the handler which performs processing to receive data from
* the UartLite. It is called from an interrupt context such that the amount of
* processing performed should be minimized.  It is called data is present in
* the receive FIFO of the UartLite such that the data can be retrieved from
* the UartLite. The size of the data present in the FIFO is not known when
* this function is called.
*
* This handler provides an example of how to handle data for the UartLite,
* but is application specific.
*
* @param	CallBackRef contains a callback reference from the driver, in
*		this case it is the instance pointer for the UartLite driver.
* @param	EventData contains the number of bytes sent or received for sent
*		and receive events.
*
* @return	None.
*
* @note		None.
*
****************************************************************************/
void RecvHandler(void *CallBackRef, unsigned int EventData)
{
	TotalReceivedCount = EventData;
}

/****************************************************************************/
/**
*
* This function setups the interrupt system such that interrupts can occur
* for the UartLite device. This function is application specific since the
* actual system may or may not have an interrupt controller. The UartLite
* could be directly connected to a processor without an interrupt controller.
* The user should modify this function to fit the application.
*
* @param    UartLitePtr contains a pointer to the instance of the UartLite
*           component which is going to be connected to the interrupt
*           controller.
*
* @return   XST_SUCCESS if successful, otherwise XST_FAILURE.
*
* @note     None.
*
****************************************************************************/
int SetupInterruptSystem(XUartLite *UartLitePtr)
{

	int Status;


	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	Status = XIntc_Initialize(&InterruptController, INTC_DEVICE_ID);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	/*
	 * Connect a device driver handler that will be called when an interrupt
	 * for the device occurs, the device driver handler performs the
	 * specific interrupt processing for the device.
	 */
	Status = XIntc_Connect(&InterruptController, UARTLITE_INT_IRQ_ID,
			   (XInterruptHandler)XUartLite_InterruptHandler,
			   (void *)UartLitePtr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Start the interrupt controller such that interrupts are enabled for
	 * all devices that cause interrupts, specific real mode so that
	 * the UartLite can cause interrupts through the interrupt controller.
	 */
	Status = XIntc_Start(&InterruptController, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*
	 * Enable the interrupt for the UartLite device.
	 */
	XIntc_Enable(&InterruptController, UARTLITE_INT_IRQ_ID);

	/*
	 * Initialize the exception table.
	 */
	Xil_ExceptionInit();

	/*
	 * Register the interrupt controller handler with the exception table.
	 */
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			 (Xil_ExceptionHandler)XIntc_InterruptHandler,
			 &InterruptController);

	/*
	 * Enable exceptions.
	 */
	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

/////////////FIFO send and receive
int TxSend(XLlFifo *InstancePtr, u32  *SourceAddr)
{

	int i;
	int j;
	u32 sendData;
	u32 tmp;
	//xil_printf(" Transmitting Data ... \r\n");

	/* Filling the buffer with data */
	//for (i=0;i<MAX_DATA_BUFFER_SIZE;i++)
		//*(SourceAddr + i) = i;
		/* Writing into the FIFO Transmit Port Buffer */
		for (j=0 ; j < MAX_PACKET_LEN ; j++){
			if( XLlFifo_iTxVacancy(InstancePtr) ){
				sendData = *(SourceAddr +j);
				//fix endianess

				tmp =   (sendData & 0x000000FF) << 24 | //byte3
						(sendData & 0x0000FF00) << 8  |
						(sendData & 0x00FF0000) >> 8  |
						(sendData & 0xFF000000) >> 24 ;  //byte0
				XLlFifo_TxPutWord(InstancePtr, tmp);
				//xil_printf("%08x\n", sendData);
			}
		}

	/* Start Transmission by writing transmission length into the TLR */
	XLlFifo_iTxSetLen(InstancePtr, (MAX_DATA_BUFFER_SIZE * WORD_SIZE));
//	xil_printf(" waiting for txDone... \r\n");
	/* Check for Transmission completion */
	while( !(XLlFifo_IsTxDone(InstancePtr)) ){
		int status = DUT_CONTROLLER_mReadReg(DUT_CTRL_BASE, 20);
		if (status == 4){
			return S_TIMEOUT;
		}
	}
	//xil_printf("txDone... \r\n");


	/* Transmission Complete */
	return S_OK;
}

/*****************************************************************************/
/**
*
* RxReceive routine.It will receive the data from the FIFO.
*
* @param	InstancePtr is a pointer to the instance of the
*		XLlFifo instance.
*
* @param	DestinationAddr is the address where to copy the received data.
*
* @return
*		-XST_SUCCESS to indicate success
*		-XST_FAILURE to indicate failure
*
* @note		None
*
******************************************************************************/
int RxReceive (XLlFifo *InstancePtr, u32* DestinationAddr)
{

	int i;
	int Status;
	u32 RxWord;
	u32 tmp;
	static u32 ReceiveLength;

	//xil_printf(" Receiving data ....\n\r");
	/* Read Recieve Length */
	ReceiveLength = (XLlFifo_iRxGetLen(InstancePtr))/WORD_SIZE;

	/* Start Receiving */
	for ( i=0; i < ReceiveLength; i++){
		RxWord = 0;
		RxWord = XLlFifo_RxGetWord(InstancePtr);

		if(XLlFifo_iRxOccupancy(InstancePtr)){
			RxWord = XLlFifo_RxGetWord(InstancePtr);
		}
		//fix endianess

		tmp =   (RxWord & 0x000000FF) << 24 | //byte3
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
/*
 *
 *   trigger_length  <= slv_reg0;
    trigger_wait    <= slv_reg1;
    trigger_mode    <= slv_reg2(7 downto 0);
    --timeout module
    timeout         <= slv_reg3;
    ack             <= slv_reg4(0);
    --slv_reg5 is for reading timeout_status
	-- User logic ends
	time_to_rst     <= slv_reg6;
	force_rst       <= slv_reg7(0);
 *
 *
 */

/********************************************************************************/
//Reset module
void forceReset(){
	 DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x1C, 1);     //register 7
}

void releaseReset(){
	 DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x1C, 0);     //register 7
}

void setTimeToReset(u32 cycles){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x18, cycles); //register 6
}

//Timeout module
void setTimeOut(u32 timeout){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x0C, timeout); //register 3
}

void setTimeoutAck(){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x10, 1);       //register 4
}
void releaseTimeoutAck(){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x10, 0);       //register 4
}

//trigger
void setTriggerLength(u32 length){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x00, length);  //register 0
}

void setTriggerWait(u32 wait){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x04, wait);    //register 1
}

void setTriggerMode(u32 mode){
	DUT_CONTROLLER_mWriteReg(DUT_CTRL_BASE, 0x08, mode);    //register 2
}

/*
 *
 * #define OUT_LEN     0
//trigger module
#define TRG_WAIT   1
#define TRG_LEN     2
#define TRG_TYPE    3
//reset module
#define TIME_TO_RST 4
#define FORCE_RST   5
//timeout module
#define TIMEOUT		6
#define TIMEOUT_ACK 7
 */
int applyConfig(int confNum, u32 value){
	int status = S_OK;
	config[confNum] = value;
	//write configuration to hardware registers if needed

	switch(confNum){
		case OUT_LEN:
				//no need to do anything else
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
		case TIMEOUT_ACK:
				setTimeoutAck();
				break;
		case REL_TIMEOUT_ACK:
				releaseTimeoutAck();
				break;
		default:
				status = S_ERROR;
				break;
	}
	return status;

}
