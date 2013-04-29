(function($) {

    $.widget("ui.sidebar", {
		options: {
			sidebarContainer: ".sidebar-records",
			actions : []
		},
				
		_create: function() {
			startDragabble = function(){
				$(this).addClass('draged');
				$('.sidebar').animate({
          			opacity: 0.9
          			}, 500, function() {
          		});
           		
			}
			stopDragabble = function(){
				$(this).removeClass('draged');
				$('.sidebar').animate({
          			opacity: 0.9
          			}, 500, function() {
           		});
			}
			var self = this,
				   o = self.options; 
			htmlStr = "";
      		htmlStr += "<div class='sidebar'>";
      		htmlStr += "<div class='actions'></div>";
      		htmlStr += "</div>";
      		$(o.sidebarContainer).parent().css("position","relative"); 
    		$(o.sidebarContainer).append(htmlStr);
    		this._refresh();
		},
		
		 _refresh: function() {
		 	function processTaskAction(jqueryObj, ui){
		 		jqueryObj.data('callback').call(undefined, ui.draggable);
		 	}

		 	var self = this,
				   o = self.options; 
		 	var imgWidth = Math.floor(100 / o.actions.length);
    		$(".actions").empty();
    		$.each( o.actions, function( index, value ) {
    			if(value['icon'])
        		{
          			$(".actions").append("<div id='action" + index + "' class='action' style='width:" + imgWidth + "%'><img src='" + value['icon'] + "'/></div>");
          			$("#action" + index).data('callback', value['callback']);
        		}
      		});

      		$( ".action" ).droppable({
      			hoverClass: "drop-hover",
      			 drop: function( event, ui ) {
      			 	processTaskAction($(this), ui);
				}
      		});
    		this.reloadDraggable();			
		},

		reloadDraggable:function(){
			$(".draggable").draggable({
				cursor: "move",
				helper: "clone",
				revert: "invalid",
				opacity: 0.9,
				zIndex: 100,
				cursorAt: { top: -2, left: -2 },
				helper: function( event ) {
					var candidate = $(this).find('.candidate-name').text();
					var project = $(this).find('.project-name').text();
					var imgSrc = $(this).find('.action-icon').attr('src');
					var htmlStr = '<div class="task-helper">';
					htmlStr += '<div class="content-left-helper">';
					htmlStr += '<img class="action-icon-helper" src=' + imgSrc + '>';
					htmlStr += '</div>';
					htmlStr += '<div class="content-right-helper">';
					htmlStr += '<div class="candidate-name-helper">' + candidate + '</div>';
					htmlStr += '<div class="project-name-helper">' + project + '</div>';
					htmlStr += '</div>';

					return $(htmlStr);
				},
				start: startDragabble,
				stop: stopDragabble
			});	
		},

		destroy: function() {			
			this.element.next().remove();
			
			$(window).unbind("sidebar");
		},
		
		 _setOptions: function() {
			this._superApply( arguments );
			this._refresh();
		},

		_setOption: function( key, value ) {
			this._super( key, value );
		}

	});
})(jQuery);