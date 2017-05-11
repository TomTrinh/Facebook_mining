setwd("C:\\Users\\tom.trinh\\Desktop\\R\\facebook mining")
library("Rfacebook")
library(tidyverse)


#this step do at the first time -------------
#source(fb_oauth_func.R)
fb_oauth <- fbOAuth(app_id="xxxxxx", app_secret="xxxxxxxxx",extended_permissions = TRUE)

save(fb_oauth, file="fb_oauth")
#----------------------------------------------

load("fb_oauth")

me <- getUsers("me",token=fb_oauth)

likes = getLikes(user="me", token = fb_oauth)#List of all the pages you have liked
sample(likes$names, 10)
updateStatus("this is just a test", token=fb_oauth) #Update Facebook Status from R
pages <- searchPages( string="sapp", token=fb_oauth, n=200) #Search Pages that contain a particular keyword
head(pages$name)
page <- getPage(page=376474342521895, token=fb_oauth, n=200) # Extract list of posts from a Facebook page
page <- getPage("Paymentwall Inc.", token=fb_oauth, n=100,
                since='2016/06/01', until='2017/03/20')#Get all the posts from a particular date

summary = page[which.max(page$likes_count),]#Which of these posts got maximum likes?

summary1 = page[which.max(page$comments_count),]#Which of these posts got maximum comments?

summary2 = page[which.max(page$shares_count),]#Which post was shared the most?

post <- getPost(summary$id[1], token=fb_oauth, comments = FALSE, n.likes=2000)#Extract a list of users who liked the maximum liked posts
likes <- post$likes
head(likes)

post <- getPost(page$id[1], token=fb_oauth, n.comments=1000, likes=FALSE)#Extract FB comments on a specific post
comments <- post$comments
fix(comments)

comments[which.max(comments$likes_count),]#What is the comment that got the most likes?
head(sort(table(users$first_name), dec=TRUE), n=3)#What are the most common first names in the user list?

post <- getReactions(post=page$id[1], token=fb_oauth)#Extract Reactions for most recent post

# Extract posts from Machine Learning Facebook group
ids <- searchGroup(name="machinelearningforum", token=fb_oauth)# searches id of a group. In case, searchGroup() function could not find group id. You can search it on lookup-id website.
group <- getGroup(group_id=ids[1,]$id, token=fb_oauth, n=25)



userliked <- function(x) {
        post <- getPost(x, token=fb_oauth, comments = FALSE, n.likes=2000)
        likes <- post$likes
        return (likes)
}

from_name <- c()
from_id <- c()
x <- data.frame(from_name,from_id)
for (i in seq(page$id)) {
        x <- rbind(x,userliked(page$id[i]))
}
y <- as.data.frame(table(x$from_name)) %>% arrange(desc(Freq))#top user like much in page

me <- getUsers(users = 1431292863599510,token=fb_oauth,private_info =T)
