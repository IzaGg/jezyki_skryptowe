#!/bin/tcsh
#Izabela Górlińska
#tabelka mnozenia

@ zm_pom =0
set arr=(0 1 2 3 4 5 6 7 8 9)

foreach i ($arr)
	echo " "
	foreach j ($arr)
		@ zm_pom = $i * $j
		echo -n "$zm_pom "	
	end
end
echo " "
exit 0
