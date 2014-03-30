yidlyModule
.controller('HomeCtrl', ['$scope', function($scope) {
	
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
	
}]);