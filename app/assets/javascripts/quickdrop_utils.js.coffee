jQuery ->
    
    window.initQuickDrop = (callback)->
        callbacks = ->
            directAction = (obj, server_function) ->
                jQueryElement = $(this)
                id = obj.attr('id');
                recordId = id.replace('task', '')
                $.get Mustache.render("/records/{{ id }}/{{ action }}.json"
                    id: recordId
                    action: server_function
                    ), (data) ->
                    callback.call()   
            createRescheduleAction = ->
                $("#reschedule-dialog").dialog
                    dialogClass: 'reschedule-dialog'
                    show: 'slide'
                    hide: 'slide'
                    autoOpen: false
                    resizable: false
                    width:220
                    dialogClass:'reschedule-dialog'
                    modal: true
                        
                $(document).on "click", "body", () -> $('#reschedule-dialog').dialog('close')
                            
                $('.reschedule-option').click () ->
                    dataElement = -> $('#reschedule-dialog')
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
                        callback.call()
            createRescheduleAction()

            nextStage = (obj) ->
                directAction obj, 'move_to_next_stage'
            reschedule = (obj) ->
                $('#reschedule-dialog').data('obj', obj)
                $('#reschedule-dialog').dialog('open') 
            wait = (obj) ->
                directAction obj, 'wait'
            reject = (obj) ->
                directAction obj, 'reject'
            actions = [
                        {
                        "icon" : "/assets/actions/done.gif",
                        "callback" : nextStage
                        }
                        {
                        "icon" : "/assets/actions/clock.png",           
                        "callback" :  reschedule
                        }
                        {
                        icon : "/assets/actions/hourglass.jpg"
                        callback :  wait
                        },
                        {
                        "icon" : "/assets/actions/stop.png",
                        "callback" :  reject
                        }
                    ]
        
        $('body').sidebar({'actions' : callbacks()});
    
    window.reloadQuickDrop = ->

         $('body').sidebar('reloadDraggable');

    
 
