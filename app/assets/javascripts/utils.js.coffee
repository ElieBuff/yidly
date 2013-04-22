that = 
    replaceInDict: (dict, key, val) ->
        b = {}
        b[key] = val
        $.extend({},dict, b)
    formatTimeStampInDict: (dict, key) ->
        that.replaceInDict(dict, key, moment(dict[key]).add('seconds', 30).calendar())

window.UTILS = that

