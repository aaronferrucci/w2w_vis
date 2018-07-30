library(shiny)
library(ggplot2)
hours_to_ms <- function(hours) {
  return(hours * 3600 * 1000)
}

elapsed_ticks <- seq(0, max(dataset$elapsed), 900000)
start_ticks <- seq(hours_to_ms(8.5), max(dataset$start), hours_to_ms(2.5/60))

timestr <- function(elapsed) {
  # elapsed is in ms, convert to s
  seconds <- elapsed / 1000.0
  hours <- as.integer(seconds / 3600)
  seconds <- seconds - hours * 3600
  minutes <- as.integer(seconds / 60)
  seconds <- round(seconds - minutes * 60, digits=2)

  minute_prefix <- ifelse(minutes < 10, "0", "")
  minutes <- paste0(minute_prefix, minutes)
  second_prefix <- ifelse(seconds < 10, "0", "")
  seconds <- paste0(second_prefix, seconds)

  time <- paste(hours, minutes, seconds, sep=":")
  return(time)
}

title_part <- function(label)
{
  part <- switch(label,
    elapsed = "Elapsed Time",
    start = "Start Time",
    bib = "Bib #",
    overall = "Overall Ranking",
    oversex = "Overal Ranking by Sex",
    country = "Country",
    age = "Age",
    label)
  return(part)
}

title_string <- function(ylabel, xlabel)
{
  title_y <- title_part(ylabel)
  title_x <- title_part(xlabel)
  return(sprintf("%s vs. %s", title_y, title_x))
}

function(input, output) {
  output$plot <- renderPlot({
    select_data <- dataset[dataset$overall <= as.numeric(input$max_rank),]

    title_y <- input$y
    title_x <- input$x
    elapsed_label <- "Elapsed Time"
    start_label <- "Start Time"
    age_label <- "Age"
    bib_label <- "Bib Number"

    p <- ggplot(select_data, aes_string(x=input$x, y=input$y, col=input$col))
    p <- p + geom_point()

    # Format an "age" axis.
    if (input$x == "age") {
      p <- p + scale_x_continuous(breaks = seq(0, 100, 10))
    } 
    if (input$y == "age") {
      p <- p + scale_y_continuous(breaks = seq(0, 100, 10))
    }

    # Format the "elapsed time" axis.
    if (input$x == "elapsed") {
      title_x <- elapsed_label
      p <- p + scale_x_continuous(
        breaks = elapsed_ticks,
        labels = timestr(elapsed_ticks),
        name = "elapsed time (h:mm:ss)"
      )
    }
    if (input$y == "elapsed") {
      title_y <- elapsed_label
      p <- p + scale_y_continuous(
        breaks = elapsed_ticks,
        labels = timestr(elapsed_ticks),
        name = "elapsed time (h:mm:ss)"
      )
    }

    # Format the "start time" axis"
    if (input$x == "start") {
      title_x <- start_label
      p <- p + scale_x_continuous(
        breaks = start_ticks,
        labels = timestr(start_ticks),
        name = "start time (AM)"
      ) + expand_limits(x = hours_to_ms(8.5))
    }
    if (input$y == "start") {
      title_y <- start_label
      p <- p + scale_y_continuous(
        breaks = start_ticks,
        labels = timestr(start_ticks),
        name = "start time (AM)"
      ) + expand_limits(y = hours_to_ms(8.5))
    }

    p <- p + ggtitle(title_string(input$y, input$x))

    if (input$jitter)
      p <- p + geom_jitter(position = position_jitter(w=.1,h=.1))
    if (input$smooth)
      p <- p + stat_smooth(method = "lm", formula = y ~ x)
    selected_bib <- subset(select_data, bib == input$bib)
    if (nrow(selected_bib) > 0) {
      p <- p + geom_point(data=selected_bib, aes_string(x=input$x, y=input$y), color = "black")
    }
    print(p)

  }, height=600)
  output$url_table <- renderTable({
      labels <- c(
        "Github",
        "2015 W2W Presentation"
      )
      urls <- c(
        "https://github.com/aaronferrucci/ddp2015Project",
        "https://aaronferrucci.github.io/ddp2015Project/"
      )
      references <- paste0(
        labels, ": ", 
        "<a href='",  urls, "' target='_blank'>",
        urls, "</a>")

      data.frame(references)

    }, sanitize.text.function = function(x) x)
}

