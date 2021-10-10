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
set output "spanningsswings.pdf"

#         R         R
#  z = ------- - -------
#       1         n + R
#       - + R
#       n
#
z(x,n) = x/(1.0/n+x) - x/(n+x)

set xrange [0:5]
#set yrange [3700:4050]
set xlabel "R_S [{/Symbol W}] (genormaliseerd)" # offset -1
set ylabel "Z [-]" # offset 0,-1
plot z(x,2) notitle lc 5 with lines, z(x,3) notitle lc 6 with lines, z(x,3) notitle lc 9 with lines, z(x,4) notitle lc 10 with lines, z(x,10) notitle lc 15 with lines 
 
set output
