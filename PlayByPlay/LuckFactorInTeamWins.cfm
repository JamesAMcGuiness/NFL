<cfquery datasource="sysstats3" name="GetLFInTeamsWins">
Select Team, Avg(LuckFactor) as aLF, Count(*) as Wins from GameInsights
where WonGame='Y' and week >= 36
Group By Team
order by Avg(LuckFactor) desc
</cfquery>	

<cfdump var ="#GetLFInTeamsWins#">	

<p>

<cfquery datasource="sysstats3" name="GetLFInTeamsLosses">
Select Team, Avg(LuckFactor) as aLF, Count(*) as Loses from GameInsights
where WonGame <> 'Y' and week >= 36
Group By Team
order by Avg(LuckFactor) 
</cfquery>	

<cfdump var ="#GetLFInTeamsLosses#">	

% of times YPP gets you the winning team - 68%
<cfquery datasource="sysstats3" name="Getit">
Select Count(*) / (Select count(*)/2 from GameInsights)
from GameInsights
where WonGame='Y' and BetterYPP = 'Y'
</cfquery>	

<cfdump var ="#Getit#">	


% of times better PAVG gets you the winning team - 74%
<cfquery datasource="sysstats3" name="Getit">
Select Count(*) / (Select count(*)/2 from GameInsights)
from GameInsights
where WonGame='Y' and BetterPavg = 'Y'
</cfquery>	

<cfdump var ="#Getit#">	


% of times better RAVG gets you the winning team - 51.7%
<cfquery datasource="sysstats3" name="Getit">
Select Count(*) / (Select count(*)/2 from GameInsights)
from GameInsights
where WonGame='Y' and BetterRavg = 'Y'
</cfquery>	

<cfdump var ="#Getit#">	




% of times better TOP gets you the winning team - 65%
<cfquery datasource="sysstats3" name="Getit">
Select Count(*) / (Select count(*)/2 from GameInsights)
from GameInsights
where WonGame='Y' and WONTOP = 'Y'
</cfquery>	

<cfdump var ="#Getit#">	


% of times better Turnover gets you the winning team - 59%
<cfquery datasource="sysstats3" name="Getit">
Select Count(*) / (Select count(*)/2 from GameInsights)
from GameInsights
where WonGame='Y' and WONTurnoverBattle = 'Y'
</cfquery>	

<cfdump var ="#Getit#">	


% of times better Sackrate gets you the winning team - 33%
<cfquery datasource="sysstats3" name="Getit">
Select Count(*) / (Select count(*)/2 from GameInsights)
from GameInsights
where WonGame='Y' and val(SackRateDif) > 0
</cfquery>	

<cfdump var ="#Getit#">	


<cfquery datasource="sysstats3" name="Getit">
Select MIN(m1.Fav) as FAV, (AVG(m1.RankDifferential) - AVG(m2.RankDifferential)) As Fav_Matchup_Advantage, MIN(m1.Und) as UND
from Matchups m1, Matchups m2
where m1.StatsFor = m1.FAV
AND m2.StatsFor = m1.UND
and m1.Week = 49 
and m1.Fav = m2.Fav
and m2.week = m1.week
Group By m1.FAV
order by 2 desc
</cfquery>	


<cfdump var ="#Getit#">	







