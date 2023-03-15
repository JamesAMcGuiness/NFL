<cfquery name="Addit" datasource="sysstats3">
Delete from PASSPressure
</cfquery>

<cfquery name="GetTeams" datasource="sysstats3">
Select Distinct Team
from PlayByPlayData
where Team <> 'SD'
</cfquery>


<cfoutput query="GetTeams">

<cfset theteam = '#GetTeams.Team#'>


<cfquery name="GetPASSPlays" datasource="sysstats3">
Select Yards, togo, playtype
from PlayByPlayData
Where PlayType in ('PASS','SACK','INTERCEPTION')
and OffDef='O'
and Team = '#theteam#'

</cfquery>


<cfset TotPlays = GetPASSPlays.recordcount>


<cfquery name="GetSACKRate" dbtype="query">
Select count(*)/#TotPlays# as SACKRate
from GetPASSPlays
Where PlayType in ('SACK')
</cfquery>

<cfset s1 = 0>
<cfif GetSACKRate.recordcount neq 0>
	<cfset s1 = GetSACKRate.SACKRate>
</cfif>

<cfquery name="GetIntRate" dbtype="query">
Select count(*)/#TotPlays# as IntRate
from GetPASSPlays
Where PlayType in ('INTERCEPTION')
</cfquery>


<cfset s2 = 0>
<cfif GetIntRate.recordcount neq 0>
	<cfset s2 = GetIntRate.IntRate>
</cfif>


<cfquery name="GetIncompleteRate" dbtype="query">
Select count(*)/#TotPlays# as IncompleteRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards = 0
</cfquery>


<cfset s3 = 0>
<cfif GetIncompleteRate.recordcount neq 0>
	<cfset s3 = GetIncompleteRate.IncompleteRate>
</cfif>


<cfquery name="GetShortGainRate" dbtype="query">
Select count(*)/#TotPlays# as ShortGainRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards <= 3
</cfquery>


<cfset s4 = 0>
<cfif GetShortGainRate.recordcount neq 0>
	<cfset s4 = GetShortGainRate.ShortGainRate>
</cfif>



<cfquery name="Addit" datasource="sysstats3">
INSERT into PASSPressure
(Team,
SACKRate,
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












<cfquery name="GetPASSPlays" datasource="sysstats3">
Select Yards, togo, playtype
from PlayByPlayData
Where PlayType in ('PASS','SACK','INTERCEPTION')
and OffDef='D'
and Team = '#theteam#'
</cfquery>


<cfset TotPlays = GetPASSPlays.recordcount>


<cfquery name="GetSACKRate" dbtype="query">
Select count(*)/#TotPlays# as SACKRate
from GetPASSPlays
Where PlayType in ('SACK')
</cfquery>

<cfset s1 = 0>
<cfif GetSACKRate.recordcount neq 0>
	<cfset s1 = GetSACKRate.SACKRate>
</cfif>

<cfquery name="GetIntRate" dbtype="query">
Select count(*)/#TotPlays# as IntRate
from GetPASSPlays
Where PlayType in ('INTERCEPTION')
</cfquery>


<cfset s2 = 0>
<cfif GetIntRate.recordcount neq 0>
	<cfset s2 = GetIntRate.IntRate>
</cfif>


<cfquery name="GetIncompleteRate" dbtype="query">
Select count(*)/#TotPlays# as IncompleteRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards = 0
</cfquery>


<cfset s3 = 0>
<cfif GetIncompleteRate.recordcount neq 0>
	<cfset s3 = GetIncompleteRate.IncompleteRate>
</cfif>


<cfquery name="GetShortGainRate" dbtype="query">
Select count(*)/#TotPlays# as ShortGainRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards <= 3
</cfquery>


<cfset s4 = 0>
<cfif GetShortGainRate.recordcount neq 0>
	<cfset s4 = GetShortGainRate.ShortGainRate>
</cfif>



<cfquery name="Addit" datasource="sysstats3">
INSERT into PASSPressure
(Team,
SACKRate,
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














<cfoutput query="GetTeams">

<cfset theteam = '#GetTeams.Team#'>


<cfquery name="GetPASSPlays" datasource="sysstats3">
Select Yards, togo, playtype
from PlayByPlayData
Where PlayType in ('PASS','SACK','INTERCEPTION')
and OffDef='O'
and Redzone_Flag = 'Y'
and Team = '#theteam#'

</cfquery>


<cfset TotPlays = GetPASSPlays.recordcount>


<cfquery name="GetSACKRate" dbtype="query">
Select count(*)/#TotPlays# as SACKRate
from GetPASSPlays
Where PlayType in ('SACK')
</cfquery>

<cfset s1 = 0>
<cfif GetSACKRate.recordcount neq 0>
	<cfset s1 = GetSACKRate.SACKRate>
</cfif>

<cfquery name="GetIntRate" dbtype="query">
Select count(*)/#TotPlays# as IntRate
from GetPASSPlays
Where PlayType in ('INTERCEPTION')
</cfquery>


<cfset s2 = 0>
<cfif GetIntRate.recordcount neq 0>
	<cfset s2 = GetIntRate.IntRate>
</cfif>


<cfquery name="GetIncompleteRate" dbtype="query">
Select count(*)/#TotPlays# as IncompleteRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards = 0
</cfquery>


<cfset s3 = 0>
<cfif GetIncompleteRate.recordcount neq 0>
	<cfset s3 = GetIncompleteRate.IncompleteRate>
</cfif>


<cfquery name="GetShortGainRate" dbtype="query">
Select count(*)/#TotPlays# as ShortGainRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards <= 3
</cfquery>


<cfset s4 = 0>
<cfif GetShortGainRate.recordcount neq 0>
	<cfset s4 = GetShortGainRate.ShortGainRate>
</cfif>


<cfquery name="Addit" datasource="sysstats3">
UPDATE PASSPressure
SET RZSACKRate=#100*s1#,
	RZIntRate=#100*s2#,
	RZIncompleteRate=#100*s3#,
	RZShortGainRate=#100*s4#
Where OffDef='O'
AND Team = '#theteam#'
</cfquery>




<cfquery name="GetPASSPlays" datasource="sysstats3">
Select Yards, togo, playtype
from PlayByPlayData
Where PlayType in ('PASS','SACK','INTERCEPTION')
and OffDef='D'
and Team = '#theteam#'
and Redzone_Flag = 'Y'
</cfquery>


<cfset TotPlays = GetPASSPlays.recordcount>


<cfquery name="GetSACKRate" dbtype="query">
Select count(*)/#TotPlays# as SACKRate
from GetPASSPlays
Where PlayType in ('SACK')
</cfquery>

<cfset s1 = 0>
<cfif GetSACKRate.recordcount neq 0>
	<cfset s1 = GetSACKRate.SACKRate>
</cfif>

<cfquery name="GetIntRate" dbtype="query">
Select count(*)/#TotPlays# as IntRate
from GetPASSPlays
Where PlayType in ('INTERCEPTION')
</cfquery>


<cfset s2 = 0>
<cfif GetIntRate.recordcount neq 0>
	<cfset s2 = GetIntRate.IntRate>
</cfif>


<cfquery name="GetIncompleteRate" dbtype="query">
Select count(*)/#TotPlays# as IncompleteRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards = 0
</cfquery>


<cfset s3 = 0>
<cfif GetIncompleteRate.recordcount neq 0>
	<cfset s3 = GetIncompleteRate.IncompleteRate>
</cfif>


<cfquery name="GetShortGainRate" dbtype="query">
Select count(*)/#TotPlays# as ShortGainRate
from GetPASSPlays
Where PlayType in ('PASS')
AND Yards <= 3
</cfquery>


<cfset s4 = 0>
<cfif GetShortGainRate.recordcount neq 0>
	<cfset s4 = GetShortGainRate.ShortGainRate>
</cfif>



<cfquery name="Addit" datasource="sysstats3">
UPDATE PASSPressure
SET RZSACKRate=#100*s1#,
	RZIntRate=#100*s2#,
	RZIncompleteRate=#100*s3#,
	RZShortGainRate=#100*s4#
Where OffDef='D'
AND Team = '#theteam#'
</cfquery>


<cfquery name="Addit" datasource="sysstats3">
UPDATE PASSPressure
SET OffRat= (IntRate) + (SACKRate)
where OffDef='O'
and Team = '#theteam#'
</cfquery>

<cfquery name="Addit" datasource="sysstats3">
UPDATE PASSPressure
SET DefRat= IntRate + SACKRate
where OffDef='D'
and Team = '#theteam#'
</cfquery>

<cfquery name="OverallRat" datasource="sysstats3">
Select d.DefRat - o.OffRat as Overall
From PASSPressure o, PASSPressure d
where o.Team = '#theteam#'
and d.Team = '#theteam#'
and o.OffDef='O'
and d.OffDef='D'
</cfquery>

<cfquery name="Addit" datasource="sysstats3">
UPDATE PASSPressure
SET OverallRat = #OverallRat.Overall#
where Team = '#theteam#'
</cfquery>


</cfoutput>



