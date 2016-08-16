#  Introduction
## ══════════════

#   • Learning objectives:
##     • Learn the R formula interface
##     • Specify factor contrasts to test specific hypotheses
##     • Perform model comparisons
##     • Run and interpret variety of regression models in R

## Set working directory
## ─────────────────────────

##   It is often helpful to start your R session by setting your working
##   directory so you don't have to type the full path names to your data
##   and other files

# set the working directory
# setwd("~/Desktop/Rstatistics")
# setwd("C:/Users/dataclass/Desktop/Rstatistics")

      setwd("C:/Users/Stephaniev/Documents/_MyFiles/Data Science Workshop/Springboard_DataScientist/linear_regression")

##   You might also start by listing the files in your working directory

getwd() # where am I?
list.files("dataSets") # files in the dataSets folder

## Load the states data
## ────────────────────────

# read the states data
states.data <- readRDS("dataSets/states.rds") 
#get labels
states.info <- data.frame(attributes(states.data)[c("names", "var.labels")])
#look at last few labels
tail(states.info, 8)

## Linear regression
## ═══════════════════

## Examine the data before fitting models
## ──────────────────────────────────────────

##   Start by examining the data to check for problems.

# summary of expense and csat columns, all rows
sts.ex.sat <- subset(states.data, select = c("expense", "csat"))
summary(sts.ex.sat)
# correlation between expense and csat
cor(sts.ex.sat)

## Plot the data before fitting models
## ───────────────────────────────────────

##   Plot the data to look for multivariate outliers, non-linear
##   relationships etc.

# scatter plot of expense vs csat
plot(sts.ex.sat)

## Linear regression example
## ─────────────────────────────

##   • Linear regression models can be fit with the `lm()' function
##   • For example, we can use `lm' to predict SAT scores based on
##     per-pupal expenditures:

# Fit our regression model
sat.mod <- lm(csat ~ expense, # regression formula
              data=states.data) # data set
# Summarize and print the results
summary(sat.mod) # show regression coefficients table

## Why is the association between expense and SAT scores /negative/?
## ─────────────────────────────────────────────────────────────────────

##   Many people find it surprising that the per-capita expenditure on
##   students is negatively related to SAT scores. The beauty of multiple
##   regression is that we can try to pull these apart. What would the
##   association between expense and SAT scores be if there were no
##   difference among the states in the percentage of students taking the
##   SAT?

summary(lm(csat ~ expense + percent, data = states.data))

## The lm class and methods
## ────────────────────────────

##   OK, we fit our model. Now what?
##   • Examine the model object:

class(sat.mod)
names(sat.mod)
methods(class = class(sat.mod))[1:9]

##   • Use function methods to get more information about the fit

confint(sat.mod)
# hist(residuals(sat.mod))

## Linear Regression Assumptions
## ─────────────────────────────────

##   • Ordinary least squares regression relies on several assumptions,
##     including that the residuals are normally distributed and
##     homoscedastic, the errors are independent and the relationships are
##     linear.

##   • Investigate these assumptions visually by plotting your model:

par(mar = c(4, 4, 2, 2), mfrow = c(1, 2)) #optional
plot(sat.mod, which = c(1, 2)) # "which" argument optional

## Comparing models
## ────────────────────

##   Do congressional voting patterns predict SAT scores over and above
##   expense? Fit two models and compare them:

# fit another model, adding house and senate as predictors
sat.voting.mod <-  lm(csat ~ expense + house + senate,
                      data = na.omit(states.data))
sat.mod <- update(sat.mod, data=na.omit(states.data))
# compare using the anova() function
anova(sat.mod, sat.voting.mod)
coef(summary(sat.mod))
coef(summary(sat.voting.mod))

## Exercise: least squares regression
## ────────────────────────────────────────

##   Use the /states.rds/ data set. Fit a model predicting energy consumed
##   per capita (energy) from the percentage of residents living in
##   metropolitan areas (metro). Be sure to
##   1. Examine/plot the data before fitting the model

        str(states.data)
        states.info
        sts.energy.metro <- subset(states.data, select = c("energy","metro"))
        sts.energy.metro
        summary(sts.energy.metro)
        cor(sts.energy.metro)
        cor(subset(na.omit(states.data), select = c("energy","metro"))) # AK and DC are removed for NAs
        plot(sts.energy.metro)

##   2. Print and interpret the model `summary'

        energy.metro.mod <- lm(energy ~ metro, data = na.omit(states.data))
        summary(energy.metro.mod)
        confint(energy.metro.mod)
        
          # not sure if these are being requested or not...but here they are
            class(energy.metro.mod)
            names(energy.metro.mod)
            methods(class = class(energy.metro.mod))[1:9]

##   3. `plot' the model to look for deviations from modeling assumptions

        par(mar = c(4, 4, 2, 2), mfrow = c(1, 2)) 
        plot(energy.metro.mod, which = c(1, 2)) 


##   Select one or more additional predictors to add to your model and
##   repeat steps 1-3. Is this model significantly better than the model
##   with /metro/ as the only predictor?

        sts.energy.metroPlus <- subset(states.data, select = c("energy","metro","green","toxic","miles"))
        sts.energy.metroPlus
        summary(sts.energy.metroPlus)
        cor(sts.energy.metroPlus)
        plot(sts.energy.metroPlus)
        
        energy.metroPlus.mod <- lm(energy ~ metro + green + toxic + miles, data = na.omit(states.data))
        summary(energy.metroPlus.mod)
        confint(energy.metroPlus.mod)
        
            class(energy.metroPlus.mod)
            names(energy.metroPlus.mod)
            methods(class = class(energy.metroPlus.mod))[1:9]
      
        par(mar = c(4, 4, 2, 2), mfrow = c(1, 2)) 
        plot(energy.metroPlus.mod, which = c(1, 2)) 
        
        anova(energy.metro.mod,energy.metroPlus.mod)
        
            # Answer: Yes, this model is better in that the r-sq value is now 0.7751 with adj rsq as 0.7542 
            # vs the original metro-only values of 0.09714 & 0.07751. 
            # This model also has two significant independent variables: green and toxic.  
            # The anova also shows us that model2 is highly significant & model1 is not significant
            # Mmodel2 would most likely be improved upon by removing miles and metro...

          # Removing miles...
            energy.metroPlus2.mod <- lm(energy ~ metro + green + toxic, data = na.omit(states.data))
            summary(energy.metroPlus2.mod)
            # R-sq 0.7644 & 0.7483; has gone down with removal of miles; metro still insignifcant (high p-value)
          
          # Adding back miles and remove metro instead...
            energy.Plus3.mod <- lm(energy ~ green + toxic + miles, data = na.omit(states.data))
            summary(energy.Plus3.mod)
            # R-sq 0.7675 / 0.7516... still only green and toxic are significant. miles is still insignificant (high p-value) 
          
          # Remove miles again & keep metro off (GREEN & TOXIC)
            energy.Plus4.mod <- lm(energy ~ green + toxic, data = na.omit(states.data))
            summary(energy.Plus4.mod)
            # R-sq 0.7627 / 0.7521... about the same as with miles, but Adj is still slightly higher &
            # we're left with only signif varibles and a simpler model
            # the R-sq value is a bit smaller than the model with 5 variables, but the adj r-sq is quite close
            # and we've removed two insigificant variables so this would still be my choice of models for predicting energy.

        # Compare the two best models
            summary(energy.metroPlus.mod)
            summary(energy.Plus4.mod)
            anova(energy.metroPlus.mod,energy.Plus4.mod) # or anova(energy.Plus4.mod,energy.metroPlus.mod)
            ## Results: these two models are not significantly different
            
            ##Definitions:
              #Res.Df = Degrees of Freedom of residuals of the model
              #RSS = Residual Sum of Squares of the model
              #Df = difference of Res.DF between the two models
              #Sum of Sq = difference of RSS between the two models
              #F = ?something to do with the F-statistic (Ratio of the mean squared errors)?
              #Pr(>F) = probability that the test statistic can take a value >= the value of the test statistic
              #         low Pr (esp with *'s) means they are significantly DIFFERENT from each other; high means they're not significantly DIFFERENT models
       
            
## Interactions and factors
## ══════════════════════════

## Modeling interactions
## ─────────────────────────

##   Interactions allow us assess the extent to which the association
##   between one predictor and the outcome depends on a second predictor.
##   For example: Does the association between expense and SAT scores
##   depend on the median income in the state?

  #Add the interaction to the model
sat.expense.by.percent <- lm(csat ~ expense*income,
                             data=states.data) 
#Show the results
coef(summary(sat.expense.by.percent)) # show regression coefficients table

## Regression with categorical predictors
## ──────────────────────────────────────────

##   Let's try to predict SAT scores from region, a categorical variable.
##   Note that you must make sure R does not think your categorical
##   variable is numeric.

# make sure R knows region is categorical
str(states.data$region)
states.data$region <- factor(states.data$region)
#Add region to the model
sat.region <- lm(csat ~ region,
                 data=states.data) 
#Show the results
coef(summary(sat.region)) # show regression coefficients table
anova(sat.region) # show ANOVA table

##   Again, *make sure to tell R which variables are categorical by
##   converting them to factors!*

## Setting factor reference groups and contrasts
## ─────────────────────────────────────────────────

##   In the previous example we use the default contrasts for region. The
##   default in R is treatment contrasts, with the first level as the
##   reference. We can change the reference group or use another coding
##   scheme using the `C' function.

# print default contrasts
contrasts(states.data$region)
# change the reference group
coef(summary(lm(csat ~ C(region, base=4),
                data=states.data)))
# change the coding scheme
coef(summary(lm(csat ~ C(region, contr.helmert),
                data=states.data)))

##   See also `?contrasts', `?contr.treatment', and `?relevel'.

## Exercise: interactions and factors
## ────────────────────────────────────────

##   Use the states data set.

##   1. Add on to the regression equation that you created in exercise 1 by
##      generating an interaction term and testing the interaction.

        ## from Orig model: energy.metro.mod <- lm(energy ~ metro, data = na.omit(states.data))
          ## green had the lowest p-value so will use that
          energy.metro.by.green <- lm(energy ~ metro*green, data = na.omit(states.data))
          summary(energy.metro.by.green)
            #Adjusted R-squared:  0.6762; intercept, metro:green are very significant & metro is quite signficant
          # vs orig
          summary(energy.metro.mod)
            #Adjusted R-squared:  0.07751; intercept, very signif. & metro signif.
        
        
        ## from my best fit model: energy.Plus4.mod <- lm(energy ~ green + toxic, data = na.omit(states.data))
          ## adding on metro
          energy.greentoxic.by.metro <- lm(energy ~ (green*metro) + (toxic*metro), data = na.omit(states.data))
          summary(energy.greentoxic.by.metro)
            #Adjusted R-squared:  0.7597; intercept is marked as very significant and green:metro is marked as almost signficant
          # vs best fit
          summary(energy.Plus4.mod)
            #Adjusted R-squared:  0.7521; all (intercept, green, toxic) are very significant.
        
        ## based on significance and p-values, the best fit model is still lm(energy ~ green + toxic, data = na.omit(states.data))
          
          
        
##   2. Try adding region to the model. Are there significant differences
##      across the four regions?

        str(states.data$region) # already factored, if not: states.data$region <- factor(states.data$region)
        
        # Again, adding Region to the original energy ~ metro model
        # and to the energy ~ metro*green model we just created above

          energy.metro.region <- lm(energy ~ metro + region, data = na.omit(states.data)) 
          summary(energy.metro.region)
            # Adjusted R-squared:  0.152; intercept ***, regionSouth *, regionN. East .
          

          energy.metro.by.green.region <- lm(energy ~ metro*green + region, data = na.omit(states.data)) 
          summary(energy.metro.by.green.region)
            # Adjusted R-squared:  0.6983; intercept ***, metro:green ***, metro **; no regions are sign.
         
          anova(energy.metro.region,energy.metro.by.green.region)   
          # the models are significantly different (low Pr(>F))
          # this second model is better than the first, but it's Adj R-sq value is still lower than
          # "best fit" energy.Plus4.mod <- lm(energy ~ green + toxic, data = na.omit(states.data))
          # with an Adjusted R-squared:  0.7521 
          
          # adding Region to the two "best fit" models - "best fit" and "best fit by metro" from above
          energy.Plus4.region <- lm(energy ~ green + toxic + region, data = na.omit(states.data))
          summary (energy.Plus4.region)
            # Adjusted R-squared:  0.7513; intercept ***, green ***, toxic ***; no sign. to regions
          energy.greentoxic.by.metro.region <- lm(energy ~ (green*metro) + (toxic*metro) + region, data = na.omit(states.data))
          summary (energy.greentoxic.by.metro.region)
            # Adjusted R-squared:  0.7561; intercept ***; green:metro . (almost sign.); no sign. to regions
          
          anova(energy.Plus4.region,energy.greentoxic.by.metro.region)
          # no significant difference between these two models, original best fit still seems to be the best model
          
          # While there are some differences between Regions, it is not singificant enough to keep them in the model
           
          




