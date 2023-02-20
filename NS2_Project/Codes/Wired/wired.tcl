#Create a simulator object
set ns [new Simulator]

# ======================================================================
# Define options

set val(ifq)          Queue/RED                ;# Interface queue type
set val(ifqlen)       100                      ;# max packet in ifq
set val(packet_size)  500                      ;# size of packets
set val(aqm)          [lindex $argv 0]         ;# 0 for RED, 1 for HRED
set val(as)           [lindex $argv 1]         ;# area size
set val(packet_rate)  [lindex $argv 2]         ;# rate of sending packets
set val(nn)           [lindex $argv 3]         ;# number of nodes
set val(nf)           [lindex $argv 4]         ;# number of flows
set val(start_time)   0.5                      ;# start time
set val(end_time)     50                       ;# end time
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

# create nodes
for {set i 0} {$i < $val(nn)} {incr i} {
    set node($i) [$ns node]
}

#Setup flows
for {set i 0} {$i < $val(nf)} {incr i} {

    set src [expr { int(rand() * 10000) % $val(nn) }]
    set dest [expr { int(rand() * 10000) % $val(nn) }]
    while {$src == $dest} {
        set src [expr { int(rand() * 10000) % $val(nn) }]
        set dest [expr { int(rand() * 10000) % $val(nn) }]
    }

    # Create link between the nodes
    $ns duplex-link $node($src) $node($dest) 2Mb 10ms RED

    # Set queue limit
    $ns queue-limit $node($src) $node($dest) $val(ifqlen)

    set tcp [new Agent/TCP]
    $ns attach-agent $node($src) $tcp
    set sink [new Agent/TCPSink]
    $ns attach-agent $node($dest) $sink
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
