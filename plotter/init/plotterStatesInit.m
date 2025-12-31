function h = plotterStatesInit()
    h = struct();
    h.pos = plotterPositionInit();
    h.vel = plotterVelocityInit();

    h.att = plotterAttitudeInit();
    h.ang_rate = plotterAngularRateInit();
end