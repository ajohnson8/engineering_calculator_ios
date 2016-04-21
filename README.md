# Electric Distribution Engineering Calculator IOS

##Overview
The Engineering Calculator application simplifies complex electrical engineering calculations
for easy access to field employees. This application improves field employee’s efficiency
by providing faster, error free calculations, improvement in field troubleshooting, and better
response to customer inquiries. This application was developed as part of the [APPA DEED Program.](http://www.publicpower.org/Programs/Landing.cfm?ItemNumber=31245&navItemNumber=37529)

##Technical Information
The Engineering Calculator application contains six different formulas.  When the application first loads
the user is presented with the Subdivision Load Calculator.  If the user is in landscape mode the list of
formulas appears on the left.  In portrait, the formula list is hidden and the user must swipe from the left
edge of the screen to the center of the calculator for the formulas to appear on the left.  For all of the formulas
there is an info button, configure button, clear button and default button.  The editable values will be in the fields
that are outlined in a box.  The results of the formula will be in the white box on the right.  

The user is able to edit the values in the formula and also save the values as defaults for the formula.
The user is able to load the defaults from the default button on the formula screen.  
When the configuration button is pressed, the formula is now editable and saves the updated defaults
to the formula.  The user can change the formula list logo by clicking on the logo image.  The logo will be
included in an email that can be shared with the information about the result of the formula in the white box. 

The application contains the following six formulas; each is outlined in detail below:

1. Subdivision Load
2. Branch Circuit Drop
3. Fuse Wizard
4. Main Service Voltage Drop
5. Transformer Load
6. Transformer Rating

### Subdivision Load
Subdivision Load calculates the available full load amps on a phase conductor.  
Select the quantity of the appropriate size transformer kVA sizes and the total 
full load amps will be calculated. To add or modify the Transformer Sizes, Volt Amps, or 
Volts select the “Configure” button.  To negate the modifications, select the “Default” button. 
To share the results, select the “E-mail” button.

### Branch Circuit Drop
Branch Circuit Voltage Drop calculates the resistance of run, voltage drop, percentage of voltage drop, 
and resultant voltage by selecting a copper conductor wire size, plus entering the length of conductor, full 
load current, and then selecting the circuit voltage of either 120 or 240 volts.  It also lists the NEC rated 
ampacity of the selected conductor with derating factors.  Select the appropriate conductor size from the Wire Size 
table. Enter the one-way total length of the conductor in feet. Enter the actual or estimated full load circuit current. 
Select the circuit voltage of either 120 or 240 volts.  The voltage drop in volts and percentage of voltage drop will be 
calculated.  The NEC ampacity and derating amperages will be given.  To modify the Wire Size constants, select the “Configure”
button.  To negate the modifications, select the “Default” button.  To share the results, select the “email” button.

### Fuse Wizard
Fuse Wizard identifies the company standard fusing per phase utilizing the selected variables from the table.  Select the
appropriate tab at the top for the construction type.  For underground construction and pad-mounted transformers, select the
“UG” tab.  For overhead construction and overhead transformers, select the “OH” tab.  For underground subdivisions, select the
“SUBD” tab. Select the kVA rating for a transformer or total connected kVA on a lateral tap using the table for “UG” or “OH”, or
select the total connected (all transformers) kVA for a phase in an underground subdivision.  The appropriate fuse sizes will be
given for the condition selected.  To modify the default kVA sizes and fuses, select the “Configure” button.  To negate the 
modifications, select the “Default” button.  To share the results, select the “email” button.

### Main Service Voltage Drop
Main Service Voltage Drop calculates the voltage drop and percentage of voltage drop by selecting aluminum or copper conductor, 
the phasing and wire size, plus entering the length of conductor, full load current, and circuit voltage.  Select the conductor 
type, “Copper” or “Aluminum”. Select a single “Phase 1” or three phase “Phase 3” circuit from the phase table. Select the appropriate
conductor size from the Wire Size table. Enter the one-way total length of the conductor in feet. Enter the actual or estimated full 
load circuit current. Enter the circuit voltage. The voltage drop in volts and percentage of voltage drop will be calculated.  To 
modify the Wire Size constants, select the “Configure” button.  To negate the modifications, select the “Default” button.  To share 
the results, select the “email” button.

### Transformer Load
Transformer Load calculates the available full load amps and fault current on the primary and secondary sides of a transformer by 
entering the nameplate data.  Select whether the transformer is a single or three phase  unit.  “Phase (1 or 3)” Select the secondary
voltage rating on the transformer.  “SEC. L-L VOLTS” Enter the transformer nameplate size in kVA. Enter the transformer nameplate % 
impedance value.  Full load amps and available fault current on the primary and secondary of transformer will be calculated.  To modify
the Phase Value constants, Phase Voltages, or Secondary Voltages select the “Configure” button.  To negate the modifications select the
“Default” button.  To share the results select the “email” button.

### Transformer Rating
Transformer Rating calculates the available full load amps and fault current on the primary and secondary sides of a transformer 
by entering kVA, phase-to-phase primary voltage and phase-to-phase secondary voltage.  It also estimates appropriate fuse and breaker
amperages.  Enter the transformer full load rating in kVA. Enter the phase-to-phase primary voltage. Enter the phase-to-phase secondary
voltage.  Full load amps and available fault current on the primary and secondary of transformer will be calculated, along with 
maximum (300%) protective primary fuse, minimum (125%) primary protective fuse, and maximum secondary breaker (125%) size.  
To modify the Impedance Table kVA sizes and Impedances, select the “Configure” button.  To negate the modifications, select the 
“Default” button.  To share the results, select the “email” button.

## Contributors
[Aaron Johnson](https://www.linkedin.com/in/aaron-johnson-30087469), [Kelly Mayo](), [John Worrell](), [Paul Marney](), [Krystle Small](http://linkedin.com/in/krystle-small-94794385), [John Little](https://www.linkedin.com/in/johnclittle), and others.

## License
The MIT License (MIT)

Copyright (c) 2016 ajohnson8

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

