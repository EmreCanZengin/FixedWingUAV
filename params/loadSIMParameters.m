function SIM = loadSIMParameters()
    SIM.StopTime = 500;
    SIM.FixedStepSize = 0.01;
    SIM.IntegratorSamplingTime = 0.01; % Determined according to the fastest mode (rolling mode)
end