jQuery ->
    return if $('#home-page').length == 0
    reloadData = ->
        displayItems = (container, template, items) ->
            createHtml = (d, i) ->
                ich[template](d).html()

            divs = container.selectAll('.item-container').data(items).html(createHtml)
            divs.enter().append('div').attr('class', 'item-container').html(createHtml)
            divs.exit().remove()

        taskList = ->
            $.get '/tasks/urgent_and_today.json?tipping_point=' + moment().startOf('day')._d, (data) ->
                calendarTime = (d) -> UTILS.formatTimeStampInDict(d, 'actionable_at')
                today =  ->
                    createTaskListWrapper = (hour) ->
                        wrapper = ich.task_list title: "#{hour}:00 - #{hour+1}:00"
                        $('.today-tasks .item-list').append wrapper
                        d3.select(wrapper[0])
                    displayItems createTaskListWrapper(1*hour), 'task', tasks.map(calendarTime) for hour, tasks of data.today
                urgent = ->
                    createTaskListWrapper = (project, container) ->
                        wrapper = ich.task_list title: project
                        container.append wrapper
                        d3.select(wrapper[0])
                    displayItems createTaskListWrapper(project, $('.urgent-tasks .item-list')), 'urgent_task', tasks.map(calendarTime) for project, tasks of data.urgent
                    displayItems createTaskListWrapper(project, $('.urgent-tasks-big .item-list')), 'task', tasks.map(calendarTime) for project, tasks of data.urgent
                urgent()
                today()
                reloadQuickDrop()

                
        projectList = ->
            $.get '/projects.json', (data) ->
                displayItems d3.select('.projects .item-list'), 'project', data

        projectList()
        taskList()
    userEventHandling = ->
        $('.urgent-tasks').mouseover () ->
            $('.urgent-tasks-big').lightbox_me
                overlayCSS:
                    opacity: 0.9
                    background: 'black'


    initQuickDrop(reloadData)
    userEventHandling()
    reloadData()
