<cfset Session.Qtr = 0>
<cfset Session.TimeOfPlay = ''>
<cfset Session.Down = 0>
<cfset Session.ToGo = 0>
<cfset Session.FieldPos = 0>
<cfset Session.PlayDepth = ''>


<cfquery datasource="sysstats3" name="Getit">
Select id, RawPlayDesc
from PBPTendencies 
Where RawPlayDesc like '%kneel%' or Playtype = 'PENALTY'
</cfquery>

<cfoutput query="GetIt">
	<cfquery datasource="sysstats3" name="Updit">
	UPDATE PBPTendencies
	Set IgnorePlay = 'Y'
	WHERE Id = #GetIt.Id#
	</cfquery>
</cfoutput>



<cfquery datasource="sysstats3" name="Getit">
Select t.id, t.Team, t.Opponent, t.OffDef 
from PBPTendencies t, DriveChartLoadData ld
Where ld.Week = t.week
and(
 ld.HomeTeam    = t.Team
 or ld.AwayTeam = t.Team)
and ld.week = t.week
and t.team = t.opponent
</cfquery>

<cfoutput query="GetIt">
	<cfquery datasource="sysstats3" name="Updit">
	UPDATE PBPTendencies
	Set ManualFix = 'Y'
	WHERE Id = #GetIt.Id#
	</cfquery>
</cfoutput>

<cfquery datasource="sysstats3" name="Getit">
Select t.id, t.Team, t.Opponent, t.OffDef, ld.HomeTeam, ld.AwayTeam 
from PBPTendencies t, DriveChartLoadData ld
Where ManualFix = 'Y' 
and(
 ld.HomeTeam    = t.Team
 or ld.AwayTeam = t.Team)
 and ld.week = t.week
 order by t.id
</cfquery>

<cfloop query="GetIt">
<cfif Getit.Team is GetIt.HomeTeam>
	
		<cfquery datasource="sysstats3" name="Updit">
		UPDATE PBPTendencies
		Set opponent = '#Getit.Awayteam#'
		WHERE Id = #GetIt.Id#
		</cfquery>
	
<cfelse>
	
		<cfquery datasource="sysstats3" name="Updit">
		UPDATE PBPTendencies
		Set opponent = '#Getit.Hometeam#'
		WHERE Id = #GetIt.Id#
		</cfquery>
	
</cfif>
</cfloop>


<cfquery datasource="sysstats3" name="Getit">
Select t.id + 1 as theid, t.Team, t.Opponent, t.OffDef, ld.HomeTeam, ld.AwayTeam 
from PBPTendencies t, DriveChartLoadData ld
Where ManualFix = 'Y' 
and(
 ld.HomeTeam    = t.Team
 or ld.AwayTeam = t.Team)
 and ld.week = t.week
 order by t.id
</cfquery>

<cfloop query="GetIt">

	<cfset theTeam = '#Getit.Team#'>
	<cfset theopp  = '#Getit.opponent#'>

	<cfquery datasource="sysstats3" name="Updit">
		UPDATE PBPTendencies
		Set opponent = '#theTeam#',
		Team = '#theopp#'
		WHERE Id = #GetIt.theId#
		and OffDef='D'
	</cfquery>

</cfloop>



<cfquery datasource="sysstats3" name="GetWeek">
Update PbPTendencies 
Set Team = 'ARZ' 
Where Team = 'ARI' 

</cfquery>

<cfquery datasource="sysstats3" name="GetWeek">
Update PbPTendencies 
Set Team = 'JAX' 
Where Team = 'JAC' 
</cfquery>

<cfquery datasource="sysstats3" name="GetWeek">
Update PbPTendencies 
Set Opponent = 'ARZ' 
Where Opponent = 'ARI' 
</cfquery>

<cfquery datasource="sysstats3" name="GetWeek">
Update PbPTendencies 
Set Opponent = 'JAX' 
Where Opponent = 'JAC' 
</cfquery>



<cfquery datasource="sysstats3" name="GetWeek">
Select week 
from week
</cfquery>

<cfset Session.Week = #GetWeek.Week#>


<cfquery datasource="sysstats3">
	Delete from PbpStatlocation 
</cfquery>

<cfset Session.week = GetWeek.week>

<cfquery name="GetFirstGame" datasource="sysstats3">
	SELECT MIN(HomeTeam) as useHomeTeam
	FROM DriveChartLoadData
	WHERE week = #Session.week#
	and PBPLoaded = 'N' 
</cfquery>


<cfif GetFirstGame.recordcount is 0>
 <cfabort>

<cfelse>
	<cfset usethis = GetFirstGame.useHomeTeam>
	<cfif GetFirstGame.useHomeTeam is 'JAC'>
		<cfset usethis = 'JAX'>
	</cfif>

	<cfif GetFirstGame.useHomeTeam is 'ARI'>
		<cfset usethis = 'ARZ'>
	</cfif>

</cfif>


<cfquery name="GetSpds" datasource="sysstats3" >
SELECT *
FROM nflspds
WHERE week = #Session.week#
AND (FAV = '#usethis#' or UND = '#usethis#')
</cfquery>



<cfloop query="Getspds">


	<cfset myfav      = "#Getspds.fav#">
	<cfset myund      = "#GetSpds.und#">
	<cfset ha         = "#GetSpds.ha#">
	<cfset spd        = "#GetSpds.spread#">
	<cfset gameplayed = "#GetSpds.GameTime#">
	
	<cfif myfav is 'JAX'>
		<cfset myfav = 'JAC'>
	</cfif>
	
	<cfif myund is 'JAX'>
		<cfset myund = 'JAC'>
	</cfif>

	<cfif myfav is 'ARZ'>
		<cfset myfav = 'ARI'>
	</cfif>
	
	<cfif myund is 'ARZ'>
		<cfset myund = 'ARI'>
	</cfif>
	
	<cfif ha is 'H'>
		<cfset useteam = myfav>
	<cfelse>
		<cfset useteam = myund>
	</cfif>


	<cfquery datasource="sysstats3">
		Delete from PbpTendencies where week = #Session.week# and Team in ('#myfav#','#myund#')
	</cfquery>	
	
	<cfquery name="GetGameURL" datasource="sysstats3">
	SELECT url,id
	FROM DriveChartLoadData
	WHERE week = #Session.week#
	and HomeTeam = '#GetFirstGame.useHomeTeam#'
	</cfquery>


	<cfif GetGameURL.recordcount neq 0>
		
		<cfset mygameurl   = GetGameURL.url>
		<cfset myurl       = Replace('#mygameurl#','drivecharts','playbyplay')>

		<cfoutput>
		#myurl#<br>
		#myfav#<br>
		#myund#<br>
		</cfoutput>
		
		<cfif ha is 'H'>
			<cfset HomeTeam = myfav>
			<cfset AwayTeam = myUnd>
		<cfelse>
			<cfset HomeTeam = myund>
			<cfset AwayTeam = myfav>
		</cfif>
		
		<cfset useHomeTeam = HomeTeam>
		<cfif Hometeam is 'ARZ' >
			<cfset useHomeTeam = 'ARI'>
		</cfif>

		<cfset useAwayTeam = AwayTeam>
		<cfif Awayteam is 'ARZ' >
			<cfset useAwayTeam = 'ARI'>
		</cfif>
	
		
		<cfset Matchup = '#awayteam#' & '@' & '#hometeam#'>

		<cfoutput>
			<cfhttp url="#myurl#" method="GET">
			</cfhttp> 
		</cfoutput>

		<cfset mypage = #cfhttp.FileContent#>
		
		<cfset FindPBP = Find('TableBase TableBase-play-by-play','#mypage#',1)>
		
		<cfset FindPBP2 = Find('<div id="key-players-container"','#mypage#',1)>
		
		<cfset lookforbegin = 'class="">#useHomeTeam#</a>'>
		<cfset HomeTeamPos = Find('#lookforbegin#',mypage,1)>
		
		<cfset lookforbegin = 'class="">#useAwayTeam#</a>'>
		<cfset AwayTeamPos = Find('#lookforbegin#',mypage,1)>

		<cfset temp = adddebug('HomeTeamPos=',#HomeTeamPos#)> 
		<cfset temp = adddebug('AwayTeamPos=',#AwayTeamPos#)> 

		<cfoutput>
		FindPBP = #FindPBP#<br>
		FindPBP2 = #FindPBP2#<br>
		HomeTeamPos = #HomeTeamPos#<br>
		AwayTeamPos = #AwayTeamPos#<br>
		</cfoutput>
		
		<cfset Session.HomeTeam = '#Usehometeam#'>
		<cfset Session.AwayTeam = '#Useawayteam#'>

		<cfset temp = adddebug('HomeTeam = #Session.HomeTeam#')> 
		<cfset temp = adddebug('AwayTeam = #Session.AwayTeam#')> 

			
		<cfset hstats = arraynew(1)>
		<cfset astats = arraynew(1)>
	
		<cfset jimct = 0>
		<cfset mystart = 1>
		<cfset done = false>
		<cfset Drivenum = 0>

		Home team gets the ball first...
		<cfif HomeTeamPos lt AwayTeamPos>

			<cfloop condition="done is false">
			
				<cfset lookforbegin = 'class="">#useHomeTeam#</a>'>
				<cfset FindTeamPos = Find('#lookforbegin#',mypage,mystart)>
				<cfif FindTeamPos gt 0>
					<cfset Drivenum = Drivenum + 1>
					
					<cfif 1 is 1>
					<cfquery datasource="sysstats3" name="addit">
					Insert into PbPStatLocation(Drivenumber,OffDef,Team,Opp,StatPos) values (#Drivenum#,'O','#usehometeam#','#useawayteam#',#FindTeamPos#)
					</cfquery>
					</cfif>
					<cfset Lastone = '#usehometeam#'>
					<cfset mystart = findteampos + 37>
				
				<cfelse>
						<cfset done = true>
				</cfif>
					
					
				<cfset lookforbegin = 'class="">#useAwayTeam#</a>'>
				<cfset FindTeamPos = Find('#lookforbegin#',mypage,mystart)>
				<cfif FindTeamPos gt 0>
					
					<cfif 1 is 1>
					<cfquery datasource="sysstats3" name="addit">
					Insert into PbPStatLocation(Drivenumber,OffDef,Team,Opp,StatPos) values (#Drivenum#,'O','#useawayteam#','#usehometeam#',#FindTeamPos#)
					</cfquery>
					</cfif>
					<cfset Lastone = '#useawayteam#'>
					<cfset mystart = findteampos + 37>
					
				<cfelse>
						<cfset done = true>
				</cfif>
				
			</cfloop>

		<cfelse>
		
			<cfloop condition="done is false">
				<cfset lookforbegin = 'class="">#useAwayTeam#</a>'>
				<cfset FindTeamPos = Find('#lookforbegin#',mypage,mystart)>
				
				<cfset temp = adddebug('HomeTeam = #Session.HomeTeam#')> 
				<cfset temp = adddebug('AwayTeam = #Session.AwayTeam#')> 

				


				<cfif FindTeamPos gt 0>
					<cfset Drivenum = Drivenum + 1>
					
					<cfif 1 is 1>
					<cfquery datasource="sysstats3" name="addit">
					Insert into PbPStatLocation(Drivenumber,OffDef,Team,Opp,StatPos) values (#Drivenum#,'O','#useAwayteam#','#usehometeam#',#FindTeamPos#)
					</cfquery>
					</cfif>
					
					<cfset mystart = findteampos + 37>	
					<cfset Lastone = '#useawayteam#'>
				<cfelse>
					<cfset done = true>
				</cfif>
				<cfset mystart = findteampos + 37>	
				<cfset lookforbegin = 'class="">#useHomeTeam#</a>'>
				<cfset FindTeamPos = Find('#lookforbegin#',mypage,mystart)>
				<cfif FindTeamPos gt 0>
					
					<cfquery datasource="sysstats3" name="addit">
					Insert into PbPStatLocation(Drivenumber,OffDef,Team,Opp,StatPos) values (#Drivenum#,'O','#useHometeam#','#useAwayteam#',#FindTeamPos#)
					</cfquery>
					
					<cfset Lastone = '#usehometeam#'>
					<cfset mystart = findteampos + 37>
					
				<cfelse>
					<cfset done = true>
				</cfif>
				
			</cfloop>

		</cfif>
		
		<cfset Drivenum = Drivenum + 1>
		
		<cfset storeval1 = '#usehometeam#'>
		<cfset storeval2 = '#useawayteam#'>
		
		<cfif Lastone is '#usehometeam#'>
			<cfset storeval1 = '#useawayteam#'>
			<cfset storeval2 = '#usehometeam#'>
			
		</cfif>

		<cfquery datasource="sysstats3" name="addit">
					Insert into PbPStatLocation(Drivenumber,OffDef,Team,Opp,StatPos) values (#Drivenum#,'O','#storeval1#','#storeval2#',999999999)
		</cfquery>
		
		<cfquery datasource="sysstats3" name="GetDrives">
				Select MAX(Drivenumber) as TotDrives from PbPStatLocation where Team in ('#useAwayteam#','#usehometeam#')
		</cfquery>


		<cfset RowCt = 0>
		<cfset Done = false>
		<cfset Drivenum = 0>
		<cfset mystart = 1>
		<cfset  ChangeOfPoss = false>
		<cfloop condition="done is false">
			<cfset jimct = jimct + 1>
				
				<cfoutput>
				Jimct = #jimct#<br>
				DriveNum = #DriveNum#<br>
				</cfoutput>

			<cfset temp = adddebug('Drivenum',#drivenum#)> 

			<cfset lookforbegin = '<div class="play-by-play-down-distance">'>
			<cfset lookforbeginlen = len(lookforbegin)>

			<cfset lookforend = '</div>'>
			<cfset lookforendlen = len(lookforend)>
				
			<cfset foundposbegin = findnocase('#lookforbegin#','#mypage#',mystart)>
			<cfset foundposend   = findnocase('#lookforend#','#mypage#',foundposbegin)>	
		
			<cfset temp = adddebug('found <div class=play-by-play-down-distance',#foundposbegin#)> 
		
		
			<cfif foundposbegin is 0>
					<cfset Done = true>
			</cfif>	
		
			<cfset playFor = lookupstat(#Foundposbegin#)>
				
			<cfif ChangeOfPoss is true>
				
				-- this means there should be a change of possession but the webpage doesn't have the labeling right...
				<cfif playfor is '#LastPossesionFor#'>
					
					-- so we need to fix it with code below
					<cfif playfor is '#useawayteam#'>
						<cfset playfor is '#usehometeam#'>
					<cfelse>
						<cfset playfor is '#useAwayteam#'>
					</cfif>
				</cfif>
			</cfif>
			
				<cfset temp = adddebug('playfor=#playfor#')> 
		
				<cfset startFrom    = (lookforbeginlen + foundposbegin)>
				<cfset ForALengthOf = foundposend - startFrom>
				<cfset DownDist     = '#mid(mypage,startfrom,ForALengthOf)#'>
				<cfset DownDist     = replace('#DownDist#',' &amp; ','-','ALL')>	
				<cfset DownDist     = replace('#DownDist#',' ','','ALL')>	


				<cfset mystart = foundposend + 5>
				<cfset lookforbegin = '</td>'>
				<cfset foundposbegin = findnocase('#lookforbegin#','#mypage#',mystart)>
		
				<cfset ForALengthOf = (foundposbegin - 1 ) - (mystart)> 	
				
				<cfset PlayDesc = '#mid(mypage,mystart + 1,ForALengthOf)#'>

				<cfset temp = adddebug('PlayDesc=#Playdesc#')> 

				<cfset playdesc = replace('#playdesc#','Barnyard','','ALL')>	
				<cfset PlayDesc = Replace('#PlayDesc#','yard difference','','All')>
				<cfset PlayDesc = Replace('#PlayDesc#','yard differences','','All')>
				<cfset PlayDesc = Replace('#PlayDesc#','yards difference','','All')>

				<cfset FndRev = FINDNOCASE('REVERSED','#PlayDesc#')>
				<cfif FndRev gt 0>
					<cfset PlayDesc = Mid('#PlayDesc#',FndRev + 9,200)> 
				</cfif>
				
				<cfset mystart = foundposbegin>
			
				
				<cfset theopp = '#UseHomeTeam#'>
				<cfif UseHometeam is '#playfor#'>
					<cfset theopp = '#UseAwayTeam#'>
				</cfif>
				
				<cfset fndPlayFor = FINDNOCASE('#playfor#','#DownDist#')>
				
				<cfif FndPlayFor gt 0>

					<cfset lenofplayFor = LEN(playfor)>
					
					<cfset myval = val(RIGHT('#DownDist#',2))>
					<cfif myval is 0>
						<cfset myval = val(RIGHT('#DownDist#',1))>
					</cfif>
					
					<cfset Session.FieldPosition = '#playfor#' & '#myval#' >	
					<cfset yardline = myval>
					
					<cfif yardline lte 20>
						<cfset Session.FieldPos = 1>
					<cfelseif yardline lte 40>	
						<cfset Session.FieldPos = 2>
					<cfelseif yardline lte 50>	
						<cfset Session.FieldPos = 3>
					</cfif>
					It is in the teams side of the field	
				<cfelse>
					<cfset myval = val(RIGHT('#DownDist#',2))>
					<cfif myval is 0>
						<cfset myval = val(RIGHT('#DownDist#',1))>
					</cfif>


					<cfset lenofplayFor = LEN(playfor)>
					<cfset Session.FieldPosition = '#theopp#' & '#myval#'>	
					<cfset yardline = myval>
					
					
					<cfif yardline lte 20>
						<cfset Session.FieldPos = 5>
					<cfelseif yardline lte 40>	
						<cfset Session.FieldPos = 4>
					<cfelseif yardline lte 50>	
						<cfset Session.FieldPos = 3>
					</cfif>
				
				</cfif>
				
				<cfif Yardline neq 0>
					<p>
					<p>
					<cfoutput>
					
					<cfset Session.Down = LEFT('#DownDist#',1)>
					<cfset Session.ToGo = ParseIt('#DownDist#',1,'-','-')>
					
					<cfset Session.Qtr = ParseIt('#DownDist# - #playdesc#',13,'-',')')>   
					<cfset Session.TimeOfPlay = ParseIt('#DownDist# - #playdesc#',1,'(','-')>   
				
					
					******************************************<br>
					Setting these for the play: #DownDist# - #playdesc#<br>
					QTR:           #Session.Qtr#<br>
					Time:          #Session.TimeOfPlay#<br>
					Down:          #Session.Down#<br>
					ToGo:          #Session.ToGo#<br>
					FieldPos:      #Session.FieldPos#<br>
					FieldPosition: #Session.FieldPosition#<br>
					Yardline:      #Yardline#<br>
					<cfset myPlayType=getPlayType('#playdesc#')>
					PlayType:      #Session.PlayType#<br>
					PlayDepth:     #Session.PlayDepth#<br>
					PlayDirection: #Session.PlayDirection#<br>
					YardsGained:   #Session.YardsGained#<br> 
					Points:        #Session.Pts#<br>
					*******************************************<br>
					</cfoutput>
					
					
					<cfif PlayFor is '#HomeTeam#'>
						<cfset Session.opp = '#AwayTeam#'>
					<cfelse>
						<cfset Session.opp = '#HomeTeam#'>
					</cfif>

					<cfquery datasource="Sysstats3" name="AddPBP">
					INSERT INTO PBPTendencies(RawPlayDesc,Quarter,TimeOfPlay,Team,Down,ToGo,FieldPosition,PlayType,Opponent,FieldPos,Yards,Score,Direction,OffDef,Week,Pts)
					VALUES('#DownDist# - #playdesc#','#Session.Qtr#','#Session.TimeOfPlay#','#playfor#',#Session.Down#,#Session.ToGo#,'#Session.FieldPosition#','#Session.PlayType#','#Session.opp#',#Session.FieldPos#,#Session.YardsGained#,#Session.Pts#,'#Session.PlayDirection#','O',#Session.Week#,#Session.Pts#)
					</cfquery>

					<cfquery datasource="Sysstats3" name="AddPBP">
					INSERT INTO PBPTendencies(RawPlayDesc,Quarter,TimeOfPlay,Team,Down,ToGo,FieldPosition,PlayType,Opponent,FieldPos,Yards,Score,Direction,OffDef,Week,Pts)
					VALUES('#DownDist# - #playdesc#','#Session.Qtr#','#Session.TimeOfPlay#','#Session.opp#',#Session.Down#,#Session.ToGo#,'#Session.FieldPosition#','#Session.PlayType#','#playfor#',#Session.FieldPos#,#Session.YardsGained#,#Session.Pts#,'#Session.PlayDirection#','D',#Session.Week#,#Session.Pts#)
					</cfquery>
					
					<cfset LastPossesionFor = '#playfor#'>
					<cfset ChangeOfPoss = false>
					<cfif FindNoCase('No Play','#playdesc#') is 0>
						<cfif (FindNoCase('Intercepted','#playdesc#') gt 0 or FindNoCase('TOUCHDOWN','#playdesc#') gt 0 or FindNoCase('field goal','#playdesc#') gt 0 or FindNoCase('punts','#playdesc#') gt 0)>
							<cfset ChangeOfPoss = true>
						</cfif>
					</cfif>
					
				</cfif>	
			
				

			
			</cfloop>

			
		</cfif>
</cfloop>


<cfquery datasource="Sysstats3" name="AddPBP">
Update DriveChartLoadData
SET PBPLoaded='Y'
where week = #Session.week#
and HomeTeam = '#useHomeTeam#'
</cfquery>




<cffunction name="getPlayType" access="remote" output="yes" returntype="void">
	-- Returns the position of where the string was found	
		<cfargument name="Play" type="String"  required="yes" />

		<cfset Session.pts           = 0>
		<cfset Found                 = 'N'>
		<cfset Session.PlayDirection = ''>
		<cfset Session.PlayType      = ''>
		<cset Session.PlayDepth      = 'UNKNOWN'>

<cfif Findnocase('PENALTY','#Arguments.play#') gt 0>
	
	<cfif Findnocase('No Play','#Arguments.play#') gt 0>
		<cfset Session.PlayType = 'PENALTY'>
		<cfset Found = 'Y'>
	</cfif>	
</cfif>

		<cfif Found is 'N'>
			
			<cfset Session.PlayDepth=''>
			<cfset Session.PlayDirection=''>
			
			<cfif Findnocase('kicks','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>
				<cfset Session.PlayType = 'Kickoff'>
			</cfif>
			
			<cfif Findnocase('punts','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'Punt'>
			</cfif>

			<cfif Findnocase('punt is blocked','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'Block Punt'>
			</cfif>


			<cfif Findnocase('extra point is good','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'ExtraPoint'>
				<cfset Session.Pts = 1> 
			</cfif>

			<cfif Findnocase('extra point is no good','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'ExtraPoint'>
			</cfif>

			<cfif Findnocase('field goal is No Good','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'FGA'>
			</cfif>
			
			<cfif Findnocase('field goal is Good','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'FGA'>
				<cfset Session.Pts = 3>
			</cfif>

			<cfif Findnocase('field goal is BLOCKED','#Arguments.play#') gt 0>
				<cfset Found = 'Y'>

				<cfset Session.PlayType = 'FGA'>
				<cfset Session.Pts = 0>
			</cfif>
			
			
		
		
			<cfif Findnocase('TOUCHDOWN','#Arguments.play#') gt 0>
				<cfset Session.Pts = 6>
			</cfif>


			
		</cfif>





	<cfif Found is 'N'>
	
	
		<!-- Pass Play? -->
		<cfset Pass1 = 'pass short middle to'>
		<cfset Pass2 = 'pass short right to'>
		<cfset Pass3 = 'pass short left to'>
		
		<cfset Pass4 = 'pass deep right to'>
		<cfset Pass5 = 'pass deep left to'>
		<cfset Pass6 = 'pass deep middle to'>

		<cfset Pass7 = 'pass incomplete short right'>
		<cfset Pass8 = 'pass incomplete short left'>
		<cfset Pass9 = 'pass incomplete short middle'>
				
		<cfset pass10 = 'pass incomplete deep right'>
		<cfset pass11 = 'pass incomplete deep left'>
		<cfset pass12 = 'pass incomplete deep middle'>

		<cfset pass13 = 'INTERCEPTED'>
		<cfset pass14 = 'sacked'>
		
		<cfset pass15 = 'complete to'>
		<cfset pass16 = 'incomplete'>
		<cfset pass17 = 'spiked'>
		
		
		

		<cfif Found is 'N'>
			<cfset Session.PlayDepth = 'UNKNOWN'>
			<!-- Pass Play -->
			<cfloop index="ii" from="1" to="17">
				<cfset Pass = 'Pass' & '#ii#'>
				<cfset check = evaluate('#Pass#')>
					
				<cfif Findnocase(#check#,'#Arguments.play#') gt 0>
					<cfset Session.PlayType = 'Pass'>
					<cfset Found = 'Y'>
					
					<cfif #ii# is 1>
						<cfset Session.PlayDirection = 'MIDDLE'>
					</cfif>
					<cfif #ii# is 2>
						<cfset Session.PlayDirection = 'RIGHT'>
					</cfif>
					<cfif #ii# is 3>
						<cfset Session.PlayDirection = 'LEFT'>
					</cfif>
					<cfif #ii# is 4>
						<cfset Session.PlayDirection = 'RIGHT'>
					</cfif>
					<cfif #ii# is 5>
						<cfset Session.PlayDirection = 'LEFT'>
					</cfif>
					<cfif #ii# is 6>
						<cfset Session.PlayDirection = 'MIDDLE'>
					</cfif>
					<cfif #ii# is 7>
						<cfset Session.PlayDirection = 'RIGHT'>
					</cfif>
					<cfif #ii# is 8>
						<cfset Session.PlayDirection = 'LEFT'>
					</cfif>
					<cfif #ii# is 9>
						<cfset Session.PlayDirection = 'MIDDLE'>
					</cfif>
					<cfif #ii# is 10>
						<cfset Session.PlayDirection = 'RIGHT'>
					</cfif>
					<cfif #ii# is 11>
						<cfset Session.PlayDirection = 'LEFT'>
					</cfif>
					<cfif #ii# is 12>
						<cfset Session.PlayDirection = 'MIDDLE'>
					</cfif>
				
					<cfif #ii# is 13>
						<cfset Session.PlayType = 'INTERCEPTION'>
					</cfif>
				
					<cfif #ii# is 14>
						<cfset Session.PlayType = 'SACK'>
					</cfif>
				
										
					<cfif #ii# lt 4>
						<cfset Session.PlayDepth = 'SHORT'>
					</cfif>
					
					<cfif #ii# gte 4 and #ii# lte 6>
						<cfset Session.PlayDepth = 'DEEP'>
					</cfif>
					
					<cfif #ii# gt 6 and #ii# lte 9>
						<cfset Session.PlayDepth = 'SHORT'>
					</cfif>
					
					<cfif #ii# gt 9 and #ii# lte 12>
						<cfset Session.PlayDepth = 'DEEP'>
					</cfif>
					
				</cfif>
			
			</cfloop>
		</cfif>
	</cfif>

	<cfif Found is 'N'>

		<!-- Run Play? -->
		<cfset Run1 = 'left tackle'>
		<cfset Run2 = 'right tackle'>
		<cfset Run3 = 'left guard'>
		<cfset Run4 = 'right guard'>
		<cfset Run5 = 'up the middle'>
		<cfset Run6 = 'kneels'>
		<cfset Run7 = 'left end'>
		<cfset Run8 = 'right end'>
		<cfset Run9 = 'scrambles'>
		<cfset Run10 = 'FUMBLE'>
		


		<cfset Session.PlayDirection = ''>
		<cfset Session.PlayDepth = ''>
		<cfset Session.PlayType = 'Run'>
		
		<!-- Run Play -->
		<cfloop index="ii" from="1" to="10">
			<cfset run = 'Run' & '#ii#'>
			<cfset check = evaluate('#run#')>
				
			<cfif Find(#check#,'#Arguments.play#') gt 0>
				
				<cfset Found = 'Y'>
				<cfset Session.PlayType = 'Run'>
				<cfif #ii# is 1>
						<cfset Session.PlayDirection = 'LEFT'>
				</cfif>
				<cfif #ii# is 2>
						<cfset Session.PlayDirection = 'RIGHT'>
				</cfif>
				<cfif #ii# is 3>
						<cfset Session.PlayDirection = 'LEFT'>
				</cfif>
				<cfif #ii# is 4>
						<cfset Session.PlayDirection = 'RIGHT'>
				</cfif>
				<cfif #ii# is 5>
						<cfset Session.PlayDirection = 'MIDDLE'>
				</cfif>
				<cfif #ii# is 6>
						<cfset Session.PlayDirection = 'MIDDLE'>
				</cfif>
				<cfif #ii# is 7>
						<cfset Session.PlayDirection = 'LEFT'>
				</cfif>
				<cfif #ii# is 8>
						<cfset Session.PlayDirection = 'RIGHT'>
				</cfif>

			</cfif>
		</cfloop>
	</cfif>
		
		<cfset Session.YardsGained = val(parseit('#arguments.Play#',1,'for ',' yard'))>
		
</cffunction>


<cffunction name="FindStringInPage" access="remote" output="yes" returntype="Numeric">
	-- Returns the position of where the string was found	
	<cfargument name="LookFor"              type="String"  required="yes" />
	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />

	<cfset FoundStringPos = FINDNOCASE('#arguments.LookFor#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  	

	<cfreturn #FoundStringPos# >

</cffunction>


<cffunction name="ParseIt" access="remote" output="yes" returntype="String">

	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />
	<cfargument name="LeftSideString"       type="String"  required="yes" />
	<cfargument name="RightSideString"      type="String"  required="yes" />
 
	<cfif 1 is 2>
	<cfoutput>
	Search on #arguments.theViewSourcePage# for Leftside:  #arguments.LeftsideString# at spot #arguments.startLookingPosition#<br>
	</cfoutput>
	</cfif>
 
	<cfset posOfLeftsidestring = FINDNOCASE('#arguments.LeftSideString#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  
	
	<cfif 1 is 2>
	<cfoutput>
	posOfLeftsidestring = #posOfLeftsidestring#
	</cfoutput>
	</cfif>	
		
	<cfset LengthOfLeftSideString = LEN('#arguments.LeftSideString#')>

	<cfset posOfRightsidestring    = FINDNOCASE('#arguments.RightSideString#','#arguments.theViewSourcePage#',#posOfLeftsidestring# +1)>  	
	<cfset LengthOfRightSideString = LEN('#arguments.RightSideString#')>

	<cfif 1 is 2>
	<cfoutput>
	Search on #arguments.theViewSourcePage# for Rightside: #arguments.RightsideString# at spot #posOfLeftsidestring# +1 <br>
	</cfoutput>
	</cfif>

	<p>
	
	<cfif 1 is 2>
	<cfoutput>
	posOfRightsidestring = #posOfRightsidestring#
	</cfoutput>
	</cfif>
	
	<cfif posOfRightsidestring neq 0 and posOfleftsidestring neq 0>
		
		<cfset StartParsePos = posOfLeftsidestring  + LengthOfLeftSideString>
		<cfset EndParsePos   = posOfRightsidestring>
		<cfset LenOfParseVal = (#EndParsePos# - #StartParsePos#)>
		
		<cfset parseVal = Mid('#arguments.theViewSourcePage#',#StartParsePos#,#LenOfParseVal#)>

		<cfif 1 is 1>
		<cfoutput>
		StartParsePos = #startparsepos#><br>
		EndParsePos   = #endparsepos#><br>
		LenOfParseVal = #LenOfParseVal#><br>
		parseVal=#parseVal#	<br>
		</cfoutput>
		</cfif>
	
	<cfelse>
		<cfset parseVal = '0'>
	</cfif>

	
	<cfreturn '#parseVal#'>

</cffunction>

<cffunction name="lookupstat" access="remote" output="yes" returntype="String">
		
	<cfargument name="LookForPos"              type="Numeric"  required="yes" />
	
	<cfquery datasource="sysstats3" name="findit">
	Select MIN(Statpos) as TheStatPos from PBPStatLocation
	where statPos > #arguments.LookforPos#  
	</cfquery>


	<cfset temp = adddebug('Min(Statpos) is',#Findit.TheStatPos#)> 

	<cfquery datasource="sysstats3" name="findit2">
	Select opp from PBPStatLocation
	where statPos = #Findit.TheStatPos#   
	</cfquery>

	<cfset temp = adddebug('The opp for this StatPos is #Findit2.opp#')> 

	<cfreturn '#Findit2.opp#' >

</cffunction>


<cffunction name="addDebug" access="remote" output="yes" returntype="Void">
	<cfargument name="debugdesc"   type="String"  required="yes" />
	<cfargument name="debugnumval" type="Numeric"  required="no" default=0/>
	
	<cfquery datasource="sysstats3" name="addit">
	INSERT INTO Debug(Stringval,Numval) VALUES ('#arguments.debugdesc#',#arguments.debugnumval#)
	</cfquery>

</cffunction>




	