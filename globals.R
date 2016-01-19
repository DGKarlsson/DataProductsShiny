require(shiny)
require(ggplot2)


distributions <- c(Normal="norm", Uniform="unif", Exponential="exp")
dist.funcs <- c(norm=function(input) rnorm(input$n, input$norm.mu, input$norm.sigma),
                unif=function(input) runif(input$n, input$unif.min, input$unif.max),
                exp=function(input) rexp(input$n, input$exp.lambda))
dist.mu <- c(norm=function(input) input$norm.mu,
             unif=function(input) (input$unif.min + input$unif.max)/2,
             exp=function(input) 1/input$exp.lambda)
dist.sigma <- c(norm=function(input) input$norm.sigma,
                unif=function(input) 1/12 * (input$unif.max - input$unif.min)**2,
                exp=function(input) 1/input$exp.lambda)


