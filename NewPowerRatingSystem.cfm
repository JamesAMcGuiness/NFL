<cfquery datasource="psp_psp" name="GetTeams">
SELECT Distinct Team from BetterThanAvg
</cfquery>

<cfquery datasource="psp_psp" name="GetPowPts">
SELECT Team,PowerPts
from BetterThanAvg
</cfquery>


<cfloop query="GetTeams">
Running for team <cfoutput>'#GetTeams.Team#' </cfoutput><br>
	<cfquery datasource="sysstats3" name="Getopp">
		SELECT Team, opp, ha, ps-dps as MOV 
		from SYSSTATS
		where team = '#trim(GetTeams.Team)#'
	</cfquery>

	<cfset TotPerfPts       = 0>
	<cfset wTotPerfPts      = 0>
	
	<cfset Gamect = 0>
	
	<cfloop query="GetOpp">
		
		<cfset Gamect = GameCt + 1>
		
		<cfif GameCt lte 3>
			<cfset wght = 1>
		<cfelseif GameCt lte 6>
			<cfset wght = 1.25> 	
		<cfelseif GameCt lte 9>
			<cfset wght = 1.50>
		<cfelseif GameCt lte 12>
			<cfset wght = 1.75>
		<cfelseif GameCt lte 16>
			<cfset wght = 1.95>
		</cfif>
		
		
		<cfquery dbtype="query" Name="GetOppRat">
		SELECT PowerPts FROM GetPowPts WHERE Team = '#trim(GetOpp.Team)#'
		</cfquery>
		
		
		<cfif GetOpp.MOV gte 0 and GetOpp.MOV lte 17>
			<cfset PerfPts = GetOppRat.PowerPts + GetOpp.MOV>
			<cfset wPerfPts = (GetOppRat.PowerPts + GetOpp.MOV)*GetOpp.MOV*wght>
			
		<cfelseif GetOpp.MOV gt 17>
			<cfset PerfPts  =  ((GetOpp.MOV ) * .60) + GetOppRat.PowerPts>
			<cfset wPerfPts = (((GetOpp.MOV ) * .60) + GetOppRat.PowerPts)*GetOpp.MOV*wght>
			
		</cfif>	
		
		<cfif GetOpp.MOV lt 0>
			<cfif GetOpp.MOV lte -17>
		
				<cfif ABS(GetOpp.MOV) gt Getopprat.PowerPts>
					<cfset PerfPts  = Getopprat.PowerPts>
					<cfset wPerfPts = Getopprat.PowerPts>
				<cfelse>
					<cfset PerfPts =  GetOppRat.PowerPts - (0 + (ABS(GetOpp.MOV-0)) * .35) >
					<cfset wPerfPts = (GetOppRat.PowerPts - (0 + (ABS(GetOpp.MOV-0)) * .35))*GetOpp.MOV*wght>
				</cfif>
			
			<cfelse>
				<cfif ABS(GetOpp.MOV) gt Getopprat.PowerPts>
					<cfset PerfPts  = Getopprat.PowerPts>
					<cfset wPerfPts = Getopprat.PowerPts>
				<cfelse>
					<cfset PerfPts = GetOppRat.PowerPts + GetOpp.MOV>
					<cfset wPerfPts = GetOppRat.PowerPts + GetOpp.MOV*wght>
				</cfif>
			</cfif>	
		</cfif>
		
		<cfif Getopp.ha is 'A'>
			<cfset PerfPts = PerfPts + 2.5>
		</cfif>	
		
		<cfset TotPerfPts = TotPerfPts + PerfPts>
		
		<cfset wTotPerfPts = wTotPerfPts + wPerfPts>
		
	</cfloop>
	<cfoutput>
	<cfquery datasource="psp_psp">
	UPDATE BetterThanAvg
		SET NewPowerRat = #TotPerfPts/Gamect#
	WHERE Team = '#GetTeams.Team#' 		
	</cfquery>
	********************************************************************<p>
	The Power Rating for #GetTeams.Team# is #TotPerfPts / GameCt#<br>
	The Weighted Power Rating for #GetTeams.Team# is #wTotPerfPts / GameCt#<br>
	********************************************************************<p>
	</cfoutput>
	
</cfloop>	
	
	
	