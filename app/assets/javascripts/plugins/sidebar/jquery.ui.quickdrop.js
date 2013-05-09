(function($) {

    $.widget("ui.quickdrop", {
		options: {
			quickdropContainer: ".quickdrop-records",
			quickdropClass: "quickdrop_draggable",
			actions : []
		},
		
		_create: function() {
			startDragabble = function(){

				$(this).addClass('draged');
				$('.quickdrop_draggable').slideDown(500);
			}
			stopDragabble = function(){
				alert(o.quickdropClass);
				$(this).removeClass('draged');
				$('.quickdrop_draggable').slideUp(500);
			}
			getQuickDropBar = function(options){
				htmlStr = "";
      			htmlStr += "<div class='quickdrop " + options.quickdropClass + "'>";
	      		htmlStr += "<div class='actions'></div>";
      			htmlStr += "</div>";
				return htmlStr;
			}
			invokeTaskAction = function (jqueryObj, ui){
				jqueryObj.data('callback').call(undefined, ui.draggable);
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

			var self = this, o = self.options; 
			$(o.quickdropContainer).parent().css("position","relative"); 
			$(o.quickdropContainer).append(getQuickDropBar(o));
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
		      	}
			 	insertIcons()
			 	initIcons()
		 	}
		 	

		 	var self = this,
				   o = self.options; 
		 	initQuickDropActions();      		
    		this.reloadDraggable();	
    		this.showQuickDrop();		
		},

		initDraggableEvent:function(){
		},

		reloadDraggable:function(){
			initDraggableTask = function(){
				$(".draggable").draggable({
					cursor: "move",
					helper: "clone",
					revert: "invalid",
					refreshPositions: true,
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
			initDraggableTask()
			
		},

		showQuickDrop:function(){
			$('.quickdrop_clickable').slideDown(500);
		},
		hideQuickDrop:function(){
			$('.quickdrop_clickable').slideUp(500);
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