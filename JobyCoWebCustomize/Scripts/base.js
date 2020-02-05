var $datePickerOptions = {
    changeMonth: true,
    dateFormat: "d MM yy",
    altFormat: "yy-mm-dd",
    changeYear: true,
    yearRange: "-100:+0",
    defaultDate: "-18y",
    maxDate: "-18y",
    minDate: null
};
$(document).ready(function () {
    autosize($('textarea'));
    $('a[href^=#]').click(function (e) {
        e.preventDefault()
    });
    $("[data-toggle=tooltip]").tooltip({container: 'body'});
    $("[data-toggle=popover]").popover();

    $(".bifa").popover({html: true, trigger: 'hover', container: "body"});

    $('[type="tel"]').numberOnly({stripLeadingZero: true});
    $('.navigate').click(function () {
        $('.menu')
            .toggleClass("display")
            .addClass('disable-trans');
        $('.body').toggleClass("push-left");
    });
    $('.mobile-input,.telephone-input').on('focus', function () {
        $(this).prop('required', true);
        var $lab = $(this).closest('.form-group').find('label');
        switch ($(this).data('type')) {
            case 'mobile':
                $(this).closest(".quote-box, .modal-body")
                    .find('.telephone-input').prop('required', false);
                $(this).closest(".quote-box, .modal-body")
                    .find('.mobile-label').text("Mobile");
                break;
            case 'telephone':
                $(this).closest(".quote-box, .modal-body")
                    .find('.mobile-input').prop('required', false);
                $(this).closest(".quote-box, .modal-body")
                    .find('.telephone-label').text("Telephone");
                break;

        }
    });
    $('.bxslider').bxSlider({
        speed: 700,
        auto: false,
        mode: 'fade',
        controls: false,
        preloadImages: "all"
    });
    $('.country-input').on('change', function () {
        var $parent = $(this).closest(".quote-box, .modal-body");
        $parent.find(".tel-prepend").text($(":selected", this).data('dial'));
        $parent.find(".tel-input-prepend").val($(":selected", this).data('dial'));

        if ($.inArray($(this).val(), ["GH"]) > -1) {
            $parent.find('.postcode-input').prop("required", false);
            $parent.find('.postcode-label').text("Postcode")
        } else {
            $parent.find('.postcode-input').prop("required", true)
        }
    }).trigger('change');
});