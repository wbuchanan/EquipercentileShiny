library("shiny"); library("ggplot2"); library("plyr")
source("simdata.R")

if ("markdown" %in% rownames(installed.packages()) == FALSE) install.packages("markdown", dep = TRUE)

# Set random number seed
# set.seed(7779311)

# Define server logic for random distribution application
shinyServer(function(input, output, session) {
     
    mydata <- reactiveValues()     
     
    # Reactive expression to generate the requested distribution.
    # This is called whenever the inputs change. The output
    # functions defined below then all use the value computed from
    # this expression
    mydata <- reactive({
        
        # wait for button push
        input$doButton
        
        isolate(
            
            # Simulate the data for the example
            mydata <- simdata(n0 = input$nsci, 
                        n1 = input$nwosci, 
                        s0 = input$sigsci, 
                        s1 = input$sigwosci, 
                        m0 = input$musci, 
                        m1 = input$muwosci)
        )
        isolate(
            # Return the data object
            return(mydata)
        )
    })
   
    theTable <- reactive({ 
         isolate(
              sci <- subset(mydata(), group == "Schools w/Science", 
                            select = c("grades", "points", "percentiles"))
         )
         isolate(
              wosci <- subset(mydata(), group == "Schools w/o Science", 
                            select = c("grades", "points", "percentiles"))
         )
         isolate(
              sci$size <- length(sci$points)
         )
         isolate(
              wosci$size <- length(wosci$points)
         )  
         isolate(
         # Create a table for schools with science to show the n size,
         # % of schools, and ranges for points and percentiles by 
         # letter grade
         scitab <- cbind(group = "Schools w/Science",                             
                         ddply(sci, .(grades), 
                               summarize, schools = length(points),       
                               pctschools = round((100 * (length(points)/size[1])), 1),          
                               ptslow = min(points), ptshigh = max(points),                 
                               pctlow = min(percentiles), pcthigh = max(percentiles)))
         )
         isolate(
         # Create a table for schools with science to show the n size,
         # % of schools, and ranges for points and percentiles by 
         # letter grade
         woscitab <- cbind(group = "Schools w/o Science",                             
                           ddply(.data = wosci, .(grades), 
                                 summarize, schools = length(points),    
                                 pctschools = round((100 * (length(points)/size[1])), 1),        
                                 ptslow = min(points), ptshigh = max(points),               
                                 pctlow = min(percentiles), pcthigh = max(percentiles)))
         )
         isolate(
              # Build the combined info table for the table display panel
              theTable <- as.data.frame(rbind(scitab, woscitab))
         )
         isolate(
               # Add grades back to the table
              theTable$grades <- rep(c(1:5), 2)
          )
         isolate(
              # Replace the numeric grade values with letters
              theTable$grades <- factor(theTable$grades, levels = c(1:5), 
                                        labels = c("A", "B", "C", "D", "F"))
         )
         isolate(
              # Add Headers to the table with the descriptive statistics
              names(theTable) <- c("Group", "Grades", "# Schools", 
                                   "% Schools", "Min Points", 
                                   "Max Points", "Min %ile", "Max %ile")
         )
         isolate(
              return(theTable)
         )
        
    })
    
    # Plot the distribution of letter grades for schools with and without science
    # as a histogram and map the bar fill to letter grades using a customized discrete 
    # color scale.
    output$hist <- renderPlot({
        
        # Don't render the graph(s) until the end user submits
        input$doButton
        
        # Create a faceted histogram with bars colored in based on the grade 
        # it represents
        isolate(ggplot(mydata(), aes(x = points)) +                            #
            geom_histogram(binwidth = input$binsi, aes(fill = grades), 
                           color = "Black", size = .375) +                     #
            facet_wrap(~ group, nrow = 2) +                                    #
            labs(x = "Total Points", y = "# of Schools",                       #
            title = "Distribution of Total Points") +                          #
            scale_fill_manual(values = c("#0000FF", "#00FF00", "#FFFF00",      #
                                         "#FFA500", "#FF0000"),                #
                              breaks = c("A", "B", "C", "D", "F"),             #
                              name = "Accountability Grades")) +               #
            scale_x_continuous(breaks = seq(100, 600, 25)) +                   #
            theme(panel.background = element_rect(fill = "White"), #
                  strip.text = element_text(size = 12), 
                  legend.title = element_text(size = 12), 
                  legend.text = element_text(size = 10),
                  plot.title = element_text(size = 16),
                  axis.text.x = element_text(size = 10, color = "Black"),
                  axis.text.y = element_text(size = 10, color = "Black"))
    })
    
    # Render a box plot of percentile scores
    output$box1 <- renderPlot({

        # Don't render the graph(s) until the end user submits
        input$doButton
            
        # Create a Box-Plot of Percentiles vs Grades and distinguish between 
        # Schools with & without Science        
        isolate(ggplot(mydata(), aes(factor(grades), percentiles)) +           #
            geom_boxplot(aes(fill = group)) +                                  #
            labs(x = "Grades", y = "Percentile Scores",                        #
            title = "Equivalence of Percentile Scores") +                      #
            scale_fill_manual(values = c("#0000FF", "#FFA500"),                #
                  labels = c("Schools w/Science", "Schools w/o Science"),      # 
                  name = "Accountability Grades")) +                           #
            scale_y_continuous(breaks = seq(0, 100, 10))  +                    #
             theme(panel.background = element_rect(fill = "White"), #
                   strip.text = element_text(size = 12), 
                   legend.title = element_text(size = 12), 
                   legend.text = element_text(size = 10),
                   plot.title = element_text(size = 16),
                   axis.text.x = element_text(size = 14, color = "Black"),
                   axis.text.y = element_text(size = 10, color = "Black"))
        
    })
    
    # Render a box plot with the scaled scores  
    output$box2 <- renderPlot({

        # Don't render the graph(s) until the end user submits
        input$doButton
        
        # Create a Box-Plot of Total Points vs Grades and distinguish between 
        # Schools with & without Science
        isolate(ggplot(mydata(), aes(factor(grades), points)) +                #
            geom_boxplot(aes(fill = group)) +                                  #
            labs(x = "Grades", y = "Total Points",                             #
            title = "Inequivalence of Total Points") +                         #
            scale_fill_manual(values = c("#0000FF", "#FFA500"),                #
                    labels = c("Schools w/Science", "Schools w/o Science"),    # 
                    name = "Accountability Grades")) +                         #
            scale_y_continuous(breaks = seq(100, 600, 25)) +                   #
             theme(panel.background = element_rect(fill = "White"),            #
                   strip.text = element_text(size = 12), 
                   legend.title = element_text(size = 12), 
                   legend.text = element_text(size = 10),
                   plot.title = element_text(size = 16),
                   axis.text.x = element_text(size = 14, color = "Black"),
                   axis.text.y = element_text(size = 10, color = "Black"))
    
    })
    
    # Render a table with the N, %, and range for points/percentiles by grade and
    # by school type (e.g., w/ or w/o science)
    output$table <- renderTable({

        # Print a table of Percentages
        theTable()
    
    })
    
    # Print the entire raw data set to the page
    output$theData <- renderDataTable(
        
        # Print the raw data to the tab
         mydata(), options = list(pageLength = 25, 
                columns = list(
                    list(columns.searchable = TRUE), list(columns.searchable = TRUE),
                    list(columns.searchable = TRUE), list(columns.searchable = TRUE)))
    
    )
    
    # Provides ability to download the raw data file
    output$downloadData <- downloadHandler(
        filename = function() {
            paste('scaleLinking-', sub(" ", "_", Sys.time()), '.csv', sep='')
        },
        content = function(file) {
            write.csv(mydata(), file)
        }
    )
    
})