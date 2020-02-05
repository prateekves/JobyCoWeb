<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Greetings.aspx.cs" Inherits="JobyCoWebCustomize.Greetings" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>
    <link rel="icon" href="/images/favicon.png"/>

    <title>Jobyco</title>

    <!-- Bootstrap core CSS -->
    <link href="/css/bootstrap.css" rel="stylesheet"/>

    <!-- Custom styles for this template -->
    <link href="/css/custom.css" rel="stylesheet"/>
    
    <!-- tel flag styles for this template -->
    <link href="/css/font-awesome.css" rel="stylesheet"/>
    
    <!-- font awesome styles for this template -->
    <link rel="stylesheet" href="/css/intlTelInput.css"/>
    
    <!-- drawer styles for this template -->
    <link href="/css/drawer.css" rel="stylesheet"/>
    
    <!-- multiForm styles for this template -->
    <link href="/css/multiForm.css" rel="stylesheet"/>
</head>
<body>
    <form id="form1" runat="server">
    <nav class="navbar navbar-default navbar-static-top innerMenu">
      <div class="container">
        <div class="navbar-header">
          <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>
          <a class="navbar-brand" href="/Landing.aspx"><img src="/images/logo.svg" alt="" class="img-responsive" /></a>
        </div>
        <div id="navbar" class="navbar-collapse collapse">
          <ul class="nav navbar-nav navbar-right">
            <li id="Landing" class="active"><a href="/Landing.aspx">Home</a></li>
            <li id="AboutUs"><a href="/AboutUs.aspx">About</a></li>
            <li><a href="/Landing.aspx">Quote</a></li>
            <li id="ContactUs"><a href="/ContactUs.aspx">Contact</a></li>
            <li id="Careers"><a href="/Careers.aspx">Careers</a></li>
            <li id="FAQs"><a href="/FAQs.aspx">Help</a></li>
            <li><a href="/Login.aspx">Customer Portal</a></li>
          </ul>
        </div><!--/.nav-collapse -->
      </div>
    </nav>
    <div>
        <div style="height: 200px;">

        </div>
        <h1 style="color: burlywood; border: 2px solid burlywood;">One of our representatives will get in touch with you. Thank you for your business.</h1>
        <br /><br />
        <a href="/Landing.aspx" style="text-decoration: none;">Back to Home</a>
    </div>
    </form>
</body>
</html>
