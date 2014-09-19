simdata <- function(n0 = 486, n1 = 150, s0 = "Somewhat", #
                    s1 = "Somewhat", m0 = 405, m1 = 345) {
    
    # Check for truncnorm package
    if ("truncnorm" %in% rownames(installed.packages()) == FALSE){
        
        # If package is not installed install it
        install.packages("truncnorm", dep = TRUE)
        
        # Load package after installation
        library("truncnorm")
        
    } 
    
    else {
        
        # Load package after installation
        library("truncnorm")
        
    }
    
    # Variance for schools with science
    s0 <- switch(s0, "Not at All" = 37.5, "Somewhat" = 50, "Very" = 62.5)
    
    # Variance for schools without science            
    s1 <- switch(s1, "Not at All" = 37.5, "Somewhat" = 50, "Very" = 62.5)
    
    # Generate vector of potential total points for schools w/Science
    wScience <- trunc(rtruncnorm(5000, a = 200, b = 700,               #
                mean = m0, sd = s0) + runif(5000, min = -65, max = 47))
    
    # Generate a vector of potential total points for schools w/o science
    woScience <- trunc(rtruncnorm(5000, a = 150, b = 600,              #
                mean = m1, sd = s1) + runif(5000, min = -55, max = 39))

    # Sample the number of schools w/Science requested by user
    wScience <- sample(wScience, size = n0)
    woScience <- sample(woScience, size = n1)
    
    # Sort the data elements in the pctile data frame
    wScience <- wScience[order(wScience)]
    woScience <- woScience[order(woScience)]
    
    # Get cutpoints for the number of quantiles
    cutwsci <- c(1, quantile(unique(wScience),  probs = seq(0.01, 1, .01),     #
                             na.rm = TRUE, names = TRUE))
    
    cutwosci <- c(1, quantile(unique(woScience),  probs = seq(0.01, 1, .01),   #
                              na.rm = TRUE, names = TRUE))
    
    # Define quantiles
    wscipctile <- cut(wScience, cutwsci, include.lowest = TRUE, right = TRUE, 
                      labels = FALSE)
    
    woscipctile <- cut(woScience, cutwosci, include.lowest = TRUE, right = TRUE, 
                       labels = FALSE)
    
    wScigrades <-   ifelse(wScience >= 518, 1,                            #
                    ifelse(wScience >= 455 & wScience <= 517, 2,          #
                    ifelse(wScience >= 400 & wScience <= 454, 3,          #
                    ifelse(wScience >= 325 & wScience <= 399, 4, 5))))
    
    woScigrades <- NA
    
    # Define data frames
    sci <- as.data.frame(cbind(wScience, wscipctile, wScigrades, 0))
    wosci <- as.data.frame(cbind(woScience, woscipctile, woScigrades, 1))
    
    # get the percentile cutoffs for each grade level from schools with science
    wsciA <- range(sci$wscipctile[wScigrades == 1])
    wsciB <- range(sci$wscipctile[wScigrades == 2])
    wsciC <- range(sci$wscipctile[wScigrades == 3])
    wsciD <- range(sci$wscipctile[wScigrades == 4])
    wsciF <- range(sci$wscipctile[wScigrades == 5])
    
    # Get the point ranges for schools without science based on schools with science percentiles
    wosciptsA <- range(wosci$woScience[wosci$woscipctile %in% c(wsciA[1]:wsciA[2])])
    wosciptsB <- range(wosci$woScience[wosci$woscipctile %in% c(wsciB[1]:wsciB[2])])
    wosciptsC <- range(wosci$woScience[wosci$woscipctile %in% c(wsciC[1]:wsciC[2])])
    wosciptsD <- range(wosci$woScience[wosci$woscipctile %in% c(wsciD[1]:wsciD[2])])
    wosciptsF <- range(wosci$woScience[wosci$woscipctile %in% c(wsciF[1]:wsciF[2])])
    
    # Assign grades to the schools without science
    wosci$woScigrades <-    ifelse(wosci$woScience %in% c(wosciptsA[1]:wosciptsA[2]), 1,    #
                            ifelse(wosci$woScience %in% c(wosciptsB[1]:wosciptsB[2]), 2,    #
                            ifelse(wosci$woScience %in% c(wosciptsC[1]:wosciptsC[2]), 3,    #
                            ifelse(wosci$woScience %in% c(wosciptsD[1]:wosciptsD[2]), 4, 5))))
    
    # Create uniform column names for data frames
    colnms <- c("points", "percentiles", "grades", "group")
    
    # Assign same column names to both data frames
    names(sci) <- colnms
    names(wosci) <- colnms
    
    # Create a single combined data frame
    data <- as.data.frame(rbind(sci, wosci))
    
    # Create labels for the factors
    data$grades <- factor(data$grades, levels = c(1:5), #
                          labels = c("A", "B", "C", "D", "F"))
    
    data$group <- factor(data$group, levels = c(0, 1), #
                         labels = c("Schools w/Science", "Schools w/o Science"))
    
    # Return the full data frame object
    return(data)

}