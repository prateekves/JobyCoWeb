    $(document).ready(function(){
        $('[data-toggle="tooltip"]').tooltip({
                placement : 'bottom'
        });
    });
        $(document).ready(function() {
          $('.drawer').drawer();
        });      
	//click-login-JS 
    $(document).ready(function(){
        $("#hide").click(function(){
            $("#signDiv").fadeToggle("fast");
        });
        $("#show").click(function(){
            $("#signDiv").fadeToggle("fast");
        });
    });
    
        $('#show').click(function() {
        $('#logiDiv').addClass('hideDiv');
        $('#signDiv').addClass('disBlock');
    });
    
    $('#hide').click(function() {
        $('#logiDiv').removeClass('hideDiv');
        $('#signDiv').removeClass('disBlock');
    });
  
   // flag-phone-JS  
    $(".flag-tel").intlTelInput({
        utilsScript: "utils.js"
    });

    
