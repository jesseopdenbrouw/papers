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
set output "ntc_sensitivity_H.pdf"

### Calculate mean to set some gnuplot internals
#mean(x)= m
#fit mean(x) 'GegevensBetatherm10K3A542I.dat' using 3:4 via m 
#SST = FIT_WSSR/(FIT_NDF+1)

# Do a fit using a power function:
lnA = 0.1
B = 5000.0
straightline(x) = B*x + lnA
fit straightline(x) "GegevensBetatherm10K3A542I.dat" using 3:4 via B, lnA
A = exp(lnA)
Ropt = 16218.0

### Caculcate some ...
#SSE=FIT_WSSR/(FIT_NDF)
#SSR=SST-SSE
#R2=SSR/SST

# Diff of H
H_diff(x) = (Ropt*A*B*exp(B/x))/((A*exp(B/x)+Ropt)**2*(x*x))

# Do the plot
#set xrange [233:391]
set xrange [100:500]
set xlabel "T [K]" # offset 0,-1
set ylabel "diff H [K^-^1]" # offset -1
plot H_diff(x) title "" lc "red" with lines

maxdiff = 0;
maxtemp = 0;
do for [t=10000:50000] {
	diff = H_diff(t/100.0)
	if (diff > maxdiff) {
		maxdiff = diff
		maxtemp = t/100.0
	}
}

set print "-"
print maxtemp
print maxdiff

# Create LaTeX file with parameters
set decimalsign locale
set print "ntc_sensitivity_H.tex"
print "% H fitting parameters maximum devirate"
print sprintf("\\newcommand{\\ntcsensitivityhmaxdiff}{%f}", maxdiff)
print sprintf("\\newcommand{\\ntcsensitivityhmaxtemp}{%.2f}", maxtemp)

set output
