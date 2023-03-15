<cfquery datasource="psp_psp" name="GetBTA">
SELECT Team, Pavg, Dpavg
FROM BetterThanAVG
</cfquery>


<cfquery datasource="psp_psp" name="GetTeams">
SELECT DISTINCT Team
FROM BetterThanAVG
</cfquery>


<cfset tmArry    = arraynew(1)>
<cfset PavgArry  = arraynew(1)>
<cfset dPavgArry = arraynew(1)>
<cfset TeamCt    = 0>

-- For each Team...
<cfloop query="GetTeams">
	<cfset TeamCt = TeamCt + 1>
	<cfset gamect   = 0>
	<cfset totPavg  = 0>
	<cfset totdPavg = 0>

	
	
	<cfquery datasource="sysstats3" name="GetData">
	SELECT Team, opp, week, pavg, dpavg
	FROM Sysstats 
	WHERE Team = '#GetTeams.Team#'
	order by week
	</cfquery>
	
	<cfif GetData.Recordcount gt 0>
		
	<cfelse>
	
		
	</cfif>
	
	
	<cfloop query="GetData">
	
		
		<cfquery dbtype="query" name="GetBTAPct">
		SELECT Pavg, Dpavg
		FROM GetBTA
		WHERE Team = '#trim(GetData.Opp)#'
		</cfquery>
				
		
		<cfset TeamPavg  = #GetData.Pavg#>
		<cfset TeamdPavg = #GetData.dPavg#>
		
				
		<cfset AdjTeamPavg  = #GetData.Pavg#>
		
		<cfif GetBTAPct.dPavg gt 0>
			<cfset AdjTeamPavg  = GetData.Pavg + ((1/GetBTAPct.Dpavg) * GetData.Pavg)>
		</cfif>
		
		<cfif GetBTAPct.dPavg lt 0>
			<cfset AdjTeamPavg  = GetData.Pavg - ((1/GetBTAPct.DPavg) * GetData.Pavg)>
		</cfif>
		
		
		<cfset AdjTeamdPavg  = GetData.dPavg>
		
		<cfif GetBTAPct.Pavg gt 0>
			<cfset AdjTeamdPavg  = GetData.dPavg - ((1/GetBTAPct.Pavg) * GetData.dPavg)>
		</cfif>
		
		<cfif GetBTAPct.Pavg lt 0>
			<cfset AdjTeamdPavg  = GetData.dPavg + ((1/GetBTAPct.Pavg) * GetData.dPavg)>
		</cfif>
		
				
		<cfset gamect = gamect + 1>
		<cfset totPavg  = totPavg   + AdjTeamPavg>
		<cfset totdPavg = totdPavg  + AdjTeamdPavg>
	
		
	
	</cfloop>
	
	
	<cfset FinalPavg  = totPavg  / gamect>
	<cfset FinaldPavg = totdPavg / gamect>
	
	
	
	<cfset tmArry[teamct]    =  '#GetTeams.Team#'>
	<cfset PavgArry[teamct]  =  FinalPavg>
	<cfset dPavgArry[teamct] =  FinaldPavg>
	
	
	
</cfloop>	
	
<cfloop index="i" From="1" To="#arraylen(tmArry)#">	
		
	
	<cfquery datasource="psp_psp" name="Updit">
	UPDATE BetterThanAVG	
		SET PavgAdjVal  = #PavgArry[i]#,
		    DPavgAdjVal = #dPavgArry[i]#,
		    PavgDiff    = #PavgArry[i] - dPavgArry[i]#
	WHERE TEAM = '#tmArry[i]#'	
	</cfquery>	
	
	
	
</cfloop>	
	
	
	
	
	
	