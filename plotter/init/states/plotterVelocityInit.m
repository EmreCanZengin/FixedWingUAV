function h = plotterVelocityInit()
    h.ax1 = subplot(9, 3, 10);
    grid(h.ax1, 'on'); hold(h.ax1, 'on');
    ylabel(h.ax1, "$u$ $[m/s]$", "Interpreter", "latex");
    h.l1 = plot(h.ax1, NaN, NaN, 'r'); 

    h.ax2 = subplot(9, 3, 13); 
    grid(h.ax2, 'on'); hold(h.ax2, 'on');
    ylabel(h.ax2, "$v$ $[m/s]$", "Interpreter", "latex");
    h.l2 = plot(h.ax2, NaN, NaN, 'g');

    h.ax3 = subplot(9, 3, 16); 
    grid(h.ax3, 'on'); hold(h.ax3, 'on');
    ylabel(h.ax3, "$w$ $[m/s]$", "Interpreter", "latex");
    h.l3 = plot(h.ax3, NaN, NaN, 'b');
    
end