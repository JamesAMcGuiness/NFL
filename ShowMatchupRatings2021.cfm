


<cfquery datasource="sysstats3" name="GetMatchupRat">
	Select StatsFor as Team,SUM(RankDifferential) as MatchupRating, MIN(w.week) as week
	from Matchups m, week w
	Where m.Week = w.week and Statsfor <> ''
	group by StatsFor
	order by 2 desc
</cfquery>		

<cfquery datasource="Sysstats3" name="AddPressure">
Delete from MATCHUPS
where week = #GetMatchupRat.Week#
and StatType IN ('OverallMatchupRating','BiggestMatchupRating')
</cfquery>


<cfdump var="#GetMatchupRat#">

<cfloop query="GetMatchupRat">

	<cfquery datasource="sysstats3" name="MatchupRat">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('OverallMatchupRating','OverallMatchupRating','#Team#',#week#,#MatchupRating#)
	</cfquery>

</cfloop>


<p>

<cfquery datasource="sysstats3" name="GetMatchupRat">
	Select StatsFor as Team,MAX(RankDifferential) as BiggestAdvantage, MIN(w.week) as week
	from Matchups m, week w
	Where m.Week = w.week and Statsfor <> ''
	group by Statsfor
	order by 2 desc
</cfquery>		

<cfloop query="GetMatchupRat">
	<cfquery datasource="sysstats3" name="MatchupRat2">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('BiggestMatchupRating','BiggestMatchupRating','#Team#',#week#,#BiggestAdvantage#)
	</cfquery>
</cfloop>



<cfdump var="#GetMatchupRat#">


<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfloop query="GetGames">
	<cfset theweek = GetGames.Week>
	<cfset thefav = Getgames.Fav>
	<cfset theund = Getgames.Und>
	

	<cfquery datasource="sysstats3" name="GetFav">
	Select StatValue 
	from Matchups m, week w
	Where m.Week = w.week and StatType = 'OverallMatchupRating'
	and Team = '#thefav#'
	</cfquery>		

	<cfquery datasource="sysstats3" name="GetUnd">
	Select StatValue 
	from Matchups m, week w
	Where m.Week = w.week and StatType = 'OverallMatchupRating'
	and Team = '#theund#'
	</cfquery>		

	<cfset undval = GetUnd.StatValue - GetFav.StatValue> 
	<cfset favval = -1*undval> 

	<cfquery datasource="sysstats3" name="UpdFav">
	Update Matchups
	Set StatValue = #favval# 
	Where Week = #theweek# and StatType = 'OverallMatchupRating'
	and Team = '#thefav#'
	</cfquery>		

	<cfquery datasource="sysstats3" name="updUnd">
	Update Matchups
	Set StatValue = #undval# 
	Where Week = #theweek# and StatType = 'OverallMatchupRating'
	and Team = '#theund#'
	</cfquery>		


</cfloop>




