## Regression with binary outcomes
## ═════════════════════════════════

## Logistic regression
## ───────────────────────

##   This far we have used the `lm' function to fit our regression models.
##   `lm' is great, but limited–in particular it only fits models for
##   continuous dependent variables. For categorical dependent variables we
##   can use the `glm()' function.

##   For these models we will use a different dataset, drawn from the
##   National Health Interview Survey. From the [CDC website]:

##         The National Health Interview Survey (NHIS) has monitored
##         the health of the nation since 1957. NHIS data on a broad
##         range of health topics are collected through personal
##         household interviews. For over 50 years, the U.S. Census
##         Bureau has been the data collection agent for the National
##         Health Interview Survey. Survey results have been
##         instrumental in providing data to track health status,
##         health care access, and progress toward achieving national
##         health objectives.


##   Load the National Health Interview Survey data:

NH11 <- readRDS("dataSets/NatHealth2011.rds")
labs <- attributes(NH11)$labels

##   [CDC website] http://www.cdc.gov/nchs/nhis.htm

## Logistic regression example
## ───────────────────────────────

##   Let's predict the probability of being diagnosed with hypertension
##   based on age, sex, sleep, and bmi

str(NH11$hypev) # check stucture of hypev (Ever been told you have hypertension)
levels(NH11$hypev) # check levels of hypev
        
      summary(NH11)
        summary(NH11$hypev)
        ##    1 Yes              2 No         7 Refused 8 Not ascertained      9 Don't know 
        ##    10672             22296                20                 0                26
        # factor(NH11$hypev, levels=c("2 No", "1 Yes")) ##-- omitted 23014 entries

# collapse all missing values to NA
NH11$hypev <- factor(NH11$hypev, levels=c("2 No", "1 Yes"))

        summary(NH11$hypev)
         ## 2 No 1 Yes  NA's 
         ## 22296 10672    46 

# run our regression model
hyp.out <- glm(hypev~age_p+sex+sleep+bmi,
              data=NH11, family="binomial")
coef(summary(hyp.out))

## Logistic regression coefficients
## ────────────────────────────────────

##   Generalized linear models use link functions, so raw coefficients are
##   difficult to interpret. For example, the age coefficient of .06 in the
##   previous model tells us that for every one unit increase in age, the
##   log odds of hypertension diagnosis increases by 0.06. Since most of us
##   are not used to thinking in log odds this is not too helpful!

##   One solution is to transform the coefficients to just odds (vs log-odds) 
##   to make them easier to interpret

hyp.out.tab <- coef(summary(hyp.out))
hyp.out.tab[, "Estimate"] <- exp(coef(hyp.out))
hyp.out.tab

## Generating predicted values
## ───────────────────────────────

##   In addition to transforming the log-odds produced by `glm' to odds, we
##   can use the `predict()' function to make direct statements about the
##   predictors in our model. For example, we can ask "How much more likely
##   is a 63 year old female to have hypertension compared to a 33 year old
##   female?".

# Create a dataset with predictors set at desired levels
predDat <- with(NH11,
                expand.grid(age_p = c(33, 63),
                            sex = "2 Female",
                            bmi = mean(bmi, na.rm = TRUE),
                            sleep = mean(sleep, na.rm = TRUE)))
# predict hypertension at those levels
cbind(predDat, predict(hyp.out, type = "response",
                       se.fit = TRUE, interval="confidence",
                       newdata = predDat))

##   This tells us that a 33 year old female has a 13% probability of
##   having been diagnosed with hypertension, while and 63 year old female
##   has a 48% probability of having been diagnosed.

## Packages for  computing and graphing predicted values
## ─────────────────────────────────────────────────────────

##   Instead of doing all this ourselves, we can use the effects package to
##   compute quantities of interest for us (cf. the Zelig package).

      # install.packages("effects")

library(effects)
plot(allEffects(hyp.out))

## Exercise: logistic regression
## ───────────────────────────────────

##   Use the NH11 data set that we loaded earlier.
##   Note that the data is not perfectly clean and ready to be modeled. You
##   will need to clean up at least some of the variables before fitting
##   the model.

        # review data
        str(NH11)  
        #summary(NH11)
          str(NH11$everwrk) # Factor w/ 5 levels
            summary(NH11$everwrk) # has NA's
          str(NH11$age_p) # num  
            summary(NH11$age_p)
          str(NH11$r_maritl)  # Factor w/ 10 levels  
            summary(NH11$r_maritl) # No NA's, but 2 levels with 0's & 1 level as Unknown
            levels(NH11$r_maritl)
        
        # subset data to just fields needed
          NH11Sub <- subset(NH11, select = c("everwrk", "age_p", "r_maritl"))    
            summary(NH11Sub)  
          
        # everwrk has NA's: collapse all missing values to NA
            NH11Sub$everwrk <- factor(NH11$everwrk, levels=c("2 No", "1 Yes"))
            summary(NH11Sub$everwrk)
              str(NH11Sub$everwrk) # Factor w/ 2 levels "2 No","1 Yes"
              levels(NH11Sub$everwrk)
          
        # add new reduced factor marital status field for model testing
          #1st: levels listed with not married types first
            NH11Sub$marital1 <- factor(NH11Sub$r_maritl, levels=c( "7 Never married","6 Separated","5 Divorced","4 Widowed",
                                                                   "2 Married - spouse not in household","8 Living with partner","1 Married - spouse in household" ))
         
          #2nd: to see effect on the model with levels re-ordered with Married types first
            NH11Sub$marital2 <- factor(NH11$r_maritl, levels=c( "2 Married - spouse not in household","1 Married - spouse in household",
                                                             "7 Never married","6 Separated", "5 Divorced", "4 Widowed", "8 Living with partner" ))
           
          #3rd: with just factor or droplevels, both of these produce the same & keep the level of "9 Unknown marital status" 
            NH11Sub$marital3a <- factor(NH11$r_maritl) 
            NH11Sub$marital3b <- droplevels(NH11$r_maritl)
            
          #4th: setting factor order in reverse of default
            NH11Sub$marital4 <- factor(NH11$r_maritl, levels=c( "9 Unknown marital status", 
                                                               "8 Living with partner","7 Never married", "6 Separated", "5 Divorced", "4 Widowed",
                                                               "2 Married - spouse not in household", "1 Married - spouse in household"       ))
            
          #summary(NH11Sub) 
            str(NH11Sub$marital1) # Factor w/ 7 levels 
              summary(NH11Sub$marital1)
            str(NH11Sub$marital2) # Factor w/ 7 levels 
              summary(NH11Sub$marital2)
            str(NH11Sub$marital3a) # Factor w/ 8 levels 
              summary(NH11Sub$marital3a)
            str(NH11Sub$marital3b) # Factor w/ 8 levels 
              summary(NH11Sub$marital3b)
            str(NH11Sub$marital4) # Factor w/ 8 levels 
              summary(NH11Sub$marital4)
            

 
##   1. Use glm to conduct a logistic regression to predict ever worked
##      (everwrk) using age (age_p) and marital status (r_maritl).

        # use marital test on different factor levels
        mod_everwrk_test1 <- glm(everwrk ~ age_p + marital1, data=NH11Sub, family="binomial")
        summary(mod_everwrk_test1)
          # All but "2 Married - spouse not in household" is showing as significant;
          # however, one level is not showing: "7 Never married", which was listed 1st
          # Widowed is the only neg coefficent.
          # AIC: 10294, but there are no *'s next to the (Intercept) line
        
        mod_everwrk_test2 <- glm(everwrk ~ age_p + marital2, data=NH11Sub, family="binomial")
        summary(mod_everwrk_test2)
          # with the reordered factorlevels, I get the same AIC of 10294
          # It appears that the level I list first is the one that doesn't show up - "2 Married - spouse not in household". 
          # Also have different significance output: This time just Age, Divorced, Widowed, & Living with partner
          # show as signficant. Intuition says that Never Married should be an indicator of having ever worked...
          # Never Married and Widowed are negative this time.
          # Intercept has the Almost Significant (.) symbol
          
        mod_everwrk_test3a <- glm(everwrk ~ age_p + marital3a, data=NH11Sub, family="binomial")
        mod_everwrk_test3b <- glm(everwrk ~ age_p + marital3b, data=NH11Sub, family="binomial")
        summary(mod_everwrk_test3a)
        summary(mod_everwrk_test3b)
          # these two are the same here: using the data where it's just factored or levels dropped & Unknown status is retained, 
          # AIC goes up to 10327, which isn't much higher.
          # In this case, Age, Widowed, Divorced, Never Married, and Living with Partner are all significant
          # in if a person has ever worked. This seems right, but Widowed and Divorced have different
          # coefficent signs... intuition would seem like these should be the same sign & opposite of Married
          # however Married is not showing up. Going to set the factors in reverse order...
        
        mod_everwrk_test4 <- glm(everwrk ~ age_p + marital4, data=NH11Sub, family="binomial")
        summary(mod_everwrk_test4)
          # Reversing the factor order with the 8 levels as defaulted, the AIC is still 10327
          # However, this time "9 Unknown marital status" does not show (pattern seems that first in factor list is excluded...)
          # And that Age is still highly significant with Divorce as * significant & Living with partner as almost signficant (.)
          # Coefficent signs doen't coorespond well with each other: Widowed & Never Married are negative, but Divorced is positive...
          # Intercept has no signficance
        
          # I will be using the 3a option of factor(NH11$r_maritl) since it seems to make the most sense.
          # It also has *** by the Intercept (the rest do not) and perhaps this means that the model itself is significant
        
        contrasts(NH11Sub$everwrk)
        contrasts(NH11Sub$r_maritl)
        contrasts(NH11Sub$marital1)
        contrasts(NH11Sub$marital2)
        contrasts(NH11Sub$marital3a) # would be same for contrasts(NH11Sub$marital3b)
        contrasts(NH11Sub$marital4)
        # Ok so looking at this, my interpretation would be that the first level is always 0 and therefore never appears in the 
          # coefficient output. All other levels are then analyzed in contrast to this level...
          # And changing the factor orders above would be like changing the reference group...
        

        # remove test marital fields from Sub table and factor r_maritl (3a)
        NH11Sub <- subset(NH11Sub, select = c("everwrk", "age_p", "r_maritl"))
        NH11Sub$r_maritl <- factor(NH11Sub$r_maritl) 
          str(NH11Sub) 
            summary(NH11Sub)  
          str(NH11Sub$r_maritl)
            summary(NH11Sub$r_maritl)
          
        # create preferred glm model on r_maritl
        mod_everwrk <- glm(everwrk ~ age_p + r_maritl, data=NH11Sub, family="binomial")
        summary(mod_everwrk)
          
        # Check out the Odds (vs log odds)
        coefodds <- coef(summary(mod_everwrk))
        coefodds[, "Estimate"] <- exp(coef(mod_everwrk))
        coefodds
        
        
##   2. Predict the probability of working for each level of marital
##      status.
         
        # predictions on all/original data set
        PredEverWrk <- predict(mod_everwrk, type="response", newdata=NH11Sub) # se.fit = TRUE, interval="confidence" are defaults and not required
          head(PredEverWrk)
          summary(PredEverWrk)
          str(PredEverWrk)
          
        # convert to data.frame and cbind with NH11Sub data
        PredEverWrkDF <- as.data.frame(PredEverWrk, colname = 'PredEverWrk')
          str(PredEverWrkDF)
          head(PredEverWrkDF)
          summary(PredEverWrkDF)
          
        NH11Sub <- cbind(NH11Sub,PredEverWrkDF)
          head(NH11Sub)
          summary(NH11Sub)
     
        # get prob of everwrk by r_maritl levels & plot
        library(effects)
        # plot(allEffects(mod_everwrk)) ## gives error due to r_maritl being categorical
        data.frame(effect("r_maritl",mod_everwrk)) # prob of everwrk for each r_maritl level
        plot(data.frame(effect("r_maritl",mod_everwrk))) # plot of above
        
        # for fun... get prob of everwrk by by age& plot
        data.frame(effect("age_p",mod_everwrk)) # prob of everwrk for each r_maritl level
        plot(data.frame(effect("age_p",mod_everwrk))) # plot of above
        
        
