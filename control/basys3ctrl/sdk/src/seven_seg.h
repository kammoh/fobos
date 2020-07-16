#ifndef SEVEN_SEG_H
#define SEVEN_SEG_H

#include "xintc.h"
#include "xparameters.h"

#define SEVEN_SEG_BASE      XPAR_SEVEN_SEG_0_S_AXI_BASEADDR
void write7Seg(char d3, char d2, char d1, char d0);
//digits and characters
//               .gfedcba
#define D_0 	0b11000000
#define D_1 	0b11111001
#define D_2 	0b10100100
#define D_3 	0b10110000
#define D_4 	0b10011001
#define D_5 	0b10010010
#define D_6 	0b10000010
#define D_7 	0b11111000
#define D_8 	0b10000000
#define D_9 	0b10010000
#define	D_A		0b10001000
#define	D_B		0b10000011
#define	D_C		0b11000110
#define	D_E		0b10000110
#define	D_D		0b10000110
#define D_F 	0b10001110
//for logo
#define D_R		0b10001000
#define D_G		0b11000010
#define D_BLANK 0b11111111

#endif
