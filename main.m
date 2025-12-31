run("Setup.m")
load("oper_point.mat");
out = sim("Simulation");
postPlotter(out.simout, false);