#!/bin/bash

# Script 1/3 

#This bundle of scripts aims to help determine whether or not a given DL_POLY simulation has converged.
#This bundle of scripts is a combination of a number of previous scripts which were specifically designed to characterise cellulose.

# This script extracts the necessary information, calls the analysis scripts and tidies up after them.

rm -rf ./data/
rm -rf ./tmp/
rm -rf ./convergence

mkdir ./tmp/
mkdir ./convergence

gunzip CONTROL.gz
gunzip FIELD.gz
gunzip STATIS.gz
gunzip OUTPUT.gz

cp <PATH>/visualise_convergence/{*sh,*py} .


##########
# ENERGY #
##########

#This part of the script extracts the instantaneous configurational and total energy of the system at every timestep from the DL_POLY STATIS file.

#Finds a "landmark" within the STATIS file - in this case it is the number at the end of line 3 (the number of array elements).

x=$(grep -A1 "ENERGY UNITS" STATIS | grep -v "ENERGY UNITS" | awk '{ print $(NF)}' | head -1 )

#Uses this landmark to locate the configurational energy

grep -A1 -w  "$x"  STATIS | grep -v -w $x | grep -v "^--*$" | awk '{print $3}' >> ./tmp/configenergies.out
grep -A1 -w  "$x"  STATIS | grep -v -w $x | grep -v "^--*$" | awk '{print $1}' >> ./tmp/totalenergies.out
grep -w  "$x"  STATIS | awk '{print $1}' >> ./tmp/energy_timestep

###############
# TEMPERATURE #
###############

#This part of the script extracts the instantaneous temperature of system at every timestep from the DL_POLY OUTPUT file, as well as the number and frequency of the timesteps used from the CONTROL file.

grep "rolling" OUTPUT | awk '{print $(NF-7)}' >> ./tmp/temperature

steps=$(grep "steps" CONTROL | awk '{print $(NF=2);}')
resol=$(grep "print" CONTROL | grep -v "print rdf" |awk '{print $(NF=2)}')
num=$((steps / resol)) # calculates the number of time steps 

for ((i=0; i<=steps; i+=resol)); do
   echo "$i" >> ./tmp/fluct_timesteps
done

############
# PRESSURE #
############

#This part of the script extracts the instantaneous pressure of the system at every timestep from the DL_POLY OUTPUT file.

grep -A1 "averages" OUTPUT | grep -v "averages" | awk '{print $(NF-0)}'| grep -v "^--*$" >> ./tmp/pressure

##########
# VOLUME #
##########

#This part of the script extracts the instantaneous volume of the system at every timestep from the DL_POLY STATIS file.

y=$(grep -A1 "ENERGY UNITS" STATIS | grep -v "ENERGY UNITS" | awk '{ print $(NF)}' | head -1 )

grep -w -A4 $y STATIS | grep -v -w $y | grep -v -- "^--$" >> parameters

###########
# DENSITY #
###########

# This part of the script extracts the number of molecules and the number of atoms within the system from the DL_POLY FIELD file.

nummols=$(grep -m 1 "nummols" FIELD | awk '{ print $(NF)}')
atoms=$(grep -m 1 "atoms" FIELD | awk '{ print $(NF)}')

echo $nummols $atoms >> molecule_info


z=$(grep -A1 "ENERGY UNITS" STATIS | grep -v "ENERGY UNITS" | awk '{ print $(NF)}' | head -1 )

grep -w $z STATIS | awk '{print $(NF-2)}' >> ./tmp/timestep

##################
# PYTHON SCRIPTS #
##################

# This part of the script calls the other scripts which are used to perform analysis of the system properties.

python ./energy.py
python ./fluctuations.py

############
# CLEAN UP #
############

# This part of the script tidies all the relevant info away and deletes any unneeded temporary files.

mkdir data
mv *_change ./data
mv *_averages ./data
mv density ./data
mv molecule_info ./tmp
mv parameters ./tmp

mkdir plots
mv *.pdf ./plots
mv ./plots ./data/


mkdir scripts
mv *.sh ./scripts
mv *.py ./scripts

mv ./scripts ./convergence
mv ./plots ./convergence
mv ./data ./convergence
