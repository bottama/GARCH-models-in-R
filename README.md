# GARCH models in R

#### February 17, 2021 ####
#### Matteo Bottacini, [matteo.bottacini@usi.ch](mailto:matteo.bottacini@usi.ch) ####

## Description ##
These scripts on GARCH models are about forward looking approach to balance risk and reward in financial decision making.
The models gradually moves from the standard normal GARCH(1,1) model to more advanced volatility models with a leverage effect, GARCH-in-mean specification and the use of the skewed student t distribution for modelling asset returns.

Application on stock and exchange rate returns include portfolio optimization, rolling sample forecast evaluation, value-at-risk (VaR) forecasting and studying dynamic covariances.

Folder structure:
~~~~
GARCH-models-in-R/
    deliverable/
        normal_garch_model.R
        improvements_normal_garch_model.R
        performance_evaluation.R
        applications.R
    README.md
~~~~

## Script description ##

### normal_garch_model.R ###
The standard GARCH model as the workhorse model.
The basics of using the `rugarch` package for specifying and estimating the workhorse GARCH(1,1) model in R. 
In this scrpit are also shown its usefulness in tactical asset allocation.

#### Computing returns ####
For managing financial risk, we need to first measure the risk by analyzing the return series. Here, you are given the S&P 500 price series and you need to plot the daily returns. You will see that large (positive or negative) returns tend to be followed by large returns of either sign, and small returns tend to be followed by small returns. The periods of sustained low volatility and high volatility are called volatility clusters.

#### Rolling approach ####
You can visualize the time-variation in volatility by using the function `chart.RollingPerformance()`in the package `PerformanceAnalytics`. An important tuning parameter is the choice of the window length. The shorter the window, the more responsive the rolling volatility estimate is to recent returns. The longer the window, the smoother it will be. The function `sd.annualized` lets you compute annualized volatility under the assumption that the number of trading days in a year equals the number specified in the scale argument.

#### Prediction errors ####
Under the GARCH model, the variance is driven by the square of the prediction errors 
`e = R − μ`. In order to calculate a GARCH variance, you thus need to first compute the prediction errors. For daily returns, it is common practice to set `μ` equal to the sample average. 
There is a large positive autocorrelation in the absolute value of the prediction errors. Positive autocorrelation reflects the presence of volatility clusters. When volatility is above average, it stays above average for some time. When volatility is low, it stays low for some time.

#### The GARCH model ####
GARCH models come in many flavors. You thus need to start off by specifying the mean model, the variance model and the error distribution that you want to use. The best model to use is application-specific. A realistic GARCH analysis thus involves specifying, estimating and testing various GARCH models.

#### Out-of-sample forecasting ####
The `garchvol` series is the series of predicted volatilities for each of the returns in the observed time series `sp500ret`. For decision making, it is the volatility of the future (not yet observed) return that matters. 
You get it by applying the `ugarchforecast()` function to the output from `ugarchfit()` In forecasting, we call this the out-of-sample volatility forecasts, as they involve predictions of returns that have not been used when estimating the GARCH model.

#### Volatility targeting in tactical asset allocation ####
GARCH volatility predictions are of direct practical use in portfolio allocation. According to the two-fund separation theorem of James Tobin, you should invest a proportion of your wealth in a risky portfolio and the remainder in a risk free asset, like a US Treasury bill.

When you target a portfolio with 5% annualized volatility, and the annualized volatility of the risky asset is σ, then you should invest  0.05/σ in the risky asset.

### improvements_normal_garch_model.R ###
GARCH models with a leverage effect and skewed student t innovations. 
Use GARCH models for estimating over ten thousand different GARCH model specifications.

#### Estimation of non-normal GARCH model ####
The function `ugarchfit()` does a joint estimation of all the mean, variance and distribution parameters. 
A general approach is to use a skewed student t distribution. 
You then need to estimate also the skew and shape parameters.
You will see that you obtain parameter estimates are close to the true parameters. 
The difference between the estimated and true parameter is called the estimation error. 
On long time series, the error is typically small.

#### Standardized returns ####

A complete GARCH model requires to make an assumption about the distribution of the standardized returns. 
Once the model has been estimated you can verify the assumption by analyzing the standardized returns.


### performance_evaluation.R ###
Analysis of statistical significance of the estimated GARCH parameters, the properties of standardized returns, the interpretation of information criteria and the use of rolling GARCH estimation and mean squared prediction errors to analyze the accuracy of the volatility forecast.

### applications.R ###
Specific rugarch functionality for making VaR estimates, for using the GARCH model in production and for simulating GARCH returns. 
The estimation of the beta of a stock and finding the minimum variance portfolio.
