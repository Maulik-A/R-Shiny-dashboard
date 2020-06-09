# Define server logic required to draw a histogram
shinyServer(function(input, output) {

    #create a dataframe
    df<- reactive({
        raw %>%
        filter(Sport == input$sport) %>%
        filter(
            if (input$cate==2) {
                Category =="Casual"
            } else if (input$cate==3){
                Category =="Core"
            } else {
                (Category == "Casual" | Category == "Core")
            })
    })




    output$distPlot <- renderPlot({

      df_plot<- df() %>%
        filter(Code == "sex") %>%
        #dplyr::filter(Year %in% input$slider_date) %>%
        group_by(Year,Subcategory) %>%
        summarise(Participants = sum(Participants)) %>%
        ungroup()

      ggplot(data=df_plot,mapping= aes(x= Year,y=Participants,group=Subcategory,
                                       label=sprintf("%0.1f", round(Participants, digits = 1))))+
        geom_line(aes(color=Subcategory))+
        geom_point(aes(color=Subcategory))+
        geom_text(hjust = 0, nudge_x = 0.05)+
        ylab("Participants in million")+
        xlab("Year")+
        ggtitle("Gender distribution of the Baseball participants")+
        theme_minimal()

    })



})
