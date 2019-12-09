library(readr)
#umsatzdaten_gekuerzt <- read.csv("data/umsatzdaten_gekuerzt.csv", stringsAsFactors = F)
#Schulferien <- read.csv("data/Bäckerei_Schulferien.csv", sep = ";", stringsAsFactors = F)


# Schulferien --------------------------------------------------------
schulferien_importieren <- function(umsatzdaten_gekuerzt, Schulferien){
  umsatzdaten_gekuerzt$Datum <- as.Date(umsatzdaten_gekuerzt$Datum)
  umsatzdaten_gekuerzt$Ferien <- 0
  
  for (zeile in seq(1:nrow(Schulferien))){
    
    datum_von <- as.Date(Schulferien$Von[zeile])
    datum_bis <- as.Date(Schulferien$Bis[zeile])
    
    ferien <- umsatzdaten_gekuerzt$Datum >= datum_von & 
              umsatzdaten_gekuerzt$Datum <= datum_bis
    
    umsatzdaten_gekuerzt[ferien, "Ferien"] <- 1
  }  
  
  return(umsatzdaten_gekuerzt)
}

#Funktion ausführen und ansehen:
#umsatzdaten_gekuerzt <- schulferien_importieren(umsatzdaten_gekuerzt, Schulferien)
#View(umsatzdaten_gekuerzt)



#Semesterferien

Semesterferien <- read.csv("data/Semesterferien.csv", sep = ";", stringsAsFactors = F)
colnames(Semesterferien) <- c('Von', 'Bis')

semesterferien_importieren <- function(umsatzdaten_gekuerzt, Semesterferien){
  umsatzdaten_gekuerzt$Datum <- as.Date(umsatzdaten_gekuerzt$Datum)
  umsatzdaten_gekuerzt$FerienCAU <- 0
  
  for (zeile in seq(1:nrow(Semesterferien))){
    
    datum_von <- as.Date(Semesterferien$Von[zeile])
    datum_bis <- as.Date(Semesterferien$Bis[zeile])
    
    ferien <- umsatzdaten_gekuerzt$Datum >= datum_von & 
      umsatzdaten_gekuerzt$Datum <= datum_bis
    
    umsatzdaten_gekuerzt[ferien, "FerienCAU"] <- 1
  }  
  
  return(umsatzdaten_gekuerzt)
}

#Funktion ausführen und ansehen:
#umsatzdaten_gekuerzt <- semesterferien_importieren(umsatzdaten_gekuerzt, Semesterferien)
#View(umsatzdaten_gekuerzt)
