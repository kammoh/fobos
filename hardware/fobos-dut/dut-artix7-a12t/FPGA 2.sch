EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 6 7
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L cerg:XC7A12T-CSG325 U?
U 5 1 6008248E
P 3550 5850
AR Path="/5F22D594/6008248E" Ref="U?"  Part="5" 
AR Path="/6004C151/6008248E" Ref="U1"  Part="5" 
F 0 "U1" H 3550 6617 50  0000 C CNN
F 1 "XC7A12T-CSG325" H 3550 6526 50  0000 C CNN
F 2 "Package_BGA:Xilinx_CSG325" H 3550 5850 50  0001 C CNN
F 3 "https://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 3550 5850 50  0001 C CNN
F 4 "IC FPGA 150 I/O 324CSBGA" H 3550 5850 50  0001 C CNN "Description"
F 5 "XC7A12T-2CSG325I" H 3550 5850 50  0001 C CNN "MPN"
F 6 "Xilinx Inc." H 3550 5850 50  0001 C CNN "Manufacturer"
	5    3550 5850
	1    0    0    -1  
$EndComp
$Comp
L cerg:XC7A12T-CSG325 U?
U 3 1 600B58B6
P 7550 3250
AR Path="/5F22D594/600B58B6" Ref="U?"  Part="3" 
AR Path="/6004C151/600B58B6" Ref="U1"  Part="3" 
F 0 "U1" H 7550 1875 50  0000 C CNN
F 1 "XC7A12T-CSG325" H 7550 1784 50  0000 C CNN
F 2 "Package_BGA:Xilinx_CSG325" H 7550 3250 50  0001 C CNN
F 3 "https://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 7550 3250 50  0001 C CNN
F 4 "IC FPGA 150 I/O 324CSBGA" H 7550 3250 50  0001 C CNN "Description"
F 5 "XC7A12T-2CSG325I" H 7550 3250 50  0001 C CNN "MPN"
F 6 "Xilinx Inc." H 7550 3250 50  0001 C CNN "Manufacturer"
	3    7550 3250
	1    0    0    -1  
$EndComp
$Comp
L cerg:XC7A12T-CSG325 U?
U 4 1 60076E9A
P 3600 3250
AR Path="/5F22D594/60076E9A" Ref="U?"  Part="4" 
AR Path="/6004C151/60076E9A" Ref="U1"  Part="4" 
F 0 "U1" H 3600 1875 50  0000 C CNN
F 1 "XC7A12T-CSG325" H 3600 1784 50  0000 C CNN
F 2 "Package_BGA:Xilinx_CSG325" H 3600 3250 50  0001 C CNN
F 3 "https://www.xilinx.com/support/documentation/data_sheets/ds180_7Series_Overview.pdf" H 3600 3250 50  0001 C CNN
F 4 "IC FPGA 150 I/O 324CSBGA" H 3600 3250 50  0001 C CNN "Description"
F 5 "XC7A12T-2CSG325I" H 3600 3250 50  0001 C CNN "MPN"
F 6 "Xilinx Inc." H 3600 3250 50  0001 C CNN "Manufacturer"
	4    3600 3250
	1    0    0    -1  
$EndComp
Wire Wire Line
	3600 1600 3600 1750
Wire Wire Line
	7550 1600 7550 1750
$Comp
L power:+3V3 #PWR?
U 1 1 60388712
P 7550 1600
AR Path="/5F3A1954/60388712" Ref="#PWR?"  Part="1" 
AR Path="/6004C151/60388712" Ref="#PWR0149"  Part="1" 
F 0 "#PWR0149" H 7550 1450 50  0001 C CNN
F 1 "+3V3" H 7565 1773 50  0000 C CNN
F 2 "" H 7550 1600 50  0001 C CNN
F 3 "" H 7550 1600 50  0001 C CNN
	1    7550 1600
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 60388506
P 3600 1600
AR Path="/5F3A1954/60388506" Ref="#PWR?"  Part="1" 
AR Path="/6004C151/60388506" Ref="#PWR0150"  Part="1" 
F 0 "#PWR0150" H 3600 1450 50  0001 C CNN
F 1 "+3V3" H 3615 1773 50  0000 C CNN
F 2 "" H 3600 1600 50  0001 C CNN
F 3 "" H 3600 1600 50  0001 C CNN
	1    3600 1600
	1    0    0    -1  
$EndComp
Text GLabel 5900 3350 0    50   Input ~ 0
VCORE_CURRENT_GAIN_0
Text GLabel 5900 3450 0    50   Input ~ 0
VCORE_CURRENT_GAIN_1
Wire Wire Line
	6050 3450 5900 3450
Wire Wire Line
	6050 3350 5900 3350
Text GLabel 5050 4250 2    50   Input ~ 0
USER_BTN_1
Wire Wire Line
	5050 4250 4800 4250
Text GLabel 2300 3450 0    50   Input ~ 0
FC_DIO2_MUX
Text GLabel 2300 3750 0    50   Input ~ 0
FC_DIO3_MUX
Text GLabel 4950 2150 2    50   Input ~ 0
FC_DIO0_MUX
Wire Wire Line
	4950 2150 4800 2150
Wire Wire Line
	2300 3450 2400 3450
Wire Wire Line
	2300 3750 2400 3750
Text GLabel 4950 2650 2    50   Input ~ 0
FC_RST
Text GLabel 4950 2550 2    50   Input ~ 0
FC_IO
Wire Wire Line
	4950 2550 4800 2550
Wire Wire Line
	4800 2650 4950 2650
Text GLabel 2300 3850 0    50   Input ~ 0
FC_DIO1_MUX
Wire Wire Line
	2300 3850 2400 3850
Text GLabel 2300 4250 0    50   Input ~ 0
FC2D_HS
Wire Wire Line
	2400 4250 2300 4250
Text GLabel 2300 3350 0    50   Input ~ 0
FD2C_HS
Wire Wire Line
	2400 3350 2300 3350
Text GLabel 4950 2050 2    50   Input ~ 0
FC2D_CLK
Wire Wire Line
	4800 2050 4950 2050
Text GLabel 2300 4450 0    50   Input ~ 0
FD2C_CLK
Wire Wire Line
	2400 4450 2300 4450
$EndSCHEMATC
