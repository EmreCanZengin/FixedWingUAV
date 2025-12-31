function MAV = loadMavStructureParams()
    % ALL MUST BE IN METERS
    MAV = struct();
    MAV.fuse_l_1x3 = [0.50, 0.35, 0.70]; 
    MAV.fuse_h = 0.2;
    MAV.fuse_w = 0.18;

    MAV.wing_l = 0.35;
    MAV.wing_w = 1.65;

    MAV.tail_h = 0.25;
    MAV.tailwing_l = 0.20;
    MAV.tailwing_w = 0.50;
    MAV.cg_wing_percentage = 0.40;
end