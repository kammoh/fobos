Control Board Feature
*********************

Trigger Settings
================
The controller can send a trigger to the Oscilloscope once the DUT starts processing the data (ie. di_ready = 0). Or it can be configured to trigger any number of clock cycles after this event occurs.

- TRIGGER_WAIT_CYCLES : The number of clock cycles after which the trigger is asserted (after di_ready goes to zero).
- TRIGGER_LENGTH_CYCLES : The time the trigger signal is asserted.
- TRIGGER_TYPE : possible values: TRG_NORM | TRG_FULL | TRG_NORM_CLK | TRG_FULL_CLK
        - TRG_NORM : normal trigger mode. in this mode the TRIGGER_WAIT_CYCLES and TRIGGER_LENGTH_CYCLES are applied.
        - TRG_FULL : Full trigger mode. While DUT is running (between di_ready = 0 and do_valid = 1) the trigger is asserted.
        - TRG_NORM_CLK : same as TRG_NORM but the trigger signal is anded with the clock.
        - TRG_FULL_CLK : same as TRG_FULL but the trigger signal is anded with the clock.
- CUT_MODE : Controls how the trace retrieved from the scope will be processed. Possible values: FULL | TRIG_HIGH
        - FULL : The trace is cut starting at the rising edge of the trigger to the end of the screen.
        - TRIG_HIGH : the trace is cut from the rising edge to the falling edge of the trigger ie. the trace where the trigger is high will be saved.


Setting DUT Clock
=================

The control board can provide a clock for the DUT ranging from 400 KHz to 100 MHz. The default value is 5 MHz.
To set it, use the following method:
    ctrl.setDUTClk(clkValue).


DUT Reset Feature
=================
In some cases, the control board may need to reset the DUT because the interesting part of the victim algorithm has already executed. This is specifically valuable for ciphers that take a long time to complete. In this case, the cipher runs for a configurable number of clock cycles and then is reset without waiting for it to complete. This helps reduce acquisition time.
The number of cycles is counted after di_ready goes to 0.
Note: When you use this feature, no output is returned from the DUT.
To set it use the following command and set TIME_TO_RESET to any number other than zero. This number is set to zero by default which disables this feature.

    ctrl.setTimeToReset(TIME_TO_RST)


Timeout Setting
===============
In some cases, due to communication error or DUT non-responsiveness the control board sends a 
timeout error message to the control PC when a configurable time has elapsed. The default value is 5 
seconds which is enough for almost all cases. Once timeout is reached, the control board resets the DUT, clears any pending DUT data transfers and return the a timeout status to the capture software.
To set the timeout value, use the method:
    ctrl.setTimeout(TIMEOUT)


Port mapping
============

Below, we show how the pins on the Basys3 PMOD ports are assinged. ::

    #JA
    #+----------+----------+----------+----------+
    #|          |  din3    |  do_ready|  rst     |
    #|  G2      |  J2      |  L2      |  J1      |
    #+----------+----------+----------+----------+
    #|  din0    |  din2    |  din1    |  do_valid|
    #|  G3      |  H2      |  K2      |  H1      |
    #+----------+----------+----------+----------+

    #JXADC
    #+----------+----------+----------+----------+
    #|  dout1   |  dout3   |  di_ready|  dut_clk |
    #|  N2      |  M2      |  L3      |  J3      |
    #+----------+----------+----------+----------+
    #|  dout0   |  dout2   |  di_valid|          |
    #|  N1      |  M1      |  M3      |  K3      |
    #+----------+----------+----------+----------+

    #JC
    #+----------+----------+----------+------------+
    #|          |          |          | trigger_out|
    #|          |          |          |            |
    #+----------+----------+----------+------------+
    #|          |          |          |            |
    #|          |          |          |            |
    #+----------+----------+----------+------------+
