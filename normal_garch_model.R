#### ---- install/load packages ---- ####
packages = c("quantmod", "PerformanceAnalytics", "rugarch")

install_load = function(packages){   
  for(package in packages){
    if(package %in% rownames(installed.packages()))
      do.call('library', list(package))
    else {
      install.packages(package)
      do.call("library", list(package))
    }
  } 
}
install_load(packages)



#### ---- Data cleaning ---- ####

# download S&P500 close prices from yahoo finance
getSymbols('^GSPC')
sp500prices = GSPC[,6]
sp500prices = na.omit(sp500prices)

# Compute daily returns
sp500ret = CalculateReturns(sp500prices)
sp500ret = na.omit(sp500ret)


#### ---- Data visualization ---- ####

# Plot daily returns
plot(sp500ret, main = 'S&P500 daily returns')

# Showing two plots on the same figure
par(mfrow=c(2,1)) 

# Compute the rolling 1 month estimate of annualized volatility
chart.RollingPerformance(R = sp500ret["2000::2020"], width = 22,
                         FUN = "sd.annualized", scale = 252, main = "One month rolling volatility")

# Compute the rolling 3 months estimate of annualized volatility
chart.RollingPerformance(R = sp500ret["2000::2020"], width = 66,
                         FUN = "sd.annualized", scale = 252, main = "Three months rolling volatility")


#### ---- Set up GARCH ---- ####

# Compute the mean daily return
m = mean(sp500ret)

# Define the series of prediction errors
e = sp500ret - m

# Plot the absolute value of the prediction errors
par(mfrow = c(2,1))
plot(abs(e), main = "Absolute value of the prediction error")

# Plot the acf of the absolute prediction errors
acf(abs(e), main = "Autocorrelation of the absolute prediction errors")

# Compute the predicted variances
predvar    = vector(length = length(sp500ret))
predvar[1] = var(sp500ret) 
e2         = e^2
alpha      = .1
beta       = .8
omega      = predvar[1] * (1 - alpha - beta)

for(t in 2:length(predvar)){
  predvar[t] = omega + alpha * e2[t-1] + beta * predvar[t-1]
}

# Create annualized predicted volatility
ann_predvol = xts(sqrt(252) * sqrt(predvar), order.by = time(sp500ret))

# Plot the annual predicted volatility in 2008 and 2009
par(mfrow = c(1, 1))
plot(ann_predvol["2008::2009"], main = "Ann. S&P 500 vol in 2008-2009")


#### ---- RUGARCH package ---- ####
# Specify a standard GARCH model with constant mean
garchspec = ugarchspec(mean.model         = list(armaOrder = c(0,0)),
                       variance.model     = list(model = "sGARCH"), 
                       distribution.model = "norm")

# Estimate the model
garchfit = ugarchfit(data = sp500ret, 
                     spec = garchspec)

# Use the method sigma to retrieve the estimated volatilities 
garchvol = sigma(garchfit)

# Plot the volatility for 2008 to 2020
plot(garchvol["2008::2020"], main = "Garch(1,1), alpha = 0.1, beta = 0.8")


#### ---- Out of Sample forecasting ---- ####

# Compute unconditional volatility
sqrt(uncvariance(garchfit))

# Print last 10 ones in garchvol
tail(garchvol, 10)

# Forecast volatility 5 days ahead and add 
garchforecast = ugarchforecast(fitORspec = garchfit, 
                               n.ahead = 5)

# Extract the predicted volatilities and print them
print(sigma(garchforecast))


#### ---- Volaitlity targeting in tactical asset allocation ---- ####

# Compute the annualized volatility
annualvol = sqrt(252) * sigma(garchfit)

# Compute the 5% vol target weights  
vt_weights = 0.05 / annualvol

# Compare the annualized volatility to the portfolio weights in a plot
plot(merge(annualvol, vt_weights), multi.panel = TRUE, main ='Annualized Portfolio Volatility vs Target Portfolio Weights with 5% annualized volatility')







