angular.module('yidlyApp')
.directive('rescheduleItem', ['$modal', 
							function($modal){
	
	var ModalInstanceCtrl = ['$scope', '$modalInstance', 'item', 'Record',
                            function($scope, $modalInstance, item, Record) {
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
				customFunction: 'reschedule_in_sec', 
				id: item.id,
				delay: fromNowInSec()
			});
		 	$modalInstance.close();
		}
    }];
 
	return {
		restrict: 'A',
		scope: {
			rescheduleItem : '='
		},
		link: function(scope, element, attrs) {
			element.bind('click', function(){
				var modalInstance = $modal.open({ 
                    templateUrl: 'templates/modal/rescheduleItem.html',     
                    controller: ModalInstanceCtrl,
                    resolve: {
                        item: function () {
                            return scope.rescheduleItem;
                        }
                    }
                });
 
                modalInstance.result.then(function(closeData){
                    
                });
			});
        }
	};
}]);