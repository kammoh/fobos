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
$Comp
L cerg:XC7A12T-CPG238 U?
U 1 1 60D317C1
P 6750 2300
AR Path="/5F22D594/60D317C1" Ref="U?"  Part="1" 
AR Path="/60D2F94F/60D317C1" Ref="U1"  Part="1" 
F 0 "U1" H 7950 2567 50  0000 C CNN
F 1 "XC7A12T-CPG238" H 7950 2476 50  0000 C CNN
F 2 "Package_BGA:Xilinx_CPG238" H 6750 2300 50  0001 C CNN
F 3 "" H 6750 2300 50  0001 C CNN
	1    6750 2300
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4173F
P 1150 1800
AR Path="/5F3A1954/60D4173F" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4173F" Ref="C?"  Part="1" 
F 0 "C?" H 1265 1846 50  0000 L CNN
F 1 "100uF" H 1265 1755 50  0000 L CNN
F 2 "Capacitor_SMD:C_1210_3225Metric_Pad1.33x2.70mm_HandSolder" H 1188 1650 50  0001 C CNN
F 3 "~" H 1150 1800 50  0001 C CNN
F 4 "CAP CER 100UF 6.3V X5R 1210" H 1150 1800 50  0001 C CNN "Description"
F 5 "JMK325ABJ107MM-P" H 1150 1800 50  0001 C CNN "MPN"
F 6 "Taiyo Yuden" H 1150 1800 50  0001 C CNN "Manufacturer"
	1    1150 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41748
P 1650 1800
AR Path="/5F3A1954/60D41748" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41748" Ref="C?"  Part="1" 
F 0 "C?" H 1765 1846 50  0000 L CNN
F 1 "4.7uF" H 1765 1755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1688 1650 50  0001 C CNN
F 3 "~" H 1650 1800 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1650 1800 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1650 1800 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1650 1800 50  0001 C CNN "Manufacturer"
	1    1650 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41751
P 2150 1800
AR Path="/5F3A1954/60D41751" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41751" Ref="C?"  Part="1" 
F 0 "C?" H 2265 1846 50  0000 L CNN
F 1 ".47uF" H 2265 1755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2188 1650 50  0001 C CNN
F 3 "~" H 2150 1800 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2150 1800 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2150 1800 50  0001 C CNN "MPN"
F 6 "KEMET" H 2150 1800 50  0001 C CNN "Manufacturer"
	1    2150 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4175A
P 2650 1800
AR Path="/5F3A1954/60D4175A" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4175A" Ref="C?"  Part="1" 
F 0 "C?" H 2765 1846 50  0000 L CNN
F 1 ".47uF" H 2765 1755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2688 1650 50  0001 C CNN
F 3 "~" H 2650 1800 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2650 1800 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2650 1800 50  0001 C CNN "MPN"
F 6 "KEMET" H 2650 1800 50  0001 C CNN "Manufacturer"
	1    2650 1800
	1    0    0    -1  
$EndComp
$Comp
L cerg:VCCINT #PWR?
U 1 1 60D41760
P 1150 1550
AR Path="/5F3A1954/60D41760" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D41760" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 1400 50  0001 C CNN
F 1 "VCCINT" H 1153 1807 50  0000 C CNN
F 2 "" H 1150 1550 50  0001 C CNN
F 3 "" H 1150 1550 50  0001 C CNN
	1    1150 1550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60D41766
P 1150 2100
AR Path="/5F3A1954/60D41766" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D41766" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 1850 50  0001 C CNN
F 1 "GND" H 1155 1927 50  0000 C CNN
F 2 "" H 1150 2100 50  0001 C CNN
F 3 "" H 1150 2100 50  0001 C CNN
	1    1150 2100
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 1650 1150 1600
Wire Wire Line
	1650 1650 1650 1600
Wire Wire Line
	1650 1600 1150 1600
Connection ~ 1150 1600
Wire Wire Line
	1150 1600 1150 1550
Wire Wire Line
	2650 1650 2650 1600
Wire Wire Line
	2650 1600 2150 1600
Connection ~ 1650 1600
Wire Wire Line
	2150 1650 2150 1600
Connection ~ 2150 1600
Wire Wire Line
	2150 1600 1650 1600
Wire Wire Line
	2650 1950 2650 2000
Wire Wire Line
	2650 2000 2150 2000
Wire Wire Line
	1150 2000 1150 2100
Wire Wire Line
	1150 1950 1150 2000
Connection ~ 1150 2000
Wire Wire Line
	1650 1950 1650 2000
Connection ~ 1650 2000
Wire Wire Line
	1650 2000 1150 2000
Wire Wire Line
	2150 1950 2150 2000
Connection ~ 2150 2000
Wire Wire Line
	2150 2000 1650 2000
$Comp
L Device:C C?
U 1 1 60D41785
P 1150 3050
AR Path="/5F3A1954/60D41785" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41785" Ref="C?"  Part="1" 
F 0 "C?" H 1265 3096 50  0000 L CNN
F 1 "47uF" H 1265 3005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 1188 2900 50  0001 C CNN
F 3 "~" H 1150 3050 50  0001 C CNN
F 4 "CAP CER 47UF 6.3V X5R 0603" H 1150 3050 50  0001 C CNN "Description"
F 5 "06036D476MAT2A" H 1150 3050 50  0001 C CNN "MPN"
F 6 "AVX Corporation" H 1150 3050 50  0001 C CNN "Manufacturer"
	1    1150 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4178E
P 1600 3050
AR Path="/5F3A1954/60D4178E" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4178E" Ref="C?"  Part="1" 
F 0 "C?" H 1715 3096 50  0000 L CNN
F 1 "4.7uF" H 1715 3005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1638 2900 50  0001 C CNN
F 3 "~" H 1600 3050 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1600 3050 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1600 3050 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1600 3050 50  0001 C CNN "Manufacturer"
	1    1600 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41797
P 2150 3050
AR Path="/5F3A1954/60D41797" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41797" Ref="C?"  Part="1" 
F 0 "C?" H 2265 3096 50  0000 L CNN
F 1 ".47uF" H 2265 3005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2188 2900 50  0001 C CNN
F 3 "~" H 2150 3050 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2150 3050 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2150 3050 50  0001 C CNN "MPN"
F 6 "KEMET" H 2150 3050 50  0001 C CNN "Manufacturer"
	1    2150 3050
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D417A0
P 2650 3050
AR Path="/5F3A1954/60D417A0" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D417A0" Ref="C?"  Part="1" 
F 0 "C?" H 2765 3096 50  0000 L CNN
F 1 ".47uF" H 2765 3005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2688 2900 50  0001 C CNN
F 3 "~" H 2650 3050 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2650 3050 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2650 3050 50  0001 C CNN "MPN"
F 6 "KEMET" H 2650 3050 50  0001 C CNN "Manufacturer"
	1    2650 3050
	1    0    0    -1  
$EndComp
Wire Wire Line
	2650 2900 2650 2800
Wire Wire Line
	2650 2800 2150 2800
Wire Wire Line
	1150 2800 1150 2700
Wire Wire Line
	1150 2900 1150 2800
Connection ~ 1150 2800
Wire Wire Line
	1600 2900 1600 2800
Connection ~ 1600 2800
Wire Wire Line
	1600 2800 1150 2800
Wire Wire Line
	2150 2900 2150 2800
Connection ~ 2150 2800
Wire Wire Line
	2150 2800 1600 2800
$Comp
L power:GND #PWR?
U 1 1 60D417B1
P 1150 3350
AR Path="/5F3A1954/60D417B1" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D417B1" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 3100 50  0001 C CNN
F 1 "GND" H 1155 3177 50  0000 C CNN
F 2 "" H 1150 3350 50  0001 C CNN
F 3 "" H 1150 3350 50  0001 C CNN
	1    1150 3350
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 3200 1150 3300
Wire Wire Line
	1150 3300 1600 3300
Wire Wire Line
	2650 3300 2650 3200
Connection ~ 1150 3300
Wire Wire Line
	1150 3300 1150 3350
Wire Wire Line
	2150 3200 2150 3300
Connection ~ 2150 3300
Wire Wire Line
	2150 3300 2650 3300
Wire Wire Line
	1600 3200 1600 3300
Connection ~ 1600 3300
Wire Wire Line
	1600 3300 2150 3300
$Comp
L Device:C C?
U 1 1 60D417C5
P 3250 3050
AR Path="/5F3A1954/60D417C5" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D417C5" Ref="C?"  Part="1" 
F 0 "C?" H 3365 3096 50  0000 L CNN
F 1 "47uF" H 3365 3005 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3288 2900 50  0001 C CNN
F 3 "~" H 3250 3050 50  0001 C CNN
F 4 "CAP CER 47UF 6.3V X5R 0603" H 3250 3050 50  0001 C CNN "Description"
F 5 "06036D476MAT2A" H 3250 3050 50  0001 C CNN "MPN"
F 6 "AVX Corporation" H 3250 3050 50  0001 C CNN "Manufacturer"
	1    3250 3050
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60D417CB
P 3250 3350
AR Path="/5F3A1954/60D417CB" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D417CB" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3250 3100 50  0001 C CNN
F 1 "GND" H 3255 3177 50  0000 C CNN
F 2 "" H 3250 3350 50  0001 C CNN
F 3 "" H 3250 3350 50  0001 C CNN
	1    3250 3350
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D417D4
P 3800 1800
AR Path="/5F3A1954/60D417D4" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D417D4" Ref="C?"  Part="1" 
F 0 "C?" H 3915 1846 50  0000 L CNN
F 1 "47uF" H 3915 1755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0603_1608Metric_Pad1.08x0.95mm_HandSolder" H 3838 1650 50  0001 C CNN
F 3 "~" H 3800 1800 50  0001 C CNN
F 4 "CAP CER 47UF 6.3V X5R 0603" H 3800 1800 50  0001 C CNN "Description"
F 5 "06036D476MAT2A" H 3800 1800 50  0001 C CNN "MPN"
F 6 "AVX Corporation" H 3800 1800 50  0001 C CNN "Manufacturer"
	1    3800 1800
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D417DD
P 3200 1800
AR Path="/5F3A1954/60D417DD" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D417DD" Ref="C?"  Part="1" 
F 0 "C?" H 3315 1846 50  0000 L CNN
F 1 ".47uF" H 3315 1755 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3238 1650 50  0001 C CNN
F 3 "~" H 3200 1800 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3200 1800 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3200 1800 50  0001 C CNN "MPN"
F 6 "KEMET" H 3200 1800 50  0001 C CNN "Manufacturer"
	1    3200 1800
	1    0    0    -1  
$EndComp
$Comp
L cerg:VCCINT #PWR?
U 1 1 60D417E3
P 3200 1550
AR Path="/5F3A1954/60D417E3" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D417E3" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3200 1400 50  0001 C CNN
F 1 "VCCINT" H 3203 1807 50  0000 C CNN
F 2 "" H 3200 1550 50  0001 C CNN
F 3 "" H 3200 1550 50  0001 C CNN
	1    3200 1550
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60D417E9
P 3200 2050
AR Path="/5F3A1954/60D417E9" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D417E9" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3200 1800 50  0001 C CNN
F 1 "GND" H 3205 1877 50  0000 C CNN
F 2 "" H 3200 2050 50  0001 C CNN
F 3 "" H 3200 2050 50  0001 C CNN
	1    3200 2050
	1    0    0    -1  
$EndComp
Wire Wire Line
	3200 1650 3200 1600
Wire Wire Line
	3200 1950 3200 2000
Wire Wire Line
	3800 1950 3800 2000
Wire Wire Line
	3800 2000 3200 2000
Connection ~ 3200 2000
Wire Wire Line
	3200 2000 3200 2050
Wire Wire Line
	3800 1650 3800 1600
Wire Wire Line
	3800 1600 3200 1600
Connection ~ 3200 1600
Wire Wire Line
	3200 1600 3200 1550
Text Notes 3300 2750 0    50   ~ 0
BANK0\nE10, R10
Text Notes 2300 3900 0    50   ~ 0
BANK14\nL16, P17, R14, T11, U8, U18, V15
Text Notes 2250 5100 0    50   ~ 0
BANK15\nA16, B13, C10, D17, E14, G18, H15
Wire Wire Line
	3250 2750 3250 2900
Wire Wire Line
	3250 3200 3250 3350
$Comp
L Device:C C?
U 1 1 60D41801
P 1150 4200
AR Path="/5F3A1954/60D41801" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41801" Ref="C?"  Part="1" 
F 0 "C?" H 1265 4246 50  0000 L CNN
F 1 "4.7uF" H 1265 4155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1188 4050 50  0001 C CNN
F 3 "~" H 1150 4200 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1150 4200 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1150 4200 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1150 4200 50  0001 C CNN "Manufacturer"
	1    1150 4200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4180A
P 1600 4200
AR Path="/5F3A1954/60D4180A" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4180A" Ref="C?"  Part="1" 
F 0 "C?" H 1715 4246 50  0000 L CNN
F 1 "4.7uF" H 1715 4155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1638 4050 50  0001 C CNN
F 3 "~" H 1600 4200 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1600 4200 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1600 4200 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1600 4200 50  0001 C CNN "Manufacturer"
	1    1600 4200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41813
P 2150 4200
AR Path="/5F3A1954/60D41813" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41813" Ref="C?"  Part="1" 
F 0 "C?" H 2265 4246 50  0000 L CNN
F 1 ".47uF" H 2265 4155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2188 4050 50  0001 C CNN
F 3 "~" H 2150 4200 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2150 4200 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2150 4200 50  0001 C CNN "MPN"
F 6 "KEMET" H 2150 4200 50  0001 C CNN "Manufacturer"
	1    2150 4200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4181C
P 2650 4200
AR Path="/5F3A1954/60D4181C" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4181C" Ref="C?"  Part="1" 
F 0 "C?" H 2765 4246 50  0000 L CNN
F 1 ".47uF" H 2765 4155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2688 4050 50  0001 C CNN
F 3 "~" H 2650 4200 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2650 4200 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2650 4200 50  0001 C CNN "MPN"
F 6 "KEMET" H 2650 4200 50  0001 C CNN "Manufacturer"
	1    2650 4200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41825
P 1150 5400
AR Path="/5F3A1954/60D41825" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41825" Ref="C?"  Part="1" 
F 0 "C?" H 1265 5446 50  0000 L CNN
F 1 "4.7uF" H 1265 5355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1188 5250 50  0001 C CNN
F 3 "~" H 1150 5400 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1150 5400 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1150 5400 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1150 5400 50  0001 C CNN "Manufacturer"
	1    1150 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4182E
P 1600 5400
AR Path="/5F3A1954/60D4182E" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4182E" Ref="C?"  Part="1" 
F 0 "C?" H 1715 5446 50  0000 L CNN
F 1 "4.7uF" H 1715 5355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1638 5250 50  0001 C CNN
F 3 "~" H 1600 5400 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1600 5400 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1600 5400 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1600 5400 50  0001 C CNN "Manufacturer"
	1    1600 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41837
P 2150 5400
AR Path="/5F3A1954/60D41837" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41837" Ref="C?"  Part="1" 
F 0 "C?" H 2265 5446 50  0000 L CNN
F 1 ".47uF" H 2265 5355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2188 5250 50  0001 C CNN
F 3 "~" H 2150 5400 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2150 5400 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2150 5400 50  0001 C CNN "MPN"
F 6 "KEMET" H 2150 5400 50  0001 C CNN "Manufacturer"
	1    2150 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41840
P 2600 5400
AR Path="/5F3A1954/60D41840" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41840" Ref="C?"  Part="1" 
F 0 "C?" H 2715 5446 50  0000 L CNN
F 1 ".47uF" H 2715 5355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2638 5250 50  0001 C CNN
F 3 "~" H 2600 5400 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2600 5400 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2600 5400 50  0001 C CNN "MPN"
F 6 "KEMET" H 2600 5400 50  0001 C CNN "Manufacturer"
	1    2600 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41849
P 3150 4200
AR Path="/5F3A1954/60D41849" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41849" Ref="C?"  Part="1" 
F 0 "C?" H 3265 4246 50  0000 L CNN
F 1 ".47uF" H 3265 4155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3188 4050 50  0001 C CNN
F 3 "~" H 3150 4200 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3150 4200 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3150 4200 50  0001 C CNN "MPN"
F 6 "KEMET" H 3150 4200 50  0001 C CNN "Manufacturer"
	1    3150 4200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41852
P 3700 4200
AR Path="/5F3A1954/60D41852" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41852" Ref="C?"  Part="1" 
F 0 "C?" H 3815 4246 50  0000 L CNN
F 1 ".47uF" H 3815 4155 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3738 4050 50  0001 C CNN
F 3 "~" H 3700 4200 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3700 4200 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3700 4200 50  0001 C CNN "MPN"
F 6 "KEMET" H 3700 4200 50  0001 C CNN "Manufacturer"
	1    3700 4200
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D4185B
P 3150 5400
AR Path="/5F3A1954/60D4185B" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D4185B" Ref="C?"  Part="1" 
F 0 "C?" H 3265 5446 50  0000 L CNN
F 1 ".47uF" H 3265 5355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3188 5250 50  0001 C CNN
F 3 "~" H 3150 5400 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3150 5400 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3150 5400 50  0001 C CNN "MPN"
F 6 "KEMET" H 3150 5400 50  0001 C CNN "Manufacturer"
	1    3150 5400
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D41864
P 3700 5400
AR Path="/5F3A1954/60D41864" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D41864" Ref="C?"  Part="1" 
F 0 "C?" H 3815 5446 50  0000 L CNN
F 1 ".47uF" H 3815 5355 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3738 5250 50  0001 C CNN
F 3 "~" H 3700 5400 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3700 5400 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3700 5400 50  0001 C CNN "MPN"
F 6 "KEMET" H 3700 5400 50  0001 C CNN "Manufacturer"
	1    3700 5400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60D4186A
P 1150 4500
AR Path="/5F3A1954/60D4186A" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D4186A" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 4250 50  0001 C CNN
F 1 "GND" H 1155 4327 50  0000 C CNN
F 2 "" H 1150 4500 50  0001 C CNN
F 3 "" H 1150 4500 50  0001 C CNN
	1    1150 4500
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60D41870
P 1150 5700
AR Path="/5F3A1954/60D41870" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D41870" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 5450 50  0001 C CNN
F 1 "GND" H 1155 5527 50  0000 C CNN
F 2 "" H 1150 5700 50  0001 C CNN
F 3 "" H 1150 5700 50  0001 C CNN
	1    1150 5700
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 4050 1150 3950
Wire Wire Line
	3700 4050 3700 3950
Wire Wire Line
	3700 3950 3150 3950
Connection ~ 1150 3950
Wire Wire Line
	1150 3950 1150 3900
Wire Wire Line
	1600 4050 1600 3950
Connection ~ 1600 3950
Wire Wire Line
	1600 3950 1150 3950
Wire Wire Line
	2150 4050 2150 3950
Connection ~ 2150 3950
Wire Wire Line
	2150 3950 1600 3950
Wire Wire Line
	2650 4050 2650 3950
Connection ~ 2650 3950
Wire Wire Line
	2650 3950 2150 3950
Wire Wire Line
	3150 4050 3150 3950
Connection ~ 3150 3950
Wire Wire Line
	3150 3950 2650 3950
Wire Wire Line
	3700 4350 3700 4450
Wire Wire Line
	3700 4450 3150 4450
Wire Wire Line
	1150 4450 1150 4500
Wire Wire Line
	1150 4350 1150 4450
Connection ~ 1150 4450
Wire Wire Line
	1600 4350 1600 4450
Connection ~ 1600 4450
Wire Wire Line
	1600 4450 1150 4450
Wire Wire Line
	2150 4350 2150 4450
Connection ~ 2150 4450
Wire Wire Line
	2150 4450 1600 4450
Wire Wire Line
	2650 4350 2650 4450
Connection ~ 2650 4450
Wire Wire Line
	2650 4450 2150 4450
Wire Wire Line
	3150 4350 3150 4450
Connection ~ 3150 4450
Wire Wire Line
	3150 4450 2650 4450
Wire Wire Line
	1150 5050 1150 5150
Wire Wire Line
	1150 5550 1150 5650
Wire Wire Line
	1600 5250 1600 5150
Wire Wire Line
	1600 5150 1150 5150
Connection ~ 1150 5150
Wire Wire Line
	1150 5150 1150 5250
Wire Wire Line
	2150 5250 2150 5150
Wire Wire Line
	2150 5150 1600 5150
Connection ~ 1600 5150
Wire Wire Line
	3700 5250 3700 5150
Wire Wire Line
	3700 5150 3150 5150
Connection ~ 2150 5150
Wire Wire Line
	2600 5250 2600 5150
Connection ~ 2600 5150
Wire Wire Line
	2600 5150 2150 5150
Wire Wire Line
	3150 5250 3150 5150
Connection ~ 3150 5150
Wire Wire Line
	3150 5150 2600 5150
Wire Wire Line
	3700 5550 3700 5650
Connection ~ 1150 5650
Wire Wire Line
	1150 5650 1150 5700
Wire Wire Line
	1600 5550 1600 5650
Connection ~ 1600 5650
Wire Wire Line
	1600 5650 1150 5650
Wire Wire Line
	2150 5550 2150 5650
Connection ~ 2150 5650
Wire Wire Line
	2150 5650 1600 5650
Wire Wire Line
	2600 5550 2600 5650
Wire Wire Line
	2150 5650 2600 5650
Connection ~ 2600 5650
Wire Wire Line
	2600 5650 3150 5650
Wire Wire Line
	3150 5550 3150 5650
Connection ~ 3150 5650
Wire Wire Line
	3150 5650 3700 5650
Text Notes 2200 6350 0    50   ~ 0
BANK34\nL6, M3, P7, R4, T1, V5
$Comp
L Device:C C?
U 1 1 60D418BE
P 1150 6650
AR Path="/5F3A1954/60D418BE" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D418BE" Ref="C?"  Part="1" 
F 0 "C?" H 1265 6696 50  0000 L CNN
F 1 "4.7uF" H 1265 6605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1188 6500 50  0001 C CNN
F 3 "~" H 1150 6650 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1150 6650 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1150 6650 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1150 6650 50  0001 C CNN "Manufacturer"
	1    1150 6650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D418C7
P 1600 6650
AR Path="/5F3A1954/60D418C7" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D418C7" Ref="C?"  Part="1" 
F 0 "C?" H 1715 6696 50  0000 L CNN
F 1 "4.7uF" H 1715 6605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 1638 6500 50  0001 C CNN
F 3 "~" H 1600 6650 50  0001 C CNN
F 4 "CAP CER 4.7UF 6.3V X5R 0402" H 1600 6650 50  0001 C CNN "Description"
F 5 "GRM155R60J475ME87J" H 1600 6650 50  0001 C CNN "MPN"
F 6 "Murata Electronics" H 1600 6650 50  0001 C CNN "Manufacturer"
	1    1600 6650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D418D0
P 2150 6650
AR Path="/5F3A1954/60D418D0" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D418D0" Ref="C?"  Part="1" 
F 0 "C?" H 2265 6696 50  0000 L CNN
F 1 ".47uF" H 2265 6605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2188 6500 50  0001 C CNN
F 3 "~" H 2150 6650 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2150 6650 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2150 6650 50  0001 C CNN "MPN"
F 6 "KEMET" H 2150 6650 50  0001 C CNN "Manufacturer"
	1    2150 6650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D418D9
P 2600 6650
AR Path="/5F3A1954/60D418D9" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D418D9" Ref="C?"  Part="1" 
F 0 "C?" H 2715 6696 50  0000 L CNN
F 1 ".47uF" H 2715 6605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 2638 6500 50  0001 C CNN
F 3 "~" H 2600 6650 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 2600 6650 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 2600 6650 50  0001 C CNN "MPN"
F 6 "KEMET" H 2600 6650 50  0001 C CNN "Manufacturer"
	1    2600 6650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D418E2
P 3150 6650
AR Path="/5F3A1954/60D418E2" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D418E2" Ref="C?"  Part="1" 
F 0 "C?" H 3265 6696 50  0000 L CNN
F 1 ".47uF" H 3265 6605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3188 6500 50  0001 C CNN
F 3 "~" H 3150 6650 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3150 6650 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3150 6650 50  0001 C CNN "MPN"
F 6 "KEMET" H 3150 6650 50  0001 C CNN "Manufacturer"
	1    3150 6650
	1    0    0    -1  
$EndComp
$Comp
L Device:C C?
U 1 1 60D418EB
P 3700 6650
AR Path="/5F3A1954/60D418EB" Ref="C?"  Part="1" 
AR Path="/60D2F94F/60D418EB" Ref="C?"  Part="1" 
F 0 "C?" H 3815 6696 50  0000 L CNN
F 1 ".47uF" H 3815 6605 50  0000 L CNN
F 2 "Capacitor_SMD:C_0402_1005Metric_Pad0.74x0.62mm_HandSolder" H 3738 6500 50  0001 C CNN
F 3 "~" H 3700 6650 50  0001 C CNN
F 4 "CAP CER 0.47UF 6.3V X5R 0402" H 3700 6650 50  0001 C CNN "Description"
F 5 "C0402C474K9PACTU" H 3700 6650 50  0001 C CNN "MPN"
F 6 "KEMET" H 3700 6650 50  0001 C CNN "Manufacturer"
	1    3700 6650
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR?
U 1 1 60D418F1
P 1150 6950
AR Path="/5F3A1954/60D418F1" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D418F1" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 6700 50  0001 C CNN
F 1 "GND" H 1155 6777 50  0000 C CNN
F 2 "" H 1150 6950 50  0001 C CNN
F 3 "" H 1150 6950 50  0001 C CNN
	1    1150 6950
	1    0    0    -1  
$EndComp
Wire Wire Line
	1150 6950 1150 6900
Wire Wire Line
	3700 6800 3700 6900
Wire Wire Line
	3700 6900 3150 6900
Connection ~ 1150 6900
Wire Wire Line
	1150 6900 1150 6800
Wire Wire Line
	3700 6500 3700 6400
Wire Wire Line
	3700 6400 3150 6400
Wire Wire Line
	1150 6400 1150 6500
Wire Wire Line
	1600 6500 1600 6400
Connection ~ 1600 6400
Wire Wire Line
	1600 6400 1150 6400
Wire Wire Line
	2150 6500 2150 6400
Connection ~ 2150 6400
Wire Wire Line
	2150 6400 1600 6400
Wire Wire Line
	2600 6500 2600 6400
Connection ~ 2600 6400
Wire Wire Line
	2600 6400 2150 6400
Wire Wire Line
	3150 6500 3150 6400
Connection ~ 3150 6400
Wire Wire Line
	3150 6400 2600 6400
Wire Wire Line
	3150 6800 3150 6900
Connection ~ 3150 6900
Wire Wire Line
	3150 6900 2600 6900
Wire Wire Line
	2600 6800 2600 6900
Connection ~ 2600 6900
Wire Wire Line
	2600 6900 2150 6900
Wire Wire Line
	2150 6800 2150 6900
Connection ~ 2150 6900
Wire Wire Line
	2150 6900 1600 6900
Wire Wire Line
	1600 6800 1600 6900
Connection ~ 1600 6900
Wire Wire Line
	1600 6900 1150 6900
Wire Wire Line
	1150 6350 1150 6400
Connection ~ 1150 6400
$Comp
L power:+3V3 #PWR?
U 1 1 60D41919
P 3250 2750
AR Path="/5F3A1954/60D41919" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D41919" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 3250 2600 50  0001 C CNN
F 1 "+3V3" H 3265 2923 50  0000 C CNN
F 2 "" H 3250 2750 50  0001 C CNN
F 3 "" H 3250 2750 50  0001 C CNN
	1    3250 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 60D4191F
P 1150 3900
AR Path="/5F3A1954/60D4191F" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D4191F" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 3750 50  0001 C CNN
F 1 "+3V3" H 1165 4073 50  0000 C CNN
F 2 "" H 1150 3900 50  0001 C CNN
F 3 "" H 1150 3900 50  0001 C CNN
	1    1150 3900
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 60D41925
P 1150 5050
AR Path="/5F3A1954/60D41925" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D41925" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 4900 50  0001 C CNN
F 1 "+3V3" H 1165 5223 50  0000 C CNN
F 2 "" H 1150 5050 50  0001 C CNN
F 3 "" H 1150 5050 50  0001 C CNN
	1    1150 5050
	1    0    0    -1  
$EndComp
$Comp
L power:+3V3 #PWR?
U 1 1 60D4192B
P 1150 6350
AR Path="/5F3A1954/60D4192B" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D4192B" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 6200 50  0001 C CNN
F 1 "+3V3" H 1165 6523 50  0000 C CNN
F 2 "" H 1150 6350 50  0001 C CNN
F 3 "" H 1150 6350 50  0001 C CNN
	1    1150 6350
	1    0    0    -1  
$EndComp
$Comp
L power:+1V8 #PWR?
U 1 1 60D41931
P 1150 2700
AR Path="/5F3A1954/60D41931" Ref="#PWR?"  Part="1" 
AR Path="/60D2F94F/60D41931" Ref="#PWR?"  Part="1" 
F 0 "#PWR?" H 1150 2550 50  0001 C CNN
F 1 "+1V8" H 1165 2873 50  0000 C CNN
F 2 "" H 1150 2700 50  0001 C CNN
F 3 "" H 1150 2700 50  0001 C CNN
	1    1150 2700
	1    0    0    -1  
$EndComp
$EndSCHEMATC