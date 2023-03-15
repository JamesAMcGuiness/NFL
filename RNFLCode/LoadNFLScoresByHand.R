
install.packages('RODBC')
install.packages('stringi')


# Load RODBC package
library(RODBC)
library(stringi)
# Connect to Access db

setwd("C:/temp/")

fav ="CAR"
und ="CIN"
ha  ="H"
thetimeofgame="20180923"
tmshort = ""



filename = paste("Scores",".htm",sep="")

#Create an array of NFL team names 
nfltms <- "New York Jets"
nfltms <- c(nfltms,"New York Giants")
nfltms <- c(nfltms,"Washington Redskins")
nfltms <- c(nfltms,"Philadelphia Eagles")
nfltms <- c(nfltms,"Dallas Cowboys")
nfltms <- c(nfltms,"New England Patriots")
nfltms <- c(nfltms,"Buffalo Bills")
nfltms <- c(nfltms,"Miami Dolphins")
nfltms <- c(nfltms,"New Orleans Saints")
nfltms <- c(nfltms,"Atlanta Falcons")
nfltms <- c(nfltms,"Carolina Panthers")
nfltms <- c(nfltms,"Tampa Bay Buccaneers")
nfltms <- c(nfltms,"Indianapolis Colts")
nfltms <- c(nfltms,"Jacksonville Jaguars")
nfltms <- c(nfltms,"Tennessee Titans")
nfltms <- c(nfltms,"Houston Texans")
nfltms <- c(nfltms,"Arizona Cardinals")
nfltms <- c(nfltms,"Los Angeles Rams")
nfltms <- c(nfltms,"Oakland Raiders")
nfltms <- c(nfltms,"Denver Broncos")
nfltms <- c(nfltms,"Kansas City Chiefs")
nfltms <- c(nfltms,"Los Angeles Chargers")
nfltms <- c(nfltms,"Minnesota Vikings")
nfltms <- c(nfltms,"Chicago Bears")
nfltms <- c(nfltms,"Green Bay Packers")
nfltms <- c(nfltms,"Detroit Lions")
nfltms <- c(nfltms,"Cleveland Browns")
nfltms <- c(nfltms,"San Francisco 49ers")
nfltms <- c(nfltms,"Pittsburgh Steelers")
nfltms <- c(nfltms,"Cincinnati Bengals")
nfltms <- c(nfltms,"Baltimore Ravens")
nfltms <- c(nfltms,"Seattle Seahawks")



for (row in 1:15) {
  
  
  if(row ==1){
    fav           = 'LAR'
    und           = 'MIN'
    ha            = 'H' 
    thetimeofgame = '20180927'
  }
  
  
  if(row ==2){
    fav           = 'NE'
    und           = 'MIA'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  if(row ==3){
    fav           = 'IND'
    und           = 'HOU'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==4){
    fav           = 'ATL'
    und           = 'CIN'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==5){
    fav           = 'GB'
    und           = 'BUF'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  if(row ==6){
    fav           = 'DAL'
    und           = 'DET'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==7){
    fav           = 'JAX'
    und           = 'NYJ'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  if(row ==8){
    fav           = 'CHI'
    und           = 'TB'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  if(row ==9){
    fav           = 'PHI'
    und           = 'TEN'
    ha            = 'A' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==10){
    fav           = 'SEA'
    und           = 'ARZ'
    ha            = 'A' 
    thetimeofgame = '20180930'
  }
  
  if(row ==11){
    fav           = 'OAK'
    und           = 'CLE'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==12){
    fav           = 'LAC'
    und           = 'SF'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==13){
    fav           = 'NO'
    und           = 'NYG'
    ha            = 'A' 
    thetimeofgame = '20180930'
  }
  
  
  if(row ==14){
    fav           = 'PIT'
    und           = 'BAL'
    ha            = 'H' 
    thetimeofgame = '20180930'
  }
  
  
  
  if(row ==15){
    fav           = 'KC'
    und           = 'DEN'
    ha            = 'A' 
    thetimeofgame = '20181001'
  }
  




if(ha == "H") {
  hometeam = fav
  awayteam = und
  
}else{
  hometeam = und
  awayteam = fav
}

hometeam = trim.trailing(hometeam)
awayteam = trim.trailing(awayteam)

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


#url <- "http://localhost/R/NFLBoxscore.html"

thepage = readLines(url)
#awayteam <- "BUF"
x = thepage

asstring <- toString(x)
chkTeams(awayteam)




checkstr <- stri_locate_all(pattern=tmshort,asstring,fixed = TRUE)

part1 <- checkstr[[1]][2]
part2 <- checkstr[[1]][3]
thescorestr <- substr(asstring,part1-3,part2 - 230)

write(thescorestr, file = filename,
      ncolumns = if(is.character(x)) 1 else 5,
      append = TRUE, sep = " ")

}


trim.trailing <- function (x) sub("\\s+$", "", x)



chkTeams <- function (awayteam)
{
  
  tm<- awayteam
  
  if(tm == 'PIT')
  {
    eval.parent(substitute(tmshort <- 'Pittsburgh Steelers'))
  }
  
  
  if(tm == 'TEN')
  {
    eval.parent(substitute(tmshort <- 'Tennessee Titans'))
  }
  
  
  if(tm == 'DET')
  {
    eval.parent(substitute(tmshort <- 'Detroit Lions'))
  }
  
  
  if(tm == 'CHI')
  {
    eval.parent(substitute(tmshort <- 'Chicago Bears'))
  }
  
  
  if(tm == 'KC')
  {
    eval.parent(substitute(tmshort <- 'Kansas City Chiefs'))
  }
  
  
  if(tm == 'NYG')
  {
    eval.parent(substitute(tmshort <- 'New York Giants'))
  }
  
  
  
  if(tm == 'CIN')
  {
    eval.parent(substitute(tmshort <- 'Cincinnati Bengals'))
  }
  
  
  if(tm == 'DEN')
  {
    eval.parent(substitute(tmshort <- 'Denver Broncos'))
  }
  
  
  
  if(tm == 'MIN')
  {
    eval.parent(substitute(tmshort <- 'Minnesota Vikings'))
  }
  
  
  
  if(tm == 'LAR')
  {
    eval.parent(substitute(tmshort <- 'Los Angeles Rams'))
  }
  
  
  if(tm == 'ARZ')
  {
    eval.parent(substitute(tmshort <- 'Arizona Cardinals'))
  }
  
  
  
  if(tm == 'CLE')
  {
    eval.parent(substitute(tmshort <- 'Cleveland Browns'))
  }
  
  
  if(tm == 'LAC')
  {
    eval.parent(substitute(tmshort <- 'Los Angeles Chargers'))
  }
  
  
  
  if(tm == 'BUF')
  {
    eval.parent(substitute(tmshort <- 'Buffalo Bills'))
  }
  
  
  if(tm == 'NE')
  {
    eval.parent(substitute(tmshort <- 'New England Patriots'))
  }
  
  
  
  if(tm == 'OAK')
  {
    eval.parent(substitute(tmshort <- 'Oakland Raiders'))
  }
  
  
  
  if(tm == 'PHI')
  {
    eval.parent(substitute(tmshort <- 'Philadelphia Eagles'))
  }
  
  if(tm == 'DAL')
  {
    eval.parent(substitute(tmshort <- 'Dallas Cowboys'))
  }
  
  
  
  
  if(tm == 'NO')
  {
    eval.parent(substitute(tmshort <- 'New Orleans Saints'))
  }
  
  if(tm == 'WAS')
  {
    eval.parent(substitute(tmshort <- 'Washington Redskins'))
  }
  
  
  
  if(tm == 'CAR')
  {
    eval.parent(substitute(tmshort <- 'Carolina Panthers'))
  }
  
  if(tm == 'NYJ')
  {
    eval.parent(substitute(tmshort <- 'New York Jets'))
  }
  
  
  if(tm == 'IND')
  {
    eval.parent(substitute(tmshort <- 'Indianapolis Colts'))
  }
  
  
  if(tm == 'SF')
  {
    eval.parent(substitute(tmshort <- 'San Francisco 49ers'))
  }
  
  if(tm == 'MIA')
  {
    eval.parent(substitute(tmshort <- 'Miami Dolphins'))
  }
  
  
  if(tm == 'TB')
  {
    eval.parent(substitute(tmshort <- 'Tampa Bay Buccaneers'))
  }
  
  
  
  if(tm == 'BAL')
  {
    eval.parent(substitute(tmshort <- 'Baltimore Ravens'))
  }
  
  
  if(tm == 'GB')
  {
    eval.parent(substitute(tmshort <- 'Green Bay Packers'))
  }
  
  if(tm == 'HOU')
  {
    eval.parent(substitute(tmshort <- 'Houston Texans'))
  }
  
  
  if(tm == 'JAX')
  {
    eval.parent(substitute(tmshort <- 'Jacksonville Jaguars'))
  }
  
  if(tm == 'SEA')
  {
    eval.parent(substitute(tmshort <- 'Seattle Seahawks'))
  }
  
  
  
  if(tm == 'ATL')
  {
    eval.parent(substitute(tmshort <- 'Atlanta Falcons'))
  }
  
  
}








