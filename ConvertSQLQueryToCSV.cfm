<cfquery datasource="PSP_PSP" name="GetSpreads">
SELECT (
'"' + Data1 + '",' + '"' + Data2 + '",' + '"' + Data3 + '",' + '"' + Data4 + '"' ) as Line
FROM NFLSpds
</cfquery>


and then just put result into the file:
<cfset filecontent = ValueList(GetSpreads.line,"#CHR(13)#")>
<cffile action="write" file="#fName#" output="#filecontent#" addnewline="yes">