function h = plotterPositionUpdate(h, pos_vec_3x1, time)  
    set(h.l1, "XData", [h.l1.XData time], "YData", [h.l1.YData pos_vec_3x1(1)]);
    set(h.l2, "XData", [h.l2.XData time], "YData", [h.l2.YData pos_vec_3x1(2)]);
    set(h.l3, "XData", [h.l3.XData time], "YData", [h.l3.YData -pos_vec_3x1(3)]);
end