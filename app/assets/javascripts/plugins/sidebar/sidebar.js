(function( $ ){

  var methods = {
    init : function( options ) { 
      htmlStr = "";
      htmlStr += "<div class='sidebar'>";
      htmlStr += "<div class='sb-candidate-name'></div>";
      htmlStr += "<div class='sb-project-name'></div>";
      htmlStr += "</div>";
      $(this).parent().css("position","relative"); 
    	$(this).append(htmlStr);
    },
    showSidebar : function( options ) {
        var settings = $.extend( {
                          'candidateName' : 'No Candidate Name',
                          'projectName'   : 'No Project Name'
                        }, options);
        $('.sb-candidate-name').text(settings.candidateName);
        $('.sb-project-name').text(settings.projectName);
        $('.sidebar').animate({
          width: 200
          }, 1000, function() {
          // Animation complete.
        });
    },
    hideSidebar : function( ) {
        $('.sidebar').animate({
          width: 0
          }, 1000, function() {
          // Animation complete.
        });
    },
    update : function( content ) { 
      // !!! 
    }
  };

  $.fn.sideBar = function( method ) {
    
    // Method calling logic
    if ( methods[method] ) {
      return methods[ method ].apply( this, Array.prototype.slice.call( arguments, 1 ));
    } else if ( typeof method === 'object' || ! method ) {
    	return methods.init.apply( this, arguments );
    } else {
      $.error( 'Method ' +  method + ' does not exist on jQuery.sideBar' );
    }    
  
  };

})( jQuery );