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
set output "ntc_sensitivity_ntc.pdf"

### Calculate mean to set some gnuplot internals
#mean(x)= m
#fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 3:4 via m 
#SST = FIT_WSSR/(FIT_NDF+1)

# Do a fit using a power function:
lnA = -3.88
B = 3892.0
straightline(x) = B*x + lnA
FIT_LIMIT=1.e-10
fit straightline(x) "GegevensBetatherm10K3A542I.dat" using 3:4 via B, lnA
A = exp(lnA)

### Caculcate some ...
#SSE=FIT_WSSR/(FIT_NDF)
#SSR=SST-SSE
#R2=SSR/SST

# Diff of Rntc
ntc_diff(x) = -A*B*exp(B/x)/(x*x)

# Do the plot
set xrange [233:391]
set xlabel "T [K]" # offset 0,-1
set ylabel "diff R_n_t_c [{/Symbol W}/K]" # offset -1
plot ntc_diff(x) title "" lc "red" with lines

# Create LaTeX file with parameters
set decimalsign locale
set print "ntc_sensitivity_ntc_alpha.tex"
print "% Sensitivity of the NTC in Ohm/K"
#print "% ln Rntc = B*x + A"
print sprintf("\\newcommand{\\ntcsensitivityntcalphaabs}{%f}", ntc_diff(298.15))
print sprintf("\\newcommand{\\ntcsensitivityntcalpha}{%f}", ntc_diff(298.15)/100.0)
print sprintf("\\newcommand{\\ntcsensitivityntcalphatwodec}{%.2f}", ntc_diff(298.15)/100.0)

set output
