/*getdefault*/
(function ($) {
    $.fn.getDefault = function () {
        var sel = "";
        $("option", this).each(function () {
            if (this.defaultSelected) {
                return sel = this.value
            }
        });
        return $(this).prop("defaultValue") || sel;
    };
}(jQuery));
/*pwcheck*/
(function ($) {
    /*
     *  Adapted from strength.js by @aaronlumsden
     *   https://github.com/aarondo/Strength.js
     */
    var progressbar, total;
    var pw_methods = {
        init: function (_progressbar) {
            progressbar = _progressbar;
            return this
        },
        check: function (thisval) {
            var characters = 0;
            var capitalletters = 0;
            var loweletters = 0;
            var number = 0;
            var special = 0;

            var upperCase = new RegExp('[A-Z]');
            var lowerCase = new RegExp('[a-z]');
            var numbers = new RegExp('[0-9]');
            var specialchars = new RegExp('([!,%,&,@,#,$,^,*,?,_,~])');

            if (thisval.length >= 8) {
                characters = 1;
            } else {
                characters = -1;
            }
            if (thisval.match(upperCase)) {
                capitalletters = 1
            } else {
                capitalletters = 0;
            }
            if (thisval.match(lowerCase)) {
                loweletters = 1
            } else {
                loweletters = 0;
            }
            if (thisval.match(numbers)) {
                number = 1
            } else {
                number = 0;
            }
            if (thisval.match(specialchars)) {
                special = 1
            } else {
                special = 0;
            }

            total = characters + capitalletters + loweletters + number + special;

            if (!thisval.length || thisval.length < 1) {
                total = -1;
            }
            if (total < 1) {
                progressbar
                    .css("width", "100%")
                    .attr("aria-valuenow", 100)
                    .removeClass()
                    .addClass('progress-bar progress-bar-danger')
                    .html('Password too short');
            }
            else if (total == 2) {
                progressbar
                    .css("width", "25%")
                    .attr("aria-valuenow", 25)
                    .removeClass()
                    .addClass('progress-bar progress-bar-danger')
                    .html('Very Weak');
            } else if (total == 3) {
                progressbar
                    .css("width", "50%")
                    .attr("aria-valuenow", 50)
                    .removeClass()
                    .addClass('progress-bar progress-bar-warning')
                    .html('Weak');
            } else if (total == 4) {
                progressbar
                    .css("width", "75%")
                    .attr("aria-valuenow", 75)
                    .removeClass()
                    .addClass('progress-bar progress-bar-warning')
                    .html('Medium');

            } else {
                progressbar
                    .removeClass()
                    .attr("aria-valuenow", 100)
                    .css("width", "100%")
                    .addClass('progress-bar progress-bar-success')
                    .html('Strong');
            }
        },
        isValid: function () {
            return (total > 0)
        }
    };
    $.fn.pwCheck = function (opts) {
        if (pw_methods[opts]) {
            return pw_methods[opts].apply(this, Array.prototype.slice.call(arguments, 1));
        } else if (typeof opts === 'object' || !opts) {
            return pw_methods.init.apply(this, arguments);
        } else {
            $.error('Method:' + opts + 'does not exist.')
        }

    };
}(jQuery));
/*asyncadd*/
(function ($) {
    var asyncAdd = function (element, options) {
        this.element = element;
        this.$element = $(element);
        this.options = options;
        this._rows = [];
    };
    asyncAdd.prototype = {
        defaults: {
            showPrice: true,
            showTotalPrice: true,
            readOnly: false,
            rowClass: '.aa-item-row',
            wrapperClass: '.aa-wrapper',
            columnElements: [],
            columnWidths: [],
            addMultiRow: false,
            handlers: function () {
            }
        },

        init: function () {
            this.config = $.extend(true, {}, this.defaults, this.options);
            if (this.config.columnElements.length > 12) {
                $.error("Column Count Greater than 12")
            } else {
                this._generateWrapper();
                if (!this.config.readOnly) {
                    this._addAddRowButton();
                }
                this.$element.data("asyncAdd", this);
                if (typeof this.config.handlers === "function") {
                    this.config.handlers(this);
                } else {
                    $.error("Handler Callback is not a function.")
                }
            }
            return this;
        },
        _generateWrapper: function () {
            this.$wrapperhtml = $('<div class="' + this.config.wrapperClass.substr(1) + '"></div>');
            this.$wrapperhtml.appendTo(this.$element)
        },
        _toBoolean: function (value) {
            switch (String(value).toLowerCase()) {
                case "true":
                case "on":
                case "yes":
                case "y":
                case "1":
                    return true;
                default:
                    return false;
            }
        },
        _addAddRowButton: function () {
            var $row = '';
            if (this.config.showTotalPrice) {
                $row += '<div class="hidden aa-price-subtotal">' +
                    '<strong>Subtotal: </strong>&pound;<span>0.00</span>' +
                    '</div>';
                if (this.config.hasVAT) {
                    $row += '<div class="hidden aa-price-vat">' +
                        '<strong>VAT: </strong>&pound;<span>0.00</span>' +
                        '</div>';
                }
            }
            $row += '<div class="col-xs-12">' +
                '<div class="col-xs-6">' +
                '<button class="btn btn-success pull-left aa-add-row" type="button">' +
                '<span class="glyphicon glyphicon-plus" style="padding-right: 10px"></span> Add Row' +
                '</button>';
            if (this.config.addMultiRow) {
                $row += '<button class="btn btn-success pull-left aa-add-multi-row" type="button">' +
                    '<span class="glyphicon glyphicon-plus" style="padding-right: 10px"></span> Add Multiple Rows' +
                    '</button>';
            }
            $row += '</div>';
            if (this.config.showTotalPrice) {
                if (this.config.hasVAT) {
                    $row += '<div class="col-xs-6 aa-price-total-inc-vat">' +
                        '<strong>Total </strong><i class="note-disclaimer">(inc. vat)<i>: &pound;<span>0.00</span>' +
                        '</div>';
                } else {
                    $row += '<div class="col-xs-6 aa-price-total">' +
                        '<strong>Total </strong>: &pound;<span>0.00</span>' +
                        '</div>';
                }
            }
            $row += '</div>';
            this.$element.append($row);
        },
        _html2rowhtml: function (html) {
            return html.replace(/((?:id|name|for)=['"])(.+?)(['"])/ig, "$1$2[]$3");
        },
        removeRow: function ($row) {
            delete this._rows[$row.data('row')];
            $row.closest(this.config.rowClass).remove();
            this.$element.trigger('aa-row-removed', $row.data('row'));
        },
        addRow: function (quantity) {
            // If quantity is specified then add that many columns, else only add the one
            var _self = this;
            quantity = quantity || 1;
            for (var q = 0; q < quantity; q++) {
                var cols = 12 / ((this.config.columnElements.length != 0) ? this.config.columnElements.length : 1);

                var $row = '<div class="' + this.config.rowClass.substr(1) + ' form-group col-xs-12">';
                if (!this.config.readOnly) {
                    $row += '<div class="aa-remove-row"><span class="glyphicon glyphicon-minus-sign text-danger"></span></div>';
                }
                if (this.config.showPrice) {
                    $row += '<div class="aa-price-label">&pound;<span>0.00</span></div>';
                }
                $row += '<div class="aa-column-wrapper">';
                $.each(this.config.columnElements, function (k, _element) {
                    if (_self.config.columnWidths.length == 0) {
                        $row += "<div class='col-xs-12 col-md-" + Math.round(cols) + "' data-column='" + k + "'>" + _element + "</div>"
                    } else {
                        $row += "<div class='col-xs-12 col-md-" + _self.config.columnWidths[k] + "' data-column='" + k + "'>" + _element + "</div>"
                    }

                });
                $row += '</div>' +
                    '</div>';
                $row = $(this._html2rowhtml($row));
                this.$wrapperhtml.append($row);
                if (this.config.readOnly) {
                    $("input,select", $row).each(function () {
                        $(this).prop({disabled: true});
                    })
                }
                $('.aa-remove-row', $row).data('row', this._rows.length);
                this.$element.trigger('aa-row-added', this._rows.length);
                this._rows.push($row);
            }
        },
        loadData: function (json) {
            var _self = this;
            if (!(typeof json == "object")) {
                if (!(json = JSON.parse(json))) {
                    $.error("Invalid JSON String passed");
                }
            }
            $.each(json, function (row, rowData) {
                var column = 0;
                $.each(rowData, function (col, value) {
                    var _element = $("[data-column='" + column + "'] select, [data-column='" + column + "'] input", _self._rows[row]);
                    switch (_element.prop("type")) {
                        case "checkbox":
                            _element.prop("checked", _self._toBoolean(value)).trigger('change');
                            break;
                        case "select-one":
                        case "text":
                        default:
                            _element.val(value).trigger('change');
                            break;
                    }
                    column++;
                });
                _self.$element.trigger('aa-row-data-loaded', row);
            });
        },
        option: function (name, value) {
            this.config[name] = value;
        }
    };
    asyncAdd.defaults = asyncAdd.prototype.defaults;

    $.fn.asyncAdd = function (options) {
        var $args = Array.prototype.slice.call(arguments, 1);
        return this.each(function () {
            var plugin = (!$(this).data("asyncAdd")) ? new asyncAdd(this, options) : $(this).data("asyncAdd");
            if (typeof options === 'object' || !options) {
                plugin.init();
            } else if (typeof options === 'string' && typeof plugin[options] === 'function' && options.indexOf('_') === -1) {
                plugin[options].apply(plugin, $args);
            } else {
                $.error('Method ' + options + ' does not exist');
            }
        });
    }
}(jQuery));
/*convert*/
(function ($) {
    $.fn.convert = function ($obj) {
        var CMIN = 2.54; // CM in an inch.
        var value = (this.val()).replace(/\s+/g, '');
        if (value.match(/(in|"|inches)/)) {
            var res;
            if (res = value.match(/^(?:([0-9]+)(?:in|inches|"))$/)) {
                var cm = Math.ceil(parseInt(res[1]) * CMIN);
                if ($obj && $obj.max) {
                    if (parseInt(cm) > parseInt($obj.max)) {
                        this.val(this.getDefault());
                        this.parent()
                            .removeClass("has-success has-error")
                            .addClass("has-warning")
                            .find('.glyphicon')
                            .removeClass("glyphicon-ok glyphicon-remove")
                            .addClass("glyphicon-warning-sign")
                    } else {
                        this
                            .val(cm)
                        //.trigger('change');

                        this.parent()
                            .removeClass("has-error has-warning")
                            .addClass("has-success")
                            .find('.glyphicon')
                            .removeClass("glyphicon-remove glyphicon-warning-sign")
                            .addClass("glyphicon-ok");
                    }
                }
                else {
                    this
                        .val(cm)
                    //.trigger('change');

                    this.parent()
                        .removeClass("has-error has-warning")
                        .addClass("has-success")
                        .find('.glyphicon')
                        .removeClass("glyphicon-remove glyphicon-warning-sign")
                        .addClass("glyphicon-ok");
                }

            } else {
                this.val(this.getDefault());
                this.parent()
                    .removeClass("has-success has-warning")
                    .addClass("has-error")
                    .find('.glyphicon')
                    .removeClass("glyphicon-ok glyphicon-warning-sign")
                    .addClass("glyphicon-remove");
            }
        } else if (value.match(/cm/)) {
            value = (this.val()).replace(/cm/g, '');
            if ($obj && $obj.max) {
                if (parseInt(value) > parseInt($obj.max)) {
                    this.val(this.getDefault());
                    this.parent()
                        .removeClass("has-success has-error")
                        .addClass("has-warning")
                        .find('.glyphicon')
                        .removeClass("glyphicon-ok glyphicon-remove")
                        .addClass("glyphicon-warning-sign")
                } else {
                    this.trigger("change");
                    this.parent()
                        .removeClass("has-error has-warning")
                        .addClass("has-success")
                        .find('.glyphicon')
                        .removeClass("glyphicon-remove glyphicon-warning-sign")
                        .addClass("glyphicon-ok");
                }
            } else {
                this
                    .val()
                    .trigger('change');
                this.parent()
                    .removeClass("has-error has-warning")
                    .addClass("has-success")
                    .find('.glyphicon')
                    .removeClass("glyphicon-remove glyphicon-warning-sign")
                    .addClass("glyphicon-ok");
            }

        } else if (value.match(/^[0-9]{2,}|[1-9]$/)) {
            if ($obj && $obj.max) {
                if (parseInt(value) > parseInt($obj.max)) {
                    this.val(this.getDefault());
                    this.parent()
                        .removeClass("has-success has-error")
                        .addClass("has-warning")
                        .find('.glyphicon')
                        .removeClass("glyphicon-ok glyphicon-remove")
                        .addClass("glyphicon-warning-sign")
                } else {
                    //this.trigger("change");
                    this.parent()
                        .removeClass("has-error has-warning")
                        .addClass("has-success")
                        .find('.glyphicon')
                        .removeClass("glyphicon-remove glyphicon-warning-sign")
                        .addClass("glyphicon-ok");
                }
            } else {
                //this.trigger("change");
                this.parent()
                    .removeClass("has-error has-warning")
                    .addClass("has-success")
                    .find('.glyphicon')
                    .removeClass("glyphicon-remove glyphicon-warning-sign")
                    .addClass("glyphicon-ok");
            }
        } else {
            this.val(this.getDefault());
            this.parent()
                .removeClass("has-success has-warning")
                .addClass("has-error")
                .find('.glyphicon')
                .removeClass("glyphicon-ok glyphicon-warning-sign")
                .addClass("glyphicon-remove");

        }
    }


}(jQuery));

/*Dirtyform*/
(function ($) {
    var typingTimer;
    var trackDirty = function (element, options) {
        this.element = element;
        this.$element = $(element);
        this.options = options;
        this.defaultValues = {};
    };
    trackDirty.prototype = {
        defaults: {
            markDirty: true,
            'data-name': "isDirty",
            resetElement: ".dirtyReset",
        },
        init: function () {
            this.config = $.extend(true, {}, this.defaults, this.options);
            this._addHandlers();
            this.$element.data("trackDirty", this);
            var _this = this;
            $('input:not(.usedFlag),select,textarea', this.$element).each(function () {
                _this.defaultValues[_this._getSelector($(this))] = $(this).val();
            });
            $(this.config.resetElement, this.$element).hide();

            return this;
        },
        _getSelector: function ($elem) {
            var selector = ($elem.context.id) ? '#' : ($elem.context.className) ? '.' : 0;
            var el = $elem.context.localName + selector + ($elem.context.id || $elem.context.className || '');
            return el;
        },
        _timeout: function (callback, pauseTime) {
            clearTimeout(typingTimer);
            typingTimer = setTimeout(function () {
                callback.apply(this, arguments);
            }, pauseTime)
        },
        _addHandlers: function () {
            $('input,select,textarea').each(function (k, v) {
                $(v).data('original', $(v).val());
            });
            var _this = this;
            var $element = this.$element;
            $element
                .on({
                    change: function () {
                        $element.data(_this.config['data-name'], 1);
                        if (_this.config.markDirty) {
                            if ($(this).val() != $(this).data('original')) {
                                $(this).addClass('dirty-element');
                                $(this).data(_this.config['data-name'], 1);
                            } else {
                                $(this).removeClass('dirty-element');
                                $(this).removeData(_this.config['data-name']);
                            }
                        }
                        $(_this.config.resetElement, $element).show();
                    }
                }, 'input,select,textarea');
            var resetElement = this.config.resetElement;
            if (!(resetElement instanceof jQuery)) {
                resetElement = $(resetElement);
            }
            resetElement.on({
                click: function (e) {
                    e.stopPropagation();
                    e.preventDefault();
                    _this.resetForm($(this).closest($element));
                }
            })
        },
        resetForm: function ($element) {
            var _this = this;
            $('input:not(.usedFlag),select,textarea', $element).each(function () {
                var item = _this._getSelector($(this));
                $(this).val(_this.defaultValues[item]);
                $(this).trigger('change');
                $(this).data(_this.config['data-name']);
                $(_this.config.resetElement, $element).hide();
                if (_this.config.markDirty) {
                    this.removeClass('dirty-element');
                }
            });
            this.$element.removeData(this.config['data-name']);
            $element.trigger('form.reset');
        }
    };
    trackDirty.defaults = trackDirty.prototype.defaults;

    $.fn.trackDirty = function (options) {
        var $args = Array.prototype.slice.call(arguments, 1);
        return this.each(function () {
            var plugin = (!$(this).data("trackDirty")) ? new trackDirty(this, options) : $(this).data("trackDirty");
            if (typeof options === 'object' || !options) {
                plugin.init();
            } else if (typeof options === 'string' && typeof plugin[options] === 'function' && options.indexOf('_') === -1) {
                plugin[options].apply(plugin, $args);
            } else {
                $.error('Method ' + options + ' does not exist');
            }
        })
    }

}(jQuery));
/*numberOnly*/
(function ($) {
    var numberOnly = function (element, options) {
        this.element = element;
        this.$element = $(element);
        this.options = options;
        this.group = $(element).closest(".form-element");
    };
    numberOnly.prototype = {
        defaults: {
            regex: "[0-9]+",
            maxChar: 20,
            stripLeadingZero: false,
            useMaxChar: true
        },
        init: function () {
            this.config = $.extend(true, {}, this.defaults, this.options);
            this._addToolTip();
            this._addHandlers();
            this.$element.data("numberOnly", this);
            return this;
        },
        _addToolTip: function () {
            var _this = this;
            if (this.config.useMaxChar) {
                this.$element.tooltip({
                        placement: "bottom",
                        title: "Maximum length reached: " + _this.config.maxChar + " characters.",
                        trigger: "manual",
                        container: 'body'
                    }
                )
            }
        },
        _addHandlers: function () {
            var _this = this;
            this.$element
                .on({
                    keypress: function (e) {
                        var char = String.fromCharCode(e.which || e.keyCode);

                        if (_this.config.useMaxChar) {
                            if ((_this.$element.val() + char).length > _this.config.maxChar) {
                                _this.$element.tooltip('show');
                            } else {
                                _this.$element.tooltip('hide');
                            }
                        }

                        if (!char.match(_this.config.regex) || (_this.$element.val().length >= _this.config.maxChar && _this.config.useMaxChar)) {
                            e.preventDefault();
                        }
                    },
                    blur: function () {
                        if (_this.config.stripLeadingZero) {
                            if (slz = _this.$element.val().match("^0(.+)")) {
                                _this.$element.val(slz[1]);
                            }
                        }
                        _this.$element.tooltip('hide');
                    }
                });
        }
    };
    numberOnly.defaults = numberOnly.prototype.defaults;

    $.fn.numberOnly = function (options) {
        var $args = Array.prototype.slice.call(arguments, 1);
        return this.each(function () {
            var plugin = (!$(this).data("numberOnly")) ? new numberOnly(this, options) : $(this).data("numberOnly");
            if (typeof options === 'object' || !options) {
                plugin.init();
            } else if (typeof options === 'string' && typeof numberOnly[options] === 'function' && options.indexOf('_') === -1) {
                plugin[options].apply(plugin, $args);
            } else {
                $.error('Method ' + options + ' does not exist');
            }
        })
    }

}(jQuery));
/* WordCount*/
(function ($) {
    var wordCount = function (element, options) {
        this.element = element;
        this.$element = $(element);
        this.options = options;
    };
    wordCount.prototype = {
        defaults: {
            maxLength: 255
        },
        init: function () {
            this.config = $.extend(true, {}, this.defaults, this.options);
            this._addLengthLeft();
            this._addHandlers();
            this.$element.data("wordCount", this);
            return this;
        },
        _addLengthLeft: function () {
            this.$element.prepend("<span class='wc-left' style='display:block;text-align:right'><span class='chars'>0</span>/" + this.config.maxLength + "</span>")
        },
        _addHandlers: function () {
            var _self = this;
            this.$element
                .on({
                    keypress: function (e) {
                        var length = ($(this).val()).length;
                        if (_self._isCharacter(e) && length >= _self.config.maxLength) {
                            e.preventDefault();
                        }
                    },
                    keyup: function () {
                        _self._renderLength(($(this).val()).length);
                    },
                    change: function () {
                    },
                    paste: function () {
                        var _this = this;
                        setTimeout(function () {
                            var length = ($(_this).val()).length;
                            if (length > _self.config.maxLength) {
                                var maxLengthString = ($(_this).val()).substr(0, _self.config.maxLength);
                                $(_this).val(maxLengthString);
                                _self._renderLength(_self.config.maxLength);
                            } else {
                                _self._renderLength(length);
                            }
                        }, 5);
                    }
                }, "input,textarea");
        },
        _isCharacter: function (evt) {
            if (typeof evt.which == "undefined") {
                // This is IE, which only fires keypress events for printable keys
                return true;
            } else if (typeof evt.which == "number" && evt.which > 0) {
                // In other browsers except old versions of WebKit, evt.which is
                // only greater than zero if the keypress is a printable key.
                // We need to filter out backspace and ctrl/alt/meta key combinations
                return !evt.ctrlKey && !evt.metaKey && !evt.altKey && evt.which != 8;
            }
            return false;
        },
        _renderLength: function (length) {
            if (((length / this.config.maxLength) * 100) > 90) {
                $('.wc-left .chars', this.$element).css({"color": "red"})
            } else {
                $('.wc-left .chars', this.$element).css({"color": ""})
            }
            $('.wc-left .chars', this.$element).text(length);
        }
    };
    wordCount.defaults = wordCount.prototype.defaults;

    $.fn.wordCount = function (options) {
        var $args = Array.prototype.slice.call(arguments, 1);
        return this.each(function () {
            var plugin = (!$(this).data("wordCount")) ? new wordCount(this, options) : $(this).data("wordCount");
            if (typeof options === 'object' || !options) {
                plugin.init();
            } else if (typeof options === 'string' && typeof wordCount[options] === 'function' && options.indexOf('_') === -1) {
                plugin[options].apply(plugin, $args);
            } else {
                $.error('Method ' + options + ' does not exist');
            }
        })
    }

}(jQuery));
/* Custom Tabform */
(function ($) {
    var activeTab = 0;
    var tabForm = function (element, options) {
        this.element = element;
        this.$element = $(element);
        this.options = options;
    };
    tabForm.prototype = {
        defaults: {
            _tabs: {headers: {}, tabs: {}},
            limit: false,
            hasNavButtons: false,
            navButtons: {
                next: '<div class="btn-group btn-next-group"><button type="button" class="btn btn-default tab-btn-next">Next Step</button></div>',
                previous: '<button type="button" class="btn btn-default tab-btn-prev">Previous Step</button>',
                last: '<button type="button" class="btn btn-default tab-btn-last">Accept Quote and Continue With Order</button>'
            },
            limits: {upper: 0, lower: 0},
            runCheckBeforeTabChange: false,
            checkDirection: {up: false, down: false}
        },
        init: function () {
            this.config = $.extend(true, {}, this.defaults, this.options);
            this._setupDom();
            this._addHandlers();
            this.$element.data("tabForm", this);
            return this;
        },
        _setupDom: function () {
            var _self = this;
            this.config._tabs.tabs = $('[role="tabpanel"]', this.$element);
            this.config._tabs.headers = $('[role="tab"]', this.$element);
            if (this.config._tabs.headers.length !== this.config._tabs.tabs.length) {
                $.error('Tab Container and header length mismatch');
            } else {
                this.config._tabs.tabs.each(function (k, _tab) {
                    $(_tab).data('tab', k);
                    $(_self.config._tabs.headers[k]).data('tab', k);
                    if (_self.config.hasNavButtons) {
                        var $html = '<div class="col-xs-12">';
                        if (k == 0) {
                            $html += _self.config.navButtons.next
                        }
                        else if (k == _self.config._tabs.tabs.length - 1) {
                            $html += _self.config.navButtons.previous + _self.config.navButtons.last;
                        } else {
                            $html += _self.config.navButtons.previous + _self.config.navButtons.next;
                        }
                        $html += '</div>';
                        $(_tab).append($html);
                    }
                });
                _self._setLimit();
            }
        },
        _setLimit: function () {
            var _self = this;
            if (this.config.limit) {
                this.config._tabs.headers.each(function (k, _header) {
                    if (!$(_header).hasClass("disabled")) {
                        $(_header).addClass("disabled");
                    }
                    if (_self.config.limits.upper != 0 && (k < activeTab + _self.config.limits.upper)) {
                        $(_header).removeClass("disabled");
                    }
                    if (_self.config.limits.lower != 0 && (k > activeTab - _self.config.limits.lower)) {
                        $(_header).removeClass("disabled");
                    }
                });
            }
        },
        _checkForError: function (direction) {
            if (this.config.checkDirection[direction]) {
                var _error = this.config.runCheckBeforeTabChange();
                if (typeof this.config.runCheckBeforeTabChange == "function") {
                    if (_error !== true) {
                        this.$element.trigger('tab-error', [_error]);
                        return false;
                    }
                }
            }
            return true;
        },
        _addHandlers: function () {
            var _self = this;
            this.$element
                .on({
                    click: function () {
                        if (_self._checkForError("up") !== true) {
                            return false
                        }
                        _self._changeTab(activeTab, ++activeTab);
                        _self._setLimit();
                    }
                }, ".tab-btn-next")
                .on({
                    click: function () {
                        if (_self._checkForError("down") !== true) {
                            return false
                        }
                        _self._changeTab(activeTab, --activeTab);
                        _self._setLimit();
                    }
                }, ".tab-btn-prev")
                .on({
                    click: function () {
                        if (_self._checkForError((activeTab < $(this).data("tab") ? "up" : "down")) !== true) {
                            return false
                        }
                        _self._changeTab(activeTab, $(this).data("tab"));
                        _self._setLimit();
                    }
                }, "[role='tab']:not('.disabled')");
        }
        ,
        _changeTab: function (fromNumber, toNumber) {
            var _self = this;
            $(_self.config._tabs.tabs[fromNumber]).removeClass("active");
            $(_self.config._tabs.headers[fromNumber]).removeClass("selected");
            $(_self.config._tabs.tabs[toNumber]).addClass("active");
            $(_self.config._tabs.headers[toNumber]).addClass("selected");
            activeTab = toNumber;
            _self.$element.trigger("tab-change", toNumber);
        }
    }
    ;
    tabForm.defaults = tabForm.prototype.defaults;

    $.fn.tabForm = function (options) {
        var $args = Array.prototype.slice.call(arguments, 1);
        return this.each(function () {
            var plugin = (!$(this).data("tabForm")) ? new tabForm(this, options) : $(this).data("tabForm");
            if (typeof options === 'object' || !options) {
                plugin.init();
            } else if (typeof options === 'string' && typeof tabForm[options] === 'function' && options.indexOf('_') === -1) {
                plugin[options].apply(plugin, $args);
            } else {
                $.error('Method ' + options + ' does not exist');
            }
        })
    }
}(jQuery));
/*Editable*/
(function ($) {
    var editable = function (element, options) {
        this.element = element;
        this.$element = $(element);
        this.options = options;
    };
    /**
     * @extends editable.
     * @type {{defaults: {onBlur: null, textfield: string, inputfield: string}, setBlurCallback: Function}}
     */
    editable.prototype = {
        defaults: {
            onBlur: null,
            textfield: ".editable-text",
            inputfield: ".editable-input",
            fieldType: "text"
        },
        init: function () {
            this.config = $.extend(true, {}, this.defaults, this.options);
            var $this = this;
            this._setupDOM();
            this.config.onBlur = function (value) {
                $this.$element.data('value', value);
            };

            this._addHandlers();

            this.$element.data("editable", this);
            return this;
        },
        _setupDOM: function () {
            var attr = this.$element.attr("tabindex");
            var tabindex;
            if (typeof attr !== typeof undefined && attr !== false) {
                this.$element.data("tabindex", attr);
            }
            this.$element.html("<span class='" + this.config.textfield.substr(1) + "'>" + this.$element.html() + "</span>")
        },
        setBlurCallback: function (_callback) {
            this.config.onBlur = _callback;
        },
        _addHandlers: function () {
            var $this = this;
            this.$element
                .on({
                    focus: function () {
                        $($this.config.textfield, this).trigger('click')
                    }
                })
                .on({
                    click: function () {
                        var _text = ($($this.config.textfield, $this.$element).text()).trim().replace(/\s+/, ' ');
                        $this.$element.data('original', _text);
                        $(this).hide();
                        var tabindex = ($this.$element.data('tabindex')) ? "tabindex='" + $this.$element.data('tabindex') + "'" : '';
                        var maxlength = ($this.$element.data('max-length')) ? "maxlength='" + $this.$element.data('max-length') + "'" : '';
                        var $input = $("<input type='" + $this.config.fieldType + "' " + maxlength + " class='form-control " + $this.config.inputfield.substr(1) + "' " + tabindex + " value='" + _text + "'>");
                        $this.$element.append($input);
                        $($input, $this.$element).trigger("focus");
                    },
                    focus: function () {
                        $(this).trigger('click')
                    }
                }, this.config.textfield)
                .on({
                    blur: function () {
                        var _value = $(this).val();
                        $(this).remove();
                        $($this.config.textfield, $this.$element).text(_value).show();
                        if (_value != $this.$element.data("original")) {
                            $this.config.onBlur(_value, $this.$element.data());
                        }
                    },
                    keydown: function (e) {
                        if (e.keyCode == 13) {
                            $(this).trigger('blur');
                        }
                    }
                }, this.config.inputfield);
        }

    };
    editable.defaults = editable.prototype.defaults;
    /**
     * The jQuery plugin namespace.
     * @external "jQuery.fn"
     * @see {@link http://learn.jquery.com/plugins/|jQuery Plugins}
     */

    /**
     * A jQuery plugin to add turn an element into an editable field on click.
     * @function external:"jQuery.fn".editable
     * @param options <p>Either an Object which contains options or a string containing a function name.</p>
     * <p>
     * <b>Defaults:</b>
     * <pre>{<br >
     *  onBlur: null, - What to do when leaving the selection<br >
     *  textfield: ".editable-text", - jQuery selector of the text field<br >
     *  inputfield: ".editable-input", - jQuery selector of the input field<br >
     *  fieldType: "text" - input type<br >
     *}<br ></pre></p>
     * @example
     * $(element).editable();
     */
    $.fn.editable = function (options) {
        var $args = Array.prototype.slice.call(arguments, 1);
        return this.each(function () {
            var plugin = (!$(this).data("editable")) ? new editable(this, options) : $(this).data("editable");
            if (typeof options === 'object' || !options) {
                plugin.init();
            } else if (typeof options === 'string' && typeof plugin[options] === 'function' && options.indexOf('_') === -1) {
                plugin[options].apply(plugin, $args);
            } else {
                $.error('Method ' + options + ' does not exist');
            }
        })
    }

}(jQuery));