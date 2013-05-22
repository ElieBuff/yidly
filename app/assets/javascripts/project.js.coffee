jQuery ->
    return if $('#project-page').length == 0
    project_id = $('#project-page').attr('project-id')
    reloadData = ->
        $.get "/projects/#{project_id}/display.json", (stages_and_records) ->
            displayStages = (stagesContainer, stages_and_records) ->
                displayProjectName = (name) ->
                    $('.project-name').html(ich.project name:name)
                createTaskListWrapper = () ->
                    displayRecordsItem = (container)->
                        createRecord = (d, i) ->
                            ich.record(UTILS.formatTimeStampInDict(d,
                                                    'actionable_at',
                                                    (d)-> d.split(' at ')[0]
                                        )).html()
                        records_for_stage = (stage) -> stages_and_records.records[stage] or []
                        recordItem = container.selectAll('.record-container')
                            .data((d) -> records_for_stage d.name)
                            .html(createRecord)
                               
                        recordItem.enter()
                            .append('div')
                            .attr('class', 'record-container')
                            .html(createRecord)

                        recordItem.exit().remove()
                    createStageContainer = ->
                        wrapper = (d) ->
                            (ich.stage
                                name: d.name
                                id: d.id
                                img: d.img
                            ).html()
                        stageContainer = d3.select('.stages')
                            .selectAll('.stage')
                            .data(stages_and_records.stages)
                            .html(wrapper)

                        stageContainer.enter()
                            .append('div')
                            .attr('class', 'stage')
                            .html(wrapper)

                        stageContainer.exit().remove()
                        stageContainer

                    displayRecordsItem createStageContainer()

                setWidth = (nStages) ->
                       $('.stage').css 'width', "#{100/nStages - 1}%"
                
                displayProjectName stages_and_records.name
                createTaskListWrapper()
                setWidth stages_and_records.stages.length
               
            eventsHandler = () ->
                makeRecordsEditable =  ->
                    dialogContainer = ich.new_record()
                    dialogContainer.dialog
                            autoOpen: false
                            width: 350
                            height: 300
                            modal: true
                            dialogClass: "recordDialog"
                            open: () ->
                                that = $(this)
                                setval = (field) ->
                                    that.find("##{field}").val(dialogContainer.data()[field])
                                setval field for field in ['email', 'name']
                            buttons:
                                "Save": () ->
                                    that = $(this)
                                    val = (field) ->
                                        that.find("##{field}").val()
                                    id = -> dialogContainer.data().id
                                    $.post(
                                        "/records/#{id()}/my_edit.json",
                                        stage_id: val('stage_id')
                                        name: val('name')
                                        email: val('email')
                                    )
                                    reloadData()
                                    that.dialog 'close'
                                "Cancel": () -> $(this).dialog 'close'
                    $('.record').click (event) ->
                        that = $(this)
                        dialogContainer.data that.data()
                        dialogContainer.dialog 'open'

                addRecordButtons = ->
                    $('.add').click (event) ->
                        button = $(this)
                        ich.new_record().dialog
                            autoOpen: true
                            width: 350
                            height: 300
                            modal: true
                            dialogClass: "recordDialog"
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
                addRecordButtons()
                makeRecordsEditable()

            updateRecordsData = (records) ->
                updateRecordData = (record) ->
                    $(".record[data-server-id=#{record.id}]").data(record)
                updateRecordData record for record in records

            displayStages $('.stages'), stages_and_records
            updateRecordsData records for stage, records of stages_and_records.records
            eventsHandler()
            reloadQuickDrop()

    initQuickDrop(reloadData)
    reloadData()

