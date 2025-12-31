clear;clc;close all;
addpath(genpath("./"))

%% MODEL Configuration Stuff
LNG_MODEL = 1; % 1: Linear Drag and Lift, 2: Nonlinear Drag and Lift.

MAV = loadMAVParameters();
SIM = loadSIMParameters();