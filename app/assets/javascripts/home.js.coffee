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
                createTaskListWrapper = (hour) ->
                    wrapper = ich.hourly_task_list hour: hour
                    $('.today-tasks .tasks-list').append wrapper
                    d3.select(wrapper[0])
                today =  ->
                    displayItems createTaskListWrapper(hour), 'task', tasks.map(calendarTime) for hour, tasks of data.today
                urgent = ->
                    displayItems d3.select('.urgent-tasks .tasks-list'), 'urgent-task', data.urgent.map(calendarTime)
                #urgent()
                today()
                reloadQuickDrop()

        projectList = ->
            $.get '/projects.json', (data) ->
                displayItems d3.select('.project-list'), 'project', data

        projectList()
        taskList()

    initQuickDrop(reloadData)
    reloadData()
