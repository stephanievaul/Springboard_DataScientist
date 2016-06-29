library(devtools)
library(stringr)
library(tidyr)
library(dplyr)


#### NOTE: This file contains some trial and error code with comments for #1 and #3; however, none of these 
####       reassign values back to the refine_original; only the final answer snippets do



# 0. Load & View Data
  refine_original <- read.csv("~/_MyFiles/Data Science Workshop/Springboard_DataScientist/DataWrangling_Exercise1/refine_original.csv", stringsAsFactors=FALSE)
  View(refine_original)
  str(refine_original)



# 1. Clean up brand names (company)

  # view column data
      distinct(select(refine_original,company))  

  # find instances of the %philips% company      
       grep("^[pP]|f", refine_original$company, value=TRUE)  # returns all the spellings
       grep("^[pP]|f", refine_original$company, value=FALSE) # returns the row/observation#
       grepl("^[pP]|f", refine_original$company)             # returns TRUE/FALSe for each row

         
  #xx try to filter/select ones to be replaced...
     # refine_original %>% 
     #   #  filter(company == "philips") %>%  ## "^[pP]|f") %>%  ### says company not found or incompatible expression
     #   select(company) 


  # check out gsub option - each works, but would need to apply this permanently to the table.
        gsub("^([pP]|f).*","philips",refine_original$company)
        gsub("^[aA].*","akzo",refine_original$company)
        gsub("^[vV].*","van houten",refine_original$company)
        gsub("^[uU].*","unilever",refine_original$company)
      
      # this does not work... says "if (grepl)" condition has length > 1 and only the first element will be used... would need loop or apply?
      if( grepl("^[pP]|f", refine_original$company)) {
           gsub("^([pP]|f).*","philips",refine_original$company) }
        

  # try create if/else function to swap names and use lapply to run over the table  
      #rm(fun_coname)
        fun_coname <- function(x){ 
          if ( grepl("^[pP]|f", x) ) {"philips"
          } else if ( grepl("^[aA]", x) ) { "akzo" 
          } else if ( grepl("^[vV]", x) ) {"van houten"
          } else if ( grepl("^[uU]", x) ) {"unilever"
          } else {x}
        }
        
        lapply(refine_original$company, fun_coname) #--< seems to work, but gives back as list. sapply not working right
      # not sure how to put this back to the data frame
      
        
    # each of these also works (returning same as gsub), but would need to permanetly apply to the df before running the next one...    
        ifelse ( grepl("^[pP]|f", refine_original$company), "philips", refine_original$company )
        ifelse ( grepl("^[aA]" ,  refine_original$company), "akzo", refine_original$company )
        ifelse ( grepl("^[vV]" ,  refine_original$company), "van houten", refine_original$company )
        ifelse ( grepl("^[uU]" ,  refine_original$company), "unilever", refine_original$company )
       
       # piping doesn't seem to work here no matter how i arrange or disect the ifelse/grepl functions, either "unused argument (company)" or "("object 'company' not found"
        # so will not try to expand this
        refine_original %>% 
          ifelse ( grepl("^[pP]|f", company), "philips" , company)
    
        
    # try mutate with ifelse/grepl in pipe format -->> this works; would need to reassign to same table to update column values
        refine_original %>% 
            mutate(company=ifelse(grepl("^[pP]|f", company), "philips", company))  %>% 
            mutate(company=ifelse(grepl("^[aA]", company), "akzo", company))  %>% 
            mutate(company=ifelse(grepl("^[vV]", company), "van houten", company))  %>% 
            mutate(company=ifelse(grepl("^[uU]", company), "unilever", company))
            
         
    # also try mutate with sub in pipe format  -->> this works too :) reassign to table
    refine_original <-  refine_original %>% 
                           mutate(company=gsub("^([pP]|f).*", "philips", company)) %>% 
                           mutate(company=gsub("^[aA].*", "akzo", company)) %>% 
                           mutate(company=gsub("^[vV].*", "van houten", company)) %>% 
                           mutate(company=gsub("^[uU].*", "unilever", company))
    refine_original    
        
        

# 2. Separate product code and number
    
    refine_original <-  separate(refine_original, Product.code...number, c("product_code", "product_number"), sep = "-")
    refine_original
    
    

# 3. Add product categories

    # try assigning new column using if/else if (may just be for vectors...)
    ## ERRORS: In if (c("p", "p", "x", "x", "x", "p", "v", "v", "x", "p", "q",  :
    ##         the condition has length > 1 and only the first element will be used
    refine_original %>% 
        mutate(product_category =        if (product_code == "p") {"Smartphone"
                                  } else if (product_code == "v") {"TV"
                                  } else if (product_code == "x") {"Laptop"
                                  } else if (product_code == "q") {"Tablet"} )
   

    # try mutate with ifelse  -->> this works, but only retains the last mutate in the new column 
    # could either save each line separately or else save a new cat field = code and then mutate the cat field
        refine_original %>% 
          mutate(product_category=ifelse(grepl("p", product_code), "Smartphone", product_code))  %>% 
          mutate(product_category=ifelse(grepl("v", product_code), "TV", product_code))  %>% 
          mutate(product_category=ifelse(grepl("x", product_code), "Laptop", product_code))  %>% 
          mutate(product_category=ifelse(grepl("q", product_code), "Tablet", product_code))
   
    
    # let's try the later option 
    refine_original <- refine_original %>% 
          mutate(product_category=product_code)
    refine_original
      
    refine_original <- refine_original %>% 
                        mutate(product_category=ifelse(grepl("p", product_category), "Smartphone", product_category))  %>% 
                        mutate(product_category=ifelse(grepl("v", product_category), "TV", product_category))  %>% 
                        mutate(product_category=ifelse(grepl("x", product_category), "Laptop", product_category))  %>% 
                        mutate(product_category=ifelse(grepl("q", product_category), "Tablet", product_category))
    refine_original
    
    
    
    
# 4. Add full address for geocoding
    
    # just using unite replaces the original columns, this asks for a new column to be added...need to set remove = FALSE
    refine_original <- 
        unite(refine_original, "full_address", address, city, country, sep = ',', remove = FALSE)
    refine_original

    # assignment just says to separate by commas, but could the sep = ', ' with a space in there too, depending on which is correct for geocoding
        # unite(refine_original, "full_address", address, city, country, sep = ', ', remove = FALSE)
    
   

# 5. Create dummy variables for company and product category
      # these are categorical values, could have been set to factors vs characters

  # A.	Add four binary (1 or 0) columns for company: company_philips, company_akzo, company_van_houten and company_unilever
    refine_original <-
      refine_original %>% 
        mutate(company_philips = ifelse(company == "philips", 1, 0)) %>% 
        mutate(company_akzo = ifelse(company == "akzo", 1, 0)) %>% 
        mutate(company_van_houten = ifelse(company == "van houten", 1, 0)) %>% 
        mutate(company_unilever = ifelse(company == "unilever", 1, 0))
    
    refine_original
    
   # B.	Add four binary (1 or 0) columns for product category:product_smartphone, product_tv, product_laptop and product_tablet
    
    refine_original <-
      refine_original %>% 
      mutate(product_smartphone = ifelse(product_category == "Smartphone", 1, 0)) %>% 
      mutate(product_tv = ifelse(product_category == "TV", 1, 0)) %>% 
      mutate(product_laptop = ifelse(product_category == "Laptop", 1, 0)) %>% 
      mutate(product_tablet = ifelse(product_category == "Tablet", 1, 0))
    
    refine_original
  
    
    
# 6. Export refine_clean.csv
    str(refine_original)
    write.csv(refine_original, "refine_clean.csv")
    
    
