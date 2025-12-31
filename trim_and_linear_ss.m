clear; clc;format long;
run("Setup.m")

MODEL_NAME = "Trim_model";
%% Trimming
% fixed
Va_trim = 10;
beta_trim = 0;
R_trim = Inf;

% variable
% gamma = 10 * pi / 180;
gamma = 0;


x0 = [0;0;0;Va_trim; 0; 0;0; gamma;0;0;0;0];
ix0 = [];
u0 = [0;0;0;1];
iu0 = [];
y0 = [Va_trim; gamma; beta_trim];
iy0 = []; 
dx0 = [0;0; -Va_trim * sin(gamma); 0;0;0;0;0;0;0;0;0];
if (R_trim ~= Inf && R_trim ~= 0)
    dx0(9) = Va_trim / R_trim;
elseif (R_trim == Inf)
    dx0(9) = 0;
else
    warning("R_trim cannot be 0, assuming it is meant to be Inf")
end   
idx0 = (3:12);

% Trim fonksiyonunu çağır
[x, u, y, dx] = trim(MODEL_NAME, x0, u0, y0, ix0, iu0, iy0, dx0, idx0);

% setting initial states
init_states(4:end) = x(4:end);

%% Linear State-Space Model Extraction
