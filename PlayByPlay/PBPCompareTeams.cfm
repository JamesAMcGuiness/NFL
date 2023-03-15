<cfquery datasource="sysstats3" name="Addit">
	DELETE FROM TeamRankings
</cfquery>



Best 1st and 2nd Down Running Teams (Off)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, AVG(Yards) as aYDS
from PlayByPlayData
Where Down in (1,2)
AND PlayType IN ('RUN')
AND OffDef = 'O'
and GarbageTime_Flag = 'N'
Group By Team
Order by AVG(Yards) desc
</cfquery>

<cfdump var="#GetInfo#">

<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'O','Best 1st and 2nd Down Running Teams',#GetInfo.aYds#)
	</cfquery>
</cfloop>



Best 1st and 2nd Down Running Teams (Def)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, AVG(Yards) as aYDS
from PlayByPlayData
Where Down in (1,2)
AND PlayType IN ('RUN')
AND OffDef = 'D'
and GarbageTime_Flag = 'N'
Group By Team
Order by AVG(Yards) asc
</cfquery>

<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'D','Best 1st and 2nd Down Defense Versus The Run',#GetInfo.aYds#)
	</cfquery>
</cfloop>





<cfdump var="#GetInfo#">

<p>

Best 1st and 2nd Down Passing Teams (Off)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, AVG(Yards) as aYDS
from PlayByPlayData
Where Down in (1,2)
AND PlayType IN ('PASS','SACK','INTERCEPTION')
AND OffDef = 'O'
and GarbageTime_Flag = 'N'
Group By Team
Order by AVG(Yards) desc
</cfquery>


<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'O','Best 1st and 2nd Down Passing Teams',#GetInfo.aYds#)
	</cfquery>
</cfloop>



<cfdump var="#GetInfo#">

<p>

Best 1st and 2nd Passing Teams (Def)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, AVG(Yards) as aYDS
from PlayByPlayData
Where Down in (1,2)
AND PlayType IN ('PASS','SACK','INTERCEPTION')
AND OffDef = 'D'
and GarbageTime_Flag = 'N'
Group By Team
Order by AVG(Yards) asc
</cfquery>

<cfdump var="#GetInfo#">

<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'D','Best 1st and 2nd Down Defense Against The Pass',#GetInfo.aYds#)
	</cfquery>
</cfloop>



<p>

Best 3rd Down Passing Teams (Off)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, AVG(Yards) / Avg(ToGo) as aYDS
from PlayByPlayData
Where Down in (3)
AND PlayType IN ('PASS','SACK','INTERCEPTION')
AND OffDef = 'O'
and GarbageTime_Flag = 'N'
Group By Team
Order by AVG(Yards) / Avg(ToGo) desc
</cfquery>

<cfdump var="#GetInfo#">


<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'O','Best 3rd Down Passing Teams',#GetInfo.aYds#)
	</cfquery>
</cfloop>



<p>

Best 3rd Down Passing Teams (Def)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, AVG(Yards) / Avg(ToGo) as aYDS
from PlayByPlayData
Where Down in (3)
AND PlayType IN ('PASS','SACK','INTERCEPTION')
AND OffDef = 'D'
and GarbageTime_Flag = 'N'
Group By Team
Order by AVG(Yards) / Avg(ToGo) asc
</cfquery>

<cfdump var="#GetInfo#">

<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'D','Best 3rd Down Defense Against The Pass',#GetInfo.aYds#)
	</cfquery>
</cfloop>

<p>

Best 3rd Down and long Pass Proctection Teams (Off)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, (Count(Id) / 1000) as aBad
from PlayByPlayData
Where Down in (3)
AND PlayType IN ('INTERCEPTION','SACK')
AND OffDef = 'O'
AND togo >= 5
and GarbageTime_Flag = 'N'
Group By Team
Order by Count(Id) / 1000 asc
</cfquery>

<cfdump var="#GetInfo#">


<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'O','Best Pass Protection 3rd Down And Long',#GetInfo.aBad#)
	</cfquery>
</cfloop>


<p>

Best 3rd Down and long Pass Proctection Teams  (Def)<p>
<cfquery datasource="sysstats3" name="GetInfo">
Select TEAM, (Count(Id) / 1000) as aBad
from PlayByPlayData
Where Down in (3)
AND PlayType IN ('INTERCEPTION','SACK')
AND OffDef = 'D'
and GarbageTime_Flag = 'N'
AND togo >= 5
Group By Team
Order by Count(Id) / 1000  desc
</cfquery>

<cfset Rank = 0>
<cfloop query="GetInfo">
	<cfset Rank = Rank + 1>
	<cfquery datasource="sysstats3" name="Addit">
	INSERT INTO TeamRankings(Team,Ranking,OffDef,StatDesc,StatVal) values('#Team#',#Rank#,'D','Best Pass Pressure 3rd Down And Long',#GetInfo.aBad#)
	</cfquery>
</cfloop>
<cfdump var="#GetInfo#">


<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfset theweek = GetGames.week>

<cfquery datasource="sysstats3" name="Addit">
	DELETE FROM MatchUps Where Week = #theweek#
</cfquery>

<cfloop query="GetGames">


<cfset thefav  = '#GetGames.Fav#'>
<cfset theund  = '#GetGames.Und#'>


<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Running Teams'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Running Teams'
and Team = '#theund#'
</cfquery>

<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>


<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Defense Versus The Run'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Defense Versus The Run'
and Team = '#theund#'
</cfquery>

<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>



<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Passing Teams'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Passing Teams'
and Team = '#theund#'
</cfquery>

<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>





<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Defense Against The Pass'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 1st and 2nd Down Defense Against The Pass'
and Team = '#theund#'
</cfquery>

<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>

</cfif>




<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 3rd Down Passing Teams'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 3rd Down Passing Teams'
and Team = '#theund#'
</cfquery>


<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>




<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 3rd Down Defense Against The Pass'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best 3rd Down Defense Against The Pass'
and Team = '#theund#'
</cfquery>


<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>




<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best Pass Protection 3rd Down And Long'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best Pass Protection 3rd Down And Long'
and Team = '#theund#'
</cfquery>

<cfif getfavinfo.recordcount gt 0 and getundinfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>



<cfquery datasource="sysstats3" name="GetFavInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best Pass Pressure 3rd Down And Long'
and Team = '#thefav#'
</cfquery>

<cfquery datasource="sysstats3" name="GetUndInfo">
Select Team, Ranking, StatVal, StatDesc
From TeamRankings
Where StatDesc = 'Best Pass Pressure 3rd Down And Long'
and Team = '#theund#'
</cfquery>

<cfif getfavinfo.recordcount gt 0 and GetUndInfo.recordcount gt 0>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (Fav,Und,Week,FavRank,UndRank,StatDesc) values('#thefav#','#theund#',#theweek#,#getfavinfo.Ranking#,#getundinfo.Ranking#,'#getundinfo.StatDesc#')
</cfquery>
</cfif>

<cfquery datasource="sysstats3" name="FavRunVsUnd">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and f.StatDesc = 'Best 1st and 2nd Down Running Teams'
and u.StatDesc = 'Best 1st and 2nd Down Defense Versus The Run'
</cfquery>

<cfquery datasource="sysstats3" name="UndRunVsFav">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and u.StatDesc = 'Best 1st and 2nd Down Running Teams'
and f.StatDesc = 'Best 1st and 2nd Down Defense Versus The Run'
</cfquery>

<cfoutput>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Offense) - 1st and 2nd Down Running</td>
	<td>#FavRunVsUnd.FavRank#</td>
	</tr>
	<tr>
	<td>#theund#</td>
	<td>(Defense) - 1st and 2nd Down Running</td>
	<td>#FavRunVsUnd.UndRank#</td>
	</tr>
</table>
<p>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#theUnd#</td>
	<td>(Offense) - 1st and 2nd Down Running</td>
	<td>#UndRunVsFav.UndRank#</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Defense) - 1st and 2nd Down Running</td>
	<td>#UndRunVsFav.FavRank#</td>
	</tr>
</table>
****************************************************************************************************************<br>
</cfoutput>







<cfquery datasource="sysstats3" name="FavPassVsUnd">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and f.StatDesc = 'Best 1st and 2nd Down Passing Teams'
and u.StatDesc = 'Best 1st and 2nd Down Defense Against The Pass'
</cfquery>

<cfquery datasource="sysstats3" name="UndPassVsFav">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and u.StatDesc = 'Best 1st and 2nd Down Passing Teams'
and f.StatDesc = 'Best 1st and 2nd Down Defense Against The Pass'
</cfquery>
<cfoutput>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Offense) - 1st and 2nd Down Passing</td>
	<td>#FavPassVsUnd.FavRank#</td>
	</tr>
	<tr>
	<td>#theund#</td>
	<td>(Defense) - 1st and 2nd Down Passing</td>
	<td>#FavPassVsUnd.UndRank#</td>
	</tr>
</table>
<p>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#theUnd#</td>
	<td>(Offense) - 1st and 2nd Down Passing</td>
	<td>#UndPassVsFav.UndRank#</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Defense) - 1st and 2nd Down Passing</td>
	<td>#UndPassVsFav.FavRank#</td>
	</tr>
</table>
****************************************************************************************************************<br>
</cfoutput>



<cfquery datasource="sysstats3" name="Fav3rdPassVsUnd">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and f.StatDesc = 'Best 3rd Down Passing Teams'
and u.StatDesc = 'Best 3rd Down Defense Against The Pass'
</cfquery>

<cfquery datasource="sysstats3" name="Und3rdPassVsFav">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and u.StatDesc = 'Best 3rd Down Passing Teams'
and f.StatDesc = 'Best 3rd Down Defense Against The Pass'
</cfquery>



<cfoutput>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Offense) - 3rd Down Passing</td>
	<td>#Fav3rdPassVsUnd.FavRank#</td>
	</tr>
	<tr>
	<td>#theund#</td>
	<td>(Defense) - 3rd Down Passing</td>
	<td>#Fav3rdPassVsUnd.UndRank#</td>
	</tr>
</table>
<p>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#theUnd#</td>
	<td>(Offense) - 3rd Down Passing</td>
	<td>#Und3rdPassVsFav.UndRank#</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Defense) - 3rd Down Passing</td>
	<td>#Und3rdPassVsFav.FavRank#</td>
	</tr>
</table>
****************************************************************************************************************<br>
</cfoutput>


<cfquery datasource="sysstats3" name="FavPassProtVsUnd">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and f.StatDesc = 'Best Pass Protection 3rd Down And Long'
and u.StatDesc = 'Best Pass Pressure 3rd Down And Long'
</cfquery>

<cfquery datasource="sysstats3" name="UndPassProtVsFav">
Select f.FavRank, u.UndRank
from MatchUps f, MatchUps u 
Where f.Fav = '#TheFav#'
and u.Und = '#TheUnd#'
and u.StatDesc = 'Best Pass Protection 3rd Down And Long'
and f.StatDesc = 'Best Pass Pressure 3rd Down And Long'
</cfquery>


<cfoutput>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Offense) - Pass Protection 3rd Down And Long</td>
	<td>#FavPassProtVsUnd.FavRank#</td>
	</tr>
	<tr>
	<td>#theund#</td>
	<td>(Defense) - Pass Protection 3rd Down And Long</td>
	<td>#FavPassProtVsUnd.UndRank#</td>
	</tr>
</table>
<p>
<table border="1">
	<tr>
	<td>Team</td>
	<td>Stat</td>
	<td>Rank</td>
	</tr>
	<tr>
	<td>#theUnd#</td>
	<td>(Offense) - Pass Protection 3rd Down And Long</td>
	<td>#UndPassProtVsFav.UndRank#</td>
	</tr>
	<tr>
	<td>#thefav#</td>
	<td>(Defense) - Pass Protection 3rd Down And Long</td>
	<td>#UndPassProtVsFav.FavRank#</td>
	</tr>
</table>
****************************************************************************************************************<br>
</cfoutput>


Best 1st and 2nd Down Running Teams
#FavRunVsUnd.FavRank#
#FavRunVsUnd.UndRank#

<cfif FavRunVsUnd.FavRank gt '' and FavRunVsUnd.UndRank gt ''>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Fav,Und,Week,FavRank,UndRank,StatDesc) values('MATCHUP','#thefav#','#thefav#','#theund#',#theweek#,#FavRunVsUnd.FavRank#,#FavRunVsUnd.UndRank#,'Best 1st and 2nd Down Running Teams')
</cfquery>
</cfif>


Best 1st and 2nd Down Passing Teams
#FavPassVsUnd.FavRank#
#FavPassVsUnd.UndRank#

<cfif FavPassVsUnd.FavRank gt '' and FavPassVsUnd.UndRank gt ''>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Fav,Und,Week,FavRank,UndRank,StatDesc) values('MATCHUP','#thefav#','#thefav#','#theund#',#theweek#,#FavPassVsUnd.FavRank#,#FavPassVsUnd.UndRank#,'Best 1st and 2nd Down Passing Teams')
</cfquery>
</cfif>


Best 3rd Down Passing Teams
#Fav3rdPassVsUnd.FavRank#
#Fav3rdPassVsUnd.UndRank#

<cfif Fav3rdPassVsUnd.FavRank gt '' and Fav3rdPassVsUnd.UndRank gt ''>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Fav,Und,Week,FavRank,UndRank,StatDesc) values('MATCHUP','#thefav#','#thefav#','#theund#',#theweek#,#Fav3rdPassVsUnd.FavRank#,#Fav3rdPassVsUnd.UndRank#,'Best 3rd Down Passing Teams')
</cfquery>
</cfif>



Best Pass Protection 3rd Down And Long
#FavPassProtVsUnd.FavRank#
#FavPassProtVsUnd.UndRank#

<cfif FavPassProtVsUnd.FavRank gt '' and FavPassProtVsUnd.UndRank gt ''>
<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Fav,Und,Week,FavRank,UndRank,StatDesc) values('MATCHUP','#thefav#','#thefav#','#theund#',#theweek#,#FavPassProtVsUnd.FavRank#,#FavPassProtVsUnd.UndRank#,'Best Pass Protection 3rd Down And Long')
</cfquery>
</cfif>


Best 1st and 2nd Down Running Teams
#FavRunVsUnd.FavRank#
#FavRunVsUnd.UndRank#


<cfif UndRunVsFav.UndRank gt '' and UndRunVsFav.FavRank gt ''>

<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Und,Fav,Week,UndRank,FavRank,StatDesc) values('MATCHUP','#theund#','#theund#','#thefav#',#theweek#,#UndRunVsFav.UndRank#,#UndRunVsFav.FavRank#,'Best 1st and 2nd Down Running Teams')
</cfquery>

</cfif>



<cfif UndPassVsFav.UndRank gt '' and UndPassVsFav.FavRank gt ''>

<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Und,Fav,Week,UndRank,FavRank,StatDesc) values('MATCHUP','#theund#','#theund#','#thefav#',#theweek#,#UndPassVsFav.UndRank#,#UndPassVsFav.FavRank#,'Best 1st and 2nd Down Passing Teams')
</cfquery>

</cfif>

<cfif Und3rdPassVsFav.UndRank gt '' and Und3rdPassVsFav.FavRank gt ''>

<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Und,Fav,Week,UndRank,FavRank,StatDesc) values('MATCHUP','#theund#','#theund#','#thefav#',#theweek#,#Und3rdPassVsFav.UndRank#,#Und3rdPassVsFav.FavRank#,'Best 3rd Down Passing Teams')
</cfquery>

</cfif>


<cfif UndPassProtVsFav.UndRank gt '' and UndPassProtVsFav.FavRank gt ''>


<cfquery datasource="sysstats3" name="Addit">
INSERT INTO MatchUps (StatType,StatsFor,Und,Fav,Week,UndRank,FavRank,StatDesc) values('MATCHUP','#theund#','#theund#','#thefav#',#theweek#,#UndPassProtVsFav.UndRank#,#UndPassProtVsFav.FavRank#,'Best Pass Protection 3rd Down And Long')
</cfquery>
</cfif>

</cfloop>

<cfquery datasource="sysstats3" name="Addit">
Update MatchUps 
SET RankDifferential = UndRank - FavRank
where Fav = StatsFor
</cfquery>

<cfquery datasource="sysstats3" name="Addit">
Update MatchUps 
SET RankDifferential = FavRank - UndRank
where Und = StatsFor
</cfquery>


