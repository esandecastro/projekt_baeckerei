# Installieren der benötigten Pakete
if (!require(rstudioapi)) {
  install.packages("rstudioapi")
  library(rstudioapi) 
}

if (!require(dplyr)) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require(Metrics)) {
  install.packages("Metrics")
  library(Metrics)
}
if (!require(e1071)) {
  install.packages("e1071")
  library(e1071)
}
if (!require(ggplot2)) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require(readr)) {
  install.packages("readr")
  library(readr)
}

# Arbeitsspeicher leeren
remove(list = ls())
graphics.off()

# Arbeitsverzeichnis auf das Projektverzeichnis setzen
proj_pfad <- getActiveProject()
setwd(proj_pfad)

# Pfad zu den Daten erstellen
daten_pfad <- file.path(proj_pfad, "data")


# Importing Training and Test Data
#house_pricing_test <- read_csv("house_pricing_test.csv")
#house_pricing_train <- read_csv("house_pricing_train.csv")
#daten_train <- read_csv("aufbereitung.csv")
# Durchführen des Aufbereitungs-Skripts (Training Data)
eval(parse("Aufbereitung.R", encoding = "UTF-8"))


#################
# Data Preparation

# Option to check the correctnes of the code with a small (and computationally fast) training data set
# Do not run or uncomment the following line if you want to reduce the dataset size
daten_train <- sample_frac(daten, .10)


# Training the SVM

# Estimation of an SVM with optimized weighting parameters and given standard hyper parameters
# Typically not used; instead, the function svm_tune is used in order to also get a model with optimized hyper parameters
#model_svm <- svm(price ~ bathrooms, house_pricing_train)

# Estimation of various SVM (each with optimized weighting parameters) using systematically varied hyper parameters (typically called 'grid search' approach) and cross validation
# the resulting object includes the optimal model in the element named 'best.model'
#svm_tune <- tune(svm, price ~ bedrooms + bathrooms + sqft_living + zipcode, data=house_pricing_train, ranges = list(epsilon = seq(0.2,1,0.1), cost = 2^(2:3)))

#Erstellen neue Variable ohne NA werte
daten_test <- daten_train[, !seq(1, length(colnames(daten_train))) %in% c(5,6,7,8,10,14)]

svm_tune <- tune (svm, Umsatz ~ Warengruppe + KielerWoche + Zeit_Im_Monat +
                    as.factor(Ferien) + as.factor(FerienCAU) + Umsatz_letzte_3_Tage +
                    Umsatz_letzte_7_Tage + Umsatz_letzte_30_Tage + Feiertag_in_weniger_als_1_Tagen +
                    Feiertag_in_weniger_als_2_Tagen + Feiertag_in_weniger_als_3_Tagen + Feiertag_vor_weniger_als_1_Tagen +
                    Feiertag_vor_weniger_als_2_Tagen + Feiertag_vor_weniger_als_3_Tagen + Wochentag,
                  data = daten_test, ranges = list(epsilon = seq(0.2,1,0.1), cost = 2^(2:3)))

#svm_tune <- tune (svm, Umsatz ~ Warengruppe + as.factor(Bewoelkung) + Temperatur + Windgeschwindigkeit +
                   # as.factor(Wettercode) + KielerWoche + Zeit_Im_Monat + Jahrzeiten +
                    #as.factor(Ferien) + as.factor(FerienCAU) +
                    #Umsatz_letzte_1_Tage + Umsatz_letzte_3_Tage +
                    #Umsatz_letzte_7_Tage + Umsatz_letzte_30_Tage + Feiertag_in_weniger_als_1_Tagen +
                    #Feiertag_in_weniger_als_2_Tagen + Feiertag_in_weniger_als_3_Tagen + Feiertag_vor_weniger_als_1_Tagen +
                    #Feiertag_vor_weniger_als_2_Tagen + Feiertag_vor_weniger_als_3_Tagen + Wochentag,
                  #data = daten_train, ranges = list(epsilon = seq(0.2,1,0.1), cost = 2^(2:3)))

#################
# Checking the prediction Quality

# Calculating the prediction for the training data using the best model according to the grid search
#pred_train <- predict(svm_tune$best.model, house_pricing_train)

# Calculating the prediction for the test data using the best model according to the grid search
#pred_test <- predict(svm_tune$best.model, house_pricing_test)

# Calculating the prediction quality for the training data using the MAPE
#mape(house_pricing_train$price, pred_train)

# Calculating the prediction quality for the training data using the MAPE
#mape(house_pricing_test$price, pred_test)

