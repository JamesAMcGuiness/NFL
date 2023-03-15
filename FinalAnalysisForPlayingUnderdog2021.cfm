
<cfquery datasource="sysstats3" name="GetGames">
Select n.* 
from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<table border="1" size ="50%">

<tr>
<td><b>Category</td>
<td><b>What It Means</td>
</tr>


<tr>
<td>The LiveDogRating is greater than 5</td>
<td>This means that there are 5 or more things that I look for in an underdog that this team meets in this matchup</td>
</tr>


<tr>
<td>The LiveDogRating Adjusted For Opponent is greater than 5</td>
<td>This means that there are 5 or more things that I look for in an underdog, after adjusting the stats for the opponents they played that this team meets in this matchup</td>
</tr>

<tr>
<td>Underdog Biggest Matchup Rating is greater than the Favorite Biggest Matchup Rating.<br>
</td>
<td>This means that there is one BIG matchup advantage in the game for the underdog</td>
</tr>

<tr>
<td>The Underdog Overall Matchup Rating is greater than the Favorite Overall Matchup Rating.
</td>
<td>This means that when I compare all the matchup stats, the underdog has an overall better matchup advantage in the game.</td>
</tr>

<tr>
<td>The Underdog has a better Pressure Differential for the game.
</td>
<td>This means that I am predicting that the Underdog will enjoy a pressure advantage. Which means their QB should be under less pressure than the opponents QB.</td>
</tr>

<tr>
<td>The Underdogs situational rating is better than the favorites.
</td>
<td>I take into account a lot of situational factors (Travel/rest/off a bye/off big win etc..) This means that the situation favors the underdog.</td>
</tr>

<tr>
<td>Our Power Rating model favors the underdog with the points.
</td>
<td>My Power Rating model favors taking the points with the underdog</td>
</tr>

<tr>
<td bgcolor="Yellow">The Final Live Dog Rating
</td>
<td bgcolor="Yellow">This is simply how many of the factors listed above does the Underdog have in the matchup. 8 would be the highest. I look for 4 or more for a play</td>
</tr>
	
</table>

<p>
<p>


<cfloop query="GetGames">

<cfset thefav = '#GetGames.fav#'>
<cfset theund = '#GetGames.und#'>
<cfset theweek = '#GetGames.week#'>
<cfset thespd   = #GetGames.spread#>
<cfset theha    = '#GetGames.HA#'>

<cfquery datasource="sysstats3" name="GetFavStats">
Select distinct n.*, bta.PowerRat2022, mu.* 
from NFLSPDS n, Week w, betterthanavg bta, matchups mu
where n.week = w.week 
and (n.fav = mu.team or n.fav = mu.StatsFor)
and n.fav = '#thefav#'
and bta.Team = '#thefav#'
and mu.week = w.week
</cfquery>

<cfloop query="GetFavStats">
	<cfif StatType is 'BiggestMatchupRating'>
		<cfset FavBiggestMatchupRating = #StatValue#>
	
	<cfelseif StatType is 'OverallMatchupRating'>
		<cfset FavOverallMatchupRating = #StatValue#>
	 
	</cfif> 
</cfloop>
	
	



<cfquery datasource="sysstats3" name="GetUndStats">
Select distinct n.*, bta.PowerRat2022, mu.*, t.MatchupSummary 
from NFLSPDS n, Week w, betterthanavg bta, matchups mu, Teams t
where n.week = w.week 
and (n.und = mu.team or n.und = mu.StatsFor)
and n.und = '#theund#'
and bta.Team = '#theund#'
and mu.week = w.week
and t.Team = '#theund#'
</cfquery>


<cfoutput>
<b>Game Analysis for #theund# +#thespd# vs #thefav# </b><br>
</cfoutput>

<cfset LDct = 0>
<cfoutput query="GetUndStats">

<p>
<p>
<p>	

	
	<cfif StatType is 'LiveDogRat'>
		<cfif Statvalue gt 5>
			<cfset LDct = LDct + 1>
			<li>The LiveDogRating is greater than 5.</li>
		</cfif>

	<cfelseif StatType is 'LiveDogRatAdjForOpp'>
		<cfif Statvalue gt 5>
			<cfset LDct = LDct + 1>
			<li>The LiveDogRating Adjusted For Opponent is greater than 5.</li>
		</cfif>

	<cfelseif StatType is 'BiggestMatchupRating'>
		<cfset UndBiggestMatchupRating = #StatValue#>
		<cfset UndUndBiggestMatchupRatingDiff = UndBiggestMatchupRating - FavBiggestMatchupRating> 
		<cfif UndBiggestMatchupRating gt FavBiggestMatchupRating>
			<cfset LDct = LDct + 1>
			<li>Underdog Biggest Matchup Rating is greater than the Favorite Biggest Matchup Rating.</li>
			
		</cfif>

	<cfelseif StatType is 'OverallMatchupRating'>
		<cfset UndOverallMatchupRating = #StatValue#>
		<cfset UndOverallMatchupRatingDiff = UndOverallMatchupRating - FavOverallMatchupRating>
		<cfif UndOverallMatchupRating gt FavOverallMatchupRating>
			<li>The Underdog Overall Matchup Rating is greater than the Favorite Overall Matchup Rating.</li>
			<cfset LDct = LDct + 1>
		</cfif>



	<cfelseif StatType is 'PressureDifferential'>
		<cfif StatValue gt 0>
			<cfset LDct = LDct + 1>
			<li>The Underdog has a better Pressure Differential for the game.</li>
		</cfif>

	<cfelseif StatType is 'UndSitRatDiff'>
		<cfif StatValue gt 0>
			<cfset LDct = LDct + 1>
			<li>The Underdogs situational rating is better than the favorites.</li>
		</cfif>

	</cfif>	


	
</cfoutput>

	<cfif theha is 'H'>
		<cfset UndPR = GetUndStats.PowerRat2022 - 1.8>
	<cfelse>
		<cfset UndPR = GetUndStats.PowerRat2022 + 1.8>
	</cfif>
	
	<cfset ourspd = GetFavStats.PowerRat2022 - UndPR>
	<cfif ourspd lt #thespd#>
		<cfset LDCT = LDCT + 1>
		<li>Our Power Rating model favors the underdog with the points.</li>
	</cfif>	
	<p>
	<cfoutput>
	****************<br>
	Additional Analysis<br>
	****************<br>
	#GetUndStats.MatchupSummary#
	<div background-color:"Yellow">
	<i><b>The Final Live Dog Rating for #theund# +#thespd# is #LDCt#</b></i><br></br><br></br><br></br>
	</div>
	</cfoutput>


	
	<cfset LDct = 0>
	<p>
	<p>	
	<p>
	<p>	
	
	
<p>
<p>
	
	
</cfloop>



<cfquery datasource="sysstats3" name="FavsWithNoMatchupAdv">
Select mu.*, n.und as theplay, n.fav as thefav 
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE='BiggestMatchupRating'
and mu.StatValue = 0
and n.fav = mu.team
and mu.week = w.week
</cfquery>

*******************************************************************************<br>
<b>The following favorites do not have any big matchup advantages:</b><br>
*******************************************************************************<br>
<cfoutput query="FavsWithNoMatchupAdv">
#thefav# - so potential play on #theplay#<br>	
</cfoutput>
<p>
<p>


<cfquery datasource="sysstats3" name="BigAdvCategory">
Select mu.* , n.fav,n.und
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE='BigAdvCategory'
and (n.fav = mu.team or n.und=mu.team)
and mu.week = w.week
order by mu.Team
</cfquery>

*******************************************************************************<br>
<b>The following teams have 1 or more big matchup advantages against their opponent:</b><br>
*******************************************************************************<br>
<cfoutput query="BigAdvCategory">
#BigAdvCategory.fav# vs #BigAdvCategory.und#: #team# has a big matchup advantage on - #StatDesc#<br>	
</cfoutput>
<p>



<cfquery datasource="sysstats3" name="Situationals">
Select distinct mu.team,mu.StatValue , n.fav,n.und
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE in('FavSitRat','UndSitRat')
and (n.fav = mu.team or n.und=mu.team)
and mu.week = w.week
order by StatValue 
</cfquery>

*******************************************************************************<br>
<b>This is my situational rating for all the teams this week (negative is bad):</b><br>
*******************************************************************************<br>
<cfloop query="Situationals">
<cfoutput group="Situationals.Team">
#Situationals.Team#:  #Statvalue#<br>	
</cfoutput>
</cfloop>

<p>
*****************************************************************************************************<br>
<b>These are Favorites with a LESS favorable situation than the underdog - so potential play against:</b><br>
*****************************************************************************************************<br>
<cfquery datasource="sysstats3" name="Situationals">
Select distinct mu.team,mu.StatValue , n.fav,n.und
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE in('FavSitRatDiff')
and StatValue < 0
and (n.fav = mu.team or n.und=mu.team)
and mu.week = w.week
order by StatValue 
</cfquery>


<cfloop query="Situationals">
<cfoutput group="Situationals.Team">
#Situationals.fav# vs #Situationals.und#: #Situationals.Team#:  #Statvalue#<br>	
</cfoutput>
</cfloop>


<p>



<p>
*******************************************************************************<br>
<b>These are overall Matchup Advantages Ratings I have for each team this week:</b><br>
*******************************************************************************<br>
<cfquery datasource="sysstats3" name="OverallMatchupRating">
Select distinct mu.team,mu.StatValue , n.fav,n.und
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE in('OverallMatchupRating')
and (n.fav = mu.team or n.und=mu.team)
and mu.week = w.week
order by StatValue desc 
</cfquery>


<cfloop query="OverallMatchupRating">
<cfoutput group="OverallMatchupRating.Team">
<cfif OverallMatchupRating.Team is OverallMatchupRating.und and OverallMatchupRating.Statvalue gt 0 ><b>#OverallMatchupRating.Team# - (Upset alert)</b> <cfelse>#OverallMatchupRating.Team#</cfif>: #OverallMatchupRating.Statvalue#<br>	
</cfoutput>
</cfloop>



<p>
*******************************************************************************<br>
<b>These are my Pressure ratings, which team will likely have the QB pressure advantage:</b><br>
*******************************************************************************<br>
<cfquery datasource="sysstats3" name="PressureDifferential">
Select distinct mu.team,mu.StatValue , n.fav,n.und
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE in('PressureDifferential')
and (n.fav = mu.team or n.und=mu.team)
and mu.week = w.week
order by StatValue desc 
</cfquery>


<cfloop query="PressureDifferential">
<cfoutput group="PressureDifferential.Team">
<cfif PressureDifferential.Team is PressureDifferential.und and PressureDifferential.Statvalue gt 0 ><b>#PressureDifferential.Team# - (Upset alert)</b> <cfelse>#PressureDifferential.Team#</cfif>: #PressureDifferential.Statvalue#<br>	
</cfoutput>
</cfloop>



<p>
************************************************************************************************************************************************<br>
<b>This weeks Underdogs, and a rating for how favorable things are for them in the match up (4 or more should be highly considered.)</b><br>
*************************************************************************************************************************************************<br>
<cfquery datasource="sysstats3" name="LiveDogRatAdjForOpp">
Select distinct mu.team,mu.StatValue , n.fav,n.und,n.spread
from NFLSPDS n, Week w, matchups mu
where n.week = w.week 
and mu.STATTYPE in('LiveDogRatAdjForOpp')
and (n.fav = mu.team or n.und=mu.team)
and mu.week = w.week
order by StatValue desc 
</cfquery>


<cfloop query="LiveDogRatAdjForOpp">
<cfoutput group="LiveDogRatAdjForOpp.Team">
<cfif LiveDogRatAdjForOpp.Statvalue gt 3 ><b>#LiveDogRatAdjForOpp.Team# +#LiveDogRatAdjForOpp.spread# - (Potential play alert)</b> <cfelse>#LiveDogRatAdjForOpp.Team#</cfif>: #LiveDogRatAdjForOpp.Statvalue#<br>	
</cfoutput>
</cfloop>





