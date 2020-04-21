require("stargazer")

#-------------------------------------------------------------------------------------------------------------------------
# This function takes the saved results you got from Ordinary least square regression (Linear model) and VIF calculation
# and print output as a nice table for a given target zone

# Args:
#   all_lm_VIF_res: data you want to plot, this data you saved from AVHRRStatistics.R code
#   targetzone: any one of these characters: "interior", "desert", "coastal"
#   type: "text" as default pdf output, or "latex" for latex table

#-------------------- Now, make a summary from the model results for each target zone ----------------------------------------

get_summary_table_for_lm_VIF<-function(all_lm_VIF_res,targetzone,type="text"){
  
  if(targetzone=="interior"){ # Interior Cities
    
    z<-all_lm_VIF_res$Interior_LinearModel_VIF
    
    stargazer::stargazer(z$Charleston_lm, z$StLouis_lm, z$Minneapolis_lm, z$SaltLakeCity_lm, 
                         title = "Linear Models for Interior Cities", align = TRUE,
                         type=type, 
                         column.sep.width = "-5pt", omit.stat = "f",
                         column.labels = c("Charleston, WV", "Kansas City, MO", "Minneapolis, MN", "Salt Lake City, UT"),
                         covariate.labels=c("NDVI", "Population", "Agriculture"),
                         dep.var.labels = "Logit Transformed Synchrony")
    
    stargazer::stargazer(z$VIFInterior, title = "VIF for Interior Cities",  type = type, summary = FALSE)
    
  }
  
  if(targetzone=="desert"){ # Desert Cities
    
    z<-all_lm_VIF_res$Desert_LinearModel_VIF
    
    stargazer::stargazer(z$LasVegas_lm, z$Page_lm, z$Phoenix_lm, z$Reno_lm,
                         title = "Linear Models for Desert Cities", align = TRUE,
                         type = type,
                         column.sep.width = "-5pt", omit.stat = "f",
                         column.labels = c("Las Vegas, NV", "Page, AZ", "Phoenix, AZ", "Reno, NV"),
                         covariate.labels=c("NDVI", "Population", "Agriculture"),
                         dep.var.labels = "Logit Transformed Synchrony")
    
    stargazer::stargazer(z$VIFDesert, title = "VIF for Desert Cities", type = type, summary = FALSE)
    
  }
  
  if(targetzone=="desert"){ # Coastal Cities
    
    z<-all_lm_VIF_res$Coastal_LinearModel_VIF
    
    stargazer::stargazer(z$Chicago_lm, z$NewOrleans_lm, z$NewYorkCity_lm, z$SanFrancisco_lm,
                         title = "Linear Models for Coastal Cities", align = TRUE,
                         type = type,
                         column.sep.width = "-5pt", omit.stat = "f",
                         column.labels = c("Chicago, IL", "New Orleans, LA", "New York City, NY", "San Francisco, CA"),
                         covariate.labels=c("NDVI", "Population", "Agriculture"),
                         dep.var.labels = "Logit Transformed Synchrony")
    
    stargazer::stargazer(z$VIFCoastal, title = "VIF for Coastal Cities", type = type, summary = FALSE)
    
  }
  
}




