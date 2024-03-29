
# initialize
rm(list = ls());
library(data.table)
library(igraph)
library(ggplot2)

# read list
# this is a super-fast way to read mass dataset
edge_list <- fread("E:\\project4\\movie_edge_list.txt",sep='\t', header = F)
names(edge_list) <- c("source","target","weight")
movie_id <- fread("E:\\project4\\movie_id.txt",sep='\t', header = F)
names(movie_id) <- c("name","id")
g <- graph_from_data_frame(d=edge_list, vertices=movie_id, directed=F);

plot(g,vertex.size=1,vertex.label=NA, vertex.color="red",
     edge.width=0.5,edge.arrow.size=0.1);

net_degrees <- degree(g);
degrees_raw <- as.numeric(net_degrees);
degrees_raw <- as.data.frame(degrees_raw);

net_degrees_hist <- as.data.frame(table(net_degrees));

net_degrees_hist[,1] <- as.numeric(net_degrees_hist[,1]);

# change to probablity
net_degrees_hist[,2]  <- net_degrees_hist[,2] / sum(net_degrees_hist$Freq);

# plot
p <- ggplot(net_degrees_hist, aes(x = net_degrees, y = Freq)) + geom_point(alpha=0.5, color="red");
#p <- p + geom_smooth(method = "lm")
#p <- p + labs(y = "Probablity")
p <-  p + ggtitle("Degree Distribution")
p

q <- ggplot(degrees_raw, aes(x = degrees_raw, y = ..density..))
q <- q + geom_histogram(fill = "navy",binwidth=5, alpha=0.5)
q <- q + geom_vline(aes(xintercept=mean(degrees_raw, na.rm=T)),   # Ignore NA values for mean
                    color="red", linetype="dashed", size=1)
q <- q + geom_density(colour = "red")
q <- q + ggtitle("Degree Distribution and Density Curve")
q

mean(net_degrees)
net_degrees[net_degrees == max(net_degrees)]
