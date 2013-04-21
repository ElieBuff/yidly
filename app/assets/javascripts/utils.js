var UTILS = 
{ 
    formatTimeStampInDict: function(dict, key) {
        var b = {};
        b[key] = moment(dict[key]).add('seconds', 30).calendar();
        return $.extend({},dict, b);
    }
};

