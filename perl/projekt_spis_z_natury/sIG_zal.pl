#!/usr/bin/perl
#Izabela Górlińska grupa 1
#skrypt zaliczeniowy perl
#chmod +x sIG_zal.pl

use Cwd qw( abs_path );
use File::Basename qw( dirname );
BEGIN {
        push @INC,dirname(abs_path($0));;
}
use Istnieje;
use strict;
use warnings;
use Scalar::Util qw(looks_like_number);
use Term::ANSIColor qw(:constants);


sub addProduct{ 
	my($spis)=@_; #(spis)
	print("\nDodajesz produkt do spisu - $spis. Podaj dane produktu.");
	print "\nNazwa: ";
	my $nazwa=<STDIN>;
	chomp $nazwa;
	print "Ilosc: ";
	my $ilosc=<STDIN>;
	my $i=0;
	while ($i<3) {
		unless($ilosc =~ /^[0-9]/) {
			if($i==0) {
				print "To nie liczba sztuk! Podaj poprawnie: ";
				$ilosc=<STDIN>;
				chomp $nazwa;
			}
			elsif($i==2) {
				print RED"Podano nieprawidlowa wartosc! Nie udalo sie dodac produktu :(\n", RESET;
				return;
			}
			else {
				print "Sprobuj jeszcze raz: ";
				$ilosc=<STDIN>;
				chomp $nazwa;
			}
			$i++;
		}else {
			$i=3;
		}
	}
	print "Cena: ";
	my $cena=<STDIN>;
	unless(looks_like_number($cena)) {
		print "Podaj poprawna cene: ";
		$cena=<STDIN>;
		unless(looks_like_number($cena)) {
			print "Podales niepoprawna cene. Sprobuj jeszcze raz: ";
			$cena=<STDIN>;
		}
		unless(looks_like_number($cena)) {
			print RED"Wprowadzona cena nie jest poprawna. Przerwano dodawanie produktu\n", RESET;
			return
		}
	}
	my $suma=$ilosc*$cena;
	open(PLIK, '>>', $spis) or die "Nie można utworzyć pliku: $!";
	printf PLIK "%s,%d,%.2f,%.2f\n",$nazwa, $ilosc, $cena, $suma;
	close PLIK;
	print GREEN"Pomyslnie dodano produkt do spisu :)\n", RESET;
}


sub removeProduct{
	my($spis)=@_; #(spis)
	print("\nUsuwasz produkt ze spisu - $spis.\nPodaj nazwe produktu, ktory chcesz usunac: ");
	my $prod=<STDIN>;
	chomp $prod;
	my @list=();
	my $usun=0;
	open(PLIK, '<', $spis) or die "Nie można utworzyć pliku: $!";
	while (my $line = <PLIK>) {
		chomp $line;
		my @slowawl = split(',', $line);
		if($slowawl[0] eq $prod){
			print "$prod jest w linii $line";
			print("\nCzy na pewno chcesz usunac $prod? (tak/nie) ");
			my $dec=<STDIN>;
			chomp $dec;
			if($dec eq 'tak'){
				$usun=1;	
			}else{
				print "Ok. Nie bedziemy usuwac\n";
				return;
			}
		}else{
			push(@list, $line);
		}
	}
	close PLIK;
	if($usun==1){
		open(PLIK, '>', $spis) or die "Nie można utworzyć pliku: $!";
		foreach my $p(@list){
			printf PLIK "$p\n";
		}
		close PLIK;
		print GREEN"\nProdukt zostal usuniety.\n", RESET;
		showProducts($spis);
	}else{
		print RED"Nie ma produktu o takiej nazwie :(\n", RESET;
	}
}



sub changeProduct{
	my($spis)=@_; #(spis)
	my $ex;
	my $prod;
	my $akcja;
	my $dec;
	print "\nZmieniasz dane produktu ze spisu - $spis";
	print "\nWybierz co chcesz zmienic:\n 1)nazwa\n 2)ilosc\n 3)cena\nTwoj wybor: ";
	$akcja=<STDIN>;
	chomp $akcja;
	if($akcja eq '1'){
		print "Zmieniasz nazwe.\nPodaj nazwe produktu, ktory chcesz edytowac: ";
		$prod=<STDIN>;
		chomp $prod;
		$ex=Istnieje::istnieje($spis, $prod, 0);
		unless($ex==1){
			print "\nPodaj nazwe produktu jeszcze raz: ";
			$prod=<STDIN>;
			chomp $prod;
			$ex=Istnieje::istnieje($spis, $prod, 1);
		}
		if($ex==1){
			my @list=();
			my @proded;	
			open(PLIK, '<', $spis) or die "Nie można otworzyć pliku: $!";
			while (my $line = <PLIK>) {
				chomp $line;
				my @slowawl = split(',', $line);
				if($slowawl[0] eq $prod){
					@proded=@slowawl;
					print "Podaj nowa nazwe: ";
					my $nowa=<STDIN>;
					chomp $nowa;
					$proded[0]=$nowa;
					my $pr=join( ",",$proded[0],$proded[1],$proded[2],$proded[3]);
					push(@list, $pr);
					print("Czy na pewno chcesz zmienic nazwe $prod na $nowa? (tak/nie)");
					$dec=<STDIN>;
					chomp $dec;
				}else{
					push(@list, $line);
				}
			}
			close PLIK;
			
			if($dec eq 'tak'){
				open(PLIK, '>', $spis) or die "Nie można otworzyć pliku: $!";
				foreach my $p(@list){
					printf PLIK "$p\n";
				}
				close PLIK;
				print GREEN"Edycja zakonczona sukcesem :)", RESET;
			}else{
				print RED"\nEdycja wstrzymana", RESET;
				return;
			}
		}
	}
	elsif($akcja eq '2'){
		print "Zmieniasz ilosc.\nPodaj nazwe produktu, ktory chcesz edytowac: ";
		my $prod=<STDIN>;
		chomp $prod;
		$ex=Istnieje::istnieje($spis, $prod, 0);
		unless($ex==1){
			print "\nPodaj nazwe produktu jeszcze raz: ";
			$prod=<STDIN>;
			chomp $prod;
			$ex=Istnieje::istnieje($spis, $prod, 1);
		}
		if($ex==1){
			my @list=();
			my @proded;	
			open(PLIK, '<', $spis) or die "Nie można otworzyć pliku: $!";
			while (my $line = <PLIK>) {
				chomp $line;
				my @slowawl = split(',', $line);
				if($slowawl[0] eq $prod){
					@proded=@slowawl;
					print "Podaj nowa ilosc: ";
					my $nowa=<STDIN>;
					chomp $nowa;
					unless($nowa =~ /^[0-9]/) {
						print "Podaj poprawna ilosc: ";
						$nowa=<STDIN>;
						unless($nowa =~ /^[0-9]/) {
							print "Podales niepoprawna ilosc. Sprobuj jeszcze raz: ";
							$nowa=<STDIN>;
						}
						unless($nowa =~ /^[0-9]/) {
							print "Wprowadzona ilosc nie jest poprawna. Przerwano zmienianie ilosci produktu\n";
							return
						}
					}
					$proded[1]=$nowa;
					$proded[3]=$proded[1]*$proded[2];
					$proded[3]=int($proded[3]*100)/100;
					my $pr=join( ",",$proded[0],$proded[1],$proded[2],$proded[3]);
					push(@list, $pr);
					print("Czy na pewno chcesz zmienic ilosc $prod? (tak/nie)");
					$dec=<STDIN>;
					chomp $dec;
				}else{
					push(@list, $line);
				}
			}
			close PLIK;
			
			if($dec eq 'tak'){
				open(PLIK, '>', $spis) or die "Nie można otworzyć pliku: $!";
				foreach my $p(@list){
					printf PLIK "$p\n";
				}
				close PLIK;
				print GREEN"Edycja zakonczona sukcesem :)", RESET;
			}else{
				print RED"\nEdycja wstrzymana", RESET;
				return;
			}
		}
	}
	elsif($akcja eq '3'){
		print "Zmieniasz cene.\nPodaj nazwe produktu, ktory chcesz edytowac: ";
		my $prod=<STDIN>;
		chomp $prod;
		$ex=Istnieje::istnieje($spis, $prod, 0);
		unless($ex==1){
			print "\nPodaj nazwe produktu jeszcze raz: ";
			$prod=<STDIN>;
			chomp $prod;
			$ex=Istnieje::istnieje($spis, $prod, 1);
		}
		if($ex==1){
			my @list=();
			my @proded;	
			open(PLIK, '<', $spis) or die "Nie można otworzyć pliku: $!";
			while (my $line = <PLIK>) {
				chomp $line;
				my @slowawl = split(',', $line);
				if($slowawl[0] eq $prod){
					@proded=@slowawl;
					print "Podaj nowa cene: ";
					my $nowa=<STDIN>;
					chomp $nowa;
					unless(looks_like_number($nowa)) {
						print "Podaj poprawna cene: ";
						$nowa=<STDIN>;
						unless(looks_like_number($nowa)) {
							print "Podales niepoprawna cene. Sprobuj jeszcze raz: ";
							$nowa=<STDIN>;
						}
						unless(looks_like_number($nowa)) {
							print "Wprowadzona cena nie jest poprawna. Przerwano zmienianie ceny produktu\n";
							return
						}
					}
					$proded[2]=$nowa;
					$proded[2]=int($proded[2]*100)/100;
					$proded[3]=$proded[1]*$proded[2];
					$proded[3]=int($proded[3]*100)/100;
					my $pr=join( ",",$proded[0],$proded[1],$proded[2],$proded[3]);
					push(@list, $pr);
					print("Czy na pewno chcesz zmienic cene $prod? (tak/nie)");
					$dec=<STDIN>;
					chomp $dec;
				}else{
					push(@list, $line);
				}
			}
			close PLIK;
			
			if($dec eq 'tak'){
				open(PLIK, '>', $spis) or die "Nie można otworzyć pliku: $!";
				foreach my $p(@list){
					printf PLIK "$p\n";
				}
				close PLIK;
				print GREEN"Edycja zakonczona sukcesem :)", RESET;
			}else{
				print RED"\nEdycja wstrzymana", RESET;
				return;
			}
		}
	}else{
		print RED"Nie wybrano numeru akcji. Uruchom skrypt ponownie jesli chcesz edytowac", RESET;
	}
}


sub showProducts{
	my($spis)=@_; #(spis)
	print("\nWyswietlam spis - $spis\n");
	open(PLIK, '<', $spis) or die "Nie można utworzyć pliku: $!";
	while(my $line = <PLIK>){
		chomp $line;
		my @slowawl = split(',', $line);
		print "$slowawl[0] $slowawl[1] $slowawl[2] $slowawl[3]\n";
	}
	close PLIK;
}


sub summary{
	my($spis)=@_;
	print "\nWyswietlam dane ogolne dla spisu - $spis";
	my $lprod=0;
	my $lil=0;
	my $lsum=0;
	open(PLIK, '<', $spis) or die "Nie można otworzyć pliku: $!";
	while(my $line = <PLIK>){
		chomp $line;
		my @slowawl = split(',', $line);
		$lprod++;
		$lil+=int($slowawl[1]);
		$lsum+=$slowawl[3];
		$lsum=int($lsum*100)/100;
	}
	close PLIK;
	print "\nLiczba produktow w spisie: $lprod\nLacznie na magazynie jest: $lil sztuk wszystkich towarow\nWartosc wszystkich produktow wynosi: $lsum zl\n";
}


sub printFile{
	my($spis)=@_;
	my $lprod=0;
	my $lil=0;
	my $lsum=0;
	open(PLIK1, '>', 'Summary_pl.txt') or die "Nie można utworzyć pliku: $!";
	printf PLIK1 "Podsumowanie spisu towarow z magazynu\n\nPRODUKTY\nNazwa produktu, ilosc, cena\n===========================\n";
	open(PLIK, '<', $spis) or die "Nie można otworzyć pliku: $!";
	while(my $line = <PLIK>){
		chomp $line;
		my @slowawl = split(',', $line);
		printf PLIK1 "$slowawl[0] $slowawl[1] $slowawl[2] $slowawl[3]\n";
		$lprod++;
		$lil+=int($slowawl[1]);
		$lsum+=$slowawl[3];
		$lsum=int($lsum*100)/100;
	}
	close PLIK;
	printf PLIK1 "\nPODSUMOWANIE\nLiczba produktow w spisie: $lprod\nLacznie na magazynie jest: $lil sztuk wszystkich towarow\nWartosc wszystkich produktow wynosi: $lsum zl";
	close PLIK1;
}


#koniec sub
my $file;
my $pom=0;
my $f=0;
my $h=0;

unless (defined($ARGV[0])) {
	print RED"Nie podano pliku do analizy\nJesli chcesz dowiedziec sie co ja robie wybierz opcje '-help' :)\n", RESET;
	exit 1;
}else {
	for $pom (@ARGV) {
		if (( -f $pom)) {
			if (( $f==0)){
				$file=$pom;
			}
			$f++;
		}
		if (( $pom eq '-h' ) || ( $pom eq '-help')) {
			if(( $h==0)){
				print "Wywolales skrypt z opcja help.\n";
				print "Autor: Izabela Gorlinska\n\n";
				print "Ten program jako argument przyjmuje plik z danymi(plik csv) - spisem stanu towarow na magazynie i na nim operuje.\nProgram akceptuje tylko 1 plik i na nim pracuje.\nPo wywolaniu konkretnej opcji wykonuje odpowiednia dla niej akcje.\nSkrypt mozna uruchomic z 1 lub wieloma opcjami na raz.\n";
				print "\nSkrypt wywolany tylko z pierwszym argumenten (plikiem na ktorym operuje) wypisuje wartosci wszystkich towarow w magazynie oraz liczbę towarów i ich laczna ilosc.\nMozliwe opcje wywolania skryptu:\n";
				print " -add     dodanie produktu do magazynu,\n";
				print " -rem     usuniecie produktu z magazynu,\n";
				print " -change  zmiana nazwy,ilosci lub ceny produktu,\n";
				print " -show    wypisanie towarow, ich ilosci i wartosci,\n";
				print " -summ    wypisanie ogolnych danych o towarach (tzn.: liczby produktow w spisie, ilosci wszystkich towarow i ich wartosci),\n";		
				print " -print   wypisanie danych o towarach do pliku- Summary_pl.txt. W pliku znajda sie informacje o produktach: dla kazdego podana jego ilosc oraz cena, a takze podsumowanie, ktore zawiera liczbe wszystkich produktow w spisie, ilosci wszystkich towarow w spisie oraz ich laczna wartosc.\n\n";
				print "\nPrzykladowy plik, na ktorym operuje skrypt: magazyn.csv.\nPrzyklad wywolania skryptu: ./sIG_zal.pl magazyn.csv -summ -help\n\n";
				$h++;
			}
		}
	}
	for $pom (@ARGV) {
		if($f==1){
			if (( $pom eq '-add' ) ) {
				addProduct($file);
			}
			elsif (( $pom eq '-rem' )) {
				removeProduct($file);
			}
			elsif (( $pom eq '-change' )) {
				changeProduct($file);
			}
			elsif (( $pom eq '-show' )) {
				showProducts($file);
			}
			elsif (( $pom eq '-summ' )) {
				summary($file);
			}
			elsif (( $pom eq '-print' )) {
				printFile($file);
			}
			elsif (( $pom eq '-h' ) || ( $pom eq '-help')) {
				$h++;
			}
			elsif (( -f $pom)) {
			}
			else{
				print "\nNie znam takiej opcji -'$pom'. Zajrzyj do pomocy :)\n";
			}
		}
	}
}
if (( $f==0 ) && ( $h==0)){
	print RED"Nie podano pliku do analizy ;(", RESET;
}
elsif (( $f>1)){
	print RED"Podales za duzo plikow. Zgubilem sie :(\nPrzeczytaj pomoc i sprobuj jeszcze raz!", RESET;
}

if (( $f==1 ) && ( $#ARGV==0 )){
	print "PRODUKTY z magazynu - $file\n\n";
	print "Nazwa produktu, ilosc, cena\n===========================\n";
	my $lprod=0;
	my $lil=0;
	open(PLIK, '<', $file) or die "Nie można otworzyć pliku: $!";
	while(my $line = <PLIK>){
		chomp $line;
		my @slowawl = split(',', $line);
		print "$slowawl[0] $slowawl[1] $slowawl[2] $slowawl[3]\n";
		$lprod++;
		$lil+=int($slowawl[1]);
	}
	close PLIK;
	print "\nW magazynie jest $lprod produktow.\nLacznie na magazynie jest $lil sztuk wszystkich produktow."
}
print "\n"
