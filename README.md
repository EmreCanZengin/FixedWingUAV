# MAVSim

This repository contains a MATLAB/Simulink implementation of concepts from Randal W. Beard and Timothy W. McLain's book *Small Unmanned Aircraft: Theory and Practice*. It reflects a personal project in which system modeling, trimming, autopilot design, sensor modeling, and state estimation are implemented and tested in MATLAB and Simulink.

## Project Scope

The main focus of this codebase is to apply and validate key UAV concepts from the Beard & McLain text using MATLAB and Simulink. The implementation covers:

- Aircraft system modeling
- Trim point computation
- Autopilot design and tuning
- Sensor modeling
- State estimation

Some later components are still incomplete and under active development.

## Repository Structure

- `chapter2/` - Visualization and basic simulation assets
- `chapter3/` - Dynamic model implementation
- `chapter4/` - Additional Simulink models and trim infrastructure
- `chapter5/` - Autopilot design and system analysis scripts
- `chapter6/` - Discrete autopilot implementation and further simulation
- `params/` - Parameter loading scripts for MAV and simulation models
- `plotter/` - Simulation data extraction and plotting utilities
- `Setup.m` - Project initialization script
- `Trim_model.slxc` / `Chapter7.slxc` - Simulink compiled models and saved snapshots

## Key Components

### System Modeling
The codebase includes the core MAV system model from the textbook. It captures the equations of motion and aerodynamic parameters needed for simulation and control design.

### Trimming
Trim point computation is implemented to find steady-state flight conditions. The project includes scripts and Simulink models used to solve for trimmed flight conditions.

### Autopilot Design
Autopilot design is developed using the principles from Beard & McLain. This includes control law implementation, gain tuning, and discrete-time autopilot support.

### Sensor Modeling
Sensor modeling is included to simulate realistic avionics behavior, including measurement generation for navigation and attitude estimation.

### State Estimation
State estimation is implemented to fuse sensor data and estimate the MAV state during simulation.

## Usage

1. Open the main project folder in MATLAB.
2. Run `Setup.m` to initialize paths and parameters.
3. Explore the chapter folders to run simulations and view model implementations.

## Notes

- This repository is a self-study implementation of Beard & McLain's UAV theory.
- Later sections are partially complete, especially in the final chapters, and may require additional work for a fully polished UAV simulation framework.
- Files with `.slxc` extensions are saved Simulink model snapshots and may be used for reference or re-opening in Simulink.

## Acknowledgements

Based on concepts from:

- Randal W. Beard and Timothy W. McLain, *Small Unmanned Aircraft: Theory and Practice*.

---

If you want, I can also add a `Getting Started` section with specific scripts to run for each chapter.