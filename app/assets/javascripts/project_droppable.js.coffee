window.initDropabbleStage = (refreshDataCallBack) ->
  $('.stage').droppable
    hoverClass: "drop-hover",
    drop: (event, ui) ->
      hideQuickDrop()

      stage = $(this)
      record = ui.draggable
      
      clonedRecord = record.clone().removeClass('draged')
      stage.append($('<div class="record-container"></div>').append(clonedRecord));  

      record.parent().hide()

      $.get Mustache.render("/records/{{ record_id }}/move_to_stage.json?stage={{ stage_id }}"
                record_id: record.attr("id"),
                stage_id: stage.find('.header').attr('data-server-id')
                ), (data) ->
                    refreshDataCallBack()
      

 
