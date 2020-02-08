# Orbital Mechanics/SMD MATLAB and Python Code
C: 31DEC19 LM: 07FEB20

## Function/Script Demos
http://rohandpatel.com/projects/orbital-mechanics-library-for-matlab-and-python/
_______________________________________________________________________________________
## Compatibility and Installation
Tested on Windows and UNIX (MacOS). Modifications for compatibility are not required. Python: Spicepy and Pykep libraries are required. \
\
Clone the directory. \
\
Most of the files require the NAIF CSPICE toolkit to be installed. Download the 'mice.zip' file [HERE](https://naif.jpl.nasa.gov/naif/toolkit_MATLAB.html) and extract its contents to: orbitalmechanics_rp/MICE/ \
\
The de438.bsp planetary kernel file is required. Download it [HERE](https://naif.jpl.nasa.gov/pub/naif/generic_kernels/spk/planets/) and copy/paste it to: orbitalmechanics_rp/src/SPKs \
\
**RUNNING** add <yourpath>/orbitalmechanics_rp to the MATLAB path and make sure to include all files and subfolders.


_______________________________________________________________________________________
## Main Functions
	1. l0() 		Lambert Fit (Gooding Alg.)(Uses David Eagle's MATLAB code *see below*)
	2. tbp()		Two Body Propagator
	3. plotOrbGeneric()	Generic Orbit State Data Visualization
	4. execError()		Execution Error for DeltaVs Calculator (to 3sigma)
_______________________________________________________________________________________
## Scripts
	1. executionerrors.m		Propagation of random generated execution errors within std. dev. limits
	2. dev_testl0.m			Lambert DV given SPICE body inputs
	3. LV_perf.m			Launch Vehicle Energy vs. Mass Delivered for Interplanetary Trajectories
	4. pkchp_plotter.m		Porkchop Plotter using Lambert Arcs and CSPICE data
	5. pkchp.py			(PYTHON) Porkchop Plotter using the Spiceypy wrapper for SPICE
	6. twobodyprop_solar.m		Heliocentric 2BP example (uses data from CSPICE bodies)
	7. twobodyprop.m		Earth centered 2BP example using conventional r and v.
	8. dev_orbfromspk.m		Plotting SPICE .bsp bodies using vis code
	9. dev_pltAnd2bpintegration.m	Using 2BP to create trajectory and plotting with vis code
_______________________________________________________________________________________
## Function Details

### 1. Lambert Fit (Gooding Alg.)
/src/lambert/l0.m

        Calculates a single lambert arc fit DeltaV values
 
         Input [fixed number of inputs / no error checking]:
            dataflag = Flag For Requested Data Output
            p1       = Departure State [6x1] array [x,y,z,vx,vy,vz]
            p2       = Arrival State [6x1] array [x,y,z,vx,vy,vz]
            tof      = Time of Flight [1x1] double in seconds
            mu       = Gravitational Parameter of Central body (km^3/s^2)
 
         Output Conditions:
            if dataflag == 1
                l1result(1) = DeltaV_dep mag   
                l1result(2) = DeltaV_arr mag
 
            if dataflag == 2
                l1result(1,:) = [deltaVx, deltaVy, deltaVz] @ Departure
                l1result(2,:) = [deltaVx, deltaVy, deltaVz] @ Arrival
                l1result(1,:) = [x, y, z] @ Departure
                l1result(2,:) = [x, y, z] @ Arrival
                l1result(1,:) = [Vx, Vy, Vz] @ Departure
                l1result(2,:) = [Vx, Vy, Vz] @ Arrival
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

### 2. Two Body Propagator
/src/twobodyprop/tbp.m

    A simple two body propagator using ODE45
 
    The tbp function uses variable inputs begining in the numbered order
    below.
 
    Inputs (Minimum: 2, Maximum: 5 inputs):
        1. x : [6x1] State vector in km and km/s [x;y;z;vx;vy;vz]
        2. tf: Integration stop time (assumes ti=0 seconds unless specified)
        3. mu: Central body gravitational parameter in km^3/s^2
        4. ti: Integration start time (in seconds) if non-zero
        5. options: ODE45 integration options
        
    Outputs an array called "state" with columns:
        1. x (km)
        2. y (km)
        3. z (km)
        4. vx (km/s)
        5. vy (km/s)
        6. vz (km/s)
        7. t (physical time in seconds)
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

### 3. Generic Orbit State Data Visualization
/src/visualization/plotOrbGeneric.m

    Inputs:
        ft = Title of Figure (string)
        'bdy' = Body Name (string)
        state = array containing state data (collums of X, Y, Z data)
                 (:,1) = x component
                 (:,2) = y component
                 (:,3) = z component
 
        Repeat 'bdy' and state for however many bodies that need to be
        plotted.
        
    Outputs:
        figure(#)

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

### 4. Execution Error for DeltaVs Calculator (up to 3sigma)
/src/execErrors/execErrors.m

 execError Creates Error Delta Values Given a Velocity Vector
 
    This is only calculates the ERRORS! Not the final DV Vector!
    Assumes deterministic position vector.
 
    Inputs: varargin
        1. (REQ.) flag = 1 or 0
        2. (REQ.) velocity vector = [1x3] or [3x1] or [1x1]
        3.        3sigma % Value expressed as a decimal
        4.        #ofSamples/Sigma (Total Samples = this number*3)
 
    Output: R Matrix
        (:,1:4)  = 3 Sigma x,y,z,mag
        (:,5:8)  = 2 Sigma x,y,z,mag
        (:,9:12) = 1 Sigma x,y,z,mag
 
_______________________________________________________________________________________

### 5. Porkchop Plotter using Lambert Arcs and CSPICE data
/src/pkchp_matlab/pkchp_plotter.m

**Requires CSPICE** \
**CREDIT TO: David Eagle for the Gooding Lambert Solver** \
David Eagle's lambert functions located in /src/lambert/lambert_source/ are provided, but note they originally from: \
https://www.mathworks.com/matlabcentral/fileexchange/39530-lambert-s-problem \


	Creates a contour plot of departure and arrival DeltaVs based on Lambert fits
	of type I and II trajectories that are less than 1 revolution. 
 
	Inputs: 
	   plt = (1 - ON) Display the contour plot result 
	   depbdy = Departure body SPICE ID (1x1) string 
	   arrbdy = Arrival body SPICE ID (1x1) string 
	   Default Center Body = 0 (Sun) 
	   mu = Gravitational Constant of Center Body (km^3/s^2) (default is Sun) 
	   et1 = Dep./Arr. Date pair in calendar format 'Mmm DD, YYYY' 
	   num_of_Pts = number of sampled epochs between the et1 bounds. 
	   dvmaxd = Maximum DeltaV magnitude for the departure. 
	   dvmaxa = Maximum DeltaV magnitude for the arrival. 

	Outputs: 
	   Contour Plot with:
		1. Departure DeltaV Magnitude 
		2. Arrival DeltaV Magnitude 
		3. Time of Flight in Days 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
