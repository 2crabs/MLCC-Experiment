
import csv

file = open("sim.csv", mode= "w", newline = "")
writer = csv.writer(file)


R = 1e3
V = 5
C = 22e-6

end = 0.1
steps = 200
dt = end/steps
t = 0

out = 0

writer.writerow([0, 0])

#DC Bias capacitor
for i in range(steps):
    Vr = V-out
    I = Vr/R
    #I=CDv/dt
    C_bias = 22e-6 - (2.33e-6 * out)
    #dv = (I*dt)/C
    dv = (I*dt)/C_bias
    out = out + dv
    t = t + dt
    writer.writerow([t, out])



file.close()
