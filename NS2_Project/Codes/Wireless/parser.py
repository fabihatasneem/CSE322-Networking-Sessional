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
initialEnergy = 1000.0
remainingEnergyOfNodes = dict()
sentTime = dict()

for line in traceFile:
    splitList = line.split()

    if splitList[0] == "N":
        # calculating energy
        remainingEnergyOfNodes[int(splitList[4])] = float(splitList[6])
    else:
        if startTime == 0:
            startTime = float(splitList[1])
        if endTime < float(splitList[1]):
            endTime = float(splitList[1])
        
        if splitList[6]=="tcp" and splitList[3]=="AGT":
            if splitList[0] == "s":
                sentTime[splitList[5]] = splitList[1]

                sentPackets += 1
            elif splitList[0] == "r":
                receivedBytes += int(splitList[7])-headerBytes
                
                delay = float(splitList[1]) - float(sentTime[splitList[5]])
                if delay < 0:
                    print("Error")
                totalDelay += delay

                receivedPackets += 1
        if (splitList[6]=="exp" or splitList[6]=="tcp") and splitList[0]=="D":
            droppedPackets += 1

traceFile.close()

print("sentPackets ",sentPackets, " receivedPackets ", receivedPackets, " droppedPackets ", droppedPackets)

networkThroughput = (receivedBytes*8)/((endTime-startTime)*1000)
endToEndDelay = totalDelay/receivedPackets
packetDeliveryRatio = (receivedPackets*1.0)/sentPackets*100
packetDropRatio = (droppedPackets*1.0)/sentPackets*100

for node in remainingEnergyOfNodes:
    remainingEnergyOfNodes[node] = initialEnergy - remainingEnergyOfNodes[node]

energyConsumption = sum(remainingEnergyOfNodes.values())/len(remainingEnergyOfNodes)

# writing statistics to stat.txt
statFile = open("stat.txt", "a")

statFile.write(str(networkThroughput)+" "+str(endToEndDelay)+" "+str(packetDeliveryRatio)+" "+str(packetDropRatio)+" "+str(energyConsumption)+"\n")

statFile.close()