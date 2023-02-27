#!/bin/bash

echo -e "\n------------------ run.sh: starting -----------------\n"
touch stat.txt

# defining baseline parameters
baselineArea=500
baselinePacketRate=300
baselineNode=40
baselineFlow=20
baselineSpeed=5

#===========================================================================================================

# plotting graphs varying area size
# aqm=0
# echo -e "Area-Size-(m)\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%) Energy-Consumption-(J)" >> stat.txt
# echo -e "------------- run.sh: Varying Area Size -------------\n"

# area=0
# for((i=0; i<5; i++));
# do
#     area=`expr 250 + $area`
#     echo -e "$area" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $area PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $baselineFlow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $area $baselinePacketRate $baselineNode $baselineFlow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# aqm=1

# area=0
# for((i=0; i<5; i++));
# do
#     area=`expr 250 + $area`
#     echo -e "$area" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $area PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $baselineFlow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $area $baselinePacketRate $baselineNode $baselineFlow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# echo -e "plotter.py: running\n"
# python3 plotter.py

# rm stat.txt
# touch stat.txt

#===========================================================================================================

# plotting graphs varying rate of packets
# aqm=0
# echo -e "Packet-Rate\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%) Energy-Consumption-(J)" >> stat.txt
# echo -e "------------- run.sh: Varying Rate of Packets -------------\n"

# packetRate=0
# for((i=0; i<5; i++));
# do
#     packetRate=`expr 100 + $packetRate`
#     echo -e "$packetRate" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $packetRate Nodes: $baselineNode Flows: $baselineFlow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $baselineArea $packetRate $baselineNode $baselineFlow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# aqm=1

# packetRate=0
# for((i=0; i<5; i++));
# do
#     packetRate=`expr 100 + $packetRate`
#     echo -e "$packetRate" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $packetRate Nodes: $baselineNode Flows: $baselineFlow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $baselineArea $packetRate $baselineNode $baselineFlow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# echo -e "plotter.py: running\n"
# python3 plotter.py

# rm stat.txt
# touch stat.txt

# #===========================================================================================================

# # plotting graphs varying number of nodes
# aqm=0
# echo -e "Number-of-Nodes\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%) Energy-Consumption-(J)" >> stat.txt
# echo -e "---------- run.sh: Varying Number of Nodes ----------\n"

# node=0
# for((i=0; i<5; i++));
# do
#     node=`expr 20 + $node`
#     echo -e "$node" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $node Flows: $baselineFlow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $baselineArea $baselinePacketRate $node $baselineFlow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# aqm=1

# node=0
# for((i=0; i<5; i++));
# do
#     node=`expr 20 + $node`
#     echo -e "$node" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $node Flows: $baselineFlow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $baselineArea $baselinePacketRate $node $baselineFlow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done
# echo -e "plotter.py: running\n"
# python3 plotter.py

# rm stat.txt
# touch stat.txt

#===========================================================================================================

# plotting graphs varying number of flows
# aqm=0
# echo -e "Number-of-Flows\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%) Energy-Consumption-(J)" >> stat.txt
# echo -e "---------- run.sh: Varying Number of Flows ----------\n"

# flow=0
# for((i=0; i<5; i++));
# do
#     flow=`expr 10 + $flow`
#     echo -e "$flow" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $flow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $baselineArea $baselinePacketRate $baselineNode $flow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# aqm=1

# flow=0
# for((i=0; i<5; i++));
# do
#     flow=`expr 10 + $flow`
#     echo -e "$flow" >> stat.txt

#     echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $flow Speed: $baselineSpeed\n"
#     ns wireless.tcl $aqm $baselineArea $baselinePacketRate $baselineNode $flow $baselineSpeed
#     echo -e "\nparser.py: running\n"
#     python3 parser.py
# done

# echo -e "plotter.py: running\n"
# python3 plotter.py

# rm stat.txt
# touch stat.txt

# #===========================================================================================================

# plotting graphs varying speed
aqm=0
echo -e "Speed\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%) Energy-Consumption-(J)" >> stat.txt
echo -e "---------- run.sh: Varying Speed ----------\n"

speed=0
for((i=0; i<5; i++));
do
    speed=`expr 5 + $speed`
    echo -e "$speed" >> stat.txt

    echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $baselineFlow Speed: $speed\n"
    ns wireless.tcl $aqm $baselineArea $baselinePacketRate $baselineNode $baselineFlow $speed
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1

speed=0
for((i=0; i<5; i++));
do
    speed=`expr 5 + $speed`
    echo -e "$speed" >> stat.txt

    echo -e "wireless.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $baselineFlow Speed: $speed\n"
    ns wireless.tcl $aqm $baselineArea $baselinePacketRate $baselineNode $baselineFlow $speed
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

#===========================================================================================================

# terminating by removing intermediary nam, stat, and trace files
echo -e "---------------- wireless.sh: terminating ----------------\n"
rm animation.nam stat.txt trace.tr