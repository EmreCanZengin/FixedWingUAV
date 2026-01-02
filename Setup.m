clear;clc;close all;
addpath(genpath("./"))

%% MODEL Configuration Stuff
LNG_MODEL = 1; % 1: Linear Drag and Lift, 2: Nonlinear Drag and Lift.
PLOTTING_MODEL = 1; % 1: Online, 2: Post
POST_PLOTTING = 0; % 0: not animation, 1: animated

MAV = loadMAVParameters();
SIM = loadSIMParameters();