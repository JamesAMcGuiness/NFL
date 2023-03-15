
install.packages('RODBC')

# Load RODBC package
library(RODBC)

# Connect to Access db
channel <- odbcConnectAccess("C:/Databases/db1.mdb")

# Get data
data <- sqlQuery( channel , paste ("select * from Week")
)
theweek <- data[1,"Week"] 
#theweek <- 34

setwd("C:/ColdFusion9/wwwroot/NFLCode/")

thestr = paste ("select * from NFLSpds where week =",theweek,sep="")

nflgmsall <- sqlQuery( channel , thestr)
nflgms <- nflgmsall 

data <- nflgms

for (row in 1:nrow(nflgms)) {
  fav           <- data[row, "fav"]
  und           <- data[row, "und"]
  ha            <- data[row, "ha"]
  thetimeofgame <- data[row,"timeofgame"]

  if(ha == "H") {
    hometeam = fav
    
  }else{
    hometeam = und
  }
  
  hometeam = trim.trailing(hometeam)
  convertedteam = hometeam
 
  if(hometeam == "LAC"){
    convertedteam = "sdg"
  }
   
  if(hometeam == "BAL"){
    convertedteam = "rav"
  }
  
  if(hometeam == "TEN"){
    convertedteam = "oti"
  }
  
  if(hometeam == "NO"){
    convertedteam = "nor"
  }
  
  if(hometeam == "NE"){
    convertedteam = "nwe"
  }
  
  if(hometeam == "TB"){
    convertedteam = "tam"
  }
  
  
  if(hometeam == "OAK"){
    convertedteam = "rai"
  }
  
  if(hometeam == "ARZ"){
    convertedteam = "crd"
  }
  
  
  if(hometeam == "HOU"){
    convertedteam = "htx"
  }
  
  if(hometeam == "KC"){
    convertedteam = "kan"
  }
  
  
  if(hometeam == "LAR"){
    convertedteam = "ram"
  }
  
  if(hometeam == "SF"){
    convertedteam = "sfo"
  }
  
  if(hometeam == "IND"){
    convertedteam = "clt"
  }
  
  if(hometeam == "GB"){
    convertedteam = "gnb"
  }
  
  
  convertedteam = tolower(convertedteam)
  
  
  url1 <- paste("https://www.pro-football-reference.com/boxscores/",thetimeofgame,sep="")
  url2 <- paste(url1,"0",sep="")
  url3 <- paste(url2,convertedteam,sep="")
  url  <- paste(url3,".htm",sep="") 
  
  
  filename = paste(convertedteam,".htm",sep="")
  
  thepage = readLines(url)
  
  x = thepage
  
  write(x, file = filename,
        ncolumns = if(is.character(x)) 1 else 5,
        append = TRUE, sep = " ")
  
  
  
  FD   = grep('First Downs',thepage)
  LAST = grep('</tbody></table>',FD)	
  
  x = thepage[FD[1]:1000]
  
  
}    


trim.trailing <- function (x) sub("\\s+$", "", x)

hometeam
