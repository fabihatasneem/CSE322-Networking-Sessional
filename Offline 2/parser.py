# reading event entries from trace.tr
trace_file = open("trace.tr", "r")

received_bytes = 0
totay_delay = 0
sent_packets = 0
received_packets = 0
dropped_packets = 0

start_time = 0
end_time = 0

header_bytes = 20

sent_time = dict()

for line in trace_file:
    split_list = line.split()

    if start_time == 0:
        start_time = float(split_list[1])
    if end_time < float(split_list[1]):
        end_time = float(split_list[1])
    
    if split_list[6]=="exp" and split_list[3]=="AGT":
        if split_list[0] == "s":
            sent_time[split_list[5]] = split_list[1]
            sent_packets += 1
        if split_list[0] == "r":
            received_bytes += int(split_list[7])-header_bytes
            
            delay = float(split_list[1]) - float(sent_time[split_list[5]])
            if delay < 0:
                print("Error")
            totay_delay += delay

            received_packets += 1
    if split_list[6]=="exp" and split_list[0]=="D":
        dropped_packets += 1

trace_file.close()

# writing statistics to stat.txt
print("Dropped Packets ",dropped_packets)

networkThroughput = (received_bytes*8)/((end_time-start_time)*1000)
endToEndDelay = totay_delay/received_packets
packetDeliveryRatio = (received_packets*1.0)/sent_packets*100
packetDropRatio = (dropped_packets*1.0)/sent_packets*100

stat_file = open("stat.txt", "a")

stat_file.write(str(networkThroughput)+" "+str(endToEndDelay)+" "+str(packetDeliveryRatio)+" "+str(packetDropRatio)+"\n")

stat_file.close()