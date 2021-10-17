#Izabela Gorlinska grupa 1
#skrypt zaliczeniowy python
import csv

def istnieje(spis, prod, l):
	j=0
	with open(spis) as csv_file:
		csv_reader = csv.reader(csv_file, delimiter=',')
		for row in csv_reader:
			if row[0]==prod:
				j=1
	if  j==1:
		return j
	elif l==1:
		print("Produktu '" +prod +"' nie ma w bazie. Nie udalo sie wprowadzic zmiany ;(")
		return j
	else:
		print("Nie ma produktu '" +prod +"' w bazie " +spis +" :(")
		return j


