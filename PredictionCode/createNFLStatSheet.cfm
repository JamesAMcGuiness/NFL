
<cfinclude template="createPBPSituationals.cfm">


<cfquery datasource="psp_psp" name="GetWeek">
Select week,startingweek 
from week
</cfquery>

<cfset week = GetWeek.week + 1>


<cfquery name="GetTeams" datasource="NFLSPDS">
Select Fav, Und, spread
from NFLSPDS
Where Week = #week#
</cfquery>


<table width="30%"  border="1" style="border-collapse:separate; margin:5em">
<tr>
<td bgcolor="#E9EDF0"></td>
<td bgcolor="#E9EDF0" colspan="5" align="center">Effective Running</td>
</tr>


<tr bgcolor="#E9EDF0">
<td align="center">Line</td>
<td></td>
<td align="center">Off Rating</td>
<td align="center">Def Rating</td>
<td align="center">Overall Rating</td>
<td align="center"><strong>Run Advantage</strong></td>
</tr>

<cfoutput query="GetTeams">

	<cfquery name="GetFavRunRat" datasource="psp_psp">
	Select o.AdjOverallRate as OffRate, d.AdjOverallRate as DefRate, (o.AdjOverallRate + d.adjOverallRate) as OverallRunRat
	from EffectiveRun o, EffectiveRun d 
	Where o.Team = d.Team
	and o.OffDef ='O'
	and d.OffDef ='D'
	and o.Team     = '#GetTeams.fav#'
	</cfquery>


	<cfquery name="GetUndRunRat" datasource="psp_psp">
	Select o.AdjOverallRate as OffRate, d.AdjOverallRate as DefRate, (o.AdjOverallRate + d.adjOverallRate) as OverallRunRat
	from EffectiveRun o, EffectiveRun d 
	Where o.Team = d.Team
	and o.OffDef ='O'
	and d.OffDef ='D'
	and o.Team     = '#GetTeams.und#'
	</cfquery>


	<tr>
	<td align="center">-#GetTeams.spread#</td>	
	<td align="center">#GetTeams.Fav#</td>
	<td align="center">#Numberformat(GetFavRunRat.OffRate,'999.9')#</td>
	<td align="center">#Numberformat(GetFavRunRat.DefRate,'999.9')#</td>
	<td align="center">#Numberformat(GetFavRunRat.OverallRunRat,'999.9')#</td>
	<td align="center"><cfif (GetFavRunRat.OverallRunRat - GetUndRunRat.OverallRunRat) gt 0 ><b>#Numberformat(GetFavRunRat.OverallRunRat - GetUndRunRat.OverallRunRat,'999.9')#</b></cfif></td>
	</tr>	
		
	<tr class="spaceUnder">	
	<td></td>	
	<td align="center">#GetTeams.Und#</td>
	<td align="center">#Numberformat(GetUndRunRat.OffRate,'999.9')#</td>
	<td align="center">#Numberformat(GetUndRunRat.DefRate,'999.9')#</td>
	<td align="center">#Numberformat(GetUndRunRat.OverallRunRat,'999.9')#</td>
	<cfif (GetUndRunRat.OverallRunRat - GetFavRunRat.OverallRunRat) gt 0 ><td bgcolor="Green"><b>#Numberformat(GetUndRunRat.OverallRunRat - GetFavRunRat.OverallRunRat,'999.9')#</b><cfelse><td></cfif></td>
	</tr>
	
</cfoutput>	

</table>

<p>


<table width="30%"  border="1" style="border-collapse:separate; margin:5em">
<tr>

<td bgcolor="#E9EDF0" colspan="2" align="center">Turnovers From Pressure</td>
</tr>


<tr>

<td align="center">Pressure/TO Rating</td>
<td align="center"><strong>Pressure/TO Advantage</strong></td>
</tr>

<cfoutput query="GetTeams">

 
	<cfquery name="GetFavRat" datasource="psp_psp">
	Select (4*o.SackRate + 4*o.IntRate + o.IncompleteRate) as OffRate, 
		(4*d.SackRate + 4*d.IntRate + d.IncompleteRate) as DefRate,  
		((4*d.SackRate) + (4*d.IntRate) + d.IncompleteRate) - ((4*o.SackRate) + (4*o.IntRate) + o.IncompleteRate)   as Overall


	from PassPressure o, PassPressure d 
	Where o.Team = d.Team
	and o.OffDef ='O'
	and d.OffDef ='D'
	and o.Team     = '#GetTeams.Fav#'
	</cfquery>

	<cfquery name="GetUndRat" datasource="psp_psp">
	Select (4*o.SackRate + 4*o.IntRate + o.IncompleteRate) as OffRate, 
		(4*d.SackRate + 4*d.IntRate + d.IncompleteRate) as DefRate,  
		((4*d.SackRate) + (4*d.IntRate) + d.IncompleteRate) - ((4*o.SackRate) + (4*o.IntRate) + o.IncompleteRate)   as Overall


	from PassPressure o, PassPressure d 
	Where o.Team = d.Team
	and o.OffDef ='O'
	and d.OffDef ='D'
	and o.Team     = '#GetTeams.Und#'
	</cfquery>

<!--- 
	<cfdump var="#GetFavRat#">
	<cfdump var="#GetUndRat#">
 --->


	<tr>
	<td align="center">#Numberformat(GetFavRat.Overall,'999.9')#</td>
	<td><cfif (GetFavRat.Overall - GetUndRat.Overall) gt 0><b>#Numberformat(GetFavRat.Overall - GetUndRat.Overall,'999.9')#</b></cfif></td>
	</tr>


	<tr>
	<td align="center">#Numberformat(GetUndRat.Overall,'999.9')#</td>
	<cfif GetUndRat.Overall gt GetFavRat.Overall><td bgcolor="Green"><b>#Numberformat(GetUndRat.Overall - GetFavRat.Overall,'999.9')#</b><cfelse><td></cfif></td>
	</tr>
	
</cfoutput>	

</table>







<p>


<table width="40%"  border="1" style="border-collapse:separate; margin:5em">
<tr>
<td bgcolor="#E9EDF0" colspan="5" align="center">Pass Protection And Pass Rush Pressure</td>
</tr>


<tr>
<td align="center">Failure Rate On Pass Situations</td>
<td align="center">Defensive Pressure Rate</td>
<td align="center">% Chance QB Underperforms</td>
<td align="center"><strong>QB Underperform Advantage</strong></td>
<td align="center"> QB Performance Favors</td>
</tr>

<cfoutput query="GetTeams">

	<cfset theteam = '#GetTeams.Fav#'>


	<cfquery name="GetFavRat" datasource="psp_psp">
	Select 100*o.PressureRate as OffRate, 
		100*d.PressureRate as DefRate,  
		100*d.PressureRate - o.PressureRate as Overall
	from PassPressure o, PassPressure d 
	Where o.Team = d.Team
	and o.OffDef ='O'
	and d.OffDef ='D'
	and o.Team     = '#GetTeams.Fav#'
	</cfquery>


	<cfquery name="GetUndRat" datasource="psp_psp">
	Select 100*o.PressureRate as OffRate, 
		100*d.PressureRate as DefRate,  
		100*d.PressureRate - o.PressureRate as Overall
	from PassPressure o, PassPressure d 
	Where o.Team = d.Team
	and o.OffDef ='O'
	and d.OffDef ='D'
	and o.Team     = '#GetTeams.Und#'
	</cfquery>


	<tr>
		
	<td align="center">#numberformat(GetFavRat.OffRate,'99.9')#%</td>
	<td align="center">#numberformat(GetFavRat.DefRate,'99.9')#%</td>
	<td align="center">#numberformat( (1*(GetUndRat.DefRate+GetFavRat.OffRate)/2),'99.9')#%</td>
	<td align="center"><cfif ((1*(GetFavRat.DefRate+GetUndRat.OffRate)/2)  - (1*(GetUndRat.DefRate+GetFavRat.OffRate)/2)) gt 0><strong>#numberformat( ((1*(GetFavRat.DefRate+GetUndRat.OffRate)/2)  - (1*(GetUndRat.DefRate+GetFavRat.OffRate)/2)) ,'99.9')#%</strong></cfif></td>
	<td align="center"><cfif ((1*(GetFavRat.DefRate+GetUndRat.OffRate)/2)  - (1*(GetUndRat.DefRate+GetFavRat.OffRate)/2)) gt 0>#Getteams.Fav#<cfelse></cfif></td>
	</tr>

	<tr>
		
	<td align="center">#numberformat(GetUndRat.OffRate,'99.9')#%</td>
	<td align="center">#numberformat(GetUndRat.DefRate,'99.9')#%</td>
	<td align="center">#numberformat( (1*(GetFavRat.DefRate+GetUndRat.OffRate)/2),'99.9')#%</td>
	<cfif ((1*(GetFavRat.DefRate+GetUndRat.OffRate)/2)  - (1*(GetUndRat.DefRate+GetFavRat.OffRate)/2)) lt 0 > <td bgcolor="Green"><strong>#numberformat( ((1*(GetUndRat.DefRate+GetFavRat.OffRate)/2) - (1*(GetFavRat.DefRate+GetUndRat.OffRate)/2)) ,'99.9')#%</strong><cfelse><td></cfif></td>
	<td align="center"><cfif ((1*(GetFavRat.DefRate+GetUndRat.OffRate)/2)  - (1*(GetUndRat.DefRate+GetFavRat.OffRate)/2)) lt 0>#GetTeams.Und#<cfelse></cfif></td>
	</tr>
	
</cfoutput>	

</table>






















