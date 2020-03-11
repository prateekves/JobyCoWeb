function getCurrentDate() {
    var d = new Date();
    var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    var month = d.getMonth() + 1;
    var day = d.getDate();

    //  var output = (day < 10 ? '0' : '') + day + ' ' + months[month - 1] + ' ' + d.getFullYear();

    var output = months[month - 1] + ' ' + (day < 10 ? '0' : '') + day + ', ' + d.getFullYear();
    return output;

}
function CharacterOnly(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (!((charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122) || (charCode == 8) || (charCode == 32))) {
        evt.preventDefault();
        return false;
    }

}
function NumericOnly(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (!((charCode >= 48 && charCode <= 57) || (charCode == 8))) {
        evt.preventDefault();
        return false;
    }
}
function IsEmail(email) {
    var regex = /^([a-zA-Z0-9_\.\-\+])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    if (!regex.test(email))
        return false;
    else
        return true;
}
function DateOnly(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (!((charCode >= 48 && charCode <= 57) || (charCode == 8) || (charCode == 47))) {
        evt.preventDefault();
        return false;
    }
}
function DecimalOnly(evt) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if (!((charCode >= 48 && charCode <= 57) || (charCode == 8) || (charCode == 46))) {
        evt.preventDefault();
        return false;
    }
}

function hasWhiteSpace(s) {
    return s.indexOf(' ') >= 0;
}

function countWhiteSpace(s) {
    return s.split(" ").length - 1;
}

function hasDash(s) {
    return s.indexOf('-') >= 0;
}

function AlphaNumericOnly(evt)
{
    var charCode = ( evt.which ) ? evt.which : event.keyCode
    if ( !( ( charCode >= 65 && charCode <= 90 )
        || ( charCode >= 97 && charCode <= 122 )
        || ( charCode == 8 )
        || ( charCode == 32 )
        || ( charCode >= 48 && charCode <= 57 )
        ) )
    {
        evt.preventDefault();
        return false;
    }
}

function restrictToOneDot( evt, valu )
{
    var charCode = ( evt.which ) ? evt.which : event.keyCode
    if ( ( charCode == 46 ) && valu.split( '.' ).length == 2 )
    {
        evt.preventDefault();
        return false;
    }
}

function restrictSpaceEntry(evt, valu) {
    var charCode = (evt.which) ? evt.which : event.keyCode
    if ((charCode == 32) && valu.split(' ').length > 0) {
        evt.preventDefault();
        return false;
    }
}

function roundOffDecimalValue( vDecimalValue )
{
    var fDecimalValue = parseFloat( vDecimalValue ).toFixed( 2 );
    var sDecimalValue = '£ ' + fDecimalValue.toString();

    return sDecimalValue;
}

function getCurrentDateDetails() {
    //Current Date Details
    var CurrentDate = new Date();

    //Day Part
    var CurrentDay = CurrentDate.getDate();
    var vCurrentDay = CurrentDay.toString();

    if (CurrentDay < 10) {
        vCurrentDay = "0" + vCurrentDay;
    }

    //Month Part
    var CurrentMonth = CurrentDate.getMonth() + 1;
    var vCurrentMonth = CurrentMonth.toString();

    if (CurrentMonth < 10) {
        vCurrentMonth = "0" + vCurrentMonth;
    }

    var vCurrentFullYear = CurrentDate.getFullYear().toString();

    return vCurrentDay + "-" + vCurrentMonth + "-" + vCurrentFullYear;
}

function getFormattedDateUK(date) {
    
    var date = new Date(parseInt(date.substr(6)));
    var month = date.getMonth() + 1;
    var day = date.getDate();
    var sDay = day.toString();
    var sMonth = month.toString();
    if (day < 10) {
        sDay = "0" + sDay;
    }
    if (month < 10) {
        sMonth = "0" + sMonth;
    }

    return sDay + "/" + sMonth + "/" + date.getFullYear();
}

function accessibleMenuItems(hfMenusAccessibleValues) {
    var vMenuItemsWithWhiteSpaces = hfMenusAccessibleValues;
    var vMenuItemsWithoutWhiteSpaces = vMenuItemsWithWhiteSpaces.replace(/ /g, "");

    var arrAccessibleMenus = vMenuItemsWithoutWhiteSpaces.split(",");
    $.each(arrAccessibleMenus, function (i) {
        $('#' + arrAccessibleMenus[i]).css('display', 'block');
    });
}

function accessiblePageControls(hfControlsAccessibleValues) {
    var vPageControlsWithWhiteSpaces = hfControlsAccessibleValues;
    var vPageControlsWithoutWhiteSpaces = vPageControlsWithWhiteSpaces.replace(/ /g, "");

    var arrAccessibleControls = vPageControlsWithoutWhiteSpaces.split(",");
    $.each(arrAccessibleControls, function (i) {
        $('#' + arrAccessibleControls[i]).css('display', 'none');
    });
}

function showErrorMessage(vTitle, vText) {
    swal({
        title: vTitle,
        text: vText,
        type: "warning",
        showCancelButton: true,
        confirmButtonColor: "#DD6B55",
        confirmButtonText: "Correct it!"
    },
    function () {
        swal("OK");
    });
}
function showSuccessMessage(vTitle, vText) {
    swal({
        title: vTitle,
        text: vText,
        type: "success"
    });
}
