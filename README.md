# GARCH-models-in-R

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

### improvements_normal_garch_model.R ###
GARCH models with a leverage effect and skewed student t innovations. 
Use GARCH models for estimating over ten thousand different GARCH model specifications.

### performance_evaluation.R ###
Analysis of statistical significance of the estimated GARCH parameters, the properties of standardized returns, the interpretation of information criteria and the use of rolling GARCH estimation and mean squared prediction errors to analyze the accuracy of the volatility forecast.

### applications.R ###
Specific rugarch functionality for making VaR estimates, for using the GARCH model in production and for simulating GARCH returns. 
The estimation of the beta of a stock and finding the minimum variance portfolio.
