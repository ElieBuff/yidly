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
                createTaskListWrapper = () ->
                    records_for_stage = (stage) -> stages_and_records.records[stage] or []
                    wrapper = (d) ->
                        (ich.stage
                            name: d.name
                            id: d.id
                            img: d.img
                        ).html()
                    displayRecordsItem = (container)->
                        recordItem = container.selectAll('.record-container')
                            .data((d) -> records_for_stage d.name)
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
                        .data((d) -> (records_for_stage d.name))
                        .enter()
                        .append('div')
                        .attr('class', 'record-container')
                        .html(createRecord)
                    
                    stageContainer.exit().remove()

                    displayRecordsItem stageContainer

                setWidth = (nStages) ->
                       $('.stage').css 'width', "#{100/nStages - 1}%"
                
                displayProjectName stages_and_records.name
                createTaskListWrapper()
                setWidth stages_and_records.stages.length
               
            makeRecordsEditable = ->
                $('.record').click (event) ->
                    record = $(this)
                    ich.new_record().dialog
                        autoOpen: true
                        width: 350
                        height: 300
                        modal: true
                        open: ->
                            that = $(this)
                            setval = (field) ->
                                that.find("##{field}").val(record.find("##{field}").val())
                            setval field for field in ['name', 'email']
                        buttons:
                            "Save": () ->
                                that = $(this)
                                val = (field) ->
                                    that.find("##{field}").val()
                                id = -> record.attr('data-server-id')
                                $.post(
                                    "/records/#{id()}/my_edit.json",
                                    stage_id: val('stage_id')
                                    name: val('name')
                                    email: val('email')
                                )
                                reloadData()
                                that.dialog 'close'
                            "Cancel": () -> $(this).dialog 'close'
            addRecordButtons = ->
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
                                    stage_id: button.attr('data-server-id')
                                    name: val('name')
                                    email: val('email')
                                )
                                reloadData()
                                that.dialog 'close'
                            "Cancel": () -> $(this).dialog 'close'

            displayStages $('.stages'), stages_and_records
            addRecordButtons()
            makeRecordsEditable()
            reloadQuickDrop()


    initQuickDrop(reloadData)
    reloadData()

