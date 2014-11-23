yidlyModule
.directive('tasksList', ['$filter', 'Record', function($filter, Record){
	return {
		restrict: 'E',
		scope:{
			tasks: '=',
			reload: '&'
		},
		templateUrl: '/templates/directives/tasksList.html',
		
		link: function(scope, element, attrs) {
			scope.moveNextStage = function() {
				Record.get({
					id:scope.selectedId, 
					customFunction:'move_to_next_stage'
				}); 
				console.log(scope.reload);
				scope.reload();
			};

			scope.rejectItem = function() {
				Record.get({
					id:scope.selectedId, 
					customFunction:'reject'
				}); 
				scope.reload();  
			};
		}
	};
}]);