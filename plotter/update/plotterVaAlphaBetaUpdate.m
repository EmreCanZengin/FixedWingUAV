function h = plotterVaAlphaBetaUpdate(h, vaab, time)
    set(h.l1, "XData", [h.l1.XData time], "YData", [h.l1.YData vaab(1, :)]);
    set(h.l2, "XData", [h.l2.XData time], "YData", [h.l2.YData 180 / pi * vaab(2, :)]);
    set(h.l3, "XData", [h.l3.XData time], "YData", [h.l3.YData 180 / pi * vaab(3, :)]);
end
