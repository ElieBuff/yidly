yidlyModule
.directive('upsertRecord', ['Record', '$modal', function(Record, $modal){
	return {
		restrict: 'A',
		scope:{
			stageId:'=',
			reloadItems: '&'
		},
		link: function(scope, element, attrs) {
			element.bind('click', function(){
				var $modalInstance = $modal.open({
					resolve: {
	        			stageId: function () {
	          				return scope.stageId;
	        			}
	        		}, 
					controller: function($scope, $modalInstance, stageId){
						$scope.record = new Record();
						$scope.record.stage_id = stageId;

						$scope.saveRecord = function(){
							$scope.record.$save({
								customFunction:'my_create'
							});
							scope.reloadItems();
							$modalInstance.close();
						}

						$scope.cancelRecord = function(){
							$modalInstance.close();
						}

					},
					templateUrl: '/templates/directives/addRecord.html',
				});
			})
        }
	};
}]);