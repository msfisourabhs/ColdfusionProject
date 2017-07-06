<!---
<cfdump var="#sortLetters(Hash("pass","SHA-512"))#" >

	<cffunction name="sortLetters" access="private" returntype="string" >
		<cfargument name="unsortedLetters" required="true" type="string" >
			<cfset sortedTemp = "">
			<cfset temps=[]>
			<cfset temp = Arguments.unsortedLetters.Split("")>
			<cfloop from="1" to="#arraylen(temp)#" index="i">
				<cfif temp[i] NEQ " ">
					<cfset temps[i] = Asc(temp[i])>
					
				</cfif>
			</cfloop>
			<cfset ArraySort(temps,"numeric")>
			<cfloop from="1" to="#arraylen(temps)#" index="i" >
				<cfset sortedTemp = sortedTemp & temps[i]>
			</cfloop>
			<cfreturn sortedTemp&"/"&arraylen(temps)>
	</cffunction>
	
<cffunction name="compareme" access="public" returntype="Numeric" >
	<cfargument name="s1" required="true" type="string" >
	<cfargument name="s2" required="true" type="string" >
		<cfset unicode1 = #Asc(mid(s1,1,1))#>
		<cfset unicode2 = #Asc(mid(s2,1,1))#>
		<cfif unicode1 GT unicode2>
			<cfreturn 1>
		<cfelseif unicode1 EQ unicode2>
			<cfreturn 0>
		<cfelse>
			<cfreturn -1>
		</cfif>	
</cffunction>>
<cfdump var="#Session#" >
<cfset te = "acbd">
<cfset l = #te.Split("")#>
<cfdump var="#isArray(l)#">
<cfset k = arrayToList(l)>
<cfdump var="#k#">
<cfdump var="#listSort(k,"text" )#">
<cfdump var="#k#">

<cfloop collection="#Session#" item="key">
	<cfoutput >
		#key#	
	</cfoutput>	
</cfloop>
<cfdump var="#nmSalt#">	
<cfdump var="#res#" >			
<cfdump var="#Len(Hash(GenerateSecretKey("AES"), "SHA-512"))#" >
<cfdump var="#Len(Hash("Sourabh" & salt, "SHA-512"))#" >


<cfdump var="#Stru	ctAppend(form,Session)#">
<cfdump var="#form#">
<cfset l = "firstname=&lastname=&user_email=&user_password=&user_confirm_password=&gender=M&phoneno=&phonenoAlt=&caddress=&paddress=&country=&state=&city=&capval=">
<cfset userInput = createObject("component",'components.fieldValidationService')>
		
<cfdump var="#userInput.validateName("")#">
		

<cfdump var="#l.split("&")#">
<cfloop array="#l.split("&")#" index="i">
	<cfdump var="#i.split("=")#">
</cfloop>

<cfhttp url="http://localhost/CF/CFSiteWithRegForm/index.cfm" method="post" result="res">	
	<cfhttpparam type="formfield" name="firstname" value="Sourabh1111111111" encoded="false" >
</cfhttp>
<cfdump var="#res#">
<cfoutput >
	#res.fileContent#
</cfoutput>

--->