#!/usr/bin/Rscript --slave

#usage: chmod +x bibliobypubmed.r 
#usage: ./bibliobypubmed.r "your name"

argv<-commandArgs(TRUE)
query<-toString(argv[1])


#query <- "your name"

#install require R packages if necessary and load them
if(!require(RISmed)){
    install.packages("RISmed")
    library(RISmed)
}

if(!require(ggplot2)){
    install.packages("ggpplot2")
    library(ggplot2)
}



#library(RISmed)
#library(ggplot2)

#get the time machine
time<-toString(Sys.time())

cat("The Query concerned: ", query, "\n")

#perform the pubmed query with the input name
search <- EUtilsSummary(query, type="esearch",db = "pubmed", retmax=30000)
nb <- QueryCount(search)

nb<-toString(nb)
cat ("Number of articles found on Pubmed: ",nb , "\n")

records <- EUtilsGet(search)
years <- YearPubmed(records)
pubs_count <- as.data.frame(table(years))

#print the query time on the screen
cat(time, "\n")
str(pubs_count)
write.table(pubs_count,file="bibliobyyear.txt")
pdf('bibliobyyear.pdf')
 
#build the graph barplot with ggplot2
ggplot(pubs_count,aes(years, Freq,fill=years)) + geom_bar (stat="identity") +
xlab("Year") +
ylab("PUBMED articles by year")+
coord_flip() +
ggtitle(query, time)+
theme_classic()+
labs(caption = nb )+
theme(legend.position="none")+
theme(
  plot.title = element_text(color = "red", size = 20, face = "bold"),
  plot.subtitle = element_text(color = "blue", size = 18),
  plot.caption = element_text(color = "darkgreen", face = "italic", size = 16)
)
dev.off()

#journal analysis
journal <- MedlineTA(records)
journal_count <- as.data.frame(table(journal))
journal_count_order <- journal_count[order(-journal_count[,2]),]

str(journal_count_order)
write.table(journal_count_order, file="bibliobyjournal.txt")

#make journal graph
pdf('bibliobyjournal.pdf')
ggplot(journal_count_order,aes(journal, Freq,fill=journal)) + geom_bar (stat="identity") +
xlab("Journals") +
ylab("Counts")+
ggtitle(query, time)+
theme_classic()+
labs(caption = nb )+
theme(axis.text.x = element_text(angle = 90, hjust = 1))+
theme(legend.position="none")+
theme(
  plot.title = element_text(color = "red", size = 20, face = "bold"),
  plot.subtitle = element_text(color = "blue", size = 18),
  plot.caption = element_text(color = "darkgreen", face = "italic", size = 16)
)
dev.off()




