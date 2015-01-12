yidlyModule
.directive('taskCard', [function(){
	return {
		restrict: 'E',
		scope:{
			task: '='
		},
		templateUrl: '/templates/directives/taskCard.html',
		
		link: function(scope, element, attrs) {
			scope.className = 'today_task';
			
			var taskDate = moment(scope.task.actionable_at);
			var dayDiff = moment().diff(taskDate, 'days');

			if(dayDiff > 0)
				scope.className = 'emergency_task';
			else if(dayDiff < 0)
				scope.className = 'futur_task';
		}
	};
}]);