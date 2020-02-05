function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(';');
    for (var i = 0; i < ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') c = c.substring(1);
        if (c.indexOf(name) == 0) return decodeURIComponent(c.substring(name.length, c.length));
    }
    return "";
}
function setCookie(cname, cval, expires, path) {
    var _cookie = "";
    _cookie += cname + "=" + cval + ";";
    if (expires) {
        var d = new Date(expires).getTime();
        if (d > 0) {
            _cookie += "; expires=" + d.toUTCString();
        }
    }
    if (path) {
        _cookie += "; path=" + path;
    }
    document.cookie = _cookie;
}
if (!Date.now) {
    Date.now = function () {
        return new Date().getTime();
    }
}
function isValidEmail(emailval) {
    var emailrxp = /^(?:[a-z0-9_-]+(?:\.)?)+[a-z0-9_-]@[a-z0-9\.-]{2,}\.[a-z0-9\.-]+$/i;
    return emailval.match(emailrxp);
}
function validKey(key) {
    return (
        (key >= 48 && key <= 90) ||
        (key >= 96 && key <= 111) ||
        (key >= 186 && key <= 122) ||
        (key == 8) || (key == 46)
    )
}
var typingTimer;
function typingTimeout(callback, pauseTime) {
    typingTimer = setTimeout(function () {
        callback.apply(this, arguments);
    }, pauseTime)
}
var _tTimer, _tTimerCallback;
function tTimeout(_callback, _pauseTime) {
    clearTimeout(_tTimer);
    _tTimerCallback = _callback;
    _tTimer = setTimeout(function () {
        _callback.apply(this, arguments);
        _tTimerCallback = null;
    }, _pauseTime);
}
function tclearTimeout() {
    if (_tTimerCallback) {
        clearTimeout(_tTimer);
        _tTimerCallback.apply(this, arguments);
        _tTimerCallback = null;
    }
}
function nl2br(str, is_xhtml) {
    var breakTag = (is_xhtml || typeof is_xhtml === 'undefined') ? '<br />' : '<br>';
    return (str + '').replace(/([^>\r\n]?)(\r\n|\n\r|\r|\n)/g, '$1' + breakTag + '$2');
}
function checkForm(form, checkextra) {
    if (!(form instanceof jQuery)) {
        form = $(form);
    }
    var errors = [];
    form.find('[required]:visible').each(function () {
        var $fg = $(this).closest(".form-group");
        $fg.removeClass("has-error");
        if (!$(this).val() || ($(this).val()).trim() == '') {
            $fg.addClass("has-error");
            var $label = $('label[for="' + $(this).attr('id') + '"]', $fg);
            var _label = $label.text();
            if (_label.length > 0) {
                _label = _label.replace("*", '');
                _label = _label.replace(":", '');
                errors.push(($label.data('label-prepend') || "") + _label + " is required" + ($label.data('label-append') || "") + ".");
            }
        }
    });
    for (var k in checkextra) {
        if (checkextra[k]['val'] == false) {
            errors.push(checkextra[k]['error']);
            if (checkextra[k]['element']) {
                if (!(checkextra[k]['element'] instanceof jQuery)) {
                    checkextra[k]['element'] = $(checkextra[k]['element']);
                }
                checkextra[k]['element'].closest(".form-group").addClass("has-error");
            }
        }
    }

    errors = errors.filter(Boolean);
    if (errors.length == 0) {
        return true;
    } else {
        return errors;
    }
}
function store(type, method, key, value) {
    method = method.toLowerCase();
    if (typeof(Storage) !== "undefined") {
        var _store = (type == "session") ? localStorage : sessionStorage;
        if (method == "get") {
            return _store[key];
        } else if (method == "set") {
            _store[key] = value;
        } else if (method == "clear") {
            _store.clear();
        }
    } else {
        if (method == "get") {
            return getCookie(key);
        } else if (method == "set") {
            setCookie(key, value);
        } else if (method == "clear") {
        }
    }
}
function isPasteEvent(event) {
    return (event.keyCode == 86 && event.ctrlKey)
}