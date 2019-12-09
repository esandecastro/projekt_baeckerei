# Einbinden benötigter Bibliotheken 
library(readr) 
library(lubridate) 
library(ggplot2)
library(dplyr)
library(openair)

# Jahreszeiten definieren
# Daten von datei importieren
# Einlesen der Umsatzdaten 
umsatzdaten <- read_csv("data/umsatzdaten_gekuerzt.csv")
wetterdaten <- read_csv("data/wetter.csv")
#datum <- as.Date(umsatzdaten$Datum, format = "%d.%m.%Y")

umsatzdaten[order(umsatzdaten$Datum ),]
umsatzdaten$Monat <-format(umsatzdaten$Datum, "%m")
umsatzdaten$Jahr <-format(umsatzdaten$Datum, "%Y")
umsatzdaten$Tag <- format(umsatzdaten$Datum, "%d")

# Neue variable Jahrzeiten definieren => fangt alle jahrzeiten am 01 tag des monats an
# spalte Date definieren für cutdata funktion nötig
#umsatzdaten$date <- as.Date(umsatzdaten$Datum, "%Y/%m/%d")
#jahrzeiten <- cutData(umsatzdaten,'seasonyear','northern', 4, 1)

# Funktion dass anzeigt die Jahreszeiten jeder Zeile
toSeason <- function(data) {
  datum <- data$Datum
  data$Jahrzeiten <- ""
  #stopifnot(class(datum) == "Date")
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
    
    data$Jahrzeiten[zeile] <- r
  }
  return(data)
}

#In session Variable speichern
season <- toSeason(umsatzdaten)
#In session Variable speichern
#season <- toSeason(wetterdaten)
#Visualization die daten
View(season)
