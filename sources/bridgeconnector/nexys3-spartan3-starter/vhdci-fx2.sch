<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE eagle SYSTEM "eagle.dtd">
<eagle version="6.4">
<drawing>
<settings>
<setting alwaysvectorfont="no"/>
<setting verticaltext="up"/>
</settings>
<grid distance="0.1" unitdist="inch" unit="inch" style="lines" multiple="1" display="no" altdistance="0.01" altunitdist="inch" altunit="inch"/>
<layers>
<layer number="1" name="Top" color="4" fill="1" visible="no" active="no"/>
<layer number="16" name="Bottom" color="1" fill="1" visible="no" active="no"/>
<layer number="17" name="Pads" color="2" fill="1" visible="no" active="no"/>
<layer number="18" name="Vias" color="2" fill="1" visible="no" active="no"/>
<layer number="19" name="Unrouted" color="6" fill="1" visible="no" active="no"/>
<layer number="20" name="Dimension" color="15" fill="1" visible="no" active="no"/>
<layer number="21" name="tPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="22" name="bPlace" color="7" fill="1" visible="no" active="no"/>
<layer number="23" name="tOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="24" name="bOrigins" color="15" fill="1" visible="no" active="no"/>
<layer number="25" name="tNames" color="7" fill="1" visible="no" active="no"/>
<layer number="26" name="bNames" color="7" fill="1" visible="no" active="no"/>
<layer number="27" name="tValues" color="7" fill="1" visible="no" active="no"/>
<layer number="28" name="bValues" color="7" fill="1" visible="no" active="no"/>
<layer number="29" name="tStop" color="7" fill="3" visible="no" active="no"/>
<layer number="30" name="bStop" color="7" fill="6" visible="no" active="no"/>
<layer number="31" name="tCream" color="7" fill="4" visible="no" active="no"/>
<layer number="32" name="bCream" color="7" fill="5" visible="no" active="no"/>
<layer number="33" name="tFinish" color="6" fill="3" visible="no" active="no"/>
<layer number="34" name="bFinish" color="6" fill="6" visible="no" active="no"/>
<layer number="35" name="tGlue" color="7" fill="4" visible="no" active="no"/>
<layer number="36" name="bGlue" color="7" fill="5" visible="no" active="no"/>
<layer number="37" name="tTest" color="7" fill="1" visible="no" active="no"/>
<layer number="38" name="bTest" color="7" fill="1" visible="no" active="no"/>
<layer number="39" name="tKeepout" color="4" fill="11" visible="no" active="no"/>
<layer number="40" name="bKeepout" color="1" fill="11" visible="no" active="no"/>
<layer number="41" name="tRestrict" color="4" fill="10" visible="no" active="no"/>
<layer number="42" name="bRestrict" color="1" fill="10" visible="no" active="no"/>
<layer number="43" name="vRestrict" color="2" fill="10" visible="no" active="no"/>
<layer number="44" name="Drills" color="7" fill="1" visible="no" active="no"/>
<layer number="45" name="Holes" color="7" fill="1" visible="no" active="no"/>
<layer number="46" name="Milling" color="3" fill="1" visible="no" active="no"/>
<layer number="47" name="Measures" color="7" fill="1" visible="no" active="no"/>
<layer number="48" name="Document" color="7" fill="1" visible="no" active="no"/>
<layer number="49" name="Reference" color="7" fill="1" visible="no" active="no"/>
<layer number="51" name="tDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="52" name="bDocu" color="7" fill="1" visible="no" active="no"/>
<layer number="91" name="Nets" color="2" fill="1" visible="yes" active="yes"/>
<layer number="92" name="Busses" color="1" fill="1" visible="yes" active="yes"/>
<layer number="93" name="Pins" color="2" fill="1" visible="no" active="yes"/>
<layer number="94" name="Symbols" color="4" fill="1" visible="yes" active="yes"/>
<layer number="95" name="Names" color="7" fill="1" visible="yes" active="yes"/>
<layer number="96" name="Values" color="7" fill="1" visible="yes" active="yes"/>
<layer number="97" name="Info" color="7" fill="1" visible="yes" active="yes"/>
<layer number="98" name="Guide" color="6" fill="1" visible="yes" active="yes"/>
</layers>
<schematic xreflabel="%F%N/%S.%C%R" xrefpart="/%S.%C%R">
<libraries>
<library name="jumper">
<description>&lt;b&gt;Jumpers&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="JP1">
<description>&lt;b&gt;JUMPER&lt;/b&gt;</description>
<wire x1="-1.016" y1="0" x2="-1.27" y2="0.254" width="0.1524" layer="21"/>
<wire x1="-1.016" y1="0" x2="-1.27" y2="-0.254" width="0.1524" layer="21"/>
<wire x1="1.016" y1="0" x2="1.27" y2="0.254" width="0.1524" layer="21"/>
<wire x1="1.016" y1="0" x2="1.27" y2="-0.254" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-0.254" x2="1.27" y2="-2.286" width="0.1524" layer="21"/>
<wire x1="1.016" y1="-2.54" x2="1.27" y2="-2.286" width="0.1524" layer="21"/>
<wire x1="1.27" y1="2.286" x2="1.016" y2="2.54" width="0.1524" layer="21"/>
<wire x1="1.27" y1="2.286" x2="1.27" y2="0.254" width="0.1524" layer="21"/>
<wire x1="1.016" y1="2.54" x2="-1.016" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="2.286" x2="-1.016" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="2.286" x2="-1.27" y2="0.254" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-0.254" x2="-1.27" y2="-2.286" width="0.1524" layer="21"/>
<wire x1="-1.016" y1="-2.54" x2="-1.27" y2="-2.286" width="0.1524" layer="21"/>
<wire x1="-1.016" y1="-2.54" x2="1.016" y2="-2.54" width="0.1524" layer="21"/>
<pad name="1" x="0" y="-1.27" drill="0.9144" shape="long"/>
<pad name="2" x="0" y="1.27" drill="0.9144" shape="long"/>
<text x="-1.651" y="-2.54" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="2.921" y="-2.54" size="1.27" layer="27" ratio="10" rot="R90">&gt;VALUE</text>
<rectangle x1="-0.3048" y1="0.9652" x2="0.3048" y2="1.5748" layer="51"/>
<rectangle x1="-0.3048" y1="-1.5748" x2="0.3048" y2="-0.9652" layer="51"/>
</package>
</packages>
<symbols>
<symbol name="JP2E">
<wire x1="0" y1="0" x2="0" y2="1.27" width="0.1524" layer="94"/>
<wire x1="0" y1="2.54" x2="0" y2="1.27" width="0.4064" layer="94"/>
<wire x1="2.54" y1="0" x2="2.54" y2="1.27" width="0.1524" layer="94"/>
<wire x1="2.54" y1="2.54" x2="2.54" y2="1.27" width="0.4064" layer="94"/>
<wire x1="-0.635" y1="0" x2="3.175" y2="0" width="0.4064" layer="94"/>
<wire x1="3.175" y1="0" x2="3.175" y2="0.635" width="0.4064" layer="94"/>
<wire x1="3.175" y1="0.635" x2="-0.635" y2="0.635" width="0.4064" layer="94"/>
<wire x1="-0.635" y1="0.635" x2="-0.635" y2="0" width="0.4064" layer="94"/>
<text x="-1.27" y="0" size="1.778" layer="95" rot="R90">&gt;NAME</text>
<text x="5.715" y="0" size="1.778" layer="96" rot="R90">&gt;VALUE</text>
<pin name="1" x="0" y="-2.54" visible="pad" length="short" direction="pas" rot="R90"/>
<pin name="2" x="2.54" y="-2.54" visible="pad" length="short" direction="pas" rot="R90"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="JP1E" prefix="JP" uservalue="yes">
<description>&lt;b&gt;JUMPER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="JP2E" x="2.54" y="0"/>
</gates>
<devices>
<device name="" package="JP1">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="2" pad="2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="con-coax">
<description>&lt;b&gt;Coax Connectors&lt;/b&gt;&lt;p&gt;
Radiall  and M/A COM.&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="BU-SMA-V">
<description>FEMALE &lt;b&gt;SMA CONNECTOR&lt;/b&gt;&lt;p&gt;
Radiall&lt;p&gt;
distributor RS 112-3794</description>
<wire x1="-1.1" y1="3.2" x2="1.1" y2="3.2" width="0.2032" layer="21"/>
<wire x1="3.2" y1="1.1" x2="3.2" y2="-1.1" width="0.2032" layer="21"/>
<wire x1="1.1" y1="-3.2" x2="-1.1" y2="-3.2" width="0.2032" layer="21"/>
<wire x1="-3.2" y1="-1.1" x2="-3.2" y2="1.1" width="0.2032" layer="21"/>
<wire x1="-3.1999" y1="3.1999" x2="3.2" y2="3.2" width="0.2032" layer="51"/>
<wire x1="3.2" y1="3.2" x2="3.1999" y2="-3.1999" width="0.2032" layer="51"/>
<wire x1="3.1999" y1="-3.1999" x2="-3.2" y2="-3.2" width="0.2032" layer="51"/>
<wire x1="-3.2" y1="-3.2" x2="-3.1999" y2="3.1999" width="0.2032" layer="51"/>
<circle x="0" y="0" radius="3.1999" width="0.2032" layer="51"/>
<circle x="0" y="0" radius="1.7" width="0.2032" layer="21"/>
<pad name="1" x="0" y="0" drill="1.27"/>
<pad name="2" x="-2.5499" y="2.5499" drill="1.778"/>
<pad name="3" x="2.5499" y="2.5499" drill="1.778"/>
<pad name="4" x="2.5499" y="-2.5499" drill="1.778"/>
<pad name="5" x="-2.5499" y="-2.5499" drill="1.778"/>
<text x="-2.54" y="4.445" size="1.27" layer="25">&gt;NAME</text>
<text x="-3.175" y="-5.715" size="1.27" layer="27">&gt;VALUE</text>
</package>
</packages>
<symbols>
<symbol name="BNC-FGND">
<wire x1="0" y1="-2.54" x2="-0.762" y2="-1.778" width="0.254" layer="94"/>
<wire x1="0" y1="0" x2="-0.508" y2="0" width="0.1524" layer="94"/>
<wire x1="-2.54" y1="0.508" x2="-0.762" y2="0.508" width="0.254" layer="94"/>
<wire x1="-0.762" y1="0.508" x2="-0.508" y2="0" width="0.254" layer="94"/>
<wire x1="-0.508" y1="0" x2="-0.762" y2="-0.508" width="0.254" layer="94"/>
<wire x1="-0.762" y1="-0.508" x2="-2.54" y2="-0.508" width="0.254" layer="94"/>
<wire x1="-2.54" y1="2.54" x2="0" y2="0.508" width="0.3048" layer="94" curve="-79.611142" cap="flat"/>
<wire x1="-2.54" y1="-2.54" x2="0" y2="-0.508" width="0.3048" layer="94" curve="79.611142" cap="flat"/>
<text x="-2.54" y="-5.08" size="1.778" layer="96">&gt;VALUE</text>
<text x="-2.54" y="3.302" size="1.778" layer="95">&gt;NAME</text>
<pin name="1" x="2.54" y="0" visible="off" length="short" direction="pas" rot="R180"/>
<pin name="GND" x="2.54" y="-2.54" visible="off" length="short" direction="pwr" rot="R180"/>
</symbol>
<symbol name="GND">
<text x="-1.524" y="1.778" size="1.778" layer="95">&gt;NAME</text>
<pin name="GND" x="-2.54" y="0" length="short" direction="pwr"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="BU-SMA-V" prefix="X">
<description>FEMALE &lt;b&gt;SMA CONNECTOR&lt;/b&gt;&lt;p&gt;
Radiall&lt;p&gt;
distributor RS 112-3794</description>
<gates>
<gate name="G$1" symbol="BNC-FGND" x="-2.54" y="0"/>
<gate name="G2" symbol="GND" x="20.32" y="2.54" addlevel="request"/>
<gate name="G3" symbol="GND" x="20.32" y="0" addlevel="request"/>
<gate name="G4" symbol="GND" x="20.32" y="-2.54" addlevel="request"/>
</gates>
<devices>
<device name="" package="BU-SMA-V">
<connects>
<connect gate="G$1" pin="1" pad="1"/>
<connect gate="G$1" pin="GND" pad="2"/>
<connect gate="G2" pin="GND" pad="4"/>
<connect gate="G3" pin="GND" pad="3"/>
<connect gate="G4" pin="GND" pad="5"/>
</connects>
<technologies>
<technology name="">
<attribute name="MF" value="" constant="no"/>
<attribute name="MPN" value="" constant="no"/>
<attribute name="OC_FARNELL" value="unknown" constant="no"/>
<attribute name="OC_NEWARK" value="unknown" constant="no"/>
</technology>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="pinhead">
<description>&lt;b&gt;Pin Header Connectors&lt;/b&gt;&lt;p&gt;
&lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
<package name="2X25">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-31.75" y1="-1.905" x2="-31.115" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-31.115" y1="-2.54" x2="-29.845" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-29.845" y1="-2.54" x2="-29.21" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-29.21" y1="-1.905" x2="-28.575" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-28.575" y1="-2.54" x2="-27.305" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-27.305" y1="-2.54" x2="-26.67" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-26.67" y1="-1.905" x2="-26.035" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-26.035" y1="-2.54" x2="-24.765" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-24.765" y1="-2.54" x2="-24.13" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-24.13" y1="-1.905" x2="-23.495" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-23.495" y1="-2.54" x2="-22.225" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-22.225" y1="-2.54" x2="-21.59" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-21.59" y1="-1.905" x2="-20.955" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-20.955" y1="-2.54" x2="-19.685" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-19.685" y1="-2.54" x2="-19.05" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-19.05" y1="-1.905" x2="-18.415" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-18.415" y1="-2.54" x2="-17.145" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-17.145" y1="-2.54" x2="-16.51" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-31.75" y1="-1.905" x2="-31.75" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-31.75" y1="1.905" x2="-31.115" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-31.115" y1="2.54" x2="-29.845" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-29.845" y1="2.54" x2="-29.21" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-29.21" y1="1.905" x2="-28.575" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-28.575" y1="2.54" x2="-27.305" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-27.305" y1="2.54" x2="-26.67" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-26.67" y1="1.905" x2="-26.035" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-26.035" y1="2.54" x2="-24.765" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-24.765" y1="2.54" x2="-24.13" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-24.13" y1="1.905" x2="-23.495" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-23.495" y1="2.54" x2="-22.225" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-22.225" y1="2.54" x2="-21.59" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-21.59" y1="1.905" x2="-20.955" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-20.955" y1="2.54" x2="-19.685" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-19.685" y1="2.54" x2="-19.05" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-19.05" y1="1.905" x2="-18.415" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-18.415" y1="2.54" x2="-17.145" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-17.145" y1="2.54" x2="-16.51" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-16.51" y1="1.905" x2="-15.875" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-15.875" y1="2.54" x2="-14.605" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-14.605" y1="2.54" x2="-13.97" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-13.97" y1="1.905" x2="-13.335" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-13.335" y1="2.54" x2="-12.065" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-12.065" y1="2.54" x2="-11.43" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-11.43" y1="1.905" x2="-10.795" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-10.795" y1="2.54" x2="-9.525" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-9.525" y1="2.54" x2="-8.89" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-8.89" y1="1.905" x2="-8.255" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-8.255" y1="2.54" x2="-6.985" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-6.985" y1="2.54" x2="-6.35" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="1.905" x2="-5.715" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-5.715" y1="2.54" x2="-4.445" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="2.54" x2="-3.81" y2="1.905" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="1.905" x2="-3.175" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-3.175" y1="2.54" x2="-1.905" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="1.905" x2="-1.905" y2="2.54" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="1.905" x2="-0.635" y2="2.54" width="0.1524" layer="21"/>
<wire x1="0.635" y1="2.54" x2="-0.635" y2="2.54" width="0.1524" layer="21"/>
<wire x1="0.635" y1="2.54" x2="1.27" y2="1.905" width="0.1524" layer="21"/>
<wire x1="1.27" y1="1.905" x2="1.905" y2="2.54" width="0.1524" layer="21"/>
<wire x1="3.175" y1="2.54" x2="1.905" y2="2.54" width="0.1524" layer="21"/>
<wire x1="3.175" y1="2.54" x2="3.81" y2="1.905" width="0.1524" layer="21"/>
<wire x1="3.81" y1="1.905" x2="4.445" y2="2.54" width="0.1524" layer="21"/>
<wire x1="5.715" y1="2.54" x2="4.445" y2="2.54" width="0.1524" layer="21"/>
<wire x1="5.715" y1="2.54" x2="6.35" y2="1.905" width="0.1524" layer="21"/>
<wire x1="6.35" y1="1.905" x2="6.985" y2="2.54" width="0.1524" layer="21"/>
<wire x1="8.255" y1="2.54" x2="6.985" y2="2.54" width="0.1524" layer="21"/>
<wire x1="8.255" y1="2.54" x2="8.89" y2="1.905" width="0.1524" layer="21"/>
<wire x1="8.89" y1="1.905" x2="9.525" y2="2.54" width="0.1524" layer="21"/>
<wire x1="10.795" y1="2.54" x2="9.525" y2="2.54" width="0.1524" layer="21"/>
<wire x1="10.795" y1="2.54" x2="11.43" y2="1.905" width="0.1524" layer="21"/>
<wire x1="11.43" y1="1.905" x2="12.065" y2="2.54" width="0.1524" layer="21"/>
<wire x1="13.335" y1="2.54" x2="12.065" y2="2.54" width="0.1524" layer="21"/>
<wire x1="13.335" y1="2.54" x2="13.97" y2="1.905" width="0.1524" layer="21"/>
<wire x1="13.97" y1="1.905" x2="14.605" y2="2.54" width="0.1524" layer="21"/>
<wire x1="15.875" y1="2.54" x2="14.605" y2="2.54" width="0.1524" layer="21"/>
<wire x1="15.875" y1="2.54" x2="16.51" y2="1.905" width="0.1524" layer="21"/>
<wire x1="16.51" y1="-1.905" x2="15.875" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="15.875" y1="-2.54" x2="14.605" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="13.97" y1="-1.905" x2="14.605" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="13.97" y1="-1.905" x2="13.335" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="13.335" y1="-2.54" x2="12.065" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="11.43" y1="-1.905" x2="12.065" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="11.43" y1="-1.905" x2="10.795" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="10.795" y1="-2.54" x2="9.525" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="8.89" y1="-1.905" x2="9.525" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="8.89" y1="-1.905" x2="8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="6.985" y1="-2.54" x2="8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="6.985" y1="-2.54" x2="6.35" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="6.35" y1="-1.905" x2="5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="4.445" y1="-2.54" x2="5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="4.445" y1="-2.54" x2="3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="3.81" y1="-1.905" x2="3.175" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="3.175" y1="-2.54" x2="1.905" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="1.905" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="1.27" y1="-1.905" x2="0.635" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="0.635" y1="-2.54" x2="-0.635" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="-0.635" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="-1.905" x2="-1.905" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-1.905" y1="-2.54" x2="-3.175" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-1.905" x2="-3.175" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="-1.905" x2="-4.445" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-4.445" y1="-2.54" x2="-5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="-1.905" x2="-5.715" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="-1.905" x2="-6.985" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-6.985" y1="-2.54" x2="-8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-8.89" y1="-1.905" x2="-8.255" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-8.89" y1="-1.905" x2="-9.525" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-9.525" y1="-2.54" x2="-10.795" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-11.43" y1="-1.905" x2="-10.795" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-11.43" y1="-1.905" x2="-12.065" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-12.065" y1="-2.54" x2="-13.335" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-13.97" y1="-1.905" x2="-13.335" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-13.97" y1="-1.905" x2="-14.605" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-14.605" y1="-2.54" x2="-15.875" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-16.51" y1="-1.905" x2="-15.875" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="-29.21" y1="1.905" x2="-29.21" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-26.67" y1="1.905" x2="-26.67" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-24.13" y1="1.905" x2="-24.13" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-21.59" y1="1.905" x2="-21.59" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-19.05" y1="1.905" x2="-19.05" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-16.51" y1="1.905" x2="-16.51" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-13.97" y1="1.905" x2="-13.97" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-11.43" y1="1.905" x2="-11.43" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-8.89" y1="1.905" x2="-8.89" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="1.905" x2="-6.35" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="1.905" x2="-3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="1.905" x2="-1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="1.27" y1="1.905" x2="1.27" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="3.81" y1="1.905" x2="3.81" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="6.35" y1="1.905" x2="6.35" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="8.89" y1="1.905" x2="8.89" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="11.43" y1="1.905" x2="11.43" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="13.97" y1="1.905" x2="13.97" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="16.51" y1="1.905" x2="16.51" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="16.51" y1="1.905" x2="17.145" y2="2.54" width="0.1524" layer="21"/>
<wire x1="18.415" y1="2.54" x2="17.145" y2="2.54" width="0.1524" layer="21"/>
<wire x1="18.415" y1="2.54" x2="19.05" y2="1.905" width="0.1524" layer="21"/>
<wire x1="19.05" y1="-1.905" x2="18.415" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="18.415" y1="-2.54" x2="17.145" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="16.51" y1="-1.905" x2="17.145" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="19.05" y1="1.905" x2="19.05" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="21.59" y1="1.905" x2="21.59" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="24.13" y1="1.905" x2="24.13" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="26.67" y1="1.905" x2="26.67" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="29.21" y1="1.905" x2="29.21" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="20.955" y1="-2.54" x2="19.685" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="23.495" y1="-2.54" x2="22.225" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="26.035" y1="-2.54" x2="24.765" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="28.575" y1="-2.54" x2="27.305" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="31.115" y1="-2.54" x2="29.845" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="20.955" y1="2.54" x2="19.685" y2="2.54" width="0.1524" layer="21"/>
<wire x1="23.495" y1="2.54" x2="22.225" y2="2.54" width="0.1524" layer="21"/>
<wire x1="26.035" y1="2.54" x2="24.765" y2="2.54" width="0.1524" layer="21"/>
<wire x1="28.575" y1="2.54" x2="27.305" y2="2.54" width="0.1524" layer="21"/>
<wire x1="31.115" y1="2.54" x2="29.845" y2="2.54" width="0.1524" layer="21"/>
<wire x1="20.955" y1="2.54" x2="21.59" y2="1.905" width="0.1524" layer="21"/>
<wire x1="23.495" y1="2.54" x2="24.13" y2="1.905" width="0.1524" layer="21"/>
<wire x1="26.035" y1="2.54" x2="26.67" y2="1.905" width="0.1524" layer="21"/>
<wire x1="28.575" y1="2.54" x2="29.21" y2="1.905" width="0.1524" layer="21"/>
<wire x1="31.115" y1="2.54" x2="31.75" y2="1.905" width="0.1524" layer="21"/>
<wire x1="21.59" y1="-1.905" x2="20.955" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="24.13" y1="-1.905" x2="23.495" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="26.67" y1="-1.905" x2="26.035" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="29.21" y1="-1.905" x2="28.575" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="31.75" y1="-1.905" x2="31.115" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="19.05" y1="-1.905" x2="19.685" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="21.59" y1="-1.905" x2="22.225" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="24.13" y1="-1.905" x2="24.765" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="26.67" y1="-1.905" x2="27.305" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="29.21" y1="-1.905" x2="29.845" y2="-2.54" width="0.1524" layer="21"/>
<wire x1="19.05" y1="1.905" x2="19.685" y2="2.54" width="0.1524" layer="21"/>
<wire x1="21.59" y1="1.905" x2="22.225" y2="2.54" width="0.1524" layer="21"/>
<wire x1="24.13" y1="1.905" x2="24.765" y2="2.54" width="0.1524" layer="21"/>
<wire x1="26.67" y1="1.905" x2="27.305" y2="2.54" width="0.1524" layer="21"/>
<wire x1="29.21" y1="1.905" x2="29.845" y2="2.54" width="0.1524" layer="21"/>
<wire x1="31.75" y1="1.905" x2="31.75" y2="-1.905" width="0.1524" layer="21"/>
<pad name="1" x="-30.48" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="2" x="-30.48" y="1.27" drill="1.016" shape="octagon"/>
<pad name="3" x="-27.94" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="4" x="-27.94" y="1.27" drill="1.016" shape="octagon"/>
<pad name="5" x="-25.4" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="6" x="-25.4" y="1.27" drill="1.016" shape="octagon"/>
<pad name="7" x="-22.86" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="8" x="-22.86" y="1.27" drill="1.016" shape="octagon"/>
<pad name="9" x="-20.32" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="10" x="-20.32" y="1.27" drill="1.016" shape="octagon"/>
<pad name="11" x="-17.78" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="12" x="-17.78" y="1.27" drill="1.016" shape="octagon"/>
<pad name="13" x="-15.24" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="14" x="-15.24" y="1.27" drill="1.016" shape="octagon"/>
<pad name="15" x="-12.7" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="16" x="-12.7" y="1.27" drill="1.016" shape="octagon"/>
<pad name="17" x="-10.16" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="18" x="-10.16" y="1.27" drill="1.016" shape="octagon"/>
<pad name="19" x="-7.62" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="20" x="-7.62" y="1.27" drill="1.016" shape="octagon"/>
<pad name="21" x="-5.08" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="22" x="-5.08" y="1.27" drill="1.016" shape="octagon"/>
<pad name="23" x="-2.54" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="24" x="-2.54" y="1.27" drill="1.016" shape="octagon"/>
<pad name="25" x="0" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="26" x="0" y="1.27" drill="1.016" shape="octagon"/>
<pad name="27" x="2.54" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="28" x="2.54" y="1.27" drill="1.016" shape="octagon"/>
<pad name="29" x="5.08" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="30" x="5.08" y="1.27" drill="1.016" shape="octagon"/>
<pad name="31" x="7.62" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="32" x="7.62" y="1.27" drill="1.016" shape="octagon"/>
<pad name="33" x="10.16" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="34" x="10.16" y="1.27" drill="1.016" shape="octagon"/>
<pad name="35" x="12.7" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="36" x="12.7" y="1.27" drill="1.016" shape="octagon"/>
<pad name="37" x="15.24" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="38" x="15.24" y="1.27" drill="1.016" shape="octagon"/>
<pad name="39" x="17.78" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="40" x="17.78" y="1.27" drill="1.016" shape="octagon"/>
<pad name="42" x="20.32" y="1.27" drill="1.016" shape="octagon"/>
<pad name="41" x="20.32" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="43" x="22.86" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="45" x="25.4" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="47" x="27.94" y="-1.27" drill="1.016" shape="octagon"/>
<pad name="48" x="27.94" y="1.27" drill="1.016" shape="octagon"/>
<pad name="46" x="25.4" y="1.27" drill="1.016" shape="octagon"/>
<pad name="44" x="22.86" y="1.27" drill="1.016" shape="octagon"/>
<pad name="50" x="30.48" y="1.27" drill="1.016" shape="octagon"/>
<pad name="49" x="30.48" y="-1.27" drill="1.016" shape="octagon"/>
<text x="-31.75" y="3.175" size="1.27" layer="25" ratio="10">&gt;NAME</text>
<text x="-31.75" y="-4.445" size="1.27" layer="27">&gt;VALUE</text>
<rectangle x1="-30.734" y1="-1.524" x2="-30.226" y2="-1.016" layer="51"/>
<rectangle x1="-30.734" y1="1.016" x2="-30.226" y2="1.524" layer="51"/>
<rectangle x1="-28.194" y1="1.016" x2="-27.686" y2="1.524" layer="51"/>
<rectangle x1="-28.194" y1="-1.524" x2="-27.686" y2="-1.016" layer="51"/>
<rectangle x1="-25.654" y1="1.016" x2="-25.146" y2="1.524" layer="51"/>
<rectangle x1="-25.654" y1="-1.524" x2="-25.146" y2="-1.016" layer="51"/>
<rectangle x1="-23.114" y1="1.016" x2="-22.606" y2="1.524" layer="51"/>
<rectangle x1="-20.574" y1="1.016" x2="-20.066" y2="1.524" layer="51"/>
<rectangle x1="-18.034" y1="1.016" x2="-17.526" y2="1.524" layer="51"/>
<rectangle x1="-23.114" y1="-1.524" x2="-22.606" y2="-1.016" layer="51"/>
<rectangle x1="-20.574" y1="-1.524" x2="-20.066" y2="-1.016" layer="51"/>
<rectangle x1="-18.034" y1="-1.524" x2="-17.526" y2="-1.016" layer="51"/>
<rectangle x1="-15.494" y1="1.016" x2="-14.986" y2="1.524" layer="51"/>
<rectangle x1="-15.494" y1="-1.524" x2="-14.986" y2="-1.016" layer="51"/>
<rectangle x1="-12.954" y1="1.016" x2="-12.446" y2="1.524" layer="51"/>
<rectangle x1="-12.954" y1="-1.524" x2="-12.446" y2="-1.016" layer="51"/>
<rectangle x1="-10.414" y1="1.016" x2="-9.906" y2="1.524" layer="51"/>
<rectangle x1="-10.414" y1="-1.524" x2="-9.906" y2="-1.016" layer="51"/>
<rectangle x1="-7.874" y1="1.016" x2="-7.366" y2="1.524" layer="51"/>
<rectangle x1="-7.874" y1="-1.524" x2="-7.366" y2="-1.016" layer="51"/>
<rectangle x1="-5.334" y1="1.016" x2="-4.826" y2="1.524" layer="51"/>
<rectangle x1="-5.334" y1="-1.524" x2="-4.826" y2="-1.016" layer="51"/>
<rectangle x1="-2.794" y1="1.016" x2="-2.286" y2="1.524" layer="51"/>
<rectangle x1="-2.794" y1="-1.524" x2="-2.286" y2="-1.016" layer="51"/>
<rectangle x1="-0.254" y1="1.016" x2="0.254" y2="1.524" layer="51"/>
<rectangle x1="-0.254" y1="-1.524" x2="0.254" y2="-1.016" layer="51"/>
<rectangle x1="2.286" y1="1.016" x2="2.794" y2="1.524" layer="51"/>
<rectangle x1="2.286" y1="-1.524" x2="2.794" y2="-1.016" layer="51"/>
<rectangle x1="4.826" y1="1.016" x2="5.334" y2="1.524" layer="51"/>
<rectangle x1="4.826" y1="-1.524" x2="5.334" y2="-1.016" layer="51"/>
<rectangle x1="7.366" y1="1.016" x2="7.874" y2="1.524" layer="51"/>
<rectangle x1="7.366" y1="-1.524" x2="7.874" y2="-1.016" layer="51"/>
<rectangle x1="9.906" y1="1.016" x2="10.414" y2="1.524" layer="51"/>
<rectangle x1="9.906" y1="-1.524" x2="10.414" y2="-1.016" layer="51"/>
<rectangle x1="12.446" y1="1.016" x2="12.954" y2="1.524" layer="51"/>
<rectangle x1="12.446" y1="-1.524" x2="12.954" y2="-1.016" layer="51"/>
<rectangle x1="14.986" y1="1.016" x2="15.494" y2="1.524" layer="51"/>
<rectangle x1="14.986" y1="-1.524" x2="15.494" y2="-1.016" layer="51"/>
<rectangle x1="17.526" y1="1.016" x2="18.034" y2="1.524" layer="51"/>
<rectangle x1="17.526" y1="-1.524" x2="18.034" y2="-1.016" layer="51"/>
<rectangle x1="20.066" y1="1.016" x2="20.574" y2="1.524" layer="51"/>
<rectangle x1="22.606" y1="1.016" x2="23.114" y2="1.524" layer="51"/>
<rectangle x1="25.146" y1="1.016" x2="25.654" y2="1.524" layer="51"/>
<rectangle x1="27.686" y1="1.016" x2="28.194" y2="1.524" layer="51"/>
<rectangle x1="30.226" y1="1.016" x2="30.734" y2="1.524" layer="51"/>
<rectangle x1="30.226" y1="-1.524" x2="30.734" y2="-1.016" layer="51"/>
<rectangle x1="27.686" y1="-1.524" x2="28.194" y2="-1.016" layer="51"/>
<rectangle x1="25.146" y1="-1.524" x2="25.654" y2="-1.016" layer="51"/>
<rectangle x1="22.606" y1="-1.524" x2="23.114" y2="-1.016" layer="51"/>
<rectangle x1="20.066" y1="-1.524" x2="20.574" y2="-1.016" layer="51"/>
</package>
<package name="57102-F08-25">
<description>&lt;b&gt;UNSH HEADER&lt;/b&gt; 2.0mm VERTICAL TMT&lt;p&gt;
Source: https://portal.fciconnect.com/res/en/pdffiles/doc_search/57102.pdf</description>
<wire x1="-10" y1="2" x2="40" y2="2" width="0.2032" layer="21"/>
<wire x1="40" y1="2" x2="40" y2="-2" width="0.2032" layer="21"/>
<wire x1="40" y1="-2" x2="-10" y2="-2" width="0.2032" layer="21"/>
<wire x1="-10" y1="-2" x2="-10" y2="2" width="0.2032" layer="21"/>
<pad name="1" x="-9" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="2" x="-9" y="1" drill="0.8" diameter="1.4224"/>
<pad name="3" x="-7" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="4" x="-7" y="1" drill="0.8" diameter="1.4224"/>
<pad name="5" x="-5" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="6" x="-5" y="1" drill="0.8" diameter="1.4224"/>
<pad name="7" x="-3" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="8" x="-3" y="1" drill="0.8" diameter="1.4224"/>
<pad name="9" x="-1" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="10" x="-1" y="1" drill="0.8" diameter="1.4224"/>
<pad name="11" x="1" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="12" x="1" y="1" drill="0.8" diameter="1.4224"/>
<pad name="13" x="3" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="14" x="3" y="1" drill="0.8" diameter="1.4224"/>
<pad name="15" x="5" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="16" x="5" y="1" drill="0.8" diameter="1.4224"/>
<pad name="17" x="7" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="18" x="7" y="1" drill="0.8" diameter="1.4224"/>
<pad name="19" x="9" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="20" x="9" y="1" drill="0.8" diameter="1.4224"/>
<pad name="21" x="11" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="22" x="11" y="1" drill="0.8" diameter="1.4224"/>
<pad name="23" x="13" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="24" x="13" y="1" drill="0.8" diameter="1.4224"/>
<pad name="25" x="15" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="26" x="15" y="1" drill="0.8" diameter="1.4224"/>
<pad name="27" x="17" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="28" x="17" y="1" drill="0.8" diameter="1.4224"/>
<pad name="29" x="19" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="30" x="19" y="1" drill="0.8" diameter="1.4224"/>
<pad name="31" x="21" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="32" x="21" y="1" drill="0.8" diameter="1.4224"/>
<pad name="33" x="23" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="34" x="23" y="1" drill="0.8" diameter="1.4224"/>
<pad name="35" x="25" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="36" x="25" y="1" drill="0.8" diameter="1.4224"/>
<pad name="37" x="27" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="38" x="27" y="1" drill="0.8" diameter="1.4224"/>
<pad name="39" x="29" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="40" x="29" y="1" drill="0.8" diameter="1.4224"/>
<pad name="41" x="31" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="42" x="31" y="1" drill="0.8" diameter="1.4224"/>
<pad name="43" x="33" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="44" x="33" y="1" drill="0.8" diameter="1.4224"/>
<pad name="45" x="35" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="46" x="35" y="1" drill="0.8" diameter="1.4224"/>
<pad name="47" x="37" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="48" x="37" y="1" drill="0.8" diameter="1.4224"/>
<pad name="49" x="39" y="-1" drill="0.8" diameter="1.4224"/>
<pad name="50" x="39" y="1" drill="0.8" diameter="1.4224"/>
<text x="-8.89" y="2.54" size="1.27" layer="25">&gt;NAME</text>
<text x="-8.89" y="-4.445" size="1.27" layer="27">&gt;VALUE</text>
</package>
<package name="2X25/90">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<wire x1="-30.48" y1="-1.905" x2="-27.94" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-27.94" y1="-1.905" x2="-27.94" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-27.94" y1="0.635" x2="-30.48" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-30.48" y1="0.635" x2="-30.48" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-29.21" y1="6.985" x2="-29.21" y2="1.27" width="0.762" layer="21"/>
<wire x1="-27.94" y1="-1.905" x2="-25.4" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-25.4" y1="-1.905" x2="-25.4" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-25.4" y1="0.635" x2="-27.94" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-26.67" y1="6.985" x2="-26.67" y2="1.27" width="0.762" layer="21"/>
<wire x1="-25.4" y1="-1.905" x2="-22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="-1.905" x2="-22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-22.86" y1="0.635" x2="-25.4" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-24.13" y1="6.985" x2="-24.13" y2="1.27" width="0.762" layer="21"/>
<wire x1="-22.86" y1="-1.905" x2="-20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="-1.905" x2="-20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-20.32" y1="0.635" x2="-22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-21.59" y1="6.985" x2="-21.59" y2="1.27" width="0.762" layer="21"/>
<wire x1="-20.32" y1="-1.905" x2="-17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="-1.905" x2="-17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-17.78" y1="0.635" x2="-20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-19.05" y1="6.985" x2="-19.05" y2="1.27" width="0.762" layer="21"/>
<wire x1="-17.78" y1="-1.905" x2="-15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="-1.905" x2="-15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-15.24" y1="0.635" x2="-17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-16.51" y1="6.985" x2="-16.51" y2="1.27" width="0.762" layer="21"/>
<wire x1="-15.24" y1="-1.905" x2="-12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="-1.905" x2="-12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-12.7" y1="0.635" x2="-15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-13.97" y1="6.985" x2="-13.97" y2="1.27" width="0.762" layer="21"/>
<wire x1="-12.7" y1="-1.905" x2="-10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="-1.905" x2="-10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-10.16" y1="0.635" x2="-12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-11.43" y1="6.985" x2="-11.43" y2="1.27" width="0.762" layer="21"/>
<wire x1="-10.16" y1="-1.905" x2="-7.62" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="-1.905" x2="-7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-7.62" y1="0.635" x2="-10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-8.89" y1="6.985" x2="-8.89" y2="1.27" width="0.762" layer="21"/>
<wire x1="-7.62" y1="-1.905" x2="-5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="-1.905" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-5.08" y1="0.635" x2="-7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-6.35" y1="6.985" x2="-6.35" y2="1.27" width="0.762" layer="21"/>
<wire x1="-5.08" y1="-1.905" x2="-2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-2.54" y1="0.635" x2="-5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-3.81" y1="6.985" x2="-3.81" y2="1.27" width="0.762" layer="21"/>
<wire x1="-2.54" y1="-1.905" x2="0" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="0" y1="-1.905" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="0" y1="0.635" x2="-2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="-1.27" y1="6.985" x2="-1.27" y2="1.27" width="0.762" layer="21"/>
<wire x1="0" y1="-1.905" x2="2.54" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="2.54" y1="0.635" x2="0" y2="0.635" width="0.1524" layer="21"/>
<wire x1="1.27" y1="6.985" x2="1.27" y2="1.27" width="0.762" layer="21"/>
<wire x1="2.54" y1="-1.905" x2="5.08" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="5.08" y1="0.635" x2="2.54" y2="0.635" width="0.1524" layer="21"/>
<wire x1="3.81" y1="6.985" x2="3.81" y2="1.27" width="0.762" layer="21"/>
<wire x1="5.08" y1="-1.905" x2="7.62" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="7.62" y1="-1.905" x2="7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="7.62" y1="0.635" x2="5.08" y2="0.635" width="0.1524" layer="21"/>
<wire x1="6.35" y1="6.985" x2="6.35" y2="1.27" width="0.762" layer="21"/>
<wire x1="7.62" y1="-1.905" x2="10.16" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="10.16" y1="-1.905" x2="10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="10.16" y1="0.635" x2="7.62" y2="0.635" width="0.1524" layer="21"/>
<wire x1="8.89" y1="6.985" x2="8.89" y2="1.27" width="0.762" layer="21"/>
<wire x1="10.16" y1="-1.905" x2="12.7" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="12.7" y1="-1.905" x2="12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="12.7" y1="0.635" x2="10.16" y2="0.635" width="0.1524" layer="21"/>
<wire x1="11.43" y1="6.985" x2="11.43" y2="1.27" width="0.762" layer="21"/>
<wire x1="12.7" y1="-1.905" x2="15.24" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="15.24" y1="-1.905" x2="15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="15.24" y1="0.635" x2="12.7" y2="0.635" width="0.1524" layer="21"/>
<wire x1="13.97" y1="6.985" x2="13.97" y2="1.27" width="0.762" layer="21"/>
<wire x1="15.24" y1="-1.905" x2="17.78" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="17.78" y1="-1.905" x2="17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="17.78" y1="0.635" x2="15.24" y2="0.635" width="0.1524" layer="21"/>
<wire x1="16.51" y1="6.985" x2="16.51" y2="1.27" width="0.762" layer="21"/>
<wire x1="17.78" y1="-1.905" x2="20.32" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="20.32" y1="-1.905" x2="20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="20.32" y1="0.635" x2="17.78" y2="0.635" width="0.1524" layer="21"/>
<wire x1="19.05" y1="6.985" x2="19.05" y2="1.27" width="0.762" layer="21"/>
<wire x1="20.32" y1="-1.905" x2="22.86" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="22.86" y1="-1.905" x2="22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="22.86" y1="0.635" x2="20.32" y2="0.635" width="0.1524" layer="21"/>
<wire x1="21.59" y1="6.985" x2="21.59" y2="1.27" width="0.762" layer="21"/>
<wire x1="22.86" y1="-1.905" x2="25.4" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="25.4" y1="0.635" x2="22.86" y2="0.635" width="0.1524" layer="21"/>
<wire x1="24.13" y1="6.985" x2="24.13" y2="1.27" width="0.762" layer="21"/>
<wire x1="25.4" y1="-1.905" x2="25.4" y2="0.635" width="0.1524" layer="21"/>
<wire x1="25.4" y1="-1.905" x2="27.94" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="27.94" y1="-1.905" x2="27.94" y2="0.635" width="0.1524" layer="21"/>
<wire x1="27.94" y1="0.635" x2="25.4" y2="0.635" width="0.1524" layer="21"/>
<wire x1="26.67" y1="6.985" x2="26.67" y2="1.27" width="0.762" layer="21"/>
<wire x1="27.94" y1="-1.905" x2="30.48" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="30.48" y1="-1.905" x2="30.48" y2="0.635" width="0.1524" layer="21"/>
<wire x1="30.48" y1="0.635" x2="27.94" y2="0.635" width="0.1524" layer="21"/>
<wire x1="29.21" y1="6.985" x2="29.21" y2="1.27" width="0.762" layer="21"/>
<wire x1="30.48" y1="-1.905" x2="33.02" y2="-1.905" width="0.1524" layer="21"/>
<wire x1="33.02" y1="-1.905" x2="33.02" y2="0.635" width="0.1524" layer="21"/>
<wire x1="33.02" y1="0.635" x2="30.48" y2="0.635" width="0.1524" layer="21"/>
<wire x1="31.75" y1="6.985" x2="31.75" y2="1.27" width="0.762" layer="21"/>
<pad name="2" x="-29.21" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="4" x="-26.67" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="6" x="-24.13" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="8" x="-21.59" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="10" x="-19.05" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="12" x="-16.51" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="14" x="-13.97" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="16" x="-11.43" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="18" x="-8.89" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="20" x="-6.35" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="22" x="-3.81" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="24" x="-1.27" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="26" x="1.27" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="28" x="3.81" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="30" x="6.35" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="32" x="8.89" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="34" x="11.43" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="36" x="13.97" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="38" x="16.51" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="1" x="-29.21" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="3" x="-26.67" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="5" x="-24.13" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="7" x="-21.59" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="9" x="-19.05" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="11" x="-16.51" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="13" x="-13.97" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="15" x="-11.43" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="17" x="-8.89" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="19" x="-6.35" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="21" x="-3.81" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="23" x="-1.27" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="25" x="1.27" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="27" x="3.81" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="29" x="6.35" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="31" x="8.89" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="33" x="11.43" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="35" x="13.97" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="37" x="16.51" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="40" x="19.05" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="39" x="19.05" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="41" x="21.59" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="42" x="21.59" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="43" x="24.13" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="44" x="24.13" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="45" x="26.67" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="46" x="26.67" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="47" x="29.21" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="48" x="29.21" y="-6.35" drill="1.016" shape="octagon"/>
<pad name="49" x="31.75" y="-3.81" drill="1.016" shape="octagon"/>
<pad name="50" x="31.75" y="-6.35" drill="1.016" shape="octagon"/>
<text x="-31.115" y="-3.81" size="1.27" layer="25" ratio="10" rot="R90">&gt;NAME</text>
<text x="34.925" y="-4.445" size="1.27" layer="27" rot="R90">&gt;VALUE</text>
<rectangle x1="-29.591" y1="0.635" x2="-28.829" y2="1.143" layer="21"/>
<rectangle x1="-27.051" y1="0.635" x2="-26.289" y2="1.143" layer="21"/>
<rectangle x1="-24.511" y1="0.635" x2="-23.749" y2="1.143" layer="21"/>
<rectangle x1="-21.971" y1="0.635" x2="-21.209" y2="1.143" layer="21"/>
<rectangle x1="-19.431" y1="0.635" x2="-18.669" y2="1.143" layer="21"/>
<rectangle x1="-16.891" y1="0.635" x2="-16.129" y2="1.143" layer="21"/>
<rectangle x1="-14.351" y1="0.635" x2="-13.589" y2="1.143" layer="21"/>
<rectangle x1="-11.811" y1="0.635" x2="-11.049" y2="1.143" layer="21"/>
<rectangle x1="-9.271" y1="0.635" x2="-8.509" y2="1.143" layer="21"/>
<rectangle x1="-6.731" y1="0.635" x2="-5.969" y2="1.143" layer="21"/>
<rectangle x1="-4.191" y1="0.635" x2="-3.429" y2="1.143" layer="21"/>
<rectangle x1="-1.651" y1="0.635" x2="-0.889" y2="1.143" layer="21"/>
<rectangle x1="0.889" y1="0.635" x2="1.651" y2="1.143" layer="21"/>
<rectangle x1="3.429" y1="0.635" x2="4.191" y2="1.143" layer="21"/>
<rectangle x1="5.969" y1="0.635" x2="6.731" y2="1.143" layer="21"/>
<rectangle x1="8.509" y1="0.635" x2="9.271" y2="1.143" layer="21"/>
<rectangle x1="11.049" y1="0.635" x2="11.811" y2="1.143" layer="21"/>
<rectangle x1="13.589" y1="0.635" x2="14.351" y2="1.143" layer="21"/>
<rectangle x1="16.129" y1="0.635" x2="16.891" y2="1.143" layer="21"/>
<rectangle x1="18.669" y1="0.635" x2="19.431" y2="1.143" layer="21"/>
<rectangle x1="-29.591" y1="-2.921" x2="-28.829" y2="-1.905" layer="21"/>
<rectangle x1="-27.051" y1="-2.921" x2="-26.289" y2="-1.905" layer="21"/>
<rectangle x1="-29.591" y1="-5.461" x2="-28.829" y2="-4.699" layer="21"/>
<rectangle x1="-29.591" y1="-4.699" x2="-28.829" y2="-2.921" layer="51"/>
<rectangle x1="-27.051" y1="-4.699" x2="-26.289" y2="-2.921" layer="51"/>
<rectangle x1="-27.051" y1="-5.461" x2="-26.289" y2="-4.699" layer="21"/>
<rectangle x1="-24.511" y1="-2.921" x2="-23.749" y2="-1.905" layer="21"/>
<rectangle x1="-21.971" y1="-2.921" x2="-21.209" y2="-1.905" layer="21"/>
<rectangle x1="-24.511" y1="-5.461" x2="-23.749" y2="-4.699" layer="21"/>
<rectangle x1="-24.511" y1="-4.699" x2="-23.749" y2="-2.921" layer="51"/>
<rectangle x1="-21.971" y1="-4.699" x2="-21.209" y2="-2.921" layer="51"/>
<rectangle x1="-21.971" y1="-5.461" x2="-21.209" y2="-4.699" layer="21"/>
<rectangle x1="-19.431" y1="-2.921" x2="-18.669" y2="-1.905" layer="21"/>
<rectangle x1="-19.431" y1="-5.461" x2="-18.669" y2="-4.699" layer="21"/>
<rectangle x1="-19.431" y1="-4.699" x2="-18.669" y2="-2.921" layer="51"/>
<rectangle x1="-16.891" y1="-2.921" x2="-16.129" y2="-1.905" layer="21"/>
<rectangle x1="-14.351" y1="-2.921" x2="-13.589" y2="-1.905" layer="21"/>
<rectangle x1="-16.891" y1="-5.461" x2="-16.129" y2="-4.699" layer="21"/>
<rectangle x1="-16.891" y1="-4.699" x2="-16.129" y2="-2.921" layer="51"/>
<rectangle x1="-14.351" y1="-4.699" x2="-13.589" y2="-2.921" layer="51"/>
<rectangle x1="-14.351" y1="-5.461" x2="-13.589" y2="-4.699" layer="21"/>
<rectangle x1="-11.811" y1="-2.921" x2="-11.049" y2="-1.905" layer="21"/>
<rectangle x1="-9.271" y1="-2.921" x2="-8.509" y2="-1.905" layer="21"/>
<rectangle x1="-11.811" y1="-5.461" x2="-11.049" y2="-4.699" layer="21"/>
<rectangle x1="-11.811" y1="-4.699" x2="-11.049" y2="-2.921" layer="51"/>
<rectangle x1="-9.271" y1="-4.699" x2="-8.509" y2="-2.921" layer="51"/>
<rectangle x1="-9.271" y1="-5.461" x2="-8.509" y2="-4.699" layer="21"/>
<rectangle x1="-6.731" y1="-2.921" x2="-5.969" y2="-1.905" layer="21"/>
<rectangle x1="-6.731" y1="-5.461" x2="-5.969" y2="-4.699" layer="21"/>
<rectangle x1="-6.731" y1="-4.699" x2="-5.969" y2="-2.921" layer="51"/>
<rectangle x1="-4.191" y1="-2.921" x2="-3.429" y2="-1.905" layer="21"/>
<rectangle x1="-1.651" y1="-2.921" x2="-0.889" y2="-1.905" layer="21"/>
<rectangle x1="-4.191" y1="-5.461" x2="-3.429" y2="-4.699" layer="21"/>
<rectangle x1="-4.191" y1="-4.699" x2="-3.429" y2="-2.921" layer="51"/>
<rectangle x1="-1.651" y1="-4.699" x2="-0.889" y2="-2.921" layer="51"/>
<rectangle x1="-1.651" y1="-5.461" x2="-0.889" y2="-4.699" layer="21"/>
<rectangle x1="0.889" y1="-2.921" x2="1.651" y2="-1.905" layer="21"/>
<rectangle x1="3.429" y1="-2.921" x2="4.191" y2="-1.905" layer="21"/>
<rectangle x1="0.889" y1="-5.461" x2="1.651" y2="-4.699" layer="21"/>
<rectangle x1="0.889" y1="-4.699" x2="1.651" y2="-2.921" layer="51"/>
<rectangle x1="3.429" y1="-4.699" x2="4.191" y2="-2.921" layer="51"/>
<rectangle x1="3.429" y1="-5.461" x2="4.191" y2="-4.699" layer="21"/>
<rectangle x1="5.969" y1="-2.921" x2="6.731" y2="-1.905" layer="21"/>
<rectangle x1="5.969" y1="-5.461" x2="6.731" y2="-4.699" layer="21"/>
<rectangle x1="5.969" y1="-4.699" x2="6.731" y2="-2.921" layer="51"/>
<rectangle x1="8.509" y1="-2.921" x2="9.271" y2="-1.905" layer="21"/>
<rectangle x1="11.049" y1="-2.921" x2="11.811" y2="-1.905" layer="21"/>
<rectangle x1="8.509" y1="-5.461" x2="9.271" y2="-4.699" layer="21"/>
<rectangle x1="8.509" y1="-4.699" x2="9.271" y2="-2.921" layer="51"/>
<rectangle x1="11.049" y1="-4.699" x2="11.811" y2="-2.921" layer="51"/>
<rectangle x1="11.049" y1="-5.461" x2="11.811" y2="-4.699" layer="21"/>
<rectangle x1="13.589" y1="-2.921" x2="14.351" y2="-1.905" layer="21"/>
<rectangle x1="16.129" y1="-2.921" x2="16.891" y2="-1.905" layer="21"/>
<rectangle x1="13.589" y1="-5.461" x2="14.351" y2="-4.699" layer="21"/>
<rectangle x1="13.589" y1="-4.699" x2="14.351" y2="-2.921" layer="51"/>
<rectangle x1="16.129" y1="-4.699" x2="16.891" y2="-2.921" layer="51"/>
<rectangle x1="16.129" y1="-5.461" x2="16.891" y2="-4.699" layer="21"/>
<rectangle x1="18.669" y1="-2.921" x2="19.431" y2="-1.905" layer="21"/>
<rectangle x1="18.669" y1="-5.461" x2="19.431" y2="-4.699" layer="21"/>
<rectangle x1="18.669" y1="-4.699" x2="19.431" y2="-2.921" layer="51"/>
<rectangle x1="21.209" y1="0.635" x2="21.971" y2="1.143" layer="21"/>
<rectangle x1="23.749" y1="0.635" x2="24.511" y2="1.143" layer="21"/>
<rectangle x1="21.209" y1="-2.921" x2="21.971" y2="-1.905" layer="21"/>
<rectangle x1="21.209" y1="-4.699" x2="21.971" y2="-2.921" layer="51"/>
<rectangle x1="21.209" y1="-5.461" x2="21.971" y2="-4.699" layer="21"/>
<rectangle x1="23.749" y1="-2.921" x2="24.511" y2="-1.905" layer="21"/>
<rectangle x1="23.749" y1="-5.461" x2="24.511" y2="-4.699" layer="21"/>
<rectangle x1="23.749" y1="-4.699" x2="24.511" y2="-2.921" layer="51"/>
<rectangle x1="26.289" y1="0.635" x2="27.051" y2="1.143" layer="21"/>
<rectangle x1="28.829" y1="0.635" x2="29.591" y2="1.143" layer="21"/>
<rectangle x1="26.289" y1="-2.921" x2="27.051" y2="-1.905" layer="21"/>
<rectangle x1="26.289" y1="-4.699" x2="27.051" y2="-2.921" layer="51"/>
<rectangle x1="26.289" y1="-5.461" x2="27.051" y2="-4.699" layer="21"/>
<rectangle x1="28.829" y1="-2.921" x2="29.591" y2="-1.905" layer="21"/>
<rectangle x1="28.829" y1="-5.461" x2="29.591" y2="-4.699" layer="21"/>
<rectangle x1="28.829" y1="-4.699" x2="29.591" y2="-2.921" layer="51"/>
<rectangle x1="31.369" y1="0.635" x2="32.131" y2="1.143" layer="21"/>
<rectangle x1="31.369" y1="-2.921" x2="32.131" y2="-1.905" layer="21"/>
<rectangle x1="31.369" y1="-4.699" x2="32.131" y2="-2.921" layer="51"/>
<rectangle x1="31.369" y1="-5.461" x2="32.131" y2="-4.699" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="PINH2X25">
<wire x1="-6.35" y1="-33.02" x2="8.89" y2="-33.02" width="0.4064" layer="94"/>
<wire x1="8.89" y1="-33.02" x2="8.89" y2="33.02" width="0.4064" layer="94"/>
<wire x1="8.89" y1="33.02" x2="-6.35" y2="33.02" width="0.4064" layer="94"/>
<wire x1="-6.35" y1="33.02" x2="-6.35" y2="-33.02" width="0.4064" layer="94"/>
<text x="-6.35" y="33.655" size="1.778" layer="95">&gt;NAME</text>
<text x="-6.35" y="-35.56" size="1.778" layer="96">&gt;VALUE</text>
<pin name="1" x="-2.54" y="30.48" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="2" x="5.08" y="30.48" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="3" x="-2.54" y="27.94" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="4" x="5.08" y="27.94" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="5" x="-2.54" y="25.4" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="6" x="5.08" y="25.4" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="7" x="-2.54" y="22.86" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="8" x="5.08" y="22.86" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="9" x="-2.54" y="20.32" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="10" x="5.08" y="20.32" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="11" x="-2.54" y="17.78" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="12" x="5.08" y="17.78" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="13" x="-2.54" y="15.24" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="14" x="5.08" y="15.24" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="15" x="-2.54" y="12.7" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="16" x="5.08" y="12.7" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="17" x="-2.54" y="10.16" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="18" x="5.08" y="10.16" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="19" x="-2.54" y="7.62" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="20" x="5.08" y="7.62" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="21" x="-2.54" y="5.08" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="22" x="5.08" y="5.08" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="23" x="-2.54" y="2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="24" x="5.08" y="2.54" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="25" x="-2.54" y="0" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="26" x="5.08" y="0" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="27" x="-2.54" y="-2.54" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="28" x="5.08" y="-2.54" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="29" x="-2.54" y="-5.08" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="30" x="5.08" y="-5.08" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="31" x="-2.54" y="-7.62" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="32" x="5.08" y="-7.62" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="33" x="-2.54" y="-10.16" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="34" x="5.08" y="-10.16" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="35" x="-2.54" y="-12.7" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="36" x="5.08" y="-12.7" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="37" x="-2.54" y="-15.24" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="38" x="5.08" y="-15.24" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="39" x="-2.54" y="-17.78" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="40" x="5.08" y="-17.78" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="41" x="-2.54" y="-20.32" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="42" x="5.08" y="-20.32" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="43" x="-2.54" y="-22.86" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="44" x="5.08" y="-22.86" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="45" x="-2.54" y="-25.4" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="46" x="5.08" y="-25.4" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="47" x="-2.54" y="-27.94" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="48" x="5.08" y="-27.94" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
<pin name="49" x="-2.54" y="-30.48" visible="pad" length="short" direction="pas" function="dot"/>
<pin name="50" x="5.08" y="-30.48" visible="pad" length="short" direction="pas" function="dot" rot="R180"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="PINHD-2X25" prefix="JP" uservalue="yes">
<description>&lt;b&gt;PIN HEADER&lt;/b&gt;</description>
<gates>
<gate name="A" symbol="PINH2X25" x="0" y="0"/>
</gates>
<devices>
<device name="" package="2X25">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="10" pad="10"/>
<connect gate="A" pin="11" pad="11"/>
<connect gate="A" pin="12" pad="12"/>
<connect gate="A" pin="13" pad="13"/>
<connect gate="A" pin="14" pad="14"/>
<connect gate="A" pin="15" pad="15"/>
<connect gate="A" pin="16" pad="16"/>
<connect gate="A" pin="17" pad="17"/>
<connect gate="A" pin="18" pad="18"/>
<connect gate="A" pin="19" pad="19"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="20" pad="20"/>
<connect gate="A" pin="21" pad="21"/>
<connect gate="A" pin="22" pad="22"/>
<connect gate="A" pin="23" pad="23"/>
<connect gate="A" pin="24" pad="24"/>
<connect gate="A" pin="25" pad="25"/>
<connect gate="A" pin="26" pad="26"/>
<connect gate="A" pin="27" pad="27"/>
<connect gate="A" pin="28" pad="28"/>
<connect gate="A" pin="29" pad="29"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="30" pad="30"/>
<connect gate="A" pin="31" pad="31"/>
<connect gate="A" pin="32" pad="32"/>
<connect gate="A" pin="33" pad="33"/>
<connect gate="A" pin="34" pad="34"/>
<connect gate="A" pin="35" pad="35"/>
<connect gate="A" pin="36" pad="36"/>
<connect gate="A" pin="37" pad="37"/>
<connect gate="A" pin="38" pad="38"/>
<connect gate="A" pin="39" pad="39"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="40" pad="40"/>
<connect gate="A" pin="41" pad="41"/>
<connect gate="A" pin="42" pad="42"/>
<connect gate="A" pin="43" pad="43"/>
<connect gate="A" pin="44" pad="44"/>
<connect gate="A" pin="45" pad="45"/>
<connect gate="A" pin="46" pad="46"/>
<connect gate="A" pin="47" pad="47"/>
<connect gate="A" pin="48" pad="48"/>
<connect gate="A" pin="49" pad="49"/>
<connect gate="A" pin="5" pad="5"/>
<connect gate="A" pin="50" pad="50"/>
<connect gate="A" pin="6" pad="6"/>
<connect gate="A" pin="7" pad="7"/>
<connect gate="A" pin="8" pad="8"/>
<connect gate="A" pin="9" pad="9"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="_57102-F08-25" package="57102-F08-25">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="10" pad="10"/>
<connect gate="A" pin="11" pad="11"/>
<connect gate="A" pin="12" pad="12"/>
<connect gate="A" pin="13" pad="13"/>
<connect gate="A" pin="14" pad="14"/>
<connect gate="A" pin="15" pad="15"/>
<connect gate="A" pin="16" pad="16"/>
<connect gate="A" pin="17" pad="17"/>
<connect gate="A" pin="18" pad="18"/>
<connect gate="A" pin="19" pad="19"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="20" pad="20"/>
<connect gate="A" pin="21" pad="21"/>
<connect gate="A" pin="22" pad="22"/>
<connect gate="A" pin="23" pad="23"/>
<connect gate="A" pin="24" pad="24"/>
<connect gate="A" pin="25" pad="25"/>
<connect gate="A" pin="26" pad="26"/>
<connect gate="A" pin="27" pad="27"/>
<connect gate="A" pin="28" pad="28"/>
<connect gate="A" pin="29" pad="29"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="30" pad="30"/>
<connect gate="A" pin="31" pad="31"/>
<connect gate="A" pin="32" pad="32"/>
<connect gate="A" pin="33" pad="33"/>
<connect gate="A" pin="34" pad="34"/>
<connect gate="A" pin="35" pad="35"/>
<connect gate="A" pin="36" pad="36"/>
<connect gate="A" pin="37" pad="37"/>
<connect gate="A" pin="38" pad="38"/>
<connect gate="A" pin="39" pad="39"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="40" pad="40"/>
<connect gate="A" pin="41" pad="41"/>
<connect gate="A" pin="42" pad="42"/>
<connect gate="A" pin="43" pad="43"/>
<connect gate="A" pin="44" pad="44"/>
<connect gate="A" pin="45" pad="45"/>
<connect gate="A" pin="46" pad="46"/>
<connect gate="A" pin="47" pad="47"/>
<connect gate="A" pin="48" pad="48"/>
<connect gate="A" pin="49" pad="49"/>
<connect gate="A" pin="5" pad="5"/>
<connect gate="A" pin="50" pad="50"/>
<connect gate="A" pin="6" pad="6"/>
<connect gate="A" pin="7" pad="7"/>
<connect gate="A" pin="8" pad="8"/>
<connect gate="A" pin="9" pad="9"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
<device name="/90" package="2X25/90">
<connects>
<connect gate="A" pin="1" pad="1"/>
<connect gate="A" pin="10" pad="10"/>
<connect gate="A" pin="11" pad="11"/>
<connect gate="A" pin="12" pad="12"/>
<connect gate="A" pin="13" pad="13"/>
<connect gate="A" pin="14" pad="14"/>
<connect gate="A" pin="15" pad="15"/>
<connect gate="A" pin="16" pad="16"/>
<connect gate="A" pin="17" pad="17"/>
<connect gate="A" pin="18" pad="18"/>
<connect gate="A" pin="19" pad="19"/>
<connect gate="A" pin="2" pad="2"/>
<connect gate="A" pin="20" pad="20"/>
<connect gate="A" pin="21" pad="21"/>
<connect gate="A" pin="22" pad="22"/>
<connect gate="A" pin="23" pad="23"/>
<connect gate="A" pin="24" pad="24"/>
<connect gate="A" pin="25" pad="25"/>
<connect gate="A" pin="26" pad="26"/>
<connect gate="A" pin="27" pad="27"/>
<connect gate="A" pin="28" pad="28"/>
<connect gate="A" pin="29" pad="29"/>
<connect gate="A" pin="3" pad="3"/>
<connect gate="A" pin="30" pad="30"/>
<connect gate="A" pin="31" pad="31"/>
<connect gate="A" pin="32" pad="32"/>
<connect gate="A" pin="33" pad="33"/>
<connect gate="A" pin="34" pad="34"/>
<connect gate="A" pin="35" pad="35"/>
<connect gate="A" pin="36" pad="36"/>
<connect gate="A" pin="37" pad="37"/>
<connect gate="A" pin="38" pad="38"/>
<connect gate="A" pin="39" pad="39"/>
<connect gate="A" pin="4" pad="4"/>
<connect gate="A" pin="40" pad="40"/>
<connect gate="A" pin="41" pad="41"/>
<connect gate="A" pin="42" pad="42"/>
<connect gate="A" pin="43" pad="43"/>
<connect gate="A" pin="44" pad="44"/>
<connect gate="A" pin="45" pad="45"/>
<connect gate="A" pin="46" pad="46"/>
<connect gate="A" pin="47" pad="47"/>
<connect gate="A" pin="48" pad="48"/>
<connect gate="A" pin="49" pad="49"/>
<connect gate="A" pin="5" pad="5"/>
<connect gate="A" pin="50" pad="50"/>
<connect gate="A" pin="6" pad="6"/>
<connect gate="A" pin="7" pad="7"/>
<connect gate="A" pin="8" pad="8"/>
<connect gate="A" pin="9" pad="9"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="supply1">
<description>&lt;b&gt;Supply Symbols&lt;/b&gt;&lt;p&gt;
 GND, VCC, 0V, +5V, -5V, etc.&lt;p&gt;
 Please keep in mind, that these devices are necessary for the
 automatic wiring of the supply signals.&lt;p&gt;
 The pin name defined in the symbol is identical to the net which is to be wired automatically.&lt;p&gt;
 In this library the device names are the same as the pin names of the symbols, therefore the correct signal names appear next to the supply symbols in the schematic.&lt;p&gt;
 &lt;author&gt;Created by librarian@cadsoft.de&lt;/author&gt;</description>
<packages>
</packages>
<symbols>
<symbol name="GND">
<wire x1="-1.905" y1="0" x2="1.905" y2="0" width="0.254" layer="94"/>
<text x="-2.54" y="-2.54" size="1.778" layer="96">&gt;VALUE</text>
<pin name="GND" x="0" y="2.54" visible="off" length="short" direction="sup" rot="R270"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="GND" prefix="GND">
<description>&lt;b&gt;SUPPLY SYMBOL&lt;/b&gt;</description>
<gates>
<gate name="1" symbol="GND" x="0" y="0"/>
</gates>
<devices>
<device name="">
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="hirose-fx2-100">
<description>HIROSE FX2-100S-1.27DS *** A - lower *** B - upper *** 
By Peter Dorman - 2007</description>
<packages>
<package name="HIROSE-FX2-100">
<wire x1="23.1775" y1="11.1125" x2="23.1775" y2="1.27" width="0.127" layer="21"/>
<wire x1="23.1775" y1="1.27" x2="23.495" y2="0.9525" width="0.127" layer="21"/>
<wire x1="23.495" y1="0.9525" x2="-50.165" y2="0.9525" width="0.127" layer="21"/>
<wire x1="-50.165" y1="0.9525" x2="-50.165" y2="11.1125" width="0.127" layer="21"/>
<wire x1="-50.165" y1="11.1125" x2="-45.72" y2="11.1125" width="0.127" layer="21"/>
<wire x1="-45.72" y1="11.1125" x2="23.1775" y2="11.1125" width="0.127" layer="21"/>
<wire x1="-45.72" y1="11.1125" x2="-45.72" y2="16.8275" width="0.127" layer="21"/>
<wire x1="-45.72" y1="16.8275" x2="-44.7675" y2="17.78" width="0.127" layer="21"/>
<wire x1="-44.7675" y1="17.78" x2="18.0975" y2="17.78" width="0.127" layer="21"/>
<wire x1="18.0975" y1="17.78" x2="19.05" y2="16.8275" width="0.127" layer="21"/>
<wire x1="19.05" y1="16.8275" x2="19.05" y2="11.1125" width="0.127" layer="21"/>
<wire x1="19.05" y1="11.1125" x2="19.3675" y2="10.795" width="0.127" layer="21"/>
<pad name="B29" x="-17.78" y="8.89" drill="0.8"/>
<pad name="B27" x="-15.24" y="8.89" drill="0.8"/>
<pad name="B25" x="-12.7" y="8.89" drill="0.8"/>
<pad name="B23" x="-10.16" y="8.89" drill="0.8"/>
<pad name="B21" x="-7.62" y="8.89" drill="0.8"/>
<pad name="B19" x="-5.08" y="8.89" drill="0.8"/>
<pad name="B17" x="-2.54" y="8.89" drill="0.8"/>
<pad name="B15" x="0" y="8.89" drill="0.8"/>
<pad name="B13" x="2.54" y="8.89" drill="0.8"/>
<pad name="B11" x="5.08" y="8.89" drill="0.8"/>
<pad name="B9" x="7.62" y="8.89" drill="0.8"/>
<pad name="B7" x="10.16" y="8.89" drill="0.8"/>
<pad name="B5" x="12.7" y="8.89" drill="0.8"/>
<pad name="B3" x="15.24" y="8.89" drill="0.8"/>
<pad name="B1" x="17.78" y="8.89" drill="0.8"/>
<pad name="B31" x="-20.32" y="8.89" drill="0.8"/>
<pad name="B33" x="-22.86" y="8.89" drill="0.8"/>
<pad name="B35" x="-25.4" y="8.89" drill="0.8"/>
<pad name="B37" x="-27.94" y="8.89" drill="0.8"/>
<pad name="B39" x="-30.48" y="8.89" drill="0.8"/>
<pad name="B41" x="-33.02" y="8.89" drill="0.8"/>
<pad name="B43" x="-35.56" y="8.89" drill="0.8"/>
<pad name="B45" x="-38.1" y="8.89" drill="0.8"/>
<pad name="B47" x="-40.64" y="8.89" drill="0.8"/>
<pad name="B49" x="-43.18" y="8.89" drill="0.8" rot="R90"/>
<pad name="B48" x="-41.91" y="6.985" drill="0.8"/>
<pad name="B50" x="-44.45" y="6.985" drill="0.8"/>
<pad name="B46" x="-39.37" y="6.985" drill="0.8"/>
<pad name="B44" x="-36.83" y="6.985" drill="0.8"/>
<pad name="B42" x="-34.29" y="6.985" drill="0.8"/>
<pad name="B40" x="-31.75" y="6.985" drill="0.8"/>
<pad name="B38" x="-29.21" y="6.985" drill="0.8"/>
<pad name="B36" x="-26.67" y="6.985" drill="0.8"/>
<pad name="B34" x="-24.13" y="6.985" drill="0.8"/>
<pad name="B32" x="-21.59" y="6.985" drill="0.8"/>
<pad name="B30" x="-19.05" y="6.985" drill="0.8"/>
<pad name="B28" x="-16.51" y="6.985" drill="0.8"/>
<pad name="B26" x="-13.97" y="6.985" drill="0.8"/>
<pad name="B24" x="-11.43" y="6.985" drill="0.8"/>
<pad name="B22" x="-8.89" y="6.985" drill="0.8"/>
<pad name="B20" x="-6.35" y="6.985" drill="0.8"/>
<pad name="B18" x="-3.81" y="6.985" drill="0.8"/>
<pad name="B16" x="-1.27" y="6.985" drill="0.8"/>
<pad name="B14" x="1.27" y="6.985" drill="0.8"/>
<pad name="B12" x="3.81" y="6.985" drill="0.8"/>
<pad name="B10" x="6.35" y="6.985" drill="0.8"/>
<pad name="B8" x="8.89" y="6.985" drill="0.8"/>
<pad name="B6" x="11.43" y="6.985" drill="0.8"/>
<pad name="B4" x="13.97" y="6.985" drill="0.8"/>
<pad name="B2" x="16.51" y="6.985" drill="0.8"/>
<pad name="A49" x="-43.18" y="5.08" drill="0.8"/>
<pad name="A47" x="-40.64" y="5.08" drill="0.8"/>
<pad name="A45" x="-38.1" y="5.08" drill="0.8"/>
<pad name="A43" x="-35.56" y="5.08" drill="0.8"/>
<pad name="A41" x="-33.02" y="5.08" drill="0.8"/>
<pad name="A39" x="-30.48" y="5.08" drill="0.8"/>
<pad name="A37" x="-27.94" y="5.08" drill="0.8"/>
<pad name="A35" x="-25.4" y="5.08" drill="0.8"/>
<pad name="A33" x="-22.86" y="5.08" drill="0.8"/>
<pad name="A31" x="-20.32" y="5.08" drill="0.8"/>
<pad name="A29" x="-17.78" y="5.08" drill="0.8"/>
<pad name="A27" x="-15.24" y="5.08" drill="0.8"/>
<pad name="A25" x="-12.7" y="5.08" drill="0.8"/>
<pad name="A23" x="-10.16" y="5.08" drill="0.8"/>
<pad name="A21" x="-7.62" y="5.08" drill="0.8"/>
<pad name="A19" x="-5.08" y="5.08" drill="0.8"/>
<pad name="A17" x="-2.54" y="5.08" drill="0.8"/>
<pad name="A15" x="0" y="5.08" drill="0.8"/>
<pad name="A13" x="2.54" y="5.08" drill="0.8"/>
<pad name="A11" x="5.08" y="5.08" drill="0.8"/>
<pad name="A9" x="7.62" y="5.08" drill="0.8"/>
<pad name="A7" x="10.16" y="5.08" drill="0.8"/>
<pad name="A5" x="12.7" y="5.08" drill="0.8"/>
<pad name="A3" x="15.24" y="5.08" drill="0.8"/>
<pad name="A1" x="17.78" y="5.08" drill="0.8"/>
<pad name="A50" x="-44.45" y="3.175" drill="0.8"/>
<pad name="A48" x="-41.91" y="3.175" drill="0.8"/>
<pad name="A46" x="-39.37" y="3.175" drill="0.8"/>
<pad name="A44" x="-36.83" y="3.175" drill="0.8"/>
<pad name="A42" x="-34.29" y="3.175" drill="0.8"/>
<pad name="A40" x="-31.75" y="3.175" drill="0.8"/>
<pad name="A38" x="-29.21" y="3.175" drill="0.8"/>
<pad name="A36" x="-26.67" y="3.175" drill="0.8"/>
<pad name="A34" x="-24.13" y="3.175" drill="0.8"/>
<pad name="A32" x="-21.59" y="3.175" drill="0.8"/>
<pad name="A30" x="-19.05" y="3.175" drill="0.8"/>
<pad name="A28" x="-16.51" y="3.175" drill="0.8"/>
<pad name="A26" x="-13.97" y="3.175" drill="0.8"/>
<pad name="A24" x="-11.43" y="3.175" drill="0.8"/>
<pad name="A22" x="-8.89" y="3.175" drill="0.8"/>
<pad name="A20" x="-6.35" y="3.175" drill="0.8"/>
<pad name="A18" x="-3.81" y="3.175" drill="0.8"/>
<pad name="A16" x="-1.27" y="3.175" drill="0.8"/>
<pad name="A14" x="1.27" y="3.175" drill="0.8"/>
<pad name="A12" x="3.81" y="3.175" drill="0.8"/>
<pad name="A10" x="6.35" y="3.175" drill="0.8"/>
<pad name="A8" x="8.89" y="3.175" drill="0.8"/>
<pad name="A6" x="11.43" y="3.175" drill="0.8"/>
<pad name="A4" x="13.97" y="3.175" drill="0.8"/>
<pad name="A2" x="16.51" y="3.175" drill="0.8"/>
<text x="21.2725" y="3.4925" size="1.27" layer="21">A</text>
<text x="21.2725" y="9.2075" size="1.27" layer="21">B</text>
<text x="-46.6725" y="6.35" size="1.27" layer="21">50</text>
<text x="-46.6725" y="8.255" size="1.27" layer="21">49</text>
<text x="-47.9425" y="2.54" size="1.27" layer="21">50</text>
<text x="-46.6725" y="4.445" size="1.27" layer="21">49</text>
<text x="18.0975" y="2.54" size="1.27" layer="21">2</text>
<text x="19.3675" y="4.1275" size="1.27" layer="21">1</text>
<text x="18.0975" y="6.35" size="1.27" layer="21">2</text>
<text x="19.3675" y="8.255" size="1.27" layer="21">1</text>
<hole x="21.0905" y="6.9845" drill="2"/>
<hole x="-48.0315" y="6.985" drill="2"/>
<text x="-49.8475" y="3.4925" size="1.27" layer="21">A</text>
<text x="-49.8475" y="9.2075" size="1.27" layer="21">B</text>
</package>
</packages>
<symbols>
<symbol name="HIROSE-FX2-100">
<wire x1="-15.24" y1="45.72" x2="2.54" y2="45.72" width="0.254" layer="94"/>
<wire x1="2.54" y1="45.72" x2="2.54" y2="-83.82" width="0.254" layer="94"/>
<wire x1="2.54" y1="-83.82" x2="-15.24" y2="-83.82" width="0.254" layer="94"/>
<wire x1="-15.24" y1="-83.82" x2="-15.24" y2="45.72" width="0.254" layer="94"/>
<text x="-17.78" y="48.26" size="1.27" layer="94">HiRose FX2-100S-1.27DS</text>
<pin name="SHIELD@1" x="7.62" y="43.18" length="middle" rot="R180"/>
<pin name="GND@3" x="7.62" y="40.64" length="middle" direction="pwr" rot="R180"/>
<pin name="TDOXC2C" x="7.62" y="38.1" length="middle" rot="R180"/>
<pin name="TCK" x="7.62" y="35.56" length="middle" rot="R180"/>
<pin name="GND@5" x="7.62" y="33.02" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@6" x="7.62" y="30.48" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@7" x="7.62" y="27.94" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@8" x="7.62" y="25.4" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@9" x="7.62" y="22.86" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@10" x="7.62" y="20.32" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@11" x="7.62" y="17.78" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@12" x="7.62" y="15.24" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@13" x="7.62" y="12.7" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@14" x="7.62" y="10.16" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@15" x="7.62" y="7.62" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@16" x="7.62" y="5.08" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@17" x="7.62" y="2.54" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@18" x="7.62" y="0" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@19" x="7.62" y="-2.54" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@20" x="7.62" y="-5.08" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@21" x="7.62" y="-7.62" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@22" x="7.62" y="-10.16" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@23" x="7.62" y="-12.7" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@24" x="7.62" y="-15.24" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@25" x="7.62" y="-17.78" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@26" x="7.62" y="-20.32" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@27" x="7.62" y="-22.86" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@28" x="7.62" y="-25.4" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@29" x="7.62" y="-27.94" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@30" x="7.62" y="-30.48" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@31" x="7.62" y="-33.02" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@32" x="7.62" y="-35.56" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@33" x="7.62" y="-38.1" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@34" x="7.62" y="-40.64" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@35" x="7.62" y="-43.18" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@36" x="7.62" y="-45.72" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@37" x="7.62" y="-48.26" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@38" x="7.62" y="-50.8" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@39" x="7.62" y="-53.34" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@40" x="7.62" y="-55.88" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@41" x="7.62" y="-58.42" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@42" x="7.62" y="-60.96" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@43" x="7.62" y="-63.5" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@44" x="7.62" y="-66.04" length="middle" direction="pwr" rot="R180"/>
<pin name="GND@45" x="7.62" y="-68.58" length="middle" direction="pwr" rot="R180"/>
<pin name="CLKIN" x="7.62" y="-71.12" length="middle" direction="in" rot="R180"/>
<pin name="GND@4" x="7.62" y="-73.66" length="middle" direction="pwr" rot="R180"/>
<pin name="CLKIO" x="7.62" y="-76.2" length="middle" rot="R180"/>
<pin name="VCC5V@3" x="7.62" y="-78.74" length="middle" direction="pwr" rot="R180"/>
<pin name="SHIELD@2" x="7.62" y="-81.28" length="middle" rot="R180"/>
<pin name="VCC@1" x="-20.32" y="43.18" length="middle" direction="pwr"/>
<pin name="VCC@2" x="-20.32" y="40.64" length="middle" direction="pwr"/>
<pin name="TMS" x="-20.32" y="38.1" length="middle"/>
<pin name="JTSEL" x="-20.32" y="35.56" length="middle"/>
<pin name="TDO" x="-20.32" y="33.02" length="middle"/>
<pin name="IO1" x="-20.32" y="30.48" length="middle"/>
<pin name="IO2" x="-20.32" y="27.94" length="middle"/>
<pin name="IO3" x="-20.32" y="25.4" length="middle"/>
<pin name="IO4" x="-20.32" y="22.86" length="middle"/>
<pin name="IO5" x="-20.32" y="20.32" length="middle"/>
<pin name="IO6" x="-20.32" y="17.78" length="middle"/>
<pin name="IO7" x="-20.32" y="15.24" length="middle"/>
<pin name="IO8" x="-20.32" y="12.7" length="middle"/>
<pin name="IO9" x="-20.32" y="10.16" length="middle"/>
<pin name="IO10" x="-20.32" y="7.62" length="middle"/>
<pin name="IO11" x="-20.32" y="5.08" length="middle"/>
<pin name="IO12" x="-20.32" y="2.54" length="middle"/>
<pin name="IO13" x="-20.32" y="0" length="middle"/>
<pin name="IO14" x="-20.32" y="-2.54" length="middle"/>
<pin name="IO15" x="-20.32" y="-5.08" length="middle"/>
<pin name="IO16" x="-20.32" y="-7.62" length="middle"/>
<pin name="IO17" x="-20.32" y="-10.16" length="middle"/>
<pin name="IO18" x="-20.32" y="-12.7" length="middle"/>
<pin name="IO19" x="-20.32" y="-15.24" length="middle"/>
<pin name="IO20" x="-20.32" y="-17.78" length="middle"/>
<pin name="IO21" x="-20.32" y="-20.32" length="middle"/>
<pin name="IO22" x="-20.32" y="-22.86" length="middle"/>
<pin name="IO23" x="-20.32" y="-25.4" length="middle"/>
<pin name="IO24" x="-20.32" y="-27.94" length="middle"/>
<pin name="IO25" x="-20.32" y="-30.48" length="middle"/>
<pin name="IO26" x="-20.32" y="-33.02" length="middle"/>
<pin name="IO27" x="-20.32" y="-35.56" length="middle"/>
<pin name="IO28" x="-20.32" y="-38.1" length="middle"/>
<pin name="IO29" x="-20.32" y="-40.64" length="middle"/>
<pin name="IO30" x="-20.32" y="-43.18" length="middle"/>
<pin name="IO31" x="-20.32" y="-45.72" length="middle"/>
<pin name="IO32" x="-20.32" y="-48.26" length="middle"/>
<pin name="IO33" x="-20.32" y="-50.8" length="middle"/>
<pin name="IO34" x="-20.32" y="-53.34" length="middle"/>
<pin name="IP35" x="-20.32" y="-55.88" length="middle"/>
<pin name="IP36" x="-20.32" y="-58.42" length="middle"/>
<pin name="IP37" x="-20.32" y="-60.96" length="middle"/>
<pin name="IP38" x="-20.32" y="-63.5" length="middle"/>
<pin name="IO39" x="-20.32" y="-66.04" length="middle"/>
<pin name="IP40" x="-20.32" y="-68.58" length="middle"/>
<pin name="GND@1" x="-20.32" y="-71.12" length="middle" direction="pwr"/>
<pin name="CLKOUT" x="-20.32" y="-73.66" length="middle" direction="out"/>
<pin name="GND@2" x="-20.32" y="-76.2" length="middle" direction="pwr"/>
<pin name="VCC5@1" x="-20.32" y="-78.74" length="middle" direction="pwr"/>
<pin name="VCC5@2" x="-20.32" y="-81.28" length="middle" direction="pwr"/>
</symbol>
</symbols>
<devicesets>
<deviceset name="HIROSE-FX2-100S-1.27DS">
<gates>
<gate name="HIROSE100" symbol="HIROSE-FX2-100" x="2.54" y="15.24"/>
</gates>
<devices>
<device name="" package="HIROSE-FX2-100">
<connects>
<connect gate="HIROSE100" pin="CLKIN" pad="B46"/>
<connect gate="HIROSE100" pin="CLKIO" pad="B48"/>
<connect gate="HIROSE100" pin="CLKOUT" pad="A47"/>
<connect gate="HIROSE100" pin="GND@1" pad="A46"/>
<connect gate="HIROSE100" pin="GND@10" pad="B10"/>
<connect gate="HIROSE100" pin="GND@11" pad="B11"/>
<connect gate="HIROSE100" pin="GND@12" pad="B12"/>
<connect gate="HIROSE100" pin="GND@13" pad="B13"/>
<connect gate="HIROSE100" pin="GND@14" pad="B14"/>
<connect gate="HIROSE100" pin="GND@15" pad="B15"/>
<connect gate="HIROSE100" pin="GND@16" pad="B16"/>
<connect gate="HIROSE100" pin="GND@17" pad="B17"/>
<connect gate="HIROSE100" pin="GND@18" pad="B18"/>
<connect gate="HIROSE100" pin="GND@19" pad="B19"/>
<connect gate="HIROSE100" pin="GND@2" pad="A48"/>
<connect gate="HIROSE100" pin="GND@20" pad="B20"/>
<connect gate="HIROSE100" pin="GND@21" pad="B21"/>
<connect gate="HIROSE100" pin="GND@22" pad="B22"/>
<connect gate="HIROSE100" pin="GND@23" pad="B23"/>
<connect gate="HIROSE100" pin="GND@24" pad="B24"/>
<connect gate="HIROSE100" pin="GND@25" pad="B25"/>
<connect gate="HIROSE100" pin="GND@26" pad="B26"/>
<connect gate="HIROSE100" pin="GND@27" pad="B27"/>
<connect gate="HIROSE100" pin="GND@28" pad="B28"/>
<connect gate="HIROSE100" pin="GND@29" pad="B29"/>
<connect gate="HIROSE100" pin="GND@3" pad="B2"/>
<connect gate="HIROSE100" pin="GND@30" pad="B30"/>
<connect gate="HIROSE100" pin="GND@31" pad="B31"/>
<connect gate="HIROSE100" pin="GND@32" pad="B32"/>
<connect gate="HIROSE100" pin="GND@33" pad="B33"/>
<connect gate="HIROSE100" pin="GND@34" pad="B34"/>
<connect gate="HIROSE100" pin="GND@35" pad="B35"/>
<connect gate="HIROSE100" pin="GND@36" pad="B36"/>
<connect gate="HIROSE100" pin="GND@37" pad="B37"/>
<connect gate="HIROSE100" pin="GND@38" pad="B38"/>
<connect gate="HIROSE100" pin="GND@39" pad="B39"/>
<connect gate="HIROSE100" pin="GND@4" pad="B47"/>
<connect gate="HIROSE100" pin="GND@40" pad="B40"/>
<connect gate="HIROSE100" pin="GND@41" pad="B41"/>
<connect gate="HIROSE100" pin="GND@42" pad="B42"/>
<connect gate="HIROSE100" pin="GND@43" pad="B43"/>
<connect gate="HIROSE100" pin="GND@44" pad="B44"/>
<connect gate="HIROSE100" pin="GND@45" pad="B45"/>
<connect gate="HIROSE100" pin="GND@5" pad="B5"/>
<connect gate="HIROSE100" pin="GND@6" pad="B6"/>
<connect gate="HIROSE100" pin="GND@7" pad="B7"/>
<connect gate="HIROSE100" pin="GND@8" pad="B8"/>
<connect gate="HIROSE100" pin="GND@9" pad="B9"/>
<connect gate="HIROSE100" pin="IO1" pad="A6"/>
<connect gate="HIROSE100" pin="IO10" pad="A15"/>
<connect gate="HIROSE100" pin="IO11" pad="A16"/>
<connect gate="HIROSE100" pin="IO12" pad="A17"/>
<connect gate="HIROSE100" pin="IO13" pad="A18"/>
<connect gate="HIROSE100" pin="IO14" pad="A19"/>
<connect gate="HIROSE100" pin="IO15" pad="A20"/>
<connect gate="HIROSE100" pin="IO16" pad="A21"/>
<connect gate="HIROSE100" pin="IO17" pad="A22"/>
<connect gate="HIROSE100" pin="IO18" pad="A23"/>
<connect gate="HIROSE100" pin="IO19" pad="A24"/>
<connect gate="HIROSE100" pin="IO2" pad="A7"/>
<connect gate="HIROSE100" pin="IO20" pad="A25"/>
<connect gate="HIROSE100" pin="IO21" pad="A26"/>
<connect gate="HIROSE100" pin="IO22" pad="A27"/>
<connect gate="HIROSE100" pin="IO23" pad="A28"/>
<connect gate="HIROSE100" pin="IO24" pad="A29"/>
<connect gate="HIROSE100" pin="IO25" pad="A30"/>
<connect gate="HIROSE100" pin="IO26" pad="A31"/>
<connect gate="HIROSE100" pin="IO27" pad="A32"/>
<connect gate="HIROSE100" pin="IO28" pad="A33"/>
<connect gate="HIROSE100" pin="IO29" pad="A34"/>
<connect gate="HIROSE100" pin="IO3" pad="A8"/>
<connect gate="HIROSE100" pin="IO30" pad="A35"/>
<connect gate="HIROSE100" pin="IO31" pad="A36"/>
<connect gate="HIROSE100" pin="IO32" pad="A37"/>
<connect gate="HIROSE100" pin="IO33" pad="A38"/>
<connect gate="HIROSE100" pin="IO34" pad="A39"/>
<connect gate="HIROSE100" pin="IO39" pad="A44"/>
<connect gate="HIROSE100" pin="IO4" pad="A9"/>
<connect gate="HIROSE100" pin="IO5" pad="A10"/>
<connect gate="HIROSE100" pin="IO6" pad="A11"/>
<connect gate="HIROSE100" pin="IO7" pad="A12"/>
<connect gate="HIROSE100" pin="IO8" pad="A13"/>
<connect gate="HIROSE100" pin="IO9" pad="A14"/>
<connect gate="HIROSE100" pin="IP35" pad="A40"/>
<connect gate="HIROSE100" pin="IP36" pad="A41"/>
<connect gate="HIROSE100" pin="IP37" pad="A42"/>
<connect gate="HIROSE100" pin="IP38" pad="A43"/>
<connect gate="HIROSE100" pin="IP40" pad="A45"/>
<connect gate="HIROSE100" pin="JTSEL" pad="A4"/>
<connect gate="HIROSE100" pin="SHIELD@1" pad="B1"/>
<connect gate="HIROSE100" pin="SHIELD@2" pad="B50"/>
<connect gate="HIROSE100" pin="TCK" pad="B4"/>
<connect gate="HIROSE100" pin="TDO" pad="A5"/>
<connect gate="HIROSE100" pin="TDOXC2C" pad="B3"/>
<connect gate="HIROSE100" pin="TMS" pad="A3"/>
<connect gate="HIROSE100" pin="VCC5@1" pad="A49"/>
<connect gate="HIROSE100" pin="VCC5@2" pad="A50"/>
<connect gate="HIROSE100" pin="VCC5V@3" pad="B49"/>
<connect gate="HIROSE100" pin="VCC@1" pad="A1"/>
<connect gate="HIROSE100" pin="VCC@2" pad="A2"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
<library name="tw">
<packages>
<package name="VHDCI68">
<pad name="V3" x="-9.6" y="0.8" drill="0.65" diameter="1"/>
<pad name="V5" x="-8" y="0.8" drill="0.65" diameter="1"/>
<pad name="V2" x="-10.4" y="1.95" drill="0.65" diameter="1"/>
<pad name="V7" x="-6.4" y="0.8" drill="0.65" diameter="1"/>
<pad name="V9" x="-4.8" y="0.8" drill="0.65" diameter="1"/>
<pad name="V11" x="-3.2" y="0.8" drill="0.65" diameter="1"/>
<pad name="V13" x="-1.6" y="0.8" drill="0.65" diameter="1"/>
<pad name="V15" x="0" y="0.8" drill="0.65" diameter="1"/>
<pad name="V4" x="-8.8" y="1.95" drill="0.65" diameter="1"/>
<pad name="V6" x="-7.2" y="1.95" drill="0.65" diameter="1"/>
<pad name="V8" x="-5.6" y="1.95" drill="0.65" diameter="1"/>
<pad name="V10" x="-4" y="1.95" drill="0.65" diameter="1"/>
<pad name="V12" x="-2.4" y="1.95" drill="0.65" diameter="1"/>
<pad name="V14" x="-0.8" y="1.95" drill="0.65" diameter="1"/>
<pad name="V16" x="0.8" y="1.95" drill="0.65" diameter="1"/>
<pad name="V17" x="1.6" y="0.8" drill="0.65" diameter="1"/>
<pad name="V19" x="3.2" y="0.8" drill="0.65" diameter="1"/>
<pad name="V18" x="2.4" y="1.95" drill="0.65" diameter="1"/>
<pad name="V20" x="4" y="1.95" drill="0.65" diameter="1"/>
<pad name="V22" x="5.6" y="1.95" drill="0.65" diameter="1"/>
<pad name="V24" x="7.2" y="1.95" drill="0.65" diameter="1"/>
<pad name="V26" x="8.8" y="1.95" drill="0.65" diameter="1"/>
<pad name="V28" x="10.4" y="1.95" drill="0.65" diameter="1"/>
<pad name="V21" x="4.8" y="0.8" drill="0.65" diameter="1"/>
<pad name="V23" x="6.4" y="0.8" drill="0.65" diameter="1"/>
<pad name="V25" x="8" y="0.8" drill="0.65" diameter="1"/>
<pad name="V27" x="9.6" y="0.8" drill="0.65" diameter="1"/>
<pad name="V36" x="-10" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V35" x="-10.8" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V62" x="10.8" y="-0.5" drill="0.65" diameter="1"/>
<pad name="V30" x="12" y="1.95" drill="0.65" diameter="1"/>
<pad name="V32" x="13.6" y="1.95" drill="0.65" diameter="1"/>
<pad name="V34" x="15.2" y="1.95" drill="0.65" diameter="1"/>
<pad name="V29" x="11.2" y="0.8" drill="0.65" diameter="1"/>
<pad name="V31" x="12.8" y="0.8" drill="0.65" diameter="1"/>
<pad name="V33" x="14.4" y="0.8" drill="0.65" diameter="1"/>
<pad name="V64" x="12.4" y="-0.5" drill="0.65" diameter="1"/>
<pad name="V66" x="14" y="-0.5" drill="0.65" diameter="1"/>
<pad name="V68" x="15.6" y="-0.5" drill="0.65" diameter="1"/>
<pad name="V63" x="11.6" y="-1.65" drill="0.65" diameter="1"/>
<pad name="V65" x="13.2" y="-1.65" drill="0.65" diameter="1"/>
<pad name="V67" x="14.8" y="-1.65" drill="0.65" diameter="1"/>
<wire x1="-19.2" y1="-6.6" x2="23.6" y2="-6.6" width="0.127" layer="21"/>
<hole x="-18.75" y="-3.025" drill="1.75"/>
<hole x="23.15" y="-3.025" drill="1.75"/>
<pad name="V1" x="-11.2" y="0.8" drill="0.65" diameter="1"/>
<pad name="V38" x="-8.4" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V37" x="-9.2" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V40" x="-6.8" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V39" x="-7.6" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V42" x="-5.2" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V41" x="-6" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V44" x="-3.6" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V46" x="-2" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V48" x="-0.4" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V50" x="1.2" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V52" x="2.8" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V54" x="4.4" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V56" x="6" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V58" x="7.6" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V60" x="9.2" y="-0.4" drill="0.65" diameter="1"/>
<pad name="V43" x="-4.4" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V45" x="-2.8" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V47" x="-1.2" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V49" x="0.4" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V51" x="2" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V53" x="3.6" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V55" x="5.2" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V57" x="6.8" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V59" x="8.4" y="-1.55" drill="0.65" diameter="1"/>
<pad name="V61" x="10" y="-1.55" drill="0.65" diameter="1"/>
<wire x1="-19.2" y1="2.4" x2="23.6" y2="2.4" width="0.127" layer="21"/>
<pad name="SHIELD1" x="-13.975" y="-0.4" drill="1.2" diameter="2.25"/>
<pad name="SHIELD0" x="18.375" y="-0.4" drill="1.2" diameter="2.25"/>
<wire x1="-19.2" y1="2.4" x2="-19.2" y2="-6.6" width="0.127" layer="21"/>
<wire x1="23.6" y1="2.4" x2="23.6" y2="-6.6" width="0.127" layer="21"/>
<wire x1="-14.1568" y1="-6.6768" x2="-14.1568" y2="-12.4968" width="0.127" layer="21"/>
<wire x1="18.5674" y1="-6.626" x2="18.5674" y2="-12.446" width="0.127" layer="21"/>
<wire x1="-14.1" y1="-12.5" x2="18.5" y2="-12.5" width="0.127" layer="21"/>
</package>
</packages>
<symbols>
<symbol name="VHDCI68">
<wire x1="-17.78" y1="20.32" x2="-17.78" y2="-73.66" width="0.254" layer="94"/>
<wire x1="-17.78" y1="-73.66" x2="7.62" y2="-73.66" width="0.254" layer="94"/>
<wire x1="7.62" y1="-73.66" x2="7.62" y2="20.32" width="0.254" layer="94"/>
<wire x1="7.62" y1="20.32" x2="-17.78" y2="20.32" width="0.254" layer="94"/>
<pin name="IO1_P" x="-22.86" y="17.78" length="middle"/>
<pin name="GND@1" x="-22.86" y="15.24" length="middle" direction="pas"/>
<pin name="IO2_P" x="-22.86" y="12.7" length="middle"/>
<pin name="IO3_P" x="-22.86" y="10.16" length="middle"/>
<pin name="GND@2" x="-22.86" y="7.62" length="middle" direction="pas"/>
<pin name="IO4_P" x="-22.86" y="5.08" length="middle"/>
<pin name="IO5_P" x="-22.86" y="2.54" length="middle"/>
<pin name="GND@3" x="-22.86" y="0" length="middle"/>
<pin name="IO6_P" x="-22.86" y="-2.54" length="middle"/>
<pin name="IO7_P" x="-22.86" y="-5.08" length="middle"/>
<pin name="GND@4" x="-22.86" y="-7.62" length="middle"/>
<pin name="IO8_P" x="-22.86" y="-10.16" length="middle"/>
<pin name="IO9_P" x="-22.86" y="-12.7" length="middle"/>
<pin name="GND@5" x="-22.86" y="-15.24" length="middle"/>
<pin name="CLK10_P" x="-22.86" y="-17.78" length="middle"/>
<pin name="VCC@1" x="-22.86" y="-20.32" length="middle" direction="pwr"/>
<pin name="VU@1" x="-22.86" y="-22.86" length="middle" direction="pwr"/>
<pin name="VU@2" x="-22.86" y="-25.4" length="middle" direction="pwr"/>
<pin name="VCC@2" x="-22.86" y="-27.94" length="middle" direction="pwr"/>
<pin name="CLK11_P" x="-22.86" y="-30.48" length="middle"/>
<pin name="GND@6" x="-22.86" y="-33.02" length="middle"/>
<pin name="IO12_P" x="-22.86" y="-35.56" length="middle"/>
<pin name="IO13_P" x="-22.86" y="-38.1" length="middle"/>
<pin name="GND@7" x="-22.86" y="-40.64" length="middle"/>
<pin name="IO14_P" x="-22.86" y="-43.18" length="middle"/>
<pin name="IO15_P" x="-22.86" y="-45.72" length="middle"/>
<pin name="GND@8" x="-22.86" y="-48.26" length="middle"/>
<pin name="IO16_P" x="-22.86" y="-50.8" length="middle"/>
<pin name="IO17_P" x="-22.86" y="-53.34" length="middle"/>
<pin name="GND@9" x="-22.86" y="-55.88" length="middle"/>
<pin name="IO18_P" x="-22.86" y="-58.42" length="middle"/>
<pin name="IO19_P" x="-22.86" y="-60.96" length="middle"/>
<pin name="GND@10" x="-22.86" y="-63.5" length="middle"/>
<pin name="IO20_P" x="-22.86" y="-66.04" length="middle"/>
<pin name="IO20_N" x="12.7" y="-66.04" length="middle" rot="R180"/>
<pin name="GND@20" x="12.7" y="-63.5" length="middle" rot="R180"/>
<pin name="IO19_N" x="12.7" y="-60.96" length="middle" rot="R180"/>
<pin name="IO18_N" x="12.7" y="-58.42" length="middle" rot="R180"/>
<pin name="GND@19" x="12.7" y="-55.88" length="middle" rot="R180"/>
<pin name="IO17_N" x="12.7" y="-53.34" length="middle" rot="R180"/>
<pin name="IO16_N" x="12.7" y="-50.8" length="middle" rot="R180"/>
<pin name="GND@18" x="12.7" y="-48.26" length="middle" rot="R180"/>
<pin name="IO15_N" x="12.7" y="-45.72" length="middle" rot="R180"/>
<pin name="IO14_N" x="12.7" y="-43.18" length="middle" rot="R180"/>
<pin name="GND@17" x="12.7" y="-40.64" length="middle" rot="R180"/>
<pin name="IO13_N" x="12.7" y="-38.1" length="middle" rot="R180"/>
<pin name="IO12_N" x="12.7" y="-35.56" length="middle" rot="R180"/>
<pin name="GND@16" x="12.7" y="-33.02" length="middle" rot="R180"/>
<pin name="CLK11_N" x="12.7" y="-30.48" length="middle" rot="R180"/>
<pin name="VCC@4" x="12.7" y="-27.94" length="middle" direction="pwr" rot="R180"/>
<pin name="VU@4" x="12.7" y="-25.4" length="middle" direction="pwr" rot="R180"/>
<pin name="VU@3" x="12.7" y="-22.86" length="middle" direction="pwr" rot="R180"/>
<pin name="VCC@3" x="12.7" y="-20.32" length="middle" direction="pwr" rot="R180"/>
<pin name="CLK10_N" x="12.7" y="-17.78" length="middle" rot="R180"/>
<pin name="GND@15" x="12.7" y="-15.24" length="middle" rot="R180"/>
<pin name="IO9_N" x="12.7" y="-12.7" length="middle" rot="R180"/>
<pin name="IO8_N" x="12.7" y="-10.16" length="middle" rot="R180"/>
<pin name="GND@14" x="12.7" y="-7.62" length="middle" rot="R180"/>
<pin name="IO7_N" x="12.7" y="-5.08" length="middle" rot="R180"/>
<pin name="IO6_N" x="12.7" y="-2.54" length="middle" rot="R180"/>
<pin name="GND@13" x="12.7" y="0" length="middle" rot="R180"/>
<pin name="IO5_N" x="12.7" y="2.54" length="middle" rot="R180"/>
<pin name="IO4_N" x="12.7" y="5.08" length="middle" rot="R180"/>
<pin name="GND@12" x="12.7" y="7.62" length="middle" rot="R180"/>
<pin name="IO3_N" x="12.7" y="10.16" length="middle" rot="R180"/>
<pin name="IO2_N" x="12.7" y="12.7" length="middle" rot="R180"/>
<pin name="GND@11" x="12.7" y="15.24" length="middle" rot="R180"/>
<pin name="IO1_N" x="12.7" y="17.78" length="middle" rot="R180"/>
<pin name="SHIELD0" x="-22.86" y="-71.12" length="middle"/>
<pin name="SHIELD1" x="12.7" y="-71.12" length="middle" rot="R180"/>
<text x="-10.16" y="22.86" size="1.778" layer="95">VHDCI68</text>
</symbol>
</symbols>
<devicesets>
<deviceset name="VHDCI68">
<description>Nexys 3 VHDCI 68pin 0.8mm pitch</description>
<gates>
<gate name="G$1" symbol="VHDCI68" x="2.54" y="22.86"/>
</gates>
<devices>
<device name="" package="VHDCI68">
<connects>
<connect gate="G$1" pin="CLK10_N" pad="V49"/>
<connect gate="G$1" pin="CLK10_P" pad="V15"/>
<connect gate="G$1" pin="CLK11_N" pad="V54"/>
<connect gate="G$1" pin="CLK11_P" pad="V20"/>
<connect gate="G$1" pin="GND@1" pad="V2"/>
<connect gate="G$1" pin="GND@10" pad="V33"/>
<connect gate="G$1" pin="GND@11" pad="V36"/>
<connect gate="G$1" pin="GND@12" pad="V39"/>
<connect gate="G$1" pin="GND@13" pad="V42"/>
<connect gate="G$1" pin="GND@14" pad="V45"/>
<connect gate="G$1" pin="GND@15" pad="V48"/>
<connect gate="G$1" pin="GND@16" pad="V55"/>
<connect gate="G$1" pin="GND@17" pad="V58"/>
<connect gate="G$1" pin="GND@18" pad="V61"/>
<connect gate="G$1" pin="GND@19" pad="V64"/>
<connect gate="G$1" pin="GND@2" pad="V5"/>
<connect gate="G$1" pin="GND@20" pad="V67"/>
<connect gate="G$1" pin="GND@3" pad="V8"/>
<connect gate="G$1" pin="GND@4" pad="V11"/>
<connect gate="G$1" pin="GND@5" pad="V14"/>
<connect gate="G$1" pin="GND@6" pad="V21"/>
<connect gate="G$1" pin="GND@7" pad="V24"/>
<connect gate="G$1" pin="GND@8" pad="V27"/>
<connect gate="G$1" pin="GND@9" pad="V30"/>
<connect gate="G$1" pin="IO12_N" pad="V56"/>
<connect gate="G$1" pin="IO12_P" pad="V22"/>
<connect gate="G$1" pin="IO13_N" pad="V57"/>
<connect gate="G$1" pin="IO13_P" pad="V23"/>
<connect gate="G$1" pin="IO14_N" pad="V59"/>
<connect gate="G$1" pin="IO14_P" pad="V25"/>
<connect gate="G$1" pin="IO15_N" pad="V60"/>
<connect gate="G$1" pin="IO15_P" pad="V26"/>
<connect gate="G$1" pin="IO16_N" pad="V62"/>
<connect gate="G$1" pin="IO16_P" pad="V28"/>
<connect gate="G$1" pin="IO17_N" pad="V63"/>
<connect gate="G$1" pin="IO17_P" pad="V29"/>
<connect gate="G$1" pin="IO18_N" pad="V65"/>
<connect gate="G$1" pin="IO18_P" pad="V31"/>
<connect gate="G$1" pin="IO19_N" pad="V66"/>
<connect gate="G$1" pin="IO19_P" pad="V32"/>
<connect gate="G$1" pin="IO1_N" pad="V35"/>
<connect gate="G$1" pin="IO1_P" pad="V1"/>
<connect gate="G$1" pin="IO20_N" pad="V68"/>
<connect gate="G$1" pin="IO20_P" pad="V34"/>
<connect gate="G$1" pin="IO2_N" pad="V37"/>
<connect gate="G$1" pin="IO2_P" pad="V3"/>
<connect gate="G$1" pin="IO3_N" pad="V38"/>
<connect gate="G$1" pin="IO3_P" pad="V4"/>
<connect gate="G$1" pin="IO4_N" pad="V40"/>
<connect gate="G$1" pin="IO4_P" pad="V6"/>
<connect gate="G$1" pin="IO5_N" pad="V41"/>
<connect gate="G$1" pin="IO5_P" pad="V7"/>
<connect gate="G$1" pin="IO6_N" pad="V43"/>
<connect gate="G$1" pin="IO6_P" pad="V9"/>
<connect gate="G$1" pin="IO7_N" pad="V44"/>
<connect gate="G$1" pin="IO7_P" pad="V10"/>
<connect gate="G$1" pin="IO8_N" pad="V46"/>
<connect gate="G$1" pin="IO8_P" pad="V12"/>
<connect gate="G$1" pin="IO9_N" pad="V47"/>
<connect gate="G$1" pin="IO9_P" pad="V13"/>
<connect gate="G$1" pin="SHIELD0" pad="SHIELD0"/>
<connect gate="G$1" pin="SHIELD1" pad="SHIELD1"/>
<connect gate="G$1" pin="VCC@1" pad="V16"/>
<connect gate="G$1" pin="VCC@2" pad="V19"/>
<connect gate="G$1" pin="VCC@3" pad="V50"/>
<connect gate="G$1" pin="VCC@4" pad="V53"/>
<connect gate="G$1" pin="VU@1" pad="V17"/>
<connect gate="G$1" pin="VU@2" pad="V18"/>
<connect gate="G$1" pin="VU@3" pad="V51"/>
<connect gate="G$1" pin="VU@4" pad="V52"/>
</connects>
<technologies>
<technology name=""/>
</technologies>
</device>
</devices>
</deviceset>
</devicesets>
</library>
</libraries>
<attributes>
</attributes>
<variantdefs>
</variantdefs>
<classes>
<class number="0" name="default" width="0" drill="0">
</class>
</classes>
<parts>
<part name="JP1" library="jumper" deviceset="JP1E" device="" value="E2C"/>
<part name="JP2" library="jumper" deviceset="JP1E" device="" value="E2D"/>
<part name="JP3" library="jumper" deviceset="JP1E" device="" value="C2D"/>
<part name="X1" library="con-coax" deviceset="BU-SMA-V" device=""/>
<part name="GND1" library="supply1" deviceset="GND" device=""/>
<part name="GND2" library="supply1" deviceset="GND" device=""/>
<part name="GND3" library="supply1" deviceset="GND" device=""/>
<part name="GND4" library="supply1" deviceset="GND" device=""/>
<part name="U$1" library="hirose-fx2-100" deviceset="HIROSE-FX2-100S-1.27DS" device=""/>
<part name="GND5" library="supply1" deviceset="GND" device=""/>
<part name="GND6" library="supply1" deviceset="GND" device=""/>
<part name="JP5" library="pinhead" deviceset="PINHD-2X25" device="" value="Alternate DUT"/>
<part name="GND7" library="supply1" deviceset="GND" device=""/>
<part name="U$2" library="tw" deviceset="VHDCI68" device=""/>
</parts>
<sheets>
<sheet>
<plain>
</plain>
<instances>
<instance part="JP1" gate="A" x="-30.48" y="109.22"/>
<instance part="JP2" gate="A" x="-5.08" y="109.22"/>
<instance part="JP3" gate="A" x="20.32" y="111.76"/>
<instance part="X1" gate="G$1" x="-17.78" y="111.76" rot="R270"/>
<instance part="GND1" gate="1" x="-35.56" y="-15.24"/>
<instance part="GND2" gate="1" x="10.16" y="-15.24"/>
<instance part="GND3" gate="1" x="119.38" y="-15.24"/>
<instance part="GND4" gate="1" x="157.48" y="-15.24"/>
<instance part="U$1" gate="HIROSE100" x="144.78" y="35.56" rot="MR180"/>
<instance part="GND5" gate="1" x="55.88" y="-15.24"/>
<instance part="GND6" gate="1" x="78.74" y="-15.24"/>
<instance part="JP5" gate="A" x="66.04" y="27.94"/>
<instance part="GND7" gate="1" x="-20.32" y="99.06"/>
<instance part="U$2" gate="G$1" x="-7.62" y="60.96"/>
</instances>
<busses>
<bus name="DIN[0..15]">
<segment>
<wire x1="-48.26" y1="-20.32" x2="-45.72" y2="-22.86" width="0.762" layer="92"/>
<wire x1="-45.72" y1="-22.86" x2="20.32" y2="-22.86" width="0.762" layer="92"/>
<wire x1="20.32" y1="-22.86" x2="45.72" y2="-22.86" width="0.762" layer="92"/>
<wire x1="45.72" y1="-22.86" x2="88.9" y2="-22.86" width="0.762" layer="92"/>
<wire x1="88.9" y1="-22.86" x2="111.76" y2="-22.86" width="0.762" layer="92"/>
<wire x1="111.76" y1="-22.86" x2="114.3" y2="-20.32" width="0.762" layer="92"/>
<wire x1="114.3" y1="-20.32" x2="114.3" y2="43.18" width="0.762" layer="92"/>
<wire x1="-48.26" y1="-20.32" x2="-48.26" y2="25.4" width="0.762" layer="92"/>
<wire x1="20.32" y1="-22.86" x2="20.32" y2="25.4" width="0.762" layer="92"/>
<label x="27.94" y="-22.86" size="1.778" layer="95"/>
<wire x1="45.72" y1="-22.86" x2="45.72" y2="20.32" width="0.762" layer="92"/>
<wire x1="88.9" y1="-22.86" x2="88.9" y2="22.86" width="0.762" layer="92"/>
</segment>
</bus>
<bus name="DOUT[0..15]">
<segment>
<wire x1="-48.26" y1="48.26" x2="-48.26" y2="83.82" width="0.762" layer="92"/>
<wire x1="-48.26" y1="83.82" x2="20.32" y2="83.82" width="0.762" layer="92"/>
<wire x1="20.32" y1="83.82" x2="45.72" y2="83.82" width="0.762" layer="92"/>
<wire x1="45.72" y1="83.82" x2="88.9" y2="83.82" width="0.762" layer="92"/>
<wire x1="88.9" y1="83.82" x2="114.3" y2="83.82" width="0.762" layer="92"/>
<wire x1="114.3" y1="83.82" x2="114.3" y2="45.72" width="0.762" layer="92"/>
<wire x1="20.32" y1="83.82" x2="20.32" y2="48.26" width="0.762" layer="92"/>
<wire x1="45.72" y1="83.82" x2="45.72" y2="25.4" width="0.762" layer="92"/>
<label x="30.48" y="81.28" size="1.778" layer="95"/>
<wire x1="88.9" y1="83.82" x2="88.9" y2="25.4" width="0.762" layer="92"/>
</segment>
</bus>
</busses>
<nets>
<net name="GND" class="0">
<segment>
<pinref part="GND1" gate="1" pin="GND"/>
<wire x1="-30.48" y1="76.2" x2="-35.56" y2="76.2" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="76.2" x2="-35.56" y2="68.58" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="68.58" x2="-35.56" y2="60.96" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="60.96" x2="-35.56" y2="53.34" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="53.34" x2="-35.56" y2="27.94" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="27.94" x2="-35.56" y2="20.32" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="20.32" x2="-35.56" y2="12.7" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="12.7" x2="-35.56" y2="5.08" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="5.08" x2="-35.56" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="-35.56" y1="-2.54" x2="-35.56" y2="-12.7" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="68.58" x2="-35.56" y2="68.58" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="60.96" x2="-35.56" y2="60.96" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="53.34" x2="-35.56" y2="53.34" width="0.1524" layer="91"/>
<junction x="-35.56" y="68.58"/>
<junction x="-35.56" y="60.96"/>
<junction x="-35.56" y="53.34"/>
<wire x1="-30.48" y1="20.32" x2="-35.56" y2="20.32" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="12.7" x2="-35.56" y2="12.7" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="5.08" x2="-35.56" y2="5.08" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="-2.54" x2="-35.56" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="27.94" x2="-35.56" y2="27.94" width="0.1524" layer="91"/>
<junction x="-35.56" y="27.94"/>
<junction x="-35.56" y="20.32"/>
<junction x="-35.56" y="12.7"/>
<junction x="-35.56" y="5.08"/>
<junction x="-35.56" y="-2.54"/>
<pinref part="U$2" gate="G$1" pin="GND@1"/>
<pinref part="U$2" gate="G$1" pin="GND@2"/>
<pinref part="U$2" gate="G$1" pin="GND@3"/>
<pinref part="U$2" gate="G$1" pin="GND@4"/>
<pinref part="U$2" gate="G$1" pin="GND@6"/>
<pinref part="U$2" gate="G$1" pin="GND@7"/>
<pinref part="U$2" gate="G$1" pin="GND@8"/>
<pinref part="U$2" gate="G$1" pin="GND@9"/>
<pinref part="U$2" gate="G$1" pin="GND@10"/>
</segment>
<segment>
<pinref part="GND2" gate="1" pin="GND"/>
<wire x1="5.08" y1="76.2" x2="10.16" y2="76.2" width="0.1524" layer="91"/>
<wire x1="10.16" y1="76.2" x2="10.16" y2="68.58" width="0.1524" layer="91"/>
<wire x1="10.16" y1="68.58" x2="10.16" y2="60.96" width="0.1524" layer="91"/>
<wire x1="10.16" y1="60.96" x2="10.16" y2="53.34" width="0.1524" layer="91"/>
<wire x1="10.16" y1="53.34" x2="10.16" y2="27.94" width="0.1524" layer="91"/>
<wire x1="10.16" y1="27.94" x2="10.16" y2="20.32" width="0.1524" layer="91"/>
<wire x1="10.16" y1="20.32" x2="10.16" y2="12.7" width="0.1524" layer="91"/>
<wire x1="10.16" y1="12.7" x2="10.16" y2="5.08" width="0.1524" layer="91"/>
<wire x1="10.16" y1="5.08" x2="10.16" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="10.16" y1="-2.54" x2="10.16" y2="-12.7" width="0.1524" layer="91"/>
<wire x1="5.08" y1="68.58" x2="10.16" y2="68.58" width="0.1524" layer="91"/>
<wire x1="5.08" y1="60.96" x2="10.16" y2="60.96" width="0.1524" layer="91"/>
<wire x1="5.08" y1="53.34" x2="10.16" y2="53.34" width="0.1524" layer="91"/>
<junction x="10.16" y="68.58"/>
<junction x="10.16" y="60.96"/>
<junction x="10.16" y="53.34"/>
<wire x1="5.08" y1="-2.54" x2="10.16" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="5.08" y1="5.08" x2="10.16" y2="5.08" width="0.1524" layer="91"/>
<wire x1="5.08" y1="12.7" x2="10.16" y2="12.7" width="0.1524" layer="91"/>
<wire x1="5.08" y1="20.32" x2="10.16" y2="20.32" width="0.1524" layer="91"/>
<wire x1="5.08" y1="27.94" x2="10.16" y2="27.94" width="0.1524" layer="91"/>
<junction x="10.16" y="-2.54"/>
<junction x="10.16" y="5.08"/>
<junction x="10.16" y="12.7"/>
<junction x="10.16" y="20.32"/>
<junction x="10.16" y="27.94"/>
<pinref part="U$2" gate="G$1" pin="GND@20"/>
<pinref part="U$2" gate="G$1" pin="GND@19"/>
<pinref part="U$2" gate="G$1" pin="GND@18"/>
<pinref part="U$2" gate="G$1" pin="GND@17"/>
<pinref part="U$2" gate="G$1" pin="GND@16"/>
<pinref part="U$2" gate="G$1" pin="GND@14"/>
<pinref part="U$2" gate="G$1" pin="GND@13"/>
<pinref part="U$2" gate="G$1" pin="GND@12"/>
<pinref part="U$2" gate="G$1" pin="GND@11"/>
</segment>
<segment>
<pinref part="GND3" gate="1" pin="GND"/>
<wire x1="119.38" y1="-12.7" x2="119.38" y2="106.68" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@2"/>
<wire x1="119.38" y1="106.68" x2="119.38" y2="111.76" width="0.1524" layer="91"/>
<wire x1="119.38" y1="111.76" x2="124.46" y2="111.76" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@1"/>
<wire x1="124.46" y1="106.68" x2="119.38" y2="106.68" width="0.1524" layer="91"/>
<junction x="119.38" y="106.68"/>
</segment>
<segment>
<pinref part="GND4" gate="1" pin="GND"/>
<wire x1="157.48" y1="-12.7" x2="157.48" y2="-5.08" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@45"/>
<wire x1="157.48" y1="-5.08" x2="157.48" y2="2.54" width="0.1524" layer="91"/>
<wire x1="157.48" y1="2.54" x2="157.48" y2="5.08" width="0.1524" layer="91"/>
<wire x1="157.48" y1="5.08" x2="157.48" y2="7.62" width="0.1524" layer="91"/>
<wire x1="157.48" y1="7.62" x2="157.48" y2="10.16" width="0.1524" layer="91"/>
<wire x1="157.48" y1="10.16" x2="157.48" y2="12.7" width="0.1524" layer="91"/>
<wire x1="157.48" y1="12.7" x2="157.48" y2="15.24" width="0.1524" layer="91"/>
<wire x1="157.48" y1="15.24" x2="157.48" y2="17.78" width="0.1524" layer="91"/>
<wire x1="157.48" y1="17.78" x2="157.48" y2="20.32" width="0.1524" layer="91"/>
<wire x1="157.48" y1="20.32" x2="157.48" y2="22.86" width="0.1524" layer="91"/>
<wire x1="157.48" y1="22.86" x2="157.48" y2="25.4" width="0.1524" layer="91"/>
<wire x1="157.48" y1="25.4" x2="157.48" y2="27.94" width="0.1524" layer="91"/>
<wire x1="157.48" y1="27.94" x2="157.48" y2="30.48" width="0.1524" layer="91"/>
<wire x1="157.48" y1="30.48" x2="157.48" y2="33.02" width="0.1524" layer="91"/>
<wire x1="157.48" y1="33.02" x2="157.48" y2="35.56" width="0.1524" layer="91"/>
<wire x1="157.48" y1="35.56" x2="157.48" y2="38.1" width="0.1524" layer="91"/>
<wire x1="157.48" y1="38.1" x2="157.48" y2="40.64" width="0.1524" layer="91"/>
<wire x1="157.48" y1="40.64" x2="157.48" y2="43.18" width="0.1524" layer="91"/>
<wire x1="157.48" y1="43.18" x2="157.48" y2="45.72" width="0.1524" layer="91"/>
<wire x1="157.48" y1="45.72" x2="157.48" y2="48.26" width="0.1524" layer="91"/>
<wire x1="157.48" y1="48.26" x2="157.48" y2="50.8" width="0.1524" layer="91"/>
<wire x1="157.48" y1="50.8" x2="157.48" y2="53.34" width="0.1524" layer="91"/>
<wire x1="157.48" y1="53.34" x2="157.48" y2="55.88" width="0.1524" layer="91"/>
<wire x1="157.48" y1="55.88" x2="157.48" y2="58.42" width="0.1524" layer="91"/>
<wire x1="157.48" y1="58.42" x2="157.48" y2="60.96" width="0.1524" layer="91"/>
<wire x1="157.48" y1="60.96" x2="157.48" y2="63.5" width="0.1524" layer="91"/>
<wire x1="157.48" y1="63.5" x2="157.48" y2="66.04" width="0.1524" layer="91"/>
<wire x1="157.48" y1="66.04" x2="157.48" y2="68.58" width="0.1524" layer="91"/>
<wire x1="157.48" y1="68.58" x2="157.48" y2="71.12" width="0.1524" layer="91"/>
<wire x1="157.48" y1="71.12" x2="157.48" y2="73.66" width="0.1524" layer="91"/>
<wire x1="157.48" y1="73.66" x2="157.48" y2="76.2" width="0.1524" layer="91"/>
<wire x1="157.48" y1="76.2" x2="157.48" y2="78.74" width="0.1524" layer="91"/>
<wire x1="157.48" y1="78.74" x2="157.48" y2="81.28" width="0.1524" layer="91"/>
<wire x1="157.48" y1="81.28" x2="157.48" y2="83.82" width="0.1524" layer="91"/>
<wire x1="157.48" y1="83.82" x2="157.48" y2="86.36" width="0.1524" layer="91"/>
<wire x1="157.48" y1="86.36" x2="157.48" y2="88.9" width="0.1524" layer="91"/>
<wire x1="157.48" y1="88.9" x2="157.48" y2="91.44" width="0.1524" layer="91"/>
<wire x1="157.48" y1="91.44" x2="157.48" y2="93.98" width="0.1524" layer="91"/>
<wire x1="157.48" y1="93.98" x2="157.48" y2="96.52" width="0.1524" layer="91"/>
<wire x1="157.48" y1="96.52" x2="157.48" y2="99.06" width="0.1524" layer="91"/>
<wire x1="157.48" y1="99.06" x2="157.48" y2="101.6" width="0.1524" layer="91"/>
<wire x1="157.48" y1="101.6" x2="157.48" y2="104.14" width="0.1524" layer="91"/>
<wire x1="157.48" y1="104.14" x2="152.4" y2="104.14" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@44"/>
<wire x1="152.4" y1="101.6" x2="157.48" y2="101.6" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@43"/>
<wire x1="152.4" y1="99.06" x2="157.48" y2="99.06" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@42"/>
<wire x1="152.4" y1="96.52" x2="157.48" y2="96.52" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@41"/>
<wire x1="152.4" y1="93.98" x2="157.48" y2="93.98" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@40"/>
<wire x1="152.4" y1="91.44" x2="157.48" y2="91.44" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@39"/>
<wire x1="152.4" y1="88.9" x2="157.48" y2="88.9" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@38"/>
<wire x1="152.4" y1="86.36" x2="157.48" y2="86.36" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@37"/>
<wire x1="152.4" y1="83.82" x2="157.48" y2="83.82" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@36"/>
<wire x1="152.4" y1="81.28" x2="157.48" y2="81.28" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@35"/>
<wire x1="152.4" y1="78.74" x2="157.48" y2="78.74" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@34"/>
<wire x1="152.4" y1="76.2" x2="157.48" y2="76.2" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@33"/>
<wire x1="152.4" y1="73.66" x2="157.48" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@32"/>
<wire x1="152.4" y1="71.12" x2="157.48" y2="71.12" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@31"/>
<wire x1="152.4" y1="68.58" x2="157.48" y2="68.58" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@30"/>
<wire x1="152.4" y1="66.04" x2="157.48" y2="66.04" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@29"/>
<wire x1="152.4" y1="63.5" x2="157.48" y2="63.5" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@28"/>
<wire x1="152.4" y1="60.96" x2="157.48" y2="60.96" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@27"/>
<wire x1="152.4" y1="58.42" x2="157.48" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@26"/>
<wire x1="152.4" y1="55.88" x2="157.48" y2="55.88" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@25"/>
<wire x1="152.4" y1="53.34" x2="157.48" y2="53.34" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@24"/>
<wire x1="152.4" y1="50.8" x2="157.48" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@23"/>
<wire x1="152.4" y1="48.26" x2="157.48" y2="48.26" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@22"/>
<wire x1="152.4" y1="45.72" x2="157.48" y2="45.72" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@21"/>
<wire x1="152.4" y1="43.18" x2="157.48" y2="43.18" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@20"/>
<wire x1="152.4" y1="40.64" x2="157.48" y2="40.64" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@19"/>
<wire x1="152.4" y1="38.1" x2="157.48" y2="38.1" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@18"/>
<wire x1="152.4" y1="35.56" x2="157.48" y2="35.56" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@17"/>
<wire x1="152.4" y1="33.02" x2="157.48" y2="33.02" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@16"/>
<wire x1="152.4" y1="30.48" x2="157.48" y2="30.48" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@15"/>
<wire x1="152.4" y1="27.94" x2="157.48" y2="27.94" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@14"/>
<wire x1="157.48" y1="25.4" x2="152.4" y2="25.4" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@13"/>
<wire x1="152.4" y1="22.86" x2="157.48" y2="22.86" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@12"/>
<wire x1="152.4" y1="20.32" x2="157.48" y2="20.32" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@11"/>
<wire x1="152.4" y1="17.78" x2="157.48" y2="17.78" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@10"/>
<wire x1="152.4" y1="15.24" x2="157.48" y2="15.24" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@9"/>
<wire x1="152.4" y1="12.7" x2="157.48" y2="12.7" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@8"/>
<wire x1="152.4" y1="10.16" x2="157.48" y2="10.16" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@7"/>
<wire x1="152.4" y1="7.62" x2="157.48" y2="7.62" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@6"/>
<wire x1="152.4" y1="5.08" x2="157.48" y2="5.08" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@5"/>
<wire x1="152.4" y1="2.54" x2="157.48" y2="2.54" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@3"/>
<wire x1="152.4" y1="-5.08" x2="157.48" y2="-5.08" width="0.1524" layer="91"/>
<junction x="157.48" y="-5.08"/>
<junction x="157.48" y="2.54"/>
<junction x="157.48" y="5.08"/>
<junction x="157.48" y="7.62"/>
<junction x="157.48" y="10.16"/>
<junction x="157.48" y="12.7"/>
<junction x="157.48" y="15.24"/>
<junction x="157.48" y="17.78"/>
<junction x="157.48" y="20.32"/>
<junction x="157.48" y="22.86"/>
<junction x="157.48" y="25.4"/>
<junction x="157.48" y="27.94"/>
<junction x="157.48" y="30.48"/>
<junction x="157.48" y="33.02"/>
<junction x="157.48" y="35.56"/>
<junction x="157.48" y="38.1"/>
<junction x="157.48" y="40.64"/>
<junction x="157.48" y="43.18"/>
<junction x="157.48" y="45.72"/>
<junction x="157.48" y="48.26"/>
<junction x="157.48" y="50.8"/>
<junction x="157.48" y="53.34"/>
<junction x="157.48" y="55.88"/>
<junction x="157.48" y="58.42"/>
<junction x="157.48" y="60.96"/>
<junction x="157.48" y="63.5"/>
<junction x="157.48" y="66.04"/>
<junction x="157.48" y="68.58"/>
<junction x="157.48" y="71.12"/>
<junction x="157.48" y="73.66"/>
<junction x="157.48" y="76.2"/>
<junction x="157.48" y="78.74"/>
<junction x="157.48" y="81.28"/>
<junction x="157.48" y="83.82"/>
<junction x="157.48" y="86.36"/>
<junction x="157.48" y="88.9"/>
<junction x="157.48" y="91.44"/>
<junction x="157.48" y="93.98"/>
<junction x="157.48" y="96.52"/>
<junction x="157.48" y="99.06"/>
<junction x="157.48" y="101.6"/>
<pinref part="U$1" gate="HIROSE100" pin="GND@4"/>
<wire x1="152.4" y1="109.22" x2="157.48" y2="109.22" width="0.1524" layer="91"/>
<wire x1="157.48" y1="109.22" x2="157.48" y2="104.14" width="0.1524" layer="91"/>
<junction x="157.48" y="104.14"/>
</segment>
<segment>
<wire x1="63.5" y1="48.26" x2="55.88" y2="48.26" width="0.1524" layer="91"/>
<pinref part="GND5" gate="1" pin="GND"/>
<wire x1="55.88" y1="48.26" x2="55.88" y2="35.56" width="0.1524" layer="91"/>
<wire x1="55.88" y1="35.56" x2="55.88" y2="22.86" width="0.1524" layer="91"/>
<wire x1="55.88" y1="22.86" x2="55.88" y2="10.16" width="0.1524" layer="91"/>
<wire x1="55.88" y1="10.16" x2="55.88" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="55.88" y1="-2.54" x2="55.88" y2="-12.7" width="0.1524" layer="91"/>
<wire x1="63.5" y1="35.56" x2="55.88" y2="35.56" width="0.1524" layer="91"/>
<junction x="55.88" y="35.56"/>
<wire x1="63.5" y1="22.86" x2="55.88" y2="22.86" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="9"/>
<pinref part="JP5" gate="A" pin="19"/>
<pinref part="JP5" gate="A" pin="29"/>
<pinref part="JP5" gate="A" pin="39"/>
<wire x1="63.5" y1="10.16" x2="55.88" y2="10.16" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="49"/>
<wire x1="63.5" y1="-2.54" x2="55.88" y2="-2.54" width="0.1524" layer="91"/>
<junction x="55.88" y="-2.54"/>
<junction x="55.88" y="10.16"/>
<junction x="55.88" y="22.86"/>
</segment>
<segment>
<wire x1="71.12" y1="48.26" x2="78.74" y2="48.26" width="0.1524" layer="91"/>
<pinref part="GND6" gate="1" pin="GND"/>
<wire x1="78.74" y1="48.26" x2="78.74" y2="35.56" width="0.1524" layer="91"/>
<wire x1="78.74" y1="35.56" x2="78.74" y2="22.86" width="0.1524" layer="91"/>
<wire x1="78.74" y1="22.86" x2="78.74" y2="10.16" width="0.1524" layer="91"/>
<wire x1="78.74" y1="10.16" x2="78.74" y2="-12.7" width="0.1524" layer="91"/>
<wire x1="71.12" y1="35.56" x2="78.74" y2="35.56" width="0.1524" layer="91"/>
<junction x="78.74" y="35.56"/>
<wire x1="71.12" y1="22.86" x2="78.74" y2="22.86" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="10"/>
<pinref part="JP5" gate="A" pin="20"/>
<pinref part="JP5" gate="A" pin="30"/>
<pinref part="JP5" gate="A" pin="40"/>
<wire x1="71.12" y1="10.16" x2="78.74" y2="10.16" width="0.1524" layer="91"/>
<junction x="78.74" y="22.86"/>
<junction x="78.74" y="10.16"/>
</segment>
<segment>
<pinref part="X1" gate="G$1" pin="GND"/>
<pinref part="GND7" gate="1" pin="GND"/>
<wire x1="-20.32" y1="109.22" x2="-20.32" y2="101.6" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN0" class="0">
<segment>
<wire x1="5.08" y1="0" x2="20.32" y2="0" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO19_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO1"/>
<wire x1="124.46" y1="5.08" x2="114.3" y2="5.08" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="48"/>
<wire x1="71.12" y1="0" x2="88.9" y2="0" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN2" class="0">
<segment>
<wire x1="5.08" y1="2.54" x2="20.32" y2="2.54" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO18_N"/>
</segment>
<segment>
<wire x1="124.46" y1="10.16" x2="114.3" y2="10.16" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO3"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="46"/>
<wire x1="71.12" y1="2.54" x2="88.9" y2="2.54" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN1" class="0">
<segment>
<wire x1="-30.48" y1="0" x2="-48.26" y2="0" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO19_P"/>
</segment>
<segment>
<wire x1="124.46" y1="7.62" x2="114.3" y2="7.62" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO2"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="47"/>
<wire x1="63.5" y1="0" x2="45.72" y2="0" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN3" class="0">
<segment>
<wire x1="-30.48" y1="2.54" x2="-48.26" y2="2.54" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO18_P"/>
</segment>
<segment>
<wire x1="124.46" y1="12.7" x2="114.3" y2="12.7" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO4"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="45"/>
<wire x1="63.5" y1="2.54" x2="45.72" y2="2.54" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN4" class="0">
<segment>
<wire x1="5.08" y1="7.62" x2="20.32" y2="7.62" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO17_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO5"/>
<wire x1="124.46" y1="15.24" x2="114.3" y2="15.24" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="44"/>
<wire x1="71.12" y1="5.08" x2="88.9" y2="5.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN6" class="0">
<segment>
<wire x1="5.08" y1="10.16" x2="20.32" y2="10.16" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO16_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO7"/>
<wire x1="124.46" y1="20.32" x2="114.3" y2="20.32" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="42"/>
<wire x1="71.12" y1="7.62" x2="88.9" y2="7.62" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN8" class="0">
<segment>
<wire x1="5.08" y1="15.24" x2="20.32" y2="15.24" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO15_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO9"/>
<wire x1="124.46" y1="25.4" x2="114.3" y2="25.4" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="38"/>
<wire x1="71.12" y1="12.7" x2="88.9" y2="12.7" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN10" class="0">
<segment>
<wire x1="5.08" y1="17.78" x2="20.32" y2="17.78" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO14_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO11"/>
<wire x1="124.46" y1="30.48" x2="114.3" y2="30.48" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="36"/>
<wire x1="71.12" y1="15.24" x2="88.9" y2="15.24" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN12" class="0">
<segment>
<wire x1="5.08" y1="22.86" x2="20.32" y2="22.86" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO13_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO13"/>
<wire x1="124.46" y1="35.56" x2="114.3" y2="35.56" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="34"/>
<wire x1="71.12" y1="17.78" x2="88.9" y2="17.78" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN14" class="0">
<segment>
<wire x1="5.08" y1="25.4" x2="20.32" y2="25.4" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO12_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO15"/>
<wire x1="124.46" y1="40.64" x2="114.3" y2="40.64" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="32"/>
<wire x1="71.12" y1="20.32" x2="88.9" y2="20.32" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN5" class="0">
<segment>
<wire x1="-30.48" y1="7.62" x2="-48.26" y2="7.62" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO17_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO6"/>
<wire x1="124.46" y1="17.78" x2="114.3" y2="17.78" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="43"/>
<wire x1="63.5" y1="5.08" x2="45.72" y2="5.08" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN7" class="0">
<segment>
<wire x1="-30.48" y1="10.16" x2="-48.26" y2="10.16" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO16_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO8"/>
<wire x1="124.46" y1="22.86" x2="114.3" y2="22.86" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="41"/>
<wire x1="63.5" y1="7.62" x2="45.72" y2="7.62" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN9" class="0">
<segment>
<wire x1="-30.48" y1="15.24" x2="-48.26" y2="15.24" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO15_P"/>
</segment>
<segment>
<wire x1="124.46" y1="27.94" x2="114.3" y2="27.94" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO10"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="37"/>
<wire x1="63.5" y1="12.7" x2="45.72" y2="12.7" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN11" class="0">
<segment>
<wire x1="-30.48" y1="17.78" x2="-48.26" y2="17.78" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO14_P"/>
</segment>
<segment>
<wire x1="124.46" y1="33.02" x2="114.3" y2="33.02" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO12"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="35"/>
<wire x1="63.5" y1="15.24" x2="45.72" y2="15.24" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN13" class="0">
<segment>
<wire x1="-30.48" y1="22.86" x2="-48.26" y2="22.86" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO13_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO14"/>
<wire x1="124.46" y1="38.1" x2="114.3" y2="38.1" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="33"/>
<wire x1="63.5" y1="17.78" x2="45.72" y2="17.78" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DIN15" class="0">
<segment>
<wire x1="-30.48" y1="25.4" x2="-48.26" y2="25.4" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO12_P"/>
</segment>
<segment>
<wire x1="124.46" y1="43.18" x2="114.3" y2="43.18" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO16"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="31"/>
<wire x1="63.5" y1="20.32" x2="45.72" y2="20.32" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT0" class="0">
<segment>
<wire x1="5.08" y1="48.26" x2="20.32" y2="48.26" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO9_N"/>
</segment>
<segment>
<wire x1="124.46" y1="45.72" x2="114.3" y2="45.72" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO17"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="28"/>
<wire x1="71.12" y1="25.4" x2="88.9" y2="25.4" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT2" class="0">
<segment>
<wire x1="5.08" y1="50.8" x2="20.32" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO8_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO19"/>
<wire x1="124.46" y1="50.8" x2="114.3" y2="50.8" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="26"/>
<wire x1="71.12" y1="27.94" x2="88.9" y2="27.94" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT4" class="0">
<segment>
<wire x1="5.08" y1="55.88" x2="20.32" y2="55.88" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO7_N"/>
</segment>
<segment>
<wire x1="124.46" y1="55.88" x2="114.3" y2="55.88" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO21"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="24"/>
<wire x1="71.12" y1="30.48" x2="88.9" y2="30.48" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT6" class="0">
<segment>
<wire x1="5.08" y1="58.42" x2="20.32" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO6_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO23"/>
<wire x1="124.46" y1="60.96" x2="114.3" y2="60.96" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="22"/>
<wire x1="71.12" y1="33.02" x2="88.9" y2="33.02" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT8" class="0">
<segment>
<wire x1="5.08" y1="63.5" x2="20.32" y2="63.5" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO5_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO25"/>
<wire x1="124.46" y1="66.04" x2="114.3" y2="66.04" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="18"/>
<wire x1="71.12" y1="38.1" x2="88.9" y2="38.1" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT10" class="0">
<segment>
<wire x1="5.08" y1="66.04" x2="20.32" y2="66.04" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO4_N"/>
</segment>
<segment>
<wire x1="124.46" y1="71.12" x2="114.3" y2="71.12" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO27"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="16"/>
<wire x1="71.12" y1="40.64" x2="88.9" y2="40.64" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT12" class="0">
<segment>
<wire x1="5.08" y1="71.12" x2="20.32" y2="71.12" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO3_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO29"/>
<wire x1="124.46" y1="76.2" x2="114.3" y2="76.2" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="14"/>
<wire x1="71.12" y1="43.18" x2="88.9" y2="43.18" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT14" class="0">
<segment>
<wire x1="5.08" y1="73.66" x2="20.32" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO2_N"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO31"/>
<wire x1="124.46" y1="81.28" x2="114.3" y2="81.28" width="0.1524" layer="91"/>
</segment>
<segment>
<pinref part="JP5" gate="A" pin="12"/>
<wire x1="71.12" y1="45.72" x2="88.9" y2="45.72" width="0.1524" layer="91"/>
</segment>
</net>
<net name="DOUT1" class="0">
<segment>
<wire x1="-30.48" y1="48.26" x2="-48.26" y2="48.26" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO9_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO18"/>
<wire x1="124.46" y1="48.26" x2="114.3" y2="48.26" width="0.1524" layer="91"/>
</segment>
<segment>
<wire x1="63.5" y1="25.4" x2="45.72" y2="25.4" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="27"/>
</segment>
</net>
<net name="DOUT3" class="0">
<segment>
<wire x1="-30.48" y1="50.8" x2="-48.26" y2="50.8" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO8_P"/>
</segment>
<segment>
<wire x1="124.46" y1="53.34" x2="114.3" y2="53.34" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO20"/>
</segment>
<segment>
<wire x1="63.5" y1="27.94" x2="45.72" y2="27.94" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="25"/>
</segment>
</net>
<net name="DOUT5" class="0">
<segment>
<wire x1="-30.48" y1="55.88" x2="-48.26" y2="55.88" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO7_P"/>
</segment>
<segment>
<wire x1="124.46" y1="58.42" x2="114.3" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO22"/>
</segment>
<segment>
<wire x1="63.5" y1="30.48" x2="45.72" y2="30.48" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="23"/>
</segment>
</net>
<net name="DOUT7" class="0">
<segment>
<wire x1="-30.48" y1="58.42" x2="-48.26" y2="58.42" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO6_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO24"/>
<wire x1="124.46" y1="63.5" x2="114.3" y2="63.5" width="0.1524" layer="91"/>
</segment>
<segment>
<wire x1="63.5" y1="33.02" x2="45.72" y2="33.02" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="21"/>
</segment>
</net>
<net name="DOUT9" class="0">
<segment>
<wire x1="-30.48" y1="63.5" x2="-48.26" y2="63.5" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO5_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO26"/>
<wire x1="124.46" y1="68.58" x2="114.3" y2="68.58" width="0.1524" layer="91"/>
</segment>
<segment>
<wire x1="63.5" y1="38.1" x2="45.72" y2="38.1" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="17"/>
</segment>
</net>
<net name="DOUT11" class="0">
<segment>
<wire x1="-30.48" y1="66.04" x2="-48.26" y2="66.04" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO4_P"/>
</segment>
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IO28"/>
<wire x1="124.46" y1="73.66" x2="114.3" y2="73.66" width="0.1524" layer="91"/>
</segment>
<segment>
<wire x1="63.5" y1="40.64" x2="45.72" y2="40.64" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="15"/>
</segment>
</net>
<net name="DOUT13" class="0">
<segment>
<wire x1="-30.48" y1="71.12" x2="-48.26" y2="71.12" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO3_P"/>
</segment>
<segment>
<wire x1="124.46" y1="78.74" x2="114.3" y2="78.74" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO30"/>
</segment>
<segment>
<wire x1="63.5" y1="43.18" x2="45.72" y2="43.18" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="13"/>
</segment>
</net>
<net name="DOUT15" class="0">
<segment>
<wire x1="-30.48" y1="73.66" x2="-48.26" y2="73.66" width="0.1524" layer="91"/>
<pinref part="U$2" gate="G$1" pin="IO2_P"/>
</segment>
<segment>
<wire x1="124.46" y1="83.82" x2="114.3" y2="83.82" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO32"/>
</segment>
<segment>
<wire x1="63.5" y1="45.72" x2="45.72" y2="45.72" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="11"/>
</segment>
</net>
<net name="DST_READY" class="0">
<segment>
<wire x1="-30.48" y1="78.74" x2="-30.48" y2="91.44" width="0.1524" layer="91"/>
<wire x1="-30.48" y1="91.44" x2="81.28" y2="91.44" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IP35"/>
<wire x1="81.28" y1="91.44" x2="124.46" y2="91.44" width="0.1524" layer="91"/>
<wire x1="71.12" y1="53.34" x2="81.28" y2="53.34" width="0.1524" layer="91"/>
<wire x1="81.28" y1="53.34" x2="81.28" y2="91.44" width="0.1524" layer="91"/>
<junction x="81.28" y="91.44"/>
<pinref part="JP5" gate="A" pin="6"/>
<label x="30.48" y="91.44" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="IO1_P"/>
</segment>
</net>
<net name="DST_WRITE" class="0">
<segment>
<wire x1="5.08" y1="78.74" x2="5.08" y2="86.36" width="0.1524" layer="91"/>
<wire x1="5.08" y1="86.36" x2="83.82" y2="86.36" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO33"/>
<wire x1="83.82" y1="86.36" x2="124.46" y2="86.36" width="0.1524" layer="91"/>
<wire x1="71.12" y1="50.8" x2="83.82" y2="50.8" width="0.1524" layer="91"/>
<wire x1="83.82" y1="50.8" x2="83.82" y2="86.36" width="0.1524" layer="91"/>
<junction x="83.82" y="86.36"/>
<pinref part="JP5" gate="A" pin="8"/>
<label x="30.48" y="86.36" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="IO1_N"/>
</segment>
</net>
<net name="SRC_READY" class="0">
<segment>
<wire x1="-30.48" y1="-5.08" x2="-50.8" y2="-5.08" width="0.1524" layer="91"/>
<wire x1="-50.8" y1="-5.08" x2="-50.8" y2="93.98" width="0.1524" layer="91"/>
<wire x1="-50.8" y1="93.98" x2="53.34" y2="93.98" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IP36"/>
<wire x1="53.34" y1="93.98" x2="124.46" y2="93.98" width="0.1524" layer="91"/>
<wire x1="63.5" y1="53.34" x2="53.34" y2="53.34" width="0.1524" layer="91"/>
<wire x1="53.34" y1="53.34" x2="53.34" y2="93.98" width="0.1524" layer="91"/>
<junction x="53.34" y="93.98"/>
<pinref part="JP5" gate="A" pin="5"/>
<label x="30.48" y="93.98" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="IO20_P"/>
</segment>
</net>
<net name="SRC_READ" class="0">
<segment>
<wire x1="5.08" y1="-5.08" x2="22.86" y2="-5.08" width="0.1524" layer="91"/>
<wire x1="22.86" y1="-5.08" x2="22.86" y2="88.9" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO34"/>
<wire x1="22.86" y1="88.9" x2="50.8" y2="88.9" width="0.1524" layer="91"/>
<wire x1="50.8" y1="88.9" x2="124.46" y2="88.9" width="0.1524" layer="91"/>
<wire x1="63.5" y1="50.8" x2="50.8" y2="50.8" width="0.1524" layer="91"/>
<wire x1="50.8" y1="50.8" x2="50.8" y2="88.9" width="0.1524" layer="91"/>
<junction x="50.8" y="88.9"/>
<pinref part="JP5" gate="A" pin="7"/>
<label x="30.48" y="88.9" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="IO20_N"/>
</segment>
</net>
<net name="TRIGGER" class="0">
<segment>
<wire x1="5.08" y1="43.18" x2="25.4" y2="43.18" width="0.1524" layer="91"/>
<wire x1="25.4" y1="43.18" x2="25.4" y2="101.6" width="0.1524" layer="91"/>
<wire x1="25.4" y1="101.6" x2="76.2" y2="101.6" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IO39"/>
<wire x1="76.2" y1="101.6" x2="124.46" y2="101.6" width="0.1524" layer="91"/>
<wire x1="71.12" y1="58.42" x2="76.2" y2="58.42" width="0.1524" layer="91"/>
<wire x1="76.2" y1="58.42" x2="76.2" y2="101.6" width="0.1524" layer="91"/>
<junction x="76.2" y="101.6"/>
<pinref part="JP5" gate="A" pin="2"/>
<label x="30.48" y="101.6" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="CLK10_N"/>
</segment>
</net>
<net name="RST" class="0">
<segment>
<wire x1="5.08" y1="30.48" x2="27.94" y2="30.48" width="0.1524" layer="91"/>
<wire x1="27.94" y1="30.48" x2="27.94" y2="96.52" width="0.1524" layer="91"/>
<wire x1="27.94" y1="96.52" x2="78.74" y2="96.52" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="IP37"/>
<wire x1="78.74" y1="96.52" x2="124.46" y2="96.52" width="0.1524" layer="91"/>
<wire x1="71.12" y1="55.88" x2="78.74" y2="55.88" width="0.1524" layer="91"/>
<wire x1="78.74" y1="55.88" x2="78.74" y2="96.52" width="0.1524" layer="91"/>
<junction x="78.74" y="96.52"/>
<pinref part="JP5" gate="A" pin="4"/>
<label x="30.48" y="96.52" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="CLK11_N"/>
</segment>
</net>
<net name="CLKOUT_C" class="0">
<segment>
<wire x1="-30.48" y1="43.18" x2="-53.34" y2="43.18" width="0.1524" layer="91"/>
<wire x1="-53.34" y1="43.18" x2="-53.34" y2="104.14" width="0.1524" layer="91"/>
<wire x1="-53.34" y1="104.14" x2="20.32" y2="104.14" width="0.1524" layer="91"/>
<pinref part="JP3" gate="A" pin="1"/>
<wire x1="20.32" y1="104.14" x2="20.32" y2="109.22" width="0.1524" layer="91"/>
<label x="-48.26" y="104.14" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="CLK10_P"/>
</segment>
</net>
<net name="CLKIN_C" class="0">
<segment>
<wire x1="-30.48" y1="30.48" x2="-55.88" y2="30.48" width="0.1524" layer="91"/>
<wire x1="-55.88" y1="30.48" x2="-55.88" y2="106.68" width="0.1524" layer="91"/>
<wire x1="-55.88" y1="106.68" x2="-30.48" y2="106.68" width="0.1524" layer="91"/>
<pinref part="JP1" gate="A" pin="1"/>
<label x="-48.26" y="106.68" size="1.778" layer="95"/>
<pinref part="U$2" gate="G$1" pin="CLK11_P"/>
</segment>
</net>
<net name="N$3" class="0">
<segment>
<pinref part="X1" gate="G$1" pin="1"/>
<pinref part="JP2" gate="A" pin="1"/>
<wire x1="-17.78" y1="109.22" x2="-17.78" y2="106.68" width="0.1524" layer="91"/>
<pinref part="JP1" gate="A" pin="2"/>
<wire x1="-17.78" y1="106.68" x2="-5.08" y2="106.68" width="0.1524" layer="91"/>
<wire x1="-27.94" y1="106.68" x2="-17.78" y2="106.68" width="0.1524" layer="91"/>
<junction x="-17.78" y="106.68"/>
</segment>
</net>
<net name="CLKIN_D" class="0">
<segment>
<wire x1="160.02" y1="106.68" x2="160.02" y2="121.92" width="0.1524" layer="91"/>
<pinref part="U$1" gate="HIROSE100" pin="CLKIN"/>
<wire x1="152.4" y1="106.68" x2="160.02" y2="106.68" width="0.1524" layer="91"/>
<wire x1="160.02" y1="121.92" x2="116.84" y2="121.92" width="0.1524" layer="91"/>
<pinref part="JP2" gate="A" pin="2"/>
<wire x1="-2.54" y1="106.68" x2="22.86" y2="106.68" width="0.1524" layer="91"/>
<wire x1="22.86" y1="106.68" x2="86.36" y2="106.68" width="0.1524" layer="91"/>
<wire x1="86.36" y1="106.68" x2="116.84" y2="106.68" width="0.1524" layer="91"/>
<wire x1="116.84" y1="121.92" x2="116.84" y2="106.68" width="0.1524" layer="91"/>
<pinref part="JP3" gate="A" pin="2"/>
<wire x1="22.86" y1="109.22" x2="22.86" y2="106.68" width="0.1524" layer="91"/>
<junction x="22.86" y="106.68"/>
<pinref part="JP5" gate="A" pin="50"/>
<wire x1="71.12" y1="-2.54" x2="86.36" y2="-2.54" width="0.1524" layer="91"/>
<wire x1="86.36" y1="-2.54" x2="86.36" y2="106.68" width="0.1524" layer="91"/>
<junction x="86.36" y="106.68"/>
<label x="30.48" y="106.68" size="1.778" layer="95"/>
</segment>
</net>
<net name="N$5" class="0">
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IP40"/>
<wire x1="124.46" y1="104.14" x2="55.88" y2="104.14" width="0.1524" layer="91"/>
<wire x1="55.88" y1="104.14" x2="55.88" y2="58.42" width="0.1524" layer="91"/>
<wire x1="55.88" y1="58.42" x2="63.5" y2="58.42" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="1"/>
</segment>
</net>
<net name="N$6" class="0">
<segment>
<pinref part="U$1" gate="HIROSE100" pin="IP38"/>
<wire x1="124.46" y1="99.06" x2="58.42" y2="99.06" width="0.1524" layer="91"/>
<wire x1="58.42" y1="99.06" x2="58.42" y2="55.88" width="0.1524" layer="91"/>
<wire x1="58.42" y1="55.88" x2="63.5" y2="55.88" width="0.1524" layer="91"/>
<pinref part="JP5" gate="A" pin="3"/>
</segment>
</net>
</nets>
</sheet>
</sheets>
</schematic>
</drawing>
</eagle>
