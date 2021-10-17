#!/bin/tcsh		
#Izabela Górlińska
#csh -f
echo $USER
getent passwd $USER | cut -d ':' -f 5 | cut -d ',' -f 1

set i = 1

if ($#argv == 0) then
	echo "Skrypt uruchomiono bez parametrów"
else
	echo "Skrypt uruchomiono z parametrami: $argv jest ich $#argv"
	foreach arg ($argv)
		if ((" $argv[$i] " =~ " -h " )) then
			echo "Wywołałeś skrypt z opcją -h."
			echo "Ten skrypt wywołany bez żadnych argumentów podaje login użytkownika oraz jego imię i nazwisko"
		endif
		if ((" $argv[$i] " =~ " -help " )) then
			echo "Wywołałeś skrypt z opcją -help."
			echo "Ten skrypt wywołany bez żadnych argumentów podaje login użytkownika oraz jego imię i nazwisko"
		endif
		set i=`expr $i + 1`
	end
	set i=1
	foreach arg ($argv)
		if ((" $argv[$i] " =~ " -q " ) || (" $argv[$i] " =~ " -quit " )) then
			exit 0
		endif
		set i=`expr $i + 1`
	end
	set i=1
	foreach arg ($argv)
		if ((" $argv[$i] " =~ " -q " ) || (" $argv[$i] " =~ " -quit " ) || (" $argv[$i] " =~ " -help " ) || (" $argv[$i] " =~ " -h " )) then
		else
			echo "Skrypt uruchomiono z nieznanym parametrem $argv[$i]"
		endif
		set i=`expr $i + 1`
	end


endif


#$argv = $*
exit 0
