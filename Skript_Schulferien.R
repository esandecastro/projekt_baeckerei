library(readr)
#umsatzdaten_gekuerzt <- read.csv("data/umsatzdaten_gekuerzt.csv")
#Schulferien <- read.csv("data/Bäckerei_Schulferien.csv", sep = ";", stringsAsFactors = F)


# Schulferien --------------------------------------------------------
schulferien_importieren <- function(umsatzdaten_gekuerzt, Schulferien){
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
umsatzdaten_gekuerzt <- schulferien_importieren(umsatzdaten_gekuerzt, Schulferien)
View(umsatzdaten_gekuerzt)
