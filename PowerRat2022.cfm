<cfquery datasource="sysstats3" name="GetTeams">
Select bta.FinalPowerRat, bta.Team
from betterThanAvg bta 
</cfquery>	


<cfloop query="#GetTeams#">

	--Get Opp of team and MOV
	<cfquery datasource="sysstats3" name="GetGameStats">
	Select s.opp, s.PS - s.DPS as MOV, bta.FinalPowerRat
	from Sysstats s, betterThanAvg bta 
	where s.Team = '#GetTeams.Team#'
	and bta.Team = s.opp
	</cfquery>	


	-- Now take MOV and add it to the opp's Power Rating
	<cfset PR = 0>
	<cfset Gamect = 0>
	<cfloop query="#GetGameStats#">
		<cfset pr = pr + (GetGameStats.mov + GetGameStats.FinalPowerRat)>
		<cfset Gamect = Gamect + 1>
	
	</cfloop>
	<cfset FinalPR = pr/Gamect>
	<cfoutput>
	Final PR for #GetTeams.Team# is #FinalPR#<br> 

	<cfquery datasource="sysstats3" name="Upd">
	Update betterThanAvg
	Set PR2022 = #FinalPR# 
	where Team = '#GetTeams.Team#'
	</cfquery>	

	</cfoutput>
	
</cfloop>	

<cfquery datasource="sysstats3" name="upd">
Select (((((PowerRat2022+PR2022)/2)  - 12.33)) / 12.33)*10 as PR, Team
from betterThanAvg
</cfquery>

<CFLOOP query="upd">
	<cfquery datasource="sysstats3" name="Upd2">
	Update betterThanAvg
	Set PRUltimate = #PR# 
	where Team = '#upd.Team#'
	</cfquery>	
</cfloop>



<cfif 1 is 2>
<cfloop query="#GetTeams#">

	--Get Opp of team and MOV
	<cfquery datasource="sysstats3" name="GetGameStats">
	Select s.opp, s.PS - s.DPS as MOV, bta.PR2022
	from Sysstats s, betterThanAvg bta 
	where s.Team = '#GetTeams.Team#'
	and bta.Team = s.opp
	</cfquery>	


	-- Now take MOV and add it to the opp's Power Rating
	<cfset PR = 0>
	<cfset Gamect = 0>
	<cfloop query="#GetGameStats#">
		<cfset pr = pr + (GetGameStats.mov + GetGameStats.PR2022)>
		<cfset Gamect = Gamect + 1>
	
	</cfloop>
	<cfset FinalPR = pr/Gamect>
	<cfoutput>
	Final PR for #GetTeams.Team# is #FinalPR#<br> 

	<cfquery datasource="sysstats3" name="Upd">
	Update betterThanAvg
	Set PR2022 = #FinalPR# 
	where Team = '#GetTeams.Team#'
	</cfquery>	

	</cfoutput>
	
</cfloop>	
</cfif>