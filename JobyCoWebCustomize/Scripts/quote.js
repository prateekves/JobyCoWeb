function calculateVAT(number) {
    return ((20 / 100) * number).toFixed(2);
}

function updateOrderTotals() {
    var ordertotal = 0, ordersubtotal = 0, ordervat = 0;
    $('.aa-price-subtotal span').each(function (k, span) {
        ordersubtotal += parseFloat($(span).text())
    });
    $('.aa-price-vat span').each(function (k, span) {
        ordervat += parseFloat($(span).text())
    });
    $('.aa-price-total span,.aa-price-total-inc-vat span').each(function (k, span) {
        ordertotal += parseFloat($(span).text())
    });
    $(".order-subtotal span").text(ordersubtotal.toFixed(2));
    $(".order-vat span").text(ordervat.toFixed(2));
    $(".order-total span").text(ordertotal.toFixed(2));
}

// Pickup / Delivery related
function updateTotal(_self) {
    var _elem;
    if (_self.hasOwnProperty('$element')) {
        _elem = _self.$element;
    } else {
        _elem = _self;
    }
    var total = 0;
    $('.aa-price-label span', _elem).each(function (k, span) {
        total += parseFloat($(span).text());
    });
    $('.aa-price-subtotal span', _elem).text(total.toFixed(2));
    if (vatRequired) {
        $('.aa-price-vat span', _elem).text(calculateVAT(total.toFixed(2)));
        $('.aa-price-total-inc-vat span', _elem).text((total * 1.2).toFixed(2));
    } else {
        $('.aa-price-vat span', _elem).text(0);
        $('.aa-price-total-inc-vat span', _elem).text(total.toFixed(2));
    }
    $('.aa-price-total span', _elem).text(total.toFixed(2));
    updateOrderTotals();
}
function updateVolumeTotal(_self) {
    var _elem;
    if (_self.hasOwnProperty('$element')) {
        _elem = _self.$element;
    } else {
        _elem = _self;
    }
    var total = 0;
    $('.aa-item-row', _elem).each(function (k, row) {
        total += parseFloat($(row).data("volume"));
    });
    var price = total / ($s.vd || 3600);
    price = (price < (parseFloat($s.vp) || 0.00)) ? parseFloat($s.vp) : price;
    $('.aa-price-subtotal span', _elem).text(price.toFixed(2));
    if (vatRequired) {
        $('.aa-price-vat span', _elem).text(calculateVAT(price.toFixed(2)));
        $('.aa-price-total-inc-vat span', _elem).text((price * 1.2).toFixed(2));
    } else {
        $('.aa-price-vat span', _elem).text(0);
        $('.aa-price-total-inc-vat span', _elem).text(price.toFixed(2));
    }
    $('.aa-price-total span', _elem).text(price.toFixed(2));
    updateOrderTotals();
}
var restricted = false,
    itemValid = false,
    estimate = false,
    email = false,
    confirm = false,
    vatRequired = false;
var popoverSettings = {
    placement: "top",
    container: "body",
    html: true,
    title: "Please Add Description",
    trigger: "manual",
    content: "<div class='maxLength'><textarea class='otherDescArea'></textarea></div><div><button type='button' class='btn btn-primary saveOtherDesc'>Save</button></div>",
};
function doQuote() {
    $(".details-page.confirmation").find(".tab-btn-last").prop('disabled', true).before("<button type='button' class='btn btn-primary tab-fetch-quote'>Send Quote</button>").end()
        .on({
            click: function () {
                var _self = this;
                var _extraChecks = [];
                _extraChecks.push({"val": confirm, error: "Please confirm that the above details are correct.", "element": $('#confirm')});
                _extraChecks.push({"val": email, error: "Email Address is not valid."});

                var _checkform = checkForm($("#quote-form").find(".active"), _extraChecks);
                if (_checkform != true) {
                    $(".tab-container").trigger('tab-error', [_checkform]);
                    $(_self).prop("disabled", false).text("Send Quote");
                } else {
                    $(_self).prop("disabled", true).text("Please Wait...");
                    $.ajax({
                            type: "POST",
                            url: "/includes/getQuote.php",
                            dataType: "json",
                            data: {
                                type: "make",
                                userId: $("#id").val(),
                                details: store("session", "get", "store1"),
                                items: store("session", "get", "store0"),
                                email: $("#quoteEmail").val(),
                                vreq: $('#vreq').val()
                            }
                        })
                        .done(function (data) {
                            $(".details-page .tab-btn-last").prop('disabled', false).data('quote-id', data.quoteID);
                            $(_self).text("Quote Sent");
                            $(".conditions").after(
                                '<div class="alert alert-success alert-dismissible" role="alert">' +
                                '<button type="button" class="close" data-dismiss="alert" aria-label="Close"><span aria-hidden="true">&times;</span></button>' +
                                '<strong>Quote Sent!</strong> A quote has been sent to ' + $('#quoteEmail').val() + ', If you have not received this quote in 5 minutes, please check your spam folder.' +
                                '</div>'
                            )
                        })
                        .fail(function () {
                            $(_self).prop("disabled", false).text("Send Quote");
                        });
                }
            }
        }, ".tab-fetch-quote")
}
$(document).ready(function () {
    store("session", "clear");
    $('.vat-option').on({
        change: function () {
            var _registered = (($("#registered-company").val() != '') ? parseInt($("#registered-company").val()) : 0);
            var _goodsIn = (($("#goods-in-name").val() != '') ? parseInt($("#goods-in-name").val()) : 0);

            if (_registered == 1) {
                $('.vat-goods-in').show().removeClass('hidden');
            } else {
                $('.vat-goods-in').hide().addClass('hidden');
            }

            vatRequired = ((_registered + _goodsIn) == 2);
            $("#vreq").val(((_registered + _goodsIn) == 2) ? 1 : 0);
            updateTotal($("#pickup"));
        }
    });
    $('body').on({
        click: function () {
            var $popover = $(this).closest('.popover');
            var _txt = $popover.find('.otherDescArea').val();
            $('.otherDescHidden', $popover.data('bs.popover').$element).val(_txt);
            if (_txt.length > 0) {
                $popover.data('bs.popover').$element.addClass("text-success");
            } else {
                $popover.data('bs.popover').$element.removeClass("text-success");
            }
            $popover.data('bs.popover').$element.popover('hide');
        }
    }, ".saveOtherDesc");

    var pickupHandlers = function (_self) {
        _self.$element
            .on({
                change: function () {
                    var _item = $(this).val();
                    var _column = $(_self.config.columnElements[1]).clone(true);
                    var $row = $(this).closest(_self.config.rowClass);
                    $("option", _column).filter(function () {
                        return ($(this).data('item-cat') != _item)
                    }).remove();
                    if ($('option', _column).length > 1) {
                        $(_column).prepend('<option value="" data-price="0" selected>Please Select item</option>')
                    }
                    $('[data-column="1"] select', $row).html(_column.html()).trigger("change");
                    if ($('option', _column).length > 1) {
                        $('[data-column="1"] select', $row).show();
                    } else {
                        $('[data-column="1"] select', $row).hide();
                    }
                    if (_self.config.readOnly) {
                        $("input,select", $('[data-column="1"]', $row)).prop("disabled", true);
                    }
                    if ($(this).val() == 26) {
                        $('.otherWrapper', $row).show();
                    } else {
                        $('.otherWrapper', $row).hide();
                    }
                }
            }, '.itemcatPickup')
            .on({
                click: function () {
                    var $row = $(this).closest(_self.config.rowClass);
                    var $popover = $(".otherWrapper", $row).data('bs.popover').tip();
                    $(".otherWrapper", $row).popover("show");
                    if (($(".maxLength", $popover).data('wordCount')) == undefined) {
                        $(".maxLength", $popover).wordCount({maxLength: 160})
                    }
                    $(".maxLength textarea", $popover).val($(".otherDescHidden", this).val()).trigger('keyup');
                }
            }, ".otherWrapper")
            .on({
                change: function () {
                    var $row = $(this).closest(_self.config.rowClass);
                    $(".otherWrapper", $row).popover("hide");
                    var price = ($(":selected", this).data('price') || 0).toFixed(2);
                    $($(this).closest(_self.config.rowClass).data("price", price).find('.aa-price-label span').text(price));
                    updateTotal(_self);
                }
            }, ".items")
            .on({
                click: function () {
                    pickupAsync.asyncAdd("removeRow", $(this))
                }
            }, '.aa-remove-row')
            .on({
                click: function () {
                    pickupAsync.asyncAdd("addRow");
                }
            }, '.aa-add-row')
            .on({
                "aa-row-added": function (e, row) {
                    if (!$($('.aa-item-row .itemcatPickup', _self.$element)[row]).val()) {
                        $($('.aa-item-row .items', _self.$element)[row]).html('')
                    }
                    $(".otherWrapper", $('.aa-item-row', _self.$element)[row]).popover(popoverSettings).on({
                        "shown.bs.popover": function () {
                            autosize($('textarea'));
                        }
                    });
                    $($('.estimatevalue', _self.$element)[row]).numberOnly({regex: "[0-9\.]+"});

                },
                "aa-row-removed": function () {
                    updateTotal(_self);
                },
                "aa-row-data-loaded": function () {
                    updateTotal(_self);
                }
            });
    };
    var pickupAsync =
        $("#pickup")
            .asyncAdd({
                readOnly: false,
                hasVAT: true,
                handlers: pickupHandlers,
                columnElements: [
                    $(".itemcatPickup").prop('outerHTML'),
                    $("#pickupItems.items").prop('outerHTML'),
                    '<label class="fragile-label fragile">' +
                    '<input type="checkbox" class="" name="fragile">' +
                    '<input type="hidden" id="fragile" name="fragile" value="off">' +
                    '<span>FRAGILE?</span>' +
                    '</label>',
                    '<div class="input-group">' +
                    '<div class="input-group-addon">&pound;</div>' +
                    '<label for="estimatedValue" class="hidden">Estimated Value</label><input class="form-control estimatevalue" required type="text" placeholder="Estimated Value" name="estimatedValue" id="estimatedValue">' +
                    '<span class="glyphicon form-control-feedback" aria-hidden="true"></span>' +
                    '</div>',
                    '<div class="otherWrapper"><span class="other glyphicon glyphicon-copy"><input type="hidden" name="otherDesc" id="otherDesc" class="otherDescHidden"></span><span class="otherDetails">Details</span></div>'
                ],
                columnWidths: [3, 3, 2, 3, 1]
            });
    $('.tmp').remove();
    $("#conditions").on({
        click: function () {
            restricted = $(this).is(":checked");
        }
    });
    $("#confirm").on({
        click: function () {
            confirm = $(this).is(":checked");
        }
    });
    $("#start-quote").on({
        click: function () {
            $('.exist-new').slideUp(700, function () {
                $(this).remove();
            });
            $(".package-details").slideDown(700, function () {
                $(".conditions").show();
                $(".btn-next-group").show()
            });
            pickupAsync.asyncAdd("option", "showPrice", false).asyncAdd("option", "showTotalPrice", false).asyncAdd("addRow");

            $('.aa-price-total,.total-quote,.aa-price-total-inc-vat').remove();
            doQuote();
        }
    });
    $("#login").on({
        click: function () {
            var _self = this;
            $(".login-alert").hide();

            $.ajax({
                    type: "POST",
                    url: "../includes/ajax/loginDetails.php",
                    data: {
                        email: $('#exist-email').val(),
                        ps: $('#exist-password').val()
                    }
                })
                .done(function (data) {
                    data = JSON.parse(data);
                    if (data.error) {
                        $(".login-alert").find('.error-reason').text(data.error).end().show();
                    } else {
                        $("#quoteEmail").val(data.user.email);
                        email = true
                        $.each(data.user, function (id, val) {
                            $('#' + id).val(val).trigger('change');
                        });
                        $.each(data.collection, function (id, val) {
                            $('#' + id).val(val).trigger('change');
                        });
                        $.each(data.delivery, function (id, val) {
                            $('#' + id).val(val).trigger('change');
                        });
                        $('.exist-new').slideUp(700, function () {
                            $(this).remove();
                        });
                        $(".package-details").slideDown(700, function () {
                            $(".conditions,.btn-next-group").show();
                            $(".total-quote").removeClass("hidden");
                        });
                        $('.my-details').remove();
                        pickupAsync.asyncAdd("addRow");
                        doQuote();
                    }
                })
                .fail(function () {
                    $(".login-alert").show();
                });

        }
    });
    $('.estimatevalue').numberOnly({regex: "[0-9\.]+"});
    $("input").on({
        focus: function () {
            $(this).closest('.form-group').removeClass('has-error');
        }

    });
    $("#email,#quoteEmail").on({
        keyup: function () {
            if (!isValidEmail($(this).val())) {
                $(this).closest('.form-group').addClass('has-error');
                email = false;
            } else {
                $(this).closest('.form-group').removeClass('has-error');
                email = true;
            }
        },
        change: function () {
            var _val = $(this).val();
            if (_val.length > 0) {
                if (!isValidEmail($(this).val())) {
                    $(this).closest('.form-group').addClass('has-error');
                    email = false;
                } else {
                    $(this).closest('.form-group').removeClass('has-error');
                    email = true;
                }
            }
        }
    });
    $('#dob').datepicker($.extend(true, {}, {altField: "#dobiso"}, $datePickerOptions));
    $('#collection-date').datepicker($.extend(true, {}, $datePickerOptions, {
        yearRange: "-0:+10",
        defaultDate: "+1d",
        maxDate: "+10y",
        minDate: "+1d",
        altField: "#collectioniso"
    }));
    if ($("#exist-email").length > 0) {
        $(".tab-container").tabForm({
                limit: true,
                hasNavButtons: true,
                limits: {lower: 0, upper: 1},
                checkDirection: {up: true, down: false},
                runCheckBeforeTabChange: function () {
                    var _tab = $(".selected").data('tab');
                    var storageArray = {};
                    $.each($(".active #pickup select"), function (k, _dropdown) {
                        itemValid = ($(_dropdown).val() != 0);
                        if (!itemValid) {
                            return false;
                        }
                    });
                    $.each($(".active .estimatevalue"), function (k, _val) {
                        estimate = ($(_val).val() != '');
                        if (!estimate) {
                            return false;
                        }
                    });
                    $(".active")
                        .find("input,select").each(function (k, $elem) {
                        var _val;
                        switch ($($elem).get(0).nodeName.toLocaleLowerCase()) {
                            case "input":
                                _val = $($elem).val();
                                break;
                            case "select":
                                if ($($elem).hasClass(".country-input")) {
                                    _val = $(":selected", $elem).val();
                                } else {
                                    _val = $(":selected", $elem).text();
                                }

                                break;
                        }
                        var _id = $($elem).attr('id');
                        if (_id != undefined && _id.indexOf("[") == -1) {
                            storageArray[_id] = _val;
                        }
                    }).end()
                        .find('.aa-item-row').each(function (k, elem) {
                        if (!storageArray['package']) {
                            storageArray['package'] = {};
                        }
                        storageArray.package[k] = {
                            category: $(elem).find('.itemcatPickup :selected').text(),
                            categoryId: $(elem).find('.itemcatPickup :selected').val(),
                            item: $(elem).find('.items :selected').text(),
                            itemId: $(elem).find('.items :selected').val(),
                            fragile: ($('.fragile input', elem).is(":checked")),
                            estimate: $(elem).find(".estimatevalue").val(),
                            description: $(elem).find(".otherDescHidden").val()
                        };
                    });
                    storageArray['totalValue'] = $('.aa-price-total span').text();
                    var _extraChecks = [
                        {"val": restricted, error: "You Must read and agree to the <a href='/terms' target='_blank'>Prohibited &amp; Restricted items list</a>.", "element": $('#conditions')},
                        {"val": itemValid, error: "Please select a category, unable to quote an order with no items."},
                        {"val": estimate, error: "The estimated value is a mandatory field, this is for insurance reasons.", "element": $('.estimatevalue')}
                    ];

                    if (_tab == 2) {
                        _extraChecks.push({"val": confirm, error: "Please confirm that the above details are correct.", "element": $('#confirm')});
                    }
                    var _checkform = checkForm($("#quote-form").find(".active"), _extraChecks);
                    if (_checkform === true) {
                        store("session", "set", "store" + _tab, JSON.stringify(storageArray));
                    }
                    return _checkform;
                }
            })
            .on({
                'tab-change': function (e, newTab) {
                    var items = {}, details = {};
                    $("[role='tab']", this).removeClass("previous-tab");
                    $("[role='tab']", this).each(function (k, tabHeader) {
                        if (k < newTab) {
                            $(tabHeader).addClass('previous-tab')
                        }
                    });
                    if (store("session", "get", "store0") != undefined) {
                        _items = JSON.parse(store("session", "get", "store0"));
                    }
                    if (store("session", "get", "store1") != undefined) {
                        _details = JSON.parse(store("session", "get", "store1"));
                    }
                    var _progress = (newTab + 1);
                    $(".progress-bar").attr('aria-valuenow', _progress).css({width: (_progress * 25) + "%"}).text("Step: " + _progress + " of 4");
                    if (newTab == 2) {
                        $.each(_details, function (clazz, value) {
                            $("." + clazz, ".confirm-details").text(value);
                        });
                        var _itemsHtml = '';
                        $.each(_items.package, function (k, _item) {
                            _itemsHtml += "<li class='item-row'><span class='item-category'>" + (_item.category) + "</span>" +
                                ((_item.item != '') ? "<span class='item-item'>" + _item.item + "</span>" : '') +
                                ((_item.description != '') ? "<span class='item-item'>" + nl2br(_item.description) + "</span>" : '') +
                                ((_item.fragile) ? "<div class='item-fragile'><img src='images/fragile.svg'></div>" : '');

                        });
                        $(".confirm-items ul").html(_itemsHtml);
                        $(".confirm-collection-date").text(_items['collection-date']);
                    }
                    if (newTab == 3) {
                        if ($("#quoteEmail").val() != '') {
                            $('#email').val($("#quoteEmail").val());
                        }
                        if (_details['collection-telephone'] != '') {
                            $('#user-phone').val(_details['collection-telephone'])
                        } else {
                            $('#user-phone').val(_details['collection-mobile'])
                        }

                    }

                },
                'tab-error': function (e, _error) {
                    var _errormsg = '<ul>';
                    for (e in _error) {
                        _errormsg += '<li>' + _error[e] + '</li>';
                    }
                    _errormsg += '</ul>';
                    bootbox.dialog({
                        title: "<span class='fa fa-exclamation-triangle gi-pad-right'></span> Error",
                        backdrop: true,
                        animate: false,
                        onEscape: true,
                        message: _errormsg,
                        className: 'error-modal',
                        buttons: {
                            "ok": {
                                label: "OK",
                                className: "btn-success"
                            }
                        }
                    });
                }
            })
            .on({
                click: function () {
                    window.location.href = "/quote/" + $(this).data('quoteId');
                }
            }, '.tab-btn-last').find(".btn-next-group").hide();
    } else {
        $(".progress-bar").attr('aria-valuenow', 100).css({width: "100%"}).text("Step: 4 of 4");
    }
    $(".tempValues").remove();
    $(".editable").editable();
    $(".btn-place-order").on({
        click: function () {
            $(this).prop('disabled', true).text('Please Wait....');
            var _self = this,
                _extraChecks = [];
            if ($("#dobConfirm").length > 0) {
                _extraChecks = [
                    {"val": email, error: "Email Address is not valid."},
                    {"val": $("#dobConfirm").is(":checked"), error: "Please Confirm you are over the Age of 18."}
                ];
            }
            var _checkform = checkForm($("#quote-form"), _extraChecks);
            if (_checkform != true) {
                var _errormsg = '<ul>';
                for (e in _checkform) {
                    _errormsg += '<li>' + _checkform[e] + '</li>';
                }
                _errormsg += '</ul>';
                bootbox.dialog({
                    title: "<span class='fa fa-exclamation-triangle gi-pad-right'></span> Error",
                    backdrop: true,
                    animate: false,
                    onEscape: true,
                    message: _errormsg,
                    className: 'error-modal',
                    buttons: {
                        "ok": {
                            label: "OK",
                            className: "btn-success"
                        }
                    }
                });
                $(_self).prop("disabled", false).text("Place Order");
            } else {
                $("#quote-form").submit();
            }
        }
    })
}).on({
    change: function () {
        var _val;
        if ($(this).is(':checked')) {
            $(this).parent('label').addClass('checked');
            _val = 'on';
        } else {
            $(this).parent('label').removeClass('checked');
            _val = 'off';
        }

        $(this).next("[type='hidden']").val(_val);

    }
}, "[type='checkbox']");