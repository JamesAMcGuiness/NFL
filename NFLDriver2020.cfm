<cfinclude template="CreateBetterThanAvgsNFL.cfm">
11111111111111111111111111111111111111111111<p>

<cfinclude template="../NFLCode/PredictionCode/createPassPressure.cfm">
211111111111111111111111111111111111111111111<p>

<cfinclude template="PowerRating2020.cfm">
311111111111111111111111111111111111111111111<p>

<cfinclude template="../NFLCode/PlayByPlay/PBPSuccessRate2020.cfm">
411111111111111111111111111111111111111111111<p>


<cfinclude template="../NFLCode/PlayByPlay/ShowPBPSuccessRate.cfm">
611111111111111111111111111111111111111111111<p> - This creates BTAPBBSuccessRates so you can run CreateAdjustedPBPStats2020.cfm

<cfabort>


Now run one at a time..


-- Creates the AdjPBPSuccessRates table
<cfinclude template="../NFLCode/PlayByPlay/CreateAdjustedPBPStats2020.cfm">
511111111111111111111111111111111111111111111<p>

Change week number and make Predictions..

Now run again..
<cfinclude template="../NFLCode/PlayByPlay/ShowPBPSuccessRate.cfm">
611111111111111111111111111111111111111111111<p> 


-- Load PowerStats table - Each game creates a +/- of how well they did versus opponents averages
<cfinclude template="../NFLCode/PowerStats.cfm">
711111111111111111111111111111111111111111111<p>

<cfinclude template="../NFLCode/PowerRatingAdj2020.cfm">
811111111111111111111111111111111111111111111<p>

<cfinclude template="../NFLCode/LoadPressureStats2020.cfm">
911111111111111111111111111111111111111111111<p>


1. <cfinclude template="../NFLCode/CreateStats2019_backup.cfm"> 
2. <cfinclude template="../NFLCode/NFLStatMatchUps.cfm">
3. <cfinclude template="../NFLCode/PredictionCode/LiveDog2020.cfm">
4. <cfinclude template="../NFLCode/PredictionCode/LiveDog2020AdjForOpp.cfm">
5. <cfinclude template="../NFLCode/PlayByPlay/PBPCompareTeams.cfm">
6. <cfinclude template="../NFLCode/FinalAnalysisForPlayingUnderdog2021.cfm">

Finished!

Other Stuff:
http://127.0.0.1:8500/NFLCode/PlayByPlay/LuckFactorInTeamWins.cfm - Shows how much luck a team had in their wins...


