# Instruction for day 2 of the tutorial

As shown in the first hands-on tutorial, DP-Gen builds a robust training data for 
deep neural network potentials based on an iterative scheme. This scheme consists of:
1) exploration, 2) labeling and 3) training.

However, the type of exploration is critical to define the accuracy of the DNN potentials
over a range of physical events of interest. Transition states, for instance, are rarely 
sampled from conventional molecular dynamics (MD) simulations. An exploration scheme 
based only on conventional MD would thus miss configurations at the transition state, producing 
a DP potential with low-prediction accuracy for transition states. 

In this tutorial, we use enhanced sampling techniques to increase the probability of 
a system to visit rare events. Our system 
