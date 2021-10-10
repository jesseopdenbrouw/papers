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
#A = 0.1
B = 3892.0
Rntc(x) = A*exp(B/x)
fit Rntc(x) "GegevensBetatherm10K3A542I.dat" using 5:2 via B,A

### Caculcate some ...
SSE=FIT_WSSR/(FIT_NDF)

SSR=SST-SSE
R2=SSR/SST

# Do the plot
#set size square 1,1
#set ytics 400                           # Increment 20
#set xtics 5                           # Increment 20
#set xrange [-50:130]
#set yrange [0:400000]
#set title "Cells vs. Bits"
#set xlabel "Bits [-]" offset 0,-1
#set ylabel "\\rotatebox{90}{Cells [-]}" offset -1
#set label sprintf("b = %3.4f",b) at 6,1900
#set label sprintf("a = %3.4f",a) at 6,1700
#set label sprintf("$C = %3.4f\\cdot b^{\\,%3.4f}$",a,b) at 6,1700
#plot "synthesis.dat" using 1:3 title "", lin(x) title "best fit"
#set pointsize 2
#set data style linespoints
#set style line 1 lc rgb 'black' pt 5   # square
#set style data points
#set lmargin 0
#set rmargin 0
#set label sprintf("$R_\\text{NTC}=%f*\\exp(%f/T)$\n$R^2=%f$", A, B, R2) # at 20,350000
plot Rntc(x) title "" with lines lc "blue", "GegevensBetatherm10K3A542I.dat" using 5:2 with points pt 7 ps 0.2 lc "red" title ""
#stats 'GegevensBetatherm10K3A542I.dat' using 1:2

set print "ntc_shh_kelvin_curve_fitting_params.tex"
print "% Curve fitting parameters for fitting Steinhart-Hart plot in Kelvin"
print "% Rntc = A*exp(B/T)"
foo = sprintf("\\newcommand{\\shhkelvinA}{%.10f}", A)
print foo
foo = sprintf("\\newcommand{\\sshkelvinB}{%.10f}", B)
print foo
#foo = sprintf("\\newcommand{\\ntcbetakelvinC}{%.10f}", C)
#print foo
#foo = sprintf("\\newcommand{\\ntcbetakelvinD}{%.10f}", D)
#print foo
foo = sprintf("\\newcommand{\\ntcsshkelvinRsqr}{%.10f}", R2)
print foo

set output


