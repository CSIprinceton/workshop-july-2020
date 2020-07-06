#set terminal postfile 
#set output  "colvar.ps"   
set title "Learning curve"
set xlabel "Step"
set ylabel "Maximum absolute deviation in atomic forces (eV/A)"
plot "lcurve.out" u 1:6 w l t 'Testing', '' u 1:7 w l t 'Training' 
pause -1 "Hit any key to continue"
