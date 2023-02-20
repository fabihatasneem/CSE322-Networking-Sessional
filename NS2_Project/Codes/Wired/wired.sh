#!/bin/bash

echo -e "\n------------------ run.sh: starting -----------------\n"
touch stat.txt

# defining baseline parameters
baselineArea=500
baselinePacketRate=200
baselineNode=10
baselineFlow=10

#===========================================================================================================

# plotting graphs varying area size
aqm=0
echo -e "Area-Size-(m)\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "------------- run.sh: Varying Area Size -------------\n"

area=0
for((i=0; i<5; i++));
do
    area=`expr 250 + $area`
    echo -e "$area" >> stat.txt

    echo -e "wired.tcl: running with Area: $area PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $baselineFlow\n"
    ns wired.tcl $aqm $area $baselinePacketRate $baselineNode $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1

area=0
for((i=0; i<5; i++));
do
    area=`expr 250 + $area`
    echo -e "$area" >> stat.txt

    echo -e "wired.tcl: running with Area: $area PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $baselineFlow\n"
    ns wired.tcl $aqm $area $baselinePacketRate $baselineNode $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

rm stat.txt
touch stat.txt

#===========================================================================================================

# plotting graphs varying number of PacketRate
aqm=0
echo -e "Packet-Rate\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "------------- run.sh: Varying Number of PacketRate -------------\n"

packetRate=0
for((i=0; i<5; i++));
do
    packetRate=`expr 100 + $packetRate`
    echo -e "$packetRate" >> stat.txt

    echo -e "wired.tcl: running with Area: $baselineArea PacketRate: $packetRate Nodes: $baselineNode Flows: $baselineFlow\n"
    ns wired.tcl $aqm $baselineArea $packetRate $baselineNode $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1

packetRate=0
for((i=0; i<5; i++));
do
    packetRate=`expr 100 + $packetRate`
    echo -e "$packetRate" >> stat.txt

    echo -e "wired.tcl: running with Area: $baselineArea PacketRate: $packetRate Nodes: $baselineNode Flows: $baselineFlow\n"
    ns wired.tcl $aqm $baselineArea $packetRate $baselineNode $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

rm stat.txt
touch stat.txt

#===========================================================================================================

# plotting graphs varying number of nodes
aqm=0
echo -e "Number-of-Nodes\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "---------- run.sh: Varying Number of Nodes ----------\n"

node=0
for((i=0; i<5; i++));
do
    node=`expr 20 + $node`
    echo -e "$node" >> stat.txt

    echo -e "wired.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $node Flows: $baselineFlow\n"
    ns wired.tcl $aqm $baselineArea $baselinePacketRate $node $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1

node=0
for((i=0; i<5; i++));
do
    node=`expr 20 + $node`
    echo -e "$node" >> stat.txt

    echo -e "wired.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $node Flows: $baselineFlow\n"
    ns wired.tcl $aqm $baselineArea $baselinePacketRate $node $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

rm stat.txt
touch stat.txt

#===========================================================================================================

# plotting graphs varying number of flows
aqm=0
echo -e "Number-of-Flows\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "---------- run.sh: Varying Number of Flows ----------\n"

flow=0
for((i=0; i<5; i++));
do
    flow=`expr 10 + $flow`
    echo -e "$flow" >> stat.txt

    echo -e "wired.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $flow\n"
    ns wired.tcl $aqm $baselineArea $baselinePacketRate $baselineNode $flow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1

flow=0
for((i=0; i<5; i++));
do
    flow=`expr 10 + $flow`
    echo -e "$flow" >> stat.txt

    echo -e "wired.tcl: running with Area: $baselineArea PacketRate: $baselinePacketRate Nodes: $baselineNode Flows: $flow\n"
    ns wired.tcl $aqm $baselineArea $baselinePacketRate $baselineNode $flow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

#===========================================================================================================

# terminating by removing intermediary nam, stat, and trace files
echo -e "---------------- wired.sh: terminating ----------------\n"
rm animation.nam stat.txt trace.tr