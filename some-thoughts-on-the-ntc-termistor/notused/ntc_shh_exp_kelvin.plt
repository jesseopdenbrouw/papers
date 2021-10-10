# This is a GNUPLOT script
#
reset
set autoscale                          # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically

# Set terminal type
set terminal pdfcairo
set output "ntc_ssh_kelvin_fig.pdf"

### Temp Celsius to Kelvin
#T_Czero = 273.15

### Calculate mean to set some gnuplot internals
mean(x)= m
fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 5:2 via m # 1 is the x axis and 2 is the y axis
SST = FIT_WSSR/(FIT_NDF+1)

# Do a fit using using the Steinhart-Hart beta function:
# Give some start values for a and b
A = 0.01
B = 5000.0
Rntc(x) = A*exp(B/x)
fit Rntc(x) "GegevensBetatherm10K3A542I.dat" using 5:2 via B,A

### Caculcate some ...
SSE=FIT_WSSR/(FIT_NDF)
SSR=SST-SSE
R2=SSR/SST

# Do the plot
plot Rntc(x) title "" with lines lc "blue", "GegevensBetatherm10K3A542I.dat" using 5:2 with points pt 7 ps 0.2 lc "red" title ""

set print "ntc_shh_kelvin_exp_curve_fitting_params.tex"
print "% Curve fitting parameters for fitting Steinhart-Hart plot in Kelvin"
print "% Rntc = A*exp(B/T)"
print sprintf("\\newcommand{\\shhkelvinA}{%.10f}", A)
print sprintf("\\newcommand{\\sshkelvinB}{%.10f}", B)
print sprintf("\\newcommand{\\ntcsshkelvinRsqr}{%.10f}", R2)

set output
