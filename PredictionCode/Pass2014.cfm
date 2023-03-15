
<cfquery datasource="psp_psp" name="GetWeek">
Select (week + 1) as myweek 
from week
</cfquery>

<cfset week = GetWeek.myweek>

<cfquery datasource="#Application.dsn#"  name="GetStats">
Select Count(Pick) as TotPicks, Pick
from PspPicks
Where week = #week#
Group By Pick
order by 1 desc
</cfquery>

<cfquery datasource="nflspds"  name="GetGames">
Select * from nflspds
where week = #week#
</cfquery>

<table border="1">
<cfoutput query="GetGames">
	
	<cfquery datasource="#Application.dsn#"  name="GetFav">
	Select Avg(Pavg) as aPavg, Avg(dPavg) as adPavg  
	from AdjustedGameStats
	Where team = '#GetGames.fav#'
	and week < #week#
	</cfquery>

	<cfquery datasource="#Application.dsn#"  name="GetUnd">
	Select Avg(Pavg) as aPavg, Avg(dPavg) as adPavg  
	from AdjustedGameStats
	Where team = '#GetGames.Und#'
	and week < #week#
	</cfquery>

<tr>
<td>#GetGames.fav#</td>
<td>#GetFav.aPavg#</td>
<td>#GetFav.adPavg#</td>
<td>#GetFav.aPavg - GetFav.adPavg#</td>
</tr>
<tr>
<td>#GetGames.Und#</td>
<td>#GetUnd.aPavg#</td>
<td>#GetUnd.adPavg#</td>
<td>#GetUnd.aPavg - GetUnd.adPavg#</td>
<cfif (GetUnd.aPavg - GetUnd.adPavg) gte (GetFav.aPavg - GetFav.adPavg)>
<td>Play on #GetGames.und# at +#GetGames.spread#</td>

<cfquery datasource="psp_psp" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#week#,'UndBetterRat','#GetGames.und#')
</cfquery>

</cfif>
</tr>
</cfoutput>
</table>

<p>
<p>

<table border="1">
<cfoutput query="GetGames">
	
	<cfquery datasource="#Application.dsn#"  name="GetFav">
	Select Avg(intpct) as aPavg, Avg(dIntPct) as adPavg  
	from AdjustedGameStats
	Where team = '#GetGames.fav#'
	and week < #week#
	</cfquery>

	<cfquery datasource="#Application.dsn#"  name="GetUnd">
	Select Avg(intpct) as aPavg, Avg(dIntPct) as adPavg  
	from AdjustedGameStats
	Where team = '#GetGames.Und#'
	and week < #week#
	</cfquery>

<tr>
<td>#GetGames.fav#</td>
<td>#GetFav.aPavg#</td>
<td>#GetFav.adPavg#</td>
<td>#GetFav.adPavg - GetFav.aPavg#</td>
</tr>
<tr>
<td>#GetGames.Und#</td>
<td>#GetUnd.aPavg#</td>
<td>#GetUnd.adPavg#</td>
<td>#GetUnd.adPavg - GetUnd.aPavg#</td>
<cfif (GetUnd.adPavg - GetUnd.aPavg) gte (GetFav.adPavg - GetFav.aPavg)>
<td>Turnover Play on #GetGames.und# at +#GetGames.spread#</td>

<cfquery datasource="psp_psp" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#week#,'UndTurnover','#GetGames.und#')
</cfquery>

</cfif>
</tr>
</cfoutput>
</table>


<cfquery datasource="#Application.dsn#"  name="GetStats">
	Select Team, Avg(Pavg) - Avg(dPavg) as Rating  
	from AdjustedGameStats
	where week < #week#
	group by team
	order by 2 desc
</cfquery>

<cfoutput query="GetStats">
#Team# [#Rating#]<br>
</cfoutput>


<cfquery datasource="#Application.dsn#"  name="GetStats">
Select Count(Pick) as TotPicks, Pick
from PspPicks
Where week = #week#
Group By Pick
order by 1 desc
</cfquery>


<cfoutput query="GetSTats">
<cfquery datasource="psp_psp" name="Addit"> 
	Insert into PSPPicks (week,system,Pick,PickRat) Values(#week#,'FinalPicksRating','#GetStats.Pick#',#GetStats.TotPicks#)
</cfquery>
</cfoutput>




