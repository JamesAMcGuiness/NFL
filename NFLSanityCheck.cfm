
<cfquery datasource="psp_psp" name="GetWeek">
Select Week,startingweek FROM Week
</cfquery>

For each team make sure the 
<cfquery datasource="sysstats3" name="GetTeams">
Select Distinct Team FROM Sysstats
</cfquery>


<cfloop query="GetTeams">
<cfset Week = 0>
	<cfloop index="x" from="#startingweek#" to="#GetWeek.Week#">

		<cfset Week = Week + 1>
		*************************************************************************************<br>
		<cfoutput>
		Data check for team #GetTeams.Team# and week = #week#<br>
		</cfoutput>
		
		
		<cfquery datasource="psp_psp" name="GetNFLSpds">
		Select Fav, HA, UND FROM NFLSpds
		where Week = #Week#
		and (FAV = '#trim(GetTeams.Team)#' OR UND = '#Trim(GetTeams.Team)#')
		</cfquery>
		
		
		<cfquery datasource="sysstats3" name="GetSysStats">
		Select Team, opp, HA FROM Sysstats
		where Week = #Week#
		and Team = '#Trim(GetTeams.Team)#'
		</cfquery>
		
		<cfif GetSysStats.RecordCount gt 1>
			<cfoutput>
			Error: Dupe data in SYSSTATS for week = #week# and Team = #GetTeams.Team#<br>
			</cfoutput>
		</cfif>	
		
		<cfset NotEqual = false>
		<cfset usethis = 'H'>
		<cfif GetNFLSpds.FAV is GetSysStats.Team>
			<cfif '#trim(GetNFLSPDS.ha)#' neq '#Trim(GetSysStats.ha)#'>
				
				<cfset usethis = '#trim(GetNFLSPDS.ha)#'>
				<cfoutput>
				Error: The h/a values in SYSSTATS for week = #week# and Team = #GetTeams.Team# are not right.<br>
				</cfoutput>
				<cfset NotEqual = true>
			</cfif>
		<cfelse>
			<cfif '#trim(GetNFLSPDS.ha)#' is '#Trim(GetSysStats.ha)#'>
				<cfset usethis = 'H'>
				<cfif trim(GetNFLSPDS.ha) is 'H'>
					<cfset usethis = 'A'>
				</cfif>
				<cfoutput>
				Error: The h/a values in SYSSTATS for week = #week# and Team = #GetTeams.Team# are not right.<br>
				</cfoutput>
				<cfset NotEqual = true>
			</cfif>
		
		</cfif>
		
		<cfif NotEqual is true> 
			<cfquery datasource="psp_psp" name="Upd">
			Update Sysstats
			Set HA = '#Trim(usethis)#'
			where Week = #Week#
			and Team = '#Trim(GetTeams.Team)#'
			</cfquery>
			<cfoutput>
			Just made the Update!<br>
			</cfoutput>
			
			
		</cfif>
				
		
		<cfif GetNFLSpds.recordcount neq GetSysStats.Recordcount>
			<cfoutput>
				Error: The number of rows for NFLSpds does not match to the number of rows in SYSSTATS for week = #week# and Team = #GetTeams.Team#<br>
			</cfoutput>
		</cfif>
		*************************************************************************************<br>	
	</cfloop>
</cfloop>	