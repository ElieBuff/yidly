angular.module('yidlyApp')
.controller('HomeCtrl', ['$scope', 'Task', 'Record', '$modal', '$filter',
			function($scope, Task, Record, $modal, $filter) {
	$scope.tasks = [];
	$scope.checkModel = 'thumb';

	reloadTasks();
	

	

	

	$scope.rescheduleItem = function(){
		var modalInstance = $modal.open({
	      templateUrl: 'templates/modal/rescheduleItem.html',
	      controller: 'ModalInstanceCtrl',
	      resolve: {
	        selectedId: function () {
	          return $scope.selectedId;
	        } 
	      }
	    });

	    modalInstance.result.then(function(){
	    	reloadTasks();
	    });
	}

	$scope.isEmptySection = function(section){
		return $scope.taskLoaded && Object.keys(section).length == 0;
	}

	function reloadTasks(){
		$scope.tasks = Task.query();

		/*Task.get({
    		customFunction:'urgent_and_today', 
    		tipping_point:moment().startOf('day')._d*1
    	}, function(result){
    		$scope.tasks[0] = {title: 'Emergency Tasks', records:result.urgent};
    		$scope.tasks[1] = {title: 'Today Tasks', records:result.today};
    		$scope.tasks[2] = {title: 'Futur Tasks', records:result.later};
    	});*/
	}

	
}])
.controller('ModalInstanceCtrl', ['$scope', 'Record', 'selectedId', 
						function($scope, Record, selectedId) {
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
			id:selectedId,
			delay: fromNowInSec()
		});
		 $modalInstance.close();
	}
}])