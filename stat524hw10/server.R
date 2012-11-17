library(shiny)
library(datasets)

library(survival)

summary(cox.1 <- coxph(Surv(futime,fustat)~.-rx+as.factor(rx),ovarian))
summary(cox.2 <- update(cox.1,.~.-ecog.ps))
summary(cox.3 <- update(cox.2,.~.-resid.ds))
summary(cox.4 <- update(cox.3,.~.-as.factor(rx)))

cox.ph <- update(cox.4,.~.+strata(rx))


# Define server logic required to summarize and view the selected dataset
shinyServer(function(input, output) {

  # By declaring datasetInput as a reactive function we ensure that:
  #
  #  1) It is only called when the inputs it depends on changes
  #  2) The computation and result are shared by all the callers (it 
  #     only executes a single time)
  #  3) When the inputs change and the function is re-executed, the
  #     new result is compared to the previous result; if the two are
  #     identical, then the callers are not notified
  #
  modelInput <- reactive(function() {
    switch(input$model,
           "cox.1" = cox.1,
           "cox.2" = cox.2,
           "cox.3" = cox.3,
           "cox.4" = cox.4,
					 )
  })

  # The output$caption is computed based on a reactive function that
  # returns input$caption. When the user changes the "caption" field:
  #
  #  1) This function is automatically called to recompute the output 
  #  2) The new caption is pushed back to the browser for re-display
  # 
  # Note that because the data-oriented reactive functions below don't 
  # depend on input$caption, those functions are NOT called when 
  # input$caption changes.

  # The output$summary depends on the datasetInput reactive function, 
  # so will be re-executed whenever datasetInput is re-executed 
  # (i.e. whenever the input$dataset changes)
  output$summary <- reactivePrint(function() {
    model <- modelInput()
    summary(model)
  })

	output$hazardplot <- reactivePlot(function() {
		plot(survfit(cox.ph),fun="cloglog")
	})

  # The output$view depends on both the databaseInput reactive function
  # and input$obs, so will be re-executed whenever input$dataset or 
  # input$obs is changed. 
})
