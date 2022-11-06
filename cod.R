data <- read.csv("E:/5-1/181/Student-Mental-health.csv",
                 header = T,stringsAsFactors = T)
summary(data)

library(tidyverse)
library(corrplot)
library(plyr)

##所有的方差分析
aov_result <- c()
aov_result[["Mental status"]] <- summary(aov(mental_status ~ marital_status*
                                               GPA*`study_year`*age,data =data))
aov_result[["Unhealth grade"]] <- summary(aov(unhealth_grade ~ marital_status*
                                                GPA*`study_year`*age,data =data))
aov_result[["Panic"]] <- summary(aov(panic ~ marital_status*
                                       GPA*`study_year`*age,data =data))
aov_result[["Anxiety"]] <- summary(aov(anxiety ~ marital_status*
                                         GPA*`study_year`*age,data =data))
aov_result[["Depression"]] <- summary(aov(depression  ~ marital_status*
                                            GPA*`study_year`*age,data =data))
aov_result[["Treatment"]] <- summary(aov(treatment   ~ marital_status*
                                           GPA*`study_year`*age,data =data))
aov_result
##与martial status 相关



#有心理问题的占比
sum(data$mental_status==1)/nrow(data)## 64% with mental problem
sum(data$treatment==1)/nrow(data)##6% treated in population
sum(data$treatment==1)/sum(data$mental_status==1)#9% treated in people who with mental problem 
sum(data[data$mental_status==0 & data$treatment == 1,]) ## no one health but treated


colnames(data)
############做一个有问题，不同症状占比的图
data_unhealth <- data[data$mental_status==1,c("unhealth_grade","depression","anxiety","panic")] %>%
  rename(Depression=depression,Anxiety=anxiety,Panic=panic)
data_unhealth_plot <- gather(data_unhealth,key=Symptom,value = Number,-unhealth_grade)
ggplot(data_unhealth_plot,aes(x=Symptom,y=unhealth_grade))+
  #geom_dotplot(binaxis = "y",binwidth = 0.15,dotsize = 0.28,stackdir = "center",aes(fill=key),stackratio = 0.6)
  #画了个点图，不如小提琴图好看。。
  geom_violin(aes(fill=Symptom))+
  theme_classic()+
  ylab("Unhealth grade")+##可以改y轴的名字直接在这里，我觉得health不好
  xlab("")+
  scale_y_continuous(breaks = c(1,2,3))

ggplot(data_unhealth_plot,aes(x=as.factor(unhealth_grade),y=Number,fill=Symptom))+
  geom_bar(stat = "identity")+##这个直方图效果最好
  theme_classic()+
  scale_y_continuous(expand = c(0,0))


#画图数据处理
data_plot <- data
colnames(data_plot)<-c("X","Gender","Gendern","Age","Course_full","Course",
                       "Major","Study_year","GPA","Marital_status","Mental_status",
                       "Unhealth_grade","Depression","Anxiety","Panic","Treatment",
                       "X.1","X.2","GPA.1","X.3","gendern.1")
data_plot$Gender <- factor(data_plot$Gender,levels = c("Male","Female"))

#心理健康打分
##tech or other 小提琴图，用的Mental status（0，1）
ggplot(data_plot,aes(x=Major,y=Mental_status,fill=Major))+
  geom_violin()+theme_classic()+ylab("Mental status")

##堆积条形图
data_plot_major <- data_plot %>% select(Mental_status,Major)
data_plot_major$x <- rep(1,nrow(data))
major <- ddply(data_plot_major,"Major",transform,Percent=1/sum(x)*100)
ggplot(major,aes(x=Major,y=Percent,fill=as.factor(Mental_status)))+
  geom_bar(stat = "identity",width = 0.7)+
  scale_x_discrete(limits = c("Tech","Other"))+
  scale_y_continuous(expand = c(0,0),limits = c(0,100))+
  theme_classic()+
  scale_fill_discrete(labels=c("Health","Mentally ill"))+
  labs(fill="Mental status")

##tech or other 小提琴图，用的Unhealth grade（相加）
ggplot(data_plot,aes(x=Major,y=Unhealth_grade,fill=Major))+
  geom_violin()+theme_classic()+ylab("Unhealth grade")

##堆积条形图
data_plot_major <- data_plot %>% select(Unhealth_grade,Major)
data_plot_major$x <- rep(1,nrow(data))
major <- ddply(data_plot_major,"Major",transform,Percent=1/sum(x)*100)
ggplot(major,aes(x=Major,y=Percent,fill=as.factor(Unhealth_grade)))+
  geom_bar(stat = "identity",width = 0.7)+
  scale_x_discrete(limits = c("Tech","Other"))+
  scale_y_continuous(expand = c(0,0),limits = c(0,100))+
  theme_classic()+
  scale_fill_discrete()+
  labs(fill="Unhealth grade")

##tech与other 专业相比，在心理健康状态无显著差异，Wilcox.test
tech_students_mental_ststus <- data[which(data$major=="Tech"),"mental_status"]
tech_students_grades <- data[which(data$major=="Tech"),"unhealth_grade"]
other_students_mental_ststus <- data[which(data$major=="Other"),"mental_status"]
other_students_grades <- data[which(data$major=="Other"),"unhealth_grade"]
wilcox.test(tech_students_grades,other_students_grades)
wilcox.test(tech_students_mental_ststus,other_students_mental_ststus)

##bio和cs course相比，在心理健康状态无显著差异，Wilcox.test
bio_cs_students_mental_ststus <- data[grepl(pattern = "(bio|com)",ignore.case = T,x = data$course),"mental_status"]
bio_cs_students_grades <- data[grepl(pattern = "(bio|com)",ignore.case = T,x = data$course),"unhealth_grade"]
others_students_mental_ststus <- data[!grepl(pattern = "(bio|com)",ignore.case = T,x = data$course),"mental_status"]
others_students_grades <- data[!grepl(pattern = "(bio|com)",ignore.case = T,x = data$course),"unhealth_grade"]
wilcox.test(bio_cs_students_mental_ststus,others_students_mental_ststus)
wilcox.test(bio_cs_students_grades,others_students_grades)



## male与female小提琴图，用Mental_status
ggplot(data_plot,aes(x=Gender,y=Mental_status,fill=Gender))+
  geom_violin()+theme_classic()

##堆积条形图, 用Mental_status
data_plot_gender <- data_plot %>% select(Mental_status,Gender)
data_plot_gender$x <- rep(1,nrow(data))
gender <- ddply(data_plot_gender,"Gender",transform,Percent=1/sum(x)*100)
gender
ggplot(gender,aes(x=Gender,y=Percent,fill=as.factor(Mental_status)))+
  geom_bar(stat = "identity",width = 0.7)+
  scale_x_discrete(limits = c("Male","Female"))+
  scale_y_continuous(expand = c(0,0),limits = c(0,100.01))+
  theme_classic()+
  scale_fill_discrete(labels=c("Health","Mentally ill"))+
  labs(fill="Mental status")

## male与female小提琴图，用Unhealth_grade
ggplot(data_plot,aes(x=Gender,y=Unhealth_grade,fill=Gender))+
  geom_violin()+theme_classic()

##堆积条形图, 用Unhealth_grade
data_plot_gender <- data_plot %>% select(Unhealth_grade,Gender)
data_plot_gender$x <- rep(1,nrow(data))
gender <- ddply(data_plot_gender,"Gender",transform,Percent=1/sum(x)*100)
ggplot(gender,aes(x=Gender,y=Percent,fill=as.factor(Unhealth_grade)))+
  geom_bar(stat = "identity",width = 0.7)+
  scale_x_discrete(limits = c("Male","Female"))+
  scale_y_continuous(expand = c(0,0),limits = c(0,100.01))+
  theme_classic()+
  scale_fill_discrete()+
  labs(fill="Unhealth grade")

## male与female相比，在心理健康状态无显著差异，Wilcox.test
male_mental_ststus <- data[which(data$gender=="Male"),"mental_status"]
male_grades <- data[which(data$gender=="Male"),"unhealth_grade"]
female_mental_ststus <- data[which(data$gender=="Female"),"mental_status"]
female_grades <- data[which(data$gender=="Female"),"unhealth_grade"]
wilcox.test(male_mental_ststus,female_mental_ststus)
wilcox.test(male_grades,female_grades)



##相关系数分析
cor_data <- data[,c("mental_status","unhealth_grade","panic","anxiety","depression",
                    "treatment","marital_status","GPA","study_year","age")]
colnames(cor_data) <- c("Mental status","Unhealth grade","Panic","Anxiety","Depression",
                        "Treatment","Marital status","GPA","Study year","Age")

savepath <- "C:/Users/Yu/Desktop/QBS181/FP"#也可以getwd()

##ggplot2 相关系数热图，气泡图
for (i in 1:6){
  cor_data1 <- cor(cor_data[,c(i,7:10)])
  cor_data1 <- as.data.frame(cor_data1)
  cor_data1$var1 <- row.names(cor_data1)
  plot_data[[i]] <- gather(cor_data1, key = "var2", value = "corr", -var1)
  library(RColorBrewer)
  my_color <- brewer.pal(5,"GnBu")
  p <- ggplot(plot_data[[i]], aes(var1, var2, fill = corr)) +
    geom_tile(colour = "black") +
    scale_fill_gradientn(colours = my_color)+
    ylab("")+xlab("")+theme_bw()+
    theme(panel.background = element_blank(),
      axis.text  = element_text(size = 14))
  file <- paste(colnames(cor_data)[i],"_retu.png",sep = "")
  ggsave(filename = file,width = 10, height = 6, dpi = 300,path = savepath)
  p <- ggplot(plot_data[[i]], aes(var1, var2, fill = corr)) +
    geom_point(aes(size = abs(corr)), shape = 21, colour = "black") +
    scale_fill_gradientn(colours = my_color) +
    scale_size_area(max_size = 15, guide = FALSE)+theme_bw()+
    ylab("")+xlab("")+theme_bw()+
    theme(panel.background = element_blank(),
          axis.text  = element_text(size = 14))
  file <- paste(colnames(cor_data)[i],"_qipao.png",sep = "")
  ggsave(filename = file,width = 10, height = 6, dpi = 300,path = savepath)
}


## corrplot 画相关系数图
for (i in 1:6){
  cor_data2 <- cor(cor_data[,c(i,7:10)])
  #pmat <- cor.mtest(cor_data2, conf.level = .95)
  #这一行不要，这个是检测相关系数的显著性，加了之后全是不显著...
  file <- paste(colnames(cor_data)[i],"_corplot.pdf",sep = "")
  pdf(file = file,width = 8,height = 8)
  corrplot.mixed(cor_data2,tl.col = "black",lower = "number",
                 upper = "circle",tl.pos = "d", diag = 'u'
                 #,p.mat = pmat$p, sig.level = 0.05,insig = "blank"
                 #上面一行也是相关系数的显著性，不显著的显示白色，结果所有都是白色了
                 )
  dev.off()
}#pdf()保存要在绘图之前


