package Istnieje;
#Izabela Górlińska grupa 1
#skrypt zaliczeniowy perl

use strict;
use warnings;

sub istnieje{
	my($spis, $prod, $l)=@_; #(spis, prod, l)
	my $j=0;
	open(PLIK, '<', $spis) or die "Nie można utworzyć pliku: $!";
	while (my $line = <PLIK>) {
		chomp $line;
		my @slowawl = split(',', $line);
		if($slowawl[0] eq $prod){
			$j=1;	
		}
	}
	close PLIK;
	if($j==1){
		return $j;
	}
	elsif($l==1){
		print "Produktu '$prod' nie ma w bazie. Nie udalo sie wprowadzic zmiany ;(\n";
		return $j;
	}else{
		print "Nie ma produktu '$prod' w bazie $spis :(\n";
		return $j;
	}
}

1;
