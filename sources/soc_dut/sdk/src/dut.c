/******************************************************************************
*
* Copyright (C) 2013 - 2014 Xilinx, Inc.  All rights reserved.
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
/*****************************************************************************/
/**
 *
 * @file XLlFifo_polling_example.c
 * This file demonstrates how to use the Streaming fifo driver on the xilinx AXI
 * Streaming FIFO IP.The AXI4-Stream FIFO core allows memory mapped access to a
 * AXI-Stream interface. The core can be used to interface to AXI Streaming IPs
 * similar to the LogiCORE IP AXI Ethernet core, without having to use full DMA
 * solution.
 *
 * This is the polling example for the FIFO it assumes that at the
 * h/w level FIFO is connected in loopback.In these we write known amount of
 * data to the FIFO and Receive the data and compare with the data transmitted.
 *
 * Note: The TDEST Must be enabled in the H/W design inorder to
 * get correct RDR value.
 *
 * <pre>
 * MODIFICATION HISTORY:
 *
 * Ver   Who  Date     Changes
 * ----- ---- -------- -------------------------------------------------------
 * 3.00a adk 08/10/2013 initial release CR:727787
 * 5.1   ms  01/23/17   Modified xil_printf statement in main function to
 *                      ensure that "Successfully ran" and "Failed" strings
 *                      are available in all examples. This is a fix for
 *                      CR-965028.
 *       ms  04/05/17   Added tabspace for return statements in functions for
 *                      proper documentation and Modified Comment lines
 *                      to consider it as a documentation block while
 *                      generating doxygen.
 * </pre>
 *
 * ***************************************************************************
 */

/***************************** Include Files *********************************/
#include "xparameters.h"
#include "xil_exception.h"
#include "xstreamer.h"
#include "xil_cache.h"
#include "xllfifo.h"
#include "xstatus.h"
#include "dutcomm.h"
#include "ctrlComm.h"
#ifdef XPAR_UARTNS550_0_BASEADDR
#include "xuartns550_l.h"       /* to use uartns550 */
#endif

/**************************** Type Definitions *******************************/

/***************** Macros (Inline Functions) Definitions *********************/

#define FIFO_DUTCOM	   	XPAR_AXI_FIFO_1_DEVICE_ID
#define FIFO_CTRLCOM	   	XPAR_AXI_FIFO_0_DEVICE_ID


#define WORD_SIZE 4			/* Size of words in bytes */

#define MAX_PACKET_LEN 12

#define NO_OF_PACKETS 1

#define MAX_DATA_BUFFER_SIZE NO_OF_PACKETS*MAX_PACKET_LEN

#undef DEBUG

/************************** Function Prototypes ******************************/
#ifdef XPAR_UARTNS550_0_BASEADDR
static void Uart550_Setup(void);
#endif
#define DUTCOMM_BASE XPAR_DUTCOMM_0_S_AXI_BASEADDR
#define CTLCOMM_BASE XPAR_CTRLCOMM_0_S_AXI_BASEADDR
int XLlFifoPollingExample(XLlFifo *InstancePtr, u16 DeviceId);
int TxSend(XLlFifo *InstancePtr, u32 *SourceAddr, u32 cnt);
int RxReceive(XLlFifo *InstancePtr, u32 *DestinationAddr);
int test();

u32 testBuffer[12] =
        {0x00C00010,
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

/************************** Variable Definitions *****************************/
/*
 * Device instance definitions
 */
XLlFifo FifoInstance_dutcom;
XLlFifo FifoInstance_ctrlcom;

u32 SourceBuffer[MAX_DATA_BUFFER_SIZE * WORD_SIZE];
u32 DestinationBuffer[MAX_DATA_BUFFER_SIZE * WORD_SIZE];

/*****************************************************************************/
/**
*
* Main function
*
* This function is the main entry of the Axi FIFO Polling test.
*
* @param	None
*
* @return
*		- XST_SUCCESS if tests pass
* 		- XST_FAILURE if fails.
*
* @note		None
*
******************************************************************************/
int main()
{
	int Status;

	xil_printf("--- Entering main() ---\n\r");

	Status = test();
	if (Status != XST_SUCCESS) {
		xil_printf("Axi Streaming FIFO Polling Example Test Failed\n\r");
		xil_printf("--- Exiting main() ---\n\r");
		return XST_FAILURE;
	}

	xil_printf("Successfully ran Axi Streaming FIFO Polling Example\n\r");
	xil_printf("--- Exiting main() ---\n\r");

	return XST_SUCCESS;
}

/*****************************************************************************/
/**
*
* This function demonstrates the usage AXI FIFO
* It does the following:
*       - Set up the output terminal if UART16550 is in the hardware build
*       - Initialize the Axi FIFO Device.
*	- Transmit the data
*	- Receive the data from fifo
*	- Compare the data
*	- Return the result
*
* @param	InstancePtr is a pointer to the instance of the
*		XLlFifo component.
* @param	DeviceId is Device ID of the Axi Fifo Deive instance,
*		typically XPAR_<AXI_FIFO_instance>_DEVICE_ID value from
*		xparameters.h.
*
* @return
*		-XST_SUCCESS to indicate success
*		-XST_FAILURE to indicate failure
*
******************************************************************************/
int clearDestBuf(){
	int i;
	for(i=0; i<MAX_DATA_BUFFER_SIZE; i++) DestinationBuffer[i] = 0;
}
int test()
{
	u16 DeviceId;
	XLlFifo_Config *Config;
	int Status;
	int i;
	int Error;
	int j;
	int k;
	int l;
	Status = XST_SUCCESS;


	/* Initial setup for Uart16550 */
#ifdef XPAR_UARTNS550_0_BASEADDR

	Uart550_Setup();

#endif
	///init fifo1
	/* Initialize the Device Configuration Interface driver */
	DeviceId= FIFO_DUTCOM;
	Config = XLlFfio_LookupConfig(DeviceId);
	if (!Config) {
		xil_printf("No config found for %d\r\n", DeviceId);
		return XST_FAILURE;
	}

	/*
	 * This is where the virtual address would be used, this example
	 * uses physical address.
	 */
	Status = XLlFifo_CfgInitialize(&FifoInstance_dutcom, Config, Config->BaseAddress);
	if (Status != XST_SUCCESS) {
		xil_printf("Initialization failed\n\r");
		return Status;
	}

	/* Check for the Reset value */
	Status = XLlFifo_Status(&FifoInstance_dutcom);
	XLlFifo_IntClear(&FifoInstance_dutcom,0xffffffff);
	Status = XLlFifo_Status(&FifoInstance_dutcom);
	if(Status != 0x0) {
		xil_printf("\n ERROR : Reset value of ISR0 : 0x%x\t"
			    "Expected : 0x0\n\r",
			    XLlFifo_Status(&FifoInstance_dutcom));
		return XST_FAILURE;
	}
	//////////////////////////////////////////////////////////////////
	///init fifo0 - ctrl_com fifo
		// Initialize the Device Configuration Interface driver */

	DeviceId = FIFO_CTRLCOM;
		Config = XLlFfio_LookupConfig(DeviceId);
		if (!Config) {
			xil_printf("No config found for %d\r\n", DeviceId);
			return XST_FAILURE;
		}


		Status = XLlFifo_CfgInitialize(&FifoInstance_ctrlcom, Config, Config->BaseAddress);
		if (Status != XST_SUCCESS) {
			xil_printf("Initialization failed\n\r");
			return Status;
		}

		Status = XLlFifo_Status(&FifoInstance_ctrlcom);
		XLlFifo_IntClear(&FifoInstance_ctrlcom,0xffffffff);
		Status = XLlFifo_Status(&FifoInstance_ctrlcom);
		if(Status != 0x0) {
			xil_printf("\n ERROR : Reset value of ISR0 : 0x%x\t"
				    "Expected : 0x0\n\r",
				    XLlFifo_Status(&FifoInstance_ctrlcom));
			return XST_FAILURE;
		}

		///
		///////////////////////////////////////////////////////////////////
    for(k = 1; k<=10; k++){

	/* Transmit the Data Stream */ //Through DUTCOMM
	Status = TxSend(&FifoInstance_dutcom, testBuffer, MAX_PACKET_LEN);
	if (Status != XST_SUCCESS){
		xil_printf("Transmisson of Data failed\n\r");
		return XST_FAILURE;
	}

	//set snd_start signal
	DUTCOMM_mWriteReg(DUTCOMM_BASE, 0, 1); // my not be needed since FIOF sends only when a PACKET LEN is written
	for(j=0; j< 5000; j++);
    DUTCOMM_mWriteReg(DUTCOMM_BASE, 0, 0); // my not be needed since FIOF sends only when a PACKET LEN is written

    clearDestBuf();
	// Revceive the Data Stream FORM CTRL_COM
	//from ctrl_comm
	Status = RxReceive(&FifoInstance_ctrlcom, DestinationBuffer);
	if (Status != XST_SUCCESS){
		xil_printf("Receiving data failed");
		return XST_FAILURE;
	}
	//process the data
	//here

	//NOW, return result

	//push data in to the fifo
	xil_printf("Sending back result...");
	Status = TxSend(&FifoInstance_ctrlcom, DestinationBuffer, MAX_PACKET_LEN);
	if (Status != XST_SUCCESS){
			xil_printf("Transmisson of Data failed\n\r");
			return XST_FAILURE;
	}

	// assert result ready// may not be needed

	CTRLCOMM_mWriteReg(CTLCOMM_BASE, 0, 1);
	//Now, get the data out of the DUTCOMM
	xil_printf("receiving result... \n");
	clearDestBuf();
	Status = RxReceive(&FifoInstance_dutcom, DestinationBuffer);
	if (Status != XST_SUCCESS){
		xil_printf("Receiving data failed");
		return XST_FAILURE;
	}

    }//for
	Error = 0;

	/* Compare the data send with the data received */
//	xil_printf(" Comparing data ...\n\r");
//	for( i=0 ; i<MAX_DATA_BUFFER_SIZE ; i++ ){
//		if ( *(SourceBuffer + i) != *(DestinationBuffer + i) ){
//			Error = 1;
//			break;
//		}
//
//	}

	if (Error != 0){
		return XST_FAILURE;
	}

	return Status;
}

/*****************************************************************************/
/**
*
* TxSend routine, It will send the requested amount of data at the
* specified addr.
*
* @param	InstancePtr is a pointer to the instance of the
*		XLlFifo component.
*
* @param	SourceAddr is the address where the FIFO stars writing
*
* @return
*		-XST_SUCCESS to indicate success
*		-XST_FAILURE to indicate failure
*
* @note		None
*
******************************************************************************/
int TxSend(XLlFifo *InstancePtr, u32  *SourceAddr, u32 cnt)
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
		for (j=0 ; j < cnt ; j++){
			if( XLlFifo_iTxVacancy(InstancePtr) ){
				sendData = *(SourceAddr +j);
				//fix endianess
				/*
				tmp =   (sendData & 0x000000FF) << 24 | //byte3
						(sendData & 0x0000FF00) << 8  |
						(sendData & 0x00FF0000) >> 8  |
						(sendData & 0xFF000000) >> 24 ;  //byte0
				*/
				XLlFifo_TxPutWord(InstancePtr, sendData);
				xil_printf("%08x\n", sendData);
			}
		}

	/* Start Transmission by writing transmission length into the TLR */
	XLlFifo_iTxSetLen(InstancePtr, cnt * WORD_SIZE);
    xil_printf(" waiting for txDone... \r\n");
	/* Check for Transmission completion */
	//while( !(XLlFifo_IsTxDone(InstancePtr)) ){

	//}
	xil_printf("txDone... \r\n");


	/* Transmission Complete */
	return XST_SUCCESS;
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

	xil_printf(" Receiving data ....\n\r");
	/* Read Recieve Length */
	ReceiveLength = (XLlFifo_iRxGetLen(InstancePtr))/WORD_SIZE;
	xil_printf("receive length:%d\n", ReceiveLength);

	/* Start Receiving */
	for ( i=0; i < ReceiveLength; i++){
		RxWord = 0;
		RxWord = XLlFifo_RxGetWord(InstancePtr);
		xil_printf("%08x\n", RxWord);


		if(XLlFifo_iRxOccupancy(InstancePtr)){
			RxWord = XLlFifo_RxGetWord(InstancePtr);
		}
		//fix endianess

//		tmp =   (RxWord & 0x000000FF) << 24 | //byte3
//				(RxWord & 0x0000FF00) << 8  |
//				(RxWord & 0x00FF0000) >> 8  |
//				(RxWord & 0xFF000000) >> 24 ;  //byte0
		*(DestinationAddr+i) = RxWord;
	}
   xil_printf("waiting rx done");
	Status = XLlFifo_IsRxDone(InstancePtr);
	if(Status != TRUE){
		xil_printf("Failing in receive complete ... \r\n");
		return XST_FAILURE;
	}

	return XST_SUCCESS;
}



#ifdef XPAR_UARTNS550_0_BASEADDR
/*****************************************************************************/
/*
*
* Uart16550 setup routine, need to set baudrate to 9600 and data bits to 8
*
* @param	None
*
* @return	None
*
* @note		None
*
******************************************************************************/
static void Uart550_Setup(void)
{

	XUartNs550_SetBaud(XPAR_UARTNS550_0_BASEADDR,
			XPAR_XUARTNS550_CLOCK_HZ, 9600);

	XUartNs550_SetLineControlReg(XPAR_UARTNS550_0_BASEADDR,
			XUN_LCR_8_DATA_BITS);
}
#endif
 
