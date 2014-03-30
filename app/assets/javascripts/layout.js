$(document).ready(function(){
	eventHandler();
});

var eventHandler = function(){
	$(window).bind('scroll', function () {
	    var headerTop = $('#headerTop').height();
	    
	    if ($(window).scrollTop() > headerTop) {
	        $('#navbar').addClass('navbar-fixed-top');
	    } else {
	        $('#navbar').removeClass('navbar-fixed-top');
	    }
	});
}