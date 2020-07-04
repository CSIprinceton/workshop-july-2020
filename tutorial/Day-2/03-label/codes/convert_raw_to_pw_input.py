import numpy as np
from os import system

pos=np.genfromtxt('coord.raw')
typ=np.genfromtxt('type.raw',dtype='int')

nframes=pos.shape[0]
natoms=np.size(typ)
ntype=np.unique(typ).size
my_dict = {0: 'C', 1: 'H'}
indat = np.array( [my_dict[i] for i in typ] )

pos=pos.reshape(nframes,natoms,3)

for frame in range(0,nframes):

  system("mkdir ./{:05d} 2> /dev/null".format(frame+1))

  with open("./{:05d}/01.in".format(frame+1), "w") as lmp:
    lmp.write('&control\n')
    lmp.write('  calculation=\'scf\'\n')
    lmp.write('  prefix=\'ethane\'\n')
    lmp.write('  pseudo_dir=\'../../pseudo-potentials\'\n')
    lmp.write('  outdir=\'./out\'\n')
    lmp.write('  restart_mode=\'from_scratch\'\n')
    lmp.write('  nstep=20000\n')
    lmp.write('  max_seconds=14000\n')
    lmp.write('  tprnfor=.true.\n')
    lmp.write('  disk_io=\'none\'\n')
    lmp.write('/\n')
    lmp.write('&system\n')
    lmp.write('  ibrav=1\n')
    lmp.write('  a=10\n')
    lmp.write('  nat={}\n'.format(natoms))
    lmp.write('  ntyp={},\n'.format(ntype))
    lmp.write('  ecutwfc=50\n')
    lmp.write('/\n')
    lmp.write('&electrons\n')
    lmp.write('  electron_maxstep = 100\n')
    lmp.write('  mixing_beta = 0.2\n')
    lmp.write('  conv_thr = 1.D-6\n')
    lmp.write('/\n')
    lmp.write('&ions\n')
    lmp.write('/\n')
    lmp.write('&cell\n')
    lmp.write('/\n')
    lmp.write('ATOMIC_SPECIES\n')
    if any(typ==0):
      lmp.write('C   1.0  C_ONCV_PBE-1.0.upf \n')
    if any(typ==1):
      lmp.write('H   1.0  H_ONCV_PBE-1.0.upf \n')
    lmp.write('ATOMIC_POSITIONS {angstrom}\n')
    for iat in range(natoms):
      lmp.write('{} {} {} {}\n'.format(indat[iat],pos[frame][iat][0],pos[frame][iat][1], pos[frame][iat][2]))
