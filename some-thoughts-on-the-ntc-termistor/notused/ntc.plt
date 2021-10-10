# This is a GNUPLOT script
#
set autoscale                          # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically

# Set terminal type
set terminal latex
#set terminal latex size 8cm,12cm
set output "ntc_gnuplot.tex"

### Temp Celsius to Kelvin
T_Czero = 273.15

### Calculate mean to set some gnuplot internals
mean(x)= m+T_Czero
fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 1:2 via m # 1 is the x axis and 2 is the y axis
SST = FIT_WSSR/(FIT_NDF+1)

# Do a fit using using the Steinhart-Hart beta function:
# Give some start values for a and b
A = 0.1
B = 5000.0
shh_beta(x) = A*exp(B/(x+T_Czero))
fit shh_beta(x) "GegevensBetatherm10K3A542I.dat" using 1:2 via B,A

### Caculcate some ...
SSE=FIT_WSSR/(FIT_NDF)

SSR=SST-SSE
R2=SSR/SST

# Do the plot
#set size square 1,1
#set ytics 400                           # Increment 20
#set xtics 5                           # Increment 20
set xrange [-50:130]
set yrange [0:400000]
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
#plot "GegevensBetatherm10K3A542I.dat" using 1:2 pt 6 title "", shh_beta(x) title "" with dots #ps 20 #with points pointtype 1
#plot "GegevensBetatherm10K3A542I.dat" using 1:2 pt 9 title ""
#plot "GegevensBetatherm10K3A542I.dat" using 1:2 smooth csplines title "",  "GegevensBetatherm10K3A542I.dat" using 1:2 title "" with points pt 7 ps 10, shh_beta(x) # creates $bullet$
#plot "GegevensBetatherm10K3A542I.dat" using 5:2 pt 6, shh_beta(x)  title "" with dots
set label sprintf("$R_\\text{NTC}=%f*\\exp(%f/T)$\n$R^2=%f$", A, B, R2) at 20,350000
plot "GegevensBetatherm10K3A542I.dat" using 1:2 pt 6 title "", shh_beta(x) title "" with lines
#stats 'GegevensBetatherm10K3A542I.dat' using 1:2
