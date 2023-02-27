#!/bin/bash

echo -e "\n------------------ run.sh: starting -----------------\n"
touch stat.txt

# defining baseline parameters
baselinePacketRate=300000
baselineNode=100
baselineFlow=99

#===========================================================================================================

# plotting graphs varying number of PacketRate
aqm=0
echo -e "RED\n"
echo -e "Packet-Rate\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "------------- run.sh: Varying Number of PacketRate -------------\n"

packetRate=0
for((i=0; i<5; i++));
do
    packetRate=`expr 100000 + $packetRate`
    echo -e "$packetRate" >> stat.txt

    echo -e "wired.tcl: running with PacketRate: $packetRate Nodes: $baselineNode Flows: $baselineFlow\n"
    ns wired.tcl $aqm $packetRate $baselineNode $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1
echo -e "HRED\n"
packetRate=0
for((i=0; i<5; i++));
do
    packetRate=`expr 100000 + $packetRate`
    echo -e "$packetRate" >> stat.txt

    echo -e "wired.tcl: running with PacketRate: $packetRate Nodes: $baselineNode Flows: $baselineFlow\n"
    ns wired.tcl $aqm $packetRate $baselineNode $baselineFlow
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
echo -e "RED\n"
echo -e "Number-of-Nodes\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "---------- run.sh: Varying Number of Nodes ----------\n"

node=0
for((i=0; i<5; i++));
do
    node=`expr 20 + $node`
    flow=`expr $node - 1`
    echo -e "$node" >> stat.txt

    echo -e "wired.tcl: running with PacketRate: $baselinePacketRate Nodes: $node Flows: $flow\n"
    ns wired.tcl $aqm $baselinePacketRate $node $flow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1
echo -e "HRED\n"
node=0
for((i=0; i<5; i++));
do
    node=`expr 20 + $node`
    flow=`expr $node - 1`
    echo -e "$node" >> stat.txt

    echo -e "wired.tcl: running with PacketRate: $baselinePacketRate Nodes: $node Flows: $flow\n"
    ns wired.tcl $aqm $baselinePacketRate $node $flow
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
echo -e "RED\n"
echo -e "Number-of-Flows\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "---------- run.sh: Varying Number of Flows ----------\n"

flow=0
for((i=0; i<5; i++));
do
    flow=`expr 10 + $flow`
    node=`expr $flow - 1`
    echo -e "$flow" >> stat.txt

    echo -e "wired.tcl: running with PacketRate: $baselinePacketRate Nodes: $node Flows: $flow\n"
    ns wired.tcl $aqm $baselinePacketRate $node $flow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

aqm=1
echo -e "HRED\n"
flow=0
for((i=0; i<5; i++));
do
    flow=`expr 10 + $flow`
    node=`expr $flow - 1`
    echo -e "$flow" >> stat.txt

    echo -e "wired.tcl: running with PacketRate: $baselinePacketRate Nodes: $baselnodeineNode Flows: $flow\n"
    ns wired.tcl $aqm $baselinePacketRate $node $flow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

#===========================================================================================================

# terminating by removing intermediary nam, stat, and trace files
echo -e "---------------- wired.sh: terminating ----------------\n"
rm animation.nam stat.txt trace.tr