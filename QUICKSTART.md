%% ========================================================================
% DOCUMENTATION - QUICK START GUIDE
% ========================================================================
%
% POWER QUALITY CONDITIONING SYSTEM
% Bachelor Thesis Project
% MATLAB R2024b
%
% QUICK START GUIDE
%
% ========================================================================

QUICK START - 5 MINUTES

1. INSTALLATION
   =============
   a) Extract the project folder
   b) Open MATLAB
   c) Navigate to project directory
   d) Type: main
   e) Press Enter

2. FIRST RUN
   ==========
   The main script will:
   - Initialize all system parameters
   - Load the GUI application
   - Display the user interface

3. USING THE GUI
   ===============
   Tab 1: Home
      - View system status and indicators
      - Check power quality metrics
   
   Tab 2: Simulation
      - Select disturbance type
      - Set disturbance parameters
      - Run simulation
   
   Tab 3: PQ Problems
      - Choose specific power quality issues
      - Enable/disable individual problems
   
   Tab 4: Mitigation
      - Select compensation device
      - Configure device parameters
   
   Tab 5: Measurements
      - View calculated metrics
      - Check compliance status
   
   Tab 6: Oscilloscope
      - Real-time waveform display
      - 8 synchronized windows
   
   Tab 7: FFT
      - Frequency spectrum analysis
      - Harmonic content display
   
   Tab 8: Results
      - Performance comparison
      - Export results

4. EXAMPLE WORKFLOWS
   ==================
   
   Workflow 1: Analyze Voltage Sag
   ================================
   a) Go to "Simulation" tab
   b) Select "Voltage Sag" from dropdown
   c) Set sag depth to 30%
   d) Click "Run"
   e) View results in "Oscilloscope" tab
   f) Check THD in "FFT" tab
   g) Select "DVR" in "Mitigation" tab
   h) Click "Run" again
   i) Compare results
   
   Workflow 2: Harmonic Analysis
   ============================
   a) Go to "Simulation" tab
   b) Select "Harmonics" from dropdown
   c) Set harmonic orders: 5, 7, 11, 13
   d) Click "Run"
   e) Go to "FFT" tab to see spectrum
   f) Select "Active Filter" in "Mitigation"
   g) Run compensation
   h) Compare before/after
   
   Workflow 3: Motor Starting Analysis
   ===================================
   a) Go to "Simulation" tab
   b) Select "Motor Start" from dropdown
   c) Set motor size: 5 kW
   d) Click "Run"
   e) View inrush current in oscilloscope
   f) Try "STATCOM" compensation
   g) Observe voltage stabilization

5. KEYBOARD SHORTCUTS
   ===================
   Ctrl+R     : Run simulation
   Ctrl+S     : Save results
   Ctrl+L     : Load results
   Ctrl+E     : Export to PDF
   Ctrl+C     : Clear results
   Ctrl+Q     : Quit application

6. OUTPUT FILES
   =============
   Simulation Results    : Data/simulation_results_*.mat
   Generated Figures     : Reports/Figures/*.png
   PDF Reports           : Reports/*.pdf
   
7. TROUBLESHOOTING
   ================
   Problem: GUI doesn't open
   Solution: Check MATLAB version (R2024b required)
             Verify App Designer installed
             Run: initialize; PowerQualityApp;
   
   Problem: Simulation runs slowly
   Solution: Reduce simulation time step in settings
             Decrease FFT resolution
             Use faster computer
   
   Problem: No figures generated
   Solution: Check Reports/Figures folder exists
             Run: mkdir('Reports/Figures')
             Try: plotResults(time, voltage, current, harmonics, PF, THD)

8. HELP AND DOCUMENTATION
   =======================
   Type in MATLAB command window:
   - help main                    : Help on main script
   - help initialize              : Help on initialization
   - help calculateTHD            : Help on THD calculation
   - help runSimulation           : Help on simulation runner
   - help PowerQualityApp         : Help on GUI

9. CONTACT & SUPPORT
   ==================
   For issues or questions:
   - Check documentation in README.md
   - Review inline code comments
   - See TECHNICAL.md for details
   - Check examples in Examples/ folder

========================================================================
For detailed information, see README.md and other documentation files.
========================================================================
