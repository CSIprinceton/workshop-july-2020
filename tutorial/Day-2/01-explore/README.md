##Free energy surface of ethane dihedral rotation

We use metadynamics to enhance the probability to visit rare events. You can find 
excellent tutorials about metadynamics at Plumed's documentation page:
https://www.plumed.org/doc-v2.6/user-doc/html/index.html

You can obtain the free energy surface as a function of the H-C-C-H dihedral with:

1. Go to a folder corresponding to a particular iteration. Say, for iteration 1:

`cd iter.001`

2. Compute the free energy surface

`plumed sum_hills --hills HILLS`

This will generate a file `fes.dat`. You can plot the free energy surface with:

```
gnuplot
p 'fes.dat' u 1:2 w l notitle
```
