#set terminal postscript 
#set output  "model_devi.ps"   
set title "Model Deviation vs. Time"
set xlabel "Time (ps)"
set ylabel "Max. absolute deviaiton in atomic forces (eV/A)"
plot "model_devi.out" u ($1/2000):5 with lines notitle
pause -1 "Hit any key to continue"
