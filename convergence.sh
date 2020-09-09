#!/bin/bash

#This script aims to determine whether a simulation has converged.
#This script is a combination of a number of previous scripts which characterise cellulose.

gunzip CONTROL.gz
gnuzip FIELD.gz

rm -rf ./data/
rm -rf ./tmp/
rm -rf ./convergence

mkdir ./tmp/
mkdir ./convergence

########
#ENERGY#
########

#This first part of the script calculates and plots the configurational and total energy of the system from the DL_POLY OUTPUT file.

#Finds a "landmark" in this case it is the number at the end of line 3 (the number of array elements)
x=$(grep -A1 "ENERGY UNITS" STATIS | grep -v "ENERGY UNITS" | awk '{ print $(NF)}')

#Uses this landmark to locate the configurational energy

grep -A1 -w  "$x"  STATIS | grep -v -w $x | grep -v "^--*$" | awk '{print $3}' >> ./tmp/configenergies.out
grep -A1 -w  "$x"  STATIS | grep -v -w $x | grep -v "^--*$" | awk '{print $1}' >> ./tmp/totalenergies.out
grep -w  "$x"  STATIS | awk '{print $1}' >> ./tmp/energy_timestep

#############
#TEMPERATURE#
#############

grep "rolling" OUTPUT | awk '{print $(NF-7)}' >> ./tmp/temperature

steps=$(grep "steps" CONTROL | awk '{print $(NF=2);}')
resol=$(grep "print" CONTROL | grep -v "print rdf" |awk '{print $(NF=2)}')
num=$((steps / resol))

for ((i=0; i<=steps; i+=resol)); do
   echo "$i" >> ./tmp/fluct_timesteps
done

##########
#PRESSURE#
##########

grep -A1 "averages" OUTPUT | grep -v "averages" | awk '{print $(NF-0)}'| grep -v "^--*$" >> ./tmp/pressure

########
#VOLUME#
########

#This is a script which passes information from the simulation files to the python script to analyse it

y=$(grep -A1 "ENERGY UNITS" STATIS | grep -v "ENERGY UNITS" | awk '{ print $(NF)}')

grep -w -A4 $y STATIS | grep -v -w $y | grep -v -- "^--$" >> parameters

#########
#DENSITY#
#########

nummols=$(grep -m 1 "nummols" FIELD | awk '{ print $(NF)}')
atoms=$(grep -m 1 "atoms" FIELD | awk '{ print $(NF)}')

echo $nummols $atoms >> molecule_info


z=$(grep -A1 "ENERGY UNITS" STATIS | grep -v "ENERGY UNITS" | awk '{ print $(NF)}')

grep -w $z STATIS | awk '{print $(NF-2)}' >> ./tmp/timestep


#mkdir fluctuation_analysis
#mv timestep* ./fluctuation_analysis
#mv *_change ./fluctuation_analysis

################
#PYTHON SCRIPTS#
################

python ./energy.py
python ./fluctuations.py
python ./volume.py

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
