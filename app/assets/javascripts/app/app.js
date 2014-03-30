var yidlyModule = angular.module('yidlyApp', ['ngRoute', 'ngResource'])
yidlyModule.config(['$routeProvider',function($routeProvider) {
	$routeProvider
	.when('/', {
		controller: 'HomeCtrl',
		templateUrl: '/templates/dashboard.html'
	})
	.when('/projects', {
		controller: 'ProjectCtrl',
		templateUrl: '/templates/projects.html'
	})
	.when('/records/:projectId', {
		controller: 'RecordCtrl',
		templateUrl: '/templates/records.html'
	})
	.otherwise({redirectTo: '/'});
}]);