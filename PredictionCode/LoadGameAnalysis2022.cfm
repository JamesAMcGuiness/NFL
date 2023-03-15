
<cfquery datasource="sysstats3" name="GetGames">
Select n.* from NFLSPDS n, Week w
where n.week = w.week 
</cfquery>

<cfloop query="GetGames">
<cfset theweek = GetGames.Week>
<cfset thefav = Getgames.Fav>
<cfset theund = Getgames.Und>
<cfset msg = ''>

<cfset UndLiveRat = 0>
<cfset UndSitRat = 0>
<cfset FavSitRat = 0>



<cfquery datasource="sysstats3" name="GetOverUnderRated">
Select * from GameInsights 
where week = #theweek - 1#
And (OverratedPerformance='Y')
and Team in ('#thefav#')
</cfquery>

<cfif GetOverUnderRated.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theFAV# had an overrated game last week<br>'>
	
	
	<cfset FavSitRat = FavSitRat - 1>
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','OppOffOverratedGame','(Pos) #theFAV# had an overrated game last week','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','OffOverratedGame','(Neg) #theFAV# had an overrated game last week','NEG')>
	</cfquery>


	
</cfif>	




<cfquery datasource="sysstats3" name="GetOverUnderRated">
Select * from GameInsights 
where week = #theweek - 1#
And (UnderratedPerformance='Y')
and Team in ('#theund#')
</cfquery>

<cfif GetOverUnderRated.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# had an underrated game last week<br>'>
	
	<cfset UndSitRat = UndSitRat + 1>
	
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','OffUnderratedGame','(Pos) #theUnd# had an underrated game last week','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','OppUnderratedGame','(Neg) #theUnd# had an underrated game last week','NEG')>
	</cfquery>
	
	
</cfif>	



<cfquery datasource="sysstats3" name="GetOverallSuccess">
Select fav.PlaySuccessRt, fav.Fav, und.PlaySuccessRt, und.Fav from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and und.PlaySuccessRt >= fav.PlaySuccessRt 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>


<cfif GetOverallSuccess.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a better projected overall success rate<br>'>
	
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','SuccessRate','(Pos) #theUnd# has a better projected overall success rate.','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','SuccessRate','(Neg) #theUnd# has a better projected overall success rate.','NEG')>
	</cfquery>

	
	
</cfif>	



<cfquery datasource="sysstats3" name="GetBigPlay">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.BigPlayRt >= Fav.BigPlayRt 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>

<cfif GetBigPlay.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a better projected Big Play success rate<br>'>
	
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','BigPlaySuccessRate','(Pos) #theUnd# has a better projected big play success rate.','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','BigPlaySuccessRate','(Neg) #theUnd# has a better projected big play success rate.','NEG')>
	</cfquery>

	
	
</cfif>	



<cfquery datasource="sysstats3" name="GetRZSuccuss">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.RedzoneSuccessRt >= Fav.RedzoneSuccessRt 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>

<cfif GetRZSuccuss.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a better projected redzone success rate<br>'>
	
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','RedzoneSuccessRate','(Pos) #theUnd# has a better projected redzone success rate.','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','RedzoneSuccessRate','(Neg) #theUnd# has a better projected redzone success rate.','NEG')>
	</cfquery>

	
	
	
	
</cfif>



<cfquery datasource="sysstats3" name="Gettogo3rd">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.AvgToGo3rdDown <= Fav.AvgToGo3rdDown 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>


<cfif Gettogo3rd.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a better projected 3rd down togo rate<br>'>
</cfif>




<cfquery datasource="sysstats3" name="BadResult3rd">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.BadResult3rdDown <= Fav.BadResult3rdDown 
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>


<cfif BadResult3rd.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a better projected performance on 3rd and long.<br>'>
	
	
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','3rd and long','(Pos) #theUnd# has a better projected 3rd and long success rate.','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','3rd and long','(Neg) #theUnd# has a better projected 3rd and long success rate.','NEG')>
	</cfquery>
	
</cfif>



<cfquery datasource="sysstats3" name="Int3rdLong">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.Int3rdAndLongRt <= Fav.Int3rdAndLongRt
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif Int3rdLong.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a better projected INT rate on passing situations.<br>'>
	
	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#theund#','IntRate','(Pos) #theUnd# has a better projected 3rd and long success rate.','POS')>
	</cfquery>

	<cfquery datasource="sysstats3" name="Addit">
	Insert into GameAnalysis (Week,Fav,Und,Team,StatCat,StatDesc,PosNeg) values(#theweek#,'#thefav#','#theund#','#thefav#','IntRate','(Neg) #theUnd# has a better projected 3rd and long success rate.','NEG')>
	</cfquery>
	
	
	
</cfif> 

 

<cfquery datasource="sysstats3" name="RunSuccRt">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.RunSuccessRt >= Fav.RunSuccessRt
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif RunSuccRt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>(Pos) #theUnd# has a better projected Run success rate</b><br>'>
</cfif> 
 
 
 

<cfquery datasource="sysstats3" name="aPowerPtsPass">
Select fav.PowerPtsPass, und.PowerPtsPass from betterThanAvg fav, betterThanAvg und
where Und.PowerPtsPass > Fav.PowerPtsPass
and fav.Team in ('#thefav#')
and und.Team in ('#theund#')
</cfquery>



<cfif aPowerPtsPass.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>(Pos) #theUnd# has a better PowerPtsPass rating.</b><br>'>
</cfif>



<cfquery datasource="sysstats3" name="FavAboveCt">
Select * from GameInsights fav
where fav.week = #theweek - 1#
and fav.ConseqAboveExpCt >= 2
and fav.Team in ('#thefav#')
</cfquery>

<cfif FavAboveCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '<b>(Pos) #theFav# has 2+ above expectation games.</b><br>'>
	

	<cfset FavSitRat = FavSitRat - 1>

	
</cfif>





<cfquery datasource="sysstats3" name="UndBelowCt">
Select * from GameInsights und
where und.week = #theweek - 1#
and und.ConseqBelowExpCt >= 2
and und.Team in ('#theund#')
</cfquery>

<cfif UndBelowCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	
	<cfset UndSitRat = UndSitRat + 1>

	
	<cfset msg = msg & '<b> (Pos) #theUnd# has 2+ under expectation games.</b><br>'>
</cfif>





<cfquery datasource="sysstats3" name="SpotLevel1">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.SpotLevelPlay1 = 'Y'
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif SpotLevel1.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a Spot Level 1 play situation.<br>'>
	<cfset UndSitRat = UndSitRat + 1>
	
</cfif> 


<cfquery datasource="sysstats3" name="SpotLevel2">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Und.SpotLevelPlay2 = 'Y'
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif SpotLevel2.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  + 1> 
	<cfset msg = msg & '(Pos) #theUnd# has a Spot Level 2 play situation.<br>'>
	<cfset UndSitRat = UndSitRat + 1>

</cfif> 



<cfquery datasource="sysstats3" name="SpotLevel1">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Fav.SpotLevelPlay1 = 'Y'
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif SpotLevel1.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat  - 1> 
	<cfset msg = msg & '(Neg) #thefav# however has a Spot Level 1 play situation.<br>'>

	<cfset FavSitRat = FavSitRat + 1>
	
</cfif> 


<cfquery datasource="sysstats3" name="SpotLevel2">
Select * from PBPGameProjections fav, PBPGameProjections und
where fav.week = #theweek#
and Und.Week = Fav.Week 
and Fav.SpotLevelPlay2 = 'Y'
and fav.Fav in ('#thefav#') 
and und.Fav in ('#theund#')
</cfquery>
 
<cfif SpotLevel2.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theFav# has a Spot Level 2 play situation.<br>'>
	
	<cfset FavSitRat = FavSitRat + 1>

</cfif> 



<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from PBPGameProjections fav
where fav.week = #theweek#
and Fav.ConseqRdCt = 2
and fav.Fav in ('#thefav#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & "(Pos) This is " &  "#theFav#'" & "'s"  & " second successive road trip.<br>">

	<cfset FavSitRat = FavSitRat - 1>

</cfif> 



<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from PBPGameProjections fav
where fav.week = #theweek#
and Fav.ConseqRdCt = 3
and fav.Fav in ('#thefav#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 2> 
	<cfset msg = msg & "(Pos) This is " &  "#theFav#'" & "'s"  & " THIRD successive road trip.<br>">

	<cfset FavSitRat = FavSitRat - 2>

</cfif> 





<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from PBPGameProjections und
where und.week = #theweek#
and Und.ConseqRdCt = 2
and und.Fav in ('#theund#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & "(Neg) This is " &  "#theUnd#'" & "'s"  & " second successive road trip.<br>">
	<cfset UndSitRat = UndSitRat - 1>

</cfif> 


<cfquery datasource="sysstats3" name="ConseqRdCt">
Select * from PBPGameProjections und
where und.week = #theweek#
and Und.ConseqRdCt = 3
and und.Fav in ('#theund#') 
</cfquery>
 
<cfif ConseqRdCt.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & "(Neg) This is " &  "#theUnd#'" & "'s"  & " THIRD successive road trip.<br>">
	<cfset UndSitRat = UndSitRat - 2>

</cfif> 




<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams und
where Und.OffExtraTravel = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theUnd# is coming off extra travel.<br>'>
	<cfset UndSitRat = UndSitRat - 1>

</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams fav
where fav.OffExtraTravel = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '(Pos) #theFav# is coming off extra travel.<br>'>

	<cfset FavSitRat = FavSitRat - 1>

</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams und
where Und.CoastToCoast = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theUnd# is traveling coast to coast.<br>'>
	<cfset UndSitRat = UndSitRat - 1>


</cfif> 


<cfquery datasource="sysstats3" name="ExtraTravel">
Select * from Teams fav
where fav.CoastToCoast = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraTravel.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '(Pos) #theFav# is traveling coast to coast.<br>'>
	
	<cfset FavSitRat = FavSitRat - 1>

</cfif> 

<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams und
where Und.ExtraRest = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '(Pos) #theUnd# is coming off extra rest.<br>'> 
	<cfset UndSitRat = UndSitRat + 1>
	
</cfif> 


<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams fav
where fav.ExtraRest = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theFav# is coming off extra rest.<br>'> 

	<cfset FavSitRat = FavSitRat + 1>

</cfif> 








<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams und
where Und.OffTNF = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1>
	<cfset msg = msg & '(Pos) #theUnd# is coming off extra rest from TNF.<br>'>	
	<cfset UndSitRat = UndSitRat + 1>

</cfif> 


<cfquery datasource="sysstats3" name="ExtraRest">
Select * from Teams fav
where fav.OffTNF = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif ExtraRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theFav# is coming off extra rest from TNF.<br>'>

	<cfset FavSitRat = FavSitRat + 1>

</cfif> 






<cfquery datasource="sysstats3" name="LessRest">
Select * from Teams und
where Und.OffMNF = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif LessRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theUnd# is coming off less rest from MNF.<br>'> 
	<cfset UndSitRat = UndSitRat - 1>
	

</cfif> 


<cfquery datasource="sysstats3" name="LessRest">
Select * from Teams fav
where fav.OffMNF = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif LessRest.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '(Pos) #theFav# is coming off less rest from MNF.<br>'>

	<cfset FavSitRat = FavSitRat - 1>

</cfif> 



<cfquery datasource="sysstats3" name="OffDIVGame">
Select * from Teams und
where Und.OffDIVGame = 'Y'
and und.Team = '#theund#'
</cfquery>
 
<cfif OffDIVGame.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat - 1> 
	<cfset msg = msg & '(Neg) #theUnd# is coming off a divisional game.<br>'> 
	<cfset UndSitRat = UndSitRat - 1>


</cfif> 


<cfquery datasource="sysstats3" name="OffDIVGame">
Select * from Teams fav
where fav.OffDivGame = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif OffDIVGame.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '(Pos) #theFav# is coming off a divisional game.<br>'>

	<cfset FavSitRat = FavSitRat - 1>

</cfif> 


<cfquery datasource="sysstats3" name="OffBigWin">
Select * from Teams fav
where fav.OffBigWin = 'Y'
and fav.Team = '#thefav#'
</cfquery>
 
<cfif OffBigWin.recordcount gt 0>
	<cfset UndLiveRat = UndLiveRat + 1> 
	<cfset msg = msg & '(Pos) #theFav# is coming off a big win.<br>'> 

	<cfset FavSitRat = FavSitRat - 1>

</cfif> 


<cfset msg = msg & 'The Live Underdog Rating for <b>#theUnd#</b> vs #thefav# is <b>#UndLiveRat#</b>'>


<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('LiveDogRat','LiveDogRat','#theund#',#theweek#,#UndLiveRat#)
</cfquery>

<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('UndSitRat','UndSitRat','#theund#',#theweek#,#UndSitRat#)
</cfquery>

<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('FavSitRat','FavSitRat','#thefav#',#theweek#,#FavSitRat#)
</cfquery>

<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('UndSitRatDiff','UndSitRatDiff','#theund#',#theweek#,#UndSitRat - FavSitRat#)
</cfquery>

<cfquery datasource="sysstats3" name="MatchupRat3">
	Insert into MatchUps (StatType,StatDesc,Team,Week,StatValue) values ('FavSitRatDiff','FavSitRatDiff','#thefav#',#theweek#,#FavSitRat - UndSitRat#)
</cfquery>



<cfoutput>
#msg#
</cfoutput><br>
<cfset UndLiveRat = 0>
***************************************************************************

<cfquery datasource="sysstats3" name="UpdIt">
Update Teams 
SET MatchupSummary = '#msg#'
where Team in ('#theund#')
</cfquery>

<p>
</cfloop>

