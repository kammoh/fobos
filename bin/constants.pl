#!/usr/bin/perl

use File::Copy;
use Storable;
use File::Path qw(remove_tree rmtree);
use Cwd;


# =============================================
# ATHENA - Automated Tool for Hardware EvaluatioN.
# Copyright © 2009 - 2011 CERG at George Mason University <cryptography.gmu.edu>.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, see http://www.gnu.org/licenses
# or write to the Free Software Foundation,Inc., 51 Franklin Street,
# Fifth Floor, Boston, MA 02110-1301  USA.
# =============================================

#! ./perl

$FOBOS_VERSION = "0.1";
$CNTL_BRD = "Nexys2";
$OS = $^O;
#####################################################################
# FILE/FOLDER NAMES for the design
#####################################################################
die "ERROR: Constants - Root directory does not exit!" if($ROOT_DIR eq "");
#FILE NAMES =========================
#files
$DESIGN_CONFIGURATION_FILE_NAME = "config.txt";
$OSC_CONFIG_FILE_NAME = "osc_config.txt";
$FOBOS_LOG_FILE_NAME = "fobos_log.txt";
$FOBOS_OUTPUT_FILE_NAME = "outputs.txt";
$FOBOS_MEASUREMENT_POWER_FILE_NAME = "power_data.txt";
$FOBOS_MEASUREMENT_POWER_FILE_NAME = "trigger_data.txt";
#FILE PATHS =========================
$DESIGN_CONFIGURATION_FILE = "$CONFIG_DIR/$DESIGN_CONFIGURATION_FILE_NAME";
$OSC_CONFIGURATION_FILE = "$CONFIG_DIR/$OSC_CONFIG_FILE_NAME";

#####################################################################
# Global Flags
#####################################################################
#FILE writing options
$APPEND = 0;
$OVERWRITE = 1;

#YES NO flags
$YES = 1;
$NO = 0;

#####################################################################
# Register Values for the control board
#####################################################################
$STATUS_REG = 0x00;
$COMMAND_REG = 0x01;
$DIRECT_DATA2VICTIM_REG = 0x02;
$DATA_BRAM_ADD_REG = 0x03;
$DATA_BRAM_REG = 0x04;
$KEY_BRAM_ADD_REG= 0x05;
$KEY_BRAM_REG = 0x06;
$TRIGGER_REG = 0x07;
$CLK_FREQ_REG = 0x08;
$TIMEOUT_REG = 0x09;
$VICTIM_RESET_REG = 0x0A;
$CLK_FREQ_ADD_REG = 0x0B;
$CLK_FREQ_DATA_REG = 0x0C;
$DATA2PC_BRAM_REG = 0x0D;
$DATA2PC_DIRECT_REG = 0x0E;




1; #return 1 when including this file along with other scripts.