yidlyModule
.directive('tasksCaroussel', ['$filter', 'Record', function($filter, Record){
	return {
		restrict: 'E',
		scope:{
			tasks: '=',
			reload: '&'
		},
		templateUrl: '/templates/directives/tasksCaroussel.html',
		
		link: function(scope, element, attrs) {
			scope.groupTasks = $filter('partitions')(scope.tasks, 3);

			scope.itemMouseOver = function(hoverId){
				scope.selectedId = hoverId;
			}

			scope.itemMouseLeave = function(){
				scope.selectedId = '';
			}

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