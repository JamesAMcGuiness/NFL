<cfquery datasource="sysstats3" name="GetWeek">
Select MAX(Week) as theweek, MAX(Yr) as theYear
From Week
</cfquery>

<cfset ToDay=DateFormat(Now() + 1)>

<cfset TNFdate    = ToDay>
<cfset Sundaydate = ToDay>
<cfset Mondaydate = ToDay>


<cfset TNFdate    = DateAdd('d',ToDay,1)>
<cfset Sundaydate = DateAdd('d',TNFdate,3)>
<cfset Mondaydate = DateAdd('d',Sundaydate,1)>


--Tuesday
<cfif #DayOfWeek(today)# is 3>
	<cfset TNFdate    = DateAdd('d',ToDay,2)>
	<cfset Sundaydate = DateAdd('d',TNFdate,3)>
	<cfset Mondaydate = DateAdd('d',Sundaydate,1)>

</cfif>

--Wed
<cfif #DayOfWeek(today)# is 4>
	<cfset TNFdate    = DateAdd('d',ToDay,1)>
	<cfset Sundaydate = DateAdd('d',ToDay,3)>
	<cfset Mondaydate = DateAdd('d',ToDay,4)>
</cfif>

--Thurs
<cfif #DayOfWeek(today)# is 5>
	<cfset TNFdate    = DateAdd('d',ToDay,0)>
	<cfset Sundaydate = DateAdd('d',TNFdate,3)>
	<cfset Mondaydate = DateAdd('d',Sundaydate,1)>
</cfif>

<cfoutput>
--Wed
#DayOfWeek(today)#<br>
#TNFdate#<br>
#Sundaydate#<br>
#Mondaydate#<br>
</cfoutput>


		<cfoutput>
			<cfhttp url="https://iis2.donbest.com/nfl/odds/" method="GET">
						
			</cfhttp> 
		</cfoutput>

		<cfset mypage = #cfhttp.FileContent#>

	<cfset StartPos = 1>		
	<cfset AllDone = false>	
	<cfset i = 0>
	<cfloop condition="alldone is false">
		
		<cfset i = i + 1>
		
		<cfset FoundAwayTeamPos = FindStringInPage('<span class="oddsTeamWLink">','#mypage#',#StartPos#)>
		
		<cfif FoundAwayTeamPos lte 0>
			<cfset AllDone = true>
		<cfelse>
			
			<cfset AwayTeam = ParseIt('#mypage#',#FoundAwayTeamPos#,'<span class="oddsTeamWLink">','</span>')>
								
			<cfset FoundHomeTeamPos = FindStringInPage('<span class="oddsTeamWLink">','#mypage#',#FoundAwayTeamPos# + 10)>
			<cfset HomeTeam = ParseIt('#mypage#',#FoundHomeTeamPos#,'<span class="oddsTeamWLink">','</span>')>

			<cfoutput>
			Running to find #AwayTeam# versus #Hometeam#<br>
			</cfoutput>

			<cfset mytotal  = 0>
			<cfset setTotal = 'Y'>						
			<cfset setSpd   = 'Y'>
			<cfset myspd    = 0>

			<cfif i is 1>
				<cfset StartPos = 1>
			</cfif>	

			<cfif FoundHomeTeamPos gt 0>
					<cfset StartPos = FoundHomeTeamPos>
					<cfset lookforbegin = 'Div_Line_1'>
					
					<cfset StartPos = FindStringInPage('#lookforbegin#','#mypage#',#StartPos#)>
					
					<cfset setTotal = 'N'>
					<cfset setspd   = 'N'>
					<cfset myspd = 0>
					<cfset mytot = 0>
					<cfif StartPos Gt 0>


						Found DivLine1<br>	
						
						<cfset Done = false>
						
						<cfset Loopct = 0>
						<cfset addct = 0>
								
						<cfloop condition="done is false">

							
							<cfif setSPD is 'Y' and settotal is 'Y'>
								<cfoutput>
								Spread and Total are set:<br>
								 
								myspd = #val(replace('#myspd#','-','',"all"))#<br>
								mytot = #mytotal#<br>
								</cfoutput>
								<cfset loopct = 0>
								<cfset lookforbegin = 'Div_Line_1'>
								<cfset StartPos = FindStringInPage('#lookforbegin#','#mypage#',#foundposend#)>
								
								<cfset addct = addct + 1>
								
								
								
								<cfif i is 1>
									<cfset saveDate = ToString(TNFdate)>
								<cfelse>
									<cfset saveDate = ToString(Sundaydate)>
								</cfif>	
								
								<cfset x=saveDate>
								<cfset x=Replace(x,".","","All")>
								<cfset y=LSDateFormat(x,"yyyymmdd","English (US)")>
								
								
								
								<cfif HomeTeamIsFav is 'Y'>
									
									<cfset ashortname = getNBAShortName('#AwayTeam#')>
									<cfset hshortname = getNBAShortName('#HomeTeam#')>
									
									<cfset Done = true>
									<cfquery datasource="sysstats3" name="addit">
									INSERT INTO NFLSPDS(Week,Yr,Gametime,FAV,HA,SPREAD,UND,OverUnder) values (#GetWeek.TheWeek#,#GetWeek.Theyear#,'#y#','#hshortname#','H',#abs(myspd)#,'#ashortname#',#mytotal#)
									</cfquery>	

								<cfelse>
									<cfset ashortname = getNBAShortName('#AwayTeam#')>
									<cfset hshortname = getNBAShortName('#HomeTeam#')>
									<cfset Done = true>
									<cfquery datasource="sysstats3" name="addit">
									INSERT INTO NFLSPDS(Week,Yr,Gametime,FAV,HA,SPREAD,UND,OverUnder) values (#GetWeek.TheWeek#,#GetWeek.Theyear#,'#y#','#ashortname#','A',#abs(myspd)#,'#hshortname#',#mytotal#)
									</cfquery>	
								
								
								</cfif>


								
							<cfelse>
					
								<cfset lookforbegin = '>'>
								<cfset lookforend = '</div>'>
							
							</cfif>
							
							<cfset foundposbegin = findnocase('#lookforbegin#','#mypage#',StartPos)>
							<cfset foundposend   = findnocase('#lookforend#','#mypage#',StartPos)>	

							<cfif foundposbegin gt 0>

								<cfset myval = ParseIt('#mypage#',#StartPos#,'#lookforbegin#','#lookforend#')>
								
								<cfset skipit = false>
								<cfif myval is '-' >
									<cfset done = true>
									<cfset skipit = true>
								</cfif>	
								
								<cfif skipit is false>
								
									<cfset Loopct = Loopct + 1>
									<cfif myval gt 29>
										<cfif Loopct is 1>
											<cfset HomeTeamIsFav = 'Y'>
										<cfelse>
											<cfset HomeTeamIsFav = 'N'>
										</cfif>
										
										myval is gt 29<br>
										<cfset mytotal = myval>
										<cfset setTotal = 'Y'>
									<cfelse>
										<cfoutput>
										myval is lt 29 it is #myval#<br>
										</cfoutput>
										<cfset setSpd = 'Y'>
										<cfset myspd = myval>
										<cfoutput>
										myspd is set to #myspd#<br>
										<cfif myspd is 'PK'>
											<cfset myspd = '0'>
										</cfif>	
										
										</cfoutput>
										
										
									</cfif>
								</cfif>
								<cfset StartPos = foundposend +15>
							<cfelse>
								<cfset done = true>
							</cfif>

						</cfloop>
					<cfelse>
						<cfoutput>
						Could not find team '#Teams[i]#'<br>
						</cfoutput>

					</cfif>
					
			<cfelse>
				<cfoutput>
				Could not find team '#Teams[i]#'<br>
				</cfoutput>
			</cfif>
	
		</cfif>
	
	</cfloop>
		
		
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
		parseVal=#trim(parseVal)#<br>
		</cfoutput>
		</cfif>
	
	<cfelse>
		<cfset parseVal = '0'>
	</cfif>

	<cfoutput>
	The final value to return is *****#parseval#*****<br>
	Its length is #len(parseval)#<br>
	</cfoutput>
		
	<cfif parseval is 'PK'>
		<cfset parseval = '0'>
	</cfif>	
		
	<cfreturn '#parseVal#'>

</cffunction>
	
	
<cffunction name="getNBAShortName" access="remote" output="yes" returntype="String">

	<cfargument name="theTeam" type="String"  required="yes" />

	<cfset myRetVal = arguments.theTeam>

	<cfoutput>
	******#arguments.theTeam#*****<br>
	</cfoutput>

	<cfif arguments.theTeam is 'Arizona Cardinals'>
		BINGO
		<cfset myretval = 'ARZ'>
	</cfif>

	<cfif arguments.theTeam is 'San Francisco 49ers'>
	BINGO
		<cfset myretval = 'SF'>
	</cfif>

	<cfif arguments.theTeam is 'Houston Texans'>
		<cfset myretval = 'HOU'>
	</cfif>
	
	<cfif arguments.theTeam is 'Jacksonville Jaguars'>
		<cfset myretval = 'JAX'>
	</cfif>
	
	<cfif arguments.theTeam is 'Washington Football Team'>
		<cfset myretval = 'WAS'>
	</cfif>

	<cfif arguments.theTeam is 'Buffalo Bills'>
		<cfset myretval = 'BUF'>
	</cfif>

	<cfif arguments.theTeam is 'Tennessee Titans'>
		<cfset myretval = 'TEN'>
	</cfif>

	<cfif arguments.theTeam is 'Carolina Panthers'>
		<cfset myretval = 'CAR'>
	</cfif>

	<cfif arguments.theTeam is 'Chicago Bears'>
		<cfset myretval = 'CHI'>
	</cfif>

	<cfif arguments.theTeam is 'Philadelphia Eagles'>
		<cfset myretval = 'PHI'>
	</cfif>

	<cfif arguments.theTeam is 'Minnesota Vikings'>
		<cfset myretval = 'MIN'>
	</cfif>

	<cfif arguments.theTeam is 'Kansas City Chiefs'>
		<cfset myretval = 'KC'>
	</cfif>

	<cfif arguments.theTeam is 'New York Jets'>
		<cfset myretval = 'NYJ'>
	</cfif>

	<cfif arguments.theTeam is 'Miami Dolphins'>
		<cfset myretval = 'MIA'>
	</cfif>

	<cfif arguments.theTeam is 'Indianapolis Colts'>
		<cfset myretval = 'IND'>
	</cfif>

	<cfif arguments.theTeam is 'Pittsburgh Steelers'>
		<cfset myretval = 'PIT'>
	</cfif>

	<cfif arguments.theTeam is 'Detroit Lions'>
		<cfset myretval = 'DET'>
	</cfif>

	<cfif arguments.theTeam is 'Las Vegas Raiders'>
	BINGO
		<cfset myretval = 'OAK'>
	</cfif>

	<cfif arguments.theTeam is 'Tampa Bay Buccaneers'>
		<cfset myretval = 'TB'>
	</cfif>

	<cfif arguments.theTeam is 'Seattle Seahawks'>
		<cfset myretval = 'SEA'>
	</cfif>

	<cfif arguments.theTeam is 'Cleveland Browns'>
		<cfset myretval = 'CLE'>
	</cfif>

	<cfif arguments.theTeam is 'Denver Broncos'>
		<cfset myretval = 'DEN'>
	</cfif>

	<cfif arguments.theTeam is 'Green Bay Packers'>
		<cfset myretval = 'GB'>
	</cfif>

	<cfif arguments.theTeam is 'Los Angeles Chargers'>
		<cfset myretval = 'LAC'>
	</cfif>

	<cfif arguments.theTeam is 'Brooklyn Nets'>
		<cfset myretval = 'BKN'>
	</cfif>

	<cfif arguments.theTeam is 'New England Patriots'>
		<cfset myretval = 'NE'>
	</cfif>

	<cfif arguments.theTeam is 'Baltimore Ravens'>
		<cfset myretval = 'BAL'>
	</cfif>

	<cfif arguments.theTeam is 'Dallas Cowboys'>
		<cfset myretval = 'DAL'>
	</cfif>

	
	<cfif arguments.theTeam is 'New York Giants'>
		<cfset myretval = 'NYG'>
	</cfif>

	
	<cfif arguments.theTeam is 'Cincinnati Bengals'>
		<cfset myretval = 'CIN'>
	</cfif>
	
	
	<cfif arguments.theTeam is 'New Orleans Saints'>
		<cfset myretval = 'NO'>
	</cfif>
	
	<cfif arguments.theTeam is 'Atlanta Falcons'>
		<cfset myretval = 'ATL'>
	</cfif>

	<cfif arguments.theTeam is 'Los Angeles Rams'>
		<cfset myretval = 'LAR'>
	</cfif>
	
	
	<cfreturn '#myretval#'>
	
</cffunction>	