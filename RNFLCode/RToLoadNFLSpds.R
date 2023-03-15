install.packages('rvest')
install.packages('stringr')
install.packages('tidyr')

library(rvest)
library(stringr)
library(tidyr)

# Load RODBC package
library(RODBC)

# Connect to Access db
channel <- odbcConnectAccess("C:/Databases/db1.mdb")


# Get data
data <- sqlQuery( channel , paste ("select *
     from Week")
)
theweek <- data[1,"week"]
theweek = theweek + 1
#theweek = 37

delit <- sqlQuery( channel , paste ("DELETE FROM NFLSPDS WHERE Week = ",theweek,sep="")
 
)

thegametime = ""
nfltms <- ""

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



v_GAMETIME <- ""
v_Fav      <- ""
v_Und      <- ""
v_HA       <- ""
v_SPD      <- ""
v_TOT      <- ""

#url <- 'http://localhost/R/NFLodds.htm'
url <- 'http://www.donbest.com/nfl/odds/'


webpage <- read_html(url)

filename = "NFLpreads.txt"

tbls_ls <- webpage %>%
  html_nodes("table") %>%
  html_table(fill = TRUE)

# For Thursday night game will be z=1, z=2 will have the Sunday games
for(z in 1:2) {

  if (z == 1) {
    
    maxct <- 1
  } else {
    maxct <- 16
  }
  
for(j in 1:maxct) {

  # Always start at row 3
  gamect <- j + 2
  
  # Gives us game 1
  theteamsplaying <- tbls_ls[[z]][gamect,3]
  
  #Loop for 2 until the end of teams
  hometm  = ""
  for(i in 1:length(nfltms)) {

  #Loop for all the teams until we find a match for Home Team
  homepos = regexpr(nfltms[i], theteamsplaying) 
  
  if (homepos > 1) {
    hometm  = substr(theteamsplaying,homepos,100)
  }  
  }


#Loop for 2 until the end of nbateams
#  if (hometm != "") {
    awaytm  = ""
    for(k in 1:length(nfltms)) {
    
      #Loop for all the teams until we find a match for Home Team
      if(nfltms[k] != hometm) {
       
        awaypos = regexpr(nfltms[k], theteamsplaying) 
      
        if (awaypos > -1) {
          awaytm  = nfltms[k]
        }  
      }
      
    } 
    
 
  openline        <- tbls_ls[[z]][gamect,2]
  currentline     <- tbls_ls[[z]][gamect,7]
  alllines        <- tbls_ls[[z]][gamect,7:21]
  thestr <- currentline
  
  checkthis = substr(thestr,1,2)
  
  if(checkthis > '30') {
    
    checksign = substr(thestr,5,5)
    
    
    if (checksign == '-') {
      
      fav <- hometm 
      und <- awaytm  
      ha <- "H"
    }
    else {
      
      und <- hometm  
      fav <- awaytm 
      ha <- "A"
      
    }
    
    spd <- substr(thestr,6,10)
    tot <- substr(thestr,1,4) 
    
    } else {
      
      checksign = substr(thestr,1,1)
      periodfind = gregexpr("\\.", thestr)
      periodpos = periodfind[[1]][1]
      
      
      if (checksign == '-') {
        
        fav <- awaytm   
        und <-  hometm
        ha  <- "A"
      }
      else {
        
        und <- awaytm 
        fav <- hometm 
        ha <- "H"
        
      }
      
      
      if (checksign == 'P') {
        
        spd <- substr(thestr,3,periodpos+1)
        tot <- substr(thestr,periodpos+3,10) 
        
      } else {
        
        spd <- substr(thestr,2,periodpos+1)
        tot <- substr(thestr,periodpos+2,10)   
        
      }
        
      
      
      
    }
    
 
  
  tmshort <- fav
  
  
  fav <- chkTeams(tmshort)
  fav <- tmshort
  
  
  
  tmshort <- und
  und <- chkTeams(tmshort)
  und <- tmshort
 
  thegametime <- getGameTime(gamect,'N')
 
  
  v_GAMETIME <- c(v_GAMETIME,thegametime)
  v_Fav <- c(v_Fav,fav)
  v_Und <- c(v_Und,und)
  v_HA  <- c(v_HA,ha)
  v_SPD <- c(v_SPD,spd)
  v_TOT <- c(v_TOT,tot)
  
  
    
  write("--------------------------------------", file = filename,
        append = TRUE, sep = " ")
  
  write(thegametime, file = filename,
        append = TRUE, sep = " ")
  
  write(fav, file = filename,
        append = TRUE, sep = " ")
  write(ha, file = filename,
        append = TRUE, sep = " ")
  
  write(spd, file = filename,
        append = TRUE, sep = " ")
  
  write(tot, file = filename,
        append = TRUE, sep = " ")
  
  write(und, file = filename,
        append = TRUE, sep = " ")
  
}

df_Spreads <- data.frame(v_GAMETIME,v_Fav,v_HA,v_SPD,v_Und,v_TOT)

sqlSave(channel, df_Spreads, tablename = nflspds, append = TRUE)

#} else {
  
#  write("Cant find Home team", file = filename,
#        append = TRUE, sep = " ")
#  write(theteamsplaying, file = filename,
#        append = TRUE, sep = " ")
  
#}  
  
}
  
inc <- function(x)
{
  eval.parent(substitute(x <- x + 1))
}

chkTeams <- function (tmshort)
{
  
  tm<- tmshort
  
  if(tm == 'Atlanta Falcons')
  {
    eval.parent(substitute(tmshort <- 'ATL'))
  }
  
  
  if(tm == 'Seattle Seahawks')
  {
    eval.parent(substitute(tmshort <- 'SEA'))
  }
  
  
  if(tm == 'Jacksonville Jaguars')
  {
    eval.parent(substitute(tmshort <- 'JAX'))
  }
  
  
  if(tm == 'Pittsburgh Steelers')
  {
    eval.parent(substitute(tmshort <- 'PIT'))
  }
  
  
  if(tm == 'Tennessee Titans')
  {
    eval.parent(substitute(tmshort <- 'TEN'))
  }
  
  
  if(tm == 'Detroit Lions')
  {
    eval.parent(substitute(tmshort <- 'DET'))
  }
  
  
  if(tm == 'Chicago Bears')
  {
    eval.parent(substitute(tmshort <- 'CHI'))
  }
  
  
  if(tm == 'Kansas City Chiefs')
  {
    eval.parent(substitute(tmshort <- 'KC'))
  }
  
  
  if(tm == 'New York Giants')
  {
    eval.parent(substitute(tmshort <- 'NYG'))
  }
  
  
  
  if(tm == 'Cincinnati Bengals')
  {
    eval.parent(substitute(tmshort <- 'CIN'))
  }
  
  
  if(tm == 'Denver Broncos')
  {
    eval.parent(substitute(tmshort <- 'DEN'))
  }
  
  
  
  if(tm == 'Minnesota Vikings')
  {
    eval.parent(substitute(tmshort <- 'MIN'))
  }
  
  
  
  if(tm == 'Los Angeles Rams')
  {
    eval.parent(substitute(tmshort <- 'LAR'))
  }
  
  
  if(tm == 'Arizona Cardinals')
  {
    eval.parent(substitute(tmshort <- 'ARZ'))
  }
  
  
  
  if(tm == 'Cleveland Browns')
  {
    eval.parent(substitute(tmshort <- 'CLE'))
  }
  
  
  if(tm == 'Los Angeles Chargers')
  {
    eval.parent(substitute(tmshort <- 'LAC'))
  }
  
  
  
  if(tm == 'Buffalo Bills')
  {
    eval.parent(substitute(tmshort <- 'BUF'))
  }
  
  
  if(tm == 'New England Patriots')
  {
    eval.parent(substitute(tmshort <- 'NE'))
  }
  
  
  
  if(tm == 'Oakland Raiders')
  {
    eval.parent(substitute(tmshort <- 'OAK'))
  }
  
  
  
  if(tm == 'Philadelphia Eagles')
  {
    eval.parent(substitute(tmshort <- 'PHI'))
  }
  
  if(tm == 'Dallas Cowboys')
  {
    eval.parent(substitute(tmshort <- 'DAL'))
  }
  
  
  
  
  if(tm == 'New Orleans Saints')
  {
    eval.parent(substitute(tmshort <- 'NO'))
  }
  
  if(tm == 'Washington Redskins')
  {
    eval.parent(substitute(tmshort <- 'WAS'))
  }
  
  
  
  if(tm == 'Carolina Panthers')
  {
    eval.parent(substitute(tmshort <- 'CAR'))
  }
  
  if(tm == 'New York Jets')
  {
    eval.parent(substitute(tmshort <- 'NYJ'))
  }
  
  
  if(tm == 'Indianapolis Colts')
  {
    eval.parent(substitute(tmshort <- 'IND'))
  }
  
  
  if(tm == 'San Francisco 49ers')
  {
    eval.parent(substitute(tmshort <- 'SF'))
  }
  
  if(tm == 'Miami Dolphins')
  {
    eval.parent(substitute(tmshort <- 'MIA'))
  }
  
  
  if(tm == 'Tampa Bay Buccaneers')
  {
    eval.parent(substitute(tmshort <- 'TB'))
  }
  
  
  
  if(tm == 'Baltimore Ravens')
  {
    eval.parent(substitute(tmshort <- 'BAL'))
  }
  
  
  if(tm == 'Green Bay Packers')
  {
    eval.parent(substitute(tmshort <- 'GB'))
  }
  
  if(tm == 'Houston Texans')
  {
    eval.parent(substitute(tmshort <- 'HOU'))
  }
  
  
}  



getGameTime <- function (gamect,lastgameflag)
{

  #See what day we are running the spread load
  x <- Sys.Date()
  
  # Running on a wednesday... Add 4 days to make it a Sunday
  if (as.POSIXlt(x)$wday == 3) {
    x <- Sys.Date() + 4
    
    # Monday night game
    if (lastgameflag == 'Y') {
      x <- Sys.Date() + 5
    }
  }
  
  strYear <- substr(as.character(x),1,4)
  strMonth <- substr(as.character(x),6,7)
  strDay <- substr(as.character(x),9,10)
  
  strGameTime <- paste(strYear,strMonth,strDay,sep="")  
  eval.parent(substitute(thegametime <- strGameTime))
  
  #Date for Sunday if run on a Wednesday 2017-11-26
  #x <- Sys.Date() + 4
  
  #Returns 0 for Sunday
  #as.POSIXlt(x)$wday
  
  
}




data[1,"week"]

tbls_ls[[2]][3,6]
tbls_ls[[1]][2,7]

