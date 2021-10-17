#!/usr/bin/python3
#Izabela Gorlinska grupa 1
#skrypt zaliczeniowy python

from Istnieje import istnieje
from sys import argv
from os.path import isfile
import csv
import re

class kolor:
	RED='\033[91m'
	GREEN='\033[92m'
	RESET='\033[0m'

def addProduct(spis):
	print("Dodajesz produkt do spisu - " +spis +" Podaj dane produktu." )
	nazwa=input("Nazwa: ")
	ilosc=input("Ilosc: ")
	i=0
	while i<3:
		if not ilosc.isnumeric():
			if i==0:			
				ilosc=input("To nie liczba sztuk! Podaj poprawnie: ")
			elif i==2:
				print(kolor.RED +"Podano nieprawidlowa wartosc! Nie udalo sie dodac produktu :(" +kolor.RESET)
				return
			else:
				ilosc=input("Sprobuj jeszcze raz: ")
			i+=1
		else:
			i=3
	cena=input("Cena: ")
	if not re.search('[0-9]+$',cena):
		cena=input("Podaj poprawna cene: ")
	cena=float(cena)
	suma=round(float(ilosc)*cena,3)
	with open(spis, 'a+', newline='') as write_file:
		csv_writer=csv.writer(write_file)
		csv_writer.writerow([nazwa, ilosc, cena, suma])
	print(kolor.GREEN +"Pomyslnie dodano produkt do spisu :)" +kolor.RESET)


def removeProduct(spis):
	print("Usuwasz produkt ze spisu - " +spis)
	showProducts(spis)
	decyzja='x'
	list=[]
	prod=input("Podaj nazwe produktu, ktory chcesz usunac: ")
	with open(spis) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		for row in csv_reader:
			if row[0]==prod:
				decyzja=input("Czy na pewno chcesz usunac " +prod +" ? (tak/nie)")
			else:
				list.append(row)
		if decyzja =='x':
			print("Nie ma produktu o takiej nazwie :(")
		elif decyzja =='tak':
			with open(spis, 'w', newline='') as write_file:
				csv_writer=csv.writer(write_file)
				csv_writer.writerows(list)
			print(kolor.GREEN +"Produkt zostal ususniety." +kolor.RESET)
		else:
			print("Ok. Nie bedziemy usuwac")
			return
	showProducts(spis)
					

def changeProduct(spis):
	print("Zmieniasz dane produktu ze spisu - " +spis)
	akcja=input("Wybierz co chcesz zmienic:\n 1)nazwa\n 2)ilosc\n 3)cena\nTwoj wybor: ")
	if akcja=='1':
		print("Zmieniasz nazwe.")
		prod=input("Podaj nazwe produktu, ktory chcesz edytowac: ")
		ex=istnieje(spis, prod, 0)
		if not ex==1:
			prod=input("Podaj nazwe produktu jeszcze raz: ")
			ex=istnieje(spis, prod, 1)
		if ex==1:
			list=[]
			with open(spis) as csv_file:
				csv_reader = csv.reader(csv_file, delimiter=',')
				for row in csv_reader:
					if row[0]==prod:
						proded=row
						nowa=input("Podaj nowa nazwe: ")
						proded[0]=nowa
						list.append(row)
					else:
						list.append(row)
				decyzja=input("Czy na pewno chcesz zmienic nazwe " +prod +" na " +nowa +" ? (tak/nie)")
				if decyzja =='tak':
					with open(spis, 'w', newline='') as write_file:
						csv_writer=csv.writer(write_file)
						csv_writer.writerows(list)
						print(kolor.GREEN +"Edycja zakonczona sukcesem :)" +kolor.RESET)
					print
				else:
					print(kolor.RED +"Edycja wstrzymana" +kolor.RESET)
					return

	
	elif akcja=='2':
		print("Zmieniasz ilosc.")
		prod=input("Podaj nazwe produktu, ktory chcesz edytowac: ")
		ex=istnieje(spis, prod, 0)
		if not ex==1:
			prod=input("Podaj nazwe produktu jeszcze raz: ")
			ex=istnieje(spis, prod, 1)
		if ex==1:
			list=[]
			with open(spis) as csv_file:
				csv_reader = csv.reader(csv_file, delimiter=',')
				for row in csv_reader:
					if row[0]==prod:
						proded=row
						nowa=input("Podaj nowa ilosc: ")
						if not nowa.isnumeric():
							nowa=input("Podaj poprawna ilosc: ")
							if not nowa.isnumeric():
								nowa=input("Podales niepoprawna ilosc. Sprobuj jeszcze raz: ")
								if not nowa.isnumeric():
									print("Wprowadzona ilosc nie jest poprawna. Przerwano zmienianie ilosci produktu")
									return
						proded[1]=nowa
						proded[2]=float(proded[2])
						proded[3]=round(float(proded[1])*proded[2],3)
						list.append(row)
					else:
						list.append(row)
				decyzja=input("Czy na pewno chcesz zmienic ilosc " +prod +" ? (tak/nie)")
				if decyzja =='tak':
					with open(spis, 'w', newline='') as write_file:
						csv_writer=csv.writer(write_file)
						csv_writer.writerows(list)
					print(kolor.GREEN +"Edycja zakonczona sukcesem :)" +kolor.RESET)
				else:
					print(kolor.RED +"Edycja wstrzymana" +kolor.RESET)
					return	
	elif akcja=='3':
		print("Zmieniasz cene.")
		prod=input("Podaj nazwe produktu, ktory chcesz edytowac: ")
		ex=istnieje(spis, prod, 0)
		if not ex==1:
			prod=input("Podaj nazwe produktu jeszcze raz: ")
			ex=istnieje(spis, prod, 1)
		if ex==1:
			list=[]
			with open(spis) as csv_file:
				csv_reader = csv.reader(csv_file, delimiter=',')
				for row in csv_reader:
					if row[0]==prod:
						proded=row
						print("Obecna cena: " +row[2])
						nowa=input("Podaj nowa cene: ")
						if not re.search('[0-9]+$',nowa):
							nowa=input("Podaj poprawna cene: ")
							if not re.search('[0-9]+$',nowa):
								nowa=input("Podales niepoprawna cene. Sprobuj jeszcze raz: ")
								if not re.search('[0-9]+$',nowa):
									print("Wprowadzona cena nie jest poprawna. Przerwano zmienianie ilosci produktu")
									return
						proded[2]=float(nowa)
						proded[3]=round(float(proded[1])*proded[2],3)
						list.append(row)
					else:
						list.append(row)
				decyzja=input("Czy na pewno chcesz zmienic cene " +prod +" ? (tak/nie)")
				if decyzja =='tak':
					with open(spis, 'w', newline='') as write_file:
						csv_writer=csv.writer(write_file)
						csv_writer.writerows(list)
					print(kolor.GREEN +"Edycja zakonczona sukcesem :)" +kolor.RESET)
				else:
					print(kolor.RED+"Edycja wstrzymana" +kolor.RESET)
					return
	else:
		print(kolor.RED +"Nie wybrano numeru akcji. Uruchom skrypt ponownie jesli chcesz edytowac" +kolor.RESET)



def showProducts(spis):
	print("\nWyswietlam spis - " +spis )
	with open(spis) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		#line_count = 0
		for row in csv_reader:
			print (row[0], row[1], row[2], row[3])
			#line_count += 1


def summary(spis):
	print("\nWyswietlam dane ogolne dla spisu - " +spis )
	with open(spis) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		lprod = 0
		lil=0
		lsum=0
		for row in csv_reader:
			lprod += 1
			lil+=int(row[1])
			lsum+=float(row[3])
	print("Liczba produktow w spisie: " +str(lprod) +"\nLacznie na magazynie jest: " +str(lil) +" sztuk wszystkich towarow\nWartosc wszystkich produktow wynosi: "+str(round(lsum,3)) +" zl")


def printFile(spis):
	plikz = open('Summary_py.txt','w')
	plikz.write("Podsumowanie spisu towarow z magazynu\n\nPRODUKTY\nNazwa produktu, ilosc, cena\n===========================\n")
	with open(spis) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		lprod = 0
		lil=0
		lsum=0
		for row in csv_reader:
			plikz.write("%s %s %.2f %.2f\n" % (row[0], row[1], float(row[2]), float(row[3])))
			lprod += 1
			lil+=int(row[1])
			lsum+=float(row[3])
	plikz.write("\nPODSUMOWANIE\nLiczba produktow w spisie: %i\nLacznie na magazynie jest: %i sztuk wszystkich towarow\nWartosc wszystkich produktow wynosi: %.2f zl" % (lprod, lil, lsum))
	plikz.close()


#koniec def
h=0
f=0

if len(argv)<=1:
	print (kolor.RED +"Nie podano pliku do analizy.\nJesli chcesz dowiedziec sie co ja robie wybierz opcje '-help' :)" +kolor.RESET)
	exit(1)
else:
	for pom in range (1, len(argv)):
		if argv[pom] == '-h' or argv[pom] == '-help':
				if h==0:
					print ("Wywolales skrypt z opcja help.")
					print("Autor: Izabela Gorlinska\n")
					print("Ten program jako pierwszy argument przyjmuje plik z danymi (plik csv) - spisem stanu towarow na magazynie i na nim operuje.\nProgram akceptuje tylko 1 plik i na nim pracuje.\nPo wywolaniu konkretnej opcji wykonuje odpowiednia dla niej akcje.\nSkrypt mozna uruchomic z 1 lub wieloma opcjami na raz.")
					print("\nSkrypt wywolany bez parametrow wypisuje wartosci wszystkich towarow w magazynie oraz liczbę towarów i ich laczna ilosc.\nMozliwe opcje wywolania skryptu:")
					print(" -add     dodanie produktu do magazynu,")
					print(" -rem     usuniecie produktu z magazynu,")
					print(" -change  zmiana nazwy,ilosci lub ceny produktu,")
					print(" -show    wypisanie towarow, ich ilosci i wartosci,")
					print(" -summ    wypisanie ogolnych danych o towarach (tzn.: liczby produktow w spisie, ilosci wszystkich towarow i ich wartosci),")		
					print(" -print   wypisanie danych o towarach do pliku - Summary_py.txt. W pliku znajda sie informacje o produktach: dla kazdego podana jego ilosc oraz cena, a takze podsumowanie, ktore zawiera liczbe wszystkich produktow w spisie, ilosci wszystkich towarow w spisie oraz ich laczna wartosc.\n\n")

					print("Przykladowy plik, na ktorym operuje skrypt: magazyn.csv.\nPrzyklad wywolania skryptu: python3 sIG_zal.py magazyn.csv -h -summ\n");
					h+=1

		elif isfile(argv[pom]):
			if f==0:
				file=argv[pom]
			f+=1

	for pom in range (1, len(argv)):
		if f==1:
			if argv[pom] == '-add':
				addProduct(file)
			elif argv[pom] == '-rem':
				removeProduct(file)
			elif argv[pom] == '-change':
				changeProduct(file)
			elif argv[pom] == '-show':
				showProducts(file)
			elif argv[pom] == '-summ':
				summary(file)
			elif argv[pom] == '-print':
				printFile(file)
			elif argv[pom] == '-h' or argv[pom] == '-help':
				h+=1
			elif isfile(argv[pom]):
				pass
			else:
				print("\nNie znam takiej opcji -'" +argv[pom] +"'. Zajrzyj do pomocy :)\n")
		
if f>1:
	print(kolor.RED +"Chyba cos jest nie tak - podales za duzo plikow. Sprawdz pomoc i wroc do mnie :)" +kolor.RESET)
if f==0 and h==0:
	print (kolor.RED +"Nie podano pliku do analizy :(" +kolor.RESET);

if f==1 and len(argv)==2:
	print("PRODUKTY z magazynu - " +file)
	print("Nazwa produktu, ilosc, cena\n===========================")
	with open(file) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		line_count = 0
		lil=0
		for row in csv_reader:
			print (row[0], row[1], row[2], row[3])
			line_count += 1
			lil+=int(row[1])
	print("\nW magazynie jest " +str(line_count) +" towarow.")
	print("Lacznie na magazynie jest: " +str(lil) +" sztuk wszystkich produktow.")
