
<cfset theWeek = getSpdWeek()>
<cfset getGames = getGames(#theweek#)>

<cfdump var='#getGames#'>



<!--- For each game get PBP Data --->
<cfloop query="#getGames#">
		
	<cfset Session.HomeScore             =  0>
	<cfset Session.AwayScore             =  0>
	<cfset Session.GameScoreDifferential = 	0>
	<cfset TheHomeScore = 0>
	<cfset TheAwayScore = 0>		
	
	<cfif HA is 'H'>
		<cfset HomeTeam = '#fav#'>
		<cfset AwayTeam = '#und#'>	
		
		<cfset HomeNameForTeamSnap = '#FavLastName#'>
		<cfset AwayNameForTeamSnap = '#UndLastName#'>
		
		
		<cfset HomeconvertedName = lcase(ConvertTeamName('#fav#'))>
		<cfset AwayconvertedName = lcase(ConvertTeamName('#und#'))>
	<cfelse>
	
		<cfset HomeNameForTeamSnap = '#UndLastName#'>
		<cfset AwayNameForTeamSnap = '#FavLastName#'>
	
		<cfset HomeTeam = '#und#'>
		<cfset AwayTeam = '#fav#'>
		
		<cfset HomeconvertedName = lcase(ConvertTeamName('#und#'))>
		<cfset AwayconvertedName = lcase(ConvertTeamName('#fav#'))>
	</cfif>

	<cfset Session.AwayTeamMemberStartPos = 0>
	<cfset Session.AwayTeamMemberEndpos   = 0>
	
	<cfset Session.HomeTeamMemberStartPos = 0>
	<cfset Session.HomeTeamMemberEndpos   = 0>
	
	<cfset theURL = 'https://www.pro-football-reference.com/boxscores/#GameTime#0#HomeconvertedName#.htm'>
	
	
	
	<p>
	<cfoutput>
	The URL is #theURL#
	</cfoutput>
	<p>


<cfoutput>
		<cfhttp url="#theurl#" method="GET">
		</cfhttp> 
</cfoutput>

<cfset mypage = #cfhttp.FileContent#>


<cfset mypage = Replace('#mypage#',': ','| ','All')>


	<cfset temp = getTeamMembers('#mypage#','#AwayNameForTeamSnap#','A')>
	<cfset temp = getTeamMembers('#mypage#','#HomeNameForTeamSnap#','H')>
	

<cfset theViewSourcePage    = '#myPage#'>
<cfset LookFor              = '1st Quarter'>
<cfset startLookingPosition = 1>

<cfset FoundInPagePos       = FindStringInPage('#theViewSourcePage#','#LookFor#',#startLookingPosition#)>
<cfset EndOfGamePos         = FindStringInPage('#theViewSourcePage#','End of Regulation',#startLookingPosition#)>
<cfset EndOfOvertimePos     = FindStringInPage('#theViewSourcePage#','End of Overtime',#startLookingPosition#)>


<cfset Done = false>
<cfset Playct = 0>

<cfloop condition="done is false">

<cfif FoundInPagePos gt 0>
		
			<cfset Session.YdsMade = 0>
			<cfset Session.DIRECTIONOFPLAY = ''>
			<cfset Session.PTSFORPLAY = 0>
			<cfset Session.PlayType = ''>
			<cfset Session.DepthOfPlay=''>
			
		
			<cfset LeftSide = 'data-stat="quarter" >'>
			<cfset RightSide = "</th>">
			<cfset Qtr = ParseIt('#mypage#',#FoundInPagePos#,'#Leftside#','#RightSide#')>

			<p>
			<cfoutput>QTR = #Qtr#</cfoutput>
			<br>
			
			<cfset FoundColonInPagePos       = FindStringInPage('#theViewSourcePage#',':',#FoundInPagePos#)>
			
			
			<cfset Mins = numberformat(GetTimeOfPlay('#mypage#','MINS',#FoundColonInPagePos#),'09')>
			<cfoutput>MINS = #MINS#</cfoutput>
			<cfset Secs = numberformat(GetTimeOfPlay('#mypage#','SECS',#FoundColonInPagePos#),'09')>
			<cfoutput>SECS = #SECS#</cfoutput>
			<br>

			<cfset LeftSide = 'data-stat="down" >'>
			<cfset RightSide = "</td>">
			<cfset Down = ParseIt('#mypage#',#FoundColonInPagePos#,'#Leftside#','#RightSide#')>

			<cfoutput>Down = #Down#</cfoutput>
			<br>	

			<cfset LeftSide = 'data-stat="yds_to_go" >'>
			<cfset RightSide = "</td>">
			<cfset ToGo = ParseIt('#mypage#',#FoundColonInPagePos#,'#Leftside#','#RightSide#')>

			<cfoutput>ToGo = #ToGo#</cfoutput>	
			<br>
			
			
			<cfif Down is ''>
				<cfset Down = 0>
				<cfset ToGo = 0>
			</cfif>
			
			
			<cfset FoundDataStatInPagePos       = FindStringInPage('#theViewSourcePage#','data-stat="location"',#FoundColonInPagePos#)>
			 
			<cfset LeftSide = '>'>
			<cfset RightSide = "</td>">
			<cfset FieldLocation = ParseIt('#mypage#',#FoundDataStatInPagePos#,'#Leftside#','#RightSide#')>

			<cfoutput>FieldLocation = #FieldLocation#</cfoutput>	
			<br>		
		
			
			
			<cfset LeftSide = '<a href'>
			<cfset RightSide = "</a>">
			<cfset Player = ParseIt('#mypage#',#FoundDataStatInPagePos#,'#Leftside#','#RightSide#')>
		

			<cfset FoundahrefInPagePos       = FindStringInPage('#theViewSourcePage#','<a href',#FoundColonInPagePos#)>
			<cfset FoundEndahrefInPagePos    = FindStringInPage('#theViewSourcePage#','</a>',#FoundColonInPagePos#)> 
			 
			<cfset LeftSide = '>'>
			<cfset RightSide = "</a>">
			<cfset Player = ParseIt('#mypage#',#FoundahrefInPagePos#,'#Leftside#','#RightSide#')>

			

			<cfoutput>Player = #Player#</cfoutput>	
			<br>
		
			<cfset PlayFor = getPlayFor('#mypage#',#Session.AwayTeamMemberStartPos#,#Session.AwayTeamMemberEndPos#,#Session.HomeTeamMemberStartPos#,#Session.HomeTeamMemberEndPos#,'#Player#')>
			
			<cfoutput>PlayFor = #PlayFor#</cfoutput>	
			<br>	
					
			<cfset LeftSide = '</a>'>
			<cfset RightSide = "</td>">
			<cfset PlayDesc = ParseIt('#mypage#',#FoundahrefInPagePos#,'#Leftside#','#RightSide#')>

			<cfoutput>PlayDesc = #PlayDesc#</cfoutput>
			<br>
					
		
			<cfset BadData = false>
			<cfif FindNoCase('spiked','#PlayDesc#') is 0 and FindNoCase('PASS','#PlayDesc#') is 0 and FindNoCase('for','#PlayDesc#') is 0 and FindNoCase('kicks','#PlayDesc#') is 0 and FindNoCase('punts','#PlayDesc#') is 0 and FindNoCase('SACKed','#PlayDesc#') is 0 and FindNoCase('yard','#PlayDesc#') is 0 and FindNoCase('timeout','#PlayDesc#') is 0>
				<cfset BadData = true>
			</cfif>
		
		
			<cfif BadData is true>
				<cfoutput>
				WARNING: There is bad data for playct #playct# the Play Desc says #PlayDesc#
				</cfoutput>
				<p>
				
				<cfset FoundInPagePos = FoundColonInPagePos + 4>
				
			<cfelse>
		
				<cfset temp = CheckPlayDesc('#PlayDesc#','#playfor#')>
				
		
				<cfif 1 is 1>
		
				<cfset LeftSide = '<a href'>
				<cfset RightSide = "</a>">
				<cfset Player = ParseIt('#mypage#',#FoundahrefInPagePos# +10,'#Leftside#','#RightSide#')>


				<cfset FoundahrefInPagePos       = FindStringInPage('#theViewSourcePage#','<a href',#FoundahrefInPagePos# +10)>
				<cfset FoundEndahrefInPagePos    = FindStringInPage('#theViewSourcePage#','</a>',#FoundahrefInPagePos#)> 
				 
				<cfset LeftSide = '>'>
				<cfset RightSide = "</a>">
				<cfset IntendedPlayer = ParseIt('#mypage#',#FoundahrefInPagePos#,'#Leftside#','#RightSide#')>

				<cfoutput>Intended Player = #IntendedPlayer#</cfoutput>	
				<br>
			

				<cfset LeftSide = 'data-stat="pbp_score_aw" >'>
				<cfset RightSide = "</td>">
				<cfset AwayScore = ParseIt('#mypage#',#FoundEndahrefInPagePos#,'#Leftside#','#RightSide#')>
				<cfset Session.AwayScore = #val(AwayScore)#>

				<cfoutput>TheAwayScore = #Session.AwayScore#</cfoutput>	
				<br>

				<cfset LeftSide = 'data-stat="pbp_score_hm" >'>
				<cfset RightSide = "</td>">
				<cfset HomeScore = ParseIt('#mypage#',#FoundahrefInPagePos#,'#Leftside#','#RightSide#')>
				<cfset Session.HomeScore  = #val(HomeScore)#>

				<cfoutput>Session.HomeScore  = #Session.HomeScore#</cfoutput>	
				<br>
	
				</cfif>
	
	
				<cfset FoundInPagePos = FoundColonInPagePos + 4>
						
				<cfset Session.GameScoreDifferential = 	Session.HomeScore - Session.AwayScore>
			
			</cfif>
			
			<cfset Playct = PlayCt + 1>
			
			<cfoutput>
			FoundInPagePos is #FoundInPagePos# comapared to EndOfGamePos of #EndOfGamePos#<br>
			</cfoutput>
			
			<cfif EndOfGamePos gt EndOfOvertimePos>
			
				<cfif (FoundInPagePos gt EndOfGamePos) Or (PlayCt gt 200)>
					Setting done to true...
					<cfset Done = true>
				</cfif>	
			<cfelse>
				<cfif (FoundInPagePos gt EndOfOvertimePos) Or (PlayCt gt 200)>
					Setting done to true...
					<cfset Done = true>
				</cfif>	
			
			</cfif>
			
			
			
			<cfset RZ = 'N'>
						
			<cfif PlayFor is 'H'>
			
				<cfif #ucase(HomeconvertedName)# neq LEFT(FieldLocation,3)>
					<cfif val(right(FieldLocation,2)) lte 20>
						<cfset RZ = 'Y'>
					</cfif>
				</cfif>	
					
			
			<cfelse>
				<cfif #ucase(AwayconvertedName)# neq LEFT(FieldLocation,3)>
					<cfif val(right(FieldLocation,2)) lte 20>
						<cfset RZ = 'Y'>
					</cfif>
				</cfif>	
			
			</cfif>
			
				
			
			
			<cfoutput>
			<table border="1" width="100%" cellpadding="4" cellspacing="4" bgcolor="Yellow">
			<tr>
			<td>PlayCt</td>
			<td>QTR</td>
			<td>Time</td>
			<td>Down</td>
			<td>ToGo</td>
			<td>Location</td>
			<td>Red Zone</td>
			<td>Player</td>
			<td>Play For</td>
			<td>Play Desc</td>
			<td>Yards Gained</td>
			<td>Home Score</td>
			<td>Away Score</td>
			<td>Game Situation</td>
			</tr>	
			<tr>
			<td>#PlayCt#</td>
			<td>#QTR#</td>
			<td>#mins#:#secs#</td>
			<td>#Down#</td>
			<td>#ToGo#</td>
			<td>#FieldLocation#</td>
			<td>#RZ#</td>
			<td>#Player#</td>
			<td><cfif PlayFor is 'H'>#ucase(HomeconvertedName)#<cfelse>#ucase(AwayconvertedName)#</cfif></td>
			<td>#PlayDesc#</td>
			<td>#Session.YdsMade#</td>
			<td>#Session.HomeScore#</td>
			<td>#Session.AwayScore#</td>
			<td>#Session.GameScoreDifferential#</td>
			</tr>	
			</table>
			</cfoutput>
			
			<cfif PlayFor is 'H'>
				<cfset forteam = '#ucase(HomeconvertedName)#'>
				<cfset opp = '#ucase(AwayconvertedName)#'>
				
			<cfelse>
				<cfset forteam = '#ucase(AwayconvertedName)#'>
				<cfset opp = '#ucase(HomeconvertedName)#'>
			</cfif>
			
			<cfset IgnorePlay = 'N'>
			<cfif '#PlayDesc#' is '' or Findnocase('kneels','#playdesc#') gt 0 or Findnocase('spike','#playdesc#') gt 0 or Session.PlayType is 'NOPLAY'>
				<cfset IgnorePlay = 'Y'>
			</cfif>
			
			
			<cfif '#playfor#' is 'H'>
				<cfset StatsFor    = '#HomeTeam#'>
				<cfset oppStatsFor = '#AwayTeam#'>
				<cfset ptsfor      = Session.HomeScore>
				<cfset ptsagainst  = Session.AwayScore>
				
			<cfelse>
				<cfset StatsFor    = '#AwayTeam#'>
				<cfset oppStatsFor = '#HomeTeam#'>
				<cfset ptsfor      = Session.AwayScore>
				<cfset ptsagainst  = Session.HomeScore>
				
			</cfif>	
				
			
			<cfquery name="AddPlay" datasource="sysstats3">
			INSERT INTO PlayByPlayData(PtsScored,OppPtsScored,IgnorePlay,Team,PlayDesc,Quarter,TimeOfPlay,Down,ToGo,FieldPosition,Opponent,Yards,ScoreDifferential,Direction,OffDef,Week,Pts,RedZone_Flag,GameSituation,Player,PlayCt,MIN,SEC,PLAYTYPE,PlayDepth)
			values(#ptsfor#,#ptsagainst#,'#IgnorePlay#','#Statsfor#','#PlayDesc#','#QTR#','#mins#:#secs#',#Down#,#ToGo#,'#FieldLocation#','#oppStatsFor#',#Session.YdsMade#,#Session.GameScoreDifferential#,'#Session.DirectionOfPlay#','O',#week#,#Session.PtsForPlay#,'#rz#',#Session.GameScoreDifferential#,'#player#',#playct#,#val(Mins)#,#val(secs)#,'#Session.PLAYTYPE#','#Session.DepthOfPlay#')
			</cfquery>
			
			
			<cfquery name="AddPlay" datasource="sysstats3">
			INSERT INTO PlayByPlayData(PtsScored,OppPtsScored,IgnorePlay,Team,PlayDesc,Quarter,TimeOfPlay,Down,ToGo,FieldPosition,Opponent,Yards,ScoreDifferential,Direction,OffDef,Week,Pts,RedZone_Flag,GameSituation,Player,PlayCt,MIN,SEC,PLAYTYPE,PlayDepth)
			values(#PtsFor#,#ptsagainst#,'#IgnorePlay#','#oppStatsFor#','#PlayDesc#','#QTR#','#mins#:#secs#',#Down#,#ToGo#,'#FieldLocation#','#Statsfor#',#Session.YdsMade#,#Session.GameScoreDifferential#,'#Session.DirectionOfPlay#','D',#week#,#Session.PtsForPlay#,'#rz#',#Session.GameScoreDifferential#,'#player#',#playct#,#val(Mins)#,#val(secs)#,'#Session.PLAYTYPE#','#Session.DepthOfPlay#')
			</cfquery>
			
			<cfquery name="UpdGarbage" datasource="sysstats3">
			UPDATE PlayByPlayData
			SET GarbageTime_Flag = 'Y', IGNOREPLAY='Y'
			WHERE (ScoreDifferential >= 8 or ScoreDifferential <= -8)
			AND Quarter = '4'
			AND MIN <= 2
			AND week = #week#
			</cfquery>
			
			<cfquery name="UpdGarbage" datasource="sysstats3">
			Update PlayByPlayData
				SET PTS = 2 
			WHERE PlayDesc like ('%conversion succ%')
			</cfquery>
			
	 
</cfif>
</cfloop>
<cfset Done = false>

</cfloop>

















<cffunction name="getGames" output="false" access="public" returnType="query">
    <cfargument name="week"         type="numeric" required="false"  />
	
	<cfif isdefined("arguments.week")>
		<cfset theWeek = #arguments.week#>
	<cfelse>	
		<cfset theWeek = getSpdWeek()> 
    </cfif>
	
    <cfquery name="getGames" datasource="Sysstats3">
        SELECT n.*,f.LastName as FavLastName, u.LastName as UndLastName
        FROM NFLSPDS n, Teams f, Teams u
        WHERE week = #theWeek#
			AND (n.Fav = f.Team)
			AND (n.Und = u.Team)
			AND f.Team not in (Select Team from PlayByPlayData where week = #theweek#)
    </cfquery>
    
    <cfreturn getGames>
	
</cffunction>


<cffunction name="getSpdWeek" output="false" access="public" returnType="numeric">

    <cfquery name="getWeek" datasource="sysstats3">
        SELECT Week as theweek
        FROM Week
    </cfquery>

    <cfset RetVal = #getWeek.theWeek#>
    
    <cfreturn RetVal />
    
</cffunction>


<cffunction name="FindStringInPage" access="remote" output="yes" returntype="Numeric">
	-- Returns the position of where the string was found	
	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="LookFor"              type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />

	<cfset FoundStringPos = FINDNOCASE('#arguments.LookFor#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  	

	<cfreturn #FoundStringPos# >

</cffunction>


<cffunction name="ParseIt" access="remote" output="yes" returntype="String">

	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />
	<cfargument name="LeftSideString"       type="String"  required="yes" />
	<cfargument name="RightSideString"      type="String"  required="yes" />
 
	<cfset posOfLeftsidestring = FINDNOCASE('#arguments.LeftSideString#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  
	
	<cfif 1 is 2>
	<cfoutput>
	posOfLeftsidestring = #posOfLeftsidestring#
	</cfoutput>
	</cfif>	
		
	<cfset LengthOfLeftSideString = LEN('#arguments.LeftSideString#')>

	<cfset posOfRightsidestring    = FINDNOCASE('#arguments.RightSideString#','#arguments.theViewSourcePage#',#posOfLeftsidestring#)>  	
	<cfset LengthOfRightSideString = LEN('#arguments.RightSideString#')>

	<cfif 1 is 2>
	<p>
	
	<cfoutput>
	posOfRightsidestring = #posOfRightsidestring#
	</cfoutput>
	</cfif>
	
	<cfset StartParsePos = posOfLeftsidestring  + LengthOfLeftSideString>
	<cfset EndParsePos   = posOfRightsidestring>
 	<cfset LenOfParseVal = (#EndParsePos# - #StartParsePos#)>
	
	<cfif 1 is 2>
	<cfoutput>
	StartParsePos = #startparsepos#><br>
	EndParsePos   = #endparsepos#><br>
 	LenOfParseVal = #LenOfParseVal#><br>
		
	</cfoutput>
	</cfif>
	
	
	<cfset parseVal = Mid('#arguments.theViewSourcePage#',#StartParsePos#,#LenOfParseVal#)>
	
	
	<cfreturn parseVal>

</cffunction>


<cffunction name="GetTimeOfPlay" access="remote" output="yes" returntype="Numeric">
	-- Returns the position of where the string was found	
	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="MINORSEC"             type="String"  required="yes" />
	<cfargument name="startPosition"        type="Numeric" required="yes" />
	
	<cfif '#arguments.MinOrSec#' is 'MINS'>
		<cfset FoundString = MID('#arguments.theViewSourcePage#',arguments.startPosition - 2,2)>  	
	<cfelse>
		<cfset FoundString = MID('#arguments.theViewSourcePage#',arguments.startPosition + 1,2)>  
	</cfif>

	<cfif Findnocase('>','#FoundString#') gt 0>
		<cfset FoundString = MID('#Foundstring#',2,1)>
	</cfif>	



	<cfoutput>
	*****Foundstring is #FoundString#
	</cfoutput>
	<br>
	
	<cfreturn #val(FoundString)# >

</cffunction>



<cffunction name="CheckPlayDesc" access="remote" output="yes" returntype="Void">
	-- Returns the position of where the string was found	
	<cfargument name="thePlay"    type="String"  required="yes" />
	<cfargument name="PlayFor"    type="String"  required="no" />


	<cfset Session.YardsGained     = 0>
	<cfset Session.DirectionOfPlay = "">
	<cfset Session.DepthOfPlay     = "">
	<cfset Session.PlayType        = "">
	<cfset Session.PtsForPlay      = 0>
		
	<cfset passArray = ArrayNew(1)>
	<cfset runArray  = ArrayNew(1)>
	<cfset kickArray = ArrayNew(1)>
	
	
	<cfset passArray[1]  = 'pass incomplete deep right'>
	<cfset passArray[2]  = 'pass incomplete deep left'>
	<cfset passArray[3]  = 'pass incomplete deep middle'>
	<cfset passArray[4]  = 'pass incomplete short right'>
	<cfset passArray[5]  = 'pass incomplete short left'>	
	<cfset passArray[6]  = 'pass incomplete short middle'>	
	
	<cfset passArray[7]  = 'pass complete short left'>	
	<cfset passArray[8]  = 'pass complete short right'>	
	<cfset passArray[9]  = 'pass complete short middle'>	
	<cfset passArray[10]  = 'pass complete deep left'>	
	<cfset passArray[11]  = 'pass complete deep right'>	
	<cfset passArray[12]  = 'pass complete deep middle'>	
	
	<cfset passArray[13] = 'SACKed'>	
	<cfset passArray[14] = 'intercepted'>
	<cfset passArray[15] = 'spiked'>
	
	
	<cfset runArray[1]  = 'up the middle'>
	<cfset runArray[2]  = 'left end'>
	<cfset runArray[3]  = 'left guard'>
	<cfset runArray[4]  = 'left tackle'>
	<cfset runArray[5]  = 'right end'>
	<cfset runArray[6]  = 'right guard'>
	<cfset runArray[7]  = 'right tackle'>
	
	<cfset kickArray[1] = 'punts'>
	<cfset kickArray[2] = 'kicks extra point good'>
	<cfset kickArray[3] = 'kicks extra point no good'>
	<cfset kickArray[4] = 'kicks off'>
	<cfset kickArray[5] = 'field goal no good'>
	<cfset kickArray[6] = 'field goal good'>
	<cfset kickArray[7] = 'kicks onside'>	
	<cfset kickArray[8] = 'conversion succeeds'>	
		
	<cfoutput>Checking Play: CheckPlayDesc	= '#arguments.thePlay#'</cfoutput>
	<p>
	

	<cfif FindNoCase('Timeout','#arguments.thePlay#') gt 0>
			 
			<cfset Session.PlayType        = "TIMEOUT">
			<cfset Session.DepthOfPlay     = "">
			<cfset Session.COMPLETE        = "">
			<cfset PlayFound = 'Y'>
	</cfif>
	
		
	<cfset PlayFound = 'N'>
	<cfloop index="x" from="1" to="15">
		<cfif PlayFound is 'N'>
			<cfif FindNoCase('#passArray[x]#','#arguments.thePlay#')>
				<cfset Session.PlayType        = "PASS">
				<cfset PlayFound               = 'Y'>
				
				<cfif x is 1>
					<cfset Session.DirectionOfPlay = "RIGHT">
					<cfset Session.DepthOfPlay     = "DEEP">
					<cfset Session.COMPLETE        = "N">
					Pass Deep Right - INCOMPLETE<br>
					
				<cfelseif x is 2>
					<cfset Session.DirectionOfPlay = "LEFT">
					<cfset Session.DepthOfPlay     = "DEEP">
					<cfset Session.COMPLETE        = "N">
					Pass Deep Left - INCOMPLETE<br>
					
				<cfelseif x is 3>
					<cfset Session.DirectionOfPlay = "MIDDLE">
					<cfset Session.DepthOfPlay     = "DEEP">
					<cfset Session.COMPLETE        = "N">
					Pass Deep Middle - INCOMPLETE<br>
					
					
				<cfelseif x is 4>
					<cfset Session.DirectionOfPlay = "RIGHT">
					<cfset Session.DepthOfPlay     = "SHORT">
					<cfset Session.COMPLETE        = "N">
					Pass Short Right - INCOMPLETE<br>
					
				<cfelseif x is 5>
					<cfset Session.DirectionOfPlay = "LEFT">
					<cfset Session.DepthOfPlay     = "SHORT">
					<cfset Session.COMPLETE        = "N">
					Pass Short Left - INCOMPLETE<br>
					
				<cfelseif x is 6>
					<cfset Session.DirectionOfPlay = "MIDDLE">
					<cfset Session.DepthOfPlay     = "SHORT">
					<cfset Session.COMPLETE        = "N">
					Pass Short Middle - INCOMPLETE<br>
					
					
				<cfelseif x is 7>
					<cfset Session.DirectionOfPlay = "LEFT">
					<cfset Session.DepthOfPlay     = "SHORT">
					<cfset Session.COMPLETE        = "Y">	
					Pass Short Left - COMPLETE<br>
					
					
				<cfelseif x is 8>
					<cfset Session.DirectionOfPlay = "RIGHT">
					<cfset Session.DepthOfPlay     = "SHORT">
					<cfset Session.COMPLETE        = "Y">	
					Pass Short Right - COMPLETE<br>
					
					
				<cfelseif x is 9>
					<cfset Session.DirectionOfPlay = "MIDDLE">
					<cfset Session.DepthOfPlay     = "SHORT">
					<cfset Session.COMPLETE        = "Y">
					Pass Short Middle - COMPLETE<br>
					
					
				<cfelseif x is 10>
					<cfset Session.DirectionOfPlay = "LEFT">
					<cfset Session.DepthOfPlay     = "DEEP">
					<cfset Session.COMPLETE        = "Y">
					Pass Deep Left - COMPLETE<br>
					
					
				<cfelseif x is 11>
					<cfset Session.DirectionOfPlay = "RIGHT">
					<cfset Session.DepthOfPlay     = "DEEP">
					<cfset Session.COMPLETE        = "Y">
					Pass Deep Right - COMPLETE<br>
					
					
				<cfelseif x is 12>
					<cfset Session.DirectionOfPlay = "MIDDLE">
					<cfset Session.DepthOfPlay     = "DEEP">
					<cfset Session.COMPLETE        = "Y">
					Pass Deep Middle - COMPLETE<br>
					
				<cfelseif x is 13>
					<cfset Session.DirectionOfPlay = "">
					<cfset Session.DepthOfPlay     = "">
					<cfset Session.COMPLETE        = "SACK">	
					<cfset Session.PlayType        = "SACK">
					SACK!<br>
					
					
				<cfelseif x is 14>
					<cfset Session.DirectionOfPlay = "">
					<cfset Session.DepthOfPlay     = "">
					<cfset Session.COMPLETE        = "INT">	
					<cfset Session.PlayType        = "INTERCEPTION">
					INT!<br>
					
				<cfelseif x is 15>
					<cfset Session.DirectionOfPlay = "">
					<cfset Session.DepthOfPlay     = "">
					<cfset Session.COMPLETE        = "SPIKE">	
					Spiked the ball<br>	
					
					
				</cfif>
			</cfif>
		</cfif>	
	</cfloop>	
		
	<cfif PlayFound is 'N'>		
		<cfloop index="x" from="1" to="7">		
			<cfif PlayFound is 'N'>
				<cfif FindNoCase('#runArray[x]#','#arguments.thePlay#')>
					<cfset Session.PlayType        = "RUN">
					<cfset Session.DepthOfPlay     = "">
					<cfset Session.COMPLETE        = "">
					<cfset PlayFound = 'Y'>
					
					<cfif x is 1>
						<cfset Session.DirectionOfPlay = "MIDDLE">
						Run Middle<br>
						
					<cfelseif x is 2>
						<cfset Session.DirectionOfPlay = "LEFT">
						Run Left<br>
						
					<cfelseif x is 3>
						<cfset Session.DirectionOfPlay = "LEFT">
						Run Left<br>
					<cfelseif x is 4>
						<cfset Session.DirectionOfPlay = "LEFT">
						Run Left<br>
					<cfelseif x is 5>
						<cfset Session.DirectionOfPlay = "RIGHT">
						Run Right<br>
					<cfelseif x is 6>
						<cfset Session.DirectionOfPlay = "RIGHT">
						Run Right<br>
					<cfelseif x is 7>
						<cfset Session.DirectionOfPlay = "RIGHT">
						Run Right<br>
					</cfif>
				</cfif>
			</cfif>
		</cfloop>		
	</cfif>		
	
	<cfif FindNoCase('no play','#arguments.thePlay#') or FindNoCase('kneels','#arguments.thePlay#')>
		<cfset Session.PlayType        = "NOPLAY">
		<cfset Session.DepthOfPlay     = "">
		<cfset Session.COMPLETE        = "">
		<cfset PlayFound               = 'Y'>
		No Play<br>
	</cfif>
		
	<cfif PlayFound is 'N'>		
		<cfloop index="x" from="1" to="8">	
			<cfif PlayFound is 'N'>
				<cfif FindNoCase('#kickArray[x]#','#arguments.thePlay#')>
					
					<cfset Session.DepthOfPlay     = "">
					<cfset Session.COMPLETE        = "">
					<cfset PlayFound = 'Y'>
					
					<cfif x is 1>
						<cfset Session.PlayType        = "PUNT">
						Punt<br>
					<cfelseif x is 2>
						<cfset Session.PlayType        = "EXTRAPOINTGOOD">
						<cfset Session.PtsForPlay      = 1>
 						Extra Point is GOOD!<br>
					<cfelseif x is 3>
						<cfset Session.PlayType        = "EXTRAPOINTNOGOOD">
						Extra Point is NO GOOD!<br>
					<cfelseif x is 4>
						<cfset Session.PlayType        = "KICKOFF">
						Kick off<br>
					<cfelseif x is 5>
						<cfset Session.PlayType        = "FGAMISS">
						Filed Goal MISSED!<br>
					<cfelseif x is 6>
						<cfset Session.PlayType        = "FGAMAKE">
						<cfset Session.PtsForPlay      = 3>
						Filed Goal Made!<br>
					
					<cfelseif x is 7>
						<cfset Session.PlayType        = "ONSIDEKICK">
						Onside Kick<br>
					
					<cfelseif x is 8>
						<cfset Session.PlayType        = "TWOPTCONVERSION">
						<cfset Session.PtsForPlay      = 2>
						Onside Kick<br>
					</cfif>
					
					
				</cfif>	
			</cfif>	
		</cfloop>	
	</cfif>

	<cfset Session.YdsMade = 0>
	<cfif Session.PlayType neq 'NOPLAY'>
		<cfif FindNoCase('Touchdown','#arguments.thePlay#') gt 0> 	
			<cfset Session.PtsForPlay = 6>	
		</cfif>
		
		<cfif Session.PlayType IS 'RUN' or Session.PlayType IS 'PASS'>
			<cfset theyard = FindNoCase(' yard','#arguments.thePlay#')>
			<cfif theyard gt 0>
				<cfset thefor = FindNoCase(' for ','#arguments.thePlay#')> 
					
				<cfif thefor gt 0>
					<cfset thelen = theyard - thefor>
					<cfset Session.YdsMade = mid('#arguments.thePlay#',thefor,#thelen#)>		
				</cfif>
			</cfif>
		</cfif>	
	</cfif>		
	
		
		
	
	
	<cfif Session.PlayType is ''>
		<cfset forfound  = FindNoCase('for ','#arguments.thePlay#')>
		<cfset yardfound = FindNoCase(' yard','#arguments.thePlay#')>
		<cfset ydslen = Yardfound - forfound>
		
		<cfif forfound gt 0 and yardfound gt 0>
			<cfset theyds = mid('#arguments.theplay#',#forfound# + 5,#ydslen# -1)> 
			<cfset Session.PlayType        = "RUN">
			<cfset Session.DepthOfPlay     = "">
			<cfset Session.COMPLETE        = "">
			<cfset PlayFound = 'Y'>
		</cfif>
	</cfif>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	<cfif 1 is 2>
	<cfset Session.YdsMade = mid(Session.YdsMade,4,2)>		
	</cfif>
	Pts For Play is.... #Session.PtsForPlay#<br>
	Yds For Play is.... #Right(Session.YdsMade,2)#<br>
	
	<cfset Session.YdsMade = #Right(Session.YdsMade,2)#>
	**************************************************************************************<p><p>	
</cffunction>

<cffunction name="ConvertTeamName" access="remote" output="yes" returntype="String">
	<cfargument name="theTeam"    type="String"  required="yes" />

	<cfset passedname = '#arguments.theTeam#'>
	<cfset retval     = passedname>
	
	<cfif passedname is 'KC'>
		<cfset retval = 'KAN'>
	<cfelseif passedname is 'LAR'>
		<cfset retval = 'RAM'>	
	<cfelseif passedname is 'BAL'>
		<cfset retval = 'RAV'>
	<cfelseif passedname is 'NE'>
		<cfset retval = 'NWE'>	
	<cfelseif passedname is 'GB'> 	
		<cfset retval = 'GNB'>
	<cfelseif passedname is 'IND'> 	
		<cfset retval = 'CLT'>
	<cfelseif passedname is 'OAK'> 	
		<cfset retval = 'RAI'>
	<cfelseif passedname is 'LAC'> 	
		<cfset retval = 'SDG'>
	<cfelseif passedname is 'ARZ'> 	
		<cfset retval = 'CRD'>
	<cfelseif passedname is 'SF'> 	
		<cfset retval = 'SFO'>
	<cfelseif passedname is 'TB'> 	
		<cfset retval = 'TAM'>
	<cfelseif passedname is 'TEN'> 	
		<cfset retval = 'OTI'>
	<cfelseif passedname is 'NO'> 	
		<cfset retval = 'NOR'>	
	<cfelseif passedname is 'HOU'> 	
		<cfset retval = 'HTX'>		
	</cfif>	
	
	<cfreturn '#retval#'>	

</cffunction>


<cffunction name="getTeamMembers" access="remote" output="yes" returntype="Void">
	<cfargument name="thePage"    type="String"  required="yes" />
	<cfargument name="theTeam"    type="String"  required="yes" />
	<cfargument name="HorA"       type="String"  required="yes" />
	
	<cfif arguments.theTeam is 'Washington'>
		<cfset arguments.theTeam = 'Commanders'>
	</cfif>
	
    <cfset lookfor = '<caption>#arguments.theTeam# Snap Counts'>

	<cfoutput>
	Looking for #lookfor#
	</cfoutput>
	<p>			
		
		
		
	<cfset FindFirstPos = FindNoCase('#lookfor#','#arguments.thePage#',1)>
		
	<cfif arguments.HorA is 'H'>
		
		
		<cfset Session.HomeTeamMemberStartPos = FindNoCase('#lookfor#','#arguments.thePage#',#FindFirstPos#)>
		<cfset Session.HomeTeamMemberEndpos   = FindNoCase('</table>','#arguments.thePage#',#Session.HomeTeamMemberStartPos#)>	
	<cfelse>
	
		
		<cfset Session.AwayTeamMemberStartPos = FindNoCase('#lookfor#','#arguments.thePage#',#FindFirstPos#)>
		<cfset Session.AwayTeamMemberEndpos   = FindNoCase('</table>','#arguments.thePage#',#Session.AwayTeamMemberStartPos#)>	
	</cfif>
	
	<cfoutput>
	Session.HomeTeamMemberStartPos = #Session.HomeTeamMemberStartPos#<br>
	Session.HomeTeamMemberEndPos   = #Session.HomeTeamMemberEndPos#<br>
	Session.AwayTeamMemberStartPos = #Session.AwayTeamMemberStartPos#<br>
	Session.AwayTeamMemberEndPos   = #Session.AwayTeamMemberEndPos#<br>
	</cfoutput>
	
	
</cffunction>


<cffunction name="getPlayFor" access="remote" output="yes" returntype="String">
	<cfargument name="thePage"         type="String"   required="yes" />
	<cfargument name="AwayStartPos"    type="Numeric"  required="yes" />
	<cfargument name="AwayEndPos"      type="Numeric"  required="yes" />
	<cfargument name="HomeStartPos"    type="Numeric"  required="yes" />
	<cfargument name="HomeEndPos"      type="Numeric"  required="yes" />
	<cfargument name="lookForPlayer"   type="String"   required="yes" />
	
	<cfset findit = FindStringInPage('#arguments.thepage#','#arguments.lookforplayer#',#arguments.HomeStartPos#)>
		
	<P>
	'#arguments.lookforplayer#',#arguments.HomeStartPos#, #arguments.HomeStartPos#
	<cfoutput> FindIt = #findit# </cfoutput>
	<P>
	
	<cfset retVal = 'ERROR'>
	<cfif #findit# gte #arguments.HomeStartPos# and #findit# lte #arguments.HomeEndPos#>
		<cfset retVal = 'H'>
	<cfelseif #findit# gte #arguments.AwayStartPos# and #findit# lte #arguments.AwayEndPos#>
		<cfset retVal = 'A'>
	</cfif>
	

	<cfreturn '#retval#'>

</cffunction>

