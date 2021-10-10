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
set output "ntc_shh_straightline_beta_fig.pdf"

### Calculate mean to set some gnuplot internals
mean(x)= m
fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 3:4 via m 
SST = FIT_WSSR/(FIT_NDF+1)

# Do a fit using a power function:
R0 = 10000.0
T0 = 273.15+25.0
B = 5000.0
straightline_beta(x) = B*x + log(R0) - B/T0
fit straightline_beta(x) "GegevensBetatherm10K3A542I.dat" using 3:4 via B

### Caculcate some ...
SSE=FIT_WSSR/(FIT_NDF)
SSR=SST-SSE
R2=SSR/SST

# Do the plot
set yrange [5:14]
set xlabel "1/T [K^-^1]" # offset 0,-1
set ylabel "ln R_n_t_c [ln {/Symbol W}]" # offset -1
plot straightline_beta(x) title "" lc "blue" with lines, "GegevensBetatherm10K3A542I.dat" using 3:4 with points pt 7 ps 0.2 lc "red" title "" 

# Create LaTeX file with parameters
set decimalsign locale
set print "ntc_shh_straightline_beta_curve_fitting_params.tex"
print "% Curve fitting parameters for fitting straight line"
print "% ln Rntc = B*x + log(R0) - B/T0"
print sprintf("\\newcommand{\\ntcshhstraightlinebetaB}{%f}", B)
print sprintf("\\newcommand{\\ntcshhstraightlinebetaBonedec}{%.1f}", B)
print sprintf("\\newcommand{\\ntcshhstraightlinebetaBint}{%d}", B)
print sprintf("\\newcommand{\\ntcshhstraightlinebetaRsqr}{%f}", R2)

set output
