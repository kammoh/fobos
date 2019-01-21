 
#This script modifies the Vivado 2017.2 project tcl file to comment out references to the block design.
#At the end of the file, code is appended to create the block design from a tcl file.
#The script searches for a line that is seen before references to the bd
#This is by no means a general purpose script!
#Assumes that one block design is used and it is the top-level design
#Author: Abubakr Abdulgadir
#Date: 11/20/2018


LINE = "update_ip_catalog -rebuild" # line seen before the bd references
NUM_LINES = 23 #number of lines to comment out after the pattern
IN_FILE_NAME = "build_proj.tcl"
OUT_FILE_NAME = "build_proj_modified.tcl"
code = """
######ADDED BY modify_project_tcl.py
# Create block design
 source $origin_dir/src/bd/top.tcl

 # Generate the wrapper
 set design_name [get_bd_designs]
 make_wrapper -files [get_files $design_name.bd] -top -import
#####END ADDED
"""
###################################################################

f = open(IN_FILE_NAME, 'r')
num = 0 
start = False
lines = f.readlines()
fileStr = ""
for l in lines:
    #print str(start)
    #print str(num)
    #print "###"
    if l.startswith(LINE):
        start = True
        #print "#########****COMMENTED OUT BY modify_project_tcl.py\n"
        fileStr += "\n#########****COMMENTED OUT BY modify_project_tcl.py\n"
    if start and num < NUM_LINES:
        #print "#########****" + l
        l =  "#########****" + l
        fileStr += l
        num +=1
    else:
        #print l
        fileStr += l
fileStr += code
print fileStr
fo = open(OUT_FILE_NAME, 'w')
fo.write(fileStr)

        
