jQuery ->
    return if $('#project-page').length == 0
    project_id = $('#project-page').attr('project-id')
    reloadData = ->
        $.get "/projects/#{project_id}/display.json", (stages_and_records) ->
            displayStages = (stagesContainer, stages_and_records) ->
                createRecord = (d, i) ->
                    ich.record(UTILS.formatTimeStampInDict(d,
                        'actionable_at',
                        (d)-> d.split(' at ')[0]
                    )).html()
                displayProjectName = (name) ->
                    $('.project-name').html(ich.project name:name)
                displayRecordsOfStage = (recordListWrapper, records) ->
                    divs = d3.select(recordListWrapper[0]).selectAll('.record-container').data(records).html(createRecord)
                    divs.enter().append('div').attr('class', 'record-container').html(createHtml)
                    divs.exit().remove()
                createTaskListWrapper = () ->
                    wrapper = (d) ->
                        (ich.stage
                            name: d.name
                            id: d.id
                            img: d.img
                        ).html()
                    DisplayRecordsItem = (container)->
                        recordItem = container.selectAll('.record-container')
                            .data((d) ->
                                (stages_and_records.records[d.name] || [])
                            )
                            .html(createRecord)
                               
                        recordItem.enter()
                            .append('div')
                            .attr('class', 'record-container')
                            .html(createRecord)

                        recordItem.exit().remove()
                    
                    stageContainer = d3.select('.stages')
                                    .selectAll('.stage')
                                    .data(stages_and_records.stages)
                                    .html(wrapper)

                    stageContainer.enter()
                        .append('div')
                        .attr('class', 'stage')
                        .html(wrapper)
                        .selectAll('.record-container')
                        .data((d) ->
                                (stages_and_records.records[d.name] || [])
                            )
                            .enter()
                            .append('div')
                            .attr('class', 'record-container')
                            .html(createRecord)
                    
                    stageContainer.exit().remove()

                    DisplayRecordsItem stageContainer

                setWidth = (nStages) ->
                       $('.stage').css 'width', "#{100/nStages - 1}%"
                
                displayProjectName stages_and_records.name
                createTaskListWrapper()
                setWidth stages_and_records.stages.length
               
            makeRecordEditable = ->
                $('.record').click (event) ->
                    record = $(this)
                    ich.new_record().dialog
                        autoOpen: true
                        width: 350
                        height: 300
                        modal: true
                        buttons:
                            "Save": () ->
                                that = $(this)
                                val = (field) ->
                                    that.find("##{field}").val()
                                id = -> record.attr('id').replace('record-','')
                                $.post(
                                    "/records/#{id()}/my_edit.json",
                                    stage_id: val('stage_id')
                                    name: val('name')
                                    email: val('email')
                                )
                                reloadData()
                                that.dialog 'close'
                            "Cancel": () -> $(this).dialog 'close'
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
            makeRecordEditable()
            reloadQuickDrop()


    initQuickDrop(reloadData)
    reloadData()

