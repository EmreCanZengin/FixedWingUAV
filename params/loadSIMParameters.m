function SIM = loadSIMParameters()
    SIM.StopTime = 100;
    SIM.FixedStepSize = 0.001;
    SIM.IntegratorSamplingTime = 0.01; % Determined according to the fastest mode (rolling mode)
end