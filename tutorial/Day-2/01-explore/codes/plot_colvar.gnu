#set terminal postfile 
#set output  "colvar.ps"   
set title "H-C-C-H dihedral vs. Time"
set xlabel "Time (ps)"
set ylabel "H-C-C-H dihedral (radians)"
plot "COLVAR" u ($1/2000):2 with lines notitle
pause -1 "Hit any key to continue"
