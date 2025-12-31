function drawSpacecraft(uu)
    % it will update the spacecraft body properties which are dynamic
    % It will call `drawSpacecraftBody()` function to clear and draw the
    % spacecraft with changed properties.
    persistent spacecraft_handle;
    persistent V;
    persistent F;
    persistent C; 
    persistent osd_handle;

    osd_text = sprintf(...
            'Time: %.2f s\n\nN: %.2f m\nE: %.2f m\nD: %.2f m\n\nRoll (phi): %.1f deg\nPitch (th): %.1f deg\nYaw (psi): %.1f deg', ...
            uu(13), uu(2), uu(1), uu(3), rad2deg(uu(7)), rad2deg(uu(8)), rad2deg(uu(9)) ...
        );

    if uu(end) == 0
        figure(1), clf;
        [V, F, C] = defineSpacecraftBody();
        spacecraft_handle = drawSpacecraftBody([], V, F, C, uu(1:3), uu(7:9));

        title('Spacecraft')
        xlabel("East"); ylabel("North");zlabel("Up");
        axis("vis3d");
        hold on;
        osd_handle = annotation('textbox', [0.02, 0.65, 0.2, 0.25], ...
                                'String', osd_text, ...
                                'FitBoxToText', 'on', ...
                                'BackgroundColor', 'white',...
                                'EdgeColor', 'black');
        view(30, 20);

    else
        drawSpacecraftBody(spacecraft_handle, V, F, C, uu(1:3), uu(7:9));
        set(osd_handle, 'String', osd_text);
    end

end

%% Helper Functions
function handle = drawSpacecraftBody(handle, V, F, patchcolors, ...
                            ned_3x1, eul_ang_rad)
    % It will draw the spacecraft body for given properties.
    V = rotateZYX2Inertial(V, eul_ang_rad);
    V = translateInInertial(V, ned_3x1);
    NED2ENU = [0 1 0; 1 0 0; 0 0 -1];
    V = V * NED2ENU;

    if isempty(handle)
        handle = patch("Vertices", V, "Faces", F, "FaceVertexCData", patchcolors, ...
                        "FaceColor", 'flat');
        view(3)
    else
        set(handle, "Vertices", V, "Faces", F);
        drawnow
    end


end

function [V, F, colors] = defineSpacecraftBody()
    % It will define the spacecraft body properties.
    % How should we define a shape
    % vortices, faces, colors of faces
    % Define the vertices (physical location of vertices
    V = [...
        1    1    0;... % point 1
        1   -1    0;... % point 2
        -1   -1    0;... % point 3
        -1    1    0;... % point 4
        1    1   -2;... % point 5
        1   -1   -2;... % point 6
        -1   -1   -2;... % point 7
        -1    1   -2;... % point 8
        1.5  1.5  0;... % point 9
        1.5 -1.5  0;... % point 10
        -1.5 -1.5  0;... % point 11
        -1.5  1.5  0;... % point 12
    ];

    % define faces as a list of vertices numbered above
    F = [...
        1, 2,  6,  5;...  % front
        4, 3,  7,  8;...  % back
        1, 5,  8,  4;...  % right 
        2, 6,  7,  3;...  % left
        5, 6,  7,  8;...  % top
        9, 10, 11, 12;... % bottom
        ];

    % define colors for each face    
    myred = [1, 0, 0];
    mygreen = [0, 1, 0];
    myblue = [0, 0, 1];
    myyellow = [1, 1, 0];
    mycyan = [0, 1, 1];

    colors = [...
        myred;...    % front
        mygreen;...  % back
        myblue;...   % right
        myyellow;... % left
        mycyan;...   % top
        mycyan;...   % bottom
        ];
end

%% Auxilary Functions
function vec_inI_Nx3 = rotateZYX2Inertial(vec_inB_Nx3, eul_ang_rad)
    % we will not consider the rotation order here in this case
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