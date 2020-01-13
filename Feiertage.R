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

FeiertagV <- character(length(datum))

for (zeile in seq(1:length(datum))){
  # m <- umsatzdaten$Monat[zeile]
  # d <- umsatzdaten$Tag[zeile]
  # y <- umsatzdaten$Jahr[zeile]
  
  
  d <- format(datum[zeile], "%d")
  m <- format(datum[zeile], "%m")
  y <- format(datum[zeile], "%Y")
  
  if ((y== "2012" && m == "10" && d == "03") | (y== "2012" && m == "12" && d == "25") | (y== "2012" && m == "12" && d == "26") | 
      (y== "2012" && m == "04" && d == "06") | (y== "2012" && m == "04" && d == "09") | (y== "2012" && m == "05" && d == "28") |
      (y== "2013" && m == "01" && d == "01") | (y== "2013" && m == "10" && d == "03") | (y== "2013" && m == "05" && d == "01") | 
      (y== "2013" && m == "12" && d == "25") | (y== "2013" && m == "12" && d == "26") | (y== "2013" && m == "03" && d == "29") | 
      (y== "2013" && m == "04" && d == "01") | (y== "2013" && m == "05" && d == "09") | (y== "2013" && m == "05" && d == "20") | 
      (y== "2014" && m == "01" && d == "01") | (y== "2014" && m == "10" && d == "03") | (y== "2014" && m == "05" && d == "01") | 
      (y== "2014" && m == "12" && d == "25") | (y== "2014" && m == "12" && d == "26") | (y== "2014" && m == "04" && d == "18") | 
      (y== "2014" && m == "04" && d == "21") | (y== "2014" && m == "05" && d == "29") | (y== "2014" && m == "06" && d == "09") | 
      (y== "2015" && m == "01" && d == "01") | (y== "2015" && m == "10" && d == "03") | (y== "2015" && m == "05" && d == "01") | 
      (y== "2015" && m == "12" && d == "25") | (y== "2015" && m == "12" && d == "26") | (y== "2015" && m == "04" && d == "03") | 
      (y== "2015" && m == "04" && d == "06") | (y== "2015" && m == "05" && d == "14") | (y== "2015" && m == "05" && d == "25") | 
      (y== "2016" && m == "01" && d == "01") | (y== "2016" && m == "10" && d == "03") | (y== "2016" && m == "05" && d == "01") | 
      (y== "2016" && m == "12" && d == "25") | (y== "2016" && m == "12" && d == "26") | (y== "2016" && m == "03" && d == "25") |
      (y== "2016" && m == "03" && d == "28") | (y== "2016" && m == "05" && d == "05") | (y== "2016" && m == "05" && d == "16") | 
      (y== "2017" && m == "01" && d == "01") | (y== "2017" && m == "10" && d == "03") | (y== "2017" && m == "05" && d == "01") | 
      (y== "2017" && m == "12" && d == "25") | (y== "2017" && m == "12" && d == "26") | (y== "2017" && m == "04" && d == "14") | 
      (y== "2017" && m == "04" && d == "17") | (y== "2017" && m == "05" && d == "25") | (y== "2017" && m == "06" && d == "05") | 
      (y== "2017" && m == "10" && d == "31") 
  )
  {r <- "Feiertag"} 
  else {r <- "Kein Feiertag"} 
  
  FeiertagV[zeile] <- r
}


# Vektoren zusammenführen
neuData <- data.frame(Datum = datum, Feiertag=FeiertagV)

# Abspeichern des neuen Datensatzes
write.csv(neuData, file.path(daten_pfad, "feiertage.csv"), row.names = FALSE)
