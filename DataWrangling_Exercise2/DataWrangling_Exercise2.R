# load libraries
library(devtools)
library(tidyr)
library(dplyr)


#### NOTE: This file contains some trial and error code with comments for #1 and #3; however, none of these 
####       reassign values back to the titanic_original; only the final answer snippets do

  
  
# 0. Load & View Data
    # remove(titanic_original)
  titanic_original <- read.csv("~/_MyFiles/Data Science Workshop/Springboard_DataScientist/DataWrangling_Exercise2/titanic_original.csv", stringsAsFactors=FALSE)
  View(titanic_original)
  str(titanic_original)
  
  
  # copy table into final 'clean' version
    # remove(titanic_clean)
  titanic_clean <- titanic_original
  str(titanic_clean)
  
  # convert to tbl class
  titanic_clean <- tbl_df(titanic_clean)
  str(titanic_clean)
  
  titanic_clean
  
# 1: Port of embarkation: Find the missing values and replace them with S. 
   #$ embarked : chr  "S" "S" "S" "S" ...
 
  distinct(select(titanic_clean,embarked))
  
  titanic_clean %>% 
        group_by(embarked) %>% 
        summarise(cnt = n())
    #     embarked   cnt
    #      (chr) (int)
    # 1              2
    # 2        C   270
    # 3        Q   123
    # 4        S   914
  
  titanic_clean [c(169,285), ] ## found the indecies from the View (sorted by embarked), 
        ## how can I replace the c() with a list of indecies where the field is null/NA/blank? can't seem to figure this out w/ R
  # figured this out near the end of the exercise :), but how can I use this for a field update...
  titanic_clean %>% 
    filter(embarked==""|is.na(embarked)|is.null(embarked))
 
            #xx   sub("is.null","S",titanic_clean$embarked) # no effect on data
            #xx   sub("((^C|S|Q))","S",titanic_clean$embarked)  # all to 'S', trying to write does not = C|S|Q, but this was from regexp video not specific to R. Tried several different ways ([]), etc
            #xx   sub("","S",titanic_clean$embarked)  # addes S to start of all, the blanks are now just "S", but rest are bad; would be ok if isolated just the NULL records
           
            # this works...would need to apply back to tbl
            sub("^$","S",titanic_clean$embarked) 
        
               # Q: how can I choose to view only the observations that are empty? assuming this would be beneficial with larger data sets    
            
            # also works... would need to apply back to the table
            ifelse(nchar(titanic_clean$embarked)==0,"S",titanic_clean$embarked)
        
            # but same thing using pipe does not seem to work... how come?
            titanic_clean %>% 
                 ifelse(nchar(embarked)==0,"S",embarked)
        
            # this also works, but not using; found this when googling help on replacing NULLs & don't fully understand it
            titanic_clean$embarked[titanic_clean$embarked==""]<-"S" 
              #titanic_original$embarked[titanic_original$embarked==""]  # still has the two missing values
                # inside [] returns LOGICAL response to all rows in embarked (FALSE and TRUE)
                # full line returns: [1] "" "", so it's showing the actual table values where the expression is TRUE (but not the indecies/row#)
                # adding the <- "S" is assigning "S" to those two "" values... where the indecies of TRUE are kept behind the scenes..
            
            #Q: is there a better way to do this or to use is.null? 
            #Q: also, for example, in SQL, missing values may be NULL or blank (''), to capture both 
            # it's easiest just to write: select * from TableName where isnull(ColumnName, '') = ''
            # all nulls are converted to a blank '' and then you find all blanks ''
            # is there something like this that can be used in R to ensure all missing values are located?
            
      
      # final update:
      titanic_clean$embarked <-
        ifelse(nchar(titanic_clean$embarked)==0,"S",titanic_clean$embarked)
  
  
      titanic_clean [c(169,285), ]
      titanic_clean [ , "embarked"]  ## only shows top 10
      titanic_clean$embarked ## shows all, but in a vector
      print(select(titanic_clean,embarked),n=INF)  ## Q: how can you show more than the top 10 using the base R approach? (two lines up)
      
      distinct(select(titanic_clean,embarked))
      
      titanic_clean %>% 
        group_by(embarked) %>% 
        summarise(cnt = n())
      #   embarked   cnt
      #      (chr) (int)
      # 1        C   270
      # 2        Q   123
      # 3        S   916
 
      
      
# 2: Age, fill in missing values
  #A.	Calculate the mean of the Age column and use that value to populate the missing values
       select(titanic_clean,age)
       print(arrange(distinct(select(titanic_clean,age)),age),n = Inf)
       
    
      mean(titanic_clean$age,na.rm=TRUE) # 29.88113, confirmed in XLS
        # mean(titanic_clean$age,na.rm=FALSE) # NA, due to missing values
      # curious to see what mean is with trim
          # mean(titanic_clean$age, trim = .1, na.rm=TRUE) # 29.39081
          # mean(titanic_clean$age, trim = .2, na.rm=TRUE) # 28.69745
      
      
        # Q: why can't i get piping to work with mean...
            # titanic_clean %>% mean(age,na.rm=TRUE)                 ## argument is not numeric or logical: returning NA
            # titanic_clean %>% select(age) %>% mean(age,na.rm=TRUE) ## argument is not numeric or logical: returning NA
            # titanic_clean %>% select(age) %>% mean(age)            ## argument is not numeric or logical: returning NA
            # titanic_clean %>% select(age) %>% mean(na.rm=TRUE)     ## argument is not numeric or logical: returning NA
            # titanic_clean %>% filter(age,nchar(age)>0) %>% select(age) %>% mean()     ## argument is not numeric or logical: returning NA
            # titanic_clean %>% filter(age,nchar(age)>0) %>% select(age) ## this shows list though...
        ## A: got it, all 3 return the same
            titanic_clean %>% filter(age,nchar(age)>0) %>% select(age) %>% summarise(mean(age,na.rm=TRUE))
            titanic_clean %>% filter(age,nchar(age)>0) %>% summarise(mean(age,na.rm=TRUE))
            titanic_clean %>% summarise(mean(age,na.rm=TRUE))
       

       
     # now need to get this mean into the empty values; could use one of the two options that worked for embarked, but should be able to use an apply() function too...
      
        # store mean age
          meanAge <- mean(titanic_clean$age,na.rm=TRUE)
          meanAge
        # create a function to replace null ages with the meanage (suppose this could be made into a generic function with (x, newx) or something)
          nullAge <- function(age, meanAge) {
                        if (is.na(age)) {meanAge} else {age}  } # changed to is.na as is.null showed that the empty values were NA
        # run using sapply()
          titanic_clean$age <- sapply(titanic_clean$age, nullAge, meanAge)
        
          
      
        print(arrange(distinct(select(titanic_clean,age)),age),n = Inf)
        #print(arrange(distinct(select(titanic_original,age)),age),n = Inf) # Original table errors due to NAs
         
        #reivew summary
        titanic_clean %>% group_by(age) %>% summarise(cnt=n()) %>% print(n=Inf)
        
          
      #Q: does R always use NA for missing values or is there also NULL? And when are they imported differently?
          # does it depend on the import data source (i.e. csv blanks are always NA, but database imports can be either)?
      
      
  #B.	Think about other ways you could have populated the missing values in the age column. 
      # Why would you pick any of those over the mean (or not)?

      # you could use the median value, but I'd choose mean over median since I'd want an average over a middle record's value, 
      #   especially since you could have a large qty of passengers in a particular age group, but the middle rec's value may be much higher or lower than that
      # you could also use the mean, but exclude a percentage of the outliers (trim argument) to get an even more accurate picture of the average age
      # mode is another option if you want to go by frequency. This may be better suited if summarized by sex & class
      # you could also group any of the means/median/mode functions by sex and and class, 
      #   maybe even group by ranges of other stats like the # of sibsp or parch 
      # I'd most likely go with a trimmed median value and probably summarize those at least by sex, if not sex & class
      # Q: are we supposed to try these out?
      
      
      
# 3: Lifeboat, that there are a lot of missing values in the boat column. Fill these empty slots with a dummy value e.g. the string 'None' or 'NA'
       select(titanic_clean,boat)
       print(arrange(distinct(select(titanic_clean,boat)),boat),n = Inf)
     
          # got pipe op to work here :D
              titanic_clean %>% 
                select(boat) %>% 
                distinct() %>% 
                arrange(boat) %>% 
                print (n=Inf)
         
     # summarise current values
          titanic_clean %>% 
            group_by(ifelse(boat=="","none","hasCabin")) %>% 
            summarize(cnt=n()) 
       
      # update boat with "NA"
          titanic_clean <-
            titanic_clean %>% mutate(boat=ifelse(boat=="","NA",boat))
              
      # recheck summary
           titanic_clean %>% 
            group_by(ifelse(boat=="","none","hasCabin")) %>% 
            summarize(cnt=n()) 
          titanic_clean %>% 
            group_by(ifelse(boat=="NA","hasNA","hasCabin")) %>% 
            summarize(cnt=n()) 
       

          
# 4: Cabin, 
   # A•	Does it make sense to fill missing cabin numbers with a value?
          #ANS: you could populate with an NA since the values are Not Available
   # B•	What does a missing value here mean?
          #ANS: since it's not likely any records were saved during the chaos,
             # it's likely that only survivors provided their own cabin numbers, 
             # although some may have been able to provide cabin numbers of their friends/family that perished.
             # it could be too that some passengers, like stowaways, didn't have a cabin numbers, & perhaps crew shared quarters 
             # although stowaways may not have had any records unless they survived
   # C• Create a new column has_cabin_number which has 1 if there is a cabin number, and 0 otherwise.
          
        mutate(titanic_clean, has_cabin_number=ifelse(cabin=="",0,1)) %>%  # !is.na(cabin) and !is.null(cabin) as 1,0 return all as 1
            select (cabin, has_cabin_number)
            
        titanic_clean <-  
            mutate(titanic_clean, has_cabin_number=ifelse(cabin=="",0,1)) 
         
      
        titanic_clean %>% select(cabin, has_cabin_number)
      
           # Q: how come the is.na worked correctly in the age update, but down here I needed to use ==""?
           #    if I'd used an sapply() here too, would the is.na have worked? Is it a base R vs dplyr thing? (FYI - I did #4 before #3)
   
 
# 5: there is no #5
      
              
# 6: setwd (via menu) then, export titanic_clean.csv, upload all to github
      
      write.csv(titanic_clean, "titanic_clean.csv")
      

      