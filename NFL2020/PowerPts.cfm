
<cfif 1 is 1>

<cfquery name="GetPowPts" datasource="Sysstats3">
SELECT Team,10 + (10*(( (PS - DPS)/100) )) as PowerPts, 10 + (10*(( (PAVG - DPAVG)/100) )) as PowerPassPts, 10 + (10*(( (PSGB - DPSGB)/100) )) as PowerPtsAdj
FROM BetterThanAvg
</cfquery>


<CFLOOP query="GetPowPts">

	<cfquery name="UpdPowPts" datasource="sysstats3">
	UPDATE BetterThanAvg
	SET PowerPts = #GetPowPts.PowerPts#,
	PowerPtsAdj = #GetPowPts.PowerPtsAdj#
	WHERE TEAM = '#GetPowPts.Team#'
	</cfquery>
	
	<cfquery name="UpdPowPts" datasource="sysstats3">
	UPDATE BetterThanAvg
	SET PowerPassPts = #GetPowPts.PowerPassPts#
	WHERE TEAM = '#GetPowPts.Team#'
	</cfquery>
	

</CFLOOP>

<cfquery name="GetTeams" datasource="sysstats3">
SELECT Distinct Team
FROM Sysstats
</cfquery>


<cfloop query="GetTeams">

	
	<cfquery name="GetOpp" datasource="sysstats3">
	SELECT Team,Opp,week,ha,ps,dps,pavg,dpavg
	FROM Sysstats
	WHERE Team = '#GetTeams.Team#'
	
	</cfquery>


	
	<cfset TotPts     = 0>
	<cfset Pts        = 0>
	<cfset PassTotPts = 0>
	<cfset PassPts    = 0>
	<cfset TotGames = GetOpp.Recordcount>
	<cfset Multiplier = 1>
	<cfset Gamect = 0>
	<cfloop query="GetOpp">
	
			<cfset Gamect = Gamect + 1>
			<cfif TotGames gt 4>
			
				<cfif Gamect > 4 
					<cfset Multiplier = Gamect/3>
				<cfelse>
					<cfset Multiplier = 1>
				</cfif>
	
			</cfif>
	
			<cfquery name="OppPowPts" datasource="sysstats3">
			SELECT PowerPts,PowerPassPts
			FROM BetterThanAvg
			WHERE TEAM = '#GetOpp.opp#'
			</cfquery>
						
			<cfif Getopp.DPS lte GetOpp.PS>
			
				<cfif GetOpp.PS - GetOpp.dPS lte 3>
					<cfset pts = OppPowPts.PowerPts + 2>
				<cfelseif GetOpp.PS - GetOpp.dPS lte 6>
					<cfset pts = OppPowPts.PowerPts + 5>
				<cfelseif GetOpp.PS - GetOpp.dPS lte 9>
					<cfset pts = OppPowPts.PowerPts + 8>
				<cfelse>
					<cfset pts = OppPowPts.PowerPts + 11>
				</cfif>
			
			<cfelse>
			
				<cfif GetOpp.dPS - GetOpp.PS lte 3>
					<cfset pts = OppPowPts.PowerPts - 2>
				<cfelseif GetOpp.dPS - GetOpp.PS lte 6>
					<cfset pts = OppPowPts.PowerPts - 5>
				<cfelseif GetOpp.dPS - GetOpp.PS lte 9>
					<cfset pts = OppPowPts.PowerPts - 8>
				<cfelse>
					<cfset pts = OppPowPts.PowerPts - 11>
				</cfif>
			
			</cfif>
	
			<cfif GetOpp.HA is 'H'>
				<cfset Pts = Pts + 3>
			</cfif>
	
			<cfset TotPts = TotPts + (Multiplier*pts)>
			 
			
			<cfset PassTotPts = PassTotPts + ((OppPowPts.PowerPassPts*Multiplier) + (GetOpp.DPAVG - GetOpp.PAVG ))>
			
				<cfoutput>
				#PassTotPts#<br>
				</cfoutput>

			
	</cfloop>
	
	
	<cfquery name="UpdPowPts" datasource="sysstats3">
		UPDATE BetterThanAvg
		SET PerformancePts = #TotPts/gamect#, PerformancePassPts = #PassTotPts/gamect#
		WHERE TEAM = '#GetTeams.Team#'
	</cfquery>


</cfloop>


<cfquery name="UpdPowPts" datasource="sysstats3">
		UPDATE BetterThanAvg
		SET PowerPts = PerformancePts
		WHERE TEAM = '#GetTeams.Team#'
</cfquery>



</cfif>

<cfquery name="GetTeams" datasource="sysstats3">
SELECT Distinct Team
FROM Sysstats
</cfquery>


<cfif 1 is 1>


<cfloop index="x" from="1" to="2">


<cfloop query="GetTeams">

	
	<cfquery name="GetOpp" datasource="sysstats3">
	SELECT Team,Opp,week,ha,ps,dps,pavg,dpavg
	FROM Sysstats
	WHERE Team = '#GetTeams.Team#'
	</cfquery>


	
	<cfset TotPts = 0>
	<cfset Pts    = 0>
	<cfset PassTotPts = 0>
	<cfset PassPts    = 0>
	
	
	<cfset Gamect = 0>
	<cfloop query="GetOpp">
	
			<cfset Gamect = Gamect + 1>
			
	
			<cfquery name="OppPowPts" datasource="sysstats3">
			SELECT PowerPts,PowerPassPts
			FROM BetterThanAvg
			WHERE TEAM = '#GetOpp.opp#'
			</cfquery>
						
			<cfset Multiplier = 1>
						
			<cfif Getopp.DPS lte GetOpp.PS>
			
				<cfif GetOpp.PS - GetOpp.dPS lte 3>
					<cfset pts = OppPowPts.PowerPts + 2>
				<cfelseif GetOpp.PS - GetOpp.dPS lte 6>
					<cfset pts = OppPowPts.PowerPts + 5>
				<cfelseif GetOpp.PS - GetOpp.dPS lte 9>
					<cfset pts = OppPowPts.PowerPts + 8>
				<cfelse>
					<cfset pts = OppPowPts.PowerPts + 11>
				</cfif>
			
			<cfelse>
			
				<cfif GetOpp.dPS - GetOpp.PS lte 3>
					<cfset pts = OppPowPts.PowerPts - 2>
				<cfelseif GetOpp.dPS - GetOpp.PS lte 6>
					<cfset pts = OppPowPts.PowerPts - 5>
				<cfelseif GetOpp.dPS - GetOpp.PS lte 9>
					<cfset pts = OppPowPts.PowerPts - 8>
				<cfelse>
					<cfset pts = OppPowPts.PowerPts - 11>
				</cfif>
			
			</cfif>
	
			<cfif GetOpp.HA is 'H'>
				<cfset Pts = Pts + 3>
			</cfif>
	
			<cfset TotPts = TotPts + (multiplier*pts)>
			 
			
			<cfset PassTotPts = PassTotPts + ((OppPowPts.PowerPassPts*Multiplier) + (GetOpp.PAVG - GetOpp.DPAVG))>
				<cfoutput>
				#PassTotPts#<br>
				</cfoutput>

			
	</cfloop>
	
	
	<cfquery name="UpdPowPts" datasource="sysstats3">
		UPDATE BetterThanAvg
		SET PerformancePts = #TotPts/gamect#, PerformancePassPts = #PassTotPts/gamect#
		WHERE TEAM = '#GetTeams.Team#'
	</cfquery>


</cfloop>

<cfquery name="UpdPowPts" datasource="sysstats3">
		UPDATE BetterThanAvg
		SET PowerPts = PerformancePts, 
		PowerPassPts = PerformancePassPts
		
</cfquery>


</cfloop>

</cfif>

<cfquery name="UpdPowPts" datasource="sysstats3">
		UPDATE BetterThanAvg
		SET PowerPtsPass = PowerPts + PowerPassPts
		
</cfquery>





