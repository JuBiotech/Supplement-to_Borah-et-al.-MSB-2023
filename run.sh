#!/bin/bash
timeFile='times.csv'
modelDir='.'

dirlist=(`ls ${modelDir}/*.fml| xargs -n 1 basename`)
for file in ${dirlist[@]};
do
        path='./Results/'${file}
        mkdir -p ${path}/exec/
        for i in {1..10}; # This 10 generates 10 fml files for checking reproducibility
        do
                (
                #make useful argument variables
                let argVar="($i * 5)"
                #make useful name variables
                printf -v nameVar "%03d" $i

                let sleepinterval="($i*2)"
                sleep $sleepinterval
                #Run the command
                /usr/bin/time -o ${path}/$timeFile -a x3cflux-bma -i $modelDir$file -o ${path}/exec/${nameVar}eval.hdf5  -p 50 -n 5000000 -b 25000$
                )&
        if (( $i % 5 == 0 )); then wait; fi # Limit to 10 concurrent subshells.
        done
done
