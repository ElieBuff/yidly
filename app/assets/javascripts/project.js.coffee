jQuery ->
    return if $('#project-page').length == 0
    reloadData = ->
        $.get '/projects/random.json', (stages_and_records) ->
            filterActionableBefore = (stages_and_records, datePoint) ->
                filterTasksActionableBefore = (tasks, datePoint) ->
                    tasks.filter (task) -> new Date(task.actionable_at) < datePoint
                UTILS.replaceInDict stages_and_records, 'records', filterTasksActionableBefore(stages_and_records.records)


            displayStages = (stagesContainer, stages_and_records) ->
                displayRecordsOfStage = (taskListWrapper, tasks) ->
                    createHtml = (d, i) ->
                        ich.task(UTILS.formatTimeStampInDict(d, 'actionable_at')).html()

                    divs = d3.select(taskListWrapper[0]).selectAll('.task-container').data(tasks).html(createHtml)
                    divs.enter().append('div').attr('class', 'task-container').html(createHtml)
                    divs.exit().remove()
                createTaskListWrapper = (stage) ->
                    wrapper = ich.stage name: stage
                    stagesContainer.append wrapper
                    wrapper

                displayRecordsOfStage createTaskListWrapper(stage), (stages_and_records.records[stage] || []) for stage in stages_and_records.stages

                #displayStages $('.today_tasks'), filterActionableBefore(stages_and_records, new Date())
            displayStages $('.all_tasks'), stages_and_records
    createDateFilter = ->
        $('.date_radio').click () ->
            switch $(this).val()
                when 'today'
                    $('.today_tasks').show()
                    $('.all_tasks').hide()
                when 'alldays'
                    $('.today_tasks').hide()
                    $('.all_tasks').show()

    createDropBoxes = ->
        getProcessedTask = (data) -> ich.record_small(UTILS.formatTimeStampInDict(data, 'actionable_at')).html()
        createDropBox = (args) ->
            $(args.selector).on 'drop', (e) ->
                jQueryElement = $(this)
                recordId = () -> e.originalEvent.dataTransfer.getData("text/plain")
                e.preventDefault()
                $.get Mustache.render("/records/{{ id }}/{{ action }}.json"
                    id: recordId()
                    action: args.server_function
                ), (data) ->
                    jQueryElement.append(getProcessedTask(data))

                reloadData()
            
        createRescheduleBox = ->
            $("#reschedule-dialog").dialog
                dialogClass: 'reschedule-dialog'
                show: 'slide'
                hide: 'slide'
                position:
                    my: "center"
                    at: "center"
                    of: ".reschedule_box"
                autoOpen: false
                resizable: true
                width: 600
                modal: true
                
            $(document).on "click", "body", () -> $('#reschedule-dialog').dialog('close')
            $('.drop_reschedule').on 'drop', (e) ->
                e.preventDefault()
                $('#reschedule-dialog').data('recordId', e.originalEvent.dataTransfer.getData("text/plain"))
                $('#reschedule-dialog').dialog('open')
            
            $('.reschedule-option').click () ->
                dataElement = -> $('#reschedule-dialog')
                recordId = -> dataElement().data('recordId')
                clear = -> dataElement().removeData('recordId')

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
                    $('.drop_reschedule').append(getProcessedTask(data))
                    clear()
                    reloadData()

        handleDragEvents = ->
            $(document).on "dragover", ".drop_box", (e) -> e.preventDefault()
            $(document).on "dragstart", ".task", (e) ->
                id = e.target.getAttribute('id').replace 'task', ''# must be called outside a function
                e.originalEvent.dataTransfer.setData("text/plain", id)
        
        handleDragEvents()
        createDropBox args for args in [
            {
                selector: '.drop_reject'
                server_function: 'reject'
            }
            {
                selector: '.drop_done'
                server_function: 'move_to_next_stage'
            }
            ]
        createRescheduleBox()

    createDateFilter()
    reloadData()
    createDropBoxes()

