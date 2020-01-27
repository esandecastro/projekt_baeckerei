# Installieren der benötigten Pakete
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
}

if (!require(dplyr)) {
  install.packages("dplyr")
  
}
if (!require(mice)) {
  install.packages("mice")
}

library(rstudioapi)
library(dplyr)
library (lattice)
library(mice)

# Arbeitsspeicher leeren
#remove(list = ls())
#graphics.off()

# Arbeitsverzeichnis auf das Projektverzeichnis setzen
proj_pfad <- getActiveProject()
setwd(proj_pfad)

# Pfad zu den Daten erstellen
daten_pfad <- file.path(proj_pfad, "data")

# Angabe aller Namen von Dateien, die verknüpft werden sollen (müssen alle eine Spalte namens "Datum" haben und das Komma als
# Trennzeichen haben)
dateinamen <- c("umsatzdaten_gekuerzt.csv", "kiwo.csv", "wetter.csv", "monatsdaten.csv", "jahresdaten.csv", "ferien.csv",
                "feiertage.csv", "zeit_vor_und_nach_feiertagen.csv", "vorherige_umsatzdaten.csv")



# Zusammenführung der Daten

# Abspeichern des ersten Datensatzes, zu dem die weiteren in der folgenden Schleife hinzugefügt werden
daten <- read_csv(file.path(daten_pfad, dateinamen[1]))

# Formatieren der Spalte "Datum" als Datentyp "Date"
daten$Datum <- as.Date(daten$Datum)

# Hinzufügen der weiteren Datensätze
for (j in 2:length(dateinamen)) {
  # Einlesen des aktuellen Datensatzes und Abspeichern in einem temporären Objekt
  tmp_daten <- read_csv(file.path(daten_pfad, dateinamen[j]))
  
  # Formatieren der Spalte "Datum" als Datentyp "Date"
  tmp_daten$Datum <- as.Date(tmp_daten$Datum)
  
  # Zusammenführen der Daten auf Grundlage der Spalte "Datum"
  daten <- left_join(daten, tmp_daten, by = "Datum")
}

# Entfernung von eventuell entstandenen gedoppelten Reihen
daten <- daten[!duplicated(daten), ]

# Aufbereitung der Daten

# Sinnvolle Bezeichnung der unterschiedlichen Warengruppen
daten$Warengruppe <- factor(daten$Warengruppe, levels = 1:6, labels = c("Brot", "Brötchen", "Croissant", "Konditorei", "Kuchen", "Saisonbrot"))

# NA-Werte für die Kieler Woche als 0 kodieren (im Datensatz sind nur die Daten für die Kieler Woche enthalten, die
# restlichen fehlen)
daten$KielerWoche[is.na(daten$KielerWoche)] <- 0


# Umwandeln des Kieler-Woche-Vektors in einen Faktor
daten$KielerWoche <- factor(daten$KielerWoche, levels = c(0, 1), labels = c("Keine Kieler Woche", "Kieler Woche"))

# Hinzufügen einer Spalte, die die Wochentage (geordnet) beinhaltet
daten$Wochentag <- ordered(weekdays(daten$Datum), levels = c("Montag", "Dienstag", "Mittwoch", "Donnerstag", "Freitag", "Samstag", "Sonntag"))

# Ordnen des Faktors zur Zeit im Monat
daten$Zeit_Im_Monat <- ordered(daten$Zeit_Im_Monat, levels = c("Monatsanfang", "Monatsmitte", "Monatsende"))

# Ordnen des Faktors zu den Jahreszeiten
daten$Jahrzeiten <- ordered(daten$Jahrzeiten, levels = c("Frühling", "Sommer", "Herbst", "Winter"))

# Konvertieren zu Faktoren
daten$Feiertag_in_weniger_als_1_Tagen <- as.factor(daten$Feiertag_in_weniger_als_1_Tagen)
daten$Feiertag_in_weniger_als_2_Tagen <- as.factor(daten$Feiertag_in_weniger_als_2_Tagen)
daten$Feiertag_in_weniger_als_3_Tagen <- as.factor(daten$Feiertag_in_weniger_als_3_Tagen)
daten$Feiertag_vor_weniger_als_1_Tagen <- as.factor(daten$Feiertag_vor_weniger_als_1_Tagen)
daten$Feiertag_vor_weniger_als_2_Tagen <- as.factor(daten$Feiertag_vor_weniger_als_2_Tagen)
daten$Feiertag_vor_weniger_als_3_Tagen <- as.factor(daten$Feiertag_vor_weniger_als_3_Tagen)

# Impute Data für Nan Werte
#"norm.nob", "norm.predict"
imp <- mice(daten, method = "norm.nob", m = 1) # Impute data
daten <- complete(imp) # Store data 

#Speichern daten in csv datei
#write.csv(daten, file.path(daten_pfad, "aufbereitung.csv"), row.names = FALSE, fileEncoding = "utf-8")
write_csv(daten, file.path(daten_pfad, "aufbereitung.csv"))


