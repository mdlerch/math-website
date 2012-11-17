library(shiny)

# Define UI for dataset viewer application
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Stat 524 HW10 -- Michael Lerch"),

  # Sidebar with controls to provide a caption, select a dataset, and 
  # specify the number of observations to view. Note that changes made
  # to the caption in the textInput control are updated in the output
  # area immediately as you type
  sidebarPanel(
		h3("Problem 1 and 2"),
    selectInput("model", "Choose a model:", 
                choices = list("All predictors"="cox.1",
															 "remove ecog.ps"="cox.2",
															 "remove resid.ds"="cox.3",
															 "remove rx"="cox.4"
															 )),
		h3("Problem 3")

  ),


  # Show the caption, a summary of the dataset and an HTML table with
  # the requested number of observations
  mainPanel(
    h3("Problem 1 and 2"), 
		p("Fit the model with all the predictors and remove any predictors not
			significant at the 10% level"),

    verbatimTextOutput("summary"),

		p("Removing predictors, one at a time, that are not significant at the 10%
			level leaves us with a model with only age as a predictor."),

		h3("Problem 3"),
		p("Plot cumulative hazards over time for the two groups using log-log.  Does
			the plot indicate Weibull-type linearities?"),
		plotOutput("hazardplot"),

		h3("Problem 4"),
		p("Fit a weibull model.  Which do you prefer and why"),

		h3("Problem 5"),
		p("Look for problems with the cox.zph function.  Comment")



  )
))
