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
<<<<<<< HEAD
        rescheduleAction  = (obj) ->
            showRescheduleBox = ->
                setBoxDesign = () ->
                    top = obj.data('height');
                    width = obj.data('width');
                    left = obj.data('left');
                    $('.reschedule-box').css('top', top).css('width', width).css('left', left);
                    obj.removeData('obj')
                setBoxDesign()
                $('.reschedule-box').slideDown(500);
            hideRescheduleBox = ->
                $('.reschedule-box').slideUp(500, () -> $('body').quickdrop('hideQuickBar'));
            eventHandler = ->
                $(document).on "click", "body", () -> hideRescheduleBox()
=======
        createRescheduleAction = ->
            $("#dialog").dialog
                show:
                    effect: "fade"
                    duration: 800
                hide:
                    effect: "fade"
                    duration: 800
                position:
                    my: "top"
                    at: "top"
                    of: ".quickdrop-records"
                autoOpen: false
                resizable: false
                dialogClass:'reschedule-dialog'
                modal: true
            $('#dialog').load('/dialogs.html')
                    
            $(document).on "click", "body", () -> $('#dialog').dialog('close')
                        
            $(document).on "click", ".reschedule-option", () ->
                dataElement = -> $('#dialog')
                recordId = -> 
                    obj = dataElement().data('obj')
                    obj.attr('id').replace('task', '');
                    
                clear = -> dataElement().removeData('obj')
>>>>>>> upstream/master

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
                                        directAction getRecordId(obj), 'move_to_next_stage'
                    ,
                        icon : "/assets/actions/clock.png"
                        closeOnDrop : false           
                        callback : (obj) ->
                                        rescheduleAction obj
                    ,
                        icon : "/assets/actions/hourglass.jpg"
                        closeOnDrop : true
                        callback : (obj) ->
                                        waitForSec getRecordId(obj)
                    ,
                        icon : "/assets/actions/stop.png"
                        closeOnDrop : true
                        callback : (obj) ->
                                        directAction getRecordId(obj), 'reject'
                    ]
    getDragHelper = (obj) ->
        candidate = obj.find('.candidate-name').text();
        project = obj.find('.project-name').text();
        imgSrc = obj.find('.action-icon').attr('src');
        htmlStr = '<div class="task-helper">
            <div class="content-left-helper"> 
            <img class="action-icon-helper" src=' + imgSrc + '> 
            </div>
            <div class="content-right-helper">
            <div class="candidate-name-helper">' + candidate + '</div>
            <div class="project-name-helper">' + project + '</div>
            </div>'; 
        return $(htmlStr);
    
    initRescheduleBox = ->
        createRescheduleBox = ->
            reschedule = $('<div class="reschedule-box"></div>').load('/dialogs.html');
            $('.quickdrop-records').append(reschedule);
        createRescheduleBox()
    initRescheduleBox()

    window.reloadQuickDrop = ->
         $('body').quickdrop('reloadDraggable', getDragHelper);
   
    $('body').quickdrop({
        'dragHelperCallback' : getDragHelper, 
        'actions' : callbacks()
    });

    
