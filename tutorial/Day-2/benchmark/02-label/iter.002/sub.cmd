#!/bin/bash
#SBATCH -N 1   # node count
#SBATCH --tasks-per-node=40
#SBATCH -t 1:00:00
#SBATCH -J Retr

#module load intel/18.0/64/18.0.3.222 intel-mpi/intel/2018.3/64 
module load openmpi/gcc 

PW=/home/mandrade/QE-libxc/PW/src/pw.x

c=0
for i in `cat list`
do
  if [ $c -lt 40 ]; then
    cd $i
    srun -n 1 $PW < 01.in > 01.out &
    cd ..
    c=$((c+1))
  else
    wait
    c=0
  fi
done

wait
