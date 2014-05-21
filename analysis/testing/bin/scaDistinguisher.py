#!/usr/bin/python
import os
import sys
import numpy
import scipy.stats.stats as sca


def main():
	os.system('cls')
	x = [5,4,6,8,4]
	y  = [0,1,4,6,2]
	c,p = sca.pearsonr(x,y)
	print c
	
	
if __name__ == "__main__":
    main()	