#Create a simulator object
set ns [new Simulator]

# ======================================================================
# Define options

set val(ifqlen)       100                      ;# max packet in ifq
set val(packet_size)  500                      ;# size of packets
set val(aqm)          [lindex $argv 0]         ;# 0 for RED, 1 for HRED
set val(packet_rate)  [lindex $argv 1]         ;# rate of sending packets
set val(nn)           [lindex $argv 2]         ;# number of nodes
set val(nf)           [lindex $argv 3]         ;# number of flows
set val(start_time)   0.5                      ;# start time
set val(end_time)     100                      ;# end time
# =======================================================================

# setting queue size
Queue/RED set isHRED_ $val(aqm)
Queue/RED set thresh_queue_ 5
Queue/RED set maxthresh_queue_ 80
Queue/RED set q_weight_ 0.002
Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ false
Queue/RED set gentle_ false
Queue/RED set mean_pktsize_ $val(packet_size)
Queue/RED set cur_max_p_ 1

# trace file
set trace_file [open trace.tr w]
$ns trace-all $trace_file

# nam file
set nam_file [open animation.nam w]
$ns namtrace-all $nam_file

#
# Create a simple five node topology:
#
#                      d1
#                     /
#                    / 
#       s1---------r2------d2 
#                    \ 
#                     \
#                      d3 
#

# Create 1 router & 1 source node
set node_(s1) [$ns node]
set node_(r1) [$ns node]

# Update node numbers
set val(nn) [expr {$val(nn) - 2}]

# Create links between the router & source node
$ns duplex-link $node_(s1) $node_(r1) 15Mb 30ms RED 

# Set queue limit for the router & source node
$ns queue-limit $node_(r1) $node_(s1) $val(ifqlen)
$ns queue-limit $node_(s1) $node_(r1) $val(ifqlen)
$ns duplex-link-op $node_(r1) $node_(s1) orient right
$ns duplex-link-op $node_(r1) $node_(s1) queuePos 0
$ns duplex-link-op $node_(s1) $node_(r1) queuePos 0

# create Destination Nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node_(d$i) [$ns node] 
    # Create link between the dest nodes & r1
    $ns duplex-link $node_(r1) $node_(d$i) 2Mb 10ms RED
}

#Setup flows
for {set i 0} {$i < $val(nf)} {incr i} {
    set dest [expr int(rand() * $val(nn))]
    
    set udp [new Agent/UDP]
    $ns attach-agent $node_(s1) $udp
    set null [new Agent/Null]
    $ns attach-agent $node_(d$dest) $null
    $ns connect $udp $null
    $udp set fid_ $i

    # Create a CBR traffic source
    set traffic [new Application/Traffic/CBR]
    $traffic set packetSize_ $val(packet_size)
    # $traffic set interval_ 0.005
    $traffic set rate_ $val(packet_rate)

    # Attach traffic source to the traffic generator
    $traffic attach-agent $udp

    $ns at $val(start_time) "$traffic start"
    $ns at $val(end_time) "$traffic stop"
    
}

# End Simulation

# call final function
proc finish {} {
    global ns nam_file trace_file
    $ns flush-trace
    close $nam_file
    close $trace_file
    exit 0
}

$ns at $val(end_time) "finish"

# Run simulation
puts "Simulation starting"
$ns run
