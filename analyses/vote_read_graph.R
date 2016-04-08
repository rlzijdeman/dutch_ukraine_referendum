#


# install.packages("XML")
library(XML)
library(ggplot2)
library(scales)

# read data on voting turn-out for Tweede Kamer elections (source: University of Leiden)
urlV <- "http://www.parlement.com/id/vh8lnhrp8wsz/opkomstpercentage_tweede"
table <- as.data.frame(readHTMLTable(urlV, header = TRUE, as.data.frame = TRUE, colClasses = c("numeric", "character")))
names(table) <- c("year", "pct")
table$pct <- as.numeric(gsub(",", ".", table$pct))/100
# str(table)

# add row for voting turn out the #UkraineRef
table$against <- as.numeric(NA)
table <- rbind(table, c(2016, .322, .191)) # adding data from #UkraineRef
table <- rbind(table, c(2016,))

p1 <- ggplot(table, aes(x = year, y = pct)) + geom_bar(stat = "identity", fill = "grey") + 
        geom_bar(aes(x = year, y = against), stat = "identity", fill = "black") +
        geom_text(data = NULL, x = 2020, y = .0955, 
                  label = "> the Dutch 'majority' against \n the Ukraine trade treaty", colour = "black", hjust = .3)
#p1
p2 <- p1 + scale_y_continuous(labels = percent, limits = c(0, 1)) + 
        scale_x_continuous(limits = c(1970, 2025), breaks = table$year) +
        theme_bw(base_size = 16) +
        theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1)) +
        labs(x = "Year of election / referendum", 
             y = "Voter turn out by election ('Tweede Kamer') and Ukraine Referendum", 
             title = "Comparison of voter turn out by year") +
        annotate("text", label = "Source: http://www.parlement.com/id/vh8lnhrp8wsz/opkomstpercentage_tweede", 
                 x = 2005, y = .99, size = 5, colour = "black") +
        annotate("text", label = "Reproducable from: https://github.com/rlzijdeman/dutch_ukraine_referendum.git", 
                 x = 2005, y = .95, size = 5, colour = "black") +
        annotate("text", label = "Copyright: CC0 1.0", 
                 x = 1990.5, y = .91, size = 5, colour = "black")
p2

ggsave("./img/majority_vote.png", p2)
