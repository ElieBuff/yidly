angular.module('yidlyApp')
.controller('RecordCtrl', ['$scope', '$routeParams', 'Record', 'Project', 'RecordManager',
						function($scope, $routeParams, Record, Project, RecordManager) {
	$scope.projectData = {};	
	$scope.projectData.project = Project.get({id:$routeParams.projectId});
	$scope.projectData.firstStage = Project.firstStage({id:$routeParams.projectId, customFunction:'first_stage'});
		
	$scope.projectData.records = RecordManager.getAll();

	$scope.newRecord = function() {
		$scope.record = new Record();
	};

	

	$scope.deleteRecord = function(rec) {
		RecordManager.deleteRecord(rec);
	};
	
}])