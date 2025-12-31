function h = plotterGeneratedTorquesUpdate(h, torques, time)
    tatm = torques(1:3);
    tt = torques(4:6);
    
    set(h.ax1_l1, "XData", [h.ax1_l1.XData time], "YData", [h.ax1_l1.YData tatm(1)]);
    set(h.ax2_l1, "XData", [h.ax2_l1.XData time], "YData", [h.ax2_l1.YData tatm(2)]);
    set(h.ax3_l1, "XData", [h.ax3_l1.XData time], "YData", [h.ax3_l1.YData tatm(3)]);

    set(h.ax1_l2, "XData", [h.ax1_l2.XData time], "YData", [h.ax1_l2.YData tt(1)]);
    set(h.ax2_l2, "XData", [h.ax2_l2.XData time], "YData", [h.ax2_l2.YData tt(2)]);
    set(h.ax3_l2, "XData", [h.ax3_l2.XData time], "YData", [h.ax3_l2.YData tt(3)]);
end