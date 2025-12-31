function h = plotterControlSurfacesUpdate(h, ctrl_srf, time)
    set(h.l1, "XData", [h.l1.XData time], "YData", [h.l1.YData 180/pi * ctrl_srf(1, :)])
    set(h.l2, "XData", [h.l2.XData time], "YData", [h.l2.YData 180/pi * ctrl_srf(2, :)])
    set(h.l3, "XData", [h.l3.XData time], "YData", [h.l3.YData 180/pi * ctrl_srf(3, :)])
    set(h.l4, "XData", [h.l4.XData time], "YData", [h.l4.YData    100 * ctrl_srf(4, :)])
end