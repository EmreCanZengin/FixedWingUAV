function drawAircraft(states)
    persistent aircraft_h;
    persistent bff_h;
    persistent vel_h;
    persistent osd_h;
    persistent vertices;
    persistent faces;
    persistent colors;

    if states(end) == 0
        figure(1); clf;hold on;grid on;
        [vertices, faces, colors] = createAircraft();
        aircraft_h = drawAircraftBody([], vertices, faces, colors, states(1:3), states(7:9));
        % bff_h = drawBodyFixedFrame([], states(1:3), states(7:9));
        % vel_h = drawVelocityVector([], states(1:3), states(4:6));
        % osd_h = drawOSD([], states);

        title('Aircraft', 'FontSize',14, 'FontWeight','bold')
        % burada azimuth ve elevationa gore aciyi duzeltelim
        azel = [30, 30];
        xlabel("East"); ylabel("North");zlabel("Up");
        axis("equal");
        axis("vis3d");
        view(azel(1), azel(2))
    else
        drawAircraftBody(aircraft_h, vertices, faces, colors, states(1:3), states(7:9));
        % drawBodyFixedFrame(bff_h, states(1:3), states(7:9));
        % drawVelocityVector(vel_h, states(1:3), states(4:6));
        % drawOSD(osd_h, states);
    end
end

%% Helper Functions
function handle = drawAircraftBody(handle, Vertices_Nx3, Faces_Nx3, Colors_Nx3, ned_3x1, eul_ang_rad_3x1)
    Vertices_Nx3 = rotate2InertialZYX(Vertices_Nx3, eul_ang_rad_3x1);
    Vertices_Nx3 = translateInInertial(Vertices_Nx3, ned_3x1);
    R_NED2ENU = [0 1 0; 1 0 0; 0 0 -1];
    Vertices_Nx3 = Vertices_Nx3 * R_NED2ENU;

    if isempty(handle)
        handle = patch("Vertices", Vertices_Nx3, "Faces", Faces_Nx3, "FaceVertexCData", Colors_Nx3, ...
                        "FaceColor", "Flat");
    else
        set(handle, "Vertices", Vertices_Nx3, "Faces", Faces_Nx3);
        drawnow
    end
end

function handle = drawBodyFixedFrame(handle, com_inB_3x1, eul_ang_rad) % assuming fixed axis colors
    disp("I am drawBodyFixedFrame()")
end

function handle = drawOSD(handle, states)
    disp("I am drawOSD()")
end

function handle = drawVelocityVector(handle, v_inI_3x1)
    disp("I am drawVelocityVector()")
end

function [V, F, C] = createAircraft()
    MAV_structure = loadMavStructureParams();
    
    fuse_l1 = MAV_structure.fuse_l_1x3(1);
    fuse_l2 = MAV_structure.fuse_l_1x3(2);
    fuse_l3 = MAV_structure.fuse_l_1x3(3);
    
    fuse_h = MAV_structure.fuse_h;
    fuse_w = MAV_structure.fuse_w;
    
    wing_l = MAV_structure.wing_l;
    wing_w = MAV_structure.wing_w;
    
    tailwing_l = MAV_structure.tailwing_l;
    tailwing_w = MAV_structure.tailwing_w;
    tail_h = MAV_structure.tail_h;
    cg_percentage = MAV_structure.cg_wing_percentage;
    wing_x = wing_l * cg_percentage;
    
    
    fuse_w_half = fuse_w/2;
    fuse_h_half = fuse_h/2;
    wing_w_half = wing_w/2;
    tailwing_w_half = tailwing_w/2;
    
    
    V = [
        fuse_l1, 0, 0;... % Vertex 1
        fuse_l2, fuse_w_half, fuse_h_half;... % 2
        fuse_l2, -fuse_w_half, fuse_h_half;... % 3
        fuse_l2, -fuse_w_half, -fuse_h_half;...% ...
        fuse_l2, fuse_w_half, -fuse_h_half; ... 
        -fuse_l3, 0, 0;
        wing_x wing_w_half 0; ... % 7
        wing_x-wing_l wing_w_half 0; ...
        wing_x-wing_l (-wing_w_half) 0; ...
        wing_x -wing_w_half 0; ...
        (-fuse_l3+tailwing_l) tailwing_w_half 0;... % 11
        -fuse_l3 tailwing_w_half 0;... 
        -fuse_l3 -tailwing_w_half 0;...
        (-fuse_l3+tailwing_l) -tailwing_w_half 0;... 
        (-fuse_l3+tailwing_l) 0 0; ...
        -fuse_l3 0 -tail_h;
    ];
    
    F = [
        1 2 3 NaN; ... % Nose (Triangle - 4. sütun NaN)
        1 3 4 NaN; ... % Triangle
        1 4 5 NaN; ... % Triangle
        1 2 5 NaN; ... % Triangle
        3 4 6 NaN; ... % Body2tail (Triangle)
        4 5 6 NaN; ... % Triangle
        2 5 6 NaN; ... % Triangle
        2 3 6 NaN; ... % Triangle
        7 8 9 10; ... % Wing (Quad - 4 sütunun hepsi kullanıldı)
        11 12 13 14;...
        6 15 16 NaN;
    ];
    C = [
        0.5 .5 .5;  % Vertex 1
        0.5 .5 .5;  % 2
        0.5 .5 .5;  % 3
        0.5 .5 .5;  % 4
        0.5 .5 .5;  % 5
        0 1 0;  % 6
        0 1 0;  % 7
        0 1 0;  % 8
        0 1 0;  
        0 1 0;
        0 1 0;  % 11
        0 1 0;
        0 1 0;
        0 1 0;
        0 1 0;
        0 1 0;
    ];

end

%% Auxilary Functions
function vec_inI_Nx3 = rotate2InertialZYX(vec_inB_Nx3, eul_ang_rad)
    cphi = cos(eul_ang_rad(1));
    sphi = sin(eul_ang_rad(1));

    ctheta = cos(eul_ang_rad(2));
    stheta = sin(eul_ang_rad(2));

    cpsi = cos(eul_ang_rad(3));
    spsi = sin(eul_ang_rad(3));

    Rx = [1 0 0; 0 cphi -sphi; 0 sphi cphi];
    Ry = [ctheta, 0, stheta; 0 1 0; -stheta, 0, ctheta];
    Rz = [cpsi -spsi 0; spsi cpsi 0; 0 0 1];

    vec_inI_Nx3 = vec_inB_Nx3 * Rx' * Ry' * Rz';
end

function vec_inI_Nx3 = translateInInertial(vec_inI_Nx3_p, ned_3x1)
    d_ned = reshape(ned_3x1, 1,[]);
    vec_inI_Nx3 = vec_inI_Nx3_p + repmat(d_ned, size(vec_inI_Nx3_p, 1), 1);
end