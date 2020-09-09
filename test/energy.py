#!/bin/python

# Script 2/3

# This scripts performs basic statistical analysis and plots graphs of the fluctations of the instantaneous configurational and total energy of the system at every timestep.

###########
# MODULES #
###########

# Imports all the necessary modules.

import numpy as np
import matplotlib.pyplot as plt
from matplotlib.backends.backend_pdf import PdfPages

################
# DATA LOADING #
################

# Loads in the data extracted by the previous script (gogoconvergence.sh). 

config_energies = np.loadtxt('tmp/configenergies.out')
total_energies = np.loadtxt('tmp/totalenergies.out')

################
# TOTAL ENERGY #
################

# Performs basic statistical analysis of the instantaneous total energy of the system at every timestep and writes to the file "total_averages".

average_total = np.average(total_energies)
stdev_total = np.std(total_energies)
median_total = np.median(total_energies)

filename = "total_averages"
file = open(filename, 'w')

line_1 = ["The mean total energy of the system is ","", str(average_total) , "(kcal/mol):" '\n']
line_2 = ["The median total energy of the system is ","", str(median_total) , "(kcal/mol):" '\n']
line_3 = ["The standard deviation of the total energy of the system is ","", str(stdev_total) , "(kcal/mol):" '\n']

file.writelines(line_1),
file.writelines(line_2),
file.writelines(line_3)
file.close()

# Plots the instaneous total energy of the system at every timestep.
# does NOT show the graphs - uncomment #plt.show() to see the graphs.

time = np.genfromtxt('tmp/energy_timestep', dtype=None)

with PdfPages('total_energy.pdf') as pdf:
	 plt.plot(time,total_energies, linestyle='--', dashes=(1, 1), )

	 plt.xlabel('Time (ps)')
	 plt.ylabel('Total energy (kcal/mol)')

	 plt.legend(loc=2,frameon=False)
	 plt.tight_layout()


	 pdf.savefig()
	 #plt.show()
	 plt.close()

# Plots the a histogram of the instantaneous total energy of the system.
# does NOT show the graphs - uncomment #plt.show() to see the graphs.

with PdfPages('total_histogram.pdf') as pdf:
	 plt.hist(total_energies, bins=20, histtype='bar',rwidth=0.8)
	 plt.ylabel('Frequency')
	 plt.xlabel('Total energy (kcal/mol)')
	 plt.legend(loc=2,frameon=False)

	 plt.tight_layout()

	 pdf.savefig()
	 #plt.show()
	 plt.close()


##########################
# CONFIGURATIONAL ENERGY #
##########################

# Performs basic statistical analysis of the instantaneous configurational energy of the system at every timestep and writes to the file "config_averages".

average_config = np.average(config_energies)
stdev_config = np.std(config_energies)
median_config = np.median(config_energies)

filename = "config_averages"
file = open(filename, 'w')

line_1 = ["The mean configurational energy of the system is ","", str(average_config) , "(kcal/mol):" '\n']
line_2 = ["The median configurational energy of the system is ","", str(median_config) , "(kcal/mol):" '\n']
line_3 = ["The standard deviation of the configurational energy of the system is ","", str(stdev_config) , "(kcal/mol):" '\n']

file.writelines(line_1),
file.writelines(line_2),
file.writelines(line_3)
file.close()

# Plots the instantaneous configurational energy of the system at every timestep.
# does NOT show the graphs - uncomment #plt.show() to see the graphs.

time = np.genfromtxt('tmp/energy_timestep', dtype=None)
#mass_den = np.genfromtxt('mass_density', dtype=None)

with PdfPages('configurational_energy.pdf') as pdf:
	 plt.plot(time,config_energies, linestyle='--', dashes=(1, 1), )

	 plt.xlabel('Time (ps)')
	 plt.ylabel('Configurational energy (kcal/mol)')

	 plt.legend(loc=2,frameon=False)
	 plt.tight_layout()


	 pdf.savefig()
	 #plt.show()
	 plt.close()

# Plots a histogram of the instantaneous configurational energy of the system.
# does NOT show the graphs - uncomment #plt.show() to see the graphs.

with PdfPages('config_histogram.pdf') as pdf:
	 plt.hist(config_energies, bins=20, histtype='bar',rwidth=0.8)

	 plt.ylabel('Frequency')
	 plt.xlabel('Configurational energy (kcal/mol)')
	 plt.legend(loc=2,frameon=False)

	 plt.tight_layout()
	 pdf.savefig()
	 #plt.show()
	 plt.close()

