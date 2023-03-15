
<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>


<cfquery datasource="Sysstats3" name="AddPressure">
Delete from MATCHUPS
where week = #GetGames.Week#
and StatType IN ('PressureRating','PressureDifferential','OverallMatchupRating','BiggestMatchupRating','LiveDogRatAdjForOpp','LiveDogRat','FavSitRat',
'FavSitRatDiff',
'UndSitRat',
'UndSitRatDiff',
'BigAdvCategory'
)
</cfquery>


<cfloop query="GetGames">
	<cfset theweek = GetGames.Week>
	<cfset thefav = Getgames.Fav>
	<cfset theund = Getgames.Und>
	<cfset favminus = '-#GetGames.spread#'>
	<cfset Undplus = '+#GetGames.spread#'>
	
<cfquery datasource="Sysstats3" name="GetFavGIStats">
Select 	
		gi.OverratedPerformance,
		gi.UnderratedPerformance,
		gi.ConseqAboveExpCt,
		gi.ConseqBelowExpCt

From GameInsights gi
Where gi.week    = #theweek - 1#
and   gi.Team    = '#theFav#'
</cfquery>


<cfquery datasource="Sysstats3" name="GetUndGIStats">
Select 	
		gi.OverratedPerformance,
		gi.UnderratedPerformance,
		gi.ConseqAboveExpCt,
		gi.ConseqBelowExpCt

From GameInsights gi
Where gi.week    = #theweek - 1#
and   gi.Team    = '#theUnd#'
</cfquery>


<cfquery datasource="Sysstats3" name="GetFavStats">
Select 	t.Team,
		t.ConseqRdCt,
		t.OffDivGame,
		t.OffBigWin,
		t.OffBadLoss,
		t.OffExtraTravel,
		t.OffMNF,
		t.OffTNF,
		t.ExtraRest,
		t.CoastToCoast,
		t.RushPower,
		t.PassPower,
		t.ScoringPower,
		t.YppDiffAdjForOpp,

		t.SpotLevel1Play,
		t.SpotLevel2Play,
		pbp.RunSuccessRt,
		pbp.BigPlayRt,
		pbp.BadResult3rdDown,
		pbp.PlaySuccessRt,
		pbp.SackAllowedPct3rdDown,
		pbp.IntRt2ndAnd3rdDown,

		pp.OverallRat,
		bta.PowerPtsPass,
		bta.FinalPowerRat,
		bta.PowerPtsPass,
		bta.PowerPts,
		bta.PowerRat2022

From Teams t,PassPressure pp, AdjPbPGameProjections pbp, betterThanAVG bta
Where t.Team     = '#thefav#'
and   pbp.Fav    = '#thefav#'
and   pbp.week   = #theweek#
and   pp.Team    = '#theFav#'
and   pp.OffDef  = 'O'
and   bta.Team   = '#theFav#'
</cfquery>


<cfquery datasource="Sysstats3" name="GetUndStats">
Select 	
		t.team,
		t.ConseqRdCt,
		t.OffDivGame,
		t.OffBigWin,
		t.OffBadLoss,
		t.OffExtraTravel,
		t.OffMNF,
		t.OffTNF,
		t.ExtraRest,
		t.CoastToCoast,
		t.RushPower,
		t.PassPower,
		t.ScoringPower,
		t.YppDiffAdjForOpp,

		t.SpotLevel1Play,
		t.SpotLevel2Play,
		pbp.RunSuccessRt,
		pbp.BigPlayRt,
		pbp.BadResult3rdDown,
		pbp.PlaySuccessRt,
		pbp.SackAllowedPct3rdDown,
		pbp.IntRt2ndAnd3rdDown,

		pp.OverallRat,
		bta.PowerPtsPass,
		bta.FinalPowerRat,
		bta.PowerPtsPass,
		bta.PowerPts,
		bta.PowerRat2022

From Teams t,PassPressure pp, AdjPbPGameProjections pbp, betterThanAVG bta
Where t.Team     = '#theund#'
and   pp.Team    = '#theund#'
and   pbp.Fav    = '#theund#'
and   pbp.week   = #theweek#
and   pp.Team    = '#theund#'
and   pp.OffDef  = 'O'
and   bta.Team   = '#theund#'
</cfquery>


<cfquery datasource="Sysstats3" name="GetFavPressure">
Select Team,AVG(PressureRate) as aOPressureRate,AVG(dPressureRate) as adPressureRate 	
from sysstats
where Team='#thefav#' 
group by team
</cfquery>

<cfquery datasource="Sysstats3" name="GetUndPressure">
Select Team,AVG(PressureRate) as aOPressureRate,AVG(dPressureRate) as adPressureRate 	
from sysstats
where Team='#theund#' 
group by team
</cfquery>



<table width="100%" border="1">
<tr>
<td>Team</td>
<td>Power Rating</td>
<td>YPP Diff Adj</td>
<td>Off Pressure Rating</td>
<td>Def Pressure Rating</td>
<td>Projected Pressure Rating</td>
<td>Pressure Rating</td>
<td>Play Success %</td>
<td>Run Success %</td>
<td>Power Pts Pass</td>
<td>Sack Allow % 3rd Down</td>
<td>Bad Result 3rd Down %</td>
<td>Big Play %</td>
<td>Coast To Coast?</td>
<td>Conseq Rd Ct</td>
<td>Extra Rest?</td>
<td>Int % </td>
<td>Off Bad Loss?</td>
<td>Off Big Win?</td>
<td>Off DIV Game?</td>
<td>Off Extra Travel?</td>
<td>Off MNF?</td>
<td>Off TNF?</td>
<td>Pass Power</td>
<td>Rush Power</td>
<td>Scoring Power</td>
<td>Spot Level Play1</td>
<td>Spot Level Play2</td>


<td>Overrated Performance?</td>
<td>Underrated Performance?</td>
<td>Conseq Above Exp Ct</td>
<td>Conseq Below Exp Ct</td>




</tr>
<cfoutput query="GetFavStats">
<cfif GetGames.ha is 'H'>
	<cfset addit = 1.8>
<cfelse>
	<cfset addit = -1.8>
</cfif>
	
<cfset ThePred = (GetFavStats.PowerRat2022 + addit) - GetUndStats.PowerRat2022>	
	
<tr>
<td nowrap>#Team#(#GetGames.ha#)#favminus#</td>
<td>#numberformat(PowerRat2022 + addit,'99.99')#</td>
<td>#numberformat(YppDiffAdjForOpp,'99.999')#</td>
<td>#numberformat(GetFavPressure.aoPressureRate,'99.9')#</td>
<td>#numberformat(GetFavPressure.adPressureRate,'99.9')#</td>
<td>#numberformat(((GetFavPressure.aoPressureRate+GetUndPressure.adPressureRate)/2),'99.9')#</td>
<td>#numberformat(OverallRat,'9.9')#</td>
<td>#PlaySuccessRt#</td>
<td>#RunSuccessRt#</td>
<td>#numberformat(PowerPtsPass,'99.9')#</td>
<td>#SackAllowedPct3rdDown#</td>
<td>#BadResult3rdDown#</td>
<td>#BigPlayRt#</td>
<td>#CoastToCoast#</td>
<td>#ConseqRdCt#</td>
<td>#ExtraRest#</td>
<td>#IntRt2ndAnd3rdDown#</td>
<td>#OffBadLoss#</td>
<td>#OffBigWin#</td>
<td>#OffDivGame#</td>
<td>#OffExtraTravel#</td>
<td>#OffMNF#</td>
<td>#OffTNF#</td>

<td>#numberformat(PassPower,'9.99')#</td>
<td>#numberformat(RushPower,'9.99')#</td>
<td>#numberformat(ScoringPower,'9.99')#</td>
<td>#SpotLevel1Play#</td>
<td>#SpotLevel2Play#</td>

<cfset storeit = val(#numberformat(OverallRat,'9.9')#)>

<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,FavStat) values ('#TheFav#','#theund#','#thefav#',#theweek#,'PressureRating','Pressure Rating From NFLStatMatchups.cfm',#storeit#)
</cfquery>


<cfset favPRdiff = OverallRat>


<cfloop query="GetFavGIStats">
<td>#OverratedPerformance#</td>
<td>#UnderratedPerformance#</td>
<td>#ConseqAboveExpCt#</td>
<td>#ConseqBelowExpCt#</td>
</cfloop>


</tr>
</cfoutput>
<cfoutput query="GetUndStats">
<tr>
<td nowrap>#Team##undplus#</td>
<td>#numberformat(PowerRat2022,'99.99')#</td>
<td>#numberformat(YppDiffAdjForOpp,'99.999')#</td>
<td>#numberformat(GetUndPressure.aoPressureRate,'99.9')#</td>
<td>#numberformat(GetUndPressure.adPressureRate,'99.9')#</td>
<td>#numberformat(((GetUndPressure.aoPressureRate+GetFavPressure.adPressureRate)/2),'99.9')#</td>
<td>#numberformat(OverallRat,'9.9')#</td>
<td>#PlaySuccessRt#</td>
<td>#RunSuccessRt#</td>
<td>#numberformat(PowerPtsPass,'99.9')#</td>
<td>#SackAllowedPct3rdDown#</td>
<td>#BadResult3rdDown#</td>
<td>#BigPlayRt#</td>
<td>#CoastToCoast#</td>
<td>#ConseqRdCt#</td>
<td>#ExtraRest#</td>
<td>#IntRt2ndAnd3rdDown#</td>
<td>#OffBadLoss#</td>
<td>#OffBigWin#</td>
<td>#OffDivGame#</td>
<td>#OffExtraTravel#</td>
<td>#OffMNF#</td>
<td>#OffTNF#</td>
<td>#numberformat(PassPower,'9.99')#</td>
<td>#numberformat(RushPower,'9.99')#</td>
<td>#numberformat(ScoringPower,'9.99')#</td>
<td>#SpotLevel1Play#</td>
<td>#SpotLevel2Play#</td>

<cfset PowerRatDiff = GetFavStats.PowerPtsPass - GetUndStats.PowerPtsPass> 
<cfset PresuureDiff = GetFavStats.OverallRat - GetUndStats.OverallRat>
<cfset YPPDiff = GetFavStats.YppDiffAdjForOpp - GetUndStats.YppDiffAdjForOpp>
<cfset yppdiffspd = (4.3*YPPDiff)> 


<cfset storeit = val(#numberformat(OverallRat,'9.9')#)>


<cfset UndPRdiff = OverallRat>

<cfset favPRdiff = favPRdiff - UndPRdiff>
<cfset undPRdiff = -1 * favPRdiff>


	<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('PressureDifferential','PressureDifferential','#thefav#',#theweek#,#favPRdiff#)
	</cfquery>

	<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('PressureDifferential','PressureDifferential','#theund#',#theweek#,#UndPRdiff#)
	</cfquery>



<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,UndStat) values ('#TheFav#','#theund#','#theund#',#theweek#,'PressureRating','Pressure Rating From NFLStatMatchups.cfm',#storeit#)
</cfquery>

<cfloop query="GetUndGIStats">
<td>#OverratedPerformance#</td>
<td>#UnderratedPerformance#</td>
<td>#ConseqAboveExpCt#</td>
<td>#ConseqBelowExpCt#</td>
</cfloop>



</tr>
</cfoutput>

<cfoutput>
<tr>
<td nowrap>#TheFav# by #ThePred#</td>
<td></td>
<td>#yppdiffspd#</td>
<td></td>
<td></td>
<td></td>
<td></td>
</tr>
</cfoutput>
</table>

<p>

</cfloop>


<cfloop query="GetGames">

	<cfset theweek = GetGames.Week>
	<cfset thefav = Getgames.Fav>
	<cfset theund = Getgames.Und>


	<cfquery datasource="Sysstats3" name="Favstats">
	Select Min(t.team), min(t.YppDiffAdjForOpp) as YppDif, min(bta.PowerPtsPass) as PowerPointsPass, SUM(m1.RankDifferential) as RnkDiff, min(m2.FavStat) as PressRat, min(m3.FavStat) as PavDifVsSpd
	From Teams t, betterThanAVG bta, MatchUps m1, MatchUps m2, MatchUps m3
	Where t.team = '#theFav#'
	and bta.Team = '#theFav#'
	
	and m1.StatType = 'MATCHUP'
	and m1.StatsFor = '#TheFav#'
	and m1.week     = #theweek#
	
	and m2.StatType = 'PressureRating'
	and m2.StatsFor = '#TheFav#'
	and m2.week = #theweek#
	
	and m3.StatType = 'PavgDiffVsSpread'
	and m3.Fav = '#TheFav#'
	and m3.week = #theweek#
	
	
	</cfquery>

	
	

	<cfquery datasource="Sysstats3" name="Undstats">
	Select Min(t.team), min(t.YppDiffAdjForOpp) as YppDif, min(bta.PowerPtsPass) as PowerPointsPass, SUM(m1.RankDifferential) as RnkDiff, min(m2.UndStat) as PressRat, min(m3.UndStat) as PavDifVsSpd
	From Teams t, betterThanAVG bta, MatchUps m1, MatchUps m2, MatchUps m3
	Where t.team = '#theUnd#'
	and bta.Team = '#theund#'
	
	and m1.StatType = 'MATCHUP'
	and m1.StatsFor = '#TheUnd#'
	and m1.week     = #theweek#
	
	and m2.StatType = 'PressureRating'
	and m2.StatsFor = '#TheUnd#'
	and m2.week = #theweek#
	
	and m3.StatType = 'PavgDiffVsSpread'
	and m3.Fav = '#TheFav#'
	and m3.week = #theweek#
	
	
	</cfquery>

	<cfdump var="#FavStats#">
	<cfdump var="#UndStats#">

	*************************************************************************************<br>
	

</cfloop>





<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfloop query="GetGames">
	<cfset theweek = GetGames.Week>
	<cfset thefav = Getgames.Fav>
	<cfset theund = Getgames.Und>


	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Running Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Versus The Run'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Running Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Versus The Run'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>


<cfif GetFavInfo.recordcount gt 0>
<cfdump var="#GetFavInfo#">
</cfif>
<cfif GetUndInfo.recordcount gt 0>
<cfdump var="#GetUndInfo#">
</cfif>

<cfloop query="GetFavInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#thefav#',#theweek#,'BigAdvCategory','1st and 2nd Down Running',1,'#thefav#')
</cfquery>
</cfloop>

<cfloop query="GetUndInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#theund#',#theweek#,'BigAdvCategory','1st and 2nd Down Running',1,'#theund#')
</cfquery>
</cfloop>






	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Passing Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Against The Run'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Running Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Against The Run'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>


	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Passing Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Against The Pass'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Passing Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Against The Pass'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>


<cfif GetFavInfo.recordcount gt 0>
<cfdump var="#GetFavInfo#">
</cfif>
<cfif GetUndInfo.recordcount gt 0>
<cfdump var="#GetUndInfo#">
</cfif>

<cfloop query="GetFavInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#thefav#',#theweek#,'BigAdvCategory','1st and 2nd Down Passing',1,'#thefav#')
</cfquery>
</cfloop>

<cfloop query="GetUndInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#theund#',#theweek#,'BigAdvCategory','1st and 2nd Down Passing',1,'#theund#')
</cfquery>
</cfloop>





	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Passing Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Against The Pass'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 1st and 2nd Down Passing Teams'
	and r2.StatDesc='Best 1st and 2nd Down Defense Against The Pass'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>

















	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 3rd Down Passing Teams'
	and r2.StatDesc='Best 3rd Down Defense Against The Pass'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 3rd Down Passing Teams'
	and r2.StatDesc='Best 3rd Down Defense Against The Pass'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>


<cfif GetFavInfo.recordcount gt 0>
<cfdump var="#GetFavInfo#">
</cfif>
<cfif GetUndInfo.recordcount gt 0>
<cfdump var="#GetUndInfo#">
</cfif>



<cfloop query="GetFavInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#thefav#',#theweek#,'BigAdvCategory','3rd Down Passing',1,'#thefav#')
</cfquery>
</cfloop>

<cfloop query="GetUndInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#theund#',#theweek#,'BigAdvCategory','3rd Down Passing',1,'#theund#')
</cfquery>
</cfloop>





	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 3rd Down Passing Teams'
	and r2.StatDesc='Best 3rd Down Defense Against The Pass'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best 3rd Down Passing Teams'
	and r2.StatDesc='Best 3rd Down Defense Against The Pass'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>








	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best Pass Protection 3rd Down And Long'
	and r2.StatDesc='Best Pass Pressure 3rd Down And Long'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best Pass Protection 3rd Down And Long'
	and r2.StatDesc='Best Pass Pressure 3rd Down And Long'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>


<cfif GetFavInfo.recordcount gt 0>
<cfdump var="#GetFavInfo#">
</cfif>
<cfif GetUndInfo.recordcount gt 0>
<cfdump var="#GetUndInfo#">
</cfif>


<cfloop query="GetFavInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#thefav#',#theweek#,'BigAdvCategory','Pass Protection 3rd Down And Long',1,'#thefav#')
</cfquery>
</cfloop>

<cfloop query="GetUndInfo">
<cfquery datasource="Sysstats3" name="AddPressure">
INSERT INTO MATCHUPS(Fav,Und,StatsFor,Week,StatType,StatDesc,StatValue,Team) 
values ('#TheFav#','#theund#','#theund#',#theweek#,'BigAdvCategory','Pass Protection 3rd Down And Long',1,'#theund#')
</cfquery>
</cfloop>





	<cfquery datasource="sysstats3" name="GetFavInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best Pass Protection 3rd Down And Long'
	and r2.StatDesc='Best Pass Pressure 3rd Down And Long'
	And r1.OffDef='O'
	and r1.Ranking < 11
	and r2.OffDef='D'
	and r2.Ranking > 19
	and r1.Team = '#thefav#'
	and r2.Team = '#theund#'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetUndInfo">
	Select r1.Team, r2.team  
	from TeamRankings r1, TeamRankings r2 
	where r1.StatDesc='Best Pass Protection 3rd Down And Long'
	and r2.StatDesc='Best Pass Pressure 3rd Down And Long'
	And r1.OffDef='D'
	and r1.Ranking < 11
	and r2.OffDef='O'
	and r2.Ranking > 19
	and r1.Team = '#theund#'
	and r2.Team = '#thefav#'
	</cfquery>










</cfloop>

<cfinclude template="ShowMatchupRatings2021.cfm">















	