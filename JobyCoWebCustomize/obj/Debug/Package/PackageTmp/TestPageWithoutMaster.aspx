<!doctype html>
<html>
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
    <title>jQuery IntlInputPhone Plugin Demo</title>
    <link href="https://www.jqueryscript.net/css/jquerysctipttop.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="css/intlInputPhone.css">
    <style>
    body { font-family:'Roboto'; background-color:#34BC9D;}
        form {
            width: 40%;
            margin: auto;
            margin-top: 150px;
        }
    </style>
</head>
<body>
    <form>
    <h1>jQuery IntlInputPhone Plugin Demo</h1>
        <div class="input-phone"></div>
    </form>

    <script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
    <script src="js/intlInputPhone.min.js"></script>
    <script>
        $(document).ready(function() {
            $( '.input-phone' ).intlInputPhone();
            alert( 'Input Phone' );
        })
    </script>    
</body>
</html>
