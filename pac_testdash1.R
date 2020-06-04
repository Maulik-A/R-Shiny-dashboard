library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)

rawfile <- read_excel("Pac_dash/PACdb2.xlsx")


  ##use this line to split (drill down)

blocks<-split(rawfile,rawfile$Code) 


  ##could use this for individual analysis
  ##sex_df<- df %>% filter(Subcategory == "Male" | Subcategory == "Female")


  ##edu_df<-edu_df %>% 
    ##spread(key=Subcategory,value = Participants)



sex_df<-blocks$sex[,5:6]
sex_chart<-ggplot(sex_df) +
  aes(x = Subcategory, weight = Participants) +
  geom_bar(fill = "#0c4c8a") +
  theme_minimal()



geo_df<- blocks$geo
geo_chart<-ggplot(geo_df)+
  aes(x = Subcategory, weight = Participants) +
  geom_bar(fill = "#0c4c8a") +
  coord_flip() +
  theme_minimal()+
  labs(title = "New plot by Geography")+
  labs(y = "Participants in Millions")



inc_df<-blocks$inc[5:6]
inc_chart<-inc_df %>%
  dplyr::mutate(inc_group = factor(Subcategory, 
                                   levels = c("Under $25000", "$25000 to $49999", "$50000 to $74999",
                                              "$75000 to $99999","$100000+"))) %>%
  ggplot(aes(inc_group))+
  geom_bar(aes(weight = Participants),fill = "#0c4c8a")+
  coord_flip() +
  theme_minimal()



age_df<- blocks$age[5:6]
age_chart<-age_df %>%
  dplyr::mutate(age_group = factor(Subcategory, 
                                   levels = c("6~12", "13~17", "18~24","25~34",
                                              "35~44","45~54","55~64","65+"))) %>%
  ggplot(aes(age_group))+
  geom_bar(aes(weight = Participants),fill = "#0c4c8a") +
  coord_flip() +
  theme_minimal()

edu_df<-blocks$edu[5:6]
edu_chart<-edu_df %>%
  dplyr::mutate(edu_group = factor(Subcategory, 
                                   levels = c("8th Grade or Less", "1-3 years of High School", "High School Grad",
                                              "1-3 years of College","College Grad","Post-Grad Studies"))) %>%
  ggplot(aes(edu_group))+
  geom_bar(aes(weight = Participants),fill = "#0c4c8a") +
  coord_flip() +
  theme_minimal()




f<-ggplot(data=geo_df,mapping= aes(x= Participants,y=Subcategory))+
  geom_col(aes(fill=Year))+
  xlab("Participants in million")+
  ylab("Geographic location")+
  ggtitle("Geographic distribution of the Baseball participants")


  
