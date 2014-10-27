angular.module('yidlyApp')  
.filter('partitions', [function(){
    var part = function(arr, size) {
	    if(!arr)
	    	return ;
	    if(0 === arr.length) 
	    	return arr;
	    console.log(arr);
	    return [ arr.slice( 0, size ) ].concat( part( arr.slice( size ), size) );
	};
	return part;
}]);
