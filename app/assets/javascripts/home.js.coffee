jQuery ->
    return if $('#home-page').length == 0
    reloadData = ->
        displayListFromServer = (args) ->
            $.get args.url, (data) ->
                displayItems = (container, template, items) ->
                    createHtml = (d, i) ->
                        ich[template](d).html()

                    divs = container.selectAll('.item-container').data(items).html(createHtml)
                    divs.enter().append('div').attr('class', 'item-container').html(createHtml)
                    divs.exit().remove()
                mappie = (collection, func) ->
                    if func then collection.map(func) else collection
                filterie = (collection, func) ->
                    if func then collection.filter(func) else collection
                
                displayItems param.container, param.template, mappie(filterie(data, param.filter), args.mapper) for param in args.params
                reloadQuickDrop()

        taskList = ->
           filterActionableBefore = (tasks, datePoint) ->
                tasks.filter (task) -> new Date(task.actionable_at) < datePoint

            displayListFromServer
                url: '/tasks.json',
                mapper: (d) -> UTILS.formatTimeStampInDict(d, 'actionable_at'),
                params : [
                        container: d3.select('.today-tasks .tasks-list')
                        filter: (x) -> (new Date(x.actionable_at) >= moment().startOf('day'))
                        template: 'task'
                    ,
                        container: d3.select('.urgent-tasks .tasks-list')
                        filter: (x) -> (new Date(x.actionable_at) < moment().startOf('day'))
                        template: 'urgent_task'
                        ]

                
        projectList = ->
            displayListFromServer
                url: '/projects.json',
                params: [
                   container: d3.select('.project-list')
                   template: 'project'
                ]

        taskList()
        projectList()
        reloadQuickDrop(); 

    initQuickDrop(reloadData)

    initQuickDrop(reloadData)
    reloadData()
