<!---
	Filename 		: 	errorPage.cfm
 	Functionality	:	Serves as error page generated with custom error messages 
	Creation Date	:	July ‎4, ‎2017, ‏‎10:12:53 AM

--->
<!DOCTYPE HTML>
<html>
	<head>
	<title>Error Occurred</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
		<link href="../stylesheet/errorPage.css" rel="stylesheet" type="text/css" media="all" />
		</head>
	<body>
		<div class="wrap">
			<div class="content">
				<div class="logo">
					<span><img src="../images/signal.png"/><cfoutput>#errorMessage#</cfoutput></span>
				</div>
			</div>	
		</div>	
	</body>
</html>