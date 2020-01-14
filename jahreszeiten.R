# Einbinden benötigter Bibliotheken 
library(readr) 
library(lubridate) 
library(ggplot2)
library(dplyr)
library(openair)

# Package installieren/laden, das es erlaubt, den Pfad des aktiven Dokuments zu extrahieren
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
  library(rstudioapi) 
}

# Daten von datei importieren
# Einlesen der Umsatzdaten 
umsatzdaten <- read_csv("data/umsatzdaten_gekuerzt.csv")

#datum <- as.Date(umsatzdaten$Datum, format = "%d.%m.%Y")
#Spalten für arbeiten mit daten
umsatzdaten[order(umsatzdaten$Datum ),]

# Funktion dass anzeigt die Jahreszeiten jeder Zeile
toSeason <- function(data) {
  # Spalten definieren für arbeiten mit datum
  data$Monat <-format(data$Datum, "%m")
  data$Jahr  <-format(data$Datum, "%Y")
  data$Tag   <- format(data$Datum, "%d")
  
  # vektor definieren
  jahrzeitenV <- ""
  
  for (zeile in seq(1:nrow(data))){
    m <- data$Monat[zeile]
    d <- data$Tag[zeile]
    
    if ((m == "03" & d >= "21") | (m == "04") | (m == "05") | (m == "06" & d < "21")) {
      r <- "Frühling"
    } else if ((m == "06" & d >= "21") | (m == "07") | (m == "08") | (m == "09" & d < "21")) {
      r <- "Sommer"
    } else if ((m == "09" & d >= "21") | (m == "10") | (m == "11") | (m == "12" & d < "21")) {
      r <- "Herbst"
    } else if ((m == "12" & d >= "21") | (m == "01") | (m == "02") | (m == "03" & d < "21")){
      r <- "Winter"
    }
    
    jahrzeitenV[zeile] <- r
  }
  
  #Vektoren zusammenführen
  neuData <- data.frame(Datum = data$Datum, Jahrzeiten = jahrzeitenV)
  
  return(neuData)
}

#Funktion aufrufen
season <- toSeason(umsatzdaten)

#Visualization die daten
#View(season)

#Speichern daten in csv datei
proj_pfad <- getActiveProject()
# Pfad zu den Daten erstellen
daten_pfad <- file.path(proj_pfad, "data")
write.csv(season, file.path(daten_pfad, "jahresdaten.csv"), row.names = FALSE)



