function h = plotterGeneratedForcesUpdate(h, forces, time)
    fg = forces(1:3);
    fatm = forces(4:6);
    ft = forces(7:9);
    
    set(h.ax1_l1, "XData", [h.ax1_l1.XData time], "YData", [h.ax1_l1.YData fg(1)]);
    set(h.ax2_l1, "XData", [h.ax2_l1.XData time], "YData", [h.ax2_l1.YData fg(2)]);
    set(h.ax3_l1, "XData", [h.ax3_l1.XData time], "YData", [h.ax3_l1.YData fg(3)]);

    set(h.ax1_l2, "XData", [h.ax1_l2.XData time], "YData", [h.ax1_l2.YData fatm(1)]);
    set(h.ax2_l2, "XData", [h.ax2_l2.XData time], "YData", [h.ax2_l2.YData fatm(2)]);
    set(h.ax3_l2, "XData", [h.ax3_l2.XData time], "YData", [h.ax3_l2.YData fatm(3)]);

    set(h.ax1_l3, "XData", [h.ax1_l3.XData time], "YData", [h.ax1_l3.YData ft(1)]);
    set(h.ax2_l3, "XData", [h.ax2_l3.XData time], "YData", [h.ax2_l3.YData ft(2)]);
    set(h.ax3_l3, "XData", [h.ax3_l3.XData time], "YData", [h.ax3_l3.YData ft(3)]);
end