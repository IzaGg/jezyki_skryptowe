#!/bin/bash
#Izabela Górlińska grupa 1
# skrypt zaliczeniowy bash
#chmod +x sIG_zal.sh

source Istnieje

num='^-?[0-9]+$'
kateg='[1-3]'
RED='\e[1;31m'
GREEN='\e[1;32m'
RESET='\u001b[0m'

function addProduct(){
	echo "Dodajesz produkt do spisu - $1. Podaj dane produktu."
	echo "Nazwa: "
	read nazwa
	echo "Ilosc: "
	read ilosc
	i=0
	while [[ $i<3 ]]; do
		if ! [[ $ilosc =~ $num ]] ; then
			if [[ $i == 0 ]]; then
				echo "To nie liczba sztuk! Podaj poprawnie: "
				read ilosc
			elif [[ $i == 2 ]]; then
				echo -e "${RED}Podano nieprawidlowa wartosc! Nie udalo sie dodac produktu :(${RESET}"
				return
			else
				echo "Sprobuj jeszcze raz"
				read ilosc
			fi
			i=$((i+1))

		else
			i=3
		fi
	done
	echo "Kategoria: 1)nabial  2)pieczywo  3)owoce :  "
	read kat
	if ! [[ $kat =~ $kateg ]] ; then
		echo "Podaj poprawna kategorie: "
		read kat
		if ! [[ $kat =~ $kateg ]] ; then
			echo "Podales zla kategorie. Sprobuj jeszcze raz: "
			read kat
		fi
		if ! [[ $kat =~ $kateg ]] ; then
			echo -e "${RED}Nie udalo sie wybrac kategorii :(${RESET}"
			return
		fi
	fi
	echo $nazwa,$ilosc,$kat >>$1
	echo -e "${GREEN}Pomyslnie dodano produkt do spisu :)${RESET}"
}

function removeProduct(){
	echo "Usuwasz produkt ze spisu - $1"
	showProducts $plik
	echo "Podaj nazwe produktu, ktory chcesz usunac: "
	read prod
	decyzja='0'
	czy=0
	while IFS= read -r line
	do
		if [[ "$line" =~ ^$prod,.* ]]; then
			czy=1
		fi
	done < "$1"
	if [[ $czy == 1 ]]; then
		echo "Czy na pewno chcesz usunac $prod? (tak/nie)"
		read decyzja
	fi
	if [[ " $decyzja " =~ " tak" ]]; then
		grep -v "$prod" $1 > filename2; mv filename2 $1
		echo "Produkt zostal usuniety."
	elif [[ " $decyzja " =~ " 0 " ]]; then
		echo -e "${RED}Nie ma produktu o takiej nazwie :(${RESET}"
	else
		echo "Ok. Nie bedziemy usuwac"
	fi
}



function changeProduct(){
	echo "Zmieniasz dane produktu ze spisu - $1"
	showProducts $1
	echo "Wybierz co chcesz zmienic:"
	echo " 1)nazwa"
	echo " 2)ilosc"
	echo " 3)kategoria"
	echo "Twoj wybor: "
	read akcja
	if  [[ " $akcja " =~ "1" ]]; then
		echo "Zmieniasz nazwe."
		echo "Podaj nazwe produktu, ktory chcesz edytowac: "
		read prod
		istnieje "$1" "$prod" "0"
		ex=$?
		if ! [[ $ex == 1 ]] ; then 
			echo "Podaj nazwe produktu jeszcze raz: "
			read prod
			istnieje "$1" "$prod" "1"
			ex=$?
		fi
		if [[ $ex == 1 ]]; then
			echo "Podaj nowa nazwe: "
			read nowa
			echo "Czy na pewno chcesz zmienic nazwe '$prod' na '$nowa'? (tak/nie)"
			read dec
			if [[ " $dec " =~ " tak " ]]; then
				sed -i "s/$prod/$nowa/" $1
				echo -e "${GREEN}Edycja zakonczona sukcesem :)${RESET}"
			else
				echo -e "${RED}Edycja wstrzymana${RESET}"
			fi
		fi

	elif  [[ " $akcja " =~ "2" ]]; then
		echo "Zmieniasz ilosc."
		echo "Podaj nazwe produktu, ktory chcesz edytowac: "
		read prod
		istnieje "$1" "$prod" "0"
		ex=$?
		if ! [[ $ex == 1 ]] ; then 
			echo "Podaj nazwe produktu jeszcze raz: "
			read prod
			istnieje "$1" "$prod" "1"
			ex=$?
		fi
		if [[ $ex == 1 ]]; then
			echo "Podaj nowa ilosc: "
			read nowa
			if ! [[ $nowa =~ $num ]] ; then
				echo "Podaj poprawna ilosc: "
				read nowa
				if ! [[ $nowa =~ $num ]] ; then
					echo "Podales niepoprawna ilosc. Sprobuj jeszcze raz: "
					read nowa
				fi
				if ! [[ $nowa =~ $num ]] ; then
					echo "Nie udalo sie zmienic ilosci produktu :("
					return
				fi
			fi

			echo "Czy na pewno chcesz zmienic ilosc $prod na $nowa? (tak/nie)"
			read dec
			if [[ " $dec " =~ " tak " ]]; then
				sed -i -E "s/^$prod,(.*),(.*)/$prod,$nowa,\2/" $1
				echo -e"${GREEN}Edycja zakonczona sukcesem :)${RESET}"
			else
				echo -e "${RED}Edycja wstrzymana${RESET}"
			fi
		fi
	elif  [[ " $akcja " =~ "3" ]]; then
		echo "Zmieniasz kategorie."
		echo "Podaj nazwe produktu, ktory chcesz edytowac: "
		read prod
		istnieje "$1" "$prod" "0"
		ex=$?
		if ! [[ $ex == 1 ]] ; then 
			echo "Podaj nazwe produktu jeszcze raz: "
			read prod
			istnieje "$1" "$prod" "1"
			ex=$?
		fi
		if [[ $ex == 1 ]]; then
			echo "Podaj nowa kategorie. Wybierz jedna z trzech: 1)nabial 2)pieczywo 3)owoce :"
			read nowa
			if ! [[ $nowa =~ $kateg ]] ; then
				echo "Podaj poprawna kategorie: "
				read nowa
				if ! [[ $nowa =~ $kateg ]] ; then
					echo "Podales zla kategorie. Sprobuj jeszcze raz: "
					read nowa
				fi
				if ! [[ $nowa =~ $kateg ]] ; then
					echo "Nie udalo sie wybrac kategorii :("
					return
				fi
			fi
			echo "Czy na pewno chcesz zmienic kategorie $prod na $nowa? (tak/nie)"
			read dec
			if [[ " $dec " =~ " tak " ]]; then
				sed -i -E "s/^$prod,(.*),(.*)/$prod,\1,$nowa/" $1
				echo -e "${GREEN}Edycja zakonczona sukcesem :)${RESET}"
			else
				echo -e "${RED}Edycja wstrzymana ${RESET}"
			fi
		fi
	else
		echo -e "${RED}Nie wybrano numeru akcji. Uruchom skrypt ponownie jesli chcesz edytowac${RESET}"
	fi

}


function showProducts(){
	echo ""
	echo "Wyswietlam spis - $1"
	
	while IFS= read -r line
	do
		echo "$line"
	done < "$1"
	echo ""
}


function summary(){
	echo "Wyswietlam dane ogolne dla spisu - $1"
	lprod=0
	lil=0
	k1=0
	k2=0
	k3=0
	while IFS= read -r line
	do
		lprod=$((lprod+1))
	done < "$1"
	echo "Liczba produktow w spisie: $lprod"
	while IFS=, read -r nm ilosc kat
	do
		lil=$((lil+ilosc))
		if [[ $kat == 1 ]]; then
			k1=$((k1+1))
		elif [[ $kat == 2 ]]; then
			k2=$((k2+1))
		else
			k3=$((k3+1))
		fi
	done < "$1"
	echo "Lacznie na magazynie jest: $lil sztuk wszystkich towarow"
	echo "Towarow z kategorii '1' jest: $k1"
	echo "Towarow z kategorii '2' jest: $k2"
	echo "Towarow z kategorii '3' jest: $k3"
}


function printFile(){
	echo "Podsumowanie spisu towarow z magazynu" >'Summary_sh.txt'
	echo "" >>'Summary_sh.txt'
	echo "PRODUKTY" >>'Summary_sh.txt'
	echo "Nazwa produktu, ilosc, kategoria" >>'Summary_sh.txt'
	echo "=================================" >>'Summary_sh.txt'
	lprod=0
	lil=0
	k1=0
	k2=0
	k3=0
	while IFS= read -r line
	do
		lprod=$((lprod+1))
	done < "$1"
	while IFS=, read -r nm ilosc kat
	do
		echo "$nm $ilosc $kat" >>'Summary_sh.txt'
		lil=$((lil+ilosc))
		if [[ $kat == 1 ]]; then
			k1=$((k1+1))
		elif [[ $kat == 2 ]]; then
			k2=$((k2+1))
		else
			k3=$((k3+1))
		fi
	done < "$1"
	echo "" >>'Summary_sh.txt'
	echo "PODSUMOWANIE" >>'Summary_sh.txt'
	echo "Liczba produktow w spisie: $lprod" >>'Summary_sh.txt'
	echo "Lacznie na magazynie jest: $lil sztuk wszystkich towarow" >>'Summary_sh.txt'
	echo "Towarow z kategorii '1' jest: $k1" >>'Summary_sh.txt'
	echo "Towarow z kategorii '2' jest: $k2" >>'Summary_sh.txt'
	echo "Towarow z kategorii '3' jest: $k3" >>'Summary_sh.txt'
}

#koniec function
pom=0
f=0
h=0


if [[ $# == 0 ]]; then
	echo -e "${RED}Nie podano pliku do analizy"
	echo -e "${RED}Jesli chcesz dowiedziec sie co ja robie wybierz opcje '-help' :)${RED}"
	exit 1
fi

for pom in "$@";
do
	if [[ " $pom " =~ " -h " ]] || [[ " $pom " =~ " -help " ]]; then
		if [[ $h == 0 ]]; then
			echo "Wywolales skrypt z opcja help."
			echo "Autor: Izabela Gorlinska"
			echo ""
			echo "Ten program jako pierwszy argument przyjmuje plik z danymi (.csv), tj. spisem z natury stanu towarow na magazynie i na nim operuje."
			echo "Program akceptuje tylko 1 plik i na nim pracuje"
			echo "Po wywolaniu konkretnej opcji wykonuje odpowiednia dla niej akcje."
			echo "Skrypt mozna uruchomic z 1 lub wieloma opcjami na raz."
			echo "Skrypt wywolany bez parametrow wypisuje wartosci (ilosc i kategorie) wszystkich towarow w magazynie orach ich laczna ilosc."
			echo ""
			echo "Mozliwe opcje wywolania skryptu:"
			echo " -add     dodanie produktu do spisu,"
			echo " -rem     usuniecie produktu z spisu,"
			echo " -change  zmiana ilosci lub kategorii produktu,"
			echo " -show    wypisanie towarow, ich ilosci i kategorii, do ktorej naleza,"
			echo " -summ    wypisanie ogolnych danych o towarach, (tzn.: liczby produktow w spisie, ilosci wszystkich towarow w spisie i liczebnosci towarow w kazdej z kategorii)"
			echo " -print   wypisanie danych o towarach do pliku - Summary_sh.txt. W pliku znajda sie informacje o produktach: dla kazdego podana jego ilosc oraz kategoria, a takze podsumowanie, ktore zawiera liczbe wszystkich produktow w spisie, ilosci wszystkich towarow w spisie oraz liczebnosci towarow w kazdej z kategorii."
			echo ""
			echo "Przykladowy plik, na ktorym operuje skrypt: magazyn.csv."
			echo "Przyklad wywolania skryptu: ./sIG_zal.sh spis_z_nat.csv -print -h"
			echo ""
			h=$((h+1))
		fi

	elif [[ -f $pom ]]; then
		if [[ $f == 0 ]]; then
			plik=$pom
		fi
		f=$((f+1))
	fi
done
for pom in "$@";
do
	if [[ $f == 1 ]]; then
		if [[ " $pom " =~ " -add " ]]; then
			addProduct $plik	
		elif [[ " $pom " =~ " -rem " ]]; then
			removeProduct $plik	
		elif [[ " $pom " =~ " -change " ]]; then
			changeProduct $plik	
		elif [[ " $pom " =~ " -show " ]]; then
			showProducts $plik
		elif [[ " $pom " =~ " -summ " ]]; then
			summary $plik	
		elif [[ " $pom " =~ " -print " ]]; then
			printFile $plik
		elif [[ " $pom " =~ " -h " ]] || [[ " $pom " =~ " -help " ]]; then
			h=$((h+1))
		elif [[ -f $pom ]]; then
			:
		else
			echo ""
			echo "Nie znam takiej opcji -'$pom'. Zajrzyj do pomocy :)"
		fi
	fi	
done

if [[ $f > 1 ]]; then
	echo -e "${RED}Chyba cos jest nie tak - podales za duzo plikow.${RESET} Sprawdz pomoc i wroc do mnie :)"
fi
if [[ $f == 0 ]] && [[ $h == 0 ]]; then
	echo -e "${RED}Nie podano pliku do analizy ;(${RESET}"
	exit 1
fi
if [[ $# == 1 ]] && [[ $f == 1 ]]; then
	echo "PRODUKTY z magazynu - $plik"
	echo ""
	echo "Nazwa produktu, ilosc, kategoria"
	echo "================================="
	while IFS=, read -r nm ilosc kat
	do
		echo "$nm $ilosc $kat"
		lil=$((lil+ilosc))
	done < "$plik"
	echo ""
	echo "Lacznie na magazynie jest: $lil sztuk wszystkich produktow"
fi

