<cfquery datasource="sysstats3" name="GetTeams" >
SELECT DISTINCT Team FROM betterthanavg
</cfquery>

<table border="1">
<tr>
	<td>
	TEAM
	</td>
	<td>
	SOS
	</td>
	</tr>
	
<cfoutput query="GetTeams">
	<cfquery datasource="sysstats3" name="GetSOS" >
	SELECT AVG(bta.PerformancePts) as SOS
	FROM BetterThanAvg bta
	WHERE bta.Team IN (SELECT OPP FROM GameInsights WHERE Team = '#GetTeams.Team#')
	order by AVG(bta.PerformancePts) desc
	</cfquery>

	<tr>
	<td>
	#GetTeams.Team#
	</td>
	<td>
	#GetSOS.SOS#
	</td>
	</tr>
	<cfquery datasource="sysstats3" name="UpdSOS" >
	Update Teams
	SET SOS = #GetSOS.SOS#
	WHERE Team = '#GetTeams.Team#'
	</cfquery>

	
	
</cfoutput>
</table>

