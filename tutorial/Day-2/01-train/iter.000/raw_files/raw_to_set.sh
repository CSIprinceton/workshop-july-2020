#!/bin/bash

cat << EOF > import.py
import numpy as np
c=np.loadtxt("coord.raw").astype(np.float32)
b=np.loadtxt("box.raw").astype(np.float32)
f=np.loadtxt("force.raw").astype(np.float32)
e=np.loadtxt("energy.raw").astype(np.float32)
g=np.max(np.abs(f),axis=1)

np.save("energy",e[g<30])
np.save("box"   ,b[g<30])
np.save("force" ,f[g<30])
np.save("coord" ,c[g<30])

EOF

python import.py
mkdir set.000
mv *npy set.000
rm import.py
