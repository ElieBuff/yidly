that =
    replaceInDict: (dict, key, val) ->
        b = {}
        b[key] = val
        $.extend({},dict, b)
    formatTimeStampInDict: (dict, key, transformFuncIn) ->
        transformFunc = transformFuncIn or (x)->x
        that.replaceInDict(
            dict,
            key,
            transformFunc(moment(dict[key]).add('seconds', 30).calendar())
            )

window.UTILS = that

