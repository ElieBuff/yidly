var UTILS = 
{ 
    renderDust: function (template_name, data) {
        var result;
        JST['templates/' + template_name]( data, function(err, out) {
            result = out;
        });
        return result;
    },
    formatTimeStampInDict: function(dict, key) {
        var b = {};
        b[key] = moment(dict[key]).add('seconds', 30).calendar();
        return $.extend({},dict, b);
    }
};

