<cftry>
	<cfset SundayIs = 0>
	<cfset MondayIs = 0>

<cfset theyr = Year(#now()#)>
<cfoutput>
#theyr#
</cfoutput>

<cfset myday   = Day(now())>
<cfset mymonth = Month(now())>
<cfset myyear  = Year(now())>

<cfset mydate = myyear & mymonth & myday>
<cfset usedate = CreateDate(myyear,mymonth,myday)>


<cfoutput>
The day is #DayOfWeek(now())#
</cfoutput>


<!--- If today is Tuesday --->
<cfif DayOfWeek(now()) is 3>
	<cfset SundayIs = -2>
	<cfset MondayIs = -1>
	<cfset ThursdayIs = -6>
</cfif>

<!--- If today is Wednesday --->
<cfif DayOfWeek(now()) is 4>
	<cfset SundayIs = -3>
	<cfset MondayIs = -2>
</cfif>

<!--- If today is Thursday --->
<cfif DayOfWeek(now()) is 5>
	<cfset SundayIs = -4>
	<cfset MondayIs = -3>
</cfif>

<cfset Sunday = dateadd("d",#Sundayis#,usedate)>
<cfset Monday = dateadd("d",#MondayIs#,usedate)>

<cfset mydaySunday   = Day(Sunday)>
<cfset mymonthSunday = Month(Sunday)>
<cfset myyearSunday  = Year(Sunday)>

<cfoutput>
#len(mydaySunday)#
</cfoutput>

<cfif len(mydaySunday) is 1>
		yes...<br>
	<cfset mydaySunday = '0#mydaysunday#'>
	<cfoutput>#mydaySunday#</cfoutput><br>
</cfif>

<cfif len(mymonthSunday) is 1>
	<cfset mymonthSunday = '0#mymonthsunday#'>
</cfif>


<cfset mydateSunday = myyearSunday & mymonthSunday & mydaySunday>

<cfset mydayMonday   = Day(Monday)>
<cfset mymonthMonday = Month(Monday)>
<cfset myyearMonday  = Year(Monday)>

<cfif len(mydayMonday) is 1>
		yes...<br>
	<cfset mydayMonday = '0#mydayMonday#'>
	<cfoutput>#mydayMonday#</cfoutput><br>
</cfif>

<cfif len(mymonthMonday) is 1>
	<cfset mymonthMonday = '0#mymonthMonday#'>
</cfif>

<cfset mydateMonday = myyearMonday & mymonthMonday & mydayMonday>




<cfoutput>
#mydatesunday#
</cfoutput>


<cfquery datasource="psp_psp" name="GetWeek">
Select Week  as theweek 
from week
</cfquery>

<cfquery name="GetSpds" datasource="nflspds" >
SELECT *
FROM nflspds
WHERE week = #Getweek.theweek#
</cfquery>


<cfset hps = 0>
<cfset aps = 0>
<cfset theweek = GetSpds.week>
<cfset loopct = 0>
<cfloop query="Getspds">
	<cfset myha = '#getspds.ha#'>
	<cfset loopct = loopct + 1>
	<cfif myha is 'H'>
		<cfset hteam = '#trim(Getspds.Fav)#'>
		<cfset hteam2 = '#lcase(Getspds.Fav)#'>
		<cfset ateam = '#trim(Getspds.Und)#'>
		<cfset ateam2 = '#lcase(Getspds.Und)#'>
	<cfelse>	
		<cfset hteam = '#trim(Getspds.Und)#'>
		<cfset hteam2 = '#lcase(Getspds.und)#'>
		<cfset ateam = '#trim(Getspds.Fav)#'>
		<cfset ateam2 = '#lcase(Getspds.Fav)#'>
	</cfif>

	<cfoutput>
	hteam='#hteam#'<br>
	ateam='#ateam#'<br>
	hteam2='#hteam2#'<br>
	ateam2='#ateam2#'<br>
	</cfoutput>
	<hr>
	
	<cfif hteam is 'TEN'>
		<cfset hteam2 = 'oti'>
	</cfif>

	<cfif hteam is 'OAK'>
		<cfset hteam2 = 'rai'>
	</cfif>
	
	<cfif hteam is 'ARZ'>
		<cfset hteam2 = 'crd'>
	</cfif>
	
	<cfif hteam is 'GB'>
		<cfset hteam2 = 'gnb'>
	</cfif>

	<cfif hteam is 'HOU'>
		<cfset hteam2 = 'htx'>
	</cfif>

	<cfif hteam is 'KC'>
		<cfset hteam2 = 'kan'>
	</cfif>

	<cfif hteam is 'NO'>
		<cfset hteam2 = 'nor'>
	</cfif>
	
	
	<cfif hteam is 'TB'>
		<cfset hteam2 = 'tam'>
	</cfif>

	<cfif hteam is 'BAL'>
		<cfset hteam2 = 'rav'>
	</cfif>

	<cfif hteam is 'CLE'>
		<cfset hteam2 = 'cle'>
	</cfif>

	<cfif hteam is 'NE'>
		<cfset hteam2 = 'nwe'>
	</cfif>

	<cfif hteam is 'LAR'>
		<cfset hteam2 = 'ram'>
	</cfif>

	<cfif hteam is 'LAC'>
		<cfset hteam2 = 'sdg'>
	</cfif>

	
	<cfif hteam is 'SD'>
		<cfset hteam2 = 'sdg'>
	</cfif>

	<cfif hteam is 'SF'>
		<cfset hteam2 = 'sfo'>
	</cfif>

	<cfif hteam is 'IND'>
		<cfset hteam2 = 'clt'>
	</cfif>







	<cfif ateam is 'TEN'>
		<cfset ateam2 = 'oti'>
	</cfif>

	<cfif ateam is 'OAK'>
		<cfset ateam2 = 'rai'>
	</cfif>
	
	<cfif ateam is 'ARZ'>
		<cfset ateam2 = 'crd'>
	</cfif>
	
	<cfif ateam is 'GB'>
		<cfset ateam2 = 'gnb'>
	</cfif>

	<cfif ateam is 'HOU'>
		<cfset ateam2 = 'htx'>
	</cfif>

	<cfif ateam is 'KC'>
		<cfset ateam2 = 'kan'>
	</cfif>

	<cfif ateam is 'NO'>
		<cfset ateam2 = 'nor'>
	</cfif>
	
	
	<cfif ateam is 'TB'>
		<cfset ateam2 = 'tam'>
	</cfif>

	<cfif ateam is 'BAL'>
		<cfset ateam2 = 'rav'>
	</cfif>

	<cfif ateam is 'CLE'>
		<cfset ateam2 = 'cle'>
	</cfif>

	<cfif ateam is 'NE'>
		<cfset ateam2 = 'nwe'>
	</cfif>

	<cfif ateam is 'LAR'>
		<cfset ateam2 = 'ram'>
	</cfif>

	<cfif ateam is 'LAC'>
		<cfset ateam2 = 'lac'>
	</cfif>

	
	<cfif ateam is 'SD'>
		<cfset ateam2 = 'sdg'>
	</cfif>

	<cfif ateam is 'SF'>
		<cfset ateam2 = 'sfo'>
	</cfif>

	<cfif ateam is 'IND'>
		<cfset ateam2 = 'clt'>
	</cfif>






	<cfset gameplayedon = "#GetSpds.TimeOfGame#0#hteam2#.htm">
	<cfset myurl = 'https://www.pro-football-reference.com/boxscores/#gameplayedon#'>
	
	<cfset myurl = 'http://127.0.0.1:8500/NFLCode/#hteam2#.htm'>
	
<cfoutput>The game URL is: #myurl#</cfoutput>



<!--- 
	<cfoutput>
	#myurl#
	</cfoutput> 
	<hr>
 --->


<cfset lookfor='<table class="stats_table" id="team_stats" data-cols-to-freeze=1><caption>Team Stats Table</caption>'>

<cfoutput>
<cfhttp url="#myurl#" method="GET">
</cfhttp> 
</cfoutput>

<cfset mypage = #cfhttp.FileContent#>

<cfset Findit = FindNocase('#lookfor#',mypage)>

<cfoutput>
findit = #Findit#
</cfoutput>

<!-- Remove all the data prior to the Away Teams data -->
<cfset mysmallpage = RemoveChars(mypage,1,Findit - 1)>

<!-- Mypage should now have just the Drive Chart stats  -->
<cfset mypage = mysmallpage>

<cfset mainlookfor = '<td class="center " data-stat="vis_stat" >'>
<cfset mainlookfor2 = '<td class="center " data-stat="home_stat" >'>

<cfset lookfor   = 'First Downs'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfoutput>
FD<br>
FinditPos = #FinditPos#
</cfoutput>

<cfset lookfor2   = mainlookfor>

<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfoutput>
endtd<br>
FinditPos2 = #FinditPos2#
</cfoutput>



<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset aFD = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('afd ' & '#afd#')
</cfquery>

<cfset lookfor2   = mainlookfor2>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos3)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset hFD = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('hfd ' & '#hfd#')
</cfquery>


<cfoutput>
<p>
afd:#afd#<br>
hfd:#hfd#
</cfoutput>



<cfset lookfor   = 'Rush-Yds-TDs'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfset lookfor2   = mainlookfor>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset aRYTD = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('aRytd ' & '#arytd#')
</cfquery>


<cfset lookfor2   = mainlookfor2>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos3)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset hRYTD = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('hRytd ' & '#hrytd#')
</cfquery>




<cfset lookfor   = 'Cmp-Att-Yd-TD-INT'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfset lookfor2   = mainlookfor>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset aCAYTI = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('aCAYTI ' & '#aCAYTI#')
</cfquery>





<cfset lookfor2   = mainlookfor2>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos3)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset hCAYTI = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('hCAYTI ' & '#hCAYTI#')
</cfquery>




<cfset lookfor   = 'Sacked-Yards'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfset lookfor2   = mainlookfor>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset aSacked = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('aSacked' & '#aSacked#')
</cfquery>




<cfset lookfor2   = mainlookfor2>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos3)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset hSacked = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('hSacked' & '#hSacked#')
</cfquery>




<cfset lookfor   = 'Net Pass Yards'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfset lookfor2   = mainlookfor>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset aNetPass = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfset lookfor2   = mainlookfor2>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos3)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset hNetPass = '#mid(mypage,startfrom,ForALengthOf)#'>



<cfset lookfor   = 'Total Yards'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfset lookfor2   = mainlookfor>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset aTotYds = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfset lookfor2   = mainlookfor2>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos3)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfset lookfor3 = '</td>'>
<cfset FinditPos3 = FindNocase('#lookfor3#',mypage,FinditPos2)>
<cfset lenoflookfor3 = len(lookfor3)>

<cfset startFrom = (lenoflookfor2 + FindItPos2)>
<cfset ForALengthOf = FindItPos3 - startFrom>
<cfset hTotYds = '#mid(mypage,startfrom,ForALengthOf)#'>

<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash = FindNoCase('-','#hRytd#')>
<cfset hRushes = val(mid('#hrytd#',1,firstdash - 1))>


<cfset seconddash = FindNoCase('-','#hRytd#',firstdash)>
<cfset hRushYds = val(mid('#hrytd#',firstdash+1,seconddash - firstdash))>



<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash = FindNoCase('-','#aRytd#')>
<cfset aRushes = val(mid('#arytd#',1,firstdash - 1))>


<cfset seconddash = FindNoCase('-','#aRytd#',firstdash)>
<cfset aRushYds = val(mid('#arytd#',firstdash+1,seconddash - firstdash))>




<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash = FindNoCase('-','#hCAYTI#')>
<cfset hCmp = val(mid('#hCAYTI#',1,firstdash - 1))>


<cfset seconddash = FindNoCase('-','#hCAYTI#',firstdash+1)>
<cfset hAtt = val(mid('#hCAYTI#',firstdash+1,seconddash - firstdash))>

<cfset thirddash = FindNoCase('-','#hCAYTI#',seconddash+1)>
<cfset hPassYds = val(mid('#hCAYTI#',seconddash+1,thirddash - seconddash))>

<cfset fourthdash = FindNoCase('-','#hCAYTI#',thirddash+1)>
<cfset hTD        = val(mid('#hCAYTI#',thirddash+1,fourthdash - thirddash))>
<cfset hINT       = val(mid('#hCAYTI#',fourthdash+1,2))>

<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash = FindNoCase('-','#aCAYTI#')>
<cfset aCmp = val(mid('#aCAYTI#',1,firstdash - 1))>


<cfset seconddash = FindNoCase('-','#aCAYTI#',firstdash+1)>
<cfset aAtt = val(mid('#aCAYTI#',firstdash+1,seconddash - firstdash))>

<cfset thirddash = FindNoCase('-','#aCAYTI#',seconddash +1)>
<cfset aPassYds = val(mid('#aCAYTI#',seconddash+1,thirddash - seconddash))>

<cfset fourthdash = FindNoCase('-','#aCAYTI#',thirddash+1)>
<cfset aTD        = val(mid('#aCAYTI#',thirddash+1,fourthdash - thirddash))>
<cfset aINT       = val(mid('#aCAYTI#',fourthdash+1,2))>


<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash    = FindNoCase('-','#aSacked#')>
<cfset aTimesSacked      = val(mid('#aSacked#',1,firstdash - 1))>
<cfset aSackedYds   = val(mid('#aSacked#',firstdash+1,3))>

<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('aSacked' & '#aSacked#')
</cfquery>



<cfquery datasource="psp_psp" name="Adddebug">
Insert into DebugPBP(Debuginfo) values('hSacked' & '#hSacked#')
</cfquery>


<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash    = FindNoCase('-','#hSacked#')>
<cfset hTimesSacked      = val(mid('#hSacked#',1,firstdash - 1))>
<cfset hSackedYds   = val(mid('#hSacked#',firstdash+1,3))>


<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash = FindNoCase('-','#aRYTD#')>
<cfset aRushes = val(mid('#aRYTD#',1,firstdash - 1))>


<cfset seconddash = FindNoCase('-','#aRYTD#',firstdash + 1)>
<cfset aRushYds = val(mid('#aRYTD#',firstdash+1,seconddash - firstdash))>


<cfset firstdash = 0>
<cfset lookfor      = '-'>
<cfset firstdash = FindNoCase('-','#hRYTD#')>
<cfset hRushes = val(mid('#hRYTD#',1,firstdash - 1))>


<cfset seconddash = FindNoCase('-','#hRYTD#',firstdash + 1)>
<cfset hRushYds = val(mid('#hRYTD#',firstdash+1,seconddash - firstdash))>

<cfset aPassYds = aPassYds - aSackedYds>
<cfset hPassYds = hPassYds - hSackedYds>

<cfset hPavg = (hpassYds)/(hatt + htimessacked + hint)>
<cfset aPavg = (apassYds)/(aatt + atimessacked + aint)>

<cfset hRavg = (hrushYds/hRushes)>
<cfset aRavg = (arushYds/aRushes)>

<cfset hPlays = hatt + hTimesSacked + hint + hRushes>
<cfset aPlays = aatt + aTimesSacked + aint + aRushes>

<cfset hAvgPlay = htotyds/hplays>
<cfset aAvgPlay = atotyds/aPlays>

 
<cfoutput>
*********<br>	
#hatt#<br>	
#hsacked#<br>	
#hint#<br>	
#hRushes#<br>	
*********
	
	
	
	
#hTotYds#<br>
#aTotYds#<br>

#hNetPass#<br>
#aNetPass#<br>

#hSacked#<br>
#aSacked#<br>

#hCAYTI#<br>
#aCAYTI#<br>

#hRYTD#<br>
#aRYTD#<br>

#hFD#<br>
#aFD#<br>
<hr>
rushes:#hRushes#<br>
rush yds:#hRushYds#<br>
sacked:#hTimesSacked#<br>
sack yds:#hSackedYds#<br> 
<hr>
rushes:#aRushes#<br>
rush yds:#aRushYds#<br>
sacked:#aTimesSacked#<br>
sack yds:#aSackedYds#<br> 
<hr>
cmp:#hcmp#<br>
Att:#hatt#<br>
Yds:#hPassYds#<br>
int:#hint#<br>
Ydsperpass: 
<hr>
cmp:#acmp#<br>
Att:#aatt#<br>
Yds:#aPassYds#<br>
int:#aint#<br>
<hr>
hPavg:#hPavg#
aPavg:#aPavg# 
<hr>
hRavg:#hRavg# 
aRavg:#aRavg# 
<hr>
hAvgPlay:#hAvgPlay#
aAvgPlay:#aAvgPlay#

</cfoutput>


<cfif myha is 'H'>
	<cfset myha2 = 'A'>
<cfelse>
	<cfset myha2 = 'H'>
</cfif>


 
<cfquery datasource="sysstats">
Insert into sysstats(team,yr,week,longyear,ha,opp,PS,Yards,Plays,Again,Ryds,Rushes,Ravg,Pyds,Cmp,Att,Pavg,Sacked,Int,dPS,dYards,dPlays,dAgain,dRyds,dRushes,dRavg,dPyds,dCmp,dAtt,dPavg,dSacked,dInt)
values('#hteam#',98,#theweek#,'2004','#myha#','#ateam#',#hps#,#hTotYds#,#hplays#,#hAvgPlay#,#hRushYds#,#hRushes#,#hRavg#,#hPassYds#,#hcmp#,#hatt#,#hpavg#,#hTimesSacked#,#hint#,#aps#,#aTotYds#,#aplays#,#aAvgPlay#,#aRushYds#,#aRushes#,#aRavg#,#aPassYds#,#acmp#,#aatt#,#apavg#,#aTimesSacked#,#aint#)
</cfquery>

<cfquery datasource="sysstats">
Insert into sysstats(team,yr,week,longyear,ha,opp,PS,Yards,Plays,Again,Ryds,Rushes,Ravg,Pyds,Cmp,Att,Pavg,Sacked,Int,dPS,dYards,dPlays,dAgain,dRyds,dRushes,dRavg,dPyds,dCmp,dAtt,dPavg,dSacked,dInt)
values('#ateam#',98,#theweek#,'2004','#myha2#','#hteam#',#aps#,#aTotYds#,#aplays#,#aAvgPlay#,#aRushYds#,#aRushes#,#aRavg#,#aPassYds#,#acmp#,#aatt#,#apavg#,#aTimesSacked#,#aint#,#hps#,#hTotYds#,#hplays#,#hAvgPlay#,#hRushYds#,#hRushes#,#hRavg#,#hPassYds#,#hcmp#,#hatt#,#hpavg#,#hTimesSacked#,#hint#)
</cfquery>


<cfif 1 is 2>


<cfset myurl = 'http://www.pro-football-reference.com/'>

<cfoutput>
<cfhttp url="#myurl#" method="GET">
</cfhttp> 
</cfoutput>

<cfset mypage = #cfhttp.FileContent#>


<cfset lookfor   = '<a href="/boxscores/#gameplayedon#">'>
<cfset FinditPos = FindNocase('#lookfor#',mypage)>

<cfoutput>
<cfif FinditPos gt 0>
	Found #lookfor#<br>
</cfif>
</cfoutput>

<cfset lenlookfor = Len(lookfor)>

<cfset lookfor2   = '</a>'>
<cfset FinditPos2 = FindNocase('#lookfor2#',mypage,FinditPos)>
<cfset lenoflookfor2 = len(lookfor2)>

<cfoutput>
<cfif FinditPos2 gt 0>
	Found #lookfor2#<br>
</cfif>
</cfoutput>



<cfset thescore = mid(#mypage#,FindItPos + lenlookfor,finditpos2-(FindItPos + lenlookfor))>
<cfset dashfoundat = findnocase('-','#thescore#')>

<cfoutput>
Dash found at #dashfoundat# from '#thescore#' <br>
</cfoutput>
<cfset winscr = val(Left('#thescore#',2))>
<cfset losscr = val(mid('#thescore#',dashfoundat + 1,2))>

<!--- See which team won the game --->
<cfoutput>
<cfset theyr = Year(#now()#)>
<cfset thehometeam ='/teams/#hteam2#/#theyr#'>
<cfset theawayteam ='/teams/#ateam2#/#theyr#'>
</cfoutput>

<cfoutput>
The home team = #thehometeam#<br>
The away team = #theawayteam#<br>
</cfoutput>

<cfset hometeamfound = findnocase('#thehometeam#','#mypage#')>
<cfset awayteamfound = findnocase('#theawayteam#','#mypage#')>


<cfoutput>
The home team found = #hometeamfound#<br>
The away team found = #awayteamfound#<br>
</cfoutput>

<cfset hometeamfound2 = findnocase('#thehometeam#','#mypage#',hometeamfound + 10)>
<cfset awayteamfound2 = findnocase('#theawayteam#','#mypage#',awayteamfound + 10)>

<cfoutput>
The home team found2 = #hometeamfound2#<br>
The away team found2 = #awayteamfound2#<br>
</cfoutput>


<cfset mydate = mydateSunday>
<cfif loopct is GetSpds.recordcount>
	<cfset mydate = mydateMonday>
</cfif>

<cfoutput>
	
<cfif winscr neq 0 and losscr neq 0>	
	
	
<cfif hometeamfound2 lt awayteamfound2>

	#winscr#-#hteam#<br>
	#losscr#-#ateam#<br>
	
	<cfquery datasource="sysstats">
	Update sysstats
	set ps = #winscr#,
		dps = #losscr#
		
	where team = '#hteam#'
	and week = #theweek#
	</cfquery>

	<cfquery datasource="sysstats">
	Update sysstats
	set ps = #losscr#,
		dps = #winscr#
	where team = '#ateam#'
	and week = #theweek#
	</cfquery>


<cfelse>
	#winscr#-#ateam#<br>
	#losscr#-#hteam#<br>

	
	<cfquery datasource="sysstats">
	Update sysstats
	set ps = #winscr#,
		dps = #losscr#
	where team = '#ateam#'
	and week = #theweek#
	</cfquery>

	<cfquery datasource="sysstats">
	Update sysstats
	set ps = #losscr#,
		dps = #winscr#
	where team = '#hteam#'
	and week = #theweek#
	</cfquery>

</cfif>
</cfif>	

</cfoutput>
</cfif>

</cfloop>

<cfcatch>
	<cfoutput>
	
	<cfquery datasource="psp_psp" name="debugit2">
		INSERT into DebugPBP(DebugInfo) values('Failed on: #cfcatch.Detail#...#cfcatch.Message#....#cfcatch.tagcontext[1].line#') 
	</cfquery>
	
	<input name="TheMsg" type="hidden" value="There was an error loading Boxscore line number: #cfcatch.tagcontext[1].line#..for #Statsfor#">
	
	<cfhttp method="Post"
			url="http://www.pointspreadpros.com/psp2012/nfl/admin/EmailNFLDataLoadError.cfm">
	
	<cfhttpparam name="TheMsg" type="FormField" value="There was an error loading Boxscore line number: #cfcatch.tagcontext[1].line#..#Statsfor#...rowid=#theid#..play=#thedebug#">
	</cfhttp>
	</cfoutput>
</cfcatch>
</cftry>

