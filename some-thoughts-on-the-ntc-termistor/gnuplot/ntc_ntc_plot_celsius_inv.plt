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
set output "ntc_ntc_plot_celsius_fig_inv.pdf"

# Do the plot
set yrange [-45:125]
set ylabel "T [^oC]" #offset 0,-1
set xlabel "R_n_t_c [{/Symbol W}]" #offset -1
plot "GegevensBetatherm10K3A542I.dat" using 2:1 with points pt 7 ps 0.2 lc "red" notitle, "GegevensBetatherm10K3A542I.dat" using 2:1 smooth csplines lc "blue" notitle

set output
