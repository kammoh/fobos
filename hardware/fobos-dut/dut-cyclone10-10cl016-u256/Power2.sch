EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 9 9
Title "FOBOS Cyclone-10 cl016 DUT"
Date "2022-04-30"
Rev "1.0"
Comp "Cryptographic Engineering Research Group"
Comment1 "License: Apache License Version 2.0"
Comment2 "Copyright © Cryptographic Engineering Research Group"
Comment3 "Author: Jens-Peter Kaps, Eddie Ferrufino"
Comment4 "Project: FOBOS Cyclone-10 cl016 DUT"
$EndDescr
$Comp
L cerg:MAX8560EZK+T U12
U 1 1 628BBCF6
P 5050 2500
F 0 "U12" H 5250 2550 50  0000 C CNN
F 1 "MAX8560EZK+T" H 5250 1850 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:TSOT-23-5_HandSoldering" H 5050 2550 50  0001 C CNN
F 3 "https://www.digikey.com/en/products/detail/analog-devices-inc-maxim-integrated/MAX8560EZK-T/1517933" H 5050 2550 50  0001 C CNN
	1    5050 2500
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 628BE068
P 4500 2750
AR Path="/5F227C5D/628BE068" Ref="C?"  Part="1" 
AR Path="/5F449901/628BE068" Ref="C?"  Part="1" 
AR Path="/628A5EBF/628BE068" Ref="C63"  Part="1" 
F 0 "C63" H 4615 2796 50  0000 L CNN
F 1 "2u2" H 4615 2705 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 4538 2600 50  0001 C CNN
F 3 "~" H 4500 2750 50  0001 C CNN
F 4 "CAP CER 2.2UF 6.3V X7R 0805" H 4500 2750 50  0001 C CNN "Description"
F 5 "885012207001" H 4500 2750 50  0001 C CNN "MPN"
F 6 "Würth Elektronik" H 4500 2750 50  0001 C CNN "Manufacturer"
	1    4500 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 628BF750
P 5700 2750
AR Path="/5F449901/628BF750" Ref="R?"  Part="1" 
AR Path="/628A5EBF/628BF750" Ref="R30"  Part="1" 
F 0 "R30" H 5550 2700 50  0000 C CNN
F 1 "95KR" H 5550 2800 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5630 2750 50  0001 C CNN
F 3 "~" H 5700 2750 50  0001 C CNN
F 4 "RES SMD 95K OHM 1% 1/10W 0603" H 5700 2750 50  0001 C CNN "Description"
F 5 "" H 5700 2750 50  0001 C CNN "MPN"
F 6 "" H 5700 2750 50  0001 C CNN "Manufacturer"
	1    5700 2750
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 628BF916
P 5700 3200
AR Path="/5F449901/628BF916" Ref="R?"  Part="1" 
AR Path="/628A5EBF/628BF916" Ref="R34"  Part="1" 
F 0 "R34" H 5550 3150 50  0000 C CNN
F 1 "30KR" H 5550 3250 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5630 3200 50  0001 C CNN
F 3 "~" H 5700 3200 50  0001 C CNN
F 4 "RES SMD 30K OHM 1% 1/10W 0603" H 5700 3200 50  0001 C CNN "Description"
F 5 "" H 5700 3200 50  0001 C CNN "MPN"
F 6 "" H 5700 3200 50  0001 C CNN "Manufacturer"
	1    5700 3200
	-1   0    0    1   
$EndComp
$Comp
L Device:L L?
U 1 1 628D2413
P 6150 2600
AR Path="/5F449901/628D2413" Ref="L?"  Part="1" 
AR Path="/628A5EBF/628D2413" Ref="L6"  Part="1" 
F 0 "L6" V 6250 2600 50  0000 C CNN
F 1 "1.5uH" V 6100 2600 50  0000 C CNN
F 2 "cerg:L_SRN2012" H 6150 2600 50  0001 C CNN
F 3 "https://www.mouser.com/ProductDetail/Bourns/SRN2012-1R5M/?qs=U0ECReq1GB%2FS6CSJ%2FWDZfQ%3D%3D" H 6150 2600 50  0001 C CNN
F 4 "SRN2012-1R5M" V 6150 2600 50  0001 C CNN "MPN"
F 5 "FIXED IND 1.5UH 1.8A 108MOHM SMD" H 6150 2600 50  0001 C CNN "Description"
F 6 "Bourns Inc." H 6150 2600 50  0001 C CNN "Manufacturer"
	1    6150 2600
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR?
U 1 1 628D49FF
P 5700 3450
AR Path="/5B6DA40D/628D49FF" Ref="#PWR?"  Part="1" 
AR Path="/5B6C87CC/628D49FF" Ref="#PWR?"  Part="1" 
AR Path="/5BE3725D/628D49FF" Ref="#PWR?"  Part="1" 
AR Path="/5F227C5D/628D49FF" Ref="#PWR?"  Part="1" 
AR Path="/5F449901/628D49FF" Ref="#PWR?"  Part="1" 
AR Path="/628A5EBF/628D49FF" Ref="#PWR053"  Part="1" 
F 0 "#PWR053" H 5700 3200 50  0001 C CNN
F 1 "GND" H 5705 3277 50  0000 C CNN
F 2 "" H 5700 3450 50  0001 C CNN
F 3 "" H 5700 3450 50  0001 C CNN
	1    5700 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	5550 2600 5700 2600
Wire Wire Line
	5550 2800 5600 2800
Wire Wire Line
	5600 2800 5600 3000
Wire Wire Line
	5600 3000 5700 3000
Wire Wire Line
	5700 3000 5700 2900
Wire Wire Line
	5700 3050 5700 3000
Connection ~ 5700 3000
Wire Wire Line
	5700 3350 5700 3400
Wire Wire Line
	5700 2600 6000 2600
Connection ~ 5700 2600
$Comp
L Device:C C?
U 1 1 628D73A0
P 6000 3000
AR Path="/5F227C5D/628D73A0" Ref="C?"  Part="1" 
AR Path="/5F449901/628D73A0" Ref="C?"  Part="1" 
AR Path="/628A5EBF/628D73A0" Ref="C64"  Part="1" 
F 0 "C64" V 6050 3050 50  0000 L CNN
F 1 "150pF" V 6050 2700 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 6038 2850 50  0001 C CNN
F 3 "~" H 6000 3000 50  0001 C CNN
F 4 "CAP CER 0603 150PF 100V ULTRA ST" H 6000 3000 50  0001 C CNN "Description"
F 5 "C0603C151F1HAC7867" H 6000 3000 50  0001 C CNN "MPN"
F 6 "KEMET" H 6000 3000 50  0001 C CNN "Manufacturer"
	1    6000 3000
	0    -1   -1   0   
$EndComp
Wire Wire Line
	5850 3000 5700 3000
Wire Wire Line
	6150 3000 6400 3000
Wire Wire Line
	6400 3000 6400 2600
Wire Wire Line
	6400 2600 6300 2600
$Comp
L Device:C C?
U 1 1 628D790D
P 6600 2950
AR Path="/5F227C5D/628D790D" Ref="C?"  Part="1" 
AR Path="/5F449901/628D790D" Ref="C?"  Part="1" 
AR Path="/628A5EBF/628D790D" Ref="C65"  Part="1" 
F 0 "C65" H 6715 2996 50  0000 L CNN
F 1 "2u2" H 6715 2905 50  0000 L CNN
F 2 "Capacitor_SMD:C_0805_2012Metric" H 6638 2800 50  0001 C CNN
F 3 "~" H 6600 2950 50  0001 C CNN
F 4 "CAP CER 2.2UF 6.3V X7R 0805" H 6600 2950 50  0001 C CNN "Description"
F 5 "885012207001" H 6600 2950 50  0001 C CNN "MPN"
F 6 "Würth Elektronik" H 6600 2950 50  0001 C CNN "Manufacturer"
	1    6600 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	5700 3400 6600 3400
Wire Wire Line
	6600 3400 6600 3100
Connection ~ 5700 3400
Wire Wire Line
	5700 3400 5700 3450
Wire Wire Line
	6400 2600 6600 2600
Wire Wire Line
	6600 2600 6600 2800
Connection ~ 6400 2600
Wire Wire Line
	4950 2600 4500 2600
$Comp
L power:GND #PWR?
U 1 1 628D919A
P 4500 3450
AR Path="/5B6DA40D/628D919A" Ref="#PWR?"  Part="1" 
AR Path="/5B6C87CC/628D919A" Ref="#PWR?"  Part="1" 
AR Path="/5BE3725D/628D919A" Ref="#PWR?"  Part="1" 
AR Path="/5F227C5D/628D919A" Ref="#PWR?"  Part="1" 
AR Path="/5F449901/628D919A" Ref="#PWR?"  Part="1" 
AR Path="/628A5EBF/628D919A" Ref="#PWR052"  Part="1" 
F 0 "#PWR052" H 4500 3200 50  0001 C CNN
F 1 "GND" H 4505 3277 50  0000 C CNN
F 2 "" H 4500 3450 50  0001 C CNN
F 3 "" H 4500 3450 50  0001 C CNN
	1    4500 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 2800 4850 2800
$Comp
L power:+2V5_PLL #PWR?
U 1 1 628DB450
P 6600 2500
AR Path="/60D2F94F/628DB450" Ref="#PWR?"  Part="1" 
AR Path="/628A5EBF/628DB450" Ref="#PWR056"  Part="1" 
F 0 "#PWR056" H 6600 2350 50  0001 C CNN
F 1 "+2V5_PLL" H 6615 2673 50  0000 C CNN
F 2 "" H 6600 2500 50  0001 C CNN
F 3 "" H 6600 2500 50  0001 C CNN
	1    6600 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	6600 2500 6600 2600
Connection ~ 6600 2600
$Comp
L power:+5V #PWR?
U 1 1 628DD62D
P 4500 2500
AR Path="/5F449901/628DD62D" Ref="#PWR?"  Part="1" 
AR Path="/628A5EBF/628DD62D" Ref="#PWR051"  Part="1" 
F 0 "#PWR051" H 4500 2350 50  0001 C CNN
F 1 "+5V" H 4515 2673 50  0000 C CNN
F 2 "" H 4500 2500 50  0001 C CNN
F 3 "" H 4500 2500 50  0001 C CNN
	1    4500 2500
	1    0    0    -1  
$EndComp
Wire Wire Line
	4500 2500 4500 2600
Connection ~ 4500 2600
$Comp
L Device:R R?
U 1 1 628E3FDF
P 4100 2750
AR Path="/5F449901/628E3FDF" Ref="R?"  Part="1" 
AR Path="/628A5EBF/628E3FDF" Ref="R77"  Part="1" 
F 0 "R77" V 3893 2750 50  0000 C CNN
F 1 "10KR" V 3984 2750 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 4030 2750 50  0001 C CNN
F 3 "~" H 4100 2750 50  0001 C CNN
F 4 "RES SMD 10K OHM 1% 1/10W 0603" H 4100 2750 50  0001 C CNN "Description"
F 5 "ERJ-3EKF1002V" H 4100 2750 50  0001 C CNN "MPN"
F 6 "Panasonic Electronic Components" H 4100 2750 50  0001 C CNN "Manufacturer"
	1    4100 2750
	-1   0    0    1   
$EndComp
Wire Wire Line
	4950 3000 4100 3000
Wire Wire Line
	4100 3000 4100 2900
Wire Wire Line
	4100 2600 4500 2600
Wire Wire Line
	4500 2900 4500 3450
Wire Wire Line
	4500 2900 4850 2900
Wire Wire Line
	4850 2900 4850 2800
Connection ~ 4500 2900
$EndSCHEMATC
