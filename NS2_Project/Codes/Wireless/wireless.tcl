# simulator
set ns [new Simulator]

# ======================================================================
# Define options

set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/RED                ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           DSDV                     ;# ad-hoc routing protocol 
set val(packet_size)  500                      ;# size of packets
set val(aqm)          [lindex $argv 0]         ;# 0 for RED, 1 for HRED
set val(as)           [lindex $argv 1]         ;# area size
set val(packet_rate)  [lindex $argv 2]         ;# rate of sending packets
set val(nn)           [lindex $argv 3]         ;# number of mobilenodes
set val(nf)           [lindex $argv 4]         ;# number of flows
set val(speed)        [lindex $argv 5]         ;# speed
# =======================================================================


# setting queue size
Queue/RED set isHRED_ $val(aqm)             ;#1 for HRED, 0 for RED
Queue/RED set thresh_queue_ 10
Queue/RED set maxthresh_queue_ 80
Queue/RED set q_weight_ 0.002
Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ false
Queue/RED set gentle_ false
Queue/RED set mean_pktsize_ 1000
Queue/RED set cur_max_p_ 0.1

# trace file
set trace_file [open trace.tr w]
$ns trace-all $trace_file

# nam file
set nam_file [open animation.nam w]
$ns namtrace-all-wireless $nam_file $val(as) $val(as)

# topology: to keep track of node movements
set topo [new Topography]
$topo load_flatgrid $val(as) $val(as) ;             


# general operation director for mobilenodes
create-god $val(nn)


# node configs
# ======================================================================

# $ns node-config -addressingType flat or hierarchical or expanded
#                  -adhocRouting   DSDV or DSR or TORA
#                  -llType	   LL
#                  -macType	   Mac/802_11
#                  -propType	   "Propagation/TwoRayGround"
#                  -ifqType	   "Queue/DropTail/PriQueue"
#                  -ifqLen	   50
#                  -phyType	   "Phy/WirelessPhy"
#                  -antType	   "Antenna/OmniAntenna"
#                  -channelType    "Channel/WirelessChannel"
#                  -topoInstance   $topo
#                  -energyModel    "EnergyModel"
#                  -initialEnergy  (in Joules)
#                  -rxPower        (in W)
#                  -txPower        (in W)
#                  -agentTrace     ON or OFF
#                  -routerTrace    ON or OFF
#                  -macTrace       ON or OFF
#                  -movementTrace  ON or OFF

# ======================================================================

$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -topoInstance $topo \
                -channelType $val(chan) \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace OFF \
                -movementTrace OFF \
                -energyModel "EnergyModel" \
                -initialEnergy  1000.0 \
                -rxPower 0.5 \
                -txPower 1.0 \
                -idlePower 0.45 \
                -sleepPower 0.001

# create nodes
for {set i 0} {$i < $val(nn) } {incr i} {
    set node($i) [$ns node]
    $node($i) random-motion 0       ;# disable random motion

    $node($i) set X_ [expr { int(rand()*10000) % $val(as) } + 0.5]
    $node($i) set Y_ [expr { int(rand()*10000) % $val(as) } + 0.5]
    $node($i) set Z_ 0

    $ns initial_node_pos $node($i) 20

    #set speed of a node
    $ns at 0.0 "$node($i) setdest [expr int(10000 * rand()) % $val(as) + 0.5] [expr int(10000 * rand()) % $val(as) + 0.5] $val(speed)"
} 

#create flows
for {set i 0} {$i < $val(nf)} {incr i} {
    set src [expr { int(rand() * 10000) % $val(nn) }]
    set dest [expr { int(rand() * 10000) % $val(nn) }]
    while {$src == $dest} {
        set src [expr { int(rand() * 10000) % $val(nn) }]
        set dest [expr { int(rand() * 10000) % $val(nn) }]
    }

    # Traffic config
    # create agent
    set tcp [new Agent/TCP/Reno]
    set tcp_sink [new Agent/TCPSink]
    # attach to nodes
    $ns attach-agent $node($src) $tcp
    $ns attach-agent $node($dest) $tcp_sink
    # connect the source with the sink
    $ns connect $tcp $tcp_sink
    $tcp set fid_ $i

    $tcp set window_ 15
    $tcp set packetRate_ $val(packet_rate)

	# #Create an Exponential traffic agent and set its configuration parameters
	# set traffic [new Application/Traffic/Exponential]
    # set burst 2s
    # set idle 1s
	# $traffic set packetSize_ $val(packet_size)
	# $traffic set burst_time_ $burst
	# $traffic set idle_time_ $idle
	# $traffic set rate_ $val(packet_rate)

#    # Create a CBR traffic source
#     set traffic [new Application/Traffic/CBR]
#     $traffic set packetSize_ $val(packet_size)
#     $traffic set interval_ 0.005
#     $traffic set rate_ $val(packet_rate)

    # Traffic generator
    set traffic [new Application/FTP]
    # attach to agent
    $traffic attach-agent $tcp

    # Attach traffic source to the traffic generator
    $traffic attach-agent $tcp

    #Schedule events for the CBR agents
    $ns at [expr { int(rand() * 9) + 1 }] "$traffic start"
}

# End Simulation

# Stop nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at 50.0 "$node($i) reset"
}

# call final function
proc finish {} {
    global ns trace_file nam_file
    $ns flush-trace
    close $trace_file
    close $nam_file
}

proc halt_simulation {} {
    global ns
    puts "Simulation ending"
    $ns halt
}

$ns at 50.0001 "finish"
$ns at 50.0002 "halt_simulation"



# Run simulation
puts "Simulation starting"
$ns run

