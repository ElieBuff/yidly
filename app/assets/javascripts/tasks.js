
var taskID;

$(function() {
    function reloadData(){
        $.getJSON('tasks.json', function(data) {
            function filterActionableBefore(tasks, datePoint) {
                return tasks.filter(function(task) {
                    return (new Date(task.actionable_at) < datePoint);
                });
            }
            function displayTasks(container, tasks) {
                function createHtml(d, i) {
                    return UTILS.renderDust('task', UTILS.formatTimeStampInDict(d, 'actionable_at'));
                }
                var divs = container.selectAll('.task-container').data(tasks).html(createHtml);
                divs.enter().append('div').attr('class', 'task-container').html(createHtml);
                divs.exit().remove();
            }


            displayTasks(d3.select('.today_tasks'), filterActionableBefore(data, new Date()));
            displayTasks(d3.select('.all_tasks'), data);
        });
    }
    reloadData();

    $( "#Reschedule" ).dialog({ 
        position: { my: "center", at: "center", of: ".reschedule_box" },
        autoOpen: false,  
        resizable: false,
        height:150,
        width:150,
        modal: true
    });


    $(document).on("click", "body", function(){
        taskID = '';
        $('#Reschedule').dialog('close');
    });

    $(document).on("dragstart", ".task", function(e){
        var id = e.target.getAttribute('id')
        e.originalEvent.dataTransfer.setData("text/plain", id); 
    });



    $(document).on("dragover", ".drop_box", function(e){
        e.preventDefault();
    });



    $('.drop_done,.drop_cancel').on('drop', function(e) {
        function getTask(id) {
            var title = $('#'+ id + ' .title').text();
            return '<div id="' + id + '" class="drop_data">' + title + '</div>'
        }

        e.preventDefault();
        var id = e.originalEvent.dataTransfer.getData("text/plain");
        $(this).append(getTask(id));
        var recordId = id.replace('task', '');
        $.getJSON('/records/' + recordId + '/move_to_next_stage.json', function(data) {
            $('#' + taskID).remove();
            $('.drop_done').append(getProcessedTask(data));
        });
        reloadData();
    });

    $('.drop_reschedule').on('drop', function(e) {
        e.preventDefault();
        taskID = e.originalEvent.dataTransfer.getData("text/plain");
        $('#Reschedule').dialog('open');
    });



    $('.date_radio').click(function() {
        var val = $(this).val();
        if(val == 'today')
    {
        $('.today_tasks').show();
        $('.all_tasks').hide();
    }
        else
    {
        $('.today_tasks').hide();
        $('.all_tasks').show();
    }
    });

    $('.reschedule_time').click(function() {
        var jQueryThis = $(this);
        function url(){
            function futureStr() {
                return  jQueryThis.attr('data-reschedule')
            }
            function timeInSec(futureStr) {
                var HOUR = 3600;
                return {
                    same_day: 1*HOUR,
        tomorrow: 24*HOUR,
        in_a_week: 7*24*HOUR
                }[futureStr];
            }

            function recordId() {
                return taskID.replace('task', '');
            }
            console.log( '/records/' + recordId() + '/reschedule_in_sec.json?delay=' + timeInSec(futureStr()));
            return '/records/' + recordId() + '/reschedule_in_sec.json?delay=' + timeInSec(futureStr());
        }
        $.getJSON(url(), function(data) {
            $('#' + taskID).remove();
            $('.drop_reschedule').append(getProcessedTask(data));
        });
        reloadData();
    });
});

function getProcessedTask(data)
{
    return UTILS.renderDust("record_small", UTILS.formatTimeStampInDict(data, 'actionable_at'));
}


