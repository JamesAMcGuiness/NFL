Get opponents score diff, ha and their PowerRatAdj

<cfquery datasource="Sysstats3" name="GetTeams">
Select Team
from BetterThanAVG
</cfquery>


<cfloop query="GetTeams">

	<cfset PowerVal = 0>
	<cfset GameCt   = 0>



	<cfquery datasource="sysstats3" name="GetOpps">
	Select Opp, week
	from Sysstats s
	Where Team = '#GetTeams.Team#'
	order by week
	</cfquery>

	
	<cfloop query="#GetOpps#">
		<cfset GameCt   = GameCt + 1>
		<cfquery datasource="sysstats3" name="OppStats">
			Select bta.PowerPts as PowerRatAdjAvg, (s.pswogarbage - s.dpsWoGarbage) as MOV1, (s.ps - s.dps) as MOV, s.Ha
			from Sysstats s, betterThanAvg bta
			where s.Team = '#GetTeams.Team#'   
			and s.Week = #GetOpps.Week#
			and bta.Team = '#GetOpps.opp#'
		</cfquery>

		<cfif 1 is 2>
		<cfoutput>Stats For Team: #GetTeams.Team#</cfoutput><br>
		<cfdump var="#oppStats#"><p>
		</cfif>
		
		<cfset PowerVal = PowerVal + (OppStats.PowerRatAdjAvg + OppStats.MOV)>
		<cfif oppStats.HA is 'H'>
			<cfset PowerVal = PowerVal + 1.5>
		</cfif>	
	
		<cfif 1 is 2>
		<cfoutput>
		#GetTeams.Team# power is #PowerVal#<br>
		</cfoutput>
		</cfif>
	
	</cfloop>	
	
	<cfoutput>
	#GetTeams.Team# Final power is #PowerVal/GameCt#<br>
	</cfoutput>
	<cfquery datasource="sysstats3" name="upd">
	Update betterThanAvg
	Set PowerRat2020 = #PowerVal/GameCt#
	where Team = '#GetTeams.Team#'
	</cfquery>
	
	
	
	
</cfloop>	

	<cfquery datasource="sysstats3" name="upd">
	Select Team, SUM(PowerPtsAdj + PowerPts + PowerRat2020)/3 as FinalPR
	from betterThanAvg
	Group By Team
	</cfquery>
	
	<cfloop query="Upd">
	<cfquery datasource="sysstats3" name="upd2">
	Update betterThanAvg
	Set FinalPowerRat = #UPD.FinalPR#
	where Team = '#Upd.Team#'
	</cfquery>
	</cfloop>
	
	<cfquery datasource="sysstats3" name="upd">
	Select a.Team, a.AvgOfAllPR + (a.AvgOfAllPR * (bta.RushPassBTA/100)) as adj
	from betterThanAvg bta, AvgGameInsights a, week w
	where a.Team = bta.Team
	and a.week = w.week
	</cfquery>
	
	<cfloop query="Upd">
	<cfquery datasource="sysstats3" name="upd2">
	Update betterThanAvg
	Set PowerAdjForRushPassBTA = #adj# 
	where Team = '#Upd.Team#'
	</cfquery>
	</cfloop>
	
	<cfinclude template="PowerRat2022.cfm"> 
	
	
	