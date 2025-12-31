function h = plotterStatesUpdate(h, states, time)
    h.pos = plotterPositionUpdate(h.pos, states(1:3), time);
    h.vel = plotterVelocityUpdate(h.vel, states(4:6), time);
    h.att = plotterAttitudeUpdate(h.att, states(7:9), time);
    h.ang_rate = plotterAngularRateUpdate(h.ang_rate, states(10:12), time);
end