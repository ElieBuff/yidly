angular.module('yidlyApp')
.controller('HomeCtrl', ['$scope', 'Task', 'Record', '$modal', '$filter',
			function($scope, Task, Record, $modal, $filter) {
	$scope.taskLoaded = false;
	reloadTasks();
	

	$scope.moveNextStage = function() {
		Record.get({
			id:$scope.selectedId, 
			customFunction:'move_to_next_stage'
		}); 
		reloadTasks();
	};

	$scope.rejectItem = function() {
		Record.get({
			id:$scope.selectedId, 
			customFunction:'reject'
		}); 
		reloadTasks();
	};

	$scope.itemMouseOver = function(hoverId){
		$scope.selectedId = hoverId;
	}

	$scope.itemMouseLeave = function(){
		console.log('leave');
		$scope.selectedId = '';
	}

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
		Task.get({
    		customFunction:'urgent_and_today', 
    		tipping_point:moment().startOf('day')._d*1
    	}, function(result){
    		$scope.taskLoaded = true;
    		$scope.urgentTasks = $filter('partitions')(result.urgent, 3);
    		$scope.todayTasks = $filter('partitions')(result.today, 3);
    		$scope.futurTasks = $filter('partitions')(result.later, 3);
    	});
	}

	
}])
.controller('ModalInstanceCtrl', ['$scope', 'Record', 'selectedId', 
						function($scope, Record, selectedId) {
	$scope.rescheduleOptions=[
		{value:1, text:'In 1 Hour', src:''},
		{value:2, text:'In 3 Hours', src:''},
		{value:3, text:'Today 8:00 PM', src:''},
		{value:4, text:'Tomorrow 9:00 AM', src:''},
		{value:5, text:'In 1 day', src:''},
		{value:6, text:'In 1 Week', src:''}
	];

	$scope.rescheduleItem = function(delayType){alert(delayType);
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