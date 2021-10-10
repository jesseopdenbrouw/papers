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
set output "transferfunctionzmult.pdf"

#
Ropt = 15000.0
B1    = 3850.0
B2    = 3700.0
B3    = 4000.0
A    = 0.020637035
z1(x) = Ropt/(A*exp(B1/x)+Ropt)
z2(x) = Ropt/(A*exp(B2/x)+Ropt)
z3(x) = Ropt/(A*exp(B3/x)+Ropt)

set xrange [100:500]
set trange [280:280]
set style line 1  linetype 2 linecolor rgb "blue"  linewidth 0.500 pointtype 2 pointsize default pointinterval 50
set xlabel "T [K]" # offset -1
set ylabel "H [-]" # offset 0,-1
set style line 1 lt 0 lc "blue" lw 1.5
plot z1(x) notitle lc 7 with lines, z2(x) notitle lc 6 with lines, z3(x) notitle lc 5 with lines
 
set output
