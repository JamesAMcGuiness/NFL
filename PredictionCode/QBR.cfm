
<cfquery datasource="psp_psp" name="GetQBR">
Select o.Team, Avg(o.PassRating) as oQBR, Avg(d.PassRating) as dQBR
FROM LineRating o, LineRating d
Where o.Team = d.Team
and o.week = d.week
and o.OffDef='O'
and d.OffDef='D'
Group by o.Team
order by 2 desc
</cfquery>

<table border="1" width="25%">
<cfoutput query="GetQBR">
<tr>
<td>
#GetQBR.Team#
</td>

<td>
#GetQBR.oQBR#
</td>

</tr>

</cfoutput>
</table>


<cfquery datasource="psp_psp" name="GetQBR">
Select o.Team, Avg(o.PassRating) as oQBR, Avg(d.PassRating) as dQBR
FROM LineRating o, LineRating d
Where o.Team = d.Team
and o.week = d.week
and o.OffDef='O'
and d.OffDef='D'
Group by o.Team
order by 3 
</cfquery>

<p>

<table border="1" width="25%">
<cfoutput query="GetQBR">
<tr>
<td>
#GetQBR.Team#
</td>

<td>
#GetQBR.dQBR#
</td>

</tr>

</cfoutput>
</table>

<p>


<cfquery datasource="psp_psp" name="GetQBR">
Select o.Team, Avg(o.PassRating) - Avg(d.PassRating) as QBR
FROM LineRating o, LineRating d
Where o.Team = d.Team
and o.week = d.week
and o.OffDef='O'
and d.OffDef='D'
Group by o.Team
order by 2 desc 
</cfquery>

<p>

<table border="1" width="25%">
<cfoutput query="GetQBR">
<tr>
<td>
#GetQBR.Team#
</td>

<td>
#GetQBR.QBR#
</td>

</tr>

</cfoutput>
</table>

<cfquery datasource="psp_psp" name="GetWeek">
Select week 
from week
</cfquery>

<cfset week = GetWeek.week + 1>

<cfquery datasource="psp_psp" name="Addit"> 
	delete from PSPPicks where system='LINEOFSCRIMMAGE' and week = #week#
</cfquery>



<p>
<p>

<cfquery datasource="psp_psp" name="Getgames">
Select *
from nflspds
where week = #week#
</cfquery>


<table width="50%">
<tr>
	<td colspan="2" align="center">
	Chart Explained	
	</td>

</tr>

<tr>
<td>
The QBR Differential is the difference in how well a team's QB performs versus how well the
the team defends the opposing QB. In theory it should give us a better idea of what team may
win the passing game battle.
</td>
</tr>

<tr>
<td>
So it is BOTH a QB stat as well as a team defensive passing stat combined into one.
</td>
</tr>
</table>
<p>
</p>
<cfoutput query="GetGames">


<cfquery datasource="psp_psp" name="GetFavQBR">
Select o.Team, Avg(o.PassRating) - Avg(d.PassRating) as QBR
FROM LineRating o, LineRating d
Where o.Team = d.Team
and o.week = d.week
and o.OffDef='O'
and d.OffDef='D'
and o.Team = '#GetGames.Fav#'
Group by o.Team
order by 2 desc 
</cfquery>

<cfquery datasource="psp_psp" name="GetUndQBR">
Select o.Team, Avg(o.PassRating) - Avg(d.PassRating) as QBR
FROM LineRating o, LineRating d
Where o.Team = d.Team
and o.week = d.week
and o.OffDef='O'
and d.OffDef='D'
and o.Team = '#GetGames.Und#'
Group by o.Team
order by 2 desc 
</cfquery>



<table border="1" width="45%">

<tr bgcolor="aqua">
<td>
Team
</td>

<td>
QBR Differential Rating
</td>
</tr>


<tr>
<td>
#GetFAVQBR.Team#
</td>

<td>
#GetFAVQBR.QBR#
</td>
</tr>

<tr>
<td>
#GetUNDQBR.Team#
</td>

<td>
#GetUNDQBR.QBR#
</td>


<cfif GetFAVQBR.QBR gt GetUNDQBR.QBR >
	<cfset myQBRPick = GetFAVQBR.Team>
	<cfset myQBRat   = Numberformat(GetFAVQBR.QBR - GetUNDQBR.QBR,'99.9')>
<cfelse>	
	<cfset myQBRPick = '**' & '#GetUndQBR.Team#'>
	<cfset myQBRat   = Numberformat(GetUNDQBR.QBR - GetFAVQBR.QBR,'99.9')>
</cfif>

<cfset myPick = '#myQBRPick#' & ' - ' & '#myQBrat#'>
 
<cfif myQBRat is 0>
	<cfset myPick = 'EVEN'>
</cfif>

<tr>
<td>
Advantage: #myQBRPick# with a rating of #myQBRat#
</td>
</tr>

</tr>

</table>
<p>


<cfquery datasource="psp_psp" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#week#,'QBR','#myPick#')
</cfquery>
</cfoutput>

<p>
</p>

<hr>

<table width="45%" cellpadding="4" border="1">
<tr bgcolor="aqua">
	<td colspan="2" align="center">
	<cfoutput>	
	<b>Week #week# Play By Play Line Of Scrimmage Ratings - Chart Explained</b>
	</cfoutput>	
	</td>

</tr>

<tr>
<td>
This chart will show a teams overall Line Of Scrimmage rating. It is a combined offensive and
defensive statistic of how well teams perform in the trenches.
In theory it should give us a better idea of what team may win the line of scrimmage battle.
</td>
</tr>

<tr>
<td>
It is used to <strong>see which Underdogs may be stronger in the trenches (See green highlighted)</strong>.
</td>
</tr>


<p>
</p>

<cfif 1 is 2>
<cfoutput query="GetGames">

<cfquery datasource="psp_psp" name="GetFavLOS">
Select Team, Overall as LOSRat
FROM LineOfScrimmage los
Where OffDef='OVERALL'
and los.Team = '#GetGames.Fav#'
and week = #week#
</cfquery>

<cfquery datasource="psp_psp" name="GetUndLOS">
Select Team, Overall as LOSRat
FROM LineOfScrimmage los
Where OffDef='OVERALL'
and los.Team = '#GetGames.Und#'
and week = #week#
</cfquery>

<table border="1" width="45%">

<tr bgcolor="aqua">
<td>
Team
</td>

<td>
Line Of Scrimmage Rating
</td>
</tr>


<tr>
<td>
#GetFAVLOS.Team#
</td>

<td>
#GetFAVLOS.LosRat#
</td>
</tr>

<tr>
<td>
#GetUNDLos.Team#
</td>

<td>
#GetUNDLos.LosRat#
</td>

</tr>


<cfset bgcolor = ''>
<cfif GetFAVLos.LosRat gt GetUNDLos.LosRat >
	<cfset myLOSPick = GetFAVLos.Team>
	<cfset myLOSRat   = Numberformat(GetFAVLos.LosRat - GetUNDLos.LosRat,'99.9')>
<cfelse>	
	<cfset bgcolor = 'Green'>
	<cfset myLosPick = '**' & '#GetUndLos.Team#'>
	<cfset myLosRat   = Numberformat(GetUNDLos.LosRat - GetFAVLos.LosRat,'99.9')>
</cfif>

<cfset myPick = '#myLosPick#' & ' - ' & '#myLosrat#'>
<cfif mylosrat is 0>
	<cfset myPick = 'EVEN'>
</cfif> 

<tr bgcolor="#bgcolor#">
<td>
<strong>Advantage: #myLosPick# with a rating of #myLosRat#</strong>
</td>

<td>
</td>

</tr>


</table>
<p>


<cfquery datasource="psp_psp" name="Addit"> 
	Insert into PSPPicks (week,system,Pick) Values(#week#,'LINEOFSCRIMMAGE','#myPick#')
</cfquery>


</cfoutput>



<table width="45%" cellpadding="4" border="1">
<tr bgcolor="Aqua">
	<td colspan="2" align="center">
	<cfoutput>	
	<strong>Week #week# QBR Rating System - Chart Explained</strong>
	</cfoutput>	
	</td>
</tr>

<tr>
<td>
The QBR Rating is how well we think the QB will perform in this matchup.
A rating of 100 or more is considered very good, below 90 they are likely
to struggle.
</td>
</tr>
<tr>
<td>
<strong>We will look for Underdogs where their QB rating may be better than the favorites.</strong>
</td>
</tr>


</table>	
<p>

<cfoutput query="GetGames">
	
<cfquery datasource="psp_psp" name="GetFavPredQBR">
Select o.Team, (Avg(o.PassRating) + Avg(d.PassRating))/2 as FavQBRPred
FROM LineRating o, LineRating d
Where o.Team = '#GetGames.fav#'
and d.team = '#GetGames.und#'
and o.OffDef='O'
and d.OffDef='D'
Group by o.Team
order by 2 desc 
</cfquery>

<cfquery datasource="psp_psp" name="GetUndPredQBR">
Select o.Team, (Avg(o.PassRating) + Avg(d.PassRating))/2 as UndQBRPred
FROM LineRating o, LineRating d
Where  o.OffDef='O'
and d.OffDef='D'
and o.Team = '#GetGames.Und#'
and d.team = '#GetGames.fav#'
Group by o.Team
order by 2 desc 
</cfquery>	


<table border="1" width="25%">
<tr>
<td>
#GetFAVPredQBR.Team#
</td>

<td>
#GetFAVPredQBR.FavQBRPred#
</td>
</tr>

<tr>
<td>
#GetUNDPredQBR.Team#
</td>

<td>
#GetUNDPredQBR.UndQBRPred#
</td>

</tr>


<cfset bgcolor = ''>
<cfif GetFAVPredQBR.FavQBRPred gt GetUNDPredQBR.UndQBRPred >
	<cfset myQBPick = GetFAVPredQBR.Team>
	<cfset myQBRat   = Numberformat(GetFAVPredQBR.FavQBRPred - GetUNDPredQBR.UndQBRPred,'99.9')>
<cfelse>	
	<cfset myQBPick = '**' & '#GetUndPredQBR.Team#'>
	<cfset myQBRat   = Numberformat(GetUNDPredQBR.UndQBRPred - GetFAVPredQBR.FAVQBRPred,'99.9')>
	<cfset bgcolor = 'Green'>
</cfif>

<cfset myPick = '#myLosPick#' & ' - ' & '#myLosrat#'>
<cfif GetFAVPredQBR.FavQBRPred - GetUNDPredQBR.UNDQBRPred is 0>
	<cfset myQBPick = 'EVEN'>
</cfif> 


<tr bgcolor="#bgcolor#">
<td>
<strong>Advantage: #myQBPick# with a rating of #myQBRat#</strong>
</td>

<td>
</td>

</tr>


</table>
<p>




</cfoutput>

</cfif>
