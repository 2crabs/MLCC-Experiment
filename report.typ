//IMPORTS
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/codelst:2.0.2": sourcecode, sourcefile


#let note(body) = {
  set text(red)
  set text(font: "Arial", size: 10pt)
  [#body]
}

#let note(body) = {}

#let mathStuff(number) = {
  for value in range(1,number) {
    [Math ]
  }
}

#let RCFormula(v, r, c, t) = (
  v*(1-(calc.pow(2.71828, ((-t)/(r*c)))))
)

//TITLE PAGE
#show title: set align(center + horizon)
#show title: set pad(y: 16pt)
#show title: set text(font: "TeX Gyre Bonum", weight: "thin", size: 30pt)



#title()[Effect of DC Bias on Effective Capacitance of MLCCs #note([Version with notes])]
#v(5pt)
#align(center, text(font: "TeX Gyre Bonum")[M. Fraser])
#align(center, text(font: "TeX Gyre Bonum")[*Rough Draft*])
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

Opening up any modern computer will reveal hundreds of electrical components, ranging from the miniscule resistors to large chips with hundreds of electrical contacts. Among these one shows up on nearly every circuit board. A multi-layer ceramic capacitor or MLCC is used in just about every circuit produced today. Both in precise high speed applications, such as on a CPU, and high power designs, like a DC-DC converter, they have a wide range of uses. Through their combination of ease of use in assembly, low cost, and small size, MLCCs have become an indispensable tool in circuit design.

#figure(
  image("imgs/mlcc_0.png"),
  caption: "MLCCs come in many shapes and sizes, with some as small as a grain of sand"
)<sizes>

Despite being mainly used in mass production of consumer products, MLCCs are simultaneously used in hobbyist designs. While nearly always coming in Surface Mount packages, though hole packages exist as shown in @sizes, making them easy to solder by hand. And while other types of capacitors exist, they do not offer the same characteristics. #note([This paragraph either needs to be removed or fleshed out])

These simple electronic components can be modelled mathematically, but the real-world impacts how they function. 

== Voltage, Current, and Resistance <VIR>
To understand their function and why they are universally used, it is important to first understand the basic theory of how electricity flows. Voltage, a potential difference, causes current, the flow of electrons, through a conductor. 

#figure(
  image("imgs/ohms-law.jpg"),
  caption: "A popular cartoon representing voltage and amperage"
)<ohms>

When a voltage difference, such as from a battery, is applied across a conductor, current is allowed to flow unrestricted through that conductor. This is known as a short circuit. The amount of current flowing can be limited by using a resistor. A resistor is a component where the current flowing is directly proportional to the amount of voltage across the resistor. This relationship is shown in the following equation where $V="voltage"$ (measured in volts), $I= "current"$ (measured in Amps), and $R= "Resistance"$ (measured in ohms).

$ V = I dot R $

This relationship is known as Ohm's Law. As an example, if a 5V battery is connected to a 100#sym.Omega resistor, the current can be found.

$ V = I dot R $
$ 5V = I dot 100 Omega $
$ (5V)/(100 Omega) = I $
$ 0.02A = I $

As seen above knowing any two variables of this equation allows solving for the third. The equation can be manipulated to solve for Resistance, $R = I/V$, or current, $I = V/R$.

== Model of Capacitor <C>
A capacitor is a device where the current flowing through is proportional to the rate of change of voltage. That is,  $I = C (d v)/(d t)$ where $C$ is the capacitance in Farads. When a capacitor is connected to a current source the voltage across the capacitor will increase at a constant rate.

This models an ideal capacitor, but real capacitors and especially MLCCs face non-idealities which change this model. One of the most important, yet often overlooked, ones in MLCCs is DC-bias. DC-bias causes the capacitance, $C$, of a capacitor to be reduced as a voltage is applied across the capacitor. This introduces a new curve, which is the capacitance versus voltage curve. Manufacturers of capacitors will provide this graph. An example of the DC Bias graph of standard capacitor is shown in .

These curves have a domain of $0<V<v_max$ due to maximum ratings and capacitors not having directionality.

#let (V, C) = lq.load-txt(read("data/GRM21BR60J226ME39.csv"))
#let C = C.map(x => if x > 5.0 { x /10.0} else {x})

#figure(
  block(
    lq.diagram(
      lq.plot(
        V, C.map(x => x* 10.0),
        mark: none
      ),
      lq.plot(
        (0,6), (22, 6),
        mark: none
      ),
      xlabel: [DC Bias (V)],
      ylabel: [Capacitance ($mu"F"$)]
    ),
    inset: (right: 20pt)
  ),
  caption: [DC Bias of GRM21BR60J226ME39L]
)

We will use a 22uF cap from Murata#footnote[Part number GRM21BR60J226ME39L]
== Research Question

The effect of DC Bias is mainly used in AC analysis applications, such as for a bypass capacitor, but is important when a device is first turned on, and a MLCC goes from 0V to $V_"on"$. Often components will have an enable pin that will only allow the device to turn on when the voltage reachess a certain threshold. Meeting rigid timing requirements neccesitates knowing how quickly the voltage across a capacitor will rise. This this paper will attempt to find *the effect DC Bias has on the effective capacitance of a MLCC during device turn on.*



= RC Formula <RC>

== Applications <RCapp>
Creating the constant current source in @C for a capacitor can be difficult, so instead a resistor, as mentioned in @VIR, can be used to limit voltage increasing across a capacitor. Resistors, similar to capacitors, are relatively cheap and come in small package sizes. Combining these two components creates a circuit often referred to as an RC Circuit.

#figure(
  image("imgs/placeholder.jpg"),
  caption: [Schematic of RC Circuit]
)<RCcircuit>

This circuit is often used to limit noise in a system in order to prevent unexpected behvavior. Additionally it can be used to slow down the rise time of voltage across a capacitor. This is the application that will be exmained here.

By mathmatically modelling this circuit the below equations are generated.

$ V_R + V_C = V_"on  "arrow"  " V_C = V_"on" - V_R $

$ V_"out" = V_C = V_"on" - V_R $

Substituting in the formula from @VIR for $V_R$ we get:

$ V_"out" =  V_"on" - I R $

And finally using the equation for a capacitor from @C to replace $I$:

$ V_"out" = V_"on" - R C (d V) / (d t) $

This formula currently isn't very helpful because we are not able to input a time to get the output voltage, but it can be turned into the popular RC Formula as shown below.

$ V_"out" (t) = V_"on" dot (1 - e^((-t)/(R C))) $

This allows us to get the output voltage with a specific time.


== Derivation <RCderiv>
The formula in @RCapp can be derived using the following process.

#mathStuff(300)

= Experiment

== Advantages
An experiment allows the greatest degree of accuracy in determing the behavior of a capacitor in the real-world but is also the costliest and most time consuming.

== Set Up
== Results

#let (Time-MSO, Trig, Out-MSO, VCC-MSO) = lq.load-txt(read("data/oscilloscope_analog.csv"))
#let x43 = lq.linspace(0,102).map(x => x/1000 +0.)

As expected when the voltage rises faster than expected. A comparison is shown in figuree asdasd between an ideal capacitor and the real capacitor.

#block(
  lq.diagram(
    lq.plot(
      x43, x43.map(x => RCFormula(5, 1000, 0.000022, (x))),
      mark: none,
      label: [Ideal]
    ),
     lq.plot(
      Time-MSO, Out-MSO.map(x => (x - 0.15) * 1.031),
      mark: none,
      label: [Actual]
    ),
    xlabel: [Time (ms)],
    ylabel: [$V_"out"$],
    legend: (position: bottom + right)
  )
)

= Simulation

== Advantages
Modern software allows us to simulate these environments. Compared to assembling the actual circuit this can reduce cost and increase speed in developing prototypes. The software used for simulation of circuits is Simulation Program with Integrated Circuit Emphasis. Many options exist for SPICE, but LTspice#sym.trademark.registered from Analog Devices will be used here.


#let (simT, simV) = lq.load-txt(read("sim.csv"))
#block(
  lq.diagram(
    lq.plot(
      simT, simV,
      mark: none,
      label: [Ideal]
    ),
    lq.plot(
      Time-MSO, Out-MSO.map(x => (x - 0.15) * 1.031),
      mark: none,
      label: [Ideal]
    ),
    xlabel: [Time (ms)],
    ylabel: [$V_"out"$],
    legend: (position: bottom + right)
  )
)

== Schematic

== Modeling DC Bias

== Results

Additional waveforms can be found in @appA


= Deriving New Formula

== Derivation

== Results
Plot of graph using above derived formula
Figuring out a formula for capacitance vs voltage (probably linear)

Substitute this formula into the Starting formula

= Comparison of Methods
Graphs

Short paragraph and analysis

= Generalization
Compare capacitance vs. voltage of different types of capacitors (x5r, x7r, 0805, 0603)

Try to find a general formula that can fit this curve

Do five again but with a generalized formula

Compare to LTSPice and Experimental results


= Conclusion
How this could be useful in my life and elsewhere

Why it might not be accurate (This focused on bulk capacitors which might not be as common for enable pins due to size, Model might not be accurate because capacitance might not immediately change with dc applied across the capacitor (maybe experiment with this with different resistor values and see if C from RC stays the same))

Something else?




#pagebreak()

#set page(columns: 1)
#show: appendix

= Waveforms  <appA>
#let (Time-MSO, Trig, Out-MSO, VCC-MSO) = lq.load-txt(read("data/oscilloscope_analog.csv"))
#lq.diagram(
  lq.plot(
    Time-MSO, VCC-MSO,
    mark: none,
    label: [Ideal]
  ),
  xlabel: [Time (ms)],
  ylabel: [$V_"out"$],
  width: 450pt,
  legend: (position: bottom + right)
)

#lq.diagram(
  lq.plot(
    Time-MSO.slice(), VCC-MSO,
    mark: none,
    label: [Ideal]
  ),
  xlabel: [Time (ms)],
  ylabel: [$V_"out"$],
  width: 450pt,
  legend: (position: bottom + right)
)

= Code <appB>

#let code = "```typ" +raw("sim.py") + "```"

#sourcefile(read("sim.py"), lang: "py")