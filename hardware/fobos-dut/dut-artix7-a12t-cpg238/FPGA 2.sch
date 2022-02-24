EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 8 8
Title "FOBOS Artix-7 a12t DUT - FPGA Part 2"
Date ""
Rev "1.0"
Comp "Cryptographic Engineering Research Group"
Comment1 "License: Apache License Version 2.0"
Comment2 "Copyright © Cryptographic Engineering Research Group"
Comment3 "Author: Jens-Peter Kaps, Eddie Ferrufino"
Comment4 "Project: FOBOS Artix-7 a12t DUT"
$EndDescr
Wire Wire Line
	7050 800  7050 950 
$Comp
L power:+3V3 #PWR?
U 1 1 60388712
P 7050 800
AR Path="/5F3A1954/60388712" Ref="#PWR?"  Part="1" 
AR Path="/6004C151/60388712" Ref="#PWR0149"  Part="1" 
F 0 "#PWR0149" H 7050 650 50  0001 C CNN
F 1 "+3V3" H 7065 973 50  0000 C CNN
F 2 "" H 7050 800 50  0001 C CNN
F 3 "" H 7050 800 50  0001 C CNN
	1    7050 800 
	1    0    0    -1  
$EndComp
Text GLabel 5000 5150 0    50   Input ~ 0
VCORE_CURRENT_GAIN_0
Text GLabel 5000 5250 0    50   Input ~ 0
VCORE_CURRENT_GAIN_1
$Comp
L cerg:XC7A12T-CPG238 U1
U 5 1 60C0A0EC
P 5250 1250
F 0 "U1" H 5450 -3800 50  0000 L CNN
F 1 "XC7A12T-CPG238" H 5450 -3900 50  0000 L CNN
F 2 "Package_BGA:Xilinx_CPG238" H 5250 1250 50  0001 C CNN
F 3 "" H 5250 1250 50  0001 C CNN
	5    5250 1250
	1    0    0    -1  
$EndComp
Wire Wire Line
	7350 950  7350 800 
Wire Wire Line
	7350 800  7250 800 
Connection ~ 7050 800 
Wire Wire Line
	7250 950  7250 800 
Connection ~ 7250 800 
Wire Wire Line
	7250 800  7150 800 
Wire Wire Line
	7150 950  7150 800 
Connection ~ 7150 800 
Wire Wire Line
	7150 800  7050 800 
Wire Wire Line
	6950 950  6950 800 
Wire Wire Line
	6950 800  7050 800 
Wire Wire Line
	6850 950  6850 800 
Wire Wire Line
	6850 800  6950 800 
Connection ~ 6950 800 
Wire Wire Line
	6750 950  6750 800 
Wire Wire Line
	6750 800  6850 800 
Connection ~ 6850 800 
Text Notes 1800 950  0    50   ~ 0
BANK34\nJ7, K7, L7, M7, M8, N7, N8
$Comp
L Device:C C?
U 1 1 60F8DADA
P 750 1250
AR Path="/5F3A1954/60F8DADA" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60F8DADA" Ref="C?"  Part="1" 
AR Path="/6004C151/60F8DADA" Ref="C48"  Part="1" 
F 0 "C48" H 865 1296 50  0000 L CNN
F 1 "4.7uF" H 865 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 788 1100 50  0001 C CNN
F 3 "~" H 750 1250 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 750 1250 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 750 1250 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 750 1250 50  0001 C CNN "Manufacturer"
	1    750  1250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60F8DAE3
P 1200 1250
AR Path="/5F3A1954/60F8DAE3" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60F8DAE3" Ref="C?"  Part="1" 
AR Path="/6004C151/60F8DAE3" Ref="C49"  Part="1" 
F 0 "C49" H 1315 1296 50  0000 L CNN
F 1 "4.7uF" H 1315 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1238 1100 50  0001 C CNN
F 3 "~" H 1200 1250 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1200 1250 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1200 1250 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1200 1250 50  0001 C CNN "Manufacturer"
	1    1200 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60F8DAEC
P 1750 1250
AR Path="/5F3A1954/60F8DAEC" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60F8DAEC" Ref="C?"  Part="1" 
AR Path="/6004C151/60F8DAEC" Ref="C50"  Part="1" 
F 0 "C50" H 1865 1296 50  0000 L CNN
F 1 ".47uF" H 1865 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1788 1100 50  0001 C CNN
F 3 "~" H 1750 1250 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 1750 1250 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 1750 1250 50  0001 C CNN "MPN"
F 6 "KEMET" H 1750 1250 50  0001 C CNN "Manufacturer"
	1    1750 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60F8DAF5
P 2200 1250
AR Path="/5F3A1954/60F8DAF5" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60F8DAF5" Ref="C?"  Part="1" 
AR Path="/6004C151/60F8DAF5" Ref="C51"  Part="1" 
F 0 "C51" H 2315 1296 50  0000 L CNN
F 1 ".47uF" H 2315 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2238 1100 50  0001 C CNN
F 3 "~" H 2200 1250 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2200 1250 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2200 1250 50  0001 C CNN "MPN"
F 6 "KEMET" H 2200 1250 50  0001 C CNN "Manufacturer"
	1    2200 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60F8DAFE
P 2750 1250
AR Path="/5F3A1954/60F8DAFE" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60F8DAFE" Ref="C?"  Part="1" 
AR Path="/6004C151/60F8DAFE" Ref="C52"  Part="1" 
F 0 "C52" H 2865 1296 50  0000 L CNN
F 1 ".47uF" H 2865 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2788 1100 50  0001 C CNN
F 3 "~" H 2750 1250 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2750 1250 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2750 1250 50  0001 C CNN "MPN"
F 6 "KEMET" H 2750 1250 50  0001 C CNN "Manufacturer"
	1    2750 1250
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60F8DB07
P 3300 1250
AR Path="/5F3A1954/60F8DB07" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60F8DB07" Ref="C?"  Part="1" 
AR Path="/6004C151/60F8DB07" Ref="C53"  Part="1" 
F 0 "C53" H 3415 1296 50  0000 L CNN
F 1 ".47uF" H 3415 1205 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3338 1100 50  0001 C CNN
F 3 "~" H 3300 1250 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3300 1250 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3300 1250 50  0001 C CNN "MPN"
F 6 "KEMET" H 3300 1250 50  0001 C CNN "Manufacturer"
	1    3300 1250
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60F8DB0D
P 750 1550
AR Path="/5F3A1954/60F8DB0D" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60F8DB0D" Ref="#PWR?"  Part="1" 
AR Path="/6004C151/60F8DB0D" Ref="#PWR055"  Part="1" 
F 0 "#PWR055" H 750 1300 50  0001 C CNN
F 1 "GND" H 755 1377 50  0000 C CNN
F 2 "" H 750 1550 50  0001 C CNN
F 3 "" H 750 1550 50  0001 C CNN
	1    750  1550
	1    0    0    -1  
$EndComp
Wire Wire Line
	750  1550 750  1500
Wire Wire Line
	3300 1400 3300 1500
Wire Wire Line
	3300 1500 2750 1500
Connection ~ 750  1500
Wire Wire Line
	750  1500 750  1400
Wire Wire Line
	3300 1100 3300 1000
Wire Wire Line
	3300 1000 2750 1000
Wire Wire Line
	750  1000 750  1100
Wire Wire Line
	1200 1100 1200 1000
Connection ~ 1200 1000
Wire Wire Line
	1200 1000 750  1000
Wire Wire Line
	1750 1100 1750 1000
Connection ~ 1750 1000
Wire Wire Line
	1750 1000 1200 1000
Wire Wire Line
	2200 1100 2200 1000
Connection ~ 2200 1000
Wire Wire Line
	2200 1000 1750 1000
Wire Wire Line
	2750 1100 2750 1000
Connection ~ 2750 1000
Wire Wire Line
	2750 1000 2200 1000
Wire Wire Line
	2750 1400 2750 1500
Connection ~ 2750 1500
Wire Wire Line
	2750 1500 2200 1500
Wire Wire Line
	2200 1400 2200 1500
Connection ~ 2200 1500
Wire Wire Line
	2200 1500 1750 1500
Wire Wire Line
	1750 1400 1750 1500
Connection ~ 1750 1500
Wire Wire Line
	1750 1500 1200 1500
Wire Wire Line
	1200 1400 1200 1500
Connection ~ 1200 1500
Wire Wire Line
	1200 1500 750  1500
Wire Wire Line
	750  950  750  1000
Connection ~ 750  1000
$Comp
L power:+3V3 #PWR?
U 1 1 60F8DB35
P 750 950
AR Path="/5F3A1954/60F8DB35" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60F8DB35" Ref="#PWR?"  Part="1" 
AR Path="/6004C151/60F8DB35" Ref="#PWR054"  Part="1" 
F 0 "#PWR054" H 750 800 50  0001 C CNN
F 1 "+3V3" H 765 1123 50  0000 C CNN
F 2 "" H 750 950 50  0001 C CNN
F 3 "" H 750 950 50  0001 C CNN
	1    750  950 
	1    0    0    -1  
$EndComp
Text Notes 1600 6900 0    50   ~ 0
WHEN USING MRCC PINS AS A SINGLE ENDED CLOCK, THE SIGNAL MUST BE CONNECTED TO THE POSITIVE PIN
Text GLabel 5000 4050 0    50   Input ~ 0
JA1
Text GLabel 5000 3950 0    50   Input ~ 0
JA7
Text GLabel 5000 3450 0    50   Input ~ 0
JA2
Text GLabel 5000 3350 0    50   Input ~ 0
JA8
Text GLabel 5000 3050 0    50   Input ~ 0
JA3
Text GLabel 5000 2950 0    50   Input ~ 0
JA9
Text GLabel 5000 2650 0    50   Input ~ 0
JA4
Wire Wire Line
	5000 4050 5250 4050
Wire Wire Line
	5250 3950 5000 3950
Wire Wire Line
	5250 3450 5000 3450
Wire Wire Line
	5000 3350 5250 3350
Wire Wire Line
	5000 3050 5250 3050
Wire Wire Line
	5000 2950 5250 2950
Wire Wire Line
	5000 2650 5250 2650
Text Notes 3300 2300 0    50   ~ 0
JA can be \ndifferentially\nrouted
Text GLabel 5050 2550 0    50   Input ~ 0
JA10
Wire Wire Line
	5050 2550 5250 2550
$Comp
L power:GND #PWR?
U 1 1 61EBD061
P 5100 6300
AR Path="/5F3A1954/61EBD061" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/61EBD061" Ref="#PWR?"  Part="1" 
AR Path="/6004C151/61EBD061" Ref="#PWR0135"  Part="1" 
F 0 "#PWR0135" H 5100 6050 50  0001 C CNN
F 1 "GND" H 5105 6127 50  0000 C CNN
F 2 "" H 5100 6300 50  0001 C CNN
F 3 "" H 5100 6300 50  0001 C CNN
	1    5100 6300
	1    0    0    -1  
$EndComp
Wire Wire Line
	5250 2150 5100 2150
Wire Wire Line
	5100 2150 5100 3150
Wire Wire Line
	5250 3150 5100 3150
Connection ~ 5100 3150
Wire Wire Line
	5100 3150 5100 3650
Wire Wire Line
	5250 3650 5100 3650
Connection ~ 5100 3650
Wire Wire Line
	5100 3650 5100 5050
Wire Wire Line
	5250 5050 5100 5050
Connection ~ 5100 5050
Wire Wire Line
	5100 5050 5100 5850
Wire Wire Line
	5250 5850 5100 5850
Connection ~ 5100 5850
Wire Wire Line
	5100 5850 5100 6300
Text GLabel 5000 5750 0    50   Input ~ 0
TDO
Wire Wire Line
	5250 5750 5000 5750
Wire Wire Line
	5250 1850 5000 1850
Text GLabel 5000 1850 0    50   Input ~ 0
USER_LED_3
Wire Wire Line
	5250 2050 5000 2050
Text GLabel 5000 2050 0    50   Input ~ 0
USER_LED_4
Text GLabel 5000 1750 0    50   Input ~ 0
USER_BTN_2
Text GLabel 5000 1450 0    50   Input ~ 0
USER_LED_2
Wire Wire Line
	5250 1750 5000 1750
Wire Wire Line
	5250 1450 5000 1450
Wire Wire Line
	5000 5150 5250 5150
Wire Wire Line
	5000 5250 5250 5250
$EndSCHEMATC
