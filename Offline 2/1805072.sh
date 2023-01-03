#!/bin/bash

echo -e "\n------------------ run.sh: starting -----------------\n"
touch stat.txt

# defining baseline parameters
baselineArea=500
baselineNode=40
baselineFlow=20

# plotting graphs varying area size
echo -e "Area-Size-(m)\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "------------- run.sh: Varying Area Size -------------\n"

area=0
for((i=0; i<5; i++));
do
    area=`expr 250 + $area`
    echo -e "$area" >> stat.txt

    echo -e "1805072.tcl: running with Area: $area Nodes: $baselineNode Flows: $baselineFlow\n"
    ns 1805072.tcl $area $baselineNode $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

rm stat.txt
touch stat.txt
# plotting graphs varying number of nodes
echo -e "Number-of-Nodes\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "---------- run.sh: Varying Number of Nodes ----------\n"

node=0
for((i=0; i<5; i++));
do
    node=`expr 20 + $node`
    echo -e "$node" >> stat.txt

    echo -e "1805072.tcl: running with Area: $baselineArea Nodes: $node Flows: $baselineFlow\n"
    ns 1805072.tcl $baselineArea $node $baselineFlow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

rm stat.txt
touch stat.txt
# plotting graphs varying number of flows
echo -e "Number-of-Flows\nNetwork-Throughtput-(kilobits/sec) End-to-End-Avg-Delay-(sec) Packet-Delivery-Ratio-(%) Packet-Drop-Ratio-(%)" >> stat.txt
echo -e "---------- run.sh: Varying Number of Flows ----------\n"

flow=0
for((i=0; i<5; i++));
do
    flow=`expr 10 + $flow`
    echo -e "$flow" >> stat.txt

    echo -e "1805072.tcl: running with Area: $baselineArea Nodes: $baselineNode Flows: $flow\n"
    ns 1805072.tcl $baselineArea $baselineNode $flow
    echo -e "\nparser.py: running\n"
    python3 parser.py
done

echo -e "plotter.py: running\n"
python3 plotter.py

# terminating by removing intermediary nam, stat, and trace files
echo -e "---------------- run.sh: terminating ----------------\n"
rm animation.nam stat.txt trace.tr