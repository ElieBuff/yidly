angular.module('yidlyApp')
.directive('recordManagement', ['$modal', 'Record', 
							function($modal, Record){
	
	var ModalInstanceCtrl = ['$scope', '$modalInstance', 'record', 'stageId', 'RecordManager',
                            function($scope, $modalInstance, record, stageId, RecordManager) {
        
        $scope.record = record;
       	if(!record.id)
       		$scope.isNewProj = true;
       	
       	$scope.save = function() {
			RecordManager.saveRecord($scope.record, stageId);
			$modalInstance.close();
		};

		$scope.cancel = function () {
    		$modalInstance.dismiss('cancel');
  		};
    }];
 
	return {
		restrict: 'A',
		scope: {
			record : '=',
			stageId: '='
		},
		link: function(scope, element, attrs) {
			element.bind('click', function(){
				
				var record;
				if(scope.record)
					record = angular.copy(scope.record);
				else
					record = new Record();
				
				var modalInstance = $modal.open({ 
                    windowClass:'prodManagement',
                    templateUrl: '/templates/directives/recordManagement.html',     
                    controller: ModalInstanceCtrl,
                    resolve: {
                        record: function () {
                            return record;
                        },
                        stageId: function () {
                            return scope.stageId;
                        }
                    }
                });
 
                modalInstance.result.then(function(closeData){
                    
                });
			});
        }
	};
}]);