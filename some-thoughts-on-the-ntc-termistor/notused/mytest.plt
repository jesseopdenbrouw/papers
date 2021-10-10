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
set output "ntc_gnuplot.tex

mean(x)= m
fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 1:2 via m # 1 is the x axis and 2 is the y axis
SST = FIT_WSSR/(FIT_NDF+1)

f(x) = a*x + b
fit f(x) 'GegevensBetatherm10K3A542I.dat' using 1:2 via a, b
SSE=FIT_WSSR/(FIT_NDF)

SSR=SST-SSE
R2=SSR/SST

set label sprintf("f(x)=%fx+%f\nR-2=%f", a, b, R2) # print r^2.
plot 'GegevensBetatherm10K3A542I.dat' using 1:2 title 'data', f(x) notitle
