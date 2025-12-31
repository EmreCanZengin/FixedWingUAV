function h = plotterVaAlphaBetaInit()
    h = struct();
    h.ax1 = subplot(9, 3, 3); 
    h.ax2 = subplot(9, 3, 6); 
    h.ax3 = subplot(9, 3, 9); 

    h.l1 = plot(h.ax1, NaN, NaN, 'r');
    h.l2 = plot(h.ax2, NaN, NaN, 'g');
    h.l3 = plot(h.ax3, NaN, NaN, 'b');

    ylabel(h.ax1, '$Va$ [m/s]','Interpreter', 'latex');
    ylabel(h.ax2, '$\alpha$ [$^{\circ}$]', 'Interpreter', 'latex');
    ylabel(h.ax3, '$\beta$ [$^{\circ}$]', 'Interpreter', 'latex'); 

    grid(h.ax1,'on');
    grid(h.ax2,'on');
    grid(h.ax3,'on');
end