function h = plotterGeneratedTorquesInit()
    h.ax1 = subplot(9, 3, 20); hold(h.ax1, 'on');
    h.ax2 = subplot(9, 3, 23); hold(h.ax2, 'on');
    h.ax3 = subplot(9, 3, 26); hold(h.ax3, 'on');

    h.ax1_l1 = plot(h.ax1, NaN, NaN, 'r'); % fatm
    h.ax1_l2 = plot(h.ax1, NaN, NaN, 'g'); % ft

    h.ax2_l1 = plot(h.ax2, NaN, NaN, 'r');
    h.ax2_l2 = plot(h.ax2, NaN, NaN, 'g');

    h.ax3_l1 = plot(h.ax3, NaN, NaN, 'r');
    h.ax3_l2 = plot(h.ax3, NaN, NaN, 'g');

    ylabel(h.ax1, "$T_x$ [$N.m$]", "Interpreter", 'latex');
    ylabel(h.ax2, "$T_y$ [$N.m$]", "Interpreter", 'latex');
    ylabel(h.ax3, "$T_z$ [$N.m$]", "Interpreter", 'latex');

    grid(h.ax1, 'on'); 
    grid(h.ax2, 'on'); 
    grid(h.ax3, 'on'); 
end