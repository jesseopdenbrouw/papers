# This is a GNUPLOT script
#
reset
set autoscale                          # scale axes automatically
unset log                              # remove any log-scaling
unset label                            # remove any previous labels
set xtic auto                          # set xtics automatically
set ytic auto                          # set ytics automatically
set decimalsign locale

# Set terminal type
set terminal pdfcairo
set output "ntc_ntc_plot_kelvin_fig.pdf"

# Do the plot
set xlabel "T [K]" #offset 0,-1
set ylabel "R_n_t_c [{/Symbol W}]" #offset -1
plot "GegevensBetatherm10K3A542I.dat" using 5:2 with points pt 7 ps 0.2 lc "red" notitle, "GegevensBetatherm10K3A542I.dat" using 5:2 smooth csplines lc "blue" notitle

set output
