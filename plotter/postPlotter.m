function handles = postPlotter(simout, is_anim)
    uu = extractSimOutArray(simout); % contains data
    handles = plotterInit(); % To use the same sublplot
    set(handles.fig, "Name", "Post-Plotter")
    if ~is_anim
        handles = plotterUpdate(handles, uu);
    else
        disp("Plotting and Animating...")
        VIDEO_FPS = 30; 
        sim_dt = uu(end, 2) - uu(end, 1);

        draw_step = round( (1 / VIDEO_FPS) / sim_dt); % How many time step to jump each plotting.
        if draw_step < 1, draw_step = 1; end
        
        for k=1:draw_step: size(uu, 2)
            if k~=1
                ud_idx = k - draw_step + 1;
                handles = plotterUpdate(handles, uu(:, ud_idx:k));
            end
            
            drawAircraft(uu(:, k));
            t_elapsed = toc;

            wait_time = (1 / VIDEO_FPS) - t_elapsed;
            if wait_time > 0, pause(wait_time); end
        end
    end
end
