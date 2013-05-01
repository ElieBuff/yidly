(function($) {

    $.widget("ui.quickdrop", {
		options: {
			quickdropContainer: ".quickdrop-records",
			actions : []
		},
				
		_create: function() {
			startDragabble = function(){
				$(this).addClass('draged');
				$('.quickdrop').animate({
          			opacity: 0.9
          			}, 500, function() {
          		});
           		
			}
			stopDragabble = function(){
				$(this).removeClass('draged');
				$('.quickdrop').animate({
          			opacity: 0
          			}, 500, function() {
           		});
			}
			getQuickDrop = function(){
				htmlStr = "";
      			htmlStr += "<div class='quickdrop'>";
      			htmlStr += "<div class='actions'></div>";
      			htmlStr += "</div>";
				return htmlStr;
			}
			invokeTaskAction = function (jqueryObj, ui){
				debugger;
		 		jqueryObj.data('callback').call(undefined, ui.draggable);
		 	}
			var self = this,
				   o = self.options; 
			
      		$(o.quickdropContainer).parent().css("position","relative"); 
    		$(o.quickdropContainer).append(getQuickDrop());
    		this._refresh();
		},
		
		 _refresh: function() {
		 	initQuickDropActions = function (){
		 		insertIcons = function (){
			 		var imgWidth = Math.floor(100 / o.actions.length);
	    			$(".actions").empty();
	    			$.each( o.actions, function( index, value ) {
	    				if(value['icon'])
	        			{
	          				$(".actions").append("<div id='action" + index + "' class='action' style='width:" + imgWidth + "%'><img src='" + value['icon'] + "'/></div>");
	          				$("#action" + index).data('callback', value['callback']);
	        			}
	      			});
			 	}
			 	initIcons = function (){
			 		$( ".action" ).droppable({
		      			hoverClass: "drop-hover",
		      			 drop: function( event, ui ) {
		      			 	invokeTaskAction($(this), ui);
						}
		      		});
		      		//var drop_function = $(".action").droppable('option', 'drop')
					//drop_function();
			 	}
			 	insertIcons()
			 	initIcons()
		 	}
		 	

		 	var self = this,
				   o = self.options; 
		 	initQuickDropActions();      		
    		this.reloadDraggable();			
		},

		reloadDraggable:function(){
			
			initDraggableTask = function(){
				$(".draggable").draggable({
					cursor: "move",
					helper: "clone",
					revert: "invalid",
					opacity: 0.9,
					zIndex: 100,
					cursorAt: { top: -2, left: -2 },
					helper: function( event ) {
								return getHelper($(this));
							},
					start: startDragabble,
					stop: stopDragabble
				});	
			}
			getHelper = function(obj){
				var candidate = obj.find('.candidate-name').text();
				var project = obj.find('.project-name').text();
				var imgSrc = obj.find('.action-icon').attr('src');
				var htmlStr = '<div class="task-helper">';
				htmlStr += '<div class="content-left-helper">';
				htmlStr += '<img class="action-icon-helper" src=' + imgSrc + '>';
				htmlStr += '</div>';
				htmlStr += '<div class="content-right-helper">';
				htmlStr += '<div class="candidate-name-helper">' + candidate + '</div>';
				htmlStr += '<div class="project-name-helper">' + project + '</div>';
				htmlStr += '</div>';

				return $(htmlStr);
			}
			initDraggableTask()
			
		},

		destroy: function() {			
			this.element.next().remove();
			
			$(window).unbind("quickdrop");
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