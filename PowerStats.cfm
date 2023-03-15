
<cfquery datasource="Sysstats3" name="Addit">
Delete from PowerStats
</cfquery>
			

<cfquery datasource="Sysstats3" name="GetTeams">
Select Team
from BetterThanAVG
</cfquery>

<cfquery datasource="sysstats3" name="GetAvgs">
Select Team, 
	AVG(Dpavg) as avgDpavg, 
	AVG(pavg) as avgpavg, 
	AVG(again) as AVGGain, 
	AVG(daGain) as avgDGain, 
	Avg(PS) as avgPS, 
	Avg(dps) as avgdps,
	Avg(ravg) as avgRavg,
	Avg(dravg) as avgdRavg,
	Avg(Sacked) as avgSacked,
	Avg(dSacked) as avgdSacked
	
	
from Sysstats
group by Team
</cfquery>

<cfloop query="GetTeams">

		-- Get all the games a team has played
		<cfquery datasource="sysstats3" name="GetStats">
		Select week, opp, pavg, dpavg , team, again, dagain, ps, dps, ravg, dravg, Sacked, dSacked 
		from sysstats
		Where Team = '#GetTeams.Team#'
		</cfquery>

		
		<cfloop query="GetStats">
		
			<cfquery dbtype="query" name="GetoppAvg">
			Select avgDpavg, avgPavg, avgGain, avgDgain, avgPS, avgDPS, avgRavg, avgdRavg, avgSacked, avgDSacked
			from GetAvgs
			Where Team = '#Trim(GetStats.opp)#'
			</cfquery>
		
			<cfquery dbtype="query" name="GetGameStats">
			Select pavg, dpavg, ps, dps, again, dagain, ravg, dravg, Sacked, dSacked
			from GetStats
			Where Opp = '#trim(GetStats.opp)#'
			and Team = '#trim(GetTeams.Team)#'
			and week = #GetStats.Week#
			</cfquery>
				
			<cfset pDiff       = GetGameStats.pavg - GetoppAvg.avgDpavg>
			<cfset pDiffDef    = GetoppAvg.avgpavg - GetGameStats.dpavg>
			
			<cfset rDiff       = GetGameStats.ravg - GetoppAvg.avgDravg>
			<cfset rDiffDef    = GetoppAvg.avgravg - GetGameStats.dravg>
			
			<cfset GainDiff    = GetGameStats.aGain - GetoppAvg.avgDGain>
			<cfset GainDiffDef = GetoppAvg.avgGain - GetGameStats.daGain>
			
			<cfset ptsDiff     = GetGameStats.PS  - GetoppAvg.avgDPS>
			<cfset ptsDiffDef  = GetoppAvg.avgps - GetGameStats.dPS>
			
			<cfset sackDiff    = GetoppAvg.avgdSacked - GetGameStats.Sacked>
			<cfset sackDiffDef = GetGameStats.Sacked - GetoppAvg.avgdSacked>
						
			<cfquery datasource="Sysstats3" name="Addit">
			INSERT INTO PowerStats(Team,opp,week,Pavg,dpavg,ps,dps,gain,dgain,ravg,dravg,Sacked,dSacked) VALUES ('#GetTeams.Team#','#GetStats.opp#',#GetStats.Week#,#pDiff#,#pDiffDef#,#ptsdiff#,#ptsDiffDef#,#GainDiff#,#GainDiffDef#,#rDiff#,#rDiffDef#,#sackDiff#,#sackDiffDef#)
			</cfquery>
			
			
		</cfloop>

</cfloop>


<p>
Rushing Power:<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, Avg(ravg) + Avg(dravg) as PassPower
from PowerStats
group by team
order by Avg(ravg) + Avg(dravg) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">

<cfquery datasource="Sysstats3" name="uGetPow">
Update Teams
Set RushPower = #GetPow.PassPower#
Where Team = '#GetPow.Team#'
</cfquery>

<tr>
<td>#Team#</td>
<td>#PassPower#</td>
</tr>
</cfoutput>			
</table>

<p>
Passing Power:<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, Avg(pavg) + Avg(dpavg) as PassPower
from PowerStats
group by team
order by Avg(pavg) + Avg(dpavg) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">

<cfquery datasource="Sysstats3" name="uGetPow">
Update Teams
Set PassPower = #GetPow.PassPower#
Where Team = '#GetPow.Team#'
</cfquery>


<tr>
<td>#Team#</td>
<td>#PassPower#</td>
</tr>
</cfoutput>			
</table>

<p>

Scoring Power:<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, Avg(ps) + Avg(dps) as Power
from PowerStats
group by team
order by Avg(ps) + Avg(dps) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">

<cfquery datasource="Sysstats3" name="uGetPow">
Update Teams
Set ScoringPower = #GetPow.Power#
Where Team = '#GetPow.Team#'
</cfquery>


<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>

Off Efficiency(Yards Per Play Adjusted For Opp):<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, Avg(gain) as Power
from PowerStats
group by team
order by Avg(gain)  desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>

Def Efficiency(Yards Per Play Adjusted For Opp):<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, Avg(dgain) as Power
from PowerStats
group by team
order by Avg(dgain) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>



<p>

Efficiency(Yards Per Play Adjusted For Opp):<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, Avg(gain) + Avg(dgain) as Power
from PowerStats
group by team
order by Avg(gain) + Avg(dgain) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">



<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>

Scoring w/ Yds per play Diff Adjusted For Opponent<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select Team, (Avg(pavg) + Avg(dpavg)) +  ((Avg(ps) + Avg(dps))) as Power
from PowerStats
group by team
order by (Avg(pavg) + Avg(dpavg)) +  ((Avg(ps) + Avg(dps))) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>


<p>

Off Efficiency(Yards Per Play Adjusted For Opp):<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select ps.Team, Avg(s.again) + Avg(ps.gain) as Power
from PowerStats ps, Sysstats s
where s.Team=ps.Team
group by ps.team
order by Avg(s.again) + Avg(ps.gain) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>


<p>

Def Efficiency(Yards Per Play Adjusted For Opp):<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select ps.Team, Avg(s.dagain) - Avg(ps.dgain) as Power
from PowerStats ps, Sysstats s
where s.Team=ps.Team
group by ps.team
order by Avg(s.dagain) - Avg(ps.dgain) 
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>

Overall YPP Efficiency(Yards Per Play Adjusted For Opp):<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select ps.Team, (Avg(s.again) + Avg(ps.gain)) - (Avg(s.dagain) - Avg(ps.dgain)) as Power
from PowerStats ps, Sysstats s
where s.Team=ps.Team
group by ps.team
order by (Avg(s.again) + Avg(ps.gain)) - (Avg(s.dagain) - Avg(ps.dgain)) desc
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">

<cfquery datasource="Sysstats3" name="uGetPow">
Update Teams
Set YppDiffAdjForOpp = #GetPow.Power#
Where Team = '#GetPow.Team#'
</cfquery>


<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>




Sack Off Efficiency:<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select ps.Team, Avg(ps.dSacked) - Avg(s.Sacked) as Power
from PowerStats ps, Sysstats s
where s.Team=ps.Team
group by ps.team
order by Avg(ps.dSacked) - Avg(s.Sacked) 
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>



Sack Def Efficiency:<br>
<cfquery datasource="Sysstats3" name="GetPow">
Select ps.Team, Avg(s.dSacked) - Avg(ps.Sacked) as Power
from PowerStats ps, Sysstats s
where s.Team=ps.Team
group by ps.team
order by Avg(s.dSacked) - Avg(ps.Sacked) 
</cfquery>
			
<table border="1">			
<cfoutput query="GetPow">
<tr>
<td>#Team#</td>
<td>#Power#</td>
</tr>
</cfoutput>			
</table>

<p>


TotalRunPassPower
<cfquery datasource="Sysstats3" name="Upd">
Update Teams
Set TotalRunPassPower = RushPower + PassPower  
</cfquery>
