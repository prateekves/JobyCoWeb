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

    //function toggleIcon(e) {
    //    $(e.target)
    //        .prev('.panel-heading')
    //        .find(".more-less")
    //        .toggleClass('glyphicon-plus glyphicon-minus');
    //}
    //$('.panel-group').on('hidden.bs.collapse', toggleIcon);
//$('.panel-group').on('shown.bs.collapse', toggleIcon);

    $('#exampleModal').on('show.bs.modal', function (event) {
        var button = $(event.relatedTarget) // Button that triggered the modal
        var recipient = button.data('whatever') // Extract info from data-* attributes
        // If necessary, you could initiate an AJAX request here (and then do the updating in a callback).
        // Update the modal's content. We'll use jQuery here, but you could use a data binding library or other methods instead.
        var modal = $(this)
        modal.find('.modal-title').text('New message to ' + recipient)
        modal.find('.modal-body input').val(recipient)
    })
