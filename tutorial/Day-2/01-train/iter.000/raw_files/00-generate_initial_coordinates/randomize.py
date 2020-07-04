import numpy as np

#Read initial configuration from the raw file
pos=np.genfromtxt('coord_ini.raw')

#More tractable format of cell and positions
pos=np.reshape(pos,(int(pos.shape[0]/3),3))

#Generate random perturbations - will generate n configurations
n=400
rand_pos = np.random.rand(n,pos.shape[0],pos.shape[1])                      
rand_pos = 2.*rand_pos -1.                                                
rand_pos = 0.06 * rand_pos #0.05 angstroms perturbation                                                                

#New position and cell arrays
newpos=np.tile(pos,(n,1,1))

#Apply perturbation to coordinates and cell
newpos += rand_pos

np.savetxt('coord.raw',np.reshape(newpos,(-1,pos.shape[0]*3)))

