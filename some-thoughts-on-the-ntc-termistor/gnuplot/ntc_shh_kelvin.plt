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
set output "ntc_shh_kelvin_fig.pdf"

### Calculate mean to set some gnuplot internals
mean(x)= m
fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 2:5 via m
SST = FIT_WSSR/(FIT_NDF+1)

# Do a fit using using the Steinhart-Hart beta function:
# Give some start values for a and b
A=1.0
B=1.0/3800.0
C=1e-6
shh_curve_fit(x) = 1.0/(A + B*log(x) + C*(log(x)**3))
fit shh_curve_fit(x) "GegevensBetatherm10K3A542I.dat" using 2:5 via C,B,A

### Caculcate some ...
SSE=FIT_WSSR/(FIT_NDF)
SSR=SST-SSE
R2=SSR/SST

# Do the plot
#set xrange [-50:130]
#set yrange [3700:4050]
set xlabel "R_n_t_c [{/Symbol W}]" # offset 0,-1
set ylabel "T [K]" # offset -1
plot shh_curve_fit(x) title "" with lines lc "blue", "GegevensBetatherm10K3A542I.dat" using 2:5 with points pt 7 ps 0.2 lc "red" title ""

# Create LaTeX file with parameters
set decimalsign locale
set print "ntc_shh_kelvin_curve_fitting_params.tex"
print "% Curve fitting parameters for fitting Steinhart-Hart plot in Kelvin"
print "%1/T = A + B*log(x) + C*log(x)**3"
print sprintf("\\newcommand{\\ntcshhkelvinA}{$").gprintf("%t", A).sprintf("\\cdot 10^{").gprintf("%T", A).sprintf("}$}")
print sprintf("\\newcommand{\\ntcshhkelvinB}{$").gprintf("%t", B).sprintf("\\cdot 10^{").gprintf("%T", B).sprintf("}$}")
print sprintf("\\newcommand{\\ntcshhkelvinC}{$").gprintf("%t", C).sprintf("\\cdot 10^{").gprintf("%T", C).sprintf("}$}")
print sprintf("\\newcommand{\\ntcshhkelvinRsqr}{%.10f}", R2)

set output
