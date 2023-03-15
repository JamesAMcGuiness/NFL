
		<cfset theweek = 69>
		
		<cfoutput>
			
			
			
			<cfhttp url="https://www.covers.com/sports/nfl/matchups" method="GET">			
			</cfhttp> 
		</cfoutput>

		<cfset mypage = #cfhttp.FileContent#>

<cfoutput>

#mypage#
</cfoutput>



	<cfset Session.LastPos = 1>
	<cfset StartPos = 1>		
	<cfset AllDone = false>	
	<cfset i = 0>
	<cfset FoundHomeTeamPos = 1>
	<cfset PreviousOddsPos = 1>
	
	
	<cfset HomeTeam = ArrayNew(1)>
	<cfset AwayTeam = ArrayNew(1)>
	<cfset spd = ArrayNew(1)>
	<cfset OU = ArrayNew(1)>
		
	<cfloop condition="alldone is false">
	
		<cfset FoundOddsPos = FindStringInPage('data-game-odd=','#mypage#',#PreviousOddsPos#)>
		
		<cfif FoundOddsPos gt 0 >

			<cfoutput>
			FoundOddsPos is #FoundOddsPos#<br>
			</cfoutput>
							
			<cfset i = i + 1>
			
			<cfset HomeTeam[i] = ParseIt('#mypage#',#FoundOddsPos#,'data-home-team-shortname-search="','"')>
			<cfset AwayTeam[i] = ParseIt('#mypage#',#FoundOddsPos#,'data-away-team-shortname-search="','"')>		
			<cfset spd[i]      = val(ParseIt('#mypage#',#FoundOddsPos#,'data-game-odd="',' data'))>
			<cfset OU[i]       = val(ParseIt('#mypage#',#FoundOddsPos#,'data-game-total="','"'))> 

			<cfdump var="#HomeTeam#">
			<cfdump var="#AwayTeam#">
			<cfdump var="#spd#">
			<cfdump var="#OU#">


			<cfif 1 is 2>
			<cfset HomeTeam[i] = replace('#HomeTeam#','"','')>
			<cfset AwayTeam[i] = replace('#AwayTeam#','"','')>
			</cfif>

			
			
			<cfset PreviousOddsPos = FoundOddsPos + 14>


		<cfelse>
			<cfset alldone = true>
			
		</cfif>

	</cfloop>		
	
	<cfset xspd = 0>
	<cfloop index="ii" from="1" to="#i#">
		<cfif spd[#ii#] lt 0>
			<cfset Favis = HomeTeam[#ii#]>
			<cfset UndIs = AwayTeam[#ii#]>
			<cfset HA = 'H'>
			<cfset xspd = abs(spd[#ii#])>
		<cfelse>
			<cfset Favis = AwayTeam[#ii#]>
			<cfset UndIs = HomeTeam[#ii#]>
			<cfset HA = 'A'>
			<cfset xspd = spd[#ii#]>
		</cfif>
		<cfset xou = OU[#ii#]>
		
		
		
			<cfif 1 is 1>

				
				
				<cfquery datasource="sysstats3" name="addit">
				INSERT INTO NFLSPDS(Gametime,FAV,HA,SPREAD,UND,WEEK,OverUnder) values ('20211127','#favis#','#Ha#',#xspd#,'#undis#',#theweek#,#xou#)
				</cfquery>


					
	
			</cfif>

		
		
	</cfloop>	
	
	
	
	

		
		
<cffunction name="FindStringInPage" access="remote" output="yes" returntype="Numeric">
	-- Returns the position of where the string was found	
	<cfargument name="LookFor"              type="String"  required="yes" />
	<cfargument name="theViewSourcePage"    type="String"  required="yes" />
	<cfargument name="startLookingPosition" type="Numeric" required="yes" />

	<cfset FoundStringPos = FINDNOCASE('#arguments.LookFor#','#arguments.theViewSourcePage#',#arguments.startLookingPosition#)>  	

	<cfif 1 is 2>
	<cfoutput>
	FoundStringPos = #FoundStringPos# 
	</cfoutput>
	</cfif>

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
	Start Looking Position = #arguments.startLookingPosition#<br>
	LeftSideString = #Arguments.LeftSideString#<br>
	RightSideString = #Arguments.RightSideString#<br>
		
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
	<cfset EndParsePos   = posOfRightsidestring + 4>
 	<cfset LenOfParseVal = (#EndParsePos# - #StartParsePos#)>
	
	
	
	<cfif 1 is 2>
	<cfoutput>
	StartParsePos = #startparsepos#><br>
	EndParsePos   = #endparsepos#><br>
 	LenOfParseVal = #LenOfParseVal#><br>
		
	</cfoutput>
	</cfif>
	
	
	<cfset parseVal = Mid('#arguments.theViewSourcePage#',#StartParsePos#,#LenOfParseVal#)>
	
	<cfif 1 is 1>
	<cfif findnocase('NY',parseval) gt 0>
		<cfset parseval = 'NYK'>
	<cfelseif findnocase('SA',parseval) gt 0 and findnocase('SAC',parseval) is 0>
		<cfset parseval = 'SAS'>
	<cfelseif findnocase('NO',parseval) gt 0>
		<cfset parseval = 'NOP'>
	<cfelseif findnocase('PHO',parseval) gt 0>
		<cfset parseval = 'PHX'>
	<cfelseif findnocase('BK',parseval) gt 0>
		<cfset parseval = 'BKN'>
	<cfelseif findnocase('GS',parseval) gt 0>
		<cfset parseval = 'GSW'>		
	</cfif>
	</cfif>
	
	
	<cfif 1 is 2>
	<cfoutput>
	#parseVal#
	</cfoutput>
	</cfif>
	
	
	<cfset Session.LastPos = EndParsePos + 1>
	
	
	<cfreturn parseVal>

</cffunction>
	
	
<cffunction name="getNBAShortName" access="remote" output="yes" returntype="String">

	<cfargument name="theTeam" type="String"  required="yes" />

	<cfset myRetVal = arguments.theTeam>

	<cfif arguments.theTeam is 'Miami Heat'>
		<cfset myretval = 'MIA'>
	</cfif>
	
	<cfif arguments.theTeam is 'Milwaukee Bucks'>
		<cfset myretval = 'MIL'>
	</cfif>
	
	<cfif arguments.theTeam is 'Philadelphia 76ers'>
		<cfset myretval = 'PHI'>
	</cfif>

	<cfif arguments.theTeam is 'Detroit Pistons'>
		<cfset myretval = 'DET'>
	</cfif>

	<cfif arguments.theTeam is 'Boston Celtics'>
		<cfset myretval = 'BOS'>
	</cfif>

	<cfif arguments.theTeam is 'New York Knicks'>
		<cfset myretval = 'NYK'>
	</cfif>

	<cfif arguments.theTeam is 'Orlando Magic'>
		<cfset myretval = 'ORL'>
	</cfif>

	<cfif arguments.theTeam is 'Atlanta Hawks'>
		<cfset myretval = 'ATL'>
	</cfif>

	<cfif arguments.theTeam is 'Cleveland Cavaliers'>
		<cfset myretval = 'CLE'>
	</cfif>

	<cfif arguments.theTeam is 'Toronto Raptors'>
		<cfset myretval = 'TOR'>
	</cfif>

	<cfif arguments.theTeam is 'Chicao Bulls'>
		<cfset myretval = 'CHI'>
	</cfif>

	<cfif arguments.theTeam is 'New Orleans Pelicans'>
		<cfset myretval = 'NOP'>
	</cfif>

	<cfif arguments.theTeam is 'Houston Rockets'>
		<cfset myretval = 'HOU'>
	</cfif>

	<cfif arguments.theTeam is 'Washington Wizards'>
		<cfset myretval = 'WAS'>
	</cfif>

	<cfif arguments.theTeam is 'San Antonio Spurs'>
		<cfset myretval = 'SAS'>
	</cfif>

	<cfif arguments.theTeam is 'Sacramento Kings'>
		<cfset myretval = 'SAC'>
	</cfif>

	<cfif arguments.theTeam is 'Utah Jazz'>
		<cfset myretval = 'UTA'>
	</cfif>

	<cfif arguments.theTeam is 'Los Angeles Clippers'>
		<cfset myretval = 'LAC'>
	</cfif>

	<cfif arguments.theTeam is 'Phoenix Suns'>
		<cfset myretval = 'PHX'>
	</cfif>

	<cfif arguments.theTeam is 'Minnesota Timberwolves'>
		<cfset myretval = 'MIN'>
	</cfif>

	<cfif arguments.theTeam is 'Charlotte Hornets'>
		<cfset myretval = 'MEM'>
	</cfif>

	<cfif arguments.theTeam is 'Toronto Raptors'>
		<cfset myretval = 'TOR'>
	</cfif>

	<cfif arguments.theTeam is 'Brooklyn Nets'>
		<cfset myretval = 'BKN'>
	</cfif>

	<cfif arguments.theTeam is 'Charlotte Hornets'>
		<cfset myretval = 'CHA'>
	</cfif>

	<cfif arguments.theTeam is 'Oklahoma City Thunder'>
		<cfset myretval = 'OKC'>
	</cfif>

	<cfif arguments.theTeam is 'Dallas Mavericks'>
		<cfset myretval = 'DAL'>
	</cfif>

	
	<cfif arguments.theTeam is 'Memphis Grizzlies'>
		<cfset myretval = 'MEM'>
	</cfif>

	
	<cfif arguments.theTeam is 'Los Angeles Lakers'>
		<cfset myretval = 'LAL'>
	</cfif>
	
	
	<cfif arguments.theTeam is 'Portland Trail Blazers'>
		<cfset myretval = 'POR'>
	</cfif>
	
	<cfif arguments.theTeam is 'Denver Nuggets'>
		<cfset myretval = 'DEN'>
	</cfif>

	<cfif arguments.theTeam is 'Chicago Bulls'>
		<cfset myretval = 'CHI'>
	</cfif>
	
	
	<cfif arguments.theTeam is 'Golden State Warriors'>
		<cfset myretval = 'GSW'>
	</cfif>
	
	<cfif arguments.theTeam is 'Indiana Pacers'>
		<cfset myretval = 'IND'>
	</cfif>
	
	
	
	
	<cfreturn '#myretval#'>
	
</cffunction>	