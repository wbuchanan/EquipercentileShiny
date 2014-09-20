library(shiny)

# Define UI for random distribution application 
shinyUI(fluidPage(
     
    # Application title
    titlePanel("What is Equipercentile Linking/Equating?"),
    
    # Add the text to the page
    includeMarkdown("include.md"),
    
    # Sidebar with controls to select the random distribution type
    # and number of observations to generate. Note the use of the
    # br() element to introduce extra vertical spacing
    sidebarLayout(
         
        sidebarPanel(
            
            sliderInput("nsci", "Number of Schools with Science:",
                        min = 400, max = 525, value = 486, step = 5),
            
            sliderInput("nwosci", label = "Number of Schools without Science:",
                        min = 135, max = 175, value = 150, step = 5),
            
            sliderInput("musci", label = "Average Points for Schools with Science:",
                        min = 375, max = 450, value = 405, step = 5),
            
            sliderInput("muwosci", label = "Average Points for Schools without Science:",
                        min = 300, max = 380, value = 345, step = 5),

            selectInput("sigsci", "How diverse are schools with Science?",
                        choices = c("Not at All", "Somewhat", "Very"), 
                        multiple = FALSE, selected = "Somewhat"),

            selectInput("sigwosci", 
                        "How diverse are schools without Science?",
                        choices = c("Not at All", "Somewhat", "Very"),  
                        multiple = FALSE, selected = "Somewhat"),

            sliderInput("barsi", label = "How many points should each bar span:",
                        min = 1, max = 10, value = 5, step = 1),
            
            helpText("The graphs and tables will only change ",
                     "after you press the button below."), 
            
            actionButton("doButton", "Create My Graphs!"),
        
            helpText("Because these data are simulated, you may run ", 
                     "into errors on occassion.  If that happens, just ",
                     "press the Create My Graphs button again to get a ", 
                     "new dataset.")
            
        ),
        
        # Show a tabset that includes a plot, summary, and table view
        # of the generated distribution
        mainPanel(
            tabsetPanel(type = "tabs", 
                        tabPanel("Grades", plotOutput("hist")),                        
                        tabPanel("Percentiles", plotOutput("box1")),
                        tabPanel("Total Points", plotOutput("box2")),
                        tabPanel("Table of Grades", tableOutput("table")),
                        tabPanel("Get The Example Data", dataTableOutput("theData"), #
                                 downloadLink("downloadData","Download the Data"))
            )
        )
    )
))
