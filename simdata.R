simdata <- function(n0 = 486, n1 = 150, s0 = "Somewhat", #
                    s1 = "Somewhat", m0 = 405, m1 = 345) {
    
    # Check for truncnorm package
    if ("truncnorm" %in% rownames(installed.packages()) == FALSE) {
         install.packages("truncnorm", dep = TRUE)
    }
    
    # Load the truncnorm package to simulate random variables from a truncated normal distribution
    library("truncnorm")
    
    # Load plyr for data manipulate to build out tables
    require("plyr")
    
    # Variance for schools with science
    s0 <- switch(s0, "Not at All" = 20, "Somewhat" = 40, "Very" = 80)
    
    # Variance for schools without science            
    s1 <- switch(s1, "Not at All" = 15, "Somewhat" = 30, "Very" = 60)
    
    # Generate vector of potential total points for schools w/Science
    wScience <- trunc(rtruncnorm(5000, a = 200, b = 700,               #
                mean = m0, sd = s0) + runif(5000, min = -65, max = 47))
    
    # Generate a vector of potential total points for schools w/o science
    woScience <- trunc(rtruncnorm(5000, a = 150, b = 600,              
                mean = m1, sd = s1) + runif(5000, min = -55, max = 39))
    
    # Sample the number of schools w/Science requested by user
    wScience <- sample(wScience, size = n0); woScience <- sample(woScience, size = n1)
    
    # Sort the data elements in the pctile data frame
    wScience <- wScience[order(wScience)]; woScience <- woScience[order(woScience)]
    
    # Estimate quantiles for schools with science 
    cutwsci <- quantile(unique(wScience),  probs = seq(0, 1, .01),     
                             na.rm = TRUE, names = TRUE)
    
    # Estimate quantiles for schools without science 
    cutwosci <- quantile(unique(woScience),  probs = seq(0, 1, .01),   
                              na.rm = TRUE, names = TRUE)
    
    # Define quantiles for schools with science
    wscipctile <- cut(wScience, cutwsci, include.lowest = TRUE, right = TRUE, 
                      labels = FALSE)
    
    # Define quantiles for schools without science
    woscipctile <- cut(woScience, cutwosci, include.lowest = TRUE, right = TRUE, 
                       labels = FALSE)
    
    # Assign letter grades for schools w/science bassed on published cutscores
    wScigrades  <- cut(wScience, breaks = c(0, 324, 399, 454, 517, 700), 
                         include.lowest = TRUE, right = TRUE)

    # Grades for schools w/o science NA at this point    
    woScigrades <- NA
    
    # Define data frames
    sci <- as.data.frame(cbind(wScience, wscipctile, wScigrades, 0))
    wosci <- as.data.frame(cbind(woScience, woscipctile, woScigrades, 1))
    
    # Create a lookup table with the minimum/maximum values of percentiles for each grade
    pctcuts <- ddply(sci, .(wScigrades), summarize, low = min(wscipctile), high = max(wscipctile))
    pctcuts[1, "low"] <- 1; pctcuts[5, "high"] <- 100  
    
    # Get the point ranges for schools without science based on schools with science percentiles
    wosciptsA <- range(wosci$woScience[wosci$woscipctile %in% c(pctcuts[1, "low"] : pctcuts[1, "high"])])
    wosciptsB <- range(wosci$woScience[wosci$woscipctile %in% c(pctcuts[2, "low"] : pctcuts[2, "high"])])
    wosciptsC <- range(wosci$woScience[wosci$woscipctile %in% c(pctcuts[3, "low"] : pctcuts[3, "high"])])
    wosciptsD <- range(wosci$woScience[wosci$woscipctile %in% c(pctcuts[4, "low"] : pctcuts[4, "high"])])
    wosciptsF <- range(wosci$woScience[wosci$woscipctile %in% c(pctcuts[5, "low"] : pctcuts[5, "high"] )])
    
    # Assign grades to the schools without science
    wosci$woScigrades <-    ifelse(wosci$woScience %in% c(wosciptsA[1] : wosciptsA[2]), 1,    #
                            ifelse(wosci$woScience %in% c(wosciptsB[1] : wosciptsB[2]), 2,    #
                            ifelse(wosci$woScience %in% c(wosciptsC[1] : wosciptsC[2]), 3,    #
                            ifelse(wosci$woScience %in% c(wosciptsD[1] : wosciptsD[2]), 4, 5))))
    
    # Create uniform column names for data frames
    colnms <- c("points", "percentiles", "grades", "group")
    
    # Assign same column names to both data frames
    names(sci) <- colnms; names(wosci) <- colnms
    
    # Create a single combined data frame
    ddata <- as.data.frame(rbind(sci, wosci))
    
    # Assign labels to the grades factor
    ddata$grades <- factor(ddata$grades, levels = c(5:1), 
                           labels = c("A", "B", "C", "D", "F"))
    
    # Assign labels to the group identifier for schools with/without science
    ddata$group <- factor(ddata$group, levels = c(0, 1), #
                    labels = c("Schools w/Science", "Schools w/o Science"))
        
    # Return the full data frame object
    return(ddata)

}