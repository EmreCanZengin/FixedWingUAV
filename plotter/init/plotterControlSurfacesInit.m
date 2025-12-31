function h = plotterControlSurfacesInit()
    h.ax1 = subplot(9, 3, 12); 
    h.ax2 = subplot(9, 3, 15); 
    h.ax3 = subplot(9, 3, 18); 
    h.ax4 = subplot(9, 3, 21); 

    h.l1 = plot(h.ax1, NaN, NaN, 'r');
    h.l2 = plot(h.ax2, NaN, NaN, 'g');
    h.l3 = plot(h.ax3, NaN, NaN, 'b');
    h.l4 = plot(h.ax4, NaN, NaN, 'k');

    ylabel(h.ax1, "$\delta_a$ [$^{\circ}$]", "Interpreter", "latex");
    ylabel(h.ax2, "$\delta_e$ [$^{\circ}$]", "Interpreter", "latex");
    ylabel(h.ax3, "$\delta_r$ [$^{\circ}$]", "Interpreter", "latex");
    ylabel(h.ax4, "$\delta_t$ [$\%$]", "Interpreter", "latex");

    grid(h.ax1, 'on');
    grid(h.ax2, 'on');
    grid(h.ax3, 'on');
    grid(h.ax4, 'on');
end