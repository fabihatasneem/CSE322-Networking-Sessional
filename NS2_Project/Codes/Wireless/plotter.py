import matplotlib.pyplot as plt

# reading statistics from stat.txt
statFile = open("stat.txt", "r")
parameterName = statFile.readline().strip()
metrics = statFile.readline().split()

parameters = []

REDnetworkThroughput = []
REDendToEndDelay = []
REDpacketDeliveryRatio = []
REDpacketDropRatio = []
REDenergyConsumption = []

HREDnetworkThroughput = []
HREDendToEndDelay = []
HREDpacketDeliveryRatio = []
HREDpacketDropRatio = []
HREDenergyConsumption = []

for i, line in enumerate(statFile):
    if i < 10:
        # normal RED
        if len(line.split()) == 1:
            parameters.append(int(line))
        else:
            splitList = line.split()
            REDnetworkThroughput.append(float(splitList[0]))
            REDendToEndDelay.append(float(splitList[1]))
            REDpacketDeliveryRatio.append(float(splitList[2]))
            REDpacketDropRatio.append(float(splitList[3]))
            REDenergyConsumption.append(float(splitList[4]))
    else:
        # HRED
        if len(line.split()) != 1:
            splitList = line.split()
            HREDnetworkThroughput.append(float(splitList[0]))
            HREDendToEndDelay.append(float(splitList[1]))
            HREDpacketDeliveryRatio.append(float(splitList[2]))
            HREDpacketDropRatio.append(float(splitList[3]))
            HREDenergyConsumption.append(float(splitList[4]))

statFile.close()

# plotting graphs
plt.plot(parameters, REDnetworkThroughput, marker=".", color="r", label="RED")
plt.plot(parameters, HREDnetworkThroughput, marker=".", color="b", label="HRED")
plt.ylabel(metrics[0].replace("-", " "))
plt.xlabel(parameterName.replace("-", " "))
plt.legend()
figName = "Graphs/" + parameterName + "-throughput.png"
plt.savefig(figName)
plt.close()

plt.plot(parameters, REDendToEndDelay, marker=".", color="r", label="RED")
plt.plot(parameters, HREDendToEndDelay, marker=".", color="b", label="HRED")
plt.ylabel(metrics[1].replace("-", " "))
plt.xlabel(parameterName.replace("-", " "))
plt.legend()
figName = "Graphs/" + parameterName + "-delay.png"
plt.savefig(figName)
plt.close()

plt.plot(parameters, REDpacketDeliveryRatio, marker=".", color="r", label="RED")
plt.plot(parameters, HREDpacketDeliveryRatio, marker=".", color="b", label="HRED")
plt.ylabel(metrics[2].replace("-", " "))
plt.xlabel(parameterName.replace("-", " "))
plt.legend()
figName = "Graphs/" + parameterName + "-deliveryRatio.png"
plt.savefig(figName)
plt.close()

plt.plot(parameters, REDpacketDropRatio, marker=".", color="r", label="RED")
plt.plot(parameters, HREDpacketDropRatio, marker=".", color="b", label="HRED")
plt.ylabel(metrics[3].replace("-", " "))
plt.xlabel(parameterName.replace("-", " "))
plt.legend()
figName = "Graphs/" + parameterName + "-dropRatio.png"
plt.savefig(figName)
plt.close()

plt.plot(parameters, REDenergyConsumption, marker=".", color="r", label="RED")
plt.plot(parameters, HREDenergyConsumption, marker=".", color="b", label="HRED")
plt.ylabel(metrics[4].replace("-", " "))
plt.xlabel(parameterName.replace("-", " "))
plt.legend()
figName = "Graphs/" + parameterName + "-energyConsumption.png"
plt.savefig(figName)
plt.close()