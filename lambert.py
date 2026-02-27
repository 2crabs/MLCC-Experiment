import scipy.special as special
import math
import csv

def formula(R, V, C1, C2, t):
    A = C2/(C1-C2*V)
    power = math.exp((-t)/((R*C1) - (R*C2*V)))
    fraction = (A*V) * (math.exp(A*V))
    lambertInner = power * fraction
    lambert = special.lambertw(lambertInner, tol = 1e-9).real
    return V - (lambert * (1/A))

file = open("data/lambert.csv", mode= "w", newline = "")
writer = csv.writer(file)

#1k ohm
R = 1e3
#5V
V = 5
#22uf

C1 = 22e-6
C2 = 2.29e-6

#100ms
end = 0.1
steps = 20
dt = end/steps
t = 0

writer.writerow([0, 0])

#DC Bias capacitor
for i in range(steps):
    t = t + dt
    result = formula(R, V, C1, C2, t)
    writer.writerow([t, result])

file.close()

