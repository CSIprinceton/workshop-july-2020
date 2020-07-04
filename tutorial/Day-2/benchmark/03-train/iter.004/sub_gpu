#!/bin/bash -l
#SBATCH -N 1
#SBATCH --ntasks-per-node 6
#SBATCH -t 1:00:00
#SBATCH --gres=gpu:1
#SBATCH -J Plumed

module load cudatoolkit/10.0 cudnn/cuda-10.0/7.6.1

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/mandrade/lammps/lib/plumed/plumed2/lib

code=/home/mandrade/lammps/src/lmp_serial
export OMP_NUM_THREADS=4

$code < lammps.in > out.lammps 
#$code < lammps.restart.in &> out.lammps 

#cat model_devi.out >> model_devi.out_bkp

#sbatch sub_gpu
