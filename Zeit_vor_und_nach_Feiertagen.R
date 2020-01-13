# Package installieren/laden, das es erlaubt, den Pfad des aktiven Dokuments zu extrahieren
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
  library(rstudioapi) 
}

# Arbeitsspeicher leeren
remove(list = ls())
graphics.off()

# Arbeitsverzeichnis auf das Projektverzeichnis setzen
proj_pfad <- getActiveProject()
setwd(proj_pfad)

# Pfad zu den Daten erstellen
daten_pfad <- file.path(proj_pfad, "data")

# Name der einzulesenen Datei
dateiname <- "feiertage.csv"

# Umsatzdaten einlesen
feiertage <- read.csv(file.path(daten_pfad, dateiname))

# Spalte "Datum" als Daten formatieren und in neuem Vektor speichern
datum <- as.Date(feiertage$Datum)

# Erstellen eines Vektors mit der Anzahl an Tagen, die vor bzw. nach Feiertagen berücksichtigt werden soll (kann beliebig
# erweitert werden)
anzahl_tage <- c(1, 2, 3)

# Initialisieren von leeren Listen-Objekten, in denen gespeichert wird, ob in den nächsten bzw. letzen Tagen vor dem
# derzeitigen ein Feiertag war oder nicht (jeweils für alle in "anzahl_tage" spezifizierten Abstände)
tage_vor_feiertag <- replicate(length(anzahl_tage), list(character(length(datum))))
tage_nach_feiertag <- replicate(length(anzahl_tage), list(character(length(datum))))

# Kodieren, ob in den nächsten/letzten Tagen ein Feiertag war oder nicht
for (j in 1:length(anzahl_tage)) {
  for (k in 1:length(datum)) {
    
    if ("Feiertag" %in% feiertage$Feiertag[datum %in% seq(datum[k] + 1, datum[k] + anzahl_tage[j], by = 1)]) {
      tage_vor_feiertag[[j]][k] <- paste("Feiertag in <", anzahl_tage[j], "Tagen")
    } else {
      tage_vor_feiertag[[j]][k] <- paste("Kein Feiertag in <", anzahl_tage[j], "Tagen")
    }
    
    if ("Feiertag" %in% feiertage$Feiertag[datum %in% seq(datum[k] - anzahl_tage[j], datum[k] - 1, by = 1)]) {
      tage_nach_feiertag[[j]][k] <- paste("Feiertag vor <", anzahl_tage[j], "Tagen")
    } else {
      tage_nach_feiertag[[j]][k] <- paste("Kein Feiertag vor <", anzahl_tage[j], "Tagen")
    }
    
  }
}

# Zusammenführen der Vektoren in einem neuen Datensatz
zeit_vor_und_nach_feiertagen <- data.frame(Datum = datum, tage_vor_feiertag, tage_nach_feiertag)

# Sinnvolle Bezeichnung der Spalten
colnames(zeit_vor_und_nach_feiertagen)[2:(length(anzahl_tage) + 1)] <- paste("Feiertag_in_weniger_als", anzahl_tage, "Tagen", sep = "_")

colnames(zeit_vor_und_nach_feiertagen)[(length(anzahl_tage) + 2):ncol(zeit_vor_und_nach_feiertagen)] <-
  paste("Feiertag_vor_weniger_als", anzahl_tage, "Tagen", sep = "_")

# Abspeichern des neuen Datensatzes
write.csv(zeit_vor_und_nach_feiertagen, file.path(daten_pfad, "zeit_vor_und_nach_feiertagen.csv"), row.names = FALSE)
