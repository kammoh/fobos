.. _dut_comms-label:

DUT Communication Module
************************

This module controls the communication with the Device Under Test (DUT) and determines 
from the handshaking lines what the state of the DUT is.

Setting DUT Interface
=====================

FOBOS supports a 4-bit full-duplex FIFO interface when using PMOD connectors and a 
4-bit half-duplex FIFO interface when using the target connector on the FOBOS Shield.
The selections are:

- INTERFACE_4BIT: 4-bit half-duplex FIFO interface using the target connector on the FOBOS Shield
- INTERFACE_8BIT: 4-bit full-duplex FIFO interface using PMOD connectors

.. code-block:: python

    ctrl.setDUTInterface(FOBOSCtrl.Value)

Output Length
=============

FOBOS has to know how may output **Bytes** it has to expect from the DUT. 
This is used to generate the tlast signal used to mark the end of the packet.

.. code-block:: python

    ctrl.setOutLen(Value)


