# Installation and Setup Guide

## System Requirements

### Hardware Requirements
- **Processor**: Intel Core i5 or equivalent (minimum)
- **RAM**: 8 GB (minimum), 16 GB (recommended)
- **Storage**: 5 GB free space
- **Display**: 1920x1080 resolution (minimum)

### Software Requirements
- **MATLAB**: R2024b or later
- **Simulink**: Latest version
- **Simscape Electrical**: Latest version
- **Specialized Power Systems**: Latest version
- **Windows/Mac/Linux**: Latest stable version

## Installation Steps

### Step 1: Clone the Repository
```bash
git clone https://github.com/Abdirahmancfc/Power-Quality-Conditioning-System.git
cd Power-Quality-Conditioning-System
```

### Step 2: Verify MATLAB Version
Open MATLAB and verify installation:
```matlab
ver  % Check version
```
Output should show: **MATLAB R2024b**

### Step 3: Verify Required Toolboxes
```matlab
% Check Simulink
which simulink

% Check Simscape Electrical  
which simscape

% Check if toolboxes are installed
license('inuse')
```

### Step 4: Add Project to MATLAB Path
```matlab
cd('C:/path/to/Power-Quality-Conditioning-System')  % Windows
% or
cd('/path/to/Power-Quality-Conditioning-System')    % Mac/Linux

addpath(genpath(pwd))
savepath
```

### Step 5: Initialize System
```matlab
initialize
```
You should see:
```
[INIT] Loading system configuration...
[PARAM] Setting grid parameters...
[PARAM] Setting transformer parameters...
...
[INIT] ✓ System parameters initialized successfully
```

### Step 6: Launch Application
```matlab
main
```
This will:
1. Clear all variables and close all figures
2. Initialize system parameters
3. Launch the GUI application

## Verification

To verify successful installation:

1. **Check script files**
   ```matlab
   which calculateTHD
   which calculatePF
   which runSimulation
   ```

2. **Verify models exist**
   ```matlab
   exist('Models/Main_PQCS_Model.slx', 'file')
   ```

3. **Test initialization**
   ```matlab
   clear all
   initialize
   whos params
   ```

4. **Quick test**
   ```matlab
   % Generate test signal
   t = 0:1e-6:0.1;
   v = 230*sqrt(2)*sin(2*pi*50*t);
   
   % Calculate THD
   [THD, harmonics, fundamental] = calculateTHD(v, 1e6);
   fprintf('THD: %.2f%%\n', THD);
   ```

## Troubleshooting Installation

### Problem: "Cannot find toolbox"
**Solution**: 
- Use MATLAB Add-Ons to install missing toolboxes
- Or run: `matlabInstaller` (Windows)

### Problem: "Path issues"
**Solution**:
```matlab
restoredefaultpath
addpath(genpath('C:/your/project/path'))
savepath
```

### Problem: "GUI won't open"
**Solution**:
- Verify App Designer is installed
- Check: `which appdesigner`
- Create GUI manually if needed

### Problem: "Simulink models won't load"
**Solution**:
- Update Simulink library cache: `slupdate`
- Rebuild cache: `simulink('refresh')`
- Verify model files exist in Models/ folder

## After Installation

1. **Review Documentation**
   - Read README.md for project overview
   - Check QUICKSTART.md for first steps
   - Review TECHNICAL.md for details

2. **Run Examples**
   ```matlab
   cd Examples
   Example_1_VoltageSag  % Run first example
   ```

3. **Generate Test Simulation**
   ```matlab
   params = systemParameters();
   params.t_final = 1;  % 1 second simulation
   [simout, time] = runSimulation(params);
   ```

## Next Steps

1. Launch the application: `main`
2. Read the User Guide: `QUICKSTART.md`
3. Run example scenarios in Examples/ folder
4. Create your own analysis
5. Generate reports

## Support

For issues:
1. Check existing documentation
2. Review code comments
3. Test with simpler parameters
4. Check MATLAB version compatibility

---
**Last Updated**: 2026-06-26  
**MATLAB Version**: R2024b  
**Status**: ✓ Verified
