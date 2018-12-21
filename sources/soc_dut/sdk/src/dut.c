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
/***************************** Include Files *********************************/
#include "xaxidma.h"
#include "xparameters.h"
#include "xil_exception.h"
#include "xdebug.h"
#include "FWFT_to_M_AXIS_2clk.h"
#ifdef XPAR_INTC_0_DEVICE_ID
 #include "xintc.h"
#else
 #include "xscugic.h"
#endif
/*****************************************************************************/
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

/*****************************DMA***********************************************/
/************************** Constant Definitions *****************************/
#define DMA_DEV_ID			XPAR_AXIDMA_0_DEVICE_ID

#ifdef XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR		XPAR_AXI_7SDDR_0_S_AXI_BASEADDR
#elif XPAR_MIG7SERIES_0_BASEADDR
#define DDR_BASE_ADDR		XPAR_MIG7SERIES_0_BASEADDR
#elif XPAR_MIG_0_BASEADDR
#define DDR_BASE_ADDR		XPAR_MIG_0_BASEADDR
#elif XPAR_PSU_DDR_0_S_AXI_BASEADDR
#define DDR_BASE_ADDR		XPAR_PSU_DDR_0_S_AXI_BASEADDR
#endif

#ifndef DDR_BASE_ADDR
#warning CHECK FOR THE VALID DDR ADDRESS IN XPARAMETERS.H, \
	DEFAULT SET TO 0x01000000
#define MEM_BASE_ADDR		0x01000000
#else
#define MEM_BASE_ADDR		(DDR_BASE_ADDR + 0x1000000)
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
#define RX_INTR_ID			XPAR_INTC_0_AXIDMA_0_S2MM_INTROUT_VEC_ID
#define TX_INTR_ID			XPAR_INTC_0_AXIDMA_0_MM2S_INTROUT_VEC_ID
#else
#define RX_INTR_ID			XPAR_FABRIC_AXI_DMA_0_S2MM_INTROUT_INTR
#define TX_INTR_ID			XPAR_FABRIC_AXI_DMA_0_MM2S_INTROUT_INTR
#endif

#define TX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00100000)
#define RX_BUFFER_BASE		(MEM_BASE_ADDR + 0x00300000)
#define RX_BUFFER_HIGH		(MEM_BASE_ADDR + 0x004FFFFF)

#ifdef XPAR_INTC_0_DEVICE_ID
#define INTC_DEVICE_ID      XPAR_INTC_0_DEVICE_ID
#else
#define INTC_DEVICE_ID      XPAR_SCUGIC_SINGLE_DEVICE_ID
#endif

#ifdef XPAR_INTC_0_DEVICE_ID
 #define INTC		XIntc
 #define INTC_HANDLER	XIntc_InterruptHandler
#else
 #define INTC		XScuGic
 #define INTC_HANDLER	XScuGic_InterruptHandler
#endif

#define RESET_TIMEOUT_COUNTER	10000

#define TEST_START_VALUE	0xC

#define OUTPUT_LEN			16
#define PDI_LEN				16
#define SDI_LEN				16

#define NUMBER_OF_TRANSFERS	10

/************************** Function Prototypes ******************************/
#ifndef DEBUG
extern void xil_printf(const char *format, ...);
#endif

#ifdef XPAR_UARTNS550_0_BASEADDR
static void Uart550_Setup(void);
#endif

static int CheckData(int Length, u8 StartValue);
static void TxIntrHandler(void *Callback);
static void RxIntrHandler(void *Callback);
static int SetupIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 TxIntrId, u16 RxIntrId);
static void DisableIntrSystem(INTC * IntcInstancePtr,
					u16 TxIntrId, u16 RxIntrId);
/************************** Variable Definitions *****************************/

static XAxiDma AxiDma;		/* Instance of the XAxiDma */
static INTC Intc;	/* Instance of the Interrupt Controller */
/*
 * Flags interrupt handlers use to notify the application context the events.
 */
volatile int TxDone;
volatile int RxDone;
volatile int Error;
/******************************************************************************/
int initDMA(){
 	int Status;
		XAxiDma_Config *Config;

		/* Initial setup for Uart16550 */
		xil_printf("\r\n--- Entering main() --- \r\n");
		Config = XAxiDma_LookupConfig(DMA_DEV_ID);
		if (!Config) {
			xil_printf("No config found for %d\r\n", DMA_DEV_ID);
			return XST_FAILURE;
		}
		/* Initialize DMA engine */
		Status = XAxiDma_CfgInitialize(&AxiDma, Config);

		if (Status != XST_SUCCESS) {
			xil_printf("Initialization failed %d\r\n", Status);
			return XST_FAILURE;
		}

		if(XAxiDma_HasSg(&AxiDma)){
			xil_printf("Device configured as SG mode \r\n");
			return XST_FAILURE;
		}

		/* Set up Interrupt system  */
		Status = SetupIntrSystem(&Intc, &AxiDma, TX_INTR_ID, RX_INTR_ID);
		if (Status != XST_SUCCESS) {

			xil_printf("Failed intr setup\r\n");
			return XST_FAILURE;
		}

		/* Disable all interrupts before setup */

		XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
							XAXIDMA_DMA_TO_DEVICE);

		XAxiDma_IntrDisable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
					XAXIDMA_DEVICE_TO_DMA);

		/* Enable all interrupts */
		XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
								XAXIDMA_DMA_TO_DEVICE);


		XAxiDma_IntrEnable(&AxiDma, XAXIDMA_IRQ_ALL_MASK,
								XAXIDMA_DEVICE_TO_DMA);

}

int sendPdiData(u8* TxBufferPtr, u8* RxBufferPtr){
			int Status;
			TxDone = 0;
			RxDone = 0;
		    Error = 0;
		    Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, PDI_LEN);
		    #ifdef __aarch64__
		    	Xil_DCacheFlushRange((UINTPTR)RxBufferPtr, OUTPUT_LEN);
		    #endif
		    showData(TxBufferPtr, PDI_LEN);
			Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) RxBufferPtr,
						OUTPUT_LEN, XAXIDMA_DEVICE_TO_DMA);

			if (Status != XST_SUCCESS) {
				return XST_FAILURE;
			}

			Status = XAxiDma_SimpleTransfer(&AxiDma,(UINTPTR) TxBufferPtr,
						PDI_LEN, XAXIDMA_DMA_TO_DEVICE);

			if (Status != XST_SUCCESS) {
				return XST_FAILURE;
			}
			while (!TxDone || !RxDone );
			//Show data
			if (Error) {
				xil_printf("Failed test transmit%s done, "
				"receive%s done\r\n", TxDone? "":" not",
								RxDone? "":" not");
				return XST_FAILURE;
			}

			Xil_DCacheInvalidateRange((UINTPTR)RxBufferPtr, OUTPUT_LEN);
			xil_printf("Ciphertext :\n");
		   showData(RxBufferPtr, OUTPUT_LEN);

}

int main(void)
{
	int Status;
	int Tries = NUMBER_OF_TRANSFERS;
	int Index;
	initDMA();
	u8 tv[16] = {0xFF,  0xEE, 0xDD, 0xCC, 0xBB, 0xAA, 0x99, 0x88, 0x77, 0x66, 0x55, 0x44, 0x33, 0x22, 0x11, 0x00};
	u8 *TxBufferPtr;
	u8 *RxBufferPtr;
	u8 Value;
	TxBufferPtr = (u8 *)TX_BUFFER_BASE ;
	RxBufferPtr = (u8 *)RX_BUFFER_BASE;
	/* Initialize flags before start transfer test  */
	TxDone = 0;
	RxDone = 0;
	Error = 0;

	Value = TEST_START_VALUE;

	for(Index = 0; Index < PDI_LEN; Index ++) {
		TxBufferPtr[Index] = tv[Index];
	}

	for(Index = 0; Index < OUTPUT_LEN; Index ++) {
		RxBufferPtr[Index] = 0;
	}

	/* Flush the SrcBuffer before the DMA transfer, in case the Data Cache
	 * is enabled
	 */
	Xil_DCacheFlushRange((UINTPTR)TxBufferPtr, PDI_LEN);
//#ifdef __aarch64__
	Xil_DCacheFlushRange((UINTPTR)RxBufferPtr, OUTPUT_LEN);
//#endif

	/* Send a packet */
	//set expected output len and start count
	FWFT_TO_M_AXIS_2CLK_mWriteReg(XPAR_FWFT_TO_M_AXIS_2CLK_0_S00_AXI_BASEADDR, 0 , OUTPUT_LEN /4); //NUMBER OF OUTPUT WORDS
	FWFT_TO_M_AXIS_2CLK_mWriteReg(XPAR_FWFT_TO_M_AXIS_2CLK_0_S00_AXI_BASEADDR, 4 , 0x00); // START COUNT


	for(Index = 0; Index < Tries; Index ++){
		TxBufferPtr[0] = Index;
		sendPdiData(TxBufferPtr, RxBufferPtr);
	}
	xil_printf("Successfully ran AXI DMA interrupt Example\r\n");
	/* Disable TX and RX Ring interrupts and return success */

	DisableIntrSystem(&Intc, TX_INTR_ID, RX_INTR_ID);

Done:
	xil_printf("--- Exiting main() --- \r\n");

	return XST_SUCCESS;
}

/*****************************************************************************/
//int main()
//{
//	int status;
//	xil_printf("--- Entering main() ---\n\r");
//	init();
//	status = run();
//	if (status != XST_SUCCESS) {
//		xil_printf("Process Failed\n\r");
//		xil_printf("--- Exiting main() ---\n\r");
//		return XST_FAILURE;
//	}
//	xil_printf("Successfully ran.\n\r");
//	xil_printf("--- Exiting main() ---\n\r");
//
//	return XST_SUCCESS;
//}

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

/*************************************DMA FUNCTIONS*********************/



void showData(u8* buffer, int len){
	int i;
	for(i = len-1; i>=0; i--)
		xil_printf("%02x", buffer[i]);
	xil_printf("\n");

}

/******************************************************************************/
/******************************************************************************/
static void TxIntrHandler(void *Callback)
{

	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DMA_TO_DEVICE);

	/* Acknowledge pending interrupts */


	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DMA_TO_DEVICE);

	/*
	 * If no interrupt is asserted, we do not do anything
	 */
	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {

		return;
	}

	/*
	 * If error interrupt is asserted, raise error flag, reset the
	 * hardware to recover from the error, and return with no further
	 * processing.
	 */
	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {

		Error = 1;

		/*
		 * Reset should never fail for transmit channel
		 */
		XAxiDma_Reset(AxiDmaInst);

		TimeOut = RESET_TIMEOUT_COUNTER;

		while (TimeOut) {
			if (XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}

			TimeOut -= 1;
		}

		return;
	}

	/*
	 * If Completion interrupt is asserted, then set the TxDone flag
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {

		TxDone = 1;
	}
}


static void RxIntrHandler(void *Callback)
{
	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;

	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DEVICE_TO_DMA);

	/* Acknowledge pending interrupts */
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DEVICE_TO_DMA);

	/*
	 * If no interrupt is asserted, we do not do anything
	 */
	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
		return;
	}

	/*
	 * If error interrupt is asserted, raise error flag, reset the
	 * hardware to recover from the error, and return with no further
	 * processing.
	 */
	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {

		Error = 1;

		/* Reset could fail and hang
		 * NEED a way to handle this or do not call it??
		 */
		XAxiDma_Reset(AxiDmaInst);

		TimeOut = RESET_TIMEOUT_COUNTER;

		while (TimeOut) {
			if(XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}

			TimeOut -= 1;
		}

		return;
	}

	/*
	 * If completion interrupt is asserted, then set RxDone flag
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {

		RxDone = 1;
	}
}


static int SetupIntrSystem(INTC * IntcInstancePtr,
			   XAxiDma * AxiDmaPtr, u16 TxIntrId, u16 RxIntrId)
{
	int Status;

#ifdef XPAR_INTC_0_DEVICE_ID

	/* Initialize the interrupt controller and connect the ISRs */
	Status = XIntc_Initialize(IntcInstancePtr, INTC_DEVICE_ID);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed init intc\r\n");
		return XST_FAILURE;
	}

	Status = XIntc_Connect(IntcInstancePtr, TxIntrId,
			       (XInterruptHandler) TxIntrHandler, AxiDmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed tx connect intc\r\n");
		return XST_FAILURE;
	}

	Status = XIntc_Connect(IntcInstancePtr, RxIntrId,
			       (XInterruptHandler) RxIntrHandler, AxiDmaPtr);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed rx connect intc\r\n");
		return XST_FAILURE;
	}

	/* Start the interrupt controller */
	Status = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
	if (Status != XST_SUCCESS) {

		xil_printf("Failed to start intc\r\n");
		return XST_FAILURE;
	}

	XIntc_Enable(IntcInstancePtr, TxIntrId);
	XIntc_Enable(IntcInstancePtr, RxIntrId);

#else

	XScuGic_Config *IntcConfig;


	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}

	Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
					IntcConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}


	XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA0, 0x3);

	XScuGic_SetPriorityTriggerType(IntcInstancePtr, RxIntrId, 0xA0, 0x3);
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	Status = XScuGic_Connect(IntcInstancePtr, TxIntrId,
				(Xil_InterruptHandler)TxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	Status = XScuGic_Connect(IntcInstancePtr, RxIntrId,
				(Xil_InterruptHandler)RxIntrHandler,
				AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}

	XScuGic_Enable(IntcInstancePtr, TxIntrId);
	XScuGic_Enable(IntcInstancePtr, RxIntrId);


#endif

	/* Enable interrupts from the hardware */

	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
			(Xil_ExceptionHandler)INTC_HANDLER,
			(void *)IntcInstancePtr);

	Xil_ExceptionEnable();

	return XST_SUCCESS;
}

static void DisableIntrSystem(INTC * IntcInstancePtr,
					u16 TxIntrId, u16 RxIntrId)
{
#ifdef XPAR_INTC_0_DEVICE_ID
	/* Disconnect the interrupts for the DMA TX and RX channels */
	XIntc_Disconnect(IntcInstancePtr, TxIntrId);
	XIntc_Disconnect(IntcInstancePtr, RxIntrId);
#else
	XScuGic_Disconnect(IntcInstancePtr, TxIntrId);
	XScuGic_Disconnect(IntcInstancePtr, RxIntrId);
#endif
}

