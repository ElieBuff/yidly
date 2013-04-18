var UTILS = 
{ 
    renderDust: function (template_name, data) {
        var result;
        dust.render(template_name, data, function(err, out) {
            result = out;
        });
        return result;
    },
    formatTimeStampInDict: function(dict, key) {
        var b = {};
        b[key] = moment(dict[key]).calendar();
        return $.extend({},dict, b);
    }
};

