var Locale = {
    module: function(code, obj){
        if (this[code] == undefined) {
            this[code] = {};
        }
        $.extend(this[code], obj);
    }
};
/*
 * create object Locale:
 * Locale
 * {
 * core {'Add': 'Add', 'Edit': 'Edit'}
 * }
 */
/**
 * First element of arguments is always points at module to use
 * 
 * @param {String} module_code
 */
String.prototype.translator = function(module_code){
    key = this;
    var module = 'core';
    
    if (module_code != undefined) {
        module = module_code;
    }
	console.debug(Locale);
    if (!Locale[module]) {
        localized = '__module not found__';//key;
    } else {		
        localized = Locale[module][key];
    }
    
    if (localized == undefined) {
        $.each(Locale, function(k, v){
            if (localized == undefined) {
                localized = v[key];
            }
        });
        if (localized == undefined) {
            localized = '__translation not found__';//key;
        }
    }

    if (arguments.length > 1) {
        for (var i = 1, limit = arguments.length - 1; i <= limit; i++) {
            /*if (typeof arguments[i] != 'string') {
                continue;
            }*/
            localized = localized.replace(new RegExp("{.+}"), arguments[i]);
        }
    }
    
    return localized;
}