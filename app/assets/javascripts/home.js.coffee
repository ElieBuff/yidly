jQuery ->
    return if $('#home-page').length == 0
    reloadData = ->
        taskList = ->
            $.get '/tasks.json', (data) ->
                filterActionableBefore = (tasks, datePoint) ->
                    tasks.filter (task) -> new Date(task.actionable_at) < datePoint

                displayTasks = (container, tasks) ->
                    createHtml = (d, i) ->
                        ich.task(UTILS.formatTimeStampInDict(d, 'actionable_at')).html()

                    divs = container.selectAll('.task-container').data(tasks).html(createHtml)
                    divs.enter().append('div').attr('class', 'task-container').html(createHtml)
                    divs.exit().remove()

                #displayTasks d3.select('.today_tasks'), filterActionableBefore(data, new Date())
                displayTasks d3.select('.tasks-list'), data

        projectList = ->
            $.get '/projects.json', (data) ->
                displayProjects = (container, projects) ->
                    createHtml = (d,i) ->
                        ich.project(d).html()
                    divs = container.selectAll('.project-container').data(projects).html(createHtml)
                    divs.enter().append('div').attr('class', 'project-container').html(createHtml)
                    divs.exit().remove()
                displayProjects d3.select('.project-list'), data

        taskList()
        projectList()

    createDateFilter = ->
        $('.date_radio').click () ->
            switch $(this).val()
                when 'today'
                    $('.today_tasks').show()
                    $('.all_tasks').hide()
                when 'alldays'
                    $('.today_tasks').hide()
                    $('.all_tasks').show()

    createDateFilter()
    reloadData()
