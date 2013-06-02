jQuery ->
    return if $('#home-page').length == 0
    reloadData = ->
        
        taskList = ->
            $.get '/tasks/urgent_and_today.json?tipping_point=' + moment().startOf('day')._d*1, (data) ->
                
                GetHour = (d) -> moment(d).calendar()
                GetDay = (d) -> moment(d).fromNow()
                GetProject = (d) -> d

                createTaskListWrapper = (data, titleFunc, itemsList, template) ->
                    calendarTime = (d) -> UTILS.formatTimeStampInDict(d, 'actionable_at')
                    createTitle = (d) ->
                        ich.task_list(title: titleFunc(d)).html()
                    createTask = (d, i) ->
                        ich[template](d).html()

                    DisplayTaskItem = (container)->
                        taskItem = container.selectAll('.item-container')
                            .data((d) -> return data[d].map(calendarTime);)
                            .html(createTask)
                               
                        taskItem.enter()
                            .append('div')
                            .attr('class', 'item-container')
                            .html(createTask)

                        taskItem.exit().remove()
                    
                    taskContainer = d3.select(itemsList)
                    .selectAll('.task-list')
                    .data(Object.keys(data))
                    .html(createTitle)

                    taskContainer.enter()
                        .append('div')
                        .attr('class', 'task-list')
                        .html(createTitle)
                        .selectAll('.item-container')
                        .data((d) -> return data[d].map(calendarTime);)
                            .enter()
                            .append('div')
                            .attr('class', 'item-container')
                            .html(createTask)

                    taskContainer.exit().remove()

                    DisplayTaskItem taskContainer
                    
                today =  -> createTaskListWrapper data.today, GetHour, '.today-tasks .item-list', 'task'
                later =  -> createTaskListWrapper data.later, GetDay, '.later-tasks .item-list', 'task'
                urgent = ->
                    createTaskListWrapper data.urgent, GetProject, '.urgent-tasks .item-list', 'urgent_task'
                    createTaskListWrapper data.urgent, GetProject, '.urgent-tasks-big .item-list', 'task'

                today()
                later()
                urgent()

                reloadQuickDrop()

                
        projectList = ->
            $.get '/projects.json', (data) ->
                displayItems = (container, template, items) ->
                    createHtml = (d, i) ->
                        ich[template](d).html()

                    divs = container.selectAll('.item-container').data(items).html(createHtml)
                    divs.enter().append('div').attr('class', 'item-container').html(createHtml)
                    divs.exit().remove()
                displayItems d3.select('.projects .item-list'), 'project', data

        projectList()
        taskList()
    userEventHandling = ->
        $('.urgent-tasks').click () ->
            $('.urgent-tasks-big').lightbox_me
                overlayCSS:
                    opacity: 0.9
                    background: 'black'


    initQuickDrop(reloadData)
    userEventHandling()
    reloadData()
