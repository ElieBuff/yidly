yidlyModule
.controller('HomeCtrl', ['$scope', 'Task', 'Record', '$modal',
			function($scope, Task, Record, $modal) {
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
		$scope.selectedId = '';
	}

	$scope.itemShowItem = function(itemId){
		return $scope.selectedId == itemId;
	}

	$scope.rescheduleItemClick = function(itemId){
		var modalInstance = $modal.open({
	      templateUrl: 'myModalContent.html',
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

	function reloadTasks(){
		$scope.tasks = Task.get({
    		customFunction:'urgent_and_today', 
    		tipping_point:moment().startOf('day')._d*1
    	});
	}

	
}])
.controller('ProjectCtrl', ['$scope', '$location','Project', 'ProjectManager', 
							function($scope, $location, Project, ProjectManager) {
	$scope.projects = ProjectManager.getAll();
	
  	$scope.newProject = function() {
		$scope.project = new Project();
	};

	$scope.editProject = function(proj) {
		$scope.project = angular.copy(proj);
	};

	$scope.saveProject = function() {
		ProjectManager.saveProject($scope.project)
  	};

	$scope.deleteProject = function(proj) {
		ProjectManager.deleteProject(proj);
	};

	$scope.goToRecords = function(proj) {
		$location.path("records/" + proj.id)
	};
}])
.controller('RecordCtrl', ['$scope', '$routeParams', 'Record', 'Project', 'RecordManager',
						function($scope, $routeParams, Record, Project, RecordManager) {
	$scope.projectData = {};	
	$scope.projectData.project = Project.get({id:$routeParams.projectId});
	$scope.projectData.stage = Project.firstStage({id:$routeParams.projectId, customFunction:'first_stage'});
		
	$scope.projectData.records = RecordManager.getAll();

	$scope.newRecord = function() {
		$scope.record = new Record();
	};

	$scope.editRecord = function(rec) {
		$scope.record = angular.copy(rec);
	};

	$scope.saveRecord = function() {
		RecordManager.saveRecord($scope.record, $scope.projectData.stage.id)
	};

	$scope.deleteRecord = function(rec) {
		RecordManager.deleteRecord(rec);
	};
	
}])
.controller('ModalInstanceCtrl', ['$scope', 'Record', '$modalInstance', 'selectedId', 
						function($scope, Record, $modalInstance, selectedId) {
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
			id:selectedId,
			delay: fromNowInSec()
		});
		 $modalInstance.close();
	}
}]);

