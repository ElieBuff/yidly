angular.module('yidlyApp')
.directive('projectManagement', ['$modal', 'Project', 
							function($modal, Project){
	
	var ModalInstanceCtrl = ['$scope', '$modalInstance', 'project', 'ProjectManager',
                            function($scope, $modalInstance, project, ProjectManager) {
        $scope.project = project;
       	
        $scope.save = function() {
			ProjectManager.saveProject($scope.project);
			$modalInstance.close();
  		};

       	$scope.cancel = function () {
    		$modalInstance.dismiss('cancel');
  		};
    }];
 
	return {
		restrict: 'A',
		scope: {
			project : '='
		},
		link: function(scope, element, attrs) {
			element.bind('click', function(){
				
				var project;

				if(scope.project)
					project = angular.copy(scope.project);
				else
					project = new Project();

				var modalInstance = $modal.open({ 
                    windowClass:'prodManagement',
                    templateUrl: '/templates/modal/projectManagement.html',     
                    controller: ModalInstanceCtrl,
                    resolve: {
                        project: function () {
                            return project;
                        }
                    }
                });
 
                modalInstance.result.then(function(closeData){
                    
                });
			});
        }
	};
}]);