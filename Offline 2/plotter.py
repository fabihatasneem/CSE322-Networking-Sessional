import matplotlib.pyplot as plt

# reading statistics from stat.txt
statFile = open("stat.txt", "r")
parameter = statFile.readline()
metrics = statFile.readline().split()

parameters = []
networkThroughput = []
endToEndDelay = []
packetDeliveryRatio = []
packetDropRatio = []

for line in statFile:
    if len(line.split()) == 1:
        parameters.append(int(line))
    else:
        split_list = line.split()
        networkThroughput.append(float(split_list[0]))
        endToEndDelay.append(float(split_list[1]))
        packetDeliveryRatio.append(float(split_list[2]))
        packetDropRatio.append(float(split_list[3]))

statFile.close()

# plotting graphs
plt.plot(parameters, networkThroughput, marker=".", color="b")
plt.ylabel(metrics[0].replace("-", " "))
plt.xlabel(parameter.replace("-", " "))
plt.show()

plt.plot(parameters, endToEndDelay, marker=".", color="g")
plt.ylabel(metrics[1].replace("-", " "))
plt.xlabel(parameter.replace("-", " "))
plt.show()

plt.plot(parameters, packetDeliveryRatio, marker=".", color="m")
plt.ylabel(metrics[2].replace("-", " "))
plt.xlabel(parameter.replace("-", " "))
plt.show()

plt.plot(parameters, packetDropRatio, marker=".", color="y")
plt.ylabel(metrics[3].replace("-", " "))
plt.xlabel(parameter.replace("-", " "))
plt.show()