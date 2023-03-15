
<cfquery datasource="sysstats3" name="GetGames">
Select n.*, w.StartingWeek from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfloop query="GetGames">
<cfset theweek = GetGames.Week>
<cfset thefav = Getgames.Fav>
<cfset theund = Getgames.Und>

<cfif GetGames.ha is 'H'>
	<cfset FavIsHome = 'Y'>
	<cfset UndIsHome = 'N'>
<cfelse>
	<cfset FavIsHome = 'N'>
	<cfset UndIsHome = 'Y'>
</cfif>	

<cfset msg = ''>

<cfset UndLiveRat = 0>
<cfset FavLiveRat = 0>

<cfif Getgames.Week neq GetGames.StartingWeek>
<cfquery datasource="sysstats3" name="GetOverUnderRated">
Select * from GameInsights 
where week = #theweek - 1#
And (OverratedPerformance='Y')
and Team in ('#thefav#')
</cfquery>

<cfif GetOverUnderRated.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFAV# (Sell high) had an overrated game last week<br>'>
	
</cfif>	

<cfquery datasource="sysstats3" name="GetOverUnderRated">
Select * from GameInsights 
where week = #theweek - 1#
And (UnderratedPerformance='Y')
and Team in ('#theund#')
</cfquery>

<cfif GetOverUnderRated.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive) #theUnd# (Buy low) had an underrated game last week<br>'>
</cfif>	
</cfif>



<cfquery datasource="sysstats3" name="GetOverallSuccess">
Select fav.PlaySuccessRt, fav.Fav, und.PlaySuccessRt, und.Fav from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and und.PlaySuccessRt >= fav.PlaySuccessRt 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>


<cfif GetOverallSuccess.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>#theUnd# has a better projected overall success rate.</b><br>'>
</cfif>	



<cfquery datasource="sysstats3" name="GetBigPlay">
Select * from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.BigPlayRt >= Fav.BigPlayRt 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>

<cfif GetBigPlay.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '#theUnd# has a better projected Big Play success rate<br>'>
</cfif>	



<cfquery datasource="sysstats3" name="GetRZSuccuss">
Select * from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.RedzoneSuccessRt >= Fav.RedzoneSuccessRt 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>

<cfif 1 is 2>
<cfif GetRZSuccuss.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '#theUnd# has a better projected redzone success rate<br>'>
</cfif>
</cfif>


<cfquery datasource="sysstats3" name="Gettogo3rd">
Select * from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.AvgToGo3rdDown <= Fav.AvgToGo3rdDown 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>

<cfif 1 is 2>
<cfif Gettogo3rd.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '#theUnd# has a better projected 3rd down togo rate<br>'>
</cfif>
</cfif>



<cfquery datasource="sysstats3" name="BadResult3rd">
Select * from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.BadResult3rdDown <= Fav.BadResult3rdDown 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>


<cfif BadResult3rd.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>#theUnd# (may win turnover battle) has a better projected performance on 3rd and long.</b><br>'>
</cfif>



<cfquery datasource="sysstats3" name="Int3rdLong">
Select * from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.Int3rdAndLongRt <= Fav.Int3rdAndLongRt
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif Int3rdLong.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>#theUnd# (may win turnover battle) has a better projected INT rate on passing situations.</b><br>'>
</cfif> 
 

<cfquery datasource="sysstats3" name="RunSuccRt">
Select * from ADJPBPGameProjections fav, ADJPBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.RunSuccessRt >= Fav.RunSuccessRt
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif RunSuccRt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>#theUnd# has a better projected Run success rate</b><br>'>
</cfif> 
 
 

<cfquery datasource="sysstats3" name="aPowerPtsPass">
Select fav.PowerPtsPass,fav.FinalPowerRat,und.FinalPowerRat, und.PowerPtsPass from betterThanAvg fav, betterThanAvg und
where Und.PowerPtsPass > Fav.PowerPtsPass
and fav.Team in ('#thefav#')
and und.Team in ('#theund#')
</cfquery>



<cfif aPowerPtsPass.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>***#theUnd# has a better PowerPtsPass rating.</b><br>'>
</cfif>


<cfquery datasource="sysstats3" name="aPower">
Select fav.PowerPtsPass,fav.FinalPowerRat,und.FinalPowerRat, und.PowerPtsPass from betterThanAvg fav, betterThanAvg und
where Und.FinalPowerRat > Fav.FinalPowerRat
and fav.Team in ('#thefav#')
and und.Team in ('#theund#')
</cfquery>

<cfif aPower.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>***#theUnd# has a better Power Rating.</b><br>'>
</cfif>


<cfquery datasource="sysstats3" name="FavAboveCt">
Select * from GameInsights fav
where fav.week = #theweek - 1#
and fav.ConseqAboveExpCt >= 2
and fav.Team in ('#thefav#')
</cfquery>

<cfif FavAboveCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFav# (Sell high) has 2+ above expectation games.<br>'>
</cfif>





<cfquery datasource="sysstats3" name="UndBelowCt">
Select * from GameInsights und
where und.week = #theweek - 1#
and und.ConseqBelowExpCt >= 2
and und.Team in ('#theund#')
</cfquery>

<cfif UndBelowCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theUnd# (Buy low) has 2+ under expectation games.<br>'>
</cfif>




 
<cfquery datasource="sysstats3" name="SpotLevel1">
Select * 
from Teams 
where SpotLevel1Play = 'Y'
and Team in ('#theund#')
</cfquery>
 
<cfif SpotLevel1.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>SITUATIONAL(Positive): #theUnd# has a Spot Level 1 play situation.</b><br>'>
</cfif> 


<cfquery datasource="sysstats3" name="SpotLevel2">
Select * from Teams und
where Und.SpotLevel2Play = 'Y'
and und.Team in ('#theund#')
</cfquery>
 
<cfif SpotLevel2.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>SITUATIONAL(Positive): #theUnd# has a Spot Level 2 play situation.</b><br>'>
</cfif> 



<cfquery datasource="sysstats3" name="SpotLevel1">
Select * from Teams fav
where Fav.SpotLevel1Play = 'Y'
and fav.Team in ('#thefav#') 
</cfquery>
 
<cfif SpotLevel1.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #thefav# however has a Spot Level 1 play situation.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="SpotLevel2">
Select * from Teams fav
where Fav.SpotLevel2Play = 'Y'
and fav.Team in ('#thefav#') 

</cfquery>
 
<cfif SpotLevel2.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theFav# has a Spot Level 2 play situation.<br>'>
</cfif> 









<cfset FRdctset = 'N'> 
<cfset URdctset = 'N'> 

<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from Teams fav
where Fav.ConseqRdCt >= 2
and fav.Team in ('#thefav#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 2> 
	<cfset msg = msg & '<b>SITUATIONAL(Positive): #theFav# is weary now traveling off 2 or more successive road trips.</b><br>'>
	<cfset URdctset = 'Y'> 

</cfif> 



<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from Teams und
where Und.ConseqRdCt >= 2
and und.Team in ('#theund#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 2> 
	<cfset msg = msg & '<b>SITUATIONAL: NEGATIVE - #theUnd# is weary now traveling off 2 or more successive road trips.</b><br>'>
	<cfset FRdctset = 'Y'>
</cfif> 






















<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams und
where Und.OffExtraTravel = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theUnd# is coming off extra travel.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams fav
where fav.OffExtraTravel = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFav# is coming off extra travel.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams und
where Und.CoastToCoast = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theUnd# is traveling coast to coast.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams fav
where fav.CoastToCoast = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFav# is traveling coast to coast.<br>'>
</cfif> 

<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams und
where Und.ExtraRest = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theUnd# is coming off extra rest.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams fav
where fav.ExtraRest = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theFav# is coming off extra rest.<br>'>
</cfif> 








<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams und
where Und.OffTNF = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1>
	<cfset msg = msg & 'SITUATIONAL(Positive): #theUnd# is coming off extra rest from TNF.<br>'>	
</cfif> 


<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams fav
where fav.OffTNF = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theFav# is coming off extra rest from TNF.<br>'>
</cfif> 






<cfquery datasource="sysstats3" name="LessRest">
Select * from Teams und
where Und.OffMNF = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif LessRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theUnd# is coming off less rest from MNF.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="LessRest">
Select * from Teams fav
where fav.OffMNF = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif LessRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFav# is coming off less rest from MNF.<br>'>
</cfif> 



<cfquery datasource="sysstats3" name="OffDIVGame">
Select * from Teams und
where Und.OffDIVGame = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif OffDIVGame.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theUnd# is coming off a divisional game.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="OffDIVGame">
Select * from Teams fav
where fav.OffDivGame = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif OffDIVGame.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFav# is coming off a divisional game.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="OffBigWin">
Select * from Teams fav
where fav.OffBigWin = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif OffBigWin.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theFav# is coming off a big win.<br>'>
</cfif> 




<cfquery datasource="sysstats3" name="OffPressure1">
Select AVG(und.PressureRate) as UndVal, AVG(fav.PressureRate) as favVal
from Sysstats und, Sysstats fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
</cfquery>
 
<cfquery datasource="sysstats3" name="DefPressure1">
Select AVG(und.dPressureRate) as UndVal, AVG(fav.dPressureRate) as favVal
from Sysstats und, Sysstats fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
</cfquery>

<cfset FavProjPressure = (OffPressure1.favval + DefPressure1.undval) / 2>
<cfset UndProjPressure = (OffPressure1.undval + DefPressure1.favval) / 2>


<cfquery datasource="sysstats3" name="OffPressure">
Select und.OffRat as UndVal, fav.OffRat as favVal
from PassPressure und, PassPressure fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
and fav.OffDef='O'
and Und.OffDef='O'
</cfquery>
 
<cfquery datasource="sysstats3" name="DefPressure">
Select und.DefRat as UndVal, fav.DefRat as favVal
from PassPressure und, PassPressure fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
and fav.OffDef='D'
and Und.OffDef='D'
</cfquery> 
 
<cfset Undval =  #DefPressure.favval# + #OffPressure.undval#>
<cfset favval =  #DefPressure.undval# + #OffPressure.favval#>
 
<cfif UndVal lt FavVal and UndProjPressure lt FavProjPressure >
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '<b>#theUnd# is predicted to have more QB pressure advantage.(#UndProjPressure#/#UndVal#)</b><br>'>
</cfif> 
<p>


<cfquery datasource="sysstats3" name="OffBadLoss">
Select *
from Teams fav
where fav.Team   = '#thefav#'
and fav.OffBadLoss='Y'
</cfquery> 

<cfif OffBadLoss.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL(Negative) - #theFav# is off a bad loss.<br>'>
</cfif>

*********************************************************************************************<br>
<cfoutput>The Live Underdog Rating for <b>#theUnd#</b> vs #thefav# is <b>#UndLiveRat#</b><p>
#msg#
</cfoutput><br>


<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('LiveDogRatAdjForOpp','LiveDogRatAdjForOpp','#theund#',#theweek#,#UndLiveRat#)
</cfquery>



<cfset UndLiveRat = 0>
*********************************************************************************************

<cfquery datasource="sysstats3" name="UpdIt">
Update Teams 
SET MatchupSummary = '#msg#'
where Team in ('#theund#')
</cfquery>


<p>
</cfloop>




















<cfloop query="GetGames">
<cfset theweek = GetGames.Week>
<cfset thefav = Getgames.Fav>
<cfset theund = Getgames.Und>

<cfif GetGames.ha is 'H'>
	<cfset FavIsHome = 'Y'>
	<cfset UndIsHome = 'N'>
<cfelse>
	<cfset FavIsHome = 'N'>
	<cfset UndIsHome = 'Y'>
</cfif>	

<cfset msg = ''>

<cfset UndLiveRat = 0>
<cfset FavLiveRat = 0>


<cfquery datasource="sysstats3" name="GetOverUnderRated">
Select * from GameInsights 
where week = #theweek - 1#
And (OverratedPerformance='Y')
and Team in ('#thefav#')
</cfquery>

<cfif GetOverUnderRated.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat  - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theFAV# (Sell high) had an overrated game last week<br>'>
	
</cfif>	

<cfquery datasource="sysstats3" name="GetOverUnderRated">
Select * from GameInsights 
where week = #theweek - 1#
And (UnderratedPerformance='Y')
and Team in ('#theund#')
</cfquery>

<cfif GetOverUnderRated.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat  - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE) #theUnd# (Buy low) had an underrated game last week<br>'>
</cfif>	




<cfquery datasource="sysstats3" name="FavAboveCt">
Select * from GameInsights fav
where fav.week = #theweek - 1#
and fav.ConseqAboveExpCt >= 2
and fav.Team in ('#thefav#')
</cfquery>

<cfif FavAboveCt.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat  - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theFav# (Sell high) has 2+ above expectation games.<br>'>
</cfif>





<cfquery datasource="sysstats3" name="UndBelowCt">
Select * from GameInsights und
where und.week = #theweek - 1#
and und.ConseqBelowExpCt >= 2
and und.Team in ('#theund#')
</cfquery>

<cfif UndBelowCt.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat  - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theUnd# (Buy low) has 2+ under expectation games.<br>'>
</cfif>




 
<cfquery datasource="sysstats3" name="SpotLevel1">
Select * 
from Teams 
where SpotLevel1Play = 'Y'
and Team in ('#theund#')
</cfquery>
 
<cfif SpotLevel1.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat  - 1> 
	<cfset msg = msg & '<b>SITUATIONAL(NEGATIVE): #theUnd# has a Spot Level 1 play situation.</b><br>'>
</cfif> 


<cfquery datasource="sysstats3" name="SpotLevel2">
Select * from Teams fav
where Fav.SpotLevel2Play = 'Y'
and fav.Team in ('#thefav#')
</cfquery>
 
<cfif SpotLevel2.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat  + 1> 
	<cfset msg = msg & '<b>SITUATIONAL(Positive): #theFav# has a Spot Level 2 play situation.</b><br>'>
</cfif> 



<cfset FRdctset = 'N'> 
<cfset URdctset = 'N'> 

<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from Teams und
where und.ConseqRdCt >= 2
and und.Team in ('#theund#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 2> 
	<cfset msg = msg & '<b>SITUATIONAL(Positive): #theUnd# is weary off 2 or more successive road trips.</b><br>'>
	<cfset FRdctset = 'Y'> 

</cfif> 



<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from Teams fav
where fav.ConseqRdCt >= 2
and fav.Team in ('#thefav#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 2> 
	<cfset msg = msg & '<b>SITUATIONAL: NEGATIVE - #theFav# is off 2 successive road trips.</b><br>'>
	<cfset URdctset = 'Y'>
</cfif> 



<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams fav
where fav.OffExtraTravel = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theFav# is coming off extra travel.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams und
where und.OffExtraTravel = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theund# is coming off extra travel.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams fav
where fav.CoastToCoast = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL: NEGATIVE - #theFav# is traveling coast to coast.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams und
where und.CoastToCoast = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Positive): #theUnd# is traveling coast to coast.<br>'>
</cfif> 

<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams und
where Und.ExtraRest = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theUnd# is coming off extra rest.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams fav
where fav.ExtraRest = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL: Positive - #theFav# is coming off extra rest.<br>'>
</cfif> 








<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams und
where Und.OffTNF = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 1>
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theUnd# is coming off extra rest from TNF.<br>'>	
</cfif> 


<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams fav
where fav.OffTNF = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL: Positive - #theFav# is coming off extra rest from TNF.<br>'>
</cfif> 






<cfquery datasource="sysstats3" name="LessRest">
Select * from Teams und
where Und.OffMNF = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif LessRest.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL: Positive - #theUnd# is coming off less rest from MNF.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="LessRest">
Select * from Teams fav
where fav.OffMNF = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif LessRest.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theFav# is coming off less rest from MNF.<br>'>
</cfif> 



<cfquery datasource="sysstats3" name="OffDIVGame">
Select * from Teams und
where Und.OffDIVGame = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif OffDIVGame.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL: Positive - #theUnd# is coming off a divisional game.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="OffDIVGame">
Select * from Teams fav
where fav.OffDivGame = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif OffDIVGame.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theFav# is coming off a divisional game.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="OffBigWin">
Select * from Teams fav
where fav.OffBigWin = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif OffBigWin.recordcount gt 0>
	<cfset FAVLiveRat = FAVLiveRat - 1> 
	<cfset msg = msg & 'SITUATIONAL(NEGATIVE): #theFav# is coming off a big win.<br>'>
</cfif> 


<cfquery datasource="sysstats3" name="OffPressure1">
Select AVG(und.PressureRate) as UndVal, AVG(fav.PressureRate) as favVal
from Sysstats und, Sysstats fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
</cfquery>
 
<cfquery datasource="sysstats3" name="DefPressure1">
Select AVG(und.dPressureRate) as UndVal, AVG(fav.dPressureRate) as favVal
from Sysstats und, Sysstats fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
</cfquery>

<cfset FavProjPressure = (OffPressure1.favval + DefPressure1.undval) / 2>
<cfset UndProjPressure = (OffPressure1.undval + DefPressure1.favval) / 2>


<cfquery datasource="sysstats3" name="OffPressure">
Select und.OffRat as UndVal, fav.OffRat as favVal
from PassPressure und, PassPressure fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
and fav.OffDef='O'
and Und.OffDef='O'
</cfquery>
 
<cfquery datasource="sysstats3" name="DefPressure">
Select und.DefRat as UndVal, fav.DefRat as favVal
from PassPressure und, PassPressure fav
where Und.Team = '#theund#'
and fav.Team   = '#thefav#'
and fav.OffDef='D'
and Und.OffDef='D'
</cfquery> 
 
<cfset Undval =  #DefPressure.favval# + #OffPressure.undval#>
<cfset favval =  #DefPressure.undval# + #OffPressure.favval#>
 
<cfif FavVal lt UndVal and FavProjPressure lt UndProjPressure >
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & '<b>#thefav# is predicted to have more QB pressure advantage.(#FavProjPressure#/#FavVal#)</b><br>'>
</cfif> 
<p>


<cfquery datasource="sysstats3" name="OffBadLoss">
Select *
from Teams fav
where fav.Team   = '#thefav#'
and fav.OffBadLoss='Y'
</cfquery> 

<cfif OffBadLoss.recordcount gt 0>
	<cfset FavLiveRat = FavLiveRat + 1> 
	<cfset msg = msg & 'SITUATIONAL(Postive) - #theFav# is off a bad loss.<br>'>
</cfif>

*********************************************************************************************<br>
<cfoutput>The Live Favorite Rating for <b>#theFav#</b> vs #theUnd# is <b>#FavLiveRat#</b><p>
#msg#
</cfoutput><br>
<cfset FavLiveRat = 0>
*********************************************************************************************

<cfquery datasource="sysstats3" name="UpdIt">
Update Teams 
SET MatchupSummary = '#msg#'
where Team in ('#theFav#')
</cfquery>



<p>
</cfloop>








