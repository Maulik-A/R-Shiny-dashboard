# Define UI for application that draws a histogram
shinyUI(fluidPage(

    # Application title
    titlePanel("PAC Dashboard"),
    sidebarLayout(
        sidebarPanel(
          selectInput(inputId = "sport",
                      label = "Select a sport:",
                      choices= raw %>% distinct(Sport)),

          radioButtons(inputId = "cate",
                         label = "Type of Participants:",
                         choices = list("Total" = 1,
                                        "Casual" = 2,
                                        "Core" = 3),
                         selected = 2),

          checkboxGroupInput(inputId = "checkGroup",
                             label = strong("Select your view here:"),
                             choices = list("By Age" = 1,
                                            "By Gender" = 2,
                                            "By Income" = 3,
                                            "By Education"=4,
                                            "By Geographic location"=5),
                              selected = 1),

          sliderInput(inputId = "slider_date",
                      label= strong("Date input"),
                      min = min(raw$Year),
                      max = max(raw$Year),
                      value=c(2014,2019),
                      sep = ""
          )

        ),

        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("distPlot")
      )
    )
  )
)
