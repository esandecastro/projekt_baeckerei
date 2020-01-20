# Modellieren der Daten mittels linearer Regression

# Installieren der benötigten Pakete
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
  library(rstudioapi) 
}
if (!require(broom)) {
  install.packages("broom")
  library(broom)
}
if (!require(Metrics)){
  install.packages("Metrics")
  library(Metrics)
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
mod1 <- lm(Umsatz ~ Warengruppe + as.factor(Bewoelkung) + Temperatur + Windgeschwindigkeit +
            as.factor(Wettercode) + KielerWoche + Zeit_Im_Monat + Jahrzeiten +
            as.factor(Ferien) + as.factor(FerienCAU) +
            Umsatz_letzte_1_Tage + Umsatz_letzte_3_Tage +
            Umsatz_letzte_7_Tage + Umsatz_letzte_30_Tage + Feiertag_in_weniger_als_1_Tagen +
            Feiertag_in_weniger_als_2_Tagen + Feiertag_in_weniger_als_3_Tagen + Feiertag_vor_weniger_als_1_Tagen +
            Feiertag_vor_weniger_als_2_Tagen + Feiertag_vor_weniger_als_3_Tagen + Wochentag,
          daten)

summary(mod1)

# Modell mit ausgewählten Variablen
mod2 <- lm(Umsatz ~ Warengruppe + Temperatur + Windgeschwindigkeit +
            as.factor(Wettercode) + KielerWoche + Zeit_Im_Monat + Jahrzeiten +
            as.factor(Ferien) + as.factor(FerienCAU) + Umsatz_letzte_1_Tage + Umsatz_letzte_7_Tage +
            Feiertag_in_weniger_als_1_Tagen +
            Feiertag_vor_weniger_als_2_Tagen +
            Wochentag,
           daten)

summary(mod2)

# Modell mit ausgewählten Variablen
mod3 <- lm(Umsatz ~ Warengruppe + Temperatur +
             Windgeschwindigkeit + as.factor(Wettercode) + KielerWoche +
             Zeit_Im_Monat + Jahrzeiten + as.factor(Ferien) + as.factor(FerienCAU) +
             #Umsatz_letzte_1_Tage +
             Umsatz_letzte_3_Tage +
             #Umsatz_letzte_7_Tage +
             #Umsatz_letzte_30_Tage +
             Feiertag_in_weniger_als_1_Tagen +
             Feiertag_in_weniger_als_2_Tagen +
             #Feiertag_in_weniger_als_3_Tagen +
             Feiertag_vor_weniger_als_1_Tagen +
             Feiertag_vor_weniger_als_2_Tagen +
             #Feiertag_vor_weniger_als_3_Tagen +
             Wochentag,
           daten)

summary(mod3)


# Vorbereitung ergebnisse modelen
rbind(glance(mod1), glance(mod2), glance(mod3))
mod1_predict <- predict(mod1)
# Model Prediction Quality für die Training Data mit Mean Absolute Error
# rbind(mae(daten$Umsatz, predict(mod1)),
#       mae(daten$Umsatz, predict(mod2)),
#       mae(daten$Umsatz, predict(mod3)))
     

# Model Prediction Quality für die Training Data mitMean Absolute Percentage Error
# rbind(mape(daten$Umsatz, predict(mod1)),
#       mape(daten$Umsatz, predict(mod2)),
#       mape(daten$Umsatz, predict(mod3)))


# Model Prediction Quality for the (Unknown) Test Data Using the Mean Absolute Percentage Error
# rbind(mape(daten$Umsatz, predict(mod1, newdata=daten_test)),
#       mape(daten$Umsatz, predict(mod2, newdata=daten_test)),
#       mape(daten$Umsatz, predict(mod3, newdata=daten_test)))
