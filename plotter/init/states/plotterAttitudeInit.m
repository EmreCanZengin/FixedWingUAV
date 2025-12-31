function h = plotterAttitudeInit()
    h.ax1 = subplot(9, 3, 2); 
    grid(h.ax1, 'on'); hold(h.ax1, 'on');
    ylabel(h.ax1, "$\phi$ [$^{\circ}$]", "Interpreter", "latex");
    h.l1 = plot(h.ax1, NaN, NaN, 'r'); 

    h.ax2 = subplot(9, 3, 5); 
    grid(h.ax2, 'on'); hold(h.ax2, 'on');
    ylabel(h.ax2, "$\theta$ [$^{\circ}$]", "Interpreter", "latex");
    h.l2 = plot(h.ax2, NaN, NaN, 'g');

    % 3. Psi (Yaw)
    h.ax3 = subplot(9, 3, 8); 
    grid(h.ax3, 'on'); hold(h.ax3, 'on');
    ylabel(h.ax3, "$\psi$ [$^{\circ}$]", "Interpreter", "latex");
    h.l3 = plot(h.ax3, NaN, NaN, 'b');
end