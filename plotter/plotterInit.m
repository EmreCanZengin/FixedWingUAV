function handles = plotterInit()
    handles = struct();
    handles.fig = figure("Name", "Plotter", "NumberTitle", "off");
    handles.states = plotterStatesInit();
    handles.vaab = plotterVaAlphaBetaInit();
    handles.ctrl_srf = plotterControlSurfacesInit();
    handles.forces = plotterGeneratedForcesInit();
    handles.torques = plotterGeneratedTorquesInit();
end