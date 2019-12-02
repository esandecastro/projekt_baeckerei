# Installieren der benoetigten Pakete
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
  library(rstudioapi) 
}

if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}

# Arbeitsspeicher leeren
remove(list = ls())
graphics.off()

# Arbeitsverzeichnis auf das Projektverzeichnis setzen
proj_pfad <- getActiveProject()
setwd(proj_pfad)

# Pfad zu den Daten erstellen
daten_pfad <- file.path(proj_pfad, "data")

# Angabe aller Namen von Dateien, die verknuepft werden sollen (müssen alle eine Spalte namens "Datum" haben und das Komma als
# Trennzeichen haben)
dateinamen <- c("umsatzdaten_gekuerzt.csv", "kiwo.csv", "wetter.csv", "monatsdaten.csv")


# Zusammenführung der Daten

# Abspeichern des ersten Datensatzes, zu dem die weiteren in der folgenden Schleife hinzugefügt werden
daten <- read.csv(file.path(daten_pfad, dateinamen[1]))

# Formatieren der Spalte "Datum" als Datentyp "Date"
daten$Datum <- as.Date(daten$Datum)

# Hinzufügen der weiteren Datensaetze
for (j in 2:length(dateinamen)) {
  # Einlesen des aktuellen Datensatzes und Abspeichern in einem temporaeren Objekt
  tmp_daten <- read.csv(file.path(daten_pfad, dateinamen[j]))
  
  # Formatieren der Spalte "Datum" als Datentyp "Date"
  tmp_daten$Datum <- as.Date(tmp_daten$Datum)
  
  # Zusammenführen der Daten auf Grundlage der Spalte "Datum"
  daten <- left_join(daten, tmp_daten, by = "Datum")
}


# Aufbereitung der Daten

# Sinnvolle Bezeichnung der unterschiedlichen Warengruppen
daten$Warengruppe <- factor(daten$Warengruppe, levels = 1:6, labels = c("Brot", "Brötchen", "Croissant", "Konditorei", "Kuchen", "Saisonbrot"))

# NA-Werte fuer die Kieler Woche als 0 kodieren (im Datensatz sind nur die Daten für die Kieler Woche enthalten, die
# restlichen fehlen)
daten$KielerWoche[is.na(daten$KielerWoche)] <- 0

# Umwandeln des Kieler-Woche-Vektors in einen Faktor
daten$KielerWoche <- factor(daten$KielerWoche, levels = c(0, 1), labels = c("Keine Kieler Woche", "Kieler Woche"))

# Hinzufügen einer Spalte, die die Wochentage beinhaltet
daten$Wochentag <- weekdays(daten$Datum)

# Ordnen des Faktors zur Zeit im Monat
daten$Zeit_Im_Monat <- ordered(daten$Zeit_Im_Monat, levels = c("Monatsanfang", "Monatsmitte", "Monatsende"))