/*
$.get('assets/record_small.html', function(templates) {
    //ich.addTemplate('record_small', $(templates).html());
});

$.get('assets/task.html', function(templates) {
    //ich.addTemplate('task', $(templates).html());
});
*/
$(function() {
    function getProcessedTask(data) {
        return ich.record_small(UTILS.formatTimeStampInDict(data, 'actionable_at')).html();
    }
    function reloadData(){
        $.getJSON('tasks.json', function(data) {
            function filterActionableBefore(tasks, datePoint) {
                return tasks.filter(function(task) {
                    return (new Date(task.actionable_at) < datePoint);
                });
            }
            function displayTasks(container, tasks) {
                function createHtml(d, i) {
                    return ich.task(UTILS.formatTimeStampInDict(d, 'actionable_at')).html();
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
    $("#reschedule-dialog").dialog({ 
        dialogClass: 'reschedule-dialog',
        show: 'slide',
        hide: 'slide',
        position: { my: "center", at: "center", of: ".reschedule_box" },
        autoOpen: false,  
        resizable: true,
        width:600,
        modal: true
    });
    $(document).on("click", "body", function(){
        $('#reschedule-dialog').dialog('close');
    });
    $(document).on("dragstart", ".task", function(e){
        var id = e.target.getAttribute('id')
        e.originalEvent.dataTransfer.setData("text/plain", id); 
    });
    $(document).on("dragover", ".drop_box", function(e){
        e.preventDefault();
    });
    (function setDropBoxes(){
        function setDropBox(args) {
            $(args.selector).on('drop', function(e) {
                function getTask(id) {
                    var title = $('#'+ id + ' .title').text();
                    return '<div id="' + id + '" class="drop_data">' + title + '</div>'
                }
                var jQueryElement = $(this);
                var id = e.originalEvent.dataTransfer.getData("text/plain");
                e.preventDefault();
                jQueryElement.append(getTask(id));
                var recordId = id.replace('task', '');
                $.getJSON('/records/' + recordId + '/' + args.server_function + '.json', function(data) {
                    jQueryElement.append(getProcessedTask(data));
                });
                reloadData();
            });
        }
        $.each([
    {
        selector: '.drop_reject',
            server_function: 'reject'
    },
        {
            selector: '.drop_done',
            server_function: 'move_to_next_stage'
        }
        ], function(index, args){
            setDropBox(args);
        });
        $('.drop_reschedule').on('drop', function(e) {
            e.preventDefault();
            $('#reschedule-dialog').data('recordId', e.originalEvent.dataTransfer.getData("text/plain").replace('task',''));
            $('#reschedule-dialog').dialog('open');
        });
    }());
    $('.date_radio').click(function() {
        var val = $(this).val();
        if(val == 'today') {
            $('.today_tasks').show();
            $('.all_tasks').hide();
        } else {
            $('.today_tasks').hide();
            $('.all_tasks').show();
        }
    });
    $('.reschedule-option').click(function() {
        function dataElement() {
            return $('#reschedule-dialog');
        }
        function recordId() {
            return dataElement().data('recordId');
        }
        function clear() {
            return dataElement().removeData('recordId');
        }
        var jQueryThis = $(this);
        function url(id){
            function futureStr() {
                return  jQueryThis.attr('data-reschedule')
            }
            function fromNowInSec(futureStr) {
                function the_moment(futureStr) {
                    switch(futureStr) {
                        case 'same_day': return moment().add('hours',1);
                        case 'this_evening': return moment().endOf('day').subtract('hours', 6);
                        case 'tonight': return moment().endOf('day').subtract('hours', 3);
                        case 'tomorrow': return moment().add('days',1).startOf('day').add('hours', 7);
                        case 'in_two_days': return moment().add('days',2).startOf('day').add('hours', 7);
                        case 'in_a_week': return moment().add('days',7).startOf('day').add('hours', 7);
                    }
                    return moment();
                }
                return (the_moment(futureStr) - moment())/1000;
            }
            return '/records/' + id + '/reschedule_in_sec.json?delay=' + fromNowInSec(futureStr());
        }
        $.getJSON(url(recordId()), function(data) {
            $('.drop_reschedule').append(getProcessedTask(data));
            clearElementData();
            reloadData();
        });
    });
});
