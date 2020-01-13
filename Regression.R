# Modellieren der Daten mittels linearer Regression

# Installieren der benötigten Pakete
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

# Durchführen des Aufbereitungs-Skripts ("source" führt zum fehlerhaften Durchführen mit Umlauten, daher die explizite Angabe der Unicode-Kodierung)
eval(parse("Aufbereitung.R", encoding = "UTF-8"))

# Modell mit allen Variablen
mod <- lm(Umsatz ~ Warengruppe +
            as.factor(Bewoelkung) +
            Temperatur +
            Windgeschwindigkeit +
            as.factor(Wettercode) +
            KielerWoche +
            Zeit_Im_Monat +
            Jahrzeiten +
            as.factor(Ferien) +
            as.factor(FerienCAU) +
            Umsatz_letzte_1_Tage +
            Umsatz_letzte_3_Tage +
            Umsatz_letzte_7_Tage +
            Umsatz_letzte_30_Tage +
            Feiertag_in_weniger_als_1_Tagen +
            Feiertag_in_weniger_als_2_Tagen +
            Feiertag_in_weniger_als_3_Tagen +
            Feiertag_vor_weniger_als_1_Tagen +
            Feiertag_vor_weniger_als_2_Tagen +
            Feiertag_vor_weniger_als_3_Tagen +
            Wochentag,
          daten)

summary(mod)

# Modell mit ausgewählten Variablen
mod <- lm(Umsatz ~ Warengruppe +
            #as.factor(Bewoelkung) +
            Temperatur +
            Windgeschwindigkeit +
            as.factor(Wettercode) +
            KielerWoche +
            Zeit_Im_Monat +
            Jahrzeiten +
            as.factor(Ferien) +
            as.factor(FerienCAU) +
            Umsatz_letzte_1_Tage +
            #Umsatz_letzte_3_Tage +
            Umsatz_letzte_7_Tage +
            #Umsatz_letzte_30_Tage +
            Feiertag_in_weniger_als_1_Tagen +
            #Feiertag_in_weniger_als_2_Tagen +
            #Feiertag_in_weniger_als_3_Tagen +
            #Feiertag_vor_weniger_als_1_Tagen +
            Feiertag_vor_weniger_als_2_Tagen +
            #Feiertag_vor_weniger_als_3_Tagen +
            Wochentag,
          daten)

summary(mod)
