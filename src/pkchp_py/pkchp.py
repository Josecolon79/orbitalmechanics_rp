import pykep as pk
import spiceypy as sp
import numpy as np
import matplotlib.pyplot as plt
import time

sp.kclear()
sp.furnsh('../SPKs/de438.bsp')
sp.furnsh('../SPKs/naif0009.tls')

# Inputs
start = time.time()
plot_output = 1
depbdy = '3'
arrbdy = '4'
ctrbdy = '0'
mu  = 1.32712*10**11
et1 = sp.str2et(['Jan 01, 2020', 'Dec 31, 2021'])
et2 = et1
num_of_Pts = 100
dvmaxd = 10
dvmaxa = 10

# Pull State Data
t = np.arange(0,num_of_Pts,1)*(et1[1]-et1[0])/num_of_Pts + et1[0]
pb1,_ = sp.spkezr(depbdy,t,'J2000','NONE',ctrbdy)
pb2,_ = sp.spkezr(arrbdy,t,'J2000','NONE',ctrbdy)

dt    = np.zeros((len(t),len(t)))
vimag = np.zeros((len(t),len(t)))
vfmag = np.zeros((len(t),len(t)))

# Itterative Lambert Calculation
# using [j][i] to prevent transposing output. [row][column]
for i in range(len(t)):
    for j in range(len(t)):
        dt[j][i] = t[j] - t[i]
        if dt[j][i] <= 0:
            vimag[j][i] = np.nan
            vfmag[j][i] = np.nan
        else:
            l = pk.lambert_problem(
                r1  = (pb1[i][0], pb1[i][1], pb1[i][2]),
                r2  = (pb2[j][0], pb2[j][1], pb2[j][2]),
                tof = dt[j][i],
                mu  = mu,
                max_revs = 1
            )
            dv1 =  np.subtract(l.get_v1()[0],(pb1[i][3],pb1[i][4],pb1[i][5]))
            vi_mag = np.linalg.norm(dv1)
            dv2 = np.subtract(l.get_v2()[0] , (pb2[j][3],pb2[j][4],pb2[j][5]))
            vf_mag = np.linalg.norm(dv2)

            # Keeping values that meet Vinf dep/arr threshold
            if vi_mag > dvmaxd:
                vimag[j][i] = np.nan
            else:
                vimag[j][i] = vi_mag

            if vf_mag > dvmaxa:
                vfmag[j][i] = np.nan
            else:
                vfmag[j][i] = vf_mag

# Convert ET Axis values to Calendar Dates
tcal = np.array([])
for i in range(len(t)):
    tcal = np.append(tcal,[sp.et2utc(t[i], 'C', 0)[:11]],axis=-1)
    dt[i] = dt[i]/86400

# Plotting Figure
if plot_output == 1:
    plt.figure(1)
    plt.title(sp.bodc2n(int(depbdy)) + " TO " + sp.bodc2n(int(arrbdy)) + "   | ballistic type 1,2 0 rev ")
    plt.xlabel(sp.bodc2n(int(depbdy)) + " Launch Date")
    plt.ylabel(sp.bodc2n(int(arrbdy)) + " Arrival Date")
    #vinfdep = plt.colorbar(plt.contourf(t1, t1, vimag))
    #vinfdep.ax.set_ylabel('Departure Vinf (km/s)')
    plt.clabel(plt.contour(t, t, vimag, colors='blue'))
    plt.clabel(plt.contour(t, t, vfmag, colors='black'))
    plt.clabel(plt.contour(t, t, dt, colors='red'))
    plt.xticks(t[0:-1:10], tcal[0:-1:10], rotation=90, fontsize=8)
    plt.yticks(t[0:-1:10], tcal[0:-1:10], fontsize=8)
    plt.grid()
    end = time.time()
    print(end - start)
    plt.show()
