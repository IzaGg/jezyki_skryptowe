#!/bin/bash
#Izabela Górlińska
#tabelka mnozenia

for ((i=0; i<10; i++))
do
	echo""
	for ((j=0;j<10;j++))
	do	
	 	echo -n "$(($i*$j)) "

	done
done
echo""
exit 0
