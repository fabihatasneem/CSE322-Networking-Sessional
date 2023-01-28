# simulator
set ns [new Simulator]


# ======================================================================
# Define options

set val(chan)         Channel/WirelessChannel  ;# channel type
set val(prop)         Propagation/TwoRayGround ;# radio-propagation model
set val(ant)          Antenna/OmniAntenna      ;# Antenna type
set val(ll)           LL                       ;# Link layer type
set val(ifq)          Queue/DropTail/PriQueue  ;# Interface queue type
set val(ifqlen)       50                       ;# max packet in ifq
set val(netif)        Phy/WirelessPhy          ;# network interface type
set val(mac)          Mac/802_11               ;# MAC type
set val(rp)           DSDV                     ;# ad-hoc routing protocol 
set val(as)           [lindex $argv 0]         ;# area size
set val(nn)           [lindex $argv 1]         ;# number of mobilenodes
set val(nf)           [lindex $argv 2]         ;# number of flows
# =======================================================================

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
                -movementTrace OFF

# create nodes
for {set i 0} {$i < $val(nn) } {incr i} {
    set node($i) [$ns node]
    $node($i) random-motion 0       ;# disable random motion

    $node($i) set X_ [expr { int(rand()*10000) % $val(as) } + 0.5]
    $node($i) set Y_ [expr { int(rand()*10000) % $val(as) } + 0.5]
    $node($i) set Z_ 0

    $ns initial_node_pos $node($i) 20
} 

#give random uniform speed
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns at [expr int(20 * rand()) + 10] "$node($i) setdest [expr int(10000 * rand()) % $val(as) + 0.5] [expr int(10000 * rand()) % $val(as) + 0.5] [expr int(100 * rand()) % 5 + 1]"
}

#create flows
for {set i 0} {$i < $val(nf)} {incr i} {
    set src [expr { int(rand() * 10000) % $val(nn) }]
    set dest [expr { int(rand() * 10000) % $val(nn) }]
    while {$src == $dest} {
        set src [expr { int(rand() * 10000) % $val(nn) }]
        set dest [expr { int(rand() * 10000) % $val(nn) }]
        if {$src != $dest} {
            break
        }
    }

    # Traffic config
    # create agent
    set udp [new Agent/UDP]
    set null [new Agent/Null]
    # attach to nodes
    $ns attach-agent $node($src) $udp
    $ns attach-agent $node($dest) $null
    # connect agents
    $ns connect $udp $null
    $udp set fid_ $i

	#Create an Expoo traffic agent and set its configuration parameters
	set traffic [new Application/Traffic/Exponential]
    set size 200
    set burst 2s
    set idle 1s
    set rate 100k
	$traffic set packetSize_ $size
	$traffic set burst_time_ $burst
	$traffic set idle_time_ $idle
	$traffic set rate_ $rate
        
    # Attach traffic source to the traffic generator
    $traffic attach-agent $udp
	#Connect the source and the sink
	$ns connect $udp $null
    
    #starting flow generation
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

