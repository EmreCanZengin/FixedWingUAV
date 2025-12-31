function h = plotterGeneratedForcesInit()
    h.ax1 = subplot(9, 3, 19); hold(h.ax1, 'on');
    h.ax2 = subplot(9, 3, 22); hold(h.ax2, 'on');
    h.ax3 = subplot(9, 3, 25); hold(h.ax3, 'on');

    h.ax1_l1 = plot(h.ax1, NaN, NaN, 'r'); % fg
    h.ax1_l2 = plot(h.ax1, NaN, NaN, 'g'); % fatm
    h.ax1_l3 = plot(h.ax1, NaN, NaN, 'b'); % ft

    h.ax2_l1 = plot(h.ax2, NaN, NaN, 'r');
    h.ax2_l2 = plot(h.ax2, NaN, NaN, 'g');
    h.ax2_l3 = plot(h.ax2, NaN, NaN, 'b');

    h.ax3_l1 = plot(h.ax3, NaN, NaN, 'r');
    h.ax3_l2 = plot(h.ax3, NaN, NaN, 'g');
    h.ax3_l3 = plot(h.ax3, NaN, NaN, 'b');

    ylabel(h.ax1, "$F_x$ [$N$]", "Interpreter", 'latex');
    ylabel(h.ax2, "$F_y$ [$N$]", "Interpreter", 'latex');
    ylabel(h.ax3, "$F_z$ [$N$]", "Interpreter", 'latex');
    
    grid(h.ax1, 'on'); 
    grid(h.ax2, 'on'); 
    grid(h.ax3, 'on'); 
end