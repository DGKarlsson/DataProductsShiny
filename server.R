require(ggplot2)
source("globals.R")

shinyServer(function(input, output, session)
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
})
