#!/bin/sh

rm *.dat

for i in volume-*
do
        cd $i
                phonopy --fc vasprun.xml

		rm thermal_properties.yaml*

                phonopy --dim="1 1 1" -c POSCAR -t -p ../mesh.conf & 


        cd ../
done



# calculate the volume vs energy (e-v.dat and fe-v.dat)
phonopy-vasp-efe --tmax=2000 volume-0.995/vasprun.xml volume-0.996/vasprun.xml volume-0.997/vasprun.xml volume-0.998/vasprun.xml volume-0.999/vasprun.xml volume-1.000/vasprun.xml volume-1.001/vasprun.xml volume-1.002/vasprun.xml volume-1.003/vasprun.xml volume-1.004/vasprun.xml volume-1.005/vasprun.xml volume-1.006/vasprun.xml 

# e-v.dat murnaghan fitting
#phonopy-qha -b e-v.dat --eos murnaghan -p

# QHA calculation (all thermodynamic properties)

phonopy-qha -p --tmax=2000 --efe fe-v.dat e-v.dat volume-0.995/thermal_properties.yaml volume-0.996/thermal_properties.yaml volume-0.997/thermal_properties.yaml volume-0.998/thermal_properties.yaml volume-0.999/thermal_properties.yaml volume-1.000/thermal_properties.yaml volume-1.001/thermal_properties.yaml volume-1.002/thermal_properties.yaml volume-1.003/thermal_properties.yaml volume-1.004/thermal_properties.yaml volume-1.005/thermal_properties.yaml volume-1.006/thermal_properties.yaml 

