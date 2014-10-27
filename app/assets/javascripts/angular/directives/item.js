yidlyModule
.directive('hello', ['Record', '$modal', function(Record, $modal){
	return {
		restrict: 'E',
		replace: true,
		transclude: true,
		scope:{
			id:'@',
			actionable:'@',
			name:'@',
			email:'@',
			reloadItems: '&'
		},
		templateUrl: '/templates/directives/record.html',
		replace: true,
		link: function(scope, element, attrs) {
			element.on('mouseenter', function() {
                element.addClass('hover');
            });
            element.on('mouseleave', function() {
                element.removeClass('hover');
            });


           	scope.moveNextStage = function(action){
				Record.get({
					id:scope.id, 
					customFunction:'move_to_next_stage'
				});
				scope.reloadItems();
			};

			scope.rejectItem = function() {
				Record.get({
					id:scope.id, 
					customFunction:'reject'
				});
				scope.reloadItems(); 
			};

			scope.rescheduleItem = function() {
				console.log('modal controller');
				var $modalInstance = $modal.open({
					resolve: {
	        			selectedId: function () {
	          				return scope.id;
	        			}
	        		}, 
					controller: function($scope, $modalInstance, selectedId){
						$scope.rescheduleOptions=[
							{value:1, text:'In 1 Hour', src:''},
							{value:2, text:'In 3 Hours', src:''},
							{value:3, text:'Today 8:00 PM', src:''},
							{value:4, text:'Tomorrow 9:00 AM', src:''},
							{value:5, text:'In 1 day', src:''},
							{value:6, text:'In 1 Week', src:''}
						];

						$scope.rescheduleItem = function(delayType){
							var fromNowInSec = function(){
								var futurDate;
								switch(delayType){
									case 1:
										futurDate = moment().add('hours', 1);
										break;
									case 2:
										futurDate = moment().add('hours', 3);
										break;
									case 3:
										futurDate = moment().endOf('day').add('hours', -4);
										break;
									case 4:
										futurDate = moment().add('days',1).startOf('day').add('hours', 9);
										break;
									case 5:
										futurDate = moment().add('days', 1);
										break;
									case 6:
										futurDate = moment().add('weeks', 1);
										break;
								}
								
								return (futurDate - moment()) / 1000
							}

							Record.get({
								customFunction:'reschedule_in_sec', 
								id: selectedId,
								delay: fromNowInSec()
							});
							scope.reloadItems();
							$modalInstance.close();
					}		
					},
					
					templateUrl: '/templates/modal/rescheduleItem.html',
					
				});
			
			};
        }
	};
}]);