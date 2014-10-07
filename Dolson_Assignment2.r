#Emily Dolson - Code for assignment 2

#Import libraries
library(arm)
library(car)

#Make histograms of EQU
hist(data$EQU, nclass = 80)
hist(data$EQU, ylim = c(0,600), nclass = 100)

#Ian's ConditionNumber function
ConditionNumber <-function(mod){
     mod.X <- model.matrix(mod)
     eigen.x <- eigen(t(mod.X) %*%mod.X)
     eigen.x$val # eigenvalues from the design matrix
     sqrt(eigen.x$val[1]/eigen.x$val) # condition numbers
}

#Scale data
EQU_scaled <- scale(data$EQU)
diversity <- scale(data$ShannonDiversityPhenotype)

#rename condition so plots are prettier
con <- data$condition

#Make the lms
null_lm <- lm(EQU_scaled ~ 1)
shannon_lm <- lm(EQU_scaled ~ diversity)
condition_lm <- lm(EQU_scaled ~ con)
shannon_condition_lm <- lm(EQU_scaled ~ con + diversity)
interaction_lm <- lm(EQU_scaled ~ con*diversity)

#Make coefficient plots
coefplot(interaction_lm,  xlab="Standard Deviations of # of Organisms Performing EQU", mar=c(1,12,5,6), intercept=TRUE, main="Coefficient estimates for diversity*condition")
coefplot(shannon_condition_lm,  xlab="Standard Deviations of # of Organisms Performing EQU", mar=c(1,12,5,6), intercept=TRUE, main="Coefficient estimates for diversity + condition")
coefplot(condition_lm,  xlab="Standard Deviations of # of Organisms Performing EQU", mar=c(1,12,5,6), intercept=TRUE, main="Coefficient estimates for condition")
coefplot(shannon_lm,  xlab="Standard Deviations of # of Organisms Performing EQU", mar=c(1,12,5,6), intercept=TRUE, main="Coefficient estimates for diversity")

#Can't make a coefficient plot for the null model, so print out confidence interval:
confint(null_lm)

#For question 2c
plot(c(2, 12, 21), c(4.583e-03, 0.004214, 0.01327), xlab="Number of parameters", ylab="Std. err. of diversity coefficient")

#Calculate condition numbers
ConditionNumber(shannon_condition_lm)
ConditionNumber(interaction_lm)

#Calculate variance-covariance matrices
vcov(shannon_condition_lm)
vcov(interaction_lm)

#Calculate VIF
vif(shannon_condition_lm)
vif(interaction_lm)

#Calculate partial R2
Rsq <- function( model ){
  fitted.variance <- var(model$fitted)
  total.variance	<- var(model$fitted) + var(model$resid)
  fitted.variance / total.variance
}

PRsq <- function( model ){
  residual.variance <- var(model$resid)
  variables <- attr(terms(model), "term.labels")
  model.length <- length(variables)
  variable.name <- rep(NA, model.length )
  partial.Rsq <- rep(NA, model.length )
  univariate.Model.Rsq <- rep(NA, model.length )
  
  for (i in 1:model.length){
    variable.name[i] <- variables[i]
    drop <- parse( text=variables[i] )
    new.formula <- as.formula( paste( ".~.-", variables[i], sep=""))
    new.model <- update(model, new.formula )
    partial.Rsq[i] <- (var(new.model$resid) - residual.variance)/ var(new.model$resid)
    
    new.formula.univariate <- as.formula( paste( ".~", variables[i], sep=""))
    univariate.model <- update(model, new.formula.univariate)
    univariate.Model.Rsq[i] <- summary(univariate.model)$r.sq
  }
  
  R2 <- Rsq( model )
  adj.R2 <- summary(model)$adj.r
  
  partials <- data.frame(partial.Rsq, univariate.Model.Rsq )
  row.names(partials) <- variable.name
  
  list(FullModelRsquared=R2, FullModelAdjustedR2 = adj.R2, partials=partials	)
}

summary(null_lm) #you can't have partial r2 for the nulll lm
PRsq(condition_lm)
summary(condition_lm)
PRsq(shannon_lm)
summary(shannon_lm)
PRsq(shannon_condition_lm)
summary(shannon_condition_lm)
PRsq(interaction_lm)
summary(interaction_lm)

#Get RSS for each model
sum(residuals(null_lm)^2)
sum(residuals(condition_lm)^2)
sum(residuals(shannon_lm)^2)
sum(residuals(shannon_condition_lm)^2)
sum(residuals(interaction_lm)^2)

#Expected vs. observed plots
plot(fitted(shannon_condition_lm), EQU_scaled, xlab="Expected", ylab="Observed")
abline(0,1)
plot(fitted(interaction_lm), EQU_scaled, xlab="Expected", ylab="Observed")
abline(0,1)

#Diagnostic plots
plot(null_lm)
plot(shannon_lm)
plot(condition_lm)
plot(shannon_condition_lm)
plot(interaction_lm)
durbinWatsonTest(interaction_lm)
acf(residuals(interaction_lm))
