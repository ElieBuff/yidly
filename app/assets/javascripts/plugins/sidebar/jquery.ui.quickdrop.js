(function($) {
    $.widget("ui.quickdrop", {
		options: {
			containerName: ".quickdrop-records",
			className: "quickdrop_draggable",
			dragHelperCallback: "",
			actions : []
		},
		
		_create: function() {
			startDragabble = function(){
				$(this).addClass('draged');
				$('.quickdrop').slideDown(500);
			}
			stopDragabble = function(){
				$(this).removeClass('draged');
			}
			getQuickDropBar = function(){
				htmlStr = "";
      			htmlStr += "<div class='quickdrop " + o.className + "'>" + 
	      				   "<div class='actions'></div>" + 
      			           "</div>";
				return htmlStr;
			}
			
			var self = this, o = self.options; 
			$(o.containerName).parent().css("position","relative"); 
			$(o.containerName).append(getQuickDropBar());
    		this._refresh();
		},
		
		 _refresh: function() {
		 	initQuickDropActions = function (){
	 			getImageWidth = function () { return 100 / o.actions.length; }
	 			$(".actions").empty();
	 			
	 			$.each( o.actions, function( index, value ) {
	 				createActionDiv = function(){
		 				return $("<div class='action' style='width:" + getImageWidth() + "%'><img src='" + value.icon + "'/></div>");
		 			}
	 				var actionElem = createActionDiv();
	 				insertIcon = function (){
		 				if(value.icon)
	        			{
	          				$(".actions").append(actionElem);
	        			}
		      		}
		      		initIcon = function (){
				 		actionElem.droppable({
			      			hoverClass: "drop-hover",
			      			 drop: function( event, ui ) {
			      			 	ui.draggable.data('height', $('.quickdrop').height());
			      			 	ui.draggable.data('width', actionElem.width());
			      			 	ui.draggable.data('left', actionElem.position().left);
			      			 	value.callback(ui.draggable);
			      			 	if(value.closeOnDrop)
			      			 		$('.quickdrop').slideUp(500);
			      			 	else
			      			 		$(this).addClass("drop-hover");
							}
			      		});
			      	}
			      	insertIcon();
			      	initIcon();
			 	});
		 	}
		 	
		 	var self = this,
				   o = self.options; 
		 	initQuickDropActions();      		
    		this.reloadDraggable(o.dragHelperCallback);	
    	},

		reloadDraggable:function(dragHelperCallback){
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
						return dragHelperCallback($(this));
						},
					start: startDragabble, 
					stop: stopDragabble
				});	
			}
			initDraggableTask()
			
		},
		hideQuickBar:function(){
			$('.action').removeClass("drop-hover");
			$('.quickdrop').slideUp(500);
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