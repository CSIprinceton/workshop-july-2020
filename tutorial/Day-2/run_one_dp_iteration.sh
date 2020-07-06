#Running one cycle of DP active learning 
origin=`pwd`
source path_to_codes

if [ -e .iter ]; then 
  iter=`cat .iter`
else
  iter=1
fi

#### Exploration ####

#cd 01-explore/iter.00${iter}
##Link DP graphs (deep potentials)
#ln -s $origin/03-train/iter.00$((iter-1))/?/graph* . 
##Run Lammps
#echo "Running Lammps. It will take 20 minutes (max.) to finish"
#echo "The simulation is running at: $origin/01-explore/iter.00${iter}"
#$lammps < lammps.in &> lammps.out
#if grep -q 'Total wall time' lammps.out
#  then
#  echo "Done with Lammps"
#else
#  echo "Lammps simulation crashed"
#  echo "STOP"
#  exit
#fi
#./extract_to_retrain.sh
#n=`wc -l coord.raw | awk '{print $1}'`
#echo "We will label $n configurations"
#cd $origin

#### Labeling ####

cd 02-label/iter.00${iter}
cp $origin/01-explore/iter.00${iter}/coord.raw .
echo "We will start first-principles calculations right now. It should take 10-15 minutes."
../codes/run_first_principles.sh
if [ -s analysis/force.raw ]; then
  echo "Finished first-principles. We will now add the newly labeled data to the old DP training data."
else
  echo "Something went wrong with PW calculations"
  echo "STOP"
  exit
fi
cd $origin

#### Training ####

cd 03-train/iter.00${iter}/raw_files 
./collect_training_data.sh $iter
cd ..
echo "Training 3 DP models. Training should take around 30 minutes"
echo "The learning curves are prited to lcurve.out. You can find these files at:"
echo "03-train/iter.00${iter}/1, 03-train/iter.00${iter}/2, 03-train/iter.00${iter}/3" 
./train_models.sh
echo "Finished training the models. Now, we will freeze the graphs."
./freeze_models.sh
if [ -e 1/graph1.pb ] && [ -e 2/graph2.pb ] && [ -e 3/graph3.pb ]
then
  echo "You can find the frozen models at 1/graph1.pb, 2/graph2.pb and 3/graph3.pb"
  echo "We just finished one active learning cycle" 
  echo "If you want to refine your DP models, please run this code again."
else
  echo "Could not find graph files. DNN training crashed."
  echo "STOP"
  exit
fi
cd $origin

###

echo $((iter+1)) > .iter
