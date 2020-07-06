# Instruction for day 2 of the tutorial

In order to run this tutorial, please make sure you have the following codes compiled:

1. DeepMD-kit (with tensorflow version 1.14.0);
2. Lammps interfaced with DeepMD-kit and Plumed;
3. PWscf code of Quantum-ESPRESSO.

If you are running this code on the GoldVM machine, these codes are already properly
compiled.

Before running the tutorial, please write the path to pw.x and lammps executable at
`path_to_codes`. No need to change the paths if you're running the tutorial 
on GoldVM.

You can run this tutorial with:

```./run_one_dp_iteration.sh &> log &```

We describe below what quatities you should look during the active learning cycle.

## Introduction

As shown in the first hands-on tutorial, DP-Gen builds a robust training data for 
deep neural network potentials based on an iterative scheme. This scheme consists of:
(1) exploration, (2) labeling and (3) training.

However, the type of exploration is critical to define the accuracy of the DNN potentials
over a range of physical events of interest. Transition states, for instance, are rarely 
sampled from conventional molecular dynamics (MD) simulations. An exploration scheme 
based only on conventional MD would thus miss configurations at the transition state, producing 
a DP potential with low-prediction accuracy for transition states. 

In this tutorial, we use enhanced sampling techniques to increase the probability of 
a system to visit rarely sampled configurations. Our system is composed of a single 
ethane (C2H6) in vacuum. The rare event in this system consists of the H-C-C-H 
dihedral rotation. 

Our aim is to perform 3 active-learning iterations in 3 h 30 min. No attempt to obtain 
a fully converged potential is made. The tutorial should provide a consistent improvement 
of the DNN potential with the number of iterations.

For the sake of time, we already provide you 3 trained potentials at `03-train/iter.000/?/graph?.pb`
("?" correspond to integers 1,2 or 3). These potentials were trained from training data 
consisting of randomly perturbed C2H6 molecules (see `03-train/iter.000/raw_files/README.md`
for more details).

You can easily perform one iteration cycle running `./run_one_dp_iteration.sh &> log &` in the current 
folder. This script will sweap over the 3 steps of active learning training. Below, we give 
instruction on what quantities we should look during the training.

We provide all the outputs of 3 active learning iterations at `./benchmark`.

## Exploration

This is the first step of active learning. We use Lammps interfaced with Plumed to perform
enhanced sampling simulations using the DNN potential. At this stage, we should mainly 
focus on two files: COLVAR and model_devi.out. COLVAR contains outputs from Plumed. 
In this file, we can see the time evolution of our collective variable (H-C-C-H dihedral).
This collective variable goes from -Pi to +Pi, and our enhanced sampling can explore 
the full rotation of the H-C-C-H dihedral. This is not the case of conventional MD.
You can find the time evolution of the H-C-C-H dihedral on a ~200 ps simulation 
without enhanced sampling at "benchmark/01-explore/00-test-without-enhanced-sampling/COLVAR".

model_devi.out contains the deviation of energy and forces predicted from 3 different 
DNN potentials. As in the first-day tutorial, these potentials are trained with the
same training data. They differ only by the different random initialization of the 
DNN parameters. We here use the deviation as a fast error estimatior of energy and
forces. As the iterations go, you should compare how the model deviation change as 
a function of the number of completed iterations.

At the end of the exploration, we will use the model deviation to select new atomic
configurations to retrain. Only configurations with high maximum deviation in atomic 
forces will be selected to retrain.  
 
If you're interested, you can also compute the free energy surface for this system at 
the end of each exploration step. Please read "01-explore/README" for more details.

## Labeling

Now that we selected a set of atomic configurations from the exploration step, we should 
label these configuration. Labeling consists of evaluation of atomic forces and energy 
using first-principles methods. We use the PBE functional, as implemented in the PW
code of Quantum-ESPRESSO, to evaluate first-principles energy and forces. At the end 
of this step, raw files will be extracted from PW outputs and later appended to the 
existing DP training data.

## Training

This is the last step of one active learning iteration. We will use the old and the new 
training data collected from labeling to train an improved DNN potential. 

Our DNN potential is slightly different from the one used in the first-day. We use 
the local-frame descriptors, instead of the smooth descriptors, for computational 
efficiency. We recommend the use of the smooth descriptors for condensed 
phase systems.

During training, you should look at "lcurve.out". This file contains the fitting 
error of the DNN as a function of the number of training steps. Use gnuplot to 
plot the training and testing error forces for one the potentials in folders 
1, 2 or 3 in "03-train/iter.00?".  
