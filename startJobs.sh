#!/bin/bash
#Adam Iaizzi
#2020-05-25
#example shell script I use for setting up and starting my jobs. 
#an explanation is the the lecture notes that accompany these exercises
#note that this script will not run without supporting files which are not included. It's just an example .
for ll in 0064 0128 0256 
do
    #loop over beta
    for bb in 0128 
    do 
	#loop over fields
	for hx in `seq 3950 10 3990` `seq 4010 10 4050`
	do
	    hi=$(printf "%04d" $hx)
	    #path to working directory
	    ptd=`echo n$ll/b$bb/h$hi`
	    #make directory
	    mkdir -p $ptd
	    #copy source
	    cp ising.f90 $ptd
	    #calculate tt - the temperature
	    tt=`echo 'scale=8; 1.0 /' $bb | bc`
	    hh=`echo 'scale=8; ' $hi '*0.001' | bc`
	    #make read.in
	    sed -e "s/#ll#/$ll/g" TEMPLATE_read.in > temp1.txt
	    sed -e "s/#hh#/$hh/g" temp1.txt > temp2.txt
	    sed -e "s/#tt#/$tt/g" temp2.txt > $ptd/read.in
	    #set name
	    name=`echo n$ll-$hh-$bb`
	    #replace flags in subFiles.sh
	    sed -e "s@#name#@$name@g" TEMPLATE_runFile.sh > $ptd/runFile.sh
	    #submit job
	    cd $ptd
	    qsub runFile.sh
	    cd -
	    echo "Submitted job " $name 
	done #hh loop
    done #beta loop
done #ll loop
