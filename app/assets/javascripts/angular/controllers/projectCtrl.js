angular.module('yidlyApp')
.controller('ProjectCtrl', ['$scope', '$location','Project', 'ProjectManager', 
							function($scope, $location, Project, ProjectManager) {
	$scope.projects = ProjectManager.getAll();
	
  	$scope.deleteProject = function(proj) {
		ProjectManager.deleteProject(proj);
	};

	$scope.goToRecords = function(proj) {
		$location.path("records/" + proj.id)
	};
}])