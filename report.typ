//IMPORTS
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/codelst:2.0.2": sourcecode, sourcefile
#import "@preview/equate:0.3.2": equate
#import "@preview/showybox:2.0.4": showybox

#show: equate.with(breakable: true, sub-numbering: true, number-mode: "label")
#set math.equation(numbering: "(1.1)")


#let mathStuff(number) = {
  for value in range(1,number) {
    [#text(fill:  rgb("#bcbcbc"))[math ]]
  }
}

#let mathNote(body, right, left) = {
  align(center)[
    #table(
      columns: 2,
      stroke: none,
      inset: (right: right, left: left),
      text(size: 9pt, fill: rgb("#a1a1a1"))[#body], text(size: 9pt, fill: rgb("#a1a1a1"))[#body]
    )
    
  ]
}

#let colorFormula(body, color) = text(fill: color)[$#body$]

#let simpleMathNote(body, right, left) = {
  align(center)[
    #table(
      columns: 1,
      stroke: none,
      inset: (right: right, left: left),
      text(size: 9pt, fill: rgb("#a1a1a1"))[#body]
    )
    
  ]
}

#let modifiedRCFormula(Vc, V, R, C1, C2) = (
  (R * C2 * Vc) - R * (C1 - C2 * V) * (calc.ln((V - Vc)/V))
)

#let RCFormula(v, r, c, t) = (
  v*(1-(calc.pow(2.71828, ((-t)/(r*c)))))
)

//TITLE PAGE
#show title: set align(center + horizon)
#show title: set pad(y: 16pt)
#show title: set text(font: "TeX Gyre Bonum", weight: "thin", size: 30pt)



#title()[Effect of DC Bias on Effective Capacitance of MLCCs]
#v(5pt)
#align(center, text(font: "TeX Gyre Bonum")[M. Fraser])
#pagebreak()


//OUTLINE

//taken from Mc-Zen
#let appendix(body) = {
  set heading(numbering: "A", supplement: [Appendix])
  counter(heading).update(0)
  body
}
#set heading(supplement: [Section])

#show outline.entry: set text(font: "TeX Gyre Adventor", weight: "medium")
#show outline: set text(font: "TeX Gyre Adventor", weight: "medium")


#outline(depth: 2, target: heading.where(supplement: [Section]))
#outline(target: heading.where(supplement: [Appendix]), title: [Appendix])
//#outline(target: figure.where(kind: image), title: [Figures])
//#outline(target: figure.where(kind: table), title: [Tables])

// END OUTLINE

//PAGE
#set page(
  numbering: "1"
  , columns: 2
)
#counter(page).update(1)

//PARAGRAPH
#set par(
  first-line-indent: 1em,
  spacing: 0.65em,
  justify: true,
  linebreaks: "simple",
)
#set text(hyphenate: false)

//HEADINGS
//#show heading.where(level: 1): set align(center)
#show heading.where(level: 1): set text(font: "TeX Gyre Adventor", weight: "bold")
#show heading.where(level: 2): set text(font: "TeX Gyre Adventor", weight: "medium")
#show heading.where(level: 3): set text(font: "TeX Gyre Adventor", weight: "thin")

#set heading(numbering: "1.")

#show image: set align(center)
#set image(width: 80%)


#set block(spacing: 1.6em)

//FIGURES
#show figure.caption: emph
//#show figure.caption: set text(font: "arial", size: 9pt, weight: "extrabold")
//#show figure.where(kind: table): set figure.caption(position: top)

//END OF SETUP



= Introduction <intro>

Opening up any modern computer will reveal hundreds of electrical components, ranging from the miniscule resistors to large chips with hundreds of electrical contacts. Among these one shows up on nearly every circuit board. A multi-layer ceramic capacitor or MLCC is used in just about every circuit produced today. Both in precise high speed applications, such as on a CPU, and high power designs, like a DC-DC converter, they have a wide range of uses. Through their combination of ease of use in assembly, low cost, and small size, multi-layer ceramic capacitors have become an indispensable tool in circuit design.

#figure(
  image("imgs/mlcc_0.png"),
  caption: "MLCCs come in many shapes and sizes, with some as small as a grain of sand"
)<sizes>

Despite being mainly used in mass production of consumer products, MLCCs are simultaneously used in hobbyist designs. While nearly always coming in Surface Mount packages, though hole packages exist, making them easy to solder by hand. And while other types of capacitors exist, they do not offer the same characteristics.

== Voltage, Current, and Resistance <VIR>
To understand their function and why they are universally used, it is important to first understand the basic theory of how electricity flows. Voltage, a potential difference, causes current, the flow of electrons, through a conductor. 

#figure(
  image("imgs/ohms-law.jpg"),
  caption: "A popular cartoon representing voltage and amperage"
)<ohms>

When a voltage difference, such as from a battery, is applied across a conductor, current is allowed to flow unrestricted through that conductor. An electrical drawing known as a schematic can be used to respresent these connections as @schematicIntro shows.

#figure(
  image("imgs/short.png", height: 90pt, fit: "contain"),
  caption: "Voltage across conductor",
)<schematicIntro>

This is known as a short circuit. The amount of current flowing can be limited by using a resistor. A resistor is a component where the current flowing is directly proportional to the amount of voltage across the resistor. This relationship is shown in the following equation where $V="voltage"$ (measured in volts), $I= "current"$ (measured in amperes), and $R= "resistance"$ (measured in ohms, represented #sym.Omega).

$ V = I dot R $<eqOhmsLaw>

This relationship is known as Ohm's Law and the accompanying circuit can be depicted by a schematic as shown in @schematicR.

#figure(
  image("imgs/resistor.png", height: 90pt, fit: "contain"),
  caption: "Voltage across resistor"
)<schematicR>

As an example, if a 5V battery is connected to a 100#sym.Omega resistor, the current can be found.

$ V = I dot R $
$ 5V = I dot 100 Omega $
$ (5V)/(100 Omega) = I $
$ 0.05A = I $

As seen above knowing any two variables of this equation allows solving for the third. The equation can be manipulated to solve for Resistance, $R = I/V$, or current, $I = V/R$.

== Model of Capacitor <C>
A capacitor is a device where the current flowing through is proportional to the rate of change of voltage across the capacitor. That is,
$ I = C (d V)/(d t) $<eqC>
where $C$ is the capacitance in Farads. When a capacitor is connected to a constant current source the voltage across the capacitor will increase at a constant rate. The schematic of this situation is depicted in @schematicC. Conversely when a capacitor provides a constant current the voltage decreases at a linear rate.

#figure(
  image("imgs/capacitor.png", height: 90pt, fit: "contain"),
  caption: "Constant current into capacitor"
)<schematicC>

 Functionally, a capacitor acts similarly to a battery in that it can be charged and then discharged.

This models an ideal capacitor, a capacitor that behaves exactly as mathematically modelled, but real capacitors and especially multi-layer cermaic capacitors face non-idealities which change this model. One of the most important, yet often overlooked, non-idealities in MLCCs is DC bias. DC bias causes the capacitance, $C$, to be reduced as a voltage is applied across the capacitor. This introduces a new curve, which is the capacitance versus voltage curve. Manufacturers of capacitors will provide this. An example of the DC Bias graph of a standard capacitor is shown in @bias.

These curves have a domain of $0<V<V_max$ due to maximum ratings and capacitors being bidirectional.

#let (V, C) = lq.load-txt(read("data/22u6v3.csv"))
#let C = C.map(x => if x > 5.0 { x /10.0} else {x})

#figure(
  block(
    lq.diagram(
      lq.plot(
        V, C.map(x => x* 10.0),
        mark: none
      ),
      xlabel: [DC Bias (V)],
      ylabel: [Capacitance ($mu"F"$)]
    ),
    inset: (right: 20pt)
  ),
  caption: [DC Bias of 22$mu"F"$ capacitor from Murata]
)<bias>

Because Capacitance is in fact a function of voltage, $C = C(V)$, a more accurate model of a capacitor is $I = C(V) (d v)/(d t)$. This is important when there is large change in voltage across the capacitor.
== Research Question

The effect of DC Bias is mainly used for noise suppresion applications. In these applications, because the voltage across the capacitor has a relatively small range, it is sufficient to assume $C$ as constant, functionally making the capacitor a derated version of itself. This can not be done when a device is first turned on, and a MLCC goes from 0V to $V_"in"$, a large voltage change. During this transition the capacitor has a large range of capacitance from $C(0V)$ to $C(V_"in")$.

Due to many systems requiring supply voltage to stabilize before a component is activated, components often will have an enable pin that will only allow the device to turn on when the voltage reachess a certain threshold. This is often achieved by using a capacitor to limit how fast the voltage on this pin rises. Meeting rigid timing requirements neccesitates knowing how quickly the voltage across a capacitor will rise. The aim of this paper is to find the effect DC Bias has on the effective capacitance of a MLCC during large voltage changes such as those found in device turn on.



= RC Formula <RC>

== Applications <RCapp>
Creating the constant current source in @C for a capacitor can be difficult, so instead a resistor, as mentioned in @VIR, can be used to limit voltage increasing across a capacitor. Resistors, similar to capacitors, are relatively cheap and come in small package sizes. Combining these two components creates a circuit often referred to as an RC Circuit. The diagram of this is shown in @RCcircuit.

#figure(
  image("imgs/RC.png"),
  caption: [Schematic of RC Circuit]
)<RCcircuit>

This circuit is often used to limit noise in a system in order to prevent unexpected behvavior. Here it will be used to slow down the rise time of voltage across a capacitor.

The voltage across the resistor, $V_R$, and voltage across the capacitor, $V_C$, add to $V_"in"$. Using this, it is possible to mathematically model the circuit as shown below.

$ V_R + V_C = V_"in" $
$ V_C = V_"in" - V_R $

Substituting in the formula from @VIR for $V_R$ we get:

$ V_C =  V_"in" - I R $

And finally using the equation for a capacitor from @C to replace $I$:

$ V_C = V_"in" - R C (d V) / (d t) $

The equation in this form is not very helpful because it not possible to easily input a time and get an output voltage. Because of this, the equation is almost always manipulated into the RC formula, shown below. This process is explained in @RCderiv.

$ V_C (t) = V_"in" dot (1 - e^((-t)/(R C))) $<eqRC>

This equation makes it easy to get the output voltage at a specific time of an ideal capacitor. It is worth noting that this is the charging form of the equation and there is another form for discharging of a capacitor.


== Derivation <RCderiv>
The formula in @RCapp can be derived using the following process.

#set block(spacing: 0.5em)
$ V_C = V_"in" - R C (d V_C) / (d t) $
#mathNote([$- V_"in"$], 10pt, 10pt)
$ V_C - V_"in" = -R C (d V_C) / (d t) $
#mathNote([$div R C$], 10pt, 10pt)
$ (V_C - V_"in")/(R C) = -(d V) / (d t) $
#mathNote([$dot d t$], 15pt, 20pt)
$ ((d t)(V_C - V_"in"))/(R C) = -d V $
#mathNote([$div (V_C - V_"in")$], 1pt, 15pt)
$ (d t)/(R C) = (-d V) / (V_C - V_"in") $
#simpleMathNote([Take integral], 10pt, 10pt)
$ integral_0^(t) (d t)/(R C) = integral_0^(V_C) (-d V_C) / (V_C - V_"in") $
#simpleMathNote([Integrate], 10pt, 10pt)
$ t/(R C) = -ln(V_C - V_"in") - ln(-V_"in") $
#simpleMathNote([Combine logarithms], 10pt, 10pt)
$ t/(R C) = -ln((V_C - V_"in")/(-V_"in")) $
#mathNote([Combine ln], 10pt, 10pt)
$ -t/(R C) = ln((V_C - V_"in")/(-V_"in")) $
#mathNote([Combine ln], 10pt, 10pt)
$ e^(-t/(R C)) = (V_C - V_"in")/(-V_"in") $
#simpleMathNote([$dot (-V_"in")$], 10pt, 10pt)
$ -V_"in" dot e^(-t/(R C)) = V_C - V_"in" $
#mathNote([$dot (-1)$], 10pt, 10pt)
$ V_"in" - V_"in" dot e^(-t/(R C)) = V_C $
#simpleMathNote([Common factor of $V_"in"$], 10pt, 10pt)
$ V_"in" (1 - e^(-t/(R C))) = V_C $
#set block(spacing: 1.6em)

= Experiment

== Overview
An experiment as a method of finding electrical behavior is the costliest and most time consuming. If the appropriate component needs to be chosen from a large selection, than buying and testing them all is unrealistic.

Despite this shortcoming, an experiment is invaluable in that it will always provide the highest degree of accuracy to how a component will behave in the real world. Due to this, the results from this experiment will be the benchmark for the methods used in @sim and @math.

== Setup
A printed circuit board, designed for a RC circuit, was populated with a 1$"k"Omega$ resistor and a 22$mu"F"$ capacitor with a rated voltage of 6.3V. The circuit board was then held in place with exposed positive and negative wires. A power supply was set to 5V with no current limit and the negative side of the power supply and PCB were connected. A 10x oscilloscope probe with a ground spring was connected across the capacitor while another 10x probe was connected between the two power wires. The capacitor was discharged by shorting the two ends using metal tweezers. The positive side of the power supply was then put in contact with the resistor side of the PCB and a waveform was obtained. This setup is depicted in @experiment. More details on the PCB and osciloscope used can be found in @appA.

#figure(
  image("imgs/experiment-close.jpg"),
  caption: [Probing of MLCC using ground spring]
)<experiment>


== Results <Experiment-Results>

#let (Time-MSO, Trig, Out-MSO, VCC-MSO) = lq.load-txt(read("data/oscilloscope_analog.csv"))
#let x43 = lq.linspace(0,102).map(x => x/1000 +0.)

As expected, the voltage rises faster than an ideal 22$mu"F"$ capacitor. A comparison is shown in @exp1 between an ideal $22mu"F"$capacitor and the real capacitor.

#figure(
  block(
    lq.diagram(
      lq.plot(
        x43, x43.map(x => RCFormula(5, 1000, 0.000022, (x))),
        mark: none,
        label: [Ideal $22mu"F"$]
      ),
      lq.plot(
        Time-MSO, Out-MSO.map(x => (x - 0.15) * 1.031),
        mark: none,
        label: [Actual]
      ),
      xlabel: [Time (s)],
      ylabel: [$V_"out"$],
      legend: (position: bottom + right)
    ),
    inset: (right: 20pt, bottom: 4pt)
  ),
  caption: [Caption],
)<exp1>

Using this graph we are able to to try to find a capacitor of a lower value that is more accurate to the curve. Using as point on the curve, a capacitor that will have an equivalent amount of rise time to get to that point can be calculated using the RC formula. Here a point of (0.03669s, 4.511V) was chosen and the values of $t = 0.03669"s"$ and $V = 4.511"V"$ were substituted into the formula shown below.

$ 4.511"V" = 5V dot (1 - e^((-0.03669"s")/(1000Omega dot C))) $

Solving for $C$ yielded result of $C approx 16mu"F"$. The curve from this value of capacitor is plotted in @16u.

#figure(
  block(
    lq.diagram(
      lq.plot(
        x43, x43.map(x => RCFormula(5, 1000, 0.000016, (x))),
        mark: none,
        label: [Ideal $16mu"F"$]
      ),
      lq.plot(
        Time-MSO, Out-MSO.map(x => (x - 0.15) * 1.031),
        mark: none,
        label: [Actual]
      ),
      xlabel: [Time (s)],
      ylabel: [$V_"out"$],
      legend: (position: bottom + right)
    ),
    inset: (right: 20pt, bottom: 4pt)
  ),
  caption: [Caption]
)<16u>

The gap between the two curves shows that the original RC formula, even with an adjusted capacitance, is not sufficient for modelling DC Bias.

= Simulation <sim>

== Overview
The speed of modern computing has made simulation in a variety of situations useful. Due to the efficiency of processing repeated operations, computer software is perfect for circuit simulation. In this section, python, a modern programming language, will be used to simulate an ideal capacitor and then a capacitor with DC bias.

== Implementation<SimImplementation>
The charging of the capacitor can be broken into small time steps where each time step has value of $t_"step"$. This will act as a replacement to $d t$. Each $t_"step"$, the voltage across the capacitor, $V$, will increase by a calculated amount. Using this, a sequence of voltage values can be obtained, $ V_0, V_1, V_2,... , V_"# of steps"$. Each $V_n$ corresponds to a time of $t_"step" dot n$.

To find the change in voltage each time step, the equation $I = C (d V) / (d t)$ is manipulated to isolate the change in voltage. This yields $d V = I* (d t)/C$. Current is calculated using ohm's law to get $I = (V_"in"-V_n)/R$. Using these equations we get the following sequence.

$ V_0 = 0V $
$ V_(n+1) = V_n + (V_"in"-V_n)/R dot (t_"step")/C $<eqSequence>

All simulations will have a time domain of $0 <= t < 100"ms"$. Using the desired total number of time steps, $t_"step"$ can be calculated with $t_"step" = (100"ms")/"# of steps"$. This is implemented in python with $R = 1"k"Omega$, $C = 22mu"F"$, and $V_"in" = 5V$. Code can be found in @appA. @sim1 shows the number of steps as 5, 10, 20, and 50.

#let (sim5T, sim5V) = lq.load-txt(read("data/sim-5.csv"))
#let (sim10T, sim10V) = lq.load-txt(read("data/sim-10.csv"))
#let (sim20T, sim20V) = lq.load-txt(read("data/sim-20.csv"))
#let (sim50T, sim50V) = lq.load-txt(read("data/sim-50.csv"))

#figure(
  block(
    lq.diagram(
      lq.plot(
        sim5T, sim5V,
        mark: none,
        label: [5]
      ),
      lq.plot(
        sim10T, sim10V,
        mark: none,
        label: [10]
      ),
      lq.plot(
        sim20T, sim20V,
        mark: none,
        label: [20]
      ),
      lq.plot(
        sim50T, sim50V,
        mark: none,
        label: [50]
      ),
      cycle: lq.color.map.tofino,
      xlabel: [Time (s)],
      ylabel: [$V$],
      legend: (position: bottom + right)
    ),
    inset: (right: 20pt, bottom: 4pt)
  ),
  caption: [Simulations with increasing number of time steps and decreasing $t_"step"$]
)<sim1>

By using this method, the capacitance can easily be changed to be any arbitrary function with time or voltage as the argument. In this case, the capacitance becomes a function of voltage. The new sequence is shown below.

$ V_0 = 0V $
$ V_(n+1) = V_n + (V_"in"-V_n)/R dot (t_"step")/C(V_n) $

Using the DC Bias curve from the manufacturer, the same from @C, we can use a linear function to approximate the capacitance based on voltage. The approximation chosen was
$ C(V) = 22mu"F" - (2.33mu"F" dot V) $<eqApprox>
This approximation is shown in @approx compared to the manufacturer.

#figure(
  block(
    lq.diagram(
      lq.plot(
        (0,6), (22, 6),
        mark: none,
        label: [Approximation],
        z-index: 3
      ),
      lq.plot(
        V, C.map(x => x* 10.0),
        mark: none,
        label: [Manufacturer]
      ),
      xlabel: [DC Bias (V)],
      ylabel: [Capacitance ($mu"F"$)]
    ),
    inset: (right: 20pt, bottom: 4pt)
  ),
  caption: [Linear approximation of DC bias]
)<approx>

Using this approximation, the sequence becomes

$ V_0 = 0V $
$ V_(n+1) = V_n + (V_"in"-V_n)/R dot (t_"step")/(22mu"F" - 2.33mu"F" dot V_n) $

== Results


#let (simT, simV) = lq.load-txt(read("data/sim.csv"))
#figure(
  block(
    lq.diagram(
      lq.plot(
        simT, simV,
        mark: none,
        label: [Simulation]
      ),
      lq.plot(
        Time-MSO, Out-MSO.map(x => (x - 0.15) * 1.031),
        mark: none,
        label: [Actual]
      ),   
      xlabel: [Time (s)],
      ylabel: [$V_C$],
      legend: (position: bottom + right)
    ),
    inset: (right: 20pt, bottom: 4pt)
  ),
  caption: [Simulation versus actual]
)<sim2>

Using this approximation, a simulation is run using 200 time steps across a 100ms period, $t_"step" = 500mu s$. The curve obtained is compared with the actual curve in @sim2.

This appears to be much closer to the actual capacitor than what would be predicted for a 22$mu"F"$ capacitor.

= Deriving New Formula <math>

== Overview
In this section we will attempt to derive a formula for the same method used in the second part of the previous section
== Derivation
In @SimImplementation, the approximation $C(V) = 22mu"F" - (2.33mu"F" dot V)$ was used. We will continue to use a linear approximation but transfer to an equation form with arbitrary values. $22mu"F"$ and and $-2.3mu"F"$ are replaced with with $C_1$ and $C_2$ respectively. Thus the new formula is $C(V) = C_1 - C_2 dot V$. This formula replaces the constant $C$.

$ V_C = V_"in" - R (C_1 - C_2 dot V_C) (d V_C) / (d t) $

Using the derivation shown in @appB the following formula is found.

$ V_"in" (1-e^((C_2 V_C - t/R)/(C_1 - C_2 V_"in"))) = V_C $

Due to the output voltage being both inside and outside the exponent it is difficult to isolate $V_C$, though time can be found based on time. This is out of the scope of this paper. The formula where time is isolated is shown below.

$ t =   R C_2 V_c - (R) (C_1 - C_2 V_"in")(ln((V_"in" - V_C)/V_"in")) $

This formula is conveniet for getting a time at a specified voltage, which relates to the enable pin as referenced in @C. We can generate a series of value 0, 1, 2, 3, .., 99. eachvalue is divided by 20 to get 0, 0.05, 0.1, 0.15 ..., 4.95.
== Results

#let vDeriv = (0.1, 1.0 ,2.0 ,3.0 ,4.0, 4.5 ,4.9, 4.99)
#let vRange = lq.linspace(0, 199).map(x => x/40)
#let vDeriv = vRange
#figure(
  block(
    lq.diagram(
      lq.plot(
        Time-MSO, Out-MSO.map(x => (x - 0.15) * 1.031),
        mark: none,
        label: [Actual]
      ),
      lq.plot(
        x43, x43.map(x => (RCFormula(5, 1000, 0.000022, x))),
        mark: none,
        label: [RC Formula],
        z-index: 1
      ),
      lq.plot(
        vDeriv.map(x => (modifiedRCFormula(x, 5, 1000, 0.000022, 0.00000233))), vDeriv,
        mark: none,
        label: [New formula],
        z-index: 1
      ),
      xlabel: [Time (s)],
      ylabel: [$V_"out"$],
      legend: (position: bottom + right)
    ),
    inset: (right: 20pt, bottom: 4pt)
  ),
  caption: [Caption]
)

The result of this formula is plotted. As expected, the results of using this formula are functionally identical to the simulation.


= Generalization

Up to this point, only one value of capacitor has been analyzed, but the aim of this paper is to be able to accurately predict the behavior of any MLCC capacitor. To do this, the values of $C_1$ and $C_2$ in equation something must be able to be generated based on characteristics of a capacitor. The two main factors influencing multi-layer ceramic capaicitors are there size and and their classification.

Compare capacitance vs. voltage of different types of capacitors (x5r, x7r, 0805, 0603)

Try to find a general formula that can fit the DC bias curves.


= Comparison of Methods
The Simulation and derivation are likely very similar in results. They appear based on the experiment to better than a constant capacitance at either end ($V_"max"$ or 0V)


= Conclusion
How this could be useful in my life and elsewhere

Why it might not be accurate (This focused on bulk capacitors which might not be as common for enable pins due to size, Model might not be accurate because capacitance might not immediately change with dc applied across the capacitor (maybe experiment with this with different resistor values and see if C from RC stays the same))

Something else?




#pagebreak()

#set page(columns: 1)
#show: appendix

= Experimental Setup and Code <appA>

#counter(figure.where(kind: image)).update(0)

#figure(
  image("imgs/experiment-far.jpg"),
  caption: [Probing setup]
)<probing>

A Saleae Logic MSO oscilloscope was used in combination with a PCBite probe and Saleae probe. Alligator clips from a power supply were used.
#v(1em)
#figure(
  image("imgs/PCB.png"),
  caption: [PCB layout]
)

#let (Time-MSO, Trig, Out, VCC-MSO) = lq.load-txt(read("data/oscilloscope_analog.csv"))
#lq.diagram(
  lq.plot(
    Time-MSO, VCC-MSO,
    mark: none
  ),
  xlabel: [Time (s)],
  ylabel: [$V_"in"$],
  title: [$V_"in"$ over first 100ms],
  width: 450pt,
  legend: (position: bottom + right)
)

#v(1.5em)

#let (Time-MSO-VCC, Trig, VCC) = lq.load-txt(read("data/oscilloscope_analog-VCC_analog.csv"))
#lq.diagram(
  lq.plot(
    Time-MSO-VCC, VCC,
    mark: none,
  ),
  xlabel: [Time (s)],
  ylabel: [$V_"in"$],
  title: [$V_"in"$ over first 500$mu$s],
  width: 450pt,
  legend: (position: bottom + right)
)
#pagebreak()
#sourcefile(read("sim.py"), lang: "py")
This python script was used to generate data for all five simulation results shown in @sim @sim1 and @sim2. The variable #emph([C]) in line 34 was changed to #emph[C_bias] to account for DC bias.

#pagebreak()
= Derivations <appB>


#let eqColor1 = yellow
#let eqColor2 = blue.lighten(30%)
#let eqColor3 = green
#let eqColor4 = purple.lighten(30%)
#let eqColor5 = purple.lighten(60%)
#let eqColor6 = purple.lighten(10%)

#set block(spacing: 0.0em)

#showybox(
  title: [Deriving Modified RC Formula],
  title-style: (color: black),
  frame: (
    title-color: black.transparentize(95%),
    radius: (bottom-right: 0pt, rest: 10pt)
  )
)[
  #set block(spacing: 1.5em)
  $ (- d t) / (R (C_1-C_2 dot V_C)) = (d V)/ (V_C - V_"in") $
  $ (- d t) / (R ) = ((C_1-C_2 V_C) dot (d V))/ (V_C - V_"in") $
  $ colorFormula(integral_0^t (- d t) / (R ), #yellow) = colorFormula(integral_0^V_C ((C_1-C_2 V_C) dot (d V))/ (V_C - V_"in"), #blue) $
]

#showybox(
  title: [], width: 95%,
  align: right,
  title-style: (color: black),
  frame: (
    title-color: eqColor1,
    radius: (rest: 0pt)
  )
)[
  #set block(spacing: 1.5em)
  $ integral_0^t ((- d t) / (R)) $
  $ bold(- t / R) $
]

#showybox(
  title: [],
  width: 95%,
  align: right,
  title-style: (color: black),
  frame: (
    title-color: eqColor2,
    radius: (bottom-left: 10pt, rest: 0pt)
  )
)[
  #set block(spacing: 1.5em)
  $ integral_0^V_c (C_1-C_2 V_C)/ (V_C - V_"in") d V $
  $ integral_0^V_c C_1/ (V_C - V_"in") + (-C_2 V_C)/ (V_C - V_"in") d V $
  $ colorFormula(integral_0^V_c C_1/ (V_C - V_"in") d V, #green) + colorFormula(integral_0^V_c (-C_2 V_C)/ (V_C - V_"in") d V, #purple) $
]

#showybox(
  title: [],
  width: 90%,
  align: right,
  title-style: (color: black),
  frame: (
    title-color: eqColor3,
    radius: ( rest: 0pt)
  )
)[
  #set block(spacing: 1.5em)
  $ integral_0^V_c C_1/ (V_C - V_"in") d V $
  $ C_1 ln(|V_C - V_"in"|) - C_1 ln(|- V_"in"|) $
  $ bold(C_1 ln(V_"in" - V_C) - C_1 ln(V_"in")) $
]

#showybox(
  title: [],
  width: 90%,
  align: right,
  title-style: (color: black),
  frame: (
    title-color: eqColor4,
    radius: (bottom-left: 10pt, rest: 0pt)
  )
)[
  #set block(spacing: 1.5em)
  $ integral_0^V_c (-C_2 V_C)/ (V_C - V_"in") d V $
  $ -C_2 integral_0^V_c V_C/ (V_C - V_"in") d V $
  $ -C_2 integral_0^V_c (V_C - V_"in")/ (V_C - V_"in") + V_"in"/ (V_C - V_"in") d V $
  $ -C_2 integral_0^V_c 1 + V_"in"/ (V_C - V_"in") d V $
  $ colorFormula(-C_2 integral_0^V_c 1 d V, #eqColor5) + colorFormula(-C_2 integral_0^V_c V_"in"/ (V_C - V_"in") d V, #eqColor6) $
]

#showybox(
  title: [],
  width: 85%,
  align: right,
  title-style: (color: black),
  frame: (
    title-color: eqColor5,
    radius: (rest: 0pt)
  )
)[
  #set block(spacing: 1.5em)
  $ -C_2 integral_0^V_c 1 d V $
  $ bold(-C_2 V_c) $
]

#showybox(
  title: [],
  width: 85%,
  align: right,
  title-style: (color: black),
  frame: (
    title-color: eqColor6,
    radius: (bottom-left: 10pt, bottom-right: 10pt, rest: 0pt)
  )
)[
  #set block(spacing: 1.5em)
  $ -C_2 integral_0^V_c V_"in"/ (V_C - V_"in") d V $
  $ -C_2 V_"in" integral_0^V_c 1 / (V_C - V_"in") d V $
  $ -C_2 V_"in" ln(|V_C - V_"in"|) + C_2 V_"in" ln(|- V_"in"|) $
  $ bold(-C_2 V_"in" ln(V_"in" - V_C) + C_2 V_"in" ln(V_"in")) $
]

#showybox(
  title: [Combining results],
  title-style: (color: black),
  frame: (
    title-color: black.transparentize(95%),
    radius: (bottom-right: 0pt, bottom-left: 0pt, rest: 10pt)
  )
)[
  #set block(spacing: 1.5em)
$ (- t) / R = C_1 ln(V_"in" - V_C) - C_1 ln(V_"in") -C_2 V_"in" ln(V_"in" - V_C) + C_2 V_"in" ln(V_"in") - C_2 V_c $
$ (- t) / R = ln(V_"in" - V_C) (C_1 - C_2 V_"in") - ln(V_"in") (-C_1 + C_2 V_"in") - C_2 V_c $
$ (- t) / R = ln(V_"in" - V_C) (C_1 - C_2 V_"in") + ln(V_"in") (C_1 - C_2 V_"in") - C_2 V_c $
$ (- t) / R =  (C_1 - C_2 V_"in") (ln(V_"in" - V_C) + ln(V_"in")) - C_2 V_c $
$ (- t) / R =  (C_1 - C_2 V_"in") (ln((V_"in" - V_C)/V_"in")) - C_2 V_c $
]

#showybox(
  title: [Isolating $t$],
  title-style: (color: black),
  frame: (
    title-color: black.transparentize(95%),
    radius: 0pt
  )
)[
  #set block(spacing: 1.5em)
  $ (- t) / R =  (C_1 - C_2 V_"in") (ln((V_"in" - V_C)/V_"in")) - C_2 V_c $
  $ -t =   - R C_2 V_c + (R) (C_1 - C_2 V_"in") (ln((V_"in" - V_C)/V_"in")) $
  $ t =   R C_2 V_c - (R) (C_1 - C_2 V_"in") (ln((V_"in" - V_C)/V_"in")) $
]


#showybox(
  title: [Isolating $V_C$],
  title-style: (color: black),
  frame: (
    title-color: black.transparentize(95%),
    radius: (bottom-right: 10pt, bottom-left: 10pt, rest: 1pt)
  )
)[
  #set block(spacing: 1.5em)
  $ (- t) / R +  C_2 V_c = (C_1 - C_2 V_"in") (ln((V_"in" - V_C)/V_"in")) $
  $ ((- t) / R +  C_2 V_c)/(C_1 - C_2 V_"in") =   ln((V_"in" - V_C)/V_"in") $
  $ e^(((- t) / R +  C_2 V_c)/(C_1 - C_2 V_"in")) =   (V_"in" - V_C)/V_"in" $
  $ V_"in"e^(((- t) / R +  C_2 V_c)/(C_1 - C_2 V_"in")) =   V_"in" - V_C $
  $ V_"in"e^(((- t) / R +  C_2 V_c)/(C_1 - C_2 V_"in")) - V_"in" = - V_C $
  $ -V_"in"e^(((- t) / R +  C_2 V_c)/(C_1 - C_2 V_"in")) + V_"in" = V_C $
  $ V_"in" (1 - e^(((- t) / R +  C_2 V_c)/(C_1 - C_2 V_"in"))) = V_C $
]