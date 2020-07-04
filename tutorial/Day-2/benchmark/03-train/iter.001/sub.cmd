#!/bin/bash -l
#SBATCH -n 6
#SBATCH -t 1:00:0
#SBATCH --mem 32G 

export OMP_NUM_THREADS=2
module load anaconda
conda activate dpmd

for i in ?
do
  cd $i
  python -m deepmd train input.json &
  cd ..
done
wait

