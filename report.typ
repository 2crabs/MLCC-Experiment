//IMPORTS
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/wordometer:0.1.5": word-count, total-words
//#show: lq.theme.ocean


#let note(body) = {
  set text(red)
  set text(font: "Arial", size: 10pt)
  [#body]
}

//#let note(body) = {}


//TITLE PAGE
#show title: set align(center + horizon)
#show title: set pad(y: 16pt)
#show title: set text(font: "TeX Gyre Bonum", weight: "thin", size: 30pt)



#title()[Effect of DC-bias on Effective Capacitance of MLCCs #note([Version with notes])]
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

Opening up any modern computer will reveal hundreds of electrical components, ranging from the miniscule resistors to large chips with hundreds of electrical contacts. Among these one shows up on nearly every circuit board. The small tan chip with metal on both ends, a multi-layer ceramic capacitor or MLCC is used in just about every circuit produced today. Both in precise high speed applications, such as on a CPU, and high power designs, like a DC-DC converter, they have a wide range of uses. Through their combination of ease of use in assembly, low cost, and small size, MLCCs have become an indispensable tool in circuit design.

#figure(
  image("imgs/mlcc_0.png"),
  caption: "MLCCs come in many shapes and sizes, with some as small as a grain of sand"
)<sizes>

Despite being mainly used in mass production of consumer products, MLCCs are simultaneously used in hobbyist designs. While nearly always coming in Surface Mount packages, though hole packages exist as shown in @sizes, making them easy to solder by hand. And while other types of capacitors exist, they do not offer the same characteristics.

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
A capacitor is a device where the current flowing through is proportional to the change in voltage. That is,  $I = C (d v)/(d t)$ where $C$ is the capacitance in Farads. When a capacitor is connected to a current source the voltage across the resistor will increase at a constant rate.

This models an ideal capacitor, but real capacitors and especially MLCCs face non-idealities which change this model. One of the most important, yet often overlooked, ones in MLCCs is DC-bias. DC-bias means that the capacitance ( c ) of a capacitor will be reduced as a voltage is applied across the capacitor. This introduces a new curve, which is the capacitance versus voltage curve. For example if a capacitor has the following graph for this (6uF < 2.5v and 3uF). Of course this actual curve is much more complex and manufacturers of capacitors provide it. An example of a standard capacitor is shown in ?. These curves have a domain of 0 < c < v_max. This effect is crucial in understanding how MLCC capacitors react to changes in voltage.

Specifically this paper will examine how this curve will affect the effective capacitance of an MLCC during large voltage changes such as turn on. (0v -> 5v)

Personal connection. 





= RC Formula <RC>

in @VIR
Circuit Diagram of RC circuit

Applications of RC circuit

Mathematical model

Why it's important to transform to be based on time

Deriving formula


= LTspice
Write a little about what SPICE is and how it is used for circuit analysis in both transients and ac analysis

Model of ideal capacitor

Model of capacitor with dc-bias

Modern software allows us to simulate these environments. Compared to assembling the actual circuit this can reduce cost and increase speed in developing prototypes. 
The software that allows for simulation of circuits is Simulation Program with Integrated Circuit Emphasis.

= Experiment
Explain limitations of physical experiment (cost and time, the aim the IA is to avoid doing this)

How experiment was set-up


= Deriving Formula
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

#show: appendix

= Experimental setup  <appA>
= Photos <appB>