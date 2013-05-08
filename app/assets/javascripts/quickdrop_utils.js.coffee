window.initQuickDrop = (refreshDataCallBack)->
    callbacks = ->
        directAction = (recordId, server_function) ->
            $.get Mustache.render("/records/{{ id }}/{{ action }}.json"
                id: recordId
                action: server_function
                ), (data) ->
                    refreshDataCallBack()
        waitForSec = (recordId) ->
            $.get Mustache.render("/records/{{ id }}/wait_for_sec.json?delay=86400"
                id: recordId
                ), (data) ->
                    refreshDataCallBack()
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
                    of: "#home-page" 
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

                $.get url(recordId()), (data) ->
                    refreshDataCallBack()
        createRescheduleAction()

        getRecordId = (obj) ->
            id = obj.attr('id')
            recordId = id.replace('task', '')

        actions =   [
                        icon : "/assets/actions/done.gif"
                        callback : (obj) ->
                                        directAction getRecordId(obj), 'move_to_next_stage'
                    ,
                        icon : "/assets/actions/clock.png",           
                        callback : (obj) ->
                                        $('#dialog').data('obj', obj)
                                        $('#dialog').dialog('open') 
                    ,
                        icon : "/assets/actions/hourglass.jpg"
                        callback : (obj) ->
                                        waitForSec getRecordId(obj)
                    ,
                        icon : "/assets/actions/stop.png"
                        callback : (obj) ->
                                        directAction getRecordId(obj), 'reject'
                    ]
    
    $('body').quickdrop({'actions' : callbacks()});

window.reloadQuickDrop = ->
     $('body').quickdrop('reloadDraggable');

    
 
