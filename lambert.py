import scipy.special as special
import math
import csv

def formula(R, V, C1, C2, t):
    power = math.exp(((R * C2 * V)-t)/(R * (C1 - C2 * V)))
    fraction = (C2 * V)/(C1 - C2 * V)
    lambert = special.lambertw(power * fraction)
    return V - (lambert * ((C1/C2)-V))

file = open("data/lambert.csv", mode= "w", newline = "")
writer = csv.writer(file)

#1k ohm
R = 1e3
#5V
V = 5

C1 = 22e-6
C2 = 2.29e-6

#100ms
end = 0.1
steps = 50
dt = end/steps
t = 0

writer.writerow([0, 0])

for i in range(steps):
    t = t + dt
    result = formula(R, V, C1, C2, t).real
    writer.writerow([t, result])

file.close()

