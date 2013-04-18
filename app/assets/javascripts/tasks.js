
var taskID;
dust.helpers.formatDate = function (chunk, context, bodies, params) {
    var value = dust.helpers.tap(params.value, chunk, context);
    return chunk.write(moment(new Date(value)).calendar());
};

$(function() {
    function reloadData(){
        $.getJSON('tasks.json', function(data) {
            function filterActionableBefore(tasks, datePoint) {
                return tasks.filter(function(task) {
                    return (new Date(task.actionable_at) < datePoint);
                });
            }
            function displayTasks(container,tasks) {
                function createHtml(d, i) {
                    var result;
                    dust.render("task", d, function(err, out) {
                        result = out;
                    });
                    return result;
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
            $('.drop_reschedule').append(getProcessedTask(data));
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

function getDateTimeFormat(date)
{
    return getDateFormat(date) + ' ' + getTimeFormat(date);
}   

function getDateFormat(date)
{
    var day = ('0' + date.getDate()).slice(-2);
    var month = ('0' + (date.getMonth() + 1)).slice(-2);
    var year = date.getFullYear();
    return day + '-' + month + '-' + year;
}

function getTimeFormat(date)
{
    var hours = ('0' + (date.getHours() + 1)).slice(-2);
    var minutes = ('0' + (date.getMinutes() + 1)).slice(-2);
    return hours + ':' + minutes;
}

function isNotSameDay(date1, date2)
{
    return(date1.getDate() != date2.getDate() || 
            date1.getMonth() != date2.getMonth() || 
            date1.getFullYear() != date2.getFullYear());
}


function getProcessedTask(data)
{
    var formatedDate = '';
    if(isNotSameDay(new Date(), new Date(data.actionable_at)))
        formatedDate = getDateTimeFormat(new Date(data.actionable_at));
    else
        formatedDate = getTimeFormat(new Date(data.actionable_at));
    return '<div class="drop_data">' + data.name + formatedDate +'</div>'
}


