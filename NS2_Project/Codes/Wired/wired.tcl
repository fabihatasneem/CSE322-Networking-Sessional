#Create a simulator object
set ns [new Simulator]

# ======================================================================
# Define options

set val(ifqlen)       90                       ;# max packet in ifq
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
Queue/RED set thresh_queue_ 10
Queue/RED set maxthresh_queue_ 80
Queue/RED set q_weight_ 0.002
Queue/RED set bytes_ false
Queue/RED set queue_in_bytes_ false
Queue/RED set gentle_ false
Queue/RED set mean_pktsize_ 1000
Queue/RED set cur_max_p_ 1

# trace file
set trace_file [open trace.tr w]
$ns trace-all $trace_file

# nam file
set nam_file [open animation.nam w]
$ns namtrace-all $nam_file

#
# Create a simple six node topology:
#
#        s1                 d1
#         \                 /
#          \               / 
#     s2 _ _ r1 --------- r2 _ _ d2 
#          /               \ 
#         /                 \
#        s3                 d3 
#

# Create 2 routers
set node_(r1) [$ns node]
set node_(r2) [$ns node]

# Update node numbers
set val(nn) [expr {$val(nn) - 2}]

puts "Number of nodes without routers $val(nn)"

# Create links between the routers
$ns duplex-link $node_(r1) $node_(r2) 1Mb 30ms RED 

# Set queue limit for the routers
$ns queue-limit $node_(r1) $node_(r2) $val(ifqlen)
$ns queue-limit $node_(r2) $node_(r1) $val(ifqlen)
$ns duplex-link-op $node_(r1) $node_(r2) orient right
$ns duplex-link-op $node_(r1) $node_(r2) queuePos 0
$ns duplex-link-op $node_(r2) $node_(r1) queuePos 0

# create nodes
for {set i 0} {$i < [expr {$val(nn) / 2}]} {incr i} {

    # Source Nodes
    set node_(s$i) [$ns node]
    # Create link between the source nodes & r1
    $ns duplex-link $node_(s$i) $node_(r1) 15Mb 10ms RED 

    # Destination Nodes
    set node_(d$i) [$ns node] 
    # Create link between the dest nodes & r2
    $ns duplex-link $node_(d$i) $node_(r2) 15Mb 10ms RED
}

set val(max) [expr {$val(nn) / 2}]
set val(min) 0

#Setup flows

for {set i 0} {$i < $val(nf)} {incr i} {

    set src [expr int(rand() * ($val(max)-$val(min)))]
    set dest [expr int(rand() * ($val(max)-$val(min)))]
    

    set tcp [new Agent/TCP]
    $ns attach-agent $node_(s$src) $tcp
    set sink [new Agent/TCPSink]
    $ns attach-agent $node_(d$dest) $sink
    $ns connect $tcp $sink
    $tcp set fid_ $i

    # Create a CBR traffic source
    set traffic [new Application/Traffic/CBR]
    $traffic set packetSize_ $val(packet_size)
    $traffic set interval_ 0.005
    $traffic set rate_ $val(packet_rate)

    # Attach traffic source to the traffic generator
    $traffic attach-agent $tcp

    $ns at $val(start_time) "$traffic start"
    $ns at $val(end_time) "$traffic stop"
    
}

# End Simulation

# call final function
proc finish {} {
    global ns nam_file trace_file
    $ns flush-trace 
    #Close the NAM trace file
    close $nam_file
    close $trace_file
    #Execute NAM on the trace file
    # exec nam out.nam &
    exit 0
}

$ns at $val(end_time) "finish"

# Run simulation
puts "Simulation starting"
$ns run
