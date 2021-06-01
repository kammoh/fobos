EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 8 8
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
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
Text GLabel 2250 5200 0    50   Input ~ 0
VCORE_CURRENT_GAIN_0
Text GLabel 2250 5300 0    50   Input ~ 0
VCORE_CURRENT_GAIN_1
Wire Wire Line
	2400 5300 2250 5300
Wire Wire Line
	2400 5200 2250 5200
Text GLabel 1900 6100 0    50   Input ~ 0
USER_BTN_1
Wire Wire Line
	1900 6100 2150 6100
Text GLabel 1900 3100 0    50   Input ~ 0
FC_DIO3_MUX
Text GLabel 1700 3950 0    50   Input ~ 0
FC_DIO0_MUX
Wire Wire Line
	1700 3950 1850 3950
Wire Wire Line
	1900 3100 2000 3100
Text GLabel 1600 4650 0    50   Input ~ 0
FC_RST
Text GLabel 1600 4750 0    50   Input ~ 0
FC_IO
Wire Wire Line
	1600 4750 1750 4750
Wire Wire Line
	1750 4650 1600 4650
Text GLabel 1900 3200 0    50   Input ~ 0
FC_DIO1_MUX
Wire Wire Line
	1900 3200 2000 3200
Text GLabel 1900 3600 0    50   Input ~ 0
FC2D_HS
Wire Wire Line
	2000 3600 1900 3600
Text GLabel 1700 4050 0    50   Input ~ 0
FC2D_CLK
Wire Wire Line
	1850 4050 1700 4050
Text GLabel 1900 3800 0    50   Input ~ 0
FD2C_CLK
Wire Wire Line
	2000 3800 1900 3800
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
	2000 2700 1900 2700
Text GLabel 1900 2700 0    50   Input ~ 0
FD2C_HS
Wire Wire Line
	1900 2800 2000 2800
Text GLabel 1900 2800 0    50   Input ~ 0
FC_DIO2_MUX
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
$EndSCHEMATC
