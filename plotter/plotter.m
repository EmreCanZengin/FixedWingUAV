function plotter(uu)
    persistent handles;
    % If I delete isvalid part, It doesn't work. But I can't close the graph unless I stop the sim or close animation.
    if (isempty(handles) || ~isvalid(handles.fig)) 
        handles = plotterInit();
    end

    plotterUpdate(handles, uu);
end