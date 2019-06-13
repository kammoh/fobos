//SOC-DUT software controller
//Author: Bakry Abdulgadir
//Date  : Dec. 2018
//George Mason University
/***************************** Include Files *********************************/
#include "xparameters.h"
#include "xil_exception.h"
#include "xstreamer.h"
#include "xil_cache.h"
#include "xllfifo.h"
#include "xstatus.h"
#include "ctrlComm.h"

/***************** Macros (inline Functions) Definitions *********************/
#define FIFO_DUTCOM_DEV_ID	   	XPAR_AXI_FIFO_1_DEVICE_ID
#define FIFO_CTLCOM_DEV_ID	   	XPAR_AXI_FIFO_0_DEVICE_ID
#define WORD_SIZE				4							/* Size of words in bytes */
#define MAX_PACKET_LEN		 	12
#define NO_OF_PACKETS		 	1
#define MAX_DATA_BUFFER_SIZE 	NO_OF_PACKETS*MAX_PACKET_LEN
#define CTLCOMM_BASE 			XPAR_CTRLCOMM_0_S_AXI_BASEADDR
#undef DEBUG
/*****************************************************************************/
#define WAIT_RES				0x1a /*status from*/
/************************** Function Prototypes ******************************/
int init();
int run();
int fifoSend(XLlFifo *InstancePtr, u32 *SourceAddr, u32 cnt);
int fifoReceive(XLlFifo *InstancePtr, u32 *DestinationAddr);
void clearDestBuf();
/************************** Variable Definitions *****************************/
XLlFifo fifoInstance_dutcom;
XLlFifo fifoInstance_ctrlcom;
/*****************************************************************************/
u32 srcBuf[MAX_DATA_BUFFER_SIZE * WORD_SIZE];
u32 destBuf[MAX_DATA_BUFFER_SIZE * WORD_SIZE];
u32 testBuf[12] =
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

/*****************************************************************************/
int main()
{
	int status;
	xil_printf("--- Entering main() ---\n\r");
	init();
	status = run();
	if (status != XST_SUCCESS) {
		xil_printf("Process Failed\n\r");
		xil_printf("--- Exiting main() ---\n\r");
		return XST_FAILURE;
	}
	xil_printf("Successfully ran.\n\r");
	xil_printf("--- Exiting main() ---\n\r");

	return XST_SUCCESS;
}

/*****************************************************************************/
void clearDestBuf(){
	int i;
	for(i=0; i<MAX_DATA_BUFFER_SIZE; i++) destBuf[i] = 0;
}

int init(){
	u16 devID;
	XLlFifo_Config *config;
	int status;

	status = XST_SUCCESS;

	/*Init ctrlcomm fifo *****************************************************/
	// Initialize the Device Configuration Interface driver */

	devID = FIFO_CTLCOM_DEV_ID;
	config = XLlFfio_LookupConfig(devID);
	if (!config) {
		xil_printf("No config found for %d\r\n", devID);
		return XST_FAILURE;
	}

	status = XLlFifo_CfgInitialize(&fifoInstance_ctrlcom, config, config->BaseAddress);
	if (status != XST_SUCCESS) {
		xil_printf("Initialization failed\n\r");
		return status;
	}

	status = XLlFifo_Status(&fifoInstance_ctrlcom);
	XLlFifo_IntClear(&fifoInstance_ctrlcom,0xffffffff);
	status = XLlFifo_Status(&fifoInstance_ctrlcom);
	if(status != 0x0) {
		xil_printf("\n error : Reset value of ISR0 : 0x%x\t"
				    "Expected : 0x0\n\r",
				    XLlFifo_Status(&fifoInstance_ctrlcom));
		return XST_FAILURE;
	}
	return status;
}

int run()
{
	int status;
	long j;
	
	status = XST_SUCCESS;
	///////////////////////////////////////////////////////////////////
    while(1){
		CTRLCOMM_mWriteReg(CTLCOMM_BASE, 0, 0); // my not be needed since FIOF sends only when a PACKET LEN is written
		//xil_printf("\ninside while(1)\n");
		//wait until status = WAIT_RES
		while((CTRLCOMM_mReadReg(CTLCOMM_BASE, 4) &0x000000FF ) != WAIT_RES){
			//xil_printf("status:%02x\n", CTRLCOMM_mReadReg(CTLCOMM_BASE, 4) & 0x000000FF);
			//for(j = 0; j<500000; j++);
		}
		//for(j = 0; j<500000; j++);
		clearDestBuf();
		// Revceive the Data Stream FORM CTRL_COM
		//from ctrl_comm
		status = fifoReceive(&fifoInstance_ctrlcom, destBuf);
		if (status != XST_SUCCESS){
			xil_printf("Receiving data failed");
			return XST_FAILURE;
		}
		//process the data
		//here

		//NOW, return result

		//push data in to the fifo
		xil_printf("Sending back result...\n");
		status = fifoSend(&fifoInstance_ctrlcom, destBuf, MAX_PACKET_LEN);
		if (status != XST_SUCCESS){
				xil_printf("Transmisson of Data failed\n\r");
				return XST_FAILURE;
		}

		// assert result ready// may not be needed

		CTRLCOMM_mWriteReg(CTLCOMM_BASE, 0, 1);
		for(j = 0; j<5000; j++);
    }

	return status;
}

/******************************************************************************/
int fifoSend(XLlFifo *InstancePtr, u32  *SourceAddr, u32 cnt)
{
	int j;
	u32 data;
	for (j=0 ; j < cnt ; j++){
		if( XLlFifo_iTxVacancy(InstancePtr) ){
			data = *(SourceAddr +j);
			XLlFifo_TxPutWord(InstancePtr, data);
			xil_printf("%08x\n", data);
		}
	}
	/* Start transmission by writing TLR */
	XLlFifo_iTxSetLen(InstancePtr, cnt * WORD_SIZE);
    xil_printf(" waiting for txDone... \r\n");
	//while( !(XLlFifo_IsTxDone(InstancePtr)) ){
	//}
	xil_printf("txDone... \r\n");
	return XST_SUCCESS;
}

/******************************************************************************/
int fifoReceive (XLlFifo *InstancePtr, u32* DestinationAddr)
{
	int i;
	int status;
	u32 data;
	static u32 ReceiveLength;

	xil_printf(" Receiving data ....\n\r");
	/* Read Receive Length */
	ReceiveLength = (XLlFifo_iRxGetLen(InstancePtr))/WORD_SIZE;
	xil_printf("receive length:%d\n", ReceiveLength);
	/* Start Receiving */
	for ( i=0; i < ReceiveLength; i++){
		data = 0;
		data = XLlFifo_RxGetWord(InstancePtr);
		xil_printf("%08x\n", data);

		if(XLlFifo_iRxOccupancy(InstancePtr)){
			data = XLlFifo_RxGetWord(InstancePtr);
		}

		*(DestinationAddr+i) = data;
	}
   xil_printf("waiting rx done\n");
   status = XLlFifo_IsRxDone(InstancePtr);
   if(status != TRUE){
	   xil_printf("Failing in receive complete ... \r\n");
	   return XST_FAILURE;
	}

	return XST_SUCCESS;
}
