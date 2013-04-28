jQuery ->
    return if $('#project-page').length == 0
    reloadData = ->
        $.get '/projects/random.json', (stages_and_records) ->
            displayStages = (stagesContainer, stages_and_records) ->
                displayProjectName = (name) ->
                    $('.project-name').append(ich.project name:name)
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
                setWidth = (nStages) ->
                       $('.stage').css 'width', "#{100/nStages - 1}%"
                       $('.icon').height($('.icon').width())

                displayProjectName stages_and_records.name
                displayRecordsOfStage createTaskListWrapper(stage), (stages_and_records.records[stage] || []) for stage in stages_and_records.stages
                setWidth stages_and_records.stages.length

            displayStages $('.stages'), stages_and_records

    reloadData()

