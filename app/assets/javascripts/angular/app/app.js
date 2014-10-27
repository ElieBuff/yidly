var yidlyModule = angular.module('yidlyApp', ['ngRoute', 'ngResource', 
					'ui.bootstrap', 'ngDragDrop', 'shoppinpal.mobile-menu'])
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
	.when('/projectDashboard/:projectId', {
		controller: 'ProjectDashboardCtrl',
		templateUrl: '/templates/projectDashboard.html'
	})
	.otherwise({redirectTo: '/'});
}]);