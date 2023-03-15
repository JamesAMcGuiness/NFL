<cfquery name="Addit" datasource="sysstats3">
Delete from PassPressure
</cfquery>

<cfquery name="GetTeams" datasource="sysstats3">
Select Distinct Team
from PlayByPlayData
where Team <> 'SD'
</cfquery>


<cfoutput query="GetTeams">

<cfset theteam = '#GetTeams.Team#'>


<cfquery name="GetPassPlays" datasource="sysstats3">
Select Yards, togo, playtype
from PlayByPlayData
Where PlayType in ('PASS','SACK','INTERCEPTION')
and( (Togo >= 5 and down = 3) or (down = 2 and togo >=10) )
and OffDef='O'
and Team = '#theteam#'
</cfquery>


<cfset TotPlays = GetPassPlays.recordcount>


<cfquery name="GetSackRate" dbtype="query">
Select count(*)/#TotPlays# as SackRate
from GetPassPlays
Where PlayType in ('SACK')
</cfquery>

<cfset s1 = 0>
<cfif GetSackRate.recordcount neq 0>
	<cfset s1 = GetSackRate.SackRate>
</cfif>

<cfquery name="GetIntRate" dbtype="query">
Select count(*)/#TotPlays# as IntRate
from GetPassPlays
Where PlayType in ('INTERCEPTION')
</cfquery>


<cfset s2 = 0>
<cfif GetIntRate.recordcount neq 0>
	<cfset s2 = GetIntRate.IntRate>
</cfif>


<cfquery name="GetIncompleteRate" dbtype="query">
Select count(*)/#TotPlays# as IncompleteRate
from GetPassPlays
Where PlayType in ('PASS')
AND Yards = 0
</cfquery>


<cfset s3 = 0>
<cfif GetIncompleteRate.recordcount neq 0>
	<cfset s3 = GetIncompleteRate.IncompleteRate>
</cfif>


<cfquery name="GetShortGainRate" dbtype="query">
Select count(*)/#TotPlays# as ShortGainRate
from GetPassPlays
Where PlayType in ('PASS')
AND Yards <= 3
</cfquery>


<cfset s4 = 0>
<cfif GetShortGainRate.recordcount neq 0>
	<cfset s4 = GetShortGainRate.ShortGainRate>
</cfif>



<cfquery name="Addit" datasource="sysstats3">
INSERT into PassPressure
(Team,
SackRate,
IntRate,
IncompleteRate,
ShortGainRate,
OffDef
)
VALUES
(
'#theteam#',
#100*s1#,
#100*s2#,
#100*s3#,
#100*s4#,
'O'
)
</cfquery>












<cfquery name="GetPassPlays" datasource="sysstats3">
Select Yards, togo, playtype
from PlayByPlayData
Where PlayType in ('PASS','SACK','INTERCEPTION')
and( (Togo >= 5 and down = 3) or (down = 2 and togo >=10) )
and OffDef='D'
and Team = '#theteam#'
</cfquery>


<cfset TotPlays = GetPassPlays.recordcount>


<cfquery name="GetSackRate" dbtype="query">
Select count(*)/#TotPlays# as SackRate
from GetPassPlays
Where PlayType in ('SACK')
</cfquery>

<cfset s1 = 0>
<cfif GetSackRate.recordcount neq 0>
	<cfset s1 = GetSackRate.SackRate>
</cfif>

<cfquery name="GetIntRate" dbtype="query">
Select count(*)/#TotPlays# as IntRate
from GetPassPlays
Where PlayType in ('INTERCEPTION')
</cfquery>


<cfset s2 = 0>
<cfif GetIntRate.recordcount neq 0>
	<cfset s2 = GetIntRate.IntRate>
</cfif>


<cfquery name="GetIncompleteRate" dbtype="query">
Select count(*)/#TotPlays# as IncompleteRate
from GetPassPlays
Where PlayType in ('PASS')
AND Yards = 0
</cfquery>


<cfset s3 = 0>
<cfif GetIncompleteRate.recordcount neq 0>
	<cfset s3 = GetIncompleteRate.IncompleteRate>
</cfif>


<cfquery name="GetShortGainRate" dbtype="query">
Select count(*)/#TotPlays# as ShortGainRate
from GetPassPlays
Where PlayType in ('PASS')
AND Yards <= 3
</cfquery>


<cfset s4 = 0>
<cfif GetShortGainRate.recordcount neq 0>
	<cfset s4 = GetShortGainRate.ShortGainRate>
</cfif>



<cfquery name="Addit" datasource="sysstats3">
INSERT into PassPressure
(Team,
SackRate,
IntRate,
IncompleteRate,
ShortGainRate,
OffDef
)
VALUES
(
'#theteam#',
#100*s1#,
#100*s2#,
#100*s3#,
#100*s4#,
'D'
)
</cfquery>





</cfoutput>














