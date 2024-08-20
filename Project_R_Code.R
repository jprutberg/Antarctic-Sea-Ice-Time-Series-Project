# Import Data and Convert into Time Series Object
Ice <- read.table("Sea Ice.txt")
Ice <- c(t(as.matrix(Ice)))
Ice <- ts(data = Ice, start = c(1989, 1), frequency = 12)

# Load Packages
library(tseries)
library(forecast)
library(TSA)

# Plot Time Series (Figure 1)
plot(Ice, xlab = "Year", 
     ylab = "Average Monthly Antarctic Sea Ice (Millions of Square Kilometers)",
     main = "Figure 1: Average Monthly Antarctic Sea Ice from 1989 to 2023", 
     col = "blue", cex.main = 2)

# Classical Decomposition (Figure 2)
decomp.plot <- function(x, main = NULL, ...) {
  if(is.null(main))
    main <- paste("Decomposition of", x$type, "time series")
  plot(cbind(observed = x$random + if (x$type == "additive")
    x$trend + x$seasonal
    else x$trend * x$seasonal, trend = x$trend, seasonal = x$seasonal, random = x$random), main = main, ...)
}

z <- decompose(Ice, type = "additive") 
decomp.plot(z, main = "Figure 2: Additive Decomposition of Sea Ice Data", cex.main = 2)

# ADF Test + Plot of Seasonally Differenced Data (Figure 3)
adf.test(Ice) # Appears stationary (but we know it's NOT)

Ice_diff <- diff(diff(Ice, lag = 12)) # seasonal difference + first difference
adf.test(Ice_diff) # stationary

plot(Ice_diff, xlab = "Year", 
     ylab = "Differenced Average Monthly Antarctic Sea Ice (Millions of Square Kilometers)",
     main = "Figure 3: Differenced Average Monthly Antarctic Sea Ice", 
     col = "orange", cex.main = 2)

# ACF and PACF Plots (Figure 4)
ACF <- acf(Ice_diff, main = "Figure 4a: Differenced Data Sample ACF", ylim = c(-1,1), lag.max = 50)
PACF <- pacf(Ice_diff, main = "Figure 4b: Differenced Data Sample PACF", ylim = c(-1,1), lag.max = 50)

# Automatic Model Selection
auto.arima(Ice_diff)
fit <- armasubsets(y = Ice_diff, nar = 20, nma = 20)
plot(fit)

# Manual SARIMA Model Selection
fit_1 <- Arima(Ice, order = c(1,1,1), seasonal = list(order = c(0,1,1), period = 12))
fit_1

fit_2 <- Arima(Ice, order = c(1,1,2), seasonal = list(order = c(0,1,1), period = 12))
fit_2

fit_3 <- Arima(Ice, order = c(3,1,0), seasonal = list(order = c(0,1,1), period = 12))
fit_3

fit_4 <- Arima(Ice, order = c(0,1,3), seasonal = list(order = c(0,1,1), period = 12))
fit_4

fit_5 <- Arima(Ice, order = c(1,1,1), seasonal = list(order = c(0,1,2), period = 12))
fit_5

fit_6 <- Arima(Ice, order = c(1,1,2), seasonal = list(order = c(0,1,2), period = 12))
fit_6

fit_7 <- Arima(Ice, order = c(3,1,0), seasonal = list(order = c(0,1,2), period = 12))
fit_7

fit_8 <- Arima(Ice, order = c(0,1,3), seasonal = list(order = c(0,1,2), period = 12))
fit_8

fit_9 <- Arima(Ice, order = c(1,1,1), seasonal = list(order = c(1,1,1), period = 12))
fit_9

fit_10 <- Arima(Ice, order = c(1,1,2), seasonal = list(order = c(1,1,1), period = 12))
fit_10

fit_11 <- Arima(Ice, order = c(3,1,0), seasonal = list(order = c(1,1,1), period = 12))
fit_11

fit_12 <- Arima(Ice, order = c(0,1,3), seasonal = list(order = c(1,1,1), period = 12))
fit_12

# SARIMA Model Diagnostics (Figure 5 and Figure A1)
fit <- Arima(Ice, order = c(1,1,2), seasonal = list(order = c(0,1,2), period = 12))
tsdiag(fit)

qqnorm(residuals(fit), main = "Figure A1: Normal Q-Q Plot of SARIMA Model Residuals", cex.main = 2)
qqline(residuals(fit))

auto.arima(residuals(fit), max.q = 0) # Order of Minimum AICC AR Model

# SARIMA Model Forecast (Figure 6)
ARIMAforecast <- forecast(fit, h = 24)
ARIMAforecast

plot(ARIMAforecast, main = "Figure 6: Seasonal ARIMA (1,1,2) x (0,1,2)[12] Forecast", xlab = "Year", ylab = "Average Monthly Antarctic Sea Ice (Millions of Square Kilometers)", cex.main = 2)

# Holt-Winters Forecast (Figure 7)
HWfit <- HoltWinters(Ice, seasonal = "additive")
HWforecast <- forecast(HWfit, h = 24)
HWforecast

plot(HWforecast, main = "Figure 7: Holt-Winters Forecast", xlab = "Year", ylab = "Average Monthly Antarctic Sea Ice (Millions of Square Kilometers)", cex.main = 2)

# Model Performance
train <- window(Ice, end = c(2019, 12))
test <- window(Ice, start = c(2020, 1)) # last 48 observations

# Holt-Winters Forecast
HWfit <- HoltWinters(train, seasonal = "additive")
HWforecast <- forecast(HWfit, h = 48)
HWforecast

HWerr <- test - HWforecast$mean
HWrmse <- sqrt(mean(HWerr^2))
HWmae <- mean(abs(HWerr))
HWmape <- mean(abs((HWerr*100)/test))

HWrmse # Holt-Winters RMSE
HWmae # Holt-Winters MAE
HWmape # Holt-Winters MAPE

# SARIMA(1,1,2)x(0,1,2)[12] Forecast
arimafit <- Arima(train, order = c(1,1,2), seasonal = list(order = c(0,1,2), period = 12))
arimafcast <- forecast(arimafit, h = 48)
arimafcast

arimaerr <- test - arimafcast$mean
arimarmse <- sqrt(mean(arimaerr^2))
arimamae <- mean(abs(arimaerr))
arimamape <- mean(abs((arimaerr*100)/test))

arimarmse # ARIMA RMSE
arimamae # ARIMA MAE
arimamape # ARIMA MAPE

Measure <- c("SARIMA(1,1,2)x(0,1,2)[12]", "Holt-Winters")
RMSE <- round(c(arimarmse, HWrmse), 4)
MAE <- round(c(arimamae, HWmae), 4)
MAPE <- round(c(arimamape, HWmape), 4)
rbind(Measure, RMSE, MAE, MAPE)

# Extra Material (NOT Included in Report)
# ARMA Subsets Model
fit_sub <- Arima(Ice, order = c(15,1,12), seasonal = list(order = c(0,1,0), period = 12), fixed=c(rep(0,14), NA, 0, NA, rep(0,9), NA))
fit_sub

# Check adequacy of the model
tsdiag(fit_sub)

qqnorm(residuals(fit_sub), main = "Q-Q Plot of Model Residuals")
qqline(residuals(fit_sub))

auto.arima(residuals(fit_sub), max.q = 0) # Order of Minimum AICC AR Model
# This model is NOT suitable
