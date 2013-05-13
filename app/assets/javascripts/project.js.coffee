jQuery ->
    return if $('#project-page').length == 0
    project_id = $('#project-page').attr('project-id')
    reloadData = ->
        $.get "/projects/#{project_id}/display.json", (stages_and_records) ->
            displayStages = (stagesContainer, stages_and_records) ->
                displayProjectName = (name) ->
                    $('.project-name').html(ich.project name:name)
                displayRecordsOfStage = (taskListWrapper, tasks) ->
                    createHtml = (d, i) ->
                        ich.task(UTILS.formatTimeStampInDict(d, 'actionable_at')).html()

                    divs = d3.select(taskListWrapper[0]).selectAll('.task-container').data(tasks).html(createHtml)
                    divs.enter().append('div').attr('class', 'task-container').html(createHtml)
                    divs.exit().remove()
                createTaskListWrapper = () ->
                    wrapper = (d) ->
                        (ich.stage name: d.name, img: d.img).html() 
                    createRecord = (d, i) ->
                        ich.task(UTILS.formatTimeStampInDict(d, 'actionable_at')).html()
                    DisplayRecordsItem = (container)->
                        taskItem = container.selectAll('.task-container')
                            .data((d) ->
                                (stages_and_records.records[d.name] || [])
                            )
                            .html(createRecord)
                               
                        taskItem.enter()
                            .append('div')
                            .attr('class', 'task-container')
                            .html(createRecord)

                        taskItem.exit().remove()
                    
                    stageContainer = d3.select('.stages')
                                    .selectAll('.stage')
                                    .data(stages_and_records.stages)
                                    .html(wrapper)

                    stageContainer.enter()
                        .append('div')
                        .attr('class', 'stage')
                        .html(wrapper)
                        .selectAll('.task-container')
                        .data((d) ->
                                (stages_and_records.records[d.name] || [])
                            )
                            .enter()
                            .append('div')
                            .attr('class', 'task-container')
                            .html(createRecord)
                    
                    stageContainer.exit().remove()

                    DisplayRecordsItem stageContainer

                setWidth = (nStages) ->
                       $('.stage').css 'width', "#{100/nStages - 1}%"
                
                displayProjectName stages_and_records.name
                createTaskListWrapper()
                setWidth stages_and_records.stages.length
               
            displayStages $('.stages'), stages_and_records
            reloadQuickDrop()

    initQuickDrop(reloadData)
    reloadData()

