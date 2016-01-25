source("globals.R")

shinyUI(fluidPage(
    titlePanel("Central Limit Theorem Simulator"),
    sidebarLayout(
        sidebarPanel(numericInput("seed", "Random Seed", 1337),
                     selectInput("dist", "Distribution", distributions),
                     numericInput("num.samples", "Number of Samples", 10000, min=1, max=100000, step=100),
                     numericInput("n", "Number in Each Average", 40, min=1, max=100),
                     conditionalPanel(condition="input.dist == 'norm'", numericInput("norm.mu", "Mu", value=0)),
                     conditionalPanel(condition="input.dist == 'norm'", numericInput("norm.sigma", "Sigma", value=1, min=0.1)),
                     conditionalPanel(condition="input.dist == 'unif'", numericInput("unif.min", "Min", value=0)),
                     conditionalPanel(condition="input.dist == 'unif'", numericInput("unif.max", "Max", value=1)),
                     conditionalPanel(condition="input.dist == 'exp'", numericInput("exp.lambda", "Lambda", value=1, min=0.1))),
        mainPanel(plotOutput("plot"),
                  tableOutput("table"))
    )
))
