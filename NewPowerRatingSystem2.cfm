<cfquery datasource="psp_psp" name="GetTeams">
SELECT Distinct Team from BetterThanAvg 

</cfquery>

<cfquery datasource="psp_psp" name="GetPowPts">
SELECT Team,PowerPts
from BetterThanAvg

</cfquery>


<cfloop query="GetTeams">
Running for team <cfoutput>'#GetTeams.Team#' </cfoutput><br>

<cfquery datasource="psp_psp" name="Addit">
	insert into DebugPBP(DebugInfo) values('Running for team: #GetTeams.Team#')	
</cfquery>


	<cfquery datasource="sysstats3" name="Getopp">
		SELECT Team, opp, ha, ps-dps as MOV, week 
		from SYSSTATS
		where team = '#trim(GetTeams.Team)#'
		order by week
	</cfquery>

	<cfset TotPerfPts       = 0>
	<cfset wTotPerfPts      = 0>
	
	<cfset Gamect = 0>
	
	<cfloop query="GetOpp">
		
		<cfquery datasource="psp_psp" name="Addit">
			insert into DebugPBP(DebugInfo) values('Opp is: #GetOpp.opp#')	
		</cfquery>
		
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
		SELECT PowerPts FROM GetPowPts WHERE Team = '#trim(GetOpp.opp)#'
		</cfquery>
	
		<cfquery datasource="psp_psp" name="Addit">
			insert into DebugPBP(DebugInfo) values('PowerPts for opp is: #GetOppRat.PowerPts#')	
		</cfquery>
	
		<cfquery datasource="psp_psp" Name="GetSpds">
		SELECT FAV, UND, spread, ha
		FROM NFLSPDS 
		WHERE Week = #GetOpp.Week# 
		AND (Fav IN('#trim(GetTeams.Team)#') 
		or Und IN('#trim(GetTeams.Team)#'))
		</cfquery>
		
		<cfdump var="#GetSpds#">
		
		<cfset ExpectedWinAmt = 0>
		<cfset ExpectedLossAmt = 0>
		
		<cfset TeamIsFAV = ''>
		
		<cfif '#trim(Getspds.fav)#' is '#trim(GetTeams.Team)#'>
			<cfset TeamIsFAV = 'Y'>
			<cfquery datasource="psp_psp" name="Addit">
			insert into DebugPBP(DebugInfo) values('our team is the Fav')	
			</cfquery>

			<cfset ExpectedWinAmt = GetSpds.spread>
		<cfelse>
			<cfset ExpectedLossAmt = -1 * #GetSpds.spread#>
			
			<cfquery datasource="psp_psp" name="Addit">
			insert into DebugPBP(DebugInfo) values('our team is the Und')		
			</cfquery>
		
		</cfif>	

		<cfquery datasource="psp_psp" name="Addit">
			insert into DebugPBP(DebugInfo) values('ExpectedWinAmt is #ExpectedWinAmt#.')	
		</cfquery>

		<cfquery datasource="psp_psp" name="Addit">
			insert into DebugPBP(DebugInfo) values('ExpectedLossAmt is #ExpectedLossAmt#.')		
		</cfquery>

		<cfoutput>
		#ExpectedWinAmt#....#ExpectedLossAmt#
		</cfoutput>	
		
		<cfset ExpectedWinAmt=0>
		<cfset ExpectedLossAmt=0>
		
		
		<cfif TeamIsFAV is 'Y'>
			<cfif GetOpp.MOV gte 0>
				
				<cfquery datasource="psp_psp" name="Addit">
				insert into DebugPBP(DebugInfo) values('-- Team is favored and won')		
				</cfquery>
			
				<cfif GetOpp.MOV gte 0 and GetOpp.MOV lte 17>
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('Team won by less than 18.')	
					</cfquery>
				
					<cfset PerfPts = GetOppRat.PowerPts + (GetOpp.MOV - ExpectedWinAmt)>
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('1-PerfPts was #PerfPts#')	
					</cfquery>
					
				<cfelseif GetOpp.MOV gt 17>
				
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('Team won by 18 or more.')		
					</cfquery>
				
					<cfset PerfPts = GetOppRat.PowerPts + ((GetOpp.MOV*.99) - ExpectedWinAmt)>
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('2-PerfPts was #PerfPts#')	
					</cfquery>
					
					
				</cfif>
				
				
				
				
			
			<cfelse>
				
				
				<cfif GetOpp.MOV lte 0 and GetOpp.MOV lte -17>
					
					<cfset PerfPts = GetOppRat.PowerPts - (.60*(-1*GetOpp.MOV)) >
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('-- Team is favored and lost by more than 17')	
					</cfquery>
				
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('3-PerfPts was #PerfPts#')		
					</cfquery>
				
				
				
				
				<cfelseif GetOpp.MOV gt -17>
					<cfset PerfPts = GetOppRat.PowerPts + (GetOpp.MOV)>
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('-- Team is favored and lost by less than 17')	
					</cfquery>
				
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('4-PerfPts was #PerfPts#')	
					</cfquery>
					
				</cfif>
			
			</cfif>
			
			
		<cfelse>	
			
			<cfif GetOpp.MOV gte 0>

				<cfif GetOpp.MOV gte 0 and GetOpp.MOV lte 17>
				
								
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('-- Team is underdog and won by less than 17')	
					</cfquery>
		
				
					<cfset PerfPts = GetOppRat.PowerPts + ((GetOpp.MOV) - ExpectedLossAmt)>
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('5-PerfPts was #PerfPts#')	
					</cfquery>
					
					
					
				<cfelseif GetOpp.MOV gt 17>
					<cfset PerfPts = GetOppRat.PowerPts + (((GetOpp.MOV)*.99) - ExpectedLossAmt)>
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('-- Team is underdog and won by more than 17')		
					</cfquery>
		
				
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('6-PerfPts was #PerfPts#')	
					</cfquery>
					
				</cfif>
			
			<cfelse>
			
				<cfif GetOpp.MOV lte 0 and GetOpp.MOV lte -17>
					<cfset PerfPts = GetOppRat.PowerPts - ((.99*(-1*GetOpp.MOV)) - ExpectedLossAmt)>
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('-- Team is underdog and LOST by more than 17')	
					</cfquery>
		
				
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('7-PerfPts was #PerfPts#')	
					</cfquery>
				
				
					
				
				<cfelseif GetOpp.MOV gt -17>
					<cfset PerfPts = GetOppRat.PowerPts - ((-1*GetOpp.MOV) - ExpectedLossAmt)>
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('-- Team is underdog and LOST by less than 17')
					</cfquery>
		
				
					
					<cfquery datasource="psp_psp" name="Addit">
					insert into DebugPBP(DebugInfo) values('8-PerfPts was #PerfPts#')	
					</cfquery>

					
				</cfif>
			
			</cfif>
		</cfif>

		<cfif Getspds.ha is 'A' and TeamIsFAV is 'Y'>
			<cfset PerfPts = PerfPts + 2.5>
		</cfif>	
		
		
		<cfif Getspds.ha is 'H' and TeamIsFAV neq 'Y'>
			<cfset PerfPts = PerfPts + 2.5>
		</cfif>	
		
		
		<cfset TotPerfPts = TotPerfPts + PerfPts>
		
		
		
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
	
<cfquery datasource="psp_psp">
	UPDATE BetterThanAvg
		SET AvgPower = (NewPowerRat + PowerPts)/2
</cfquery>	
	