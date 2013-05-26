window.initDropabbleStage = (refreshDataCallBack) ->
  $('.stage').droppable
    hoverClass: "drop-hover",
    drop: (event, ui) ->
      stage = $(this)
      record_id = 
      
      $.get Mustache.render("/records/{{ record_id }}/move_to_stage.json?stage={{ stage_id }}"
                record_id: ui.draggable.attr("id"),
                stage_id: stage.find('.header').attr('data-server-id')
                ), (data) ->
                    refreshDataCallBack()

 
