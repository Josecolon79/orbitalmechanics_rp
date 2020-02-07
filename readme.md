Orbital Mechanics and SMD MATLAB/Python Code
C: 31DEC19 LM: 07FEB20

_______________________________________________________________________________________

Source_Common Functions/Scripts:
	1. l0() 		Lambert Fit (Gooding Alg.)
	2. pkchp_plotter.m	Porkchop Plotter using Lambert Arcs and CSPICE data
	3. tbp()		Two Body Propagator
	4. plotOrbGeneric()	Generic Orbit State Data Visualization
	5. execErrors()		Execution Error for DeltaVs Calculator (up to 3sigma)
_______________________________________________________________________________________

Function Details:

1. Lambert Fit (Gooding Alg.)
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

2. Porkchop Plotter using Lambert Arcs and CSPICE data
/src/pkchp_plotter/pkchp_plotter.m

**Requires CSPICE***
**Requires David Eagle's Lambert Code***

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

3. Two Body Propagator
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

4. Generic Orbit State Data Visualization
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

5. Execution Error for DeltaVs Calculator (up to 3sigma)
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
