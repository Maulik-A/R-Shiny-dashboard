library(shiny)
library(shinydashboard)
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

rawfile <- read_excel("Pac_dash/PACdb2.xlsx")
df<-rawfile %>% 
  select(Year:Participants) %>% 
  filter(Year==2019,Category =="Casual")
blocks<-split(df,df$Code) 


ui <- dashboardPage(
        dashboardHeader(title = "PAC Dashboard"),
        dashboardSidebar(
          sidebarMenu(
            menuItem("Sport Participation", tabName = "home", icon = icon("bar-chart-o")),
            menuItem("Sports Comparision", tabName = "dashboard", icon = icon("dashboard")),
            menuItem("Participant profile", tabName = "pp", icon = icon("th"))
            )),
        dashboardBody(
          tabItems(
            tabItem(tabName = "home",
                    fluidRow(
                      box(
                        title = "Filters",
                        selectInput(inputId = "sport",
                                    label = "Select a sport:",
                                    choices= rawfile %>% distinct(Sport)),
                        radioButtons(inputId = "cate",
                                     label = "Categories:",
                                     choices = list("Total" = 1,
                                                    "Casual" = 2,
                                                    "Core" = 3), 
                                     selected = 1),
                        selectizeInput(inputId = "subcate",
                                       label = "Select the views:",
                                       choices = list("By Gender" = 1, 
                                                      "By Age" = 2,
                                                      "By Income" = 3,
                                                      "By Education"=4,
                                                      "By Geographic location"=5),
                                      multiple = TRUE),
                        selectInput(
                          inputId =  "date_from", 
                          label = "Select time period:", 
                          choices = 2014:as.numeric(format(Sys.Date(),"%Y")),
                          multiple = TRUE
                        )
                      )
                    ),
                    fluidRow(box(plotOutput("plot11",width = 8)))
                  ),
            tabItem(tabName = "dashboard",
                    fluidRow(
                      box(plotOutput("plot1", height = 500)),
                      box(
                        title = "Controls",
                        
                        selectInput(inputId = "type",
                                    label = "Select the type of comparison:",
                                    choices = c("Core", "Casual", "Male/Female")),
                      
                        
                        checkboxGroupInput(inputId = "checkGroup", 
                                           label = strong("Select your view here:"), 
                                           choices = list("By Gender" = 1, 
                                                          "By Age" = 2,
                                                          "By Income" = 3,
                                                          "By Education"=4,
                                                          "By Geographic location"=5),
                                           selected = 1),
                        
                        dateRangeInput(inputId = "date", 
                                  label = strong("Date input"),
                                  start = min(rawfile$Year),
                                  end = max(rawfile$Year),
                                  min = strong("Date input"),
                                  max = max(rawfile$Year),
                                  format = "yyyy",
                                  separator = "-"),
                        
                        sliderInput(inputId = "slider_date",
                                    label= strong("Date input"),
                                    min = min(rawfile$Year),
                                    max = max(rawfile$Year),
                                    value=c(2019,2019)
                                    )
                            )
                          ),
                    fluidRow(
                      box(plotOutput("plot2", height = 500)),
                      box(plotOutput("plot3", height = 500)))
                        
                    ),
                      tabItem(tabName = "pp",h2("Widgets tab content"))
    )  #tab items ends here
  )  #dashbody ends here
)  #dashboard page ends here




server <- function(input, output) { 
  
  output$plot11 <- renderPlot({
    
    
  })
  
  
  
  output$plot1 <- renderPlot({
    
    geo_df<-blocks$geo
    ggplot(data=geo_df,mapping= aes(x= Participants,y=Subcategory,fill=Sport))+
      geom_col(position=position_dodge())+
      xlab("Participants in million")+
      ylab("Geographic location")+
      ggtitle("Geographic distribution of the Baseball participants")+
      theme_minimal()
    
  })
  
  
  output$plot2 <- renderPlot({
    
    edu_df<-blocks$edu
    edu_chart<-edu_df %>%
      dplyr::mutate(edu_group = factor(Subcategory, 
                                       levels = c("8th Grade or Less",
                                                  "1-3 years of High School",
                                                  "High School Grad",
                                                  "1-3 years of College",
                                                  "College Grad",
                                                  "Post-Grad Studies"))) %>%
      ggplot(aes(edu_group))+
      geom_bar(aes(weight = Participants),fill = "#0c4c8a") +
      coord_flip() +
      theme_minimal()
    edu_chart
    
  })
  
  output$plot3 <- renderPlot({
    
    age_df<- blocks$age
    age_df %>%
      dplyr::mutate(age_group = factor(Subcategory, 
                                       levels = c("6~12", "13~17", "18~24","25~34",
                                                  "35~44","45~54","55~64","65+"))) %>%
      ggplot(aes(age_group))+
      geom_bar(aes(weight = Participants),fill = "#0c4c8a") +
      coord_flip() +
      theme_minimal()
  })
  
  }

shinyApp(ui, server)
