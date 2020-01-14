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

# Erstellen einer Datums-Variable, die jedes Datum vom ältesten bis zum jüngsten genau einmal enthält und zusätzlich 31
# weitere Tage abbildet. Dies stellt sicher, dass die Zuordnung von Monatsanfang, -mitte und -ende auch dann funktioniert,
# wenn Daten nicht für einen gesamten Monat angegeben werden. Die 31 zusätzlichen Tage werden vor dem Speichern des
# Datensatzes wieder entfernt.
datum <- seq(min(umsatzdaten$Datum), max(umsatzdaten$Datum) + 31, by = 1)

# Extrahieren des Tages
tag <- as.numeric(format(datum, "%d"))

# Extrahieren des Montats
monat <- format(datum, "%m")

jahr <- format(datum, "%Y")

# Erstellen eines leeren Vektors, der mit den Codes f?r unterschiedliche Zeiten im Monat gefüllt wird
zeit_im_monat <- numeric(length(datum))

# Kodieren der Zeit des Monats mit "1" für ersten sieben Tage jedes Monats mit "1"
zeit_im_monat[tag %in% 1:7] <- 1

# Die Zeit des Monats wird für die ersten sieben Tage des aktuellen Monats als "1" kodiert
for (j in 1:length(unique(jahr))) {
  # Temporäre Variable, in der das Jahr der aktuellen Iteration abgespeichert ist
  tmp_jahr <- unique(jahr)[j]
  for (k in 1:length(unique(monat[jahr == tmp_jahr]))) {
    # Temporäre logische Variable, in der die Einträge zum Monat aktuellen Iteration (für das aktuelle Jahr) mit TRUE und
    # alle anderen Einträge mit FALSE kodiert sind (wird im Folgenden zur Indizierung genutzt)
    tmp_monat <- jahr == tmp_jahr & monat == unique(monat[jahr == tmp_jahr])[k]
    
    # Die Zeit des Monats wird für die letzten sieben Tage des aktuellen Monats als "3" kodiert (durch das Hinzufügen der 31
    # Tage ist an dieser Stelle gewährleistet, dass für den relevanten Bereich der Daten auf jeden Fall die letzten Tage
    # jedes Monats (insbesondere des letzten) enthalten sind)
    zeit_im_monat[tmp_monat][tag[tmp_monat] > max(tag[tmp_monat]) - 7] <- 3
  }
}

# Die Zeit des Monats wird für die restlichen Tage des aktuellen Monats als "2" kodiert
zeit_im_monat[zeit_im_monat == 0] <- 2

# Konvertierung zu einem Faktor mit den levels "Monatsanfang", "Monatsmitte" und "Monatsende"
zeit_im_monat <- factor(zeit_im_monat, levels = c(1, 2, 3), labels = c("Monatsanfang", "Monatsmitte", "Monatsende"))

# Entfernen der 31 zusätzlichen Tage aus den beiden Vektoren
datum <- datum[1:(length(datum) - 31)]
zeit_im_monat <- zeit_im_monat[1:(length(zeit_im_monat) - 31)]

# Zusammenführen der beiden Vektoren in einem neuen Datensatz
monatsdaten <- data.frame(Datum = datum, Zeit_Im_Monat = zeit_im_monat)

# Abspeichern des neuen Datensatzes
write.csv(monatsdaten, file.path(daten_pfad, "monatsdaten.csv"), row.names = FALSE)
