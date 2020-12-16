#include "seven_seg.h"

void write7Seg(char d3, char d2, char d1, char d0){
    Xil_Out32(SEVEN_SEG_BASE + 0, (u32)(d0));
    Xil_Out32(SEVEN_SEG_BASE + 4, (u32)(d1));
    Xil_Out32(SEVEN_SEG_BASE + 8, (u32)(d2));
    Xil_Out32(SEVEN_SEG_BASE + 12, (u32)(d3));
}
