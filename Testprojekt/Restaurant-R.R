# Zeitreihenanalyse von Restaurant

# Quartale in Vektor speichern
quartaleVergangenheit = c()

for (i in 2:13){quartaleVergangenheit[i-1] = RestaurantUmsaetze[3,i]}


# Ums�tze in Vektor speichern
umsatzVergangenheit = c()

for (i in 2:13){umsatzVergangenheit[i-1] = RestaurantUmsaetze[2,i]}

# Plotten und Regressionsgerade ermitteln und zeichnen

# fit = lm(umsatzVergangenheit ~ quartaleVergangenheit)
# summary(fit)

lm(formula = umsatzVergangenheit ~ quartaleVergangenheit)

plot(quartaleVergangenheit,umsatzVergangenheit, main = "Ums�tze 2004-2006", xlab = "Quartale", ylab = "Umsatz in TEUR", type = "b", col = "red")
abline(fit, lty = 2, col = "blue")

# Trendwerte bestimmen

regressionsGerade = coefficients(fit)
steigungReg = regressionsGerade[2]

regressionY_Achse = regressionsGerade[1]

#Trendwerte bef�llen
trendwerte = c()
saisonKomponente = c()

for(i in 1:16){
  trendwerte[i] = regressionY_Achse + (steigungReg * i)
}

#reale Saisonkomponente
for(i in 1:12){
  saisonKomponente[i] = RestaurantUmsaetze[2,i+1] - trendwerte[i]
}

# saisonkomponente bef�llen
a = 1
for(i in 13:16){
  saisonKomponente[i] = (saisonKomponente[a] + saisonKomponente[a+4] + saisonKomponente[a+8]) / 3
  a = a + 1
}

prognoseUmsatz = c()

for (i in 13:16){
  prognoseUmsatz[i] = trendwerte[i] + saisonKomponente[i]
  quartaleVergangenheit[i] = i
  umsatzVergangenheit[i] = prognoseUmsatz[i]
}

# fit = lm(umsatzVergangenheit ~ quartaleVergangenheit)
# summary(fit)

# lm(formula = umsatzVergangenheit ~ quartaleVergangenheit)

plot(quartaleVergangenheit,umsatzVergangenheit, main = "Ums�tze mit Prognose f�r Folgejahr", xlab = "Quartale", ylab = "Umsatz in TEUR", type = "b", col = "red")
abline(fit, lty = 2, col = "blue")

# Intervallsch�tzung
new = data.frame(Umsatz = c(13,14,15,16))
intervallschaetzung = predict(fit, newdata = new, se.fit = TRUE, interval = "confidence", level = 0.95)
intervallschaetzung
View (intervallschaetzung, "IntervallschaetzungWerte")

intervallsch�tzungTabelle = data.frame(intervallschaetzung)
colnames(intervallsch�tzungTabelle) = c("AVERAGE_PREDICTIVE_SALE", "LOWER_PREDICTIVE_SALE", "UPPER_PREDICTIVE_SALE", "AVERAGE_PREDICTIVE_SALE", "LOWER_PREDICTIVE_SALE", "UPPER_PREDICTIVE_SALE")
intervallsch�tzungTabelle