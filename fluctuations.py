#!/bin/python

# Script 3/3

# This scripts performs basic statistical analysis and plots graphs of the fluctations of the instantaneous temperature and pressure of the system at every timestep.

###########
# MODULES #
###########

# Imports the necessary modules

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

################
# DATA LOADING #
################

# Loads in the data extracted by the previous script (gogoconvergence.sh)

temp = np.genfromtxt('tmp/temperature', dtype=None)
press = np.genfromtxt('tmp/pressure', dtype=None)
time = np.genfromtxt('tmp/fluct_timesteps', dtype=None)

###############
# TEMPERATURE #
###############

# Performs basic statistical analysis of the instantaneous temperature of the system at every timestep, and writes to the file "temperature_change".

avtemp = np.average(temp)
stdtemp = np.std(temp)

avpress = np.average(press)
stdpress = np.std(press)

filename = "temperature_change"
file = open(filename, 'w')

line_3 = ["The temperature of the system is ","", "(K):" '\n']
file.writelines(line_3),

line_4 = [str(avtemp),"(+/-)", str(stdtemp)]
file.writelines(line_4),

file.close()

# Plots the instantaneous temperature of the system at every timestep.
# does NOT show the graphs - uncomment #plt.show() to see the graphs.

with PdfPages('Temperature.pdf') as pdf:
            plt.plot(time,temp, linestyle='--', dashes=(1, 1), )

            plt.xlabel('Time (ps)')
            plt.ylabel('Temperature (K)')

            plt.legend(loc=2,frameon=False)
            plt.tight_layout()


            pdf.savefig()
            #plt.show()
            plt.close()


############
# PRESSURE #
############

# Performs basic statistical analysis of the instantaneous pressure of the system at every timestep and writes to the file "pressure_change".

filename = "pressure_change"
file = open(filename, 'w')

line_5 = ["The pressure of the system is ","", "(kAtm):" '\n']
file.writelines(line_5),

line_6 = [str(avpress),"(+/-)", str(stdpress)]
file.writelines(line_6),

file.close()

# Plots the instantaneous pressure of the system at every timestep.
# does NOT show the graphs - uncomment #plt.show() to see the graphs.

with PdfPages('Pressure.pdf') as pdf:
	    plt.plot(time,press, linestyle='--', dashes=(1, 1), )

	    plt.xlabel('Time (ps)')
	    plt.ylabel('Pressure (kAtm)')

	    plt.legend(loc=2,frameon=False)
	    plt.tight_layout()

	  
	    pdf.savefig()
	    #plt.show()    
plt.close()


