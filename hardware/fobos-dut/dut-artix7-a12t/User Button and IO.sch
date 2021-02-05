EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 7 7
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
L dk_Transistors-FETs-MOSFETs-Single:FDV301N Q?
U 1 1 600D00C3
P 2050 3050
AR Path="/5F449901/600D00C3" Ref="Q?"  Part="1" 
AR Path="/600CE672/600D00C3" Ref="Q4"  Part="1" 
F 0 "Q4" H 2158 3103 60  0000 L CNN
F 1 "FDV301N" H 2158 2997 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 2250 3250 60  0001 L CNN
F 3 "https://www.onsemi.com/pub/Collateral/FDV301N-D.PDF" H 2250 3350 60  0001 L CNN
F 4 "FDV301NCT-ND" H 2250 3450 60  0001 L CNN "Digi-Key_PN"
F 5 "FDV301N" H 2250 3550 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 2250 3650 60  0001 L CNN "Category"
F 7 "Transistors - FETs, MOSFETs - Single" H 2250 3750 60  0001 L CNN "Family"
F 8 "https://www.onsemi.com/pub/Collateral/FDV301N-D.PDF" H 2250 3850 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/on-semiconductor/FDV301N/FDV301NCT-ND/458954" H 2250 3950 60  0001 L CNN "DK_Detail_Page"
F 10 "MOSFET N-CH 25V 220MA SOT-23" H 2250 4050 60  0001 L CNN "Description"
F 11 "ON Semiconductor" H 2250 4150 60  0001 L CNN "Manufacturer"
F 12 "Active" H 2250 4250 60  0001 L CNN "Status"
	1    2050 3050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 600D00C9
P 2050 3800
AR Path="/5F449901/600D00C9" Ref="#PWR?"  Part="1" 
AR Path="/600CE672/600D00C9" Ref="#PWR046"  Part="1" 
F 0 "#PWR046" H 2050 3550 50  0001 C CNN
F 1 "GND" H 2055 3627 50  0000 C CNN
F 2 "" H 2050 3800 50  0001 C CNN
F 3 "" H 2050 3800 50  0001 C CNN
	1    2050 3800
	1    0    0    -1  
$EndComp
$Comp
L dk_LED-Indication-Discrete:LG_L29K-G2J1-24-Z D?
U 1 1 600D00D8
P 2050 2250
AR Path="/5F449901/600D00D8" Ref="D?"  Part="1" 
AR Path="/600CE672/600D00D8" Ref="D2"  Part="1" 
F 0 "D2" V 1947 2428 60  0000 L CNN
F 1 "LG_L29K-G2J1-24-Z" V 2053 2428 60  0001 L CNN
F 2 "digikey-footprints:0603" H 2250 2450 60  0001 L CNN
F 3 "https://dammedia.osram.info/media/resource/hires/osram-dam-2493945/LG%20L29K.pdf" H 2250 2550 60  0001 L CNN
F 4 "475-2709-1-ND" H 2250 2650 60  0001 L CNN "Digi-Key_PN"
F 5 "LG L29K-G2J1-24-Z" H 2250 2750 60  0001 L CNN "MPN"
F 6 "Optoelectronics" H 2250 2850 60  0001 L CNN "Category"
F 7 "LED Indication - Discrete" H 2250 2950 60  0001 L CNN "Family"
F 8 "https://dammedia.osram.info/media/resource/hires/osram-dam-2493945/LG%20L29K.pdf" H 2250 3050 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/osram-opto-semiconductors-inc/LG-L29K-G2J1-24-Z/475-2709-1-ND/1938876" H 2250 3150 60  0001 L CNN "DK_Detail_Page"
F 10 "LED GREEN DIFFUSED 0603 SMD" H 2250 3250 60  0001 L CNN "Description"
F 11 "OSRAM Opto Semiconductors Inc." H 2250 3350 60  0001 L CNN "Manufacturer"
F 12 "Active" H 2250 3450 60  0001 L CNN "Status"
	1    2050 2250
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 600D00E4
P 2050 2600
AR Path="/5F449901/600D00E4" Ref="R?"  Part="1" 
AR Path="/600CE672/600D00E4" Ref="R57"  Part="1" 
F 0 "R57" V 2250 2600 50  0000 C CNN
F 1 "800R" V 2150 2600 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 1980 2600 50  0001 C CNN
F 3 "~" H 2050 2600 50  0001 C CNN
	1    2050 2600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2050 2850 2050 2750
Wire Wire Line
	2050 2450 2050 2350
Wire Wire Line
	1750 3150 1550 3150
Wire Wire Line
	1550 3150 1300 3150
Connection ~ 1550 3150
Wire Wire Line
	2050 1950 2050 2050
Text GLabel 1800 1800 2    50   Input ~ 0
FC_3V3
Wire Wire Line
	1800 1800 1750 1800
Wire Wire Line
	1750 1800 1750 1950
Wire Wire Line
	1750 1950 2050 1950
$Comp
L dk_Transistors-FETs-MOSFETs-Single:FDV301N Q?
U 1 1 600D0F8D
P 4100 3100
AR Path="/5F449901/600D0F8D" Ref="Q?"  Part="1" 
AR Path="/600CE672/600D0F8D" Ref="Q5"  Part="1" 
F 0 "Q5" H 4208 3153 60  0000 L CNN
F 1 "FDV301N" H 4208 3047 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 4300 3300 60  0001 L CNN
F 3 "https://www.onsemi.com/pub/Collateral/FDV301N-D.PDF" H 4300 3400 60  0001 L CNN
F 4 "FDV301NCT-ND" H 4300 3500 60  0001 L CNN "Digi-Key_PN"
F 5 "FDV301N" H 4300 3600 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 4300 3700 60  0001 L CNN "Category"
F 7 "Transistors - FETs, MOSFETs - Single" H 4300 3800 60  0001 L CNN "Family"
F 8 "https://www.onsemi.com/pub/Collateral/FDV301N-D.PDF" H 4300 3900 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/on-semiconductor/FDV301N/FDV301NCT-ND/458954" H 4300 4000 60  0001 L CNN "DK_Detail_Page"
F 10 "MOSFET N-CH 25V 220MA SOT-23" H 4300 4100 60  0001 L CNN "Description"
F 11 "ON Semiconductor" H 4300 4200 60  0001 L CNN "Manufacturer"
F 12 "Active" H 4300 4300 60  0001 L CNN "Status"
	1    4100 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 600D0F93
P 4100 3850
AR Path="/5F449901/600D0F93" Ref="#PWR?"  Part="1" 
AR Path="/600CE672/600D0F93" Ref="#PWR047"  Part="1" 
F 0 "#PWR047" H 4100 3600 50  0001 C CNN
F 1 "GND" H 4105 3677 50  0000 C CNN
F 2 "" H 4100 3850 50  0001 C CNN
F 3 "" H 4100 3850 50  0001 C CNN
	1    4100 3850
	1    0    0    -1  
$EndComp
$Comp
L dk_LED-Indication-Discrete:LG_L29K-G2J1-24-Z D?
U 1 1 600D0FA2
P 4100 2300
AR Path="/5F449901/600D0FA2" Ref="D?"  Part="1" 
AR Path="/600CE672/600D0FA2" Ref="D3"  Part="1" 
F 0 "D3" V 3997 2478 60  0000 L CNN
F 1 "LG_L29K-G2J1-24-Z" V 4103 2478 60  0001 L CNN
F 2 "digikey-footprints:0603" H 4300 2500 60  0001 L CNN
F 3 "https://dammedia.osram.info/media/resource/hires/osram-dam-2493945/LG%20L29K.pdf" H 4300 2600 60  0001 L CNN
F 4 "475-2709-1-ND" H 4300 2700 60  0001 L CNN "Digi-Key_PN"
F 5 "LG L29K-G2J1-24-Z" H 4300 2800 60  0001 L CNN "MPN"
F 6 "Optoelectronics" H 4300 2900 60  0001 L CNN "Category"
F 7 "LED Indication - Discrete" H 4300 3000 60  0001 L CNN "Family"
F 8 "https://dammedia.osram.info/media/resource/hires/osram-dam-2493945/LG%20L29K.pdf" H 4300 3100 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/osram-opto-semiconductors-inc/LG-L29K-G2J1-24-Z/475-2709-1-ND/1938876" H 4300 3200 60  0001 L CNN "DK_Detail_Page"
F 10 "LED GREEN DIFFUSED 0603 SMD" H 4300 3300 60  0001 L CNN "Description"
F 11 "OSRAM Opto Semiconductors Inc." H 4300 3400 60  0001 L CNN "Manufacturer"
F 12 "Active" H 4300 3500 60  0001 L CNN "Status"
	1    4100 2300
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 600D0FAE
P 4100 2650
AR Path="/5F449901/600D0FAE" Ref="R?"  Part="1" 
AR Path="/600CE672/600D0FAE" Ref="R58"  Part="1" 
F 0 "R58" V 4300 2650 50  0000 C CNN
F 1 "800R" V 4200 2650 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 4030 2650 50  0001 C CNN
F 3 "~" H 4100 2650 50  0001 C CNN
	1    4100 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	4100 2900 4100 2800
Wire Wire Line
	4100 2500 4100 2400
Wire Wire Line
	3800 3200 3600 3200
Wire Wire Line
	3600 3200 3350 3200
Connection ~ 3600 3200
Wire Wire Line
	4100 2000 4100 2100
Text GLabel 3850 1850 2    50   Input ~ 0
FC_3V3
Wire Wire Line
	3850 1850 3800 1850
Wire Wire Line
	3800 1850 3800 2000
Wire Wire Line
	3800 2000 4100 2000
$Comp
L dk_Transistors-FETs-MOSFETs-Single:FDV301N Q?
U 1 1 600D2B55
P 5950 3100
AR Path="/5F449901/600D2B55" Ref="Q?"  Part="1" 
AR Path="/600CE672/600D2B55" Ref="Q6"  Part="1" 
F 0 "Q6" H 6058 3153 60  0000 L CNN
F 1 "FDV301N" H 6058 3047 60  0000 L CNN
F 2 "digikey-footprints:SOT-23-3" H 6150 3300 60  0001 L CNN
F 3 "https://www.onsemi.com/pub/Collateral/FDV301N-D.PDF" H 6150 3400 60  0001 L CNN
F 4 "FDV301NCT-ND" H 6150 3500 60  0001 L CNN "Digi-Key_PN"
F 5 "FDV301N" H 6150 3600 60  0001 L CNN "MPN"
F 6 "Discrete Semiconductor Products" H 6150 3700 60  0001 L CNN "Category"
F 7 "Transistors - FETs, MOSFETs - Single" H 6150 3800 60  0001 L CNN "Family"
F 8 "https://www.onsemi.com/pub/Collateral/FDV301N-D.PDF" H 6150 3900 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/on-semiconductor/FDV301N/FDV301NCT-ND/458954" H 6150 4000 60  0001 L CNN "DK_Detail_Page"
F 10 "MOSFET N-CH 25V 220MA SOT-23" H 6150 4100 60  0001 L CNN "Description"
F 11 "ON Semiconductor" H 6150 4200 60  0001 L CNN "Manufacturer"
F 12 "Active" H 6150 4300 60  0001 L CNN "Status"
	1    5950 3100
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 600D2B5B
P 5950 3850
AR Path="/5F449901/600D2B5B" Ref="#PWR?"  Part="1" 
AR Path="/600CE672/600D2B5B" Ref="#PWR048"  Part="1" 
F 0 "#PWR048" H 5950 3600 50  0001 C CNN
F 1 "GND" H 5955 3677 50  0000 C CNN
F 2 "" H 5950 3850 50  0001 C CNN
F 3 "" H 5950 3850 50  0001 C CNN
	1    5950 3850
	1    0    0    -1  
$EndComp
$Comp
L dk_LED-Indication-Discrete:LG_L29K-G2J1-24-Z D?
U 1 1 600D2B6A
P 5950 2300
AR Path="/5F449901/600D2B6A" Ref="D?"  Part="1" 
AR Path="/600CE672/600D2B6A" Ref="D4"  Part="1" 
F 0 "D4" V 5847 2478 60  0000 L CNN
F 1 "LG_L29K-G2J1-24-Z" V 5953 2478 60  0001 L CNN
F 2 "digikey-footprints:0603" H 6150 2500 60  0001 L CNN
F 3 "https://dammedia.osram.info/media/resource/hires/osram-dam-2493945/LG%20L29K.pdf" H 6150 2600 60  0001 L CNN
F 4 "475-2709-1-ND" H 6150 2700 60  0001 L CNN "Digi-Key_PN"
F 5 "LG L29K-G2J1-24-Z" H 6150 2800 60  0001 L CNN "MPN"
F 6 "Optoelectronics" H 6150 2900 60  0001 L CNN "Category"
F 7 "LED Indication - Discrete" H 6150 3000 60  0001 L CNN "Family"
F 8 "https://dammedia.osram.info/media/resource/hires/osram-dam-2493945/LG%20L29K.pdf" H 6150 3100 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/osram-opto-semiconductors-inc/LG-L29K-G2J1-24-Z/475-2709-1-ND/1938876" H 6150 3200 60  0001 L CNN "DK_Detail_Page"
F 10 "LED GREEN DIFFUSED 0603 SMD" H 6150 3300 60  0001 L CNN "Description"
F 11 "OSRAM Opto Semiconductors Inc." H 6150 3400 60  0001 L CNN "Manufacturer"
F 12 "Active" H 6150 3500 60  0001 L CNN "Status"
	1    5950 2300
	0    1    1    0   
$EndComp
$Comp
L Device:R R?
U 1 1 600D2B76
P 5950 2650
AR Path="/5F449901/600D2B76" Ref="R?"  Part="1" 
AR Path="/600CE672/600D2B76" Ref="R59"  Part="1" 
F 0 "R59" V 6150 2650 50  0000 C CNN
F 1 "800R" V 6050 2650 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5880 2650 50  0001 C CNN
F 3 "~" H 5950 2650 50  0001 C CNN
	1    5950 2650
	1    0    0    -1  
$EndComp
Wire Wire Line
	5950 2900 5950 2800
Wire Wire Line
	5950 2500 5950 2400
Wire Wire Line
	5650 3200 5450 3200
Wire Wire Line
	5450 3200 5200 3200
Connection ~ 5450 3200
Wire Wire Line
	5950 2000 5950 2100
Text GLabel 5700 1850 2    50   Input ~ 0
FC_3V3
Wire Wire Line
	5700 1850 5650 1850
Wire Wire Line
	5650 1850 5650 2000
Wire Wire Line
	5650 2000 5950 2000
Text Notes 7200 2100 0    50   ~ 0
User Button_0
$Comp
L Device:R R?
U 1 1 6023D6CE
P 1550 3400
AR Path="/5F449901/6023D6CE" Ref="R?"  Part="1" 
AR Path="/600CE672/6023D6CE" Ref="R60"  Part="1" 
F 0 "R60" V 1343 3400 50  0000 C CNN
F 1 "10KR" V 1434 3400 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 1480 3400 50  0001 C CNN
F 3 "~" H 1550 3400 50  0001 C CNN
	1    1550 3400
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 6023DDF2
P 3600 3450
AR Path="/5F449901/6023DDF2" Ref="R?"  Part="1" 
AR Path="/600CE672/6023DDF2" Ref="R61"  Part="1" 
F 0 "R61" V 3393 3450 50  0000 C CNN
F 1 "10KR" V 3484 3450 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 3530 3450 50  0001 C CNN
F 3 "~" H 3600 3450 50  0001 C CNN
	1    3600 3450
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 6023E39A
P 5450 3450
AR Path="/5F449901/6023E39A" Ref="R?"  Part="1" 
AR Path="/600CE672/6023E39A" Ref="R62"  Part="1" 
F 0 "R62" V 5243 3450 50  0000 C CNN
F 1 "10KR" V 5334 3450 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 5380 3450 50  0001 C CNN
F 3 "~" H 5450 3450 50  0001 C CNN
	1    5450 3450
	-1   0    0    1   
$EndComp
Wire Wire Line
	2050 3250 2050 3650
Wire Wire Line
	4100 3300 4100 3700
Wire Wire Line
	5950 3300 5950 3700
Wire Wire Line
	5450 3600 5450 3700
Wire Wire Line
	5450 3700 5950 3700
Connection ~ 5950 3700
Wire Wire Line
	5950 3700 5950 3850
Wire Wire Line
	5450 3300 5450 3200
Wire Wire Line
	3600 3300 3600 3200
Wire Wire Line
	3600 3600 3600 3700
Wire Wire Line
	3600 3700 4100 3700
Connection ~ 4100 3700
Wire Wire Line
	4100 3700 4100 3850
Wire Wire Line
	1550 3150 1550 3250
Wire Wire Line
	1550 3550 1550 3650
Wire Wire Line
	1550 3650 2050 3650
Connection ~ 2050 3650
Wire Wire Line
	2050 3650 2050 3800
Text Notes 1700 1650 0    50   ~ 0
User LED_0
Text Notes 3800 1700 0    50   ~ 0
User LED_1\n
Text Notes 5650 1700 0    50   ~ 0
User LED_2
$Comp
L dk_Tactile-Switches:1825910-6 S4
U 1 1 6024F1A6
P 7550 2800
F 0 "S4" H 7550 3147 60  0000 C CNN
F 1 "1825910-6" H 7550 3041 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_THT_6x6mm" H 7750 3000 60  0001 L CNN
F 3 "https://www.te.com/commerce/DocumentDelivery/DDEController?Action=srchrtrv&DocNm=1825910&DocType=Customer+Drawing&DocLang=English" H 7750 3100 60  0001 L CNN
F 4 "450-1650-ND" H 7750 3200 60  0001 L CNN "Digi-Key_PN"
F 5 "1825910-6" H 7750 3300 60  0001 L CNN "MPN"
F 6 "Switches" H 7750 3400 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 7750 3500 60  0001 L CNN "Family"
F 8 "https://www.te.com/commerce/DocumentDelivery/DDEController?Action=srchrtrv&DocNm=1825910&DocType=Customer+Drawing&DocLang=English" H 7750 3600 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/te-connectivity-alcoswitch-switches/1825910-6/450-1650-ND/1632536" H 7750 3700 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 7750 3800 60  0001 L CNN "Description"
F 11 "TE Connectivity ALCOSWITCH Switches" H 7750 3900 60  0001 L CNN "Manufacturer"
F 12 "Active" H 7750 4000 60  0001 L CNN "Status"
	1    7550 2800
	1    0    0    -1  
$EndComp
$Comp
L dk_Tactile-Switches:1825910-6 S5
U 1 1 6024F95B
P 9700 2800
F 0 "S5" H 9700 3147 60  0000 C CNN
F 1 "1825910-6" H 9700 3041 60  0000 C CNN
F 2 "digikey-footprints:Switch_Tactile_THT_6x6mm" H 9900 3000 60  0001 L CNN
F 3 "https://www.te.com/commerce/DocumentDelivery/DDEController?Action=srchrtrv&DocNm=1825910&DocType=Customer+Drawing&DocLang=English" H 9900 3100 60  0001 L CNN
F 4 "450-1650-ND" H 9900 3200 60  0001 L CNN "Digi-Key_PN"
F 5 "1825910-6" H 9900 3300 60  0001 L CNN "MPN"
F 6 "Switches" H 9900 3400 60  0001 L CNN "Category"
F 7 "Tactile Switches" H 9900 3500 60  0001 L CNN "Family"
F 8 "https://www.te.com/commerce/DocumentDelivery/DDEController?Action=srchrtrv&DocNm=1825910&DocType=Customer+Drawing&DocLang=English" H 9900 3600 60  0001 L CNN "DK_Datasheet_Link"
F 9 "/product-detail/en/te-connectivity-alcoswitch-switches/1825910-6/450-1650-ND/1632536" H 9900 3700 60  0001 L CNN "DK_Detail_Page"
F 10 "SWITCH TACTILE SPST-NO 0.05A 24V" H 9900 3800 60  0001 L CNN "Description"
F 11 "TE Connectivity ALCOSWITCH Switches" H 9900 3900 60  0001 L CNN "Manufacturer"
F 12 "Active" H 9900 4000 60  0001 L CNN "Status"
	1    9700 2800
	1    0    0    -1  
$EndComp
$Comp
L Device:R R?
U 1 1 60253141
P 7950 3050
AR Path="/5F449901/60253141" Ref="R?"  Part="1" 
AR Path="/600CE672/60253141" Ref="R63"  Part="1" 
F 0 "R63" V 7743 3050 50  0000 C CNN
F 1 "10KR" V 7834 3050 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 7880 3050 50  0001 C CNN
F 3 "~" H 7950 3050 50  0001 C CNN
	1    7950 3050
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 602539FD
P 10100 3050
AR Path="/5F449901/602539FD" Ref="R?"  Part="1" 
AR Path="/600CE672/602539FD" Ref="R65"  Part="1" 
F 0 "R65" V 9893 3050 50  0000 C CNN
F 1 "10KR" V 9984 3050 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 10030 3050 50  0001 C CNN
F 3 "~" H 10100 3050 50  0001 C CNN
	1    10100 3050
	-1   0    0    1   
$EndComp
$Comp
L Device:R R?
U 1 1 602586F7
P 8100 2700
AR Path="/5F449901/602586F7" Ref="R?"  Part="1" 
AR Path="/600CE672/602586F7" Ref="R64"  Part="1" 
F 0 "R64" V 7893 2700 50  0000 C CNN
F 1 "10KR" V 7984 2700 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 8030 2700 50  0001 C CNN
F 3 "~" H 8100 2700 50  0001 C CNN
	1    8100 2700
	0    -1   -1   0   
$EndComp
$Comp
L Device:R R?
U 1 1 60258B8B
P 10250 2700
AR Path="/5F449901/60258B8B" Ref="R?"  Part="1" 
AR Path="/600CE672/60258B8B" Ref="R66"  Part="1" 
F 0 "R66" V 10043 2700 50  0000 C CNN
F 1 "10KR" V 10134 2700 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" V 10180 2700 50  0001 C CNN
F 3 "~" H 10250 2700 50  0001 C CNN
	1    10250 2700
	0    -1   -1   0   
$EndComp
Wire Wire Line
	7750 2700 7950 2700
Wire Wire Line
	7950 2900 7950 2700
Connection ~ 7950 2700
Wire Wire Line
	9900 2700 10100 2700
Wire Wire Line
	10100 2900 10100 2700
Connection ~ 10100 2700
$Comp
L power:GND #PWR?
U 1 1 6025C793
P 7950 3500
AR Path="/5F449901/6025C793" Ref="#PWR?"  Part="1" 
AR Path="/600CE672/6025C793" Ref="#PWR049"  Part="1" 
F 0 "#PWR049" H 7950 3250 50  0001 C CNN
F 1 "GND" H 7955 3327 50  0000 C CNN
F 2 "" H 7950 3500 50  0001 C CNN
F 3 "" H 7950 3500 50  0001 C CNN
	1    7950 3500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 6025D03C
P 10100 3450
AR Path="/5F449901/6025D03C" Ref="#PWR?"  Part="1" 
AR Path="/600CE672/6025D03C" Ref="#PWR050"  Part="1" 
F 0 "#PWR050" H 10100 3200 50  0001 C CNN
F 1 "GND" H 10105 3277 50  0000 C CNN
F 2 "" H 10100 3450 50  0001 C CNN
F 3 "" H 10100 3450 50  0001 C CNN
	1    10100 3450
	1    0    0    -1  
$EndComp
Wire Wire Line
	10100 3200 10100 3450
Wire Wire Line
	7950 3200 7950 3500
Text GLabel 7150 2700 0    50   Input ~ 0
FC_3V3
Text GLabel 9350 2700 0    50   Input ~ 0
FC_3V3
Wire Wire Line
	9350 2700 9500 2700
Wire Wire Line
	7150 2700 7350 2700
Text Notes 9400 2100 0    50   ~ 0
User Button_1
$EndSCHEMATC
