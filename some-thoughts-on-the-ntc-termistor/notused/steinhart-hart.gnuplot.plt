# script for plotting calibration curve for thermistor
#	(temperature vs. resistance)
# and fitting various models

# This version modified Mon Dec 24 10:49:31 PST 2012 Kevin Karplus

# B-equation used in many thermistor specifications
# Temperature in degrees Kelvin as function of resistance in ohms

# First, given a resistance R0 at a temperature T0:
T_B_R0(R,T0,R0,B) = 1./(1/T0 + log(R/R0)/B)

# Second, given the equivalent resistance at infinite temperature
T_B_Rinf(R,Rinf,B) = B/log(R/Rinf)

# Steinhart-Hart model (3 parameters)
# Temperature in degrees Kelvin as function of resistance in ohms
T_stein(R,A,B,C) = 1./(A+B*log(R)+C*log(R)**3)

# Note that the T_stein equation can be used to model the 2-parameter
# equations, by setting the parameters appropriately:
#  T_B_Rinf(R,Rinf,B) = T_stein(R,-log(Rinf)/B,1./B, 0)
#  T_B_R0(R,T0,R0,B) = T_stein(1./T0-log(R0)/B, 1./B, 0)

# specifications for Vishay BC Components NTCLE413E2103F520L thermistor
# in terms suitable for T_B_R0 (as given on spec sheet)
T_25 = 273.15 + 25
R_25=10000.
B25_85=3435.

# From here on in the file, we'll use only the T_stein equation,
#	and not the two-parameter B equation, so B should be interpreted
#	as in the Steinhart-Hart equation.

# specifications converted to T_stein equation
C_spec = 0.
B_spec = 1./B25_85
A_spec = 1/(25.+273.15) - B_spec*log(R_25)

# Conversions between Fahrenheit and Kelvin scales
# Note: if measurements are recorded in Celsius, rather than Fahrenheit,
#	then these conversions are not right, and should be changed
#	appropriately.
K(F) = (F-32)*5./9.+273.15
F(K) = (K-273.15)*1.8+32

# Set up title and axis labels
set title "calibration for Vishay BC Components NTCLE413E2103F520L thermistor"
set xlabel "resistance in kohms"
set ylabel "temperature in degrees Fahrenheit"

# remove any stray labels that may be left from previous "set label commands"
#	If you reload this script file repeatedly, then labels can
#	accumulate unless you clear them.
unset label

# print the specification on the plot
set label sprintf("spec R_ohms = %.3g * exp(%.0f / T_in_Kelvin)",exp(-A_spec/B_spec),1/B_spec) at 3,180
set label sprintf("T_in_Kelvin = 1/(%.3g + %.3g ln(R_ohms))",A_spec,B_spec) at 3,170


# set the ranges for fitting the data (can be used to censor some outliers)
set xrange[*:*]
set yrange[*:*]

# fit a two-parameter model
A0=A_spec
B0=B_spec
fit F(T_stein(x,A0,B0,0)) 'therm_data2.txt' using (1000.*$2):1 via A0,B0

# print the two-paramter model on the plot
set label sprintf("fit R_ohms = %.3g * exp(%.0f / T_in_Kelvin)",exp(-A0/B0),1/B0) at 4.5,155
set label sprintf("T_in_Kelvin = 1/(%.3g + %.3g ln(R_ohms))",A0,B0) at 4.5,145

# fit the three-parameter Steinhart-Hart model
A=A0
B=B0
C=1e-6
fit F(T_stein(x,A,B,C)) 'therm_data2.txt' using (1000.*$2):1 via A,B,C
# and print the 3-parameter model
set label sprintf("T_in_Kelvin = 1/(%.3g + %.3g ln(R_ohms) + %.3g (ln(R_ohms)^3)",A,B,C) at 6,130


# plot the data as points and the models as curves
set style data points

# set the scaling of the axes
# It may be useful to look at this plot with both linear and log scale
# for the resistance.  Which plot is more useful at low temperature?
# Which more useful at high temperature?
set logscale x
set xrange[1:30]
unset logscale y
set yrange[*:*]

# place the legend where it won't interfere with the plots and labels
set key bottom left

plot 'therm_data2.txt' using 2:1 title 'data',\
	F(T_stein(x*1000,A0,B0,0)) title 'fitted 2-param',\
	F(T_stein(x*1000,A,B,C)) title 'fitted 3-param',\
	F(T_stein(x*1000,A_spec,B_spec,0)) title 'spec'
