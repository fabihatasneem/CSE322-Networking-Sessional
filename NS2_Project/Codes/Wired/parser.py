# reading event entries from trace.tr
traceFile = open("trace.tr", "r")

receivedBytes = 0
totalDelay = 0
sentPackets = 0
receivedPackets = 0
droppedPackets = 0
startTime = 0
endTime = 0
headerBytes = 20
sentTime = dict()

for line in traceFile:
    splitList = line.split()
    if startTime == 0:
        startTime = float(splitList[1])
    if endTime < float(splitList[1]):
        endTime = float(splitList[1])
    
    if splitList[4]=="tcp" or splitList[4]=="udp" or splitList[4]=="cbr":
        if splitList[0] == "+":
            sentTime[splitList[11]] = splitList[1]
            sentPackets += 1
        elif splitList[0] == "r":
            receivedBytes += int(splitList[5])-headerBytes
            receivedPackets += 1
            delay = float(splitList[1]) - float(sentTime[splitList[11]])
            if delay < 0:
                print("Error")
            totalDelay += delay
        elif splitList[0]=="d" or splitList[0]=="D":
            droppedPackets += 1

traceFile.close()

networkThroughput = (receivedBytes*8)/((endTime-startTime)*1000)
endToEndDelay = totalDelay/receivedPackets
packetDeliveryRatio = (receivedPackets*1.0)/sentPackets*100
packetDropRatio = (droppedPackets*1.0)/sentPackets*100

# writing statistics to stat.txt
statFile = open("stat.txt", "a")

statFile.write(str(networkThroughput)+" "+str(endToEndDelay)+" "+str(packetDeliveryRatio)+" "+str(packetDropRatio)+"\n")

statFile.close()