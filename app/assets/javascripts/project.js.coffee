jQuery ->
    return if $('#project-page').length == 0
    project_id = $('#project-page').attr('project-id')
    reloadData = ->
        $.get "/projects/#{project_id}/display.json", (stages_and_records) ->
            displayStages = (stagesContainer, stages_and_records) ->
                createRecord = (d, i) ->
                    ich.task(UTILS.formatTimeStampInDict(d,
                        'actionable_at',
                        (d)-> d.split(' at ')[0]
                    )).html()
                displayProjectName = (name) ->
                    $('.project-name').html(ich.project name:name)
                displayRecordsOfStage = (taskListWrapper, tasks) ->
                    divs = d3.select(taskListWrapper[0]).selectAll('.task-container').data(tasks).html(createRecord)
                    divs.enter().append('div').attr('class', 'task-container').html(createHtml)
                    divs.exit().remove()
                createTaskListWrapper = () ->
                    wrapper = (d) ->
                        (ich.stage
                            name: d.name
                            id: d.id
                            img: d.img
                        ).html()
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
               
            addRecordButton = ->
                $('.add').button().click (event) ->
                    button = $(this)
                    ich.new_record().dialog
                        autoOpen: true
                        width: 350
                        height: 300
                        modal: true
                        buttons:
                            "Create": () ->
                                that = $(this)
                                val = (field) ->
                                    that.find("##{field}").val()
                                $.post(
                                    "/records/my_create.json",
                                    stage_id: button.attr('id').replace('add-button-','')
                                    name: val('name')
                                    email: val('email')
                                )
                                reloadData()
                                that.dialog 'close'
                            "Cancel": () -> $(this).dialog 'close'

            displayStages $('.stages'), stages_and_records
            addRecordButton()
            reloadQuickDrop()


    initQuickDrop(reloadData)
    reloadData()

