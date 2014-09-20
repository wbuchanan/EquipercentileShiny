library(shiny); library("ggplot2"); 
source("simdata.R")

# Set random number seed
set.seed(7779311)

# Define server logic for random distribution application
shinyServer(function(input, output, session) {
        
    # Reactive expression to generate the requested distribution.
    # This is called whenever the inputs change. The output
    # functions defined below then all use the value computed from
    # this expression
    data <- reactive({
        
        # wait for button push
        input$doButton
        
        isolate(
            
            # Simulate the data for the example
            data <- simdata(n0 = input$nsci, 
                        n1 = input$nwosci, 
                        s0 = input$sigsci, 
                        s1 = input$sigwosci, 
                        m0 = input$musci, 
                        m1 = input$muwosci)
        )
        isolate(
            # Return the data object
            return(data)
        )
    })
    
    theTable <- reactive({
    
        # wait for button push
        input$doButton
        
        isolate(
            
            # Generate a column for with Science % of grades
            wsci <- round(100 * prop.table(table(subset(data(),                #
                group == "Schools w/Science", select = grades))), 1)
            
        )
        isolate(
            
            # Generate a column for without Science % of grades
            wosci <- round(100 * prop.table(table(subset(data(),                   #
                    group == "Schools w/o Science", select = grades))), 1)
        )
        isolate(
            
            # Combine the with and without Science % Tables into a single data set
            # Use the letter grades for the row names
            theTable <- as.data.frame(cbind(wsci, wosci),                          #
                                      row.names = c("A", "B", "C", "D", "F"))
        )
        isolate(
            
            # Label the columns
            names(theTable) <- c("With Science", "Without Science")
        )
        isolate(
            
            # Return the data frame object
            return(theTable)    
        )
    
    })
    # Generate a plot of the data. Also uses the inputs to build
    # the plot label. Note that the dependencies on both the inputs
    # and the data reactive expression are both tracked, and
    # all expressions are called in the sequence implied by the
    # dependency graph
    output$hist <- renderPlot({
        
        # Don't render the graph(s) until the end user submits
        input$doButton
        
        # Create a faceted histogram with bars colored in based on the grade 
        # it represents
        isolate(ggplot(data(), aes(x = points, y = 100*..density..)) +         #
            geom_histogram(binwidth = 5, aes(fill = grades)) +                 #
            facet_wrap(~ group, nrow = 2) +                                    #
            labs(x = "Total Points", y = "% of Schools",                       #
            title = "Distribution of Total Points") +                          #
            scale_fill_manual(values = c("#0000FF", "#00FF00", "#FFFF00",      #
                                         "#FFA500", "#FF0000"),                #
                              breaks = c("A", "B", "C", "D", "F"),             #
                              name = "Accountability Grades")) +               #
            scale_x_continuous(breaks = seq(100, 600, 25)) +                   #
            scale_y_continuous(breaks = seq(1, 10, .5))
    })
    
    # Render the first histogram
    output$box1 <- renderPlot({

        # Don't render the graph(s) until the end user submits
        input$doButton
            
        # Create a Box-Plot of Percentiles vs Grades and distinguish between 
        # Schools with & without Science        
        isolate(ggplot(data(), aes(factor(grades), percentiles)) +             #
            geom_boxplot(aes(fill = group)) +                                  #
            labs(x = "Grades", y = "Percentile Scores",                        #
            title = "Equivalence of Percentile Scores") +                      #
            scale_fill_manual(values = c("#0000FF", "#FFA500"),                #
                  labels = c("Schools w/Science", "Schools w/o Science"),      # 
                  name = "Accountability Grades")) +                           #
            scale_y_continuous(breaks = seq(0, 100, 10))
        
    })
    
    # Print the graph on the screen    
    output$box2 <- renderPlot({

        # Don't render the graph(s) until the end user submits
        input$doButton
        
        # Create a Box-Plot of Total Points vs Grades and distinguish between 
        # Schools with & without Science
        isolate(ggplot(data(), aes(factor(grades), points)) +                  #
            geom_boxplot(aes(fill = group)) +                                  #
            labs(x = "Grades", y = "Total Points",                             #
            title = "Inequivalence of Total Points") +                         #
            scale_fill_manual(values = c("#0000FF", "#FFA500"),                #
                    labels = c("Schools w/Science", "Schools w/o Science"),    # 
                    name = "Accountability Grades")) +                         #
            scale_y_continuous(breaks = seq(100, 600, 25))
    
    })
    
    # Generate an HTML table view of the data
    output$table <- renderTable({

        # Print a table of Percentages
        theTable()
    
    })
    
    # Print the entire raw data set to the page
    output$theData <- renderDataTable(
        
        # Print the raw data to the tab
        data(), options = list(iDisplayLength = 25, 
                aoColumns = list(
                    list(bSearchable = TRUE), list(bSearchable = TRUE),
                    list(bSearchable = TRUE), list(bSearchable = TRUE)))
    
    )
    
    # Provides ability to download the raw data file
    output$downloadData <- downloadHandler(
        filename = function() {
            paste('scaleLinking-', sub(" ", "_", Sys.time()), '.csv', sep='')
        },
        content = function(file) {
            write.csv(data(), file)
        }
    )
    
})