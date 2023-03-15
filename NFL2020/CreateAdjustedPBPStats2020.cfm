<cfquery datasource="sysstats3" name="Teams">
	Delete from AdjPBPSuccessRates
</cfquery>		

<cfset theTeams = getTeams()>

-- For each Team...
<cfloop query="#theTeams#">
	
	
		-- Create a list of opponents,week for the team
		<cfset theOpponents = getOpponents('#theTeams.Team#')>

		<cfloop query="#theopponents#">

			--get opponents BTA STats
			<cfset oppbta = getTeamBTA('#theopponents.opp#')>
			
			--Get the actual stats for the game against this opponent...
			<cfset pbpStats = getPBPStats(#theopponents.week#,'#theteams.team#')>
				
			-- Adj Successrate .58 + (.58 * (Def of opp))
			
			
			<cfset oAdjSR      = pbpStats.pOverall    + (pbpStats.pOverall   * (oppbta.dpOverall))>
			
			<p>
			<cfoutput>
			Team = '#theTeams.Team#'<br>
			<cfdump var="#oppbta#"><br>
			opp = '#theopponents.opp#'<br>
			pbpStats.pOverall = #pbpStats.pOverall#<br>
			oppbta.dpOverall/100 = #oppbta.dpOverall/100#<br>
			oAdjSR = #oAdjSR#
			</cfoutput>
			***************************************************************************************************<br>
			
			
			
			<cfset oAdjRun     = pbpStats.pRun        + (pbpStats.pRun       * (oppbta.dpRun))>
			<cfset oAdjBig     = pbpStats.pBig        + (pbpStats.pBig       * (oppbta.dpBig))>
			<cfset oAdjBigPass = pbpStats.pBigPass    + (pbpStats.pBigPass   * (oppbta.dpBigPass))>
			<cfset op1and2     = pbpStats.p1and2      + (pbpStats.p1and2     * (oppbta.dp1and2))>
			<cfset op3rd       = pbpStats.p3rd        + (pbpStats.p3rd       * (oppbta.dp3rd))>
			
			-- High number is bad on Offense/Defense 
			<cfset oToGo3rd   = pbpStats.pToGo3rd    + (pbpStats.pToGo3rd   * (oppbta.dpToGo3rd))>
			
			-- High number is good
			<cfset oskrt      = pbpStats.pskrt       - (pbpStats.pskrt      * (oppbta.dpskrt))>
			
			-- High number is good
			<cfset oBadResult = pbpStats.pBadResult  - (pbpStats.pBadResult * (oppbta.dpBadResult))>
					
			<cfquery datasource="sysstats3" name="Teams">
			INSERT INTO AdjPBPSuccessRates(Week,Team,Opp,OffDef,OverallSuccRt,BigPlayPassRt,RunSuccessRt,BigPlayRt,SuccRt1and2Down,SuccRt3rdDown,AvgToGo3rdDown,
			SackRt3rdAndLong,BadResult3rdAndLongPass) values(#theopponents.week#,'#theTeams.Team#','#theopponents.opp#','O',#oAdjSR#,#oAdjBigPass#,
			#oAdjRun#,#oAdjBig#,#op1and2#,#op3rd#,#oToGo3rd#,#oskrt#,#oBadResult#)
			</cfquery>		
				
				
			<cfquery datasource="sysstats3" name="Teams">
			INSERT INTO AdjPBPSuccessRates(Week,Team,Opp,OffDef,OverallSuccRt,BigPlayPassRt,RunSuccessRt,BigPlayRt,SuccRt1and2Down,SuccRt3rdDown,AvgToGo3rdDown,
			SackRt3rdAndLong,BadResult3rdAndLongPass) values(#theopponents.week#,'#theopponents.opp#','#theTeams.Team#','D',#oAdjSR#,#oAdjBigPass#,
			#oAdjRun#,#oAdjBig#,#op1and2#,#op3rd#,#oToGo3rd#,#oskrt#,#oBadResult#)
			</cfquery>		
				
				
		</cfloop>
	
</cfloop>



<cffunction name="getTeams" access="remote" output="yes" returntype="Query">
		<cfquery datasource="sysstats3" name="Teams">
			SELECT Team FROM Teams 
		</cfquery>
	<cfreturn #Teams#>
</cffunction>	


<cffunction name="getOpponents" access="remote" output="yes" returntype="Query">
<cfargument name="team" type="String"  required="no" />
	
	<cfquery datasource="sysstats3" name="opponents">
		SELECT opp,week FROM Sysstats where Team = '#arguments.team#'
	</cfquery>

	<cfreturn #opponents#>
</cffunction>	


<cffunction name="getTeamBTA" access="remote" output="yes" returntype="Query">
<cfargument name="team" type="String"  required="no" />

	
		<cfquery datasource="sysstats3" name="bta">
			SELECT pbp.OverallSuccRt/100 as pOverall, pbp.RunSuccessRt/100 as pRun, pbp.BigPlayRt/100 as pBig, pbp.SuccRt1and2Down as p1and2, pbp.SuccRt3rdDown/100 as p3rd, pbp.AvgToGo3rdDown / 100 as pToGo3rd,
				   pbp.BigPlayPassRt/100 as pBigPass, pbp.SackRt3rdAndLong / 100 as pskrt, pbp.BadResult3rdAndLongPass/100 as pBadResult,
				   
				   dpbp.OverallSuccRt/100 as dpOverall, dpbp.RunSuccessRt/100 as dpRun, dpbp.BigPlayRt/100 as dpBig, dpbp.SuccRt1and2Down as dp1and2, dpbp.SuccRt3rdDown/100 as dp3rd, dpbp.AvgToGo3rdDown / 100 as dpToGo3rd,
				   dpbp.BigPlayPassRt/100 as dpBigPass, dpbp.SackRt3rdAndLong / 100 as dpskrt, dpbp.BadResult3rdAndLongPass/100 as dpBadResult
				   
			FROM btapbpSuccessRates pbp, btapbpSuccessRates dpbp
			where pbp.Team = '#arguments.team#' 
			and pbp.OffDef='O'
			and dpbp.Team = '#arguments.team#' 
			and dpbp.OffDef='D'
			
			
		</cfquery>
	

	<cfreturn #bta#>
</cffunction>	



<cffunction name="getPBPStats" access="remote" output="yes" returntype="Query">
<cfargument name="theWeek" type="Numeric"  required="yes" />
<cfargument name="team" type="String"  required="no" />

	
		<cfquery datasource="sysstats3" name="pbpsr">
			SELECT pbp.OverallSuccRt as pOverall, pbp.RunSuccessRt as pRun, pbp.BigPlayRt as pBig, pbp.SuccRt1and2Down as p1and2, pbp.SuccRt3rdDown as p3rd, pbp.AvgToGo3rdDown as pToGo3rd,
				   pbp.BigPlayPassRt as pBigPass, pbp.SackRt3rdAndLong as pskrt, pbp.BadResult3rdAndLongPass as pBadResult,
				   
				   dpbp.OverallSuccRt as dpOverall, dpbp.RunSuccessRt as dpRun, dpbp.BigPlayRt as dpBig, dpbp.SuccRt1and2Down as dp1and2, dpbp.SuccRt3rdDown as dp3rd, dpbp.AvgToGo3rdDown as dpToGo3rd,
				   dpbp.BigPlayPassRt as dpBigPass, dpbp.SackRt3rdAndLong as dpskrt, dpbp.BadResult3rdAndLongPass as dpBadResult
				   
			FROM PBPSuccessRates pbp, PBPSuccessRates dpbp
			where pbp.Team = '#arguments.team#' 
			and pbp.OffDef='O'
			and dpbp.Team = '#arguments.team#' 
			and dpbp.OffDef='D'
			and pbp.Week = #arguments.theWeek#
			and dpbp.Week = #arguments.theWeek#
						
		</cfquery>
	

	<cfreturn #pbpsr#>
</cffunction>	


