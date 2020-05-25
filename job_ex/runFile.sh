#!/bin/bash -l

#choose which queue to submit to
#$ -q cpu_short
#set a time limit (in hours)
#$ -l h_rt=1:00:00
# start the job in the current working directory
#$ -cwd
# set the name of the job
#$ -N JobName

echo "Job started on `hostname` at `date`"

echo "compile code "
gfortran ex-hw4.f90

echo "start job" 

#time ./a.out  > log.txt
echo " "
echo "Job ended at `date`"

