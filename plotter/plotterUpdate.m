function handles = plotterUpdate(handles, uu)
    time = uu(end);
    handles.states = plotterStatesUpdate(handles.states, uu(1:12), time);
    handles.vaab = plotterVaAlphaBetaUpdate(handles.vaab, uu(17:20), time);
    handles.ctrl_srf = plotterControlSurfacesUpdate(handles.ctrl_srf, uu(13:16), time);
    handles.forces = plotterGeneratedForcesUpdate(handles.forces, uu(23:31), time);
    handles.torques = plotterGeneratedTorquesUpdate(handles.torques, uu(32:37), time);
    drawnow limitrate;
end