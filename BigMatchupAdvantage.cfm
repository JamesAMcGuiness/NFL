
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