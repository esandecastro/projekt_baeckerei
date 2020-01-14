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
dateiname <- "umsatzdaten_gekuerzt.csv"

# Umsatzdaten einlesen
umsatzdaten <- read.csv(file.path(daten_pfad, dateiname))

# Spalte "Datum" als Daten formatieren
umsatzdaten$Datum <- as.Date(umsatzdaten$Datum)

# Erstellen einer Datums-Variable, die jedes Datum vom ältesten bis zum jüngsten genau einmal enthält
datum <- seq(min(umsatzdaten$Datum), max(umsatzdaten$Datum), by = 1)

# Erstellen eines Vektors mit der Anzahl an Tagen vor dem bisherigen für den jeweils der Umsatz gemittelt werden soll (kann
# beliebig erweitert werden)
anzahl_tage <- c(1, 3, 7, 30)

# Initialisieren eines leeren Listen-Objekts, in dem die gemittelten Umsätze der letzten Tage gespeichert werden (jeweils für
# alle in "anzahl_tage" spezifizierten Abstände)
vorheriger_umsatz <- replicate(length(anzahl_tage), list(numeric(length(datum))))

# Für jede Anzahl an Tagen in "anzahl_tage" wird der Mittelwert des Umsatzes über diese Anzahl an Tagen vor dem derzeitigen
# Tag gebildet und in dem jeweiligen Vektor der Liste gespeichert
for (j in 1:length(anzahl_tage)) {
  for (k in 1:length(datum)) {
    vorheriger_umsatz[[j]][k] <- mean(umsatzdaten$Umsatz[umsatzdaten$Datum %in% seq(datum[k] - anzahl_tage[j], datum[k] - 1, by = 1)])
  }
}

# Zusammenführen der Vektoren in einem neuen Datensatz
vorherige_umsatzdaten <- data.frame(Datum = datum, vorheriger_umsatz)

# Sinnvolle Bezeichnung der Spalten
colnames(vorherige_umsatzdaten)[2:ncol(vorherige_umsatzdaten)] <- paste("Umsatz_letzte", anzahl_tage, "Tage", sep = "_")

# Abspeichern des neuen Datensatzes
write.csv(vorherige_umsatzdaten, file.path(daten_pfad, "vorherige_umsatzdaten.csv"), row.names = FALSE)
