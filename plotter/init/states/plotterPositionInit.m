function h = plotterPositionInit()
    h.ax1 = subplot(9, 3, 1);
    grid(h.ax1, 'on'); hold(h.ax1, 'on');
    ylabel(h.ax1, "$p_n$ [m]", "Interpreter", "latex");
    h.l1 = plot(h.ax1, NaN, NaN, 'r'); 

    h.ax2 = subplot(9, 3, 4);
    grid(h.ax2, 'on'); hold(h.ax2, 'on');
    ylabel(h.ax2, "$p_e$ [m]", "Interpreter", "latex");
    h.l2 = plot(h.ax2, NaN, NaN, 'g');

    h.ax3 = subplot(9, 3, 7); 
    grid(h.ax3, 'on'); hold(h.ax3, 'on');
    ylabel(h.ax3, "$h$ [m]", "Interpreter", "latex");
    h.l3 = plot(h.ax3, NaN, NaN, 'b');
end