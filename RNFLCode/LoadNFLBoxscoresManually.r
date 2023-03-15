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



thestr = "select * from nflspds where week=19"


# Get data
data <- sqlQuery( channel , thestr 
)
#theday = '201711110'
theday = paste(thegametime,'0',sep="")


for (row in 1:nrow(data)) {


#for (row in 3:3) 
#{

  
  if(row ==1){
  fav           = 'HOU'
  und           = 'MIA'
  ha            = 'H' 
  thetimeofgame = '20181025'
  }
  

  if(row ==2){
    fav           = 'PHI'
    und           = 'JAX'
    ha            = 'H' 
    thetimeofgame = '20181028'
  }
  
  if(row ==3){
    fav           = 'PIT'
    und           = 'CLE'
    ha            = 'H' 
    thetimeofgame = '20181028'
  }
    
  
  if(row ==4){
    fav           = 'KC'
    und           = 'DEN'
    ha            = 'H' 
    thetimeofgame = '20181028'
  }
  
  
  if(row ==5){
    fav           = 'CHI'
    und           = 'NYJ'
    ha            = 'H' 
    thetimeofgame = '20181028'
  }
  
  if(row ==6){
    fav           = 'WAS'
    und           = 'NYG'
    ha            = 'A' 
    thetimeofgame = '20181028'
  }
  
  
  if(row ==7){
    fav           = 'DET'
    und           = 'SEA'
    ha            = 'H' 
    thetimeofgame = '20181028'
  }
  
  if(row ==8){
    fav           = 'CIN'
    und           = 'TB'
    ha            = 'H' 
    thetimeofgame = '20181028'
  }
  
  if(row ==9){
    fav           = 'BAL'
    und           = 'CAR'
    ha            = 'A' 
    thetimeofgame = '20181028'
  }
  
  
  if(row ==10){
    fav           = 'IND'
    und           = 'OAK'
    ha            = 'A' 
    thetimeofgame = '20181028'
  }
  
  if(row ==11){
    fav           = 'SF'
    und           = 'ARZ'
    ha            = 'A' 
    thetimeofgame = '20181028'
  }
  
  
  if(row ==12){
    fav           = 'LAR'
    und           = 'GB'
    ha            = 'A' 
    thetimeofgame = '20181028'
  }
  
  
  if(row ==13){
    fav           = 'NO'
    und           = 'MIN'
    ha            = 'A' 
    thetimeofgame = '20181028'
  }
  
  
  if(row ==14){
    fav           = 'NE'
    und           = 'BUF'
    ha            = 'A' 
    thetimeofgame = '20181029'
  }
  
  
  
  if(row ==15){
    fav           = 'GB'
    und           = 'SF'
    ha            = 'H' 
    thetimeofgame = '20181015'
  }
  
  if(row ==16){
    fav           = 'SEA'
    und           = 'OAK'
    ha            = 'A' 
    thetimeofgame = '20181014'
  }
  

  if(row ==17){
    fav           = 'BAL'
    und           = 'TEN'
    ha            = 'A' 
    thetimeofgame = '20181014'
  }
  
  fav <- data[row, "fav"]
  und  <- data[row, "und"]
  ha  <- data[row, "ha"]
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


