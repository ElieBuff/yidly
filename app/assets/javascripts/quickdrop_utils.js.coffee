window.initQuickDrop = (refreshDataCallBack)->
    callbacks = ->
        directAction = (obj, server_function) ->
            $.get Mustache.render("/records/{{ id }}/{{ action }}.json"
                id: getRecordId(obj)
                action: server_function
                ), (data) ->
                    refreshDataCallBack()
        waitForSec = (obj) ->
            $.get Mustache.render("/records/{{ id }}/wait_for_sec.json?delay=86400"
                id: getRecordId(obj)
                ), (data) ->
                    refreshDataCallBack()
        rescheduleAction  = (obj) ->
            showRescheduleBox = ->
                setBoxDesign = () ->
                    top = obj.data('height')
                    width = obj.data('width') * 2
                    left = obj.data('left') - 100
                    $('.reschedule-box').css('top', top).css('width', width).css('left', left)
                    $('.reschedule-option').css('width', width/3)
                    obj.removeData('obj')
                setBoxDesign()
                $('.reschedule-box').slideDown(500)
            hideRescheduleBox = ->
                $('.reschedule-box').slideUp(500, () -> $('body').quickdrop('hideQuickBar'))
            eventHandler = ->
                $(document).on "click", "body", () -> hideRescheduleBox()

                $(document).on "click", ".reschedule-option", () ->
                    jQueryThis = $(this)
                    url = (id) ->
                        futureStr = -> jQueryThis.attr('data-reschedule')
                        fromNowInSec = (futureStr) ->
                            the_moment = (futureStr) ->
                                switch(futureStr)
                                    when 'same_day' then moment().add('hours',1)
                                    when 'this_evening' then moment().endOf('day').subtract('hours', 6)
                                    when 'tonight' then moment().endOf('day').subtract('hours', 3)
                                    when 'tomorrow' then moment().add('days',1).startOf('day').add('hours', 7)
                                    when 'in_two_days' then moment().add('days',2).startOf('day').add('hours', 7)
                                    when 'in_a_week' then moment().add('days',7).startOf('day').add('hours', 7)
                                
                            (the_moment(futureStr) - moment())/1000

                        Mustache.render "/records/{{ id }}/reschedule_in_sec.json?delay={{ delay }}",
                            id: id
                            delay: fromNowInSec(futureStr())

                    $.get url(getRecordId(obj)), (data) ->
                        refreshDataCallBack()
                    

            showRescheduleBox()
            eventHandler()

        getRecordId = (obj) ->
            id = obj.attr('id')
            recordId = id.replace('task', '')

        actions =   [
                        icon : "/assets/actions/done.gif"
                        closeOnDrop : true
                        callback : (obj) ->
                                        directAction obj, 'move_to_next_stage'
                    ,
                        icon : "/assets/actions/clock.png"
                        closeOnDrop : false           
                        callback : (obj) ->
                                        rescheduleAction obj
                    ,
                        icon : "/assets/actions/hourglass.jpg"
                        closeOnDrop : true
                        callback : (obj) ->
                                        waitForSec obj
                    ,
                        icon : "/assets/actions/stop.png"
                        closeOnDrop : true
                        callback : (obj) ->
                                        directAction obj, 'reject'
                    ]
    getDragHelper = (obj) ->
        helper = obj.clone()
        helper.width(obj.width())
        helper.height(obj.height())
        
        return helper
        
    
    initRescheduleBox = ->
        createRescheduleBox = ->
            reschedule = $('<div class="reschedule-box"></div>').load('/dialogs.html');
            $('.quickdrop-records').append(reschedule);
        createRescheduleBox()
    initRescheduleBox()

    window.reloadQuickDrop = ->
        $('body').quickdrop('reloadDraggable', getDragHelper);

     window.hideQuickDrop = ->
        $('body').quickdrop('hideQuickBar')
   
    $('body').quickdrop({
        'dragHelperCallback' : getDragHelper, 
        'actions' : callbacks()
    });

    

    
