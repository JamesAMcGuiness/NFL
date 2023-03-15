
Get all teams
<cfquery datasource="sysstats3" name="GetTeams">
Select Distinct Team 
from pbpSuccessRates
</cfquery>

<cfloop query="GetTeams">

    <cfquery datasource="sysstats3" name="Getopp">
    Select Distinct opp,week from pbpSuccessRates where team = '#GetTeams.Team#' and week > 35
    </cfquery>

    <cfloop query="GetOpp">

        <cfquery datasource="sysstats3" name="GetoppBTA">
        Select * from btaPbPSuccessRates
        Where Team = '#GetOpp.opp#'
		and OffDef='D'
        </cfquery>

        <cfquery datasource="sysstats3" name="GetSR">
        Select * from PbPSuccessRates
        Where OPP = '#GetOpp.opp#'
        and team = '#GetTeams.Team#'
        and week = #GetOpp.week#
		and OffDef='O'
        </cfquery>

		<cfset nRunSuccRt = GetSR.RunSuccessRt + (GetSR.RunSuccessRt * getoppBTA.RunSuccessRt)>
        <cfset nSuccRt1and2down = GetSR.SuccRt1and2down + (GetSR.SuccRt1and2down * getoppBTA.SuccRt1and2down)>
        <cfset nSuccRtRZ = GetSR.SuccRtRZ + (GetSR.SuccRtRZ * getoppBTA.SuccRtRZ)>
        <cfset nBigPlay1And2Down = GetSR.BigPlay1And2Down + (GetSR.BigPlay1And2Down * GetoppBTA.BigPlay1And2Down)>
        <cfset nRZPtsPerPlay = GetSR.RZPtsPerPlay + (GetSR.RZPtsPerPlay * GetoppBTA.RZPtsPerPlay)>
        <cfset nRZPlaysPerGame = GetSR.RZPlaysPerGame + (GetSR.RZPlaysPerGame * GetoppBTA.RZPlaysPerGame)>
        <cfset nSuccRt3rdDown = GetSR.SuccRt3rdDown + (GetSR.SuccRt3rdDown * GetoppBTA.SuccRt3rdDown)>
        <cfset nAvgToGo3rdDown = GetSR.AvgToGo3rdDown + (GetSR.AvgToGo3rdDown * GetoppBTA.AvgToGo3rdDown)>
        <cfset nSackRt3rdAndLong = GetSR.SackRt3rdAndLong - (GetSR.SackRt3rdAndLong * GetoppBTA.SackRt3rdAndLong)>
	    <cfset nIntRt3rdAndLong = GetSR.IntRt3rdAndLong - (GetSR.IntRt3rdAndLong * GetoppBTA.IntRt3rdAndLong)>
	    <cfset nIntRt2ndAnd3rdDown = GetSR.IntRt2ndAnd3rdDown - (GetSR.IntRt2ndAnd3rdDown * GetoppBTA.IntRt2ndAnd3rdDown)>
	    <cfset nBadResult3rdAndLongPass = GetSR.BadResult3rdAndLongPass - (GetSR.BadResult3rdAndLongPass * GetoppBTA.BadResult3rdAndLongPass)>
	    <cfset nBigPlayRt = GetSR.BigPlayRt + (GetSR.BigPlayRt * GetoppBTA.BigPlayRt)>
	    <cfset nBigPlayPassRt = GetSR.BigPlayPassRt + (GetSR.BigPlayPassRt * GetoppBTA.BigPlayPassRt)>
	    <cfset nOverallSuccRt = GetSR.OverallSuccRt + (GetSR.OverallSuccRt * (GetoppBTA.OverallSuccRt/100))>

		<cfquery datasource="sysstats3" name="updit">
		UPDATE PbPSuccessRates
		SET 
		adjRunSuccessRt    = #nRunSuccRt#,
		adjSuccRt1and2down = #nSuccRt1and2down#,
        adjSuccRtRZ = #nSuccRtRZ#,
        adjBigPlay1And2Down = #nBigPlay1And2Down#,
        adjRZPtsPerPlay = #nRZPtsPerPlay# ,
        adjRZPlaysPerGame = #nRZPlaysPerGame#,
        adjSuccRt3rdDown = #nSuccRt3rdDown#,
        adjAvgToGo3rdDown = #nAvgToGo3rdDown#,
        adjSackRt3rdAndLong = #nSackRt3rdAndLong#,
	    adjIntRt3rdAndLong = #nIntRt3rdAndLong#,
	    adjIntRt2ndAnd3rdDown = #nIntRt2ndAnd3rdDown#,
	    adjBadResult3rdAndLongPass = #nBadResult3rdAndLongPass#,
	    adjBigPlayRt = #nBigPlayRt#,
	    adjBigPlayPassRt = #nBigPlayPassRt#,
	    adjOverallSuccRt = #nOverallSuccRt#
		WHERE Team = '#GetTeams.Team#'
		AND opp = '#GetOpp.opp#'
		AND week = #GetOpp.week#
		AND OffDef ='O'
		</cfquery>
   </cfloop>

</cfloop>



Get all teams
<cfloop query="GetTeams">

    <cfquery datasource="sysstats3" name="Getopp">
    Select distinct opp,week from pbpSuccessRates where team = '#GetTeams.Team#' and week > 35
    </cfquery>

    <cfloop query="GetOpp">

        <cfquery datasource="sysstats3" name="GetoppBTA">
        Select * from btaPbPSuccessRates
        Where Team = '#GetOpp.opp#'
		and OffDef='O'
        </cfquery>

        <cfquery datasource="sysstats3" name="GetSR">
        Select * from PbPSuccessRates
        Where OPP = '#GetOpp.opp#'
        and team = '#GetTeams.Team#'
        and week = #GetOpp.week#
		and OffDef='D'
        </cfquery>

		
		<cfset nRunSuccRt = GetSR.RunSuccessRt - (GetSR.RunSuccessRt * (getoppBTA.RunSuccessRt/100))>
        <cfset nSuccRt1and2down = GetSR.SuccRt1and2down - (GetSR.SuccRt1and2down * (getoppBTA.SuccRt1and2down)/100)>
        <cfset nSuccRtRZ = GetSR.SuccRtRZ - (GetSR.SuccRtRZ * (getoppBTA.SuccRtRZ)/100)>
        <cfset nBigPlay1And2Down = GetSR.BigPlay1And2Down - (GetSR.BigPlay1And2Down * (GetoppBTA.BigPlay1And2Down)/100)>
        <cfset nRZPtsPerPlay = GetSR.RZPtsPerPlay - (GetSR.RZPtsPerPlay * (GetoppBTA.RZPtsPerPlay)/100)>
        <cfset nRZPlaysPerGame = GetSR.RZPlaysPerGame - (GetSR.RZPlaysPerGame * (GetoppBTA.RZPlaysPerGame)/100)>
        <cfset nSuccRt3rdDown = GetSR.SuccRt3rdDown - (GetSR.SuccRt3rdDown * (GetoppBTA.SuccRt3rdDown)/100)>
        <cfset nAvgToGo3rdDown = GetSR.AvgToGo3rdDown + (GetSR.AvgToGo3rdDown * (GetoppBTA.AvgToGo3rdDown)/100)>
        <cfset nSackRt3rdAndLong = GetSR.SackRt3rdAndLong + (GetSR.SackRt3rdAndLong * (GetoppBTA.SackRt3rdAndLong)/100)>
	    <cfset nIntRt3rdAndLong = GetSR.IntRt3rdAndLong + (GetSR.IntRt3rdAndLong * (GetoppBTA.IntRt3rdAndLong)/100)>
	    <cfset nIntRt2ndAnd3rdDown = GetSR.IntRt2ndAnd3rdDown + (GetSR.IntRt2ndAnd3rdDown * (GetoppBTA.IntRt2ndAnd3rdDown)/100)>
	    <cfset nBadResult3rdAndLongPass = GetSR.BadResult3rdAndLongPass + (GetSR.BadResult3rdAndLongPass * (GetoppBTA.BadResult3rdAndLongPass)/100)>
	    <cfset nBigPlayRt = GetSR.BigPlayRt - (GetSR.BigPlayRt * (GetoppBTA.BigPlayRt)/100)>
	    <cfset nBigPlayPassRt = GetSR.BigPlayPassRt - (GetSR.BigPlayPassRt * (GetoppBTA.BigPlayPassRt)/100)>
	    <cfset nOverallSuccRt = GetSR.OverallSuccRt - (GetSR.OverallSuccRt * (GetoppBTA.OverallSuccRt/100))>

		<cfquery datasource="sysstats3" name="updit">
		UPDATE PbPSuccessRates
		SET adjSuccRt1and2down = #nSuccRt1and2down#,
		adjRunSuccessRt    = #nRunSuccRt#,
        adjSuccRtRZ = #nSuccRtRZ#,
        adjBigPlay1And2Down = #nBigPlay1And2Down#,
        adjRZPtsPerPlay = #nRZPtsPerPlay# ,
        adjRZPlaysPerGame = #nRZPlaysPerGame#,
        adjSuccRt3rdDown = #nSuccRt3rdDown#,
        adjAvgToGo3rdDown = #nAvgToGo3rdDown#,
        adjSackRt3rdAndLong = #nSackRt3rdAndLong#,
	    adjIntRt3rdAndLong = #nIntRt3rdAndLong#,
	    adjIntRt2ndAnd3rdDown = #nIntRt2ndAnd3rdDown#,
	    adjBadResult3rdAndLongPass = #nBadResult3rdAndLongPass#,
	    adjBigPlayRt = #nBigPlayRt#,
	    adjBigPlayPassRt = #nBigPlayPassRt#,
	    adjOverallSuccRt = #nOverallSuccRt#
		WHERE Team = '#GetTeams.Team#'
		AND opp = '#GetOpp.opp#'
		AND week = #GetOpp.week#
		AND OffDef ='D'
		</cfquery>
   </cfloop>

</cfloop>

