# Visualise_DL_POLY_Convergence

This bundle of shell and python scripts aims to help determine whether or not a given DL_POLY simulation has converged.

## Workflow

**1. gogoconvergence.sh** 

  * This shell script extracts the necessary information, calls the analysis scripts and tidies up after them
  * I would store this in your bin
  * Make sure you set the path to your local clone of this repo within gogoconvergence.sh on line 22:
```
cp <PATH>/visualise_convergence/* .
```

**2. energy.py**

  * This python script performs basic statistical analysis and plots graphs of the fluctations of the instantaneous configurational and total energy of the system at every timestep
  * If you want to view the plots, please uncomment lines 64, 79, 122 and 137
  
```
#plt.show()
```

**3. fluctuations.py**

* This python script performs basic statistical analysis and plots graphs of the fluctations of the instantaneous
temperature and pressure of the system at every timestep
* If you want to view the plots, please uncomment lines 64 and 99

```
#plt.show()
```
  
