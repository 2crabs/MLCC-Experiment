
import csv

file = open("data/sim-50.csv", mode= "w", newline = "")
writer = csv.writer(file)

#1k ohm
R = 1e3
#5V
V = 5
#22uf
C = 22e-6

#100ms
end = 0.1
steps = 50
dt = end/steps
t = 0

#voltage across capacitor
out = 0

writer.writerow([0, 0])

#DC Bias capacitor
for i in range(steps):
    #Voltage and thus current across resistor during this step
    Vr = V-out
    I = Vr/R

    #Linear approximation of capacitance due to DC bias
    C_bias = 22e-6 - (2.33e-6 * out)

    #Based on current and amount of time, increment voltage
    dv = (I*dt)/C
    out = out + dv

    #record result
    t = t + dt
    writer.writerow([t, out])



file.close()
