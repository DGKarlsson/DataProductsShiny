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


server <- function(input, output, session)
{
    th.mu <- reactive({dist.mu[[input$dist]](input)})
    th.sigma <- reactive({dist.sigma[[input$dist]](input) * 1/sqrt(input$n)})
    sample <- reactive({
        set.seed(input$seed)
        means = NULL
        for (i in 1:input$num.samples)
            means <- c(means, mean(dist.funcs[[input$dist]](input)))
        means
    })

    output$plot <- renderPlot({
        means <- sample()
        ggplot(as.data.frame(means), aes(means)) +
            geom_histogram(aes(y=..density..), fill="red", bins=30) +
            stat_function(fun=function(x) dnorm(x, th.mu(), th.sigma()), size=1)
    })
    output$table <- renderTable({
        df <- data.frame(mean=c(th.mu(), mean(sample())), sd=c(th.sigma(), sd(sample())))
        rownames(df) <- c("Theoretical", "Actual")
        df
    })
}


ui <- fluidPage(
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
)

runApp(shinyApp(ui=ui, server=server))

