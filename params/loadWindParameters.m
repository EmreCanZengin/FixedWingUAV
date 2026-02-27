function WIND = loadWindParameters()
    WIND = struct();
    WIND.Dryden.seed_u = 1234;
    WIND.Dryden.seed_v = 4545;
    WIND.Dryden.seed_w = 9999;
    WIND.Dryden.Va_at6m = 15; % It was default value in matlab block
    WIND.Dryden.dir_at6m_deg = 0; % 0: Front, 90: Left


% According to the book and moderate model at h=50m
    % WIND.Dryden.Lu = 200;
    % WIND.Dryden.sigma_u = 2.12;
    
    % WIND.Dryden.Lv = 200;
    % WIND.Dryden.sigma_v = 2.12;

    % WIND.Dryden.Lw = 50;
    % WIND.Dryden.sigma_w = 1.4;

    % WIND.Dryden.Pu = 1;
    % WIND.Dryden.Pv = 1;
    % WIND.Dryden.Pw = 1; 

    % s = tf("s");

    % WIND.Dryden.Hus = WIND.Dryden.sigma_u * sqrt(2 * Va / WIND.Dryden.Lu) / (s + Va / WIND.Dryden.Lu);
    % WIND.Dryden.Hvs = WIND.Dryden.sigma_v * sqrt(3 * Va / WIND.Dryden.Lv) * ...
    %  (s + Va / (sqrt(3) * WIND.Dryden.Lv))/ (s + Va / WIND.Dryden.Lv)^2;

    % WIND.Dryden.Hws = WIND.Dryden.sigma_w * sqrt(3 * Va / WIND.Dryden.Lw) * ...
    %  (s + Va / (sqrt(3) * WIND.Dryden.Lw))/ (s + Va / WIND.Dryden.Lw)^2;   

end