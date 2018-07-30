library(shiny)
library(ggplot2)

useful_names = c(
  "age",
  "bib#" = "bib",
  "country",
  "elapsed time" = "elapsed",
  "overall ranking" = "overall",
  "overall ranking by sex" = "oversex",
  "sex",
  "start time" = "start"
)

fluidPage(
  titlePanel(sprintf("Wharf to Wharf %d Explorer", year)),
  sidebarLayout(
    # Widgets
    sidebarPanel(
      selectInput('y', 'Y', useful_names, "start"),
      selectInput('x', 'X', useful_names, "elapsed"),
      selectInput('col', 'Color', useful_names, "sex"),
      selectInput(
        'max_rank',
        'Limit to rank',
        c(
          100,
          seq(1000, 13000, 1000),
          max(dataset$overall)
        ),
        max(dataset$overall)
      ),
      textInput("bib", "Bib", "--"),
      checkboxInput('smooth', 'Enable Smoother', FALSE),
      checkboxInput('jitter', 'Enable Jitter', FALSE)
    ),

    mainPanel(
      tabsetPanel(
        # Documentation panel
        tabPanel(
          "README",
          fluidRow(
            br(),
            column(8, offset=2,
              sprintf("The Wharf to Wharf race happens every July in Santa Cruz. The mostly flat,
              6-mile course hugs the coastline between Santa Cruz and Capitola. The 
              race has grown in popularity since its beginning in 1973, with more than %d,000
              registered participants in %d.", thousands_of_participants, year),
              br(),
              br(),
              "Race results are available online. You
              can look up runners' results by bib number, name, city and state. This
              is ok, but it's not very handy for anyone wanting to do real data analysis.",
              br(),
              br(),
              sprintf("This application facilitates exploration of the %d Wharf
              to Wharf Race results. On the 'Data Exploration' tab, the data 
              is plotted in various ways, under control of the widgets on the 
              left. You can choose variables for the X and Y axes, as well 
              as color.", year),
              br(),
              br(),
              "The 'Limit to Rank' control restricts the displayed data to
              those runners who achieved a given overall ranking or better.
              ",
              br(),
              br(),
              "The 'Enable Smoother' checkbox adds trend lines to the plot;
              the 'Enable Jitter' checkbox is helpful when an axis shows a 
              factor variable (sex, country)."
            )
          ),
          fluidRow(
            br(),
            column(8, offset=2,
              tableOutput("url_table")
            ),
            br()
          )
        ),
        # Plot panel
        tabPanel("Data Exploration", 
          br(),
          column(12, plotOutput('plot'))
        )
      )
    )
  )
)
