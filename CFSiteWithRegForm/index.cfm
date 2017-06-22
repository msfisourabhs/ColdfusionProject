<cfset show = CreateObject("component",'Projects.CFSiteWithRegForm.Application')>
<cfset show.readSesssionInfo()>	 
  <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign Up Form</title>
        
        <link href='https://fonts.googleapis.com/css?family=Nunito:400,300' rel='stylesheet' type='text/css'>
        <link rel="stylesheet" href="stylesheet/main.css">
       
    </head>
    <body>
	<p id="val"><p>
      <form action="actionPage.cfm" method="post" onsubmit="return validate()">
      
        <h1>Sign Up</h1>
        
        <fieldset>
          <legend><span class="number">1</span>Your basic info</legend>
          <label for="name" class="required">First Name:</label>
          <input type="text" id="fname" name="firstname" placeholder="First Name" class="required">
          
          <label for="name" class="required">Last Name:</label>
          <input type="text" id="lname" name="lastname" placeholder="Last Name" class="required">
          
          
          <label for="mail" class="required">Email:</label>
          <input type="email" id="mail" name="user_email" placeholder="Email Address" class="required">
          
          <label for="password" class="required">Password:</label>
          <input type="password" id="password" name="user_password" maxlength="10" class="required">
          
          <label for="password" class="required">Confirm Password:</label>
          <input type="password" id="cpassword" name="user_confirm_password" maxlength="10" class="required">
          
          <label class="required">Gender</label>
				<input type="radio" name="gender" id="gn_male" value="M" checked="checked" class="required"><label class="light" for="gn_male" >Male</label>
				<input type="radio" name="gender" id="gn_female" value="F" class="required"><label class="light" for="gn_female" >Female</label>
          
          <label class="required">Phone Number </label><input type="text" name="phoneno" maxlength="10" placeholder="Phone Number" class="required">
			<label> Alternate Phone Number </label><input type="text" name="phonenoAlt" maxlength="10" placeholder="Alternate Phone number" >
        </fieldset>
        
        <fieldset>
          <legend><span class="number">2</span>Corrospondence</legend>
          <label for="corrsp" class="required">Cuurent Address</label>
          <textarea id="corrsp" name="caddress" class="required"></textarea>
          
          <label for="corrsp">Permanent Address</label>
          <textarea id="corrsp" name="paddress"></textarea>
          
          <label class="required">Country</label>
          <select name="country" class="countries order-alpha required" id="countryId" >
   			 <option value="">Select Country</option>
			</select>
		  <label class="required">State</label>
		  <select name="state" class="states order-alpha required" id="stateId" >
  		     <option value="">Select State</option>
		  </select>
		<script src="//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js"></script> 
		<script src="//geodata.solutions/includes/countrystate.js"></script>
          <label class="required">City</label><input type="text" name="city" placeholder="City Name" class="required">
       
          
        </fieldset>
        <fieldset>  
       
        <legend><span class="number">3</span>Personal Interests</legend>
        <label>Subscribe News Letter?</label>
		<input type="radio"  id="in_yes" name="subs_value" value="Y" ><label class="light" for="in_yes" >Yes</label>
		<input type="radio" id="in_no" name="subs_value" value="N" ><label class="light" for="in_no" >No</label>
        
          <label>Interests:</label>
          <input type="checkbox" id="sports" value="Sports" name="user_interest"><label class="light" for="sports">Sports</label><br>
          <input type="checkbox" id="books" value="Books" name="user_interest"><label class="light" for="books">Books</label><br>
          <input type="checkbox" id="fashion" value="Fashion" name="user_interest"><label class="light" for="fashion">Fashion</label><br>
          <input type="checkbox" id="gaming" checkedvalue="Gaming" name="user_interest"><label class="light" for="gaming">Gaming</label><br>
          <input type="checkbox" id="photography" value="Photography" name="user_interest"><label class="light" for="photography">Photography</label><br>
          <input type="checkbox" id="computerandsoftwares" value="ComputerAndSoftwares" name="user_interest"><label class="light" for="computerandsoftwares">Computer and Softwares</label>
          
        </fieldset>
        
        <strong>Captcha </strong><br><br>
        	<label id="captcha" style="display:inline-block;padding:10px 40px 0px 40px"> num1 operand num2</label>
        	<button type="button" type="refresh" style="width:30%;display:inline-block;float:right;" onclick="createCaptcha()">Refresh</button><br><br><br><br>
        	<input type="text" name="capval" placeholder="Enter the result for Captcha" style="display:inline-block;width:60%">
        	<button type="button" type="Check" style="width:30%;display:inline-block;float:right" onclick="checkCaptcha()">Check</button>
        	<label id="capmssg"></label>
        	
        <button type="submit" id="submitbttn"disabled onsubmit="validate()">Sign Up</button>
		
      </form>
      <div class="fixed">
			<p>* marked fields are mandatory</p>
	  </div>
     
     
     
      <script src="js/script.js"></script>
      
      
    </body>
</html>