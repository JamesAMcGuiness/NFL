
<cfset theWeek = getSpdWeek()>

<cfset getGames = getGames(#theweek#)>

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
	
	<cfset theURL = 'https://www.pro-football-reference.com/boxscores/#GameTime#0#HomeconvertedName#.htm##all_team_stats'>
	
	
	
	<p>
	<cfoutput>
	The URL is #theURL#
	</cfoutput>
	<p>

	

	<cfhttp url="#theurl#" method="GET">
	</cfhttp> 

<cfset mypage = #cfhttp.FileContent#>



<cfset theViewSourcePage    = '#myPage#'>
<cfset LookFor              = 'Advanced Passing Table'>
<cfset startLookingPosition = 1>

<cfset AdvancedPassingPagePos = FindStringInPage('#theViewSourcePage#','#LookFor#',#startLookingPosition#)>

<cfset LookFor              = 'Player</th>'>
<cfset AwayPlayerPos = FindStringInPage('#theViewSourcePage#','#LookFor#',#AdvancedPassingPagePos#)>
<cfset HomePlayerPos = FindStringInPage('#theViewSourcePage#','#LookFor#',#Session.LastPosFound# + 10)>

<p>
<cfoutput>
away: #AwayPlayerPos#<br>
home: #HomePlayerPos#
</cfoutput>
<p>


--Get all the QB stats for the away team
<cfset LookFor              = 'data-stat="pass_pressured_pct" >'>
<cfset qb = 1>
<cfset awayct = 0>
<cfset homect = 0>
<cfset awayQB = arraynew(1)>
<cfset homeQB = arraynew(1)>
<cfset Session.LastPosFound = 1>


<cfset Session.LastPosFound = AwayPlayerPos>
<cfloop condition="QB lt HomePlayerPos and QB neq 0">

	<cfset QB = FindStringInPage('#theViewSourcePage#','#LookFor#',#Session.LastPosFound#)>

	<cfoutput>******QB stat found #qb# </cfoutput><br>

	<cfif QB gt 0 and QB lt HomePlayerPos>
		<cfif QB lt HomePlayerPos>
			<cfset awayct = awayct + 1>
			<cfset awayQB[awayct] = #QB#>
			<cfset Session.LastPosFound = Session.LastPosFound + 10>
			<p>
			<cfoutput>
			QB Away:#awayQB[awayct]#
			</cfoutput>
		
		<cfelse>
			<cfset homect = homect + 1>
			<cfset homeQB[homect] = #QB#>
			<cfset Session.LastPosFound = Session.LastPosFound + 10>
			<p>
			<cfoutput>
			QB Home: #homeQB[homect]#
			</cfoutput>
		
		
		</cfif>
		
		
	<cfelse>

		<cfset homect = homect + 1>
		<cfset homeQB[homect] = #QB#>
		<cfset Session.LastPosFound = Session.LastPosFound + 10>
		<p>
		<cfoutput>
		QB Home: #homeQB[homect]#
		</cfoutput>
		
	</cfif>	
	
</cfloop>

<cfset theViewSourcePage    = '#myPage#'>
<cfset LookFor              = 'pass_pressured_pct'>
<cfset startLookingPosition = 1>

<cfset FoundInPagePos       = FindStringInPage('#theViewSourcePage#','#LookFor#',#startLookingPosition#)>

<cfset Done = false>
<cfset Playct = 0>

<cfset awaypressurepct = 0>
<cfset homepressurepct = 0>
<cfset totalawaypressurepct = 0>
<cfset totalhomepressurepct = 0>
<cfset awayct = 0>
<cfset homect = 0>

<cfoutput>
awayQB len of array is #arraylen(awayQB)#
</cfoutput>

<cfloop index="i" from="1" to="#arraylen(awayQB)#">
	In Away loop outter<br>	
	<cfloop condition="done is false">
			<cfoutput>
			In Away loop inner i = #i#<br>
			</cfoutput>
			
			<cfset LeftSide = '"pass_pressured_pct" >'>
			<cfset RightSide = "</td>">
			<cfset awaypressurepct = ParseIt('#mypage#',#awayQB[i]#,'#Leftside#','#RightSide#')>
			<cfset totalawaypressurepct = totalawaypressurepct + val(awaypressurepct)>

			<cfset awayct = awayct +1>

			<p>
			<cfoutput>totalawaypressurepct = #totalawaypressurepct#</cfoutput>
			<br>
			<cfset done = true>
						
	</cfloop>
	<cfset done = false>
</cfloop>			
		
<cfset HomePressurepct = 0>		
<cfset homect = 0>		
<cfset done = false>		
<cfloop index="i" from="1" to="#arraylen(homeQB)#">
	In Home loop outter<br>	
	<cfloop condition="done is false">
		<cfset homect = Homect +1>
		In Home loop inner<br>
			<cfset LeftSide = '"pass_pressured_pct" >'>
			<cfset RightSide = "</td>">
			<cfset HomePressurepct = ParseIt('#mypage#',#homeQB[i]#,'#Leftside#','#RightSide#')>
			<cfset totalhomepressurepct = totalhomepressurepct + val(homepressurepct)>

			<p>
			<cfoutput>TotalHomepressurepct = #totalhomepressurepct#</cfoutput>
			<br>
			<cfset done = true>

	</cfloop>
	<cfset done = true>
</cfloop>



			<cfif awayct gt 0 and homect gt 0>
			<cfquery name="UpdPressure" datasource="sysstats3">
			Update Sysstats
				SET PressureRate  = #totalawaypressurepct/awayct#,
					dPressureRate = #totalhomepressurepct/homect#
			WHERE Week = #theweek#
			AND Team = '#AwayTeam#'
			</cfquery>
			
			<cfquery name="UpdPressure" datasource="sysstats3">
			Update Sysstats
				SET PressureRate  = #totalhomepressurepct/homect#,
					dPressureRate = #totalawaypressurepct/awayct#
			WHERE Week = #theweek#
			AND Team = '#HomeTeam#'
			</cfquery>
			</cfif>	

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

	<cfset Session.LastPosFound = FoundStringPos>

	<cfreturn #FoundStringPos# >

</cffunction>


<cffunction name="ParseIt" access="remote" output="yes" returntype="String">

	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />
	<cfargument name="LeftSideString"       type="String"  required="yes" />
	<cfargument name="RightSideString"      type="String"  required="yes" />
 
	<cfset posOfLeftsidestring = FINDNOCASE('#arguments.LeftSideString#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  
	
	<cfif 1 is 1>
	<cfoutput>
	posOfLeftsidestring = #posOfLeftsidestring#
	</cfoutput>
	</cfif>	
		
	<cfset LengthOfLeftSideString = LEN('#arguments.LeftSideString#')>

	<cfset posOfRightsidestring    = FINDNOCASE('#arguments.RightSideString#','#arguments.theViewSourcePage#',#posOfLeftsidestring#)>  	
	<cfset LengthOfRightSideString = LEN('#arguments.RightSideString#')>

	<cfif 1 is 1>
	<p>
	
	<cfoutput>
	posOfRightsidestring = #posOfRightsidestring#
	</cfoutput>
	</cfif>
	
	<cfset StartParsePos = posOfLeftsidestring  + LengthOfLeftSideString>
	<cfset EndParsePos   = posOfRightsidestring>
 	<cfset LenOfParseVal = (#EndParsePos# - #StartParsePos#)>
	
	<cfif 1 is 1>
	<cfoutput>
	StartParsePos = #startparsepos#><br>
	EndParsePos   = #endparsepos#><br>
 	LenOfParseVal = #LenOfParseVal#><br>
		
	</cfoutput>
	</cfif>
	
	
	<cfset Session.LastPosFound = posOfLeftsidestring>
	<cfset parseVal = Mid('#arguments.theViewSourcePage#',#StartParsePos#,#LenOfParseVal#)>
	<p>
	<cfoutput>Parseval is #parseVal#</cfoutput>
	<p>
	
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
	
    <cfset lookfor = '#arguments.theTeam# Snap Counts'>

	<cfoutput>
	Looking for #lookfor#
	</cfoutput>
	<p>			
		
	<cfset FindFirstPos = FindNoCase('#lookfor#','#arguments.thePage#',1)>
	
	<cfset lookfor      = '<th scope="row"'>
	
	
	<cfif arguments.HorA is 'H'>
		
		
		<cfset Session.HomeTeamMemberStartPos = FindNoCase('#lookfor#','#arguments.thePage#',#FindFirstPos#)>
		<cfset Session.HomeTeamMemberEndpos   = FindNoCase('</tbody>','#arguments.thePage#',#Session.HomeTeamMemberStartPos#)>	
	<cfelse>
	
		
		<cfset Session.AwayTeamMemberStartPos = FindNoCase('#lookfor#','#arguments.thePage#',#FindFirstPos#)>
		<cfset Session.AwayTeamMemberEndpos   = FindNoCase('</tbody>','#arguments.thePage#',#Session.AwayTeamMemberStartPos#)>	
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

