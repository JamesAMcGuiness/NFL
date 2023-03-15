



	<cfset Session.avGameRating = 0>
	<cfset Session.avLuckFactor = 0>
	<cfset Session.avMOVPlusGameRat = 0>
	<cfset Session.avMOV = 0>
	<cfset Session.avYPPDif = 0>
	<cfset Session.avPavgDif = 0>
	<cfset Session.avRavgDif = 0>
	<cfset Session.avTOPDif = 0> 	
	
<cfquery datasource="sysstats3" name="GetTeams" >
SELECT DISTINCT Team FROM betterthanavg
</cfquery>

	
<cfquery datasource="sysstats3" name="GetData">
Select * from NFLSPDS 
where (
		(ha   = 'A' and FAV   = 'PHI') 
		or (UND = 'PHI' AND ha   = 'H')
	  )		
and (week >= 41 and week <= 45)
order by week desc
</cfquery>
	
	
<cfdump var="#GetData#">	

	
	
<cfquery datasource="sysstats3" name="GetIt">
Select Team, ha,AVG(ExpectationPct)
from GameInsights
group by Team,ha
order by 1
</cfquery>	
	
<cfinclude template="createbetterthanavgsnfl.cfm">
<cfinclude template="createsos.cfm">
	
	
<cfquery name="Upd" datasource="sysstats3">
UPDATE Teams
set OffTNF = '',
 OffMNF = '',
 OffDivGame = '',
 OffExtraTravel = '',
 OffBadLoss = '',
 OffBigWin = '',
 CoastToCoast = '',
 ExtraRest = ''
  </cfquery>	

<cfquery name="GetSpds" datasource="sysstats3" >
SELECT n.*
FROM NFLSPDS n, Week w
where n.week = w.week
</cfquery>

<cfquery datasource="sysstats3" name="UpdIt">	
Delete from MatchUps where week = #GetSpds.week# and StatType= 'PavgDiffVsSpread'
</cfquery>	

	
<cfquery name="Upd" datasource="sysstats3">
UPDATE AvgGameInsights
set AvgOfAllPr = (PowerRating + AdjPowerRating + PowerRatingAdjForOppWithTrending + PowerRatingAdjForOpp)/4
where week = #Getspds.week - 1#
</cfquery>	




<cfquery name="GetIt" datasource="sysstats3">
Select Team, Avg(ps) - Avg(expectedps) as OverPerformingOffense, Avg(expecteddps) - Avg(dps) as OverPerformingDefense, (Avg(ps) - Avg(expectedps) + Avg(expecteddps) - Avg(dps)) as OverallPerformance  
from Sysstats
Group by team
order by 4 desc
</cfquery>	






<cfloop query="GetIt">

<cfquery name="Upd" datasource="sysstats3">
Update Teams
SET PerformanceRat = #GetIt.OverallPerformance#
Where Team = '#Getit.Team#'
</cfquery>	
</cfloop>




	
<cfset temp = updateNFLSPDSFlags(#Getspds.week# - 1)>


<cfquery name="GetSpds" datasource="sysstats3" >
SELECT n.*
FROM NFLSPDS n, Week w
where n.week = w.week
</cfquery>
 
<cfset theweek = GetSpds.week>
 
<cfloop query="Getspds">
	
	<cfset myfav       = "#Getspds.fav#">
	<cfset myund       = "#GetSpds.und#">
	<cfset ha          = "#GetSpds.ha#">

	<cfif ha is 'H'>
		<cfquery name="u1" datasource="sysstats3" >
		Update Teams
		Set ConseqRdCt = 0
		where Team = '#myFav#'
		
		</cfquery>
	<cfelse>
		<cfquery name="u2" datasource="sysstats3" >
		Update Teams
		Set ConseqRdCt = 0
		where Team = '#myUnd#'
		
		</cfquery>
	
	</cfif>

	<cfset crdtct = conseqAwayGamect(#theweek#,'#myfav#')>
	<cfset crdtct = conseqAwayGamect(#theweek#,'#myund#')>

</cfloop>



<cfset temp = createPreGameStats(#Getspds.week# - 1)>


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
	SELECT AVG(bta.RushPassBTA) as SOS
	FROM BetterThanAvg bta
	WHERE bta.Team IN (SELECT OPP FROM Sysstats WHERE Team = '#GetTeams.Team#')
	order by AVG(bta.RushPassBTA) desc
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
	Update betterthanavg
	SET SOSBTA = #GetSOS.SOS#
	WHERE Team = '#GetTeams.Team#'
	</cfquery>

	
	
	
</cfoutput>
</table>

<cfquery datasource="sysstats3" name="UpdSOS2" >
	Update betterthanavg
	SET RushPassBTAAdj = RushPassBTA + ((SOSBTA/100)*abs(RushPassBTA))
</cfquery>

<cfquery name="Updjim" datasource="sysstats3">
Update betterthanavg
SET PowerRat2022 = PowerPtsPass + (PowerPtsPass*((RushPassBTAAdj/100))/3.5)
</cfquery>


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
	SELECT AVG(bta.RushPassBTA) as SOS
	FROM BetterThanAvg bta
	WHERE bta.Team IN (SELECT OPP FROM GameInsights WHERE Team = '#GetTeams.Team#')
	order by AVG(bta.RushPassBTA) desc
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
	Update betterthanavg
	SET SOSBTA = #GetSOS.SOS#
	WHERE Team = '#GetTeams.Team#'
	</cfquery>

	
	
</cfoutput>
</table>




<cfabort>	
	
<cfquery name="GetSpds" datasource="sysstats3" >
SELECT n.*
FROM NFLSPDS n, Week w
where n.week = w.week
</cfquery>
 
<cfset theweek = GetSpds.week>
<cfset thepriorweek = theweek -1>
<cfset theyr   = GetSpds.yr>
 
<cfloop query="Getspds">
	<cfset theGameTime = "#GetSpds.GameTime#">
	<cfset myfav       = "#Getspds.fav#">
	<cfset myund       = "#GetSpds.und#">
	<cfset ha          = "#GetSpds.ha#">
	<cfset spd         = "#GetSpds.spread#">

	<cfset temp = checkTravel(#theweek#,'#myfav#','#myund#','#ha#')>
	
	<cfset uha = 'A'>
	<cfif ha is 'A'>
		<cfset uha = 'H'>
	</cfif>

	<cfset tmp = SetTeamNames('#myfav#','#ha#','F')>
	<cfset tmp = SetTeamNames('#myund#','#uha#','U')>


</cfloop>	
<p>


<cfquery datasource="sysstats3" name="GetPossUnderrated">
Select Team,GameRating
from GameInsights
where WonGame = '' AND GameRating > 0	
and week = #theweek#
order by GameRating desc
</cfquery>

<p>

Underrated!...<p><br>
<cfquery datasource="sysstats3" name="GetPossOverrated">
Select Team,GameRating
from GameInsights
where WonGame = 'Y' AND GameRating < 0	
and week = #theweek#
order by GameRating 
</cfquery>

<p>
<cfoutput query="GetPossUnderrated">
#Team# - #GameRating#<br>
</cfoutput>

Overrated!...<p>
<cfoutput query="GetPossOverrated">
#Team# - #GameRating#<br>
</cfoutput>


	<cfset avGameRating = 0>
	<cfset avLuckFactor = 0>
	<cfset avMOVPlusGameRat = 0>
	<cfset avMOV = 0>
	<cfset avYPPDif = 0>
	<cfset avPavgDif = 0>
	<cfset avRavgDif = 0>
	<cfset avTOPDif = 0> 	


 
 
	Main Driver...
 	<cfset temp=createStats(#theweek#)>
	<cfset temp=createOppPavgDif(#theweek#)>
	<cfset temp=createFortunateRating(#theweek#)>
	<cfset temp=createPower(#theweek#)>
	<cfset temp=createExpectationNum()>
	<cfset temp=updateNFLSPDSFlags(#theweek#)>
	<cfset temp=createPreGameStats(#theweek#)>


	
	
<cffunction name="getGames" access="remote" output="yes" returntype="Query">
<cfargument name="theWeek" type="Numeric"  required="yes" />
<cfargument name="team" type="String"  required="no" />

	<cfif isdefined("arguments.team")>
		<cfquery datasource="sysstats3" name="GetInfo">
			SELECT * FROM NFLSPDS where week = #arguments.theweek# and (Fav = '#arguments.team#' or Und = '#arguments.team#')
		</cfquery>
	<cfelse>
		<cfquery datasource="sysstats3" name="GetInfo">
		SELECT * FROM NFLSPDS where week = #arguments.theweek#
		</cfquery>

	</cfif>

	<cfreturn #GetInfo#>

</cffunction>	
	
	
<cffunction name="SetTeamNames" access="remote" output="yes" returntype="Void">
	<cfargument name="Team"            type="String"  required="yes" />
	<cfargument name="HomeAwayFlag"    type="String"  required="yes" />
	<cfargument name="FavUndFlag"      type="String"  required="yes" />
	 
	<cfswitch expression='#Arguments.Team#'>
			<cfcase value="OAK">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'rai'> 
					<cfset Session.ScoreHomeTeam = 'OAK'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'rai'> 
					<cfset Session.ScoreAwayTeam = 'OAK'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="LAR">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'ram'> 
					<cfset Session.ScoreHomeTeam = 'LAR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'ram'> 
					<cfset Session.ScoreAwayTeam = 'LAR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="DET">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'det'> 
					<cfset Session.ScoreHomeTeam = 'DET'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'det'> 
					<cfset Session.ScoreAwayTeam = 'DET'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>


			<cfcase value="NYJ">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nyj'> 
					<cfset Session.ScoreHomeTeam = 'NYJ'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nyj'> 
					<cfset Session.ScoreAwayTeam = 'NYJ'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>


			<cfcase value="KC">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'kan'> 
					<cfset Session.ScoreHomeTeam = 'KAN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'kan'> 
					<cfset Session.ScoreAwayTeam = 'KAN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="LAC">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'sdg'> 
					<cfset Session.ScoreHomeTeam = 'LAC'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'sdg'> 
					<cfset Session.ScoreAwayTeam = 'LAC'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="BUF">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'buf'> 
					<cfset Session.ScoreHomeTeam = 'BUF'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'buf'> 
					<cfset Session.ScoreAwayTeam = 'BUF'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="BAL">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'rav'> 
					<cfset Session.ScoreHomeTeam = 'BAL'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'rav'> 
					<cfset Session.ScoreAwayTeam = 'BAL'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="JAX">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'jax'> 
					<cfset Session.ScoreHomeTeam = 'JAX'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'jax'> 
					<cfset Session.ScoreAwayTeam = 'JAX'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="NYG">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nyg'> 
					<cfset Session.ScoreHomeTeam = 'NYG'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nyg'> 
					<cfset Session.ScoreAwayTeam = 'NYG'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="HOU">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'htx'> 
					<cfset Session.ScoreHomeTeam = 'HOU'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'htx'> 
					<cfset Session.ScoreAwayTeam = 'HOU'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="NE">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nwe'> 
					<cfset Session.ScoreHomeTeam = 'NWE'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nwe'> 
					<cfset Session.ScoreAwayTeam = 'NWE'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="TB">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'tam'> 
					<cfset Session.ScoreHomeTeam = 'TAM'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'tam'> 
					<cfset Session.ScoreAwayTeam = 'TAM'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="NO">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'nor'> 
					<cfset Session.ScoreHomeTeam = 'NOR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'nor'> 
					<cfset Session.ScoreAwayTeam = 'NOR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="SF">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'sfo'> 
					<cfset Session.ScoreHomeTeam = 'SFO'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'sfo'> 
					<cfset Session.ScoreAwayTeam = 'SFO'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="MIN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'min'> 
					<cfset Session.ScoreHomeTeam = 'MIN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'min'> 
					<cfset Session.ScoreAwayTeam = 'MIN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="TEN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'oti'> 
					<cfset Session.ScoreHomeTeam = 'TEN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'oti'> 
					<cfset Session.ScoreAwayTeam = 'TEN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="MIA">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'mia'> 
					<cfset Session.ScoreHomeTeam = 'MIA'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'mia'> 
					<cfset Session.ScoreAwayTeam = 'MIA'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="CHI">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'chi'> 
					<cfset Session.ScoreHomeTeam = 'CHI'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'chi'> 
					<cfset Session.ScoreAwayTeam = 'CHI'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="GB">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'gnb'> 
					<cfset Session.ScoreHomeTeam = 'GNB'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'gnb'> 
					<cfset Session.ScoreAwayTeam = 'GNB'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="SEA">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'sea'> 
					<cfset Session.ScoreHomeTeam = 'SEA'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'sea'> 
					<cfset Session.ScoreAwayTeam = 'SEA'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="DEN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'den'> 
					<cfset Session.ScoreHomeTeam = 'DEN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'den'> 
					<cfset Session.ScoreAwayTeam = 'DEN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="WAS">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'was'> 
					<cfset Session.ScoreHomeTeam = 'WAS'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'was'> 
					<cfset Session.ScoreAwayTeam = 'WAS'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="ARZ">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'crd'> 
					<cfset Session.ScoreHomeTeam = 'ARI'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'crd'> 
					<cfset Session.ScoreAwayTeam = 'ARI'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="CIN">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'cin'> 
					<cfset Session.ScoreHomeTeam = 'CIN'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'cin'> 
					<cfset Session.ScoreAwayTeam = 'CIN'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="IND">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'clt'> 
					<cfset Session.ScoreHomeTeam = 'IND'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'clt'> 
					<cfset Session.ScoreAwayTeam = 'IND'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="PIT">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'pit'> 
					<cfset Session.ScoreHomeTeam = 'PIT'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'pit'> 
					<cfset Session.ScoreAwayTeam = 'PIT'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="CLE">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'cle'> 
					<cfset Session.ScoreHomeTeam = 'CLE'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'cle'> 
					<cfset Session.ScoreAwayTeam = 'CLE'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>


			<cfcase value="CAR">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'car'> 
					<cfset Session.ScoreHomeTeam = 'CAR'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'car'> 
					<cfset Session.ScoreAwayTeam = 'CAR'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="DAL">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'dal'> 
					<cfset Session.ScoreHomeTeam = 'DAL'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'dal'> 
					<cfset Session.ScoreAwayTeam = 'DAL'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="ATL">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'atl'> 
					<cfset Session.ScoreHomeTeam = 'ATL'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'atl'> 
					<cfset Session.ScoreAwayTeam = 'ATL'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

			<cfcase value="PHI">
				<cfif Arguments.HomeAwayFlag is 'H'>
					<cfset Session.FileHomeTeam  = 'phi'> 
					<cfset Session.ScoreHomeTeam = 'PHI'>
					<cfset Session.SpdHomeTeam   = '#Arguments.Team#'> 
				<cfelse>
					<cfset Session.FileAwayTeam  = 'phi'> 
					<cfset Session.ScoreAwayTeam = 'PHI'>
					<cfset Session.SpdAwayTeam   = '#Arguments.Team#'> 
				</cfif>
				
				<cfset Session.SpdUndTeam = '#Arguments.Team#'>
				<cfif Arguments.FavUndFlag is 'F'>
					<cfset Session.SpdFavTeam = '#Arguments.Team#'>
				</cfif>
			</cfcase>

		</cfswitch>		
	
</cffunction>







<cffunction name="createStats" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

<cfset theweek = #arguments.theweek#>

<cfquery datasource="sysstats3" name="GetIt">
	SELECT AVG(s2.ps) as NFLAVGPS, AVG(s2.dps) as NFLAVGDPS, 100*(Avg(dfumbleslost) /Avg(dTurnovers)) as NFLLuckFactor 
	FROM Sysstats s2
	Where week <= #theweek#
</cfquery>

<cfset aPS  = GetIt.NFLAVGPS>
<cfset aDPS = GetIt.NFLAVGDPS>
<cfset aLuckFactor = GetIt.NFLLuckFactor>

<cfquery datasource="sysstats3" name="GetItTm">
	SELECT TEAM, AVG(ps) as avPS, AVG(dps) as avDPS, Avg(dfumbleslost) as avdFumLost, Avg(dTurnovers) as avDto 
	FROM Sysstats 
	WHERE Week <= #theweek#
	Group by Team
</cfquery>

<cfdump var="#Getit#">
<cfdump var="#GetitTm#">

<cfloop query="GetItTm">
	<cfset psBTA = ((avPs - aPs)/aPs)*100>
	<cfset dpsBTA = ((adPs - avdPs)/adPs)*100>
	
	<cfset LF = 0>
	<cfif avDto neq 0>
		<cfset LF = (avdFumLost / avDto)*100>
	</cfif>
	
	<cfset btaLuckFactor = 0>
	<cfif LF neq 0>
		<cfset btaLuckFactor = ((LF - aLuckFactor) / LF)>   
	</cfif>
	
	<cfquery datasource="sysstats3" name="GetItTm">
	UPDATE AvgGameInsights
	SET BTAPS = #psBTA#,
		BTAdps = #dpsBTA#,
		BTAPtDif = #psBTA + dpsBTA#,
		btaLuckFactor = #100*btaLuckFactor#,
		LuckFactor = #lf#
	WHERE Team = '#team#' 
	and week = #theweek#
	</cfquery>

	<cfquery datasource="sysstats3" name="GetItTm">
	UPDATE AvgGameInsights
	SET PowerRatingAdjForOpp = ((((btaOppPtDif/100) * (ABS(btaPtDif))) + btaPtDif)/100)*15
	WHERE Team = '#team#' 
	and week = #theweek#
	</cfquery>

	<cfquery datasource="sysstats3" name="GetItTm">
	UPDATE AvgGameInsights
	SET PowerRatingAdjForOppWithTrending = PowerRatingAdjForOpp + ((TrendingUpDown/100) * ABS(PowerRatingAdjForOpp))
	WHERE Team = '#team#' 
	and week = #theweek#
	</cfquery>


</cfloop>

 	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAvgNFL">
			SELECT 	AVG(btaPtDif) as NFLAvg
			FROM AvgGameInsights 
			
	</cfquery>
			
	<cfloop query="GetAGI">
		
		<cfquery datasource="sysstats3" name="Getopp">
		SELECT gi.opp, gi.week	
		FROM GameInsights gi
		where gi.Team = '#GetAGI.Team#'
		AND Week <= #theweek#
		</cfquery>

		<cfset gamect = 0>
		<cfset stat = 0>

		<cfloop query="GetOpp">
		
			<cfquery datasource="sysstats3" name="Getoppstats">
			SELECT 	AVG(btaPtDif) as avPowerRating
			FROM AvgGameInsights 
			where Team = '#GetOpp.opp#'
			and week = #Getopp.week#
			</cfquery>

			<cfoutput query="GetOppStats">
								
				<cfset gamect = gamect + 1>
				<cfset stat = stat + GetOppStats.avPowerRating - GetAvgNFL.NFLAvg>

			</cfoutput>

		</cfloop>

				<cfoutput>
				final stat .... #stat#<br>
				</cfoutput>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET btaoppPtDif = #Stat/gamect#
		where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET AvgAllPowerRatings = (PowerRatingAdjForOpp + PowerRatingAdjForOppWithTrending) / 2
		where Team = '#GetAGI.Team#'
		and week = #theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="Updit">
				UPDATE AVGGameInsights
				SET HomePowerRat = PowerRatingAdjForOppWithTrending + (PowerRatingAdjForOppWithTrending*(HomePerfRat/100)),
					AwayPowerRat = PowerRatingAdjForOppWithTrending + (PowerRatingAdjForOppWithTrending*(AwayPerfRat/100))
				 
				where week = #theweek#
				and team = '#GetAGI.Team#'
		</cfquery> 

		
	</cfloop>
 
	--How lucky has a team been? Check Turnovers vs dTurnovers 
	-- If PLUS in turnovers, what pct of the turnovers
	
</cffunction>



<cffunction name="createOppPavgDif" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfloop query="GetAGI">
	
		<cfquery datasource="sysstats3" name="Getopp">
		SELECT gi.opp	
		FROM GameInsights gi
		where gi.Team = '#GetAGI.Team#'
		</cfquery>

		<cfset gamect = 0>
		<cfset stat = 0>


		<cfloop query="GetOpp">

			<cfquery datasource="sysstats3" name="Getoppstats">
			SELECT 	AVG(PavgDif) as avPowerRating
			FROM AvgGameInsights 
			where Team = '#GetOpp.opp#'
			
			
			</cfquery>

			<cfoutput query="GetOppStats">
				<cfset gamect = gamect + 1>
				<cfif GetOppStats.avPowerRating neq ''>
					<cfset stat = stat + #GetOppStats.avPowerRating#>
				</cfif>
			</cfoutput>

		</cfloop>

				<cfoutput>
				final stat .... #stat#<br>
				</cfoutput>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET oppPavgDif = #Stat/gamect#
		where Team = '#GetAGI.Team#'
		and week = #arguments.theweek#
		</cfquery>
		
	</cfloop>


		<cfquery datasource="sysstats3" name="Updit">
		UPDATE AVGGameInsights
		SET adjPavgDif = pAvgDif + (((100*(( (10 + oppPavgDif) -10)/10))/100)*PavgDif)  
		where week = #arguments.theweek#
		and Team <> 'AVGTeam'
		</cfquery>

</cffunction>


<cffunction name="updateNFLSPDSFlags" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

		

		<cfquery datasource="sysstats3" name="GetGames2">
		SELECT MAX(Gametime) as MNF, MIN(Gametime) as TNF 
		FROM NFLSPDS
		where week = #arguments.theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="GetUpd">
		UPDATE NFLSPDS
		SET MNF_FLAG   = 'Y'
		WHERE Gametime = '#GetGames2.MNF#'
		AND week       = #arguments.theweek#
		</cfquery>

		<cfquery datasource="sysstats3" name="GetTmsMNF">
		SELECT Fav, Und 
		FROM NFLSPDS
		where Gametime = '#GetGames2.MNF#'
		</cfquery>

		<cfquery datasource="sysstats3" name="GetTmsTNF">
		SELECT Fav, Und 
		FROM NFLSPDS
		where Gametime = '#GetGames2.TNF#'
		</cfquery>

		<cfloop query="#GetTmsMNF#">

			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFMNF   = 'Y'
			WHERE Team IN('#GetTmsMNF.Fav#','#GetTmsMNF.Und#')
			</cfquery>

		</cfloop>
		
		<cfquery datasource="sysstats3" name="GetUpd">
		UPDATE NFLSPDS
		SET TNF_FLAG   = 'Y'
		WHERE Gametime = '#GetGames2.TNF#'
		AND week       = #arguments.theweek#
		</cfquery>

		<cfloop query="#GetTmsTNF#">

			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFTNF  = 'Y'
			WHERE Team IN('#GetTmsTNF.Fav#','#GetTmsTNF.Und#')
			</cfquery>

		</cfloop>
		
		<cfset thegames = getGames(#arguments.theweek#)>
		
		<cfloop query="#thegames#">
		
			<cfset temp = checkDivisional(#arguments.theweek#,'#fav#','#und#') >
			<cfset temp = conseqAwayGamect(#arguments.theweek#,'#fav#') >
			<cfset temp = conseqAwayGamect(#arguments.theweek#,'#und#') >
			<cfset temp = checkTravel(#arguments.theweek#,'#fav#','#und#','#ha#')>
			<cfset temp = checkOffBigBadWins(#arguments.theweek#,'#fav#')>
			<cfset temp = checkOffBigBadWins(#arguments.theweek#,'#und#')>
		</cfloop>

		--Now check for current week to see travel coast to coast
		<cfset thegames = getGames(#arguments.theweek# + 1)>
		
		<cfloop query="#thegames#">
			<cfset temp = checkTravel(#arguments.theweek#,'#fav#','#und#','#ha#','Y')>
		</cfloop>

</cffunction>



<cffunction name="checkDivisional" access="remote" output="yes" returntype="Void">
	<cfargument name="theWeek"    type="Numeric"  required="yes" />
	<cfargument name="fav"        type="String"  required="yes" />
	<cfargument name="und"        type="String"  required="yes" />

	<cfquery datasource="sysstats3" name="GetAFCEast">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCEAST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAFCNorth">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCNORTH'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAFCWest">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCWEST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetAFCSouth">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'AFCSOUTH'
	</cfquery>



	<cfquery datasource="sysstats3" name="GetNFCEast">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCEAST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFCCentral">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCCENTRAL'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFCWest">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCWEST'
	</cfquery>

	<cfquery datasource="sysstats3" name="GetNFCSouth">
		SELECT * 
		FROM Teams
		where Team in ('#arguments.fav#','#arguments.UND#')
		AND Div = 'NFCSOUTH'
	</cfquery>


	<cfif GetAfcEast.Recordcount is 2 or GetAfcWest.Recordcount is 2 or GetAfcNorth.Recordcount is 2 or GetAfcSouth.Recordcount is 2 or	
		  GetNfcEast.Recordcount is 2 or GetNfcWest.Recordcount is 2 or GetNfcCentral.Recordcount is 2 or GetNfcSouth.Recordcount is 2>
		
		<cfquery datasource="sysstats3" name="GetUpd">
		UPDATE NFLSPDS
		SET DIV_GAME_FLAG = 'Y'
		WHERE Fav         = '#arguments.fav#'
		AND week          = #arguments.theweek#
		</cfquery>
		
		<cfloop query="GetAfcEast">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetAfcEast.Team#'
			
			</cfquery>
		</cfloop>
		
		<cfloop query="GetAfcWest">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetAfcWest.Team#'
			
			</cfquery>
		</cfloop>
		
		<cfloop query="GetAfcNorth">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetAfcNorth.Team#'
			
			</cfquery>
		</cfloop>
		
		<cfloop query="GetAfcSouth">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetAfcSouth.Team#'
			
			</cfquery>
		</cfloop>


		<cfloop query="GetNFcEast">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetNfcEast.Team#'
			
			</cfquery>
		</cfloop>
		
		<cfloop query="GetNfcWest">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetNfcWest.Team#'
			
			</cfquery>
		</cfloop>
		
		<cfloop query="GetNfcCentral">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetNfcCentral.Team#'
			
			</cfquery>
		</cfloop>
		
		<cfloop query="GetNfcSouth">
			<cfquery datasource="sysstats3" name="GetUpd">
			UPDATE Teams
			SET OFFDIVGAME = 'Y'
			WHERE Team         = '#GetNfcSouth.Team#'
			
			</cfquery>
		</cfloop>


		
	</cfif>		


</cffunction>



<cffunction name="checkTravel" access="remote" output="yes" returntype="Void">
	<cfargument name="theWeek"    type="Numeric"  required="yes" />
	<cfargument name="fav"        type="String"  required="yes" />
	<cfargument name="und"        type="String"  required="yes" />
	<cfargument name="ha"         type="String"  required="no" />
	<cfargument name="CoastToCoast" type="String"  required="no" default="N" />
	
	<cfoutput>
	Checking:Week:#arguments.theweek#<br>
	Checking:Fav: #arguments.fav#<br>
	Checking:Und: #arguments.und#<br>
	Checking:HA: #arguments.Ha#<br>
	</cfoutput>
	
	<cfquery datasource="sysstats3" name="GetMatch2">
		SELECT u.Team as UTeam, f.Team as FTeam 
		FROM Teams u, Teams f
		where u.Team ='#arguments.UND#'
		and   f.Team ='#arguments.FAV#'
		AND 
		(
			(u.Location = 'EAST' and f.Location = 'WEST') OR
			(u.Location = 'WEST' and f.Location = 'EAST') 
		)	
			
	</cfquery>


	<cfdump var="#GetMatch2#"><p>


	<cfif GetMatch2.recordcount gt 0>
	
		<cfif arguments.ha is 'H'>
	
	
			<cfif arguments.CoastToCoast is 'Y'>
			
				<cfquery datasource="sysstats3" name="UpdMatch2">
				Update Teams 
				SET CoastToCoast = 'Y'
				WHERE (Team = '#Arguments.Und#')
				</cfquery>
			
			<cfelse>
			
				<cfquery datasource="sysstats3" name="UpdMatch2">
				Update Teams 
				SET OffExtraTravel = 'Y'
				WHERE (Team = '#Arguments.Und#')
				</cfquery>

			</cfif>
			
			Updated UND for Extra Travel<br>
			
		<cfelse>
			<cfif arguments.CoastToCoast is 'Y'>

				<cfquery datasource="sysstats3" name="UpdMatch2">
					Update Teams 
					SET CoastToCoast = 'Y'
					WHERE (Team = '#Arguments.Fav#')
				</cfquery>
				
			<cfelse>
			
				<cfquery datasource="sysstats3" name="UpdMatch2">
				Update Teams 
				SET OffExtraTravel = 'Y'
				WHERE (Team = '#Arguments.Fav#')
				</cfquery>
			</cfif>
			Updated FAV for Extra Travel<br>

		</cfif>	
			
	</cfif>

</cffunction>

<cffunction name="createFortunateRating" access="remote" output="yes" returntype="Void">
	<cfargument name="theWeek"    type="Numeric"  required="yes" />

	<cfquery datasource="sysstats3" name="GetMatch">
		Update SysStats  
		SET  FortunateRating = 0 
		
	</cfquery>
	
	<cfquery datasource="sysstats3" name="GetMatch">
		Update SysStats  
		SET  FortunateRating = 10* ((((dFumblesLost/dTurnovers)*100)/100) * (dturnovers - turnovers))
		Where dTurnovers <> 0
	</cfquery>
	
	<cfquery datasource="sysstats3" name="GetMatch">
		Select Team, AVG(FortunateRating) as rat  
		from Sysstats
		group by team
		order by 2 desc	
	</cfquery>
	
	<cfloop query="GetMatch">
		<cfquery datasource="sysstats3" name="UpdGetMatch">
		Update AvgGameInsights  
		SET  FortunateRating = #GetMatch.rat#
		Where Team = '#GetMatch.Team#'
		and week = #arguments.theweek#
		</cfquery>
	</cfloop>
	<cfdump var="#GetMatch#">
	

</cffunction>


<cffunction name="createPower" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

	<cfquery datasource="sysstats3" name="GetAGI">
		SELECT Distinct Team	
		FROM Sysstats
	</cfquery>

	<cfloop query="GetAGI">

		<cfset gamect = 0>
		<cfset stat = 0>

			<cfquery datasource="sysstats3" name="GetTeamStats">
			SELECT Team, opp, week, Pavg, dPavg, SackMadePct, SackAllowPct
			FROM Sysstats 
			where Team = '#GetAGI.Team#'
			</cfquery>

			<cfloop query="GetTeamStats">
				
				<cfquery datasource="sysstats3" name="GetoppAvg">
				SELECT AVG(pavg) as aPavg, AVG(dpavg) as aDpavg, AVG(SackMadePct) as aSackMadePct, AVG(SackAllowPct) as aSackAllowPct 	
				FROM Sysstats 
				where Team = '#GetTeamstats.opp#'
				</cfquery>

				Compare Game Stats to oppAvgs...
				<cfset PavgPow  = GetTeamstats.pavg - GetOppAvg.adpavg>
				<cfset dPavgPow = GetOppAvg.apavg - GetTeamstats.dpavg>

				<cfset SackForPow     = GetTeamstats.SackMadePct - GetoppAvg.aSackAllowPct>
				<cfset SackAgainstPow = GetoppAvg.aSackMadePct - GetTeamstats.SackAllowPct>
				


				<cfquery datasource="sysstats3" name="Updit">
				UPDATE Sysstats
					Set POWPavg  = #PavgPow#,
                        POWdPavg = #dPavgPow#,		
						PowPassOverall = #PavgPow + dPavgPow#,
						PowSackForPct = #SackForPow#,
						PowSackAgainstPct = #SackAgainstPow#
						
				where Team = '#GetTeamStats.team#'
				and week = #GetTeamStats.week#
				</cfquery>
				
			</cfloop>

	</cfloop>
</cffunction>	





<cffunction name="getAvgGameInsights" access="remote" output="yes" returntype="Query">
<cfargument name="theWeek" type="Numeric"  required="yes" />
<cfargument name="team" type="String"  required="no" />

	<cfif arguments.Team gt ''>
	
		<cfquery datasource="sysstats3" name="GetData">
		SELECT * FROM AvgGameInsights where week = #arguments.theweek# and team='#arguments.Team#'
		</cfquery>
	<cfelse>

		<cfquery datasource="sysstats3" name="GetData">
		SELECT * FROM AvgGameInsights where week = #arguments.theweek#
		</cfquery>
	</cfif>
	<cfreturn #GetData#>

</cffunction>	








<cffunction name="createPreGameStats" access="remote" output="yes" returntype="Void">
<cfargument name="theWeek"    type="Numeric"  required="yes" />

	
	
	
	<Table width="50%" border="0" align="center">
	<tr>
	<td align="left">
	<h3>
	Advantage Line Explained
	</h3>
	</td>
	</tr>
	<tr>
	<td bgcolor="Green">Favorite Has The Advantage</td>
	</tr>
	<tr>
	<td bgcolor="Red"> Underdog Has The Advantage</td>
	</tr>
	
	<tr>
	<td>PowerRat - This is the preditced point differential with home field factored in.</td>
	</tr>
	<tr>
	<td>PredictedPassAvg - What my projected Yards/Pass Attempt differential is</td>
	</tr>
	<tr>
	<td>Trending - The difference in the teams Trending direction.</td>
	</tr>
	<tr>
	<td>FortunateRat - The difference in how "lucky" the teams are in comparison</td>
	</tr>
	<tr>
	<td>PassPower - The difference in a teams ability to pass and defend the pass</td>
	</tr>
	<tr>
	<td>SOSRat - The difference in teams strength of schedule</td>
	</tr>
	<tr>
	<td>OffBye? - Is there an advantage because a team is off a bye?</td>
	</tr>
	<tr>
	<td>OffMNF? - Is there an advantage because a team is off a Monday Night game?</td>
	</tr>
	<tr>
	<td>OffTNF? - Is there an advantage because a team is off a Thursday Night game?</td>
	</tr>
	<tr>
	<td>OffDivGame? - Is there an advantage because a team is off a Divisional game?</td>
	</tr>
	<tr>
	<td>ExtraTravel? - Is there an advantage because a team is off extra travel?</td>
	</tr>
	<tr>
	<td>Road Ct - Is there an advantage based on being on the road?</td>
	</tr>
	<tr>
	<td>Spot Level Pick- New Factor I am Testing, tested strong for 2018</td>
	</tr>
	</table>

	<cfset spdweek = arguments.theweek+1>
	<cfset theGames = getGames(#spdweek#)>
	
	<cfquery datasource="sysstats3" name="addit">
	Update BetterThanAvg
	SET PowerRatAdjAvg = (PowerPts + PowerPtsAdj)/2 
	</cfquery>
	
	<cfinclude template="PowerRating2020.cfm">
	
	
	<cfloop query="#theGames#">


	<cfset vWeek = 0>
	<cfset vGametime = "" >	
	<cfset vFav ="">	
	<cfset vHA	= "" >
	<cfset vSpread = 0 >	
	<cfset vUnd	= "" >

	<cfset vFavPowerRating = 0 >	
	<cfset vFavTrending	= 0 >
	<cfset vFavFortunateRating = 0 >	
	<cfset vFavPassRating = 0 >
	
	<cfset vFavProjPavg	= 0 >
	
	<cfset vUndPowerRating	= 0 >
	<cfset vUndTrending	= 0 >
	<cfset vUndFortunateRating = 0 >	
	<cfset vUndPassRating = 0 >	
	
	<cfset vUndProjPavg	= 0 >
	<cfset vFavProjPavgConfidence = 0 >
	<cfset vUndProjPavgConfidence = 0 >
	
	<cfset vFavHomePerfRat = 0 >
	<cfset vFavAwayPerfRat = 0 >
	<cfset vUndHomePerfRat = 0 >	
	<cfset vUndAwayPerfRat = 0 >
	
	<cfset vFavConseqRdCt = 0 >
	<cfset vUndConseqRdCt = 0 >
	
	<cfset vFavOffMNF_Flag = "" >
	<cfset vUndOffMNF_Flag = "" >
	<cfset vFavOffTNF_Flag	= "" >
	<cfset vUndOffTNF_Flag = "" >

	<cfset vFavAFANum = 0> 
	<cfset vUndAFANum = 0>

	<cfset vFavHFANum = 0> 
	<cfset vUndHFANum = 0>

		<cfset vweek = #week#>
		<cfset vGametime = #gametime#>
		<cfset vFav = '#fav#'>
		<cfset vUnd = '#und#'>
		<cfset vHA = '#ha#'>
		<cfset vSpread = #spread#>
		<cfset spdweek = vweek + 1>

		<cfquery datasource="Sysstats3" name="GetFavTeamInfo">
		Select * from Teams
		where Team='#vfav#'
		</cfquery>
		
		<cfquery datasource="Sysstats3" name="GetUndTeamInfo">
		Select * from Teams
		where Team='#vund#'
		</cfquery>
		
		<cfquery datasource="Sysstats3" name="GetFavPR">
		Select * from betterthanavg
		where Team='#vfav#'
		</cfquery>
		
		<cfquery datasource="Sysstats3" name="GetUndPR">
		Select * from betterthanavg
		where Team='#vund#'
		</cfquery>
		

		<cfif vHA is 'H'>
			<cfset useForHFA = getHFA('#vFav#','#vUnd#')>
		<cfelse>
			<cfset useForHFA = getHFA('#vUnd#','#vFav#')>
		</cfif>

		<cfset FavCheckExpectationNum=getGameInsights(#vweek# - 1, '#vfav#')>
		<cfset UndCheckExpectationNum=getGameInsights(#vweek# - 1, '#vund#')>

		<cfset FavLevel1 = ''>
		<cfset FavLevel2 = ''>
		<cfset UndLevel1 = ''>
		<cfset UndLevel2 = ''>
		
		<cfif FavCheckExpectationNum.ExpectationNum is -2>
			<cfset FavLevel1 = 'Y'>
		</cfif>	

		<cfif FavCheckExpectationNum.ExpectationNum lt -2>
			<cfset FavLevel2 = 'Y'>
		</cfif>	

		<cfif UndCheckExpectationNum.ExpectationNum is -2>
			<cfset UndLevel1 = 'Y'>
		</cfif>	

		<cfif UndCheckExpectationNum.ExpectationNum lt -2>
			<cfset UndLevel2 = 'Y'>
		</cfif>	

	
		<!--- Get the stats for the weeks before the spread week --->
		<cfset agi = getAvgGameInsights(vweek - 1,'#vfav#')>
		
		<cfset vFavPowerRating     = #GetFavPR.FinalPowerRat#>	
		
		
		<cfset vFavTrending	       = #agi.TrendingUpDown#>
		<cfset vFavFortunateRating = #agi.FortunateRating# >	
		<cfset vFavPassRating      = #agi.AdjPavgDif#>
		
		
		
		
		<cfset vFavOppPR           = #GetFavTeamInfo.SOS#>
		<cfif vha is 'H'>
			<cfset vFavHomePerfRat     = #agi.homeperfrat#>
			<cfset vFavHFANum          = #agi.hFANum#>
			
		<cfelse>
			<cfset vFavAwayPerfRat     = #agi.awayperfrat#>
			<cfset vFavAFANum          = #agi.aFANum#>
			
		</cfif>
		
		<cfset agi = getAvgGameInsights(vweek - 1,'#vund#')>
		
		<cfset vUndPowerRating     = #GetUndPR.FinalPowerRat#>	
		
		
		<cfset vUndTrending	       = #agi.TrendingUpDown#>
		<cfset vUndFortunateRating = #agi.FortunateRating# >	
		<cfset vUndPassRating      = #agi.AdjPavgDif#>
		<cfset vUndOppPR           = #GetUndTeamInfo.SOS#>
		<cfif vha is 'A'>
			<cfset vUndHomePerfRat     = #agi.homeperfrat#>
			<cfset vUndHFANum          = #agi.hFANum#>
		<cfelse>
			<cfset vUndAwayPerfRat     = #agi.awayperfrat#>
			<cfset vUndAFANum          = #agi.aFANum#>
		</cfif>



		<cfset FavOffBye = ''>
		<cfset UndOffBye = ''>
		


		<cfset FavLastGame = getGames(#arguments.theweek#,'#fav#')>
		<cfset UndLastGame = getGames(#arguments.theweek#,'#und#')>

		<cfset vFavOffMNF_Flag = ''>
		<cfset vFavOffTNF_Flag = ''>
		<cfset vFavOffDIV_Flag = ''>
		<cfset vFavOffTravel_Flag = ''>


		<cfif FavLastGame.recordcount is 0>
			<cfset FavOffBye = 'Y'>
		<cfelse>
			<cfset vFavOffMNF_Flag     = '#GetFavTeamInfo.OFFMNF#'>
			<cfset vFavOffTNF_Flag     = '#GetFavTeamInfo.OFFTNF#'>
			<cfset vFavOffDIV_Flag     = '#GetFavTeamInfo.OFFDIVGAME#'>
			<cfset vFavOffTravel_Flag  = '#GetFavTeamInfo.OFFExtraTravel#'>
						
		</cfif>	

		<cfset vUndOffMNF_Flag = ''>
		<cfset vUndOffTNF_Flag = ''>
		<cfset vUndOffDIV_Flag = ''>
		<cfset vUndOffTravel_Flag = ''>


		
		<cfif UndLastGame.recordcount is 0>
			<cfset UndOffBye = 'Y'>
		<cfelse>
			<cfset vUndOffMNF_Flag     = '#GetUndTeamInfo.OFFMNF#'>
			<cfset vUndOffTNF_Flag     = '#GetUndTeamInfo.OFFTNF#'>
			<cfset vUndOffDIV_Flag     = '#GetUndTeamInfo.OFFDIVGAME#'>
			<cfset vUndOffTravel_Flag  = '#GetUndTeamInfo.OFFExtraTravel#'>
						
		</cfif>	
		
		<cfif vweek gt 2>
			<cfset FavConseqRdCt = #GetFavTeamInfo.ConseqRdCt#>
			<cfset UndConseqRdCt = #GetUndTeamInfo.ConseqRdCt#>
		</cfif>
		
		
		
		<cfset vFavPavgProj = createPavgProjections(vWeek + 1,'#vFav#','#vUnd#')>
		<cfset vUndPavgProj = createPavgProjections(vWeek + 1,'#vUnd#','#vFav#')>

	<cfif 1 is 2>
		<cfif vha is 'H'>
			<cfset HFA = getHFA('#vfav#','#vund#')>
			<cfset UndConseqRdCt = UndConseqRdCt + 1>
			
		<cfelse>
			<cfset favConseqRdCt = favConseqRdCt + 1>
			<cfset HFA = getHFA('#vund#','#vfav#')>
		</cfif>	
	</cfif>	
		
		
	<cfset HFA = useForHFA>
	<cfset HFA = 2>
	
	
	<br>
	<Table width="80%" border="1" cellpadding="8" cellspacing="8">
	<tr>
	<td>Team</td>
	<cfif 1 is 2>
	<td>Performance<br>Rat</td>
	</cfif>
	<td align="center">Power<br>Rat</td>
	<td align="center">Pred.<br>PassAvg</td>
	<td align="center">Trending</td>
	<cfif 1 is 2>
	<td align="center">Fortunate<br>Rat</td>
	<td align="center">Pass<br>Power</td>
	</cfif>
	<td align="center">SOS<br>Rat</td>
	<td align="center">Off<br>Bye?</td>
	<td align="center">Off<br>MNF?</td>
	<td align="center">Off<br>TNF?</td>
	<td align="center">Off<br>DivGame?</td>
	<td align="center">Extra<br>Travel?</td>
	<td align="center">Road<br>Ct</td>
	<td align="center" nowrap>Spot Level<br> Play On</td>
	</tr>

	<td bgcolor="Green" align="left" nowrap>#vFav#(#vha#)<br>-#vspread#</td>
	<cfif 1 is 2>
	<td align="center">#Numberformat(GetFavTeamInfo.PerformanceRat,'99.99')#</td>
	</cfif>
	<td align="center">#Numberformat(vFavPowerRating,'99.99')#</td>
	<td align="center">#Numberformat(vFavPavgProj,'99.99')#</td>
	<td align="center">#Numberformat(vFavTrending,'99.99')#</td>
	<cfif 1 is 2>
	<td align="center">#Numberformat(vFavFortunateRating,'999.99')#</td>
	<td align="center">#Numberformat(vFavPassRating,'99.99')#</td>
	</cfif>
	<td align="center">#Numberformat(vFavOppPR,'99.99')#</td>
	<td align="center">#FavOffBye#</td>
	<td align="center">#vFavOffMNF_Flag#</td>
	<td align="center">#vFavOffTNF_Flag#</td>
	<td align="center">#vFavOffDIV_Flag#</td>
	<td align="center">#vFavOffTravel_Flag#</td>
	<td align="center">#FavConseqRdCt#</td>
	<cfif FavLevel1 is 'Y'>
		<td nowrap>Level 1</td>
	<cfelseif FavLevel2 is 'Y'>
		<td nowrap>Level 2</td>
	</cfif>	
	</tr>

	<tr>
	<td bgcolor="Red" align="left" nowrap>#vUnd#<br>+#vspread#</td>
	<cfif 1 is 2>
	<td>#Numberformat(GetUndTeamInfo.PerformanceRat,'99.99')#</td>
	</cfif>
	<td align="center">#Numberformat(vUndPowerRating,'99.99')#</td>
	<td align="center">#Numberformat(vUndPavgProj,'99.99')#</td>
	<td align="center">#Numberformat(vUndTrending,'99.99')#</td>
	<cfif 1 is 2>
	<td align="center">#Numberformat(vUndFortunateRating,'999.99')#</td>
	<td align="center">#Numberformat(vUndPassRating,'99.99')#</td>
	</cfif>
	<td align="center">#Numberformat(vUndOppPR,'99.99')#</td>
	<td align="center">#UndOffBye#</td>
	<td align="center">#vUndOffMNF_Flag#</td>
	<td align="center">#vUndOffTNF_Flag#</td>
	<td align="center">#vUndOffDIV_Flag#</td>
	<td align="center">#vUndOffTravel_Flag#</td>
	<td align="center">#UndConseqRdCt#</td>
	<cfif UndLevel1 is 'Y'>
		<td align="center" nowrap>Level 1</td>
	<cfelseif UndLevel2 is 'Y'>
		<td align="center" nowrap>Level 2</td>
	</cfif>
	</tr>
	
	<cfif vha is 'H'>
		<cfset ourspd = (vFavPowerRating + hfa) - vUndPowerRating>
		<cfset FavConseqRdCt = 0>
	<cfelse>
		<cfset UndConseqRdCt = 0>
		<cfset ourspd = (vFavPowerRating - hfa) - vUndPowerRating>
	</cfif>
	
	<cfset ourspd = #Numberformat(ourspd,'99.99')#>
	
	<cfset ourspdcolor = "">
	<cfif ourspd gt vspread>
		<cfset ourspdcolor = "Green">
	</cfif>	

	<cfif ourspd lt vspread>
		<cfset ourspdcolor = "Red">
	</cfif>	

	
	<cfset diff1 = vFavPavgProj - vUndPavgProj>
	<cfset diff1 = #Numberformat(diff1,'99.99')#>

		
	<cfset diff2 = vFavTrending - vUndTrending>
	<cfset diff2 = #Numberformat(diff2,'99.99')#>
		
	<cfset diff3 = vUndFortunateRating - vFavFortunateRating>
	<cfset diff3 = #Numberformat(diff3,'99.99')#>
		
	<cfset diff4 = vFavPassRating - vUndPassRating>
	<cfset diff4 = #Numberformat(diff4,'99.99')#>
		
	<cfset diff5 = vFavOppPR - vUndOppPR>
	<cfset diff5 = #Numberformat(diff5,'99.99')#>
	
	<cfSet MNFAdv = "">
	<cfSet TNFAdv = "">
	<cfSet DivAdv = "">

	<cfif diff1 gt 0>
		<cfset diff1color = "Green">
	<cfelse>
		<cfset diff1color = "Red">
	</cfif>	

	<cfif diff2 gt 0>
		<cfset diff2color = "Green">
	<cfelse>
		<cfset diff2color = "Red">
	</cfif>	

	<cfif diff3 gt 0>
		<cfset diff3color = "Green">
	<cfelse>
		<cfset diff3color = "Red">
	</cfif>	
	
	<cfif diff4 gt 0>
		<cfset diff4color = "Green">
	<cfelse>
		<cfset diff4color = "Red">
	</cfif>	

	<cfif diff5 gt 0>
		<cfset diff5color = "Green">
	<cfelse>
		<cfset diff5color = "Red">
	</cfif>	
	
	<cfSet MNFAdvcolor = "">
	<cfif vFavOffMNF_Flag is 'Y'>
		<cfSet MNFAdv = '#vund#'>
		<cfSet MNFAdvcolor = "Red">
	</cfif>

	<cfSet TNFAdvcolor = "">
	<cfif vFavOffTNF_Flag is 'Y'>
		<cfSet TNFAdv = '#vfav#'>
		<cfSet TNFAdvcolor = "Green">
	</cfif>
	
	<cfSet DivAdvColor = "">
	<cfif vFavOffDIV_Flag is 'Y'>
		<cfif vUndOffDIV_Flag is ''>
			<cfSet DivAdv = '#vund#'>
			<cfSet DivAdvColor = "Red">
		</cfif>
	</cfif>

	<cfif vUndOffMNF_Flag is 'Y'>
		<cfSet MNFAdv = '#vfav#'>
		<cfSet MNFAdvcolor = "Green">
	</cfif>

	<cfif vUndOffTNF_Flag is 'Y'>
		<cfSet TNFAdv = '#vund#'>
		<cfSet TNFAdvcolor = "Red">
	</cfif>
	
	<cfif vUndOffDIV_Flag is 'Y'>
		<cfif vFavOffDIV_Flag is ''>
			<cfSet DivAdv = '#vfav#'>
			<cfSet DivAdvColor = "Green">
		</cfif>
	</cfif>
	
	<cfset ConseqRdCtColor="">
	<cfif abs(UndConseqRdCt - FavConseqRdCt) gt 1>
		<cfset ConseqRdCtColor="Green">
	</cfif>
	
	<cfif abs(UndConseqRdCt - FavConseqRdCt) lt 1>
		<cfset ConseqRdCtColor="Red">
	</cfif>

	<cfif ourspd gt 0>
		<cfset Line = '#vfav# by #ourspd#'>
	<cfelse>
		<cfset Line = '#vund# by #abs(ourspd)# '>
	</cfif>
	
	<cfset ExtraTravelColor="">
	<cfset AdvExtraTravel="">	
	
	<cfif vUndOffTravel_Flag is ''>
		<cfif vFavOffTravel_Flag is 'Y'>
			<cfset ExtraTravelColor="Red">
			<cfset AdvExtraTravel="#vund#">
		</cfif>
	</cfif>

	<cfif vFavOffTravel_Flag is ''>
		<cfif vUndOffTravel_Flag is 'Y'>
			<cfset ExtraTravelColor="Green">
			<cfset AdvExtraTravel="#vfav#">
		</cfif>
	</cfif>
	
	<cfset ShowOffBye = ''>
	
	<cfif FavOffBye is 'Y'>
		<cfset ShowOffBye = '#vFav#'>
	</cfif>
	
	<cfif UndOffBye is 'Y'>
		<cfset ShowOffBye = '#vUnd#'>
	</cfif>

	<cfif (UndConseqRdCt - FavConseqRdCt) lt -1>
		<cfset ConseqRdCtColor ="Red">
	</cfif>
	
	<tr>
	<td align="left"></td>
	<cfif 1 is 2>
	<td bgcolor="">#Numberformat(GetFavTeamInfo.PerformanceRat - GetUndTeamInfo.PerformanceRat,'99.99')#</td>
	</cfif>
	<td align="left" bgcolor="#ourspdcolor#">My Line:<br><b> #line#</b> <cfif ourspd lt 0 and vspread neq 0><br>Wrong Team Favored!</cfif></td>
	<td align="center" bgcolor="#diff1Color#">#diff1#</td>
	<td align="center" bgcolor="#diff2Color#">#diff2#</td>
	<cfif 1 is 2>
	<td align="center" bgcolor="#diff3Color#">#diff3#</td>
	<td align="center" bgcolor="#diff4Color#">#diff4#</td>
	</cfif>
	<td align="center" bgcolor="#diff5Color#">#diff5#</td>
	<td align="center">#ShowOffBye#</td>
	<td align="center" bgcolor="#MNFAdvColor#">#MNFAdv#</td>
	<td align="center" bgcolor="#TNFAdvColor#">#TNFAdv#</td>
	<td align="center" bgcolor="#DIVAdvColor#">#DIVAdv#</td>
	<td align="center" bgcolor="#ExtraTravelColor#">#AdvExtraTravel#</td>
	<td align="center" bgcolor="#ConseqRdCtColor#"><cfif ABS(UndConseqRdCt - FavConseqRdCt) gt 1>#UndConseqRdCt - FavConseqRdCt#</cfif></td>
	</tr>
	
	<cfif vspread neq 0>
		<cfset myval = (vFavPavgProj - vUndPavgProj) / vspread>
		<cfoutput>
		The Passing Avg Diff to spread value is #myval#
		</cfoutput>
	<cfelse>
		<cfset myval = (vFavPavgProj - vUndPavgProj)>
		<cfoutput>
		The Passing Avg Diff to spread value is #myval#
		</cfoutput>
		
			
		
	</cfif>
	<cfquery datasource="sysstats3" name="UpdIt">	
		Insert into MatchUps (StatDesc,StatType,FavStat,UndStat,Fav,Und,Week) Values('Compare Predicted Pavg Diff Versus Spread.','PavgDiffVsSpread',#myval#,-1*#myval#,'#vfav#','#vund#',#vweek#)
	</cfquery>
		


<cfif 1 is 2>
<tr>
<td colspan="15"></td>
</tr>
<tr>
<td colspan="15"></td>
</tr>
</cfif>
</table>
<p></p>
<p></p>
<p></p>
		
<p>		
		
	<cfif FavOffBye is 'Y'>		
	
		<cfquery datasource="sysstats3" name="UpdIt">	
		UPDATE Teams
		SET ExtraRest = 'Y'
		WHERE Team = '#vfav#'	
		</cfquery>		
		
	</cfif>
	
	<cfif UndOffBye is 'Y'>		
	
		<cfquery datasource="sysstats3" name="UpdIt">	
		UPDATE Teams
		SET ExtraRest = 'Y'
		WHERE Team = '#vund#'	
		</cfquery>		
		
	</cfif>
		
		
		
	<cfquery datasource="sysstats3" name="UpdIt">	
	UPDATE PBPGameProjections
	SET SpotLevelPlay1 = '#UndLevel1#',
		SpotLevelPlay2 = '#UndLevel2#',
		ConseqRdCt = #UndConseqRdCt#
	WHERE Week = #vweek#
	AND FAV = '#vund#'	
	</cfquery>	
		
	
	<cfquery datasource="sysstats3" name="UpdIt">	
	UPDATE PBPGameProjections
	SET SpotLevelPlay1 = '#FavLevel1#',
		SpotLevelPlay2 = '#FavLevel2#',
		ConseqRdCt = #FavConseqRdCt#
	WHERE Week = #vweek#
	AND FAV = '#vfav#'	
	</cfquery>		
		
		
		
	</cfloop>

</cffunction>	

<cffunction name="conseqAwayGamect" access="remote" output="yes" returntype="Numeric">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />

<cfquery datasource="sysstats3" name="GetData">
Select * from NFLSPDS 
where (
		(ha   = 'A' and FAV   = '#arguments.Team#') 
		or (UND = '#arguments.Team#' AND ha   = 'H')
	  )		
and (week >= (#arguments.week - 4#) and week <= #arguments.week#)
order by week desc
</cfquery>


<cfset AwayCt1 = 0>
<cfset AwayCt2 = 0>
<cfset AwayCt3 = 0>
<cfset AwayCt4 = 0>
<cfset AwayCt = 0>

<cfset LastTwoAway   = ''>
<cfset LastThreeAway = ''>
<cfset LastFourAway  = ''>

<cfloop query="GetData">
	
	<cfif arguments.Week - GetData.week is 0>
		<cfset AwayCt1 = 1>
	</cfif>
	
	<cfif arguments.Week - GetData.week is 1>
		<cfset AwayCt2 = 1>
	</cfif>
	
	<cfif arguments.Week - GetData.week is 2>
		<cfset AwayCt3 = 1>
	</cfif>
	
	<cfif arguments.Week - GetData.week is 3>
		<cfset AwayCt4 = 1>
	</cfif>
</cfloop>


	<cfif AwayCt1 is 1>
		<Cfset AwayCt = AwayCt + 1>
		<cfif AwayCt2 is 1>
			<Cfset AwayCt = AwayCt + 1>
			<cfset LastTwoAway = 'Y'>
			<cfif AwayCt3 is 1>
				<Cfset AwayCt = AwayCt + 1>
				<cfset LastTHreeAway = 'Y'>
				<cfif AwayCt4 is 1>
					<Cfset AwayCt = AwayCt + 1>
					<cfset LastFourAway = 'Y'>
				</cfif>
			</cfif>
		</cfif>	
	</cfif>	
	
	<cfquery datasource="Sysstats3" name="updit">
	Update Teams
	SET ConseqRdCt = #AwayCt#
	WHERE Team = '#arguments.Team#'
	</cfquery>
	
	<cfreturn #AwayCt#>
	
</cffunction>




<cffunction name="createPavgProjections" access="remote" output="yes" returntype="Numeric">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />
<cfargument name="Opp"     type="String"  required="yes" />

<cfquery datasource="sysstats3" name="GetTeamData">
Select AVG(pavg) as avPavg, AVG(dPavg) as avdPavg, AVG(PowPavg) as avPowPavg, AVG(PowdPavg) as avPowdPavg, AVG(SackMadePct) as avSackMadePct, AVG(SackAllowPct) as avSackAllowPct 
from Sysstats 
where Team   = '#arguments.Team#' 
and week < #arguments.week#
</cfquery>

<cfquery datasource="sysstats3" name="GetOppData">
Select AVG(pavg) as avPavg, AVG(dPavg) as avdPavg, AVG(PowPavg) as avPowPavg, AVG(PowdPavg) as avPowdPavg, AVG(SackMadePct) as avSackMadePct, AVG(SackAllowPct) as avSackAllowPct 
from Sysstats 
where Team   = '#arguments.opp#' 
and week < #arguments.week#
</cfquery>

<cfif 1 is 2>
*** JIM *** <br>
Team = '#arguments.Team#'<br>
opp = '#arguments.opp#'<br>
GetTeamData.avPavg = #GetTeamData.avPavg#<br>  
GetOppData.avPowdPavg = #GetOppData.avPowdPavg#<br> 
</cfif>

<cfset TeamProj1 = GetTeamData.avPavg - GetOppData.avPowdPavg>

<cfif 1 is 2>
<p>
GetTeamData.avPowPavg = #GetTeamData.avPowPavg#<br>  
GetOppData.avdPavg = #GetOppData.avdPavg#<br> 
</cfif>

<cfset TeamProj2 = GetTeamData.avPowPavg + GetOppData.avdPavg>


<cfreturn ((#TeamProj1# + #TeamProj2#))/2> 

</cffunction>

<cffunction name="checkOffBigBadWins" access="remote" output="yes" returntype="Void">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />

<cfquery datasource="sysstats3" name="GetBadloss">
SELECT Ps - DPS as mov
from sysstats
Where Team = '#arguments.Team#'
and ps - dps <= -17
and week = #arguments.week#
</cfquery>

<cfquery datasource="sysstats3" name="GetBigWin">
SELECT Ps - DPS as mov
from sysstats
Where Team = '#arguments.Team#'
and ps - dps >= 17
and week = #arguments.week#
</cfquery>


<cfif GetBadloss.recordcount gt 0>
	<cfquery datasource="sysstats3" name="UpdBadloss">
	UPDATE Teams
	SET OffBadLoss = 'Y'
	Where Team = '#arguments.Team#'
	</cfquery>

</cfif>

<cfif GetBigWin.recordcount gt 0>
	<cfquery datasource="sysstats3" name="UpdBigWin">
	UPDATE Teams
	SET OffBigWin = 'Y'
	Where Team = '#arguments.Team#'
	</cfquery>
</cfif>

</cffunction>

<cffunction name="createExpectationNum" access="remote" output="yes" returntype="void">

<cfquery name="GetTeams" datasource="sysstats3">
Select Distinct Team
from GameInsights
</cfquery>

<cfloop query="GetTeams">

<cfquery name="GetStats" datasource="sysstats3">
Select Week, Team, Expectation, TeamCovered
from GameInsights
Where Team = '#GetTeams.Team#'
order by Week
</cfquery>

<cfset ct = 0>
<cfloop query="GetStats">
	<cfif GetStats.Expectation is 'ABOVE'>
		<cfset ct = ct + 1>
	<cfelseif GetStats.Expectation is 'BELOW'> 	
		<cfset ct = ct - 1>
	</cfif>
	
	<cfif GetStats.TeamCovered is 'Y'>
		<cfset ct = 0>
	</cfif>
	
	<cfquery name="UpdStats" datasource="sysstats3">
	UPDATE GameInsights
	SET ExpectationNum = #ct#
	WHERE Week = #GetStats.Week#
	AND TEAM = '#GetTeams.Team#'
	</cfquery>

	


</cfloop>

</cfloop>

When ExpectationNum gets to -3 strong play
Even -2 shows promise...


</cffunction>



<cffunction name="getGameInsights" access="remote" output="yes" returntype="Query">
<cfargument name="Week"    type="Numeric"  required="yes" />
<cfargument name="Team"    type="String"  required="yes" />

<cfquery name="GetStats" datasource="sysstats3">
Select *
from GameInsights
where Team = '#Arguments.Team#'
and week   = #Arguments.Week#
</cfquery>

<cfreturn #GetStats#>

</cffunction>







<cffunction name="createHomeFieldADV" access="remote" output="yes" returntype="Void">
<cfargument name="Week" type="Numeric" required="yes" />
<cfargument name="Team" type="String"  required="yes" />

<cfquery name="GetStats" datasource="sysstats3">
Select (2.2 + h.homeperfrat) as HomeAdv, (-2.2 + a.AwayPerfRat) as AwayAdv, ((2.2 + h.homeperfrat) - (-2.2 + a.AwayPerfRat))/2 as HFACalc
from AVGGameInsights h, AVGGameInsights a 
where h.Team = '#Arguments.Team#'
and a.Team   = '#Arguments.Team#'
and a.week   = #Arguments.Week#
and h.week   = #Arguments.Week#
</cfquery>

<cfquery name="updateit" datasource="sysstats3">
Update Teams
set HomeADV = #GetStats.HomeADV#,
    AwayADV = #GetStats.AwayADV#
where Team = '#Arguments.Team#'
</cfquery>


</cffunction>


<cffunction name="getHFA" access="remote" output="yes" returntype="Numeric">
<cfargument name="HomeTeam" type="String" required="yes" />
<cfargument name="AwayTeam" type="String" required="yes" />

<cfquery name="GetStats" datasource="sysstats3">
Select (h.UseHFA + a.UseAFA) / 2 as HFACalc
from Teams h, Teams a 
where h.Team = '#Arguments.HomeTeam#'
and a.Team   = '#Arguments.AwayTeam#'
</cfquery>

<cfreturn #GetStats.HFACalc#>

</cffunction>





