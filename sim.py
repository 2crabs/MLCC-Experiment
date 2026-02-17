
import csv

file = open("data/sim.csv", mode= "w", newline = "")
writer = csv.writer(file)

#1k ohm
R = 1e3
#5V
V = 5
#22uf
C = 22e-6

#100ms
end = 0.1
steps = 200
dt = end/steps
t = 0

#voltage across capacitor
Vc = 0

writer.writerow([0, 0])

#DC Bias capacitor
for i in range(steps):
    #Voltage and thus current across resistor during this step
    Vr = V-Vc
    I = Vr/R

    #Linear approximation of capacitance due to DC bias
    C_bias = 22e-6 - (2.29e-6 * Vc)

    #Based on current and amount of time, increment voltage
    dv = (I*dt)/C_bias
    Vc = Vc + dv

    #record result
    t = t + dt
    writer.writerow([t, Vc])



file.close()
