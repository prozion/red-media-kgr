library(shiny)
library(ggplot2)
# library(dplyr)
library(forcats)
library(stringr)

ui <- fluidPage(
  titlePanel("Анализ графа связей Red Coop KGR"),
  # sidebarPanel("<select>"),
  mainPanel(
    fluidRow(h3("Блогеры по числу подписчиков")),
    fluidRow(plotOutput("bloggers", height="600")),
    fluidRow(h3("Экспертная популярность - cколько раз блогер был гостем у других блогеров")),
    fluidRow(tableOutput("guests"))
  )
)

server <- function(input, output, session) {
  output$guests <- renderTable({
    read.csv("csv/guest_bloggers.csv")
  })
  output$bloggers <- renderPlot({
    bloggers <- read.csv("csv/yt_bloggers.csv")
    new_bloggers <- bloggers |>
                    transform(
                      n_p = (person |> strsplit("#") |> lapply(function(x) x[2]) |> unlist() |> str_replace("_", " "))
                    )
    new_bloggers <- filter(new_bloggers, !is.na(new_bloggers$n))
    new_bloggers <- transform(
                      new_bloggers,
                      n_p = fct_reorder(n_p, new_bloggers$n)
                    )
    # qplot(data = new_bloggers, y = n_p, weight = n, geom = "bar")
    ggplot(new_bloggers) +
    geom_bar(
      aes(y = n_p, weight = n, fill = "red"),
      show.legend = FALSE
    ) +
    labs(x = NULL, y = NULL) +
    theme(axis.text = element_text(size = 14),
          # plot.margin = margin(0, 300, 0, 100, "pt"),
          panel.background = element_rect(fill = "#ccddcc")
         ) +
    scale_x_continuous(labels = function(x) {
                                  # format(x, scientific = FALSE, big.mark = " ")
                                  sprintf("%s M", x / 1e6)
                                },
                       breaks = c(0, 1e6, 2e6, 3e6, 4e6, 5e6, 6e6)
                      )
  })
  # output$guests <- renderPrint({
  #   getwd()
  # })
}

shinyApp(ui, server)
