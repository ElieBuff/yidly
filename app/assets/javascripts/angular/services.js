yidlyModule
.factory('Project', ['$resource', function($resource) {
		return $resource('/projects/:id/:customFunction.json', 
				{
					id: '@id',
					functionRoute: '@functionRoute'
				},{
					update: { method: 'PUT' }, 
					firstStage: {method:'GET'}
				}
	);
}])
.factory('Record', ['$resource', function($resource) {
		return $resource('/records/:id/:customFunction.json', 
			{
				id: '@id'
			}, {
				update: { method: 'PUT' }
			}
	);
}])
.factory('Task', ['$resource', function($resource) {
		return $resource('/tasks/:id/:customFunction.json', 
			{
				id: '@id'
			}
	);
}])
.factory('ProjectManager', ['$resource', 'Project', function($resource, Project) {
	var projects = {items:[]}; 
	var isNewRec = true; 
	return{
		data: projects,
		getAll: function(){
			if(projects.items.length === 0)
				projects.items = Project.query();
			return projects;
		},
		reloadAll:function(){
			projects.items = [];
			this.getAll();
		},
		saveProject: function(project){
			var rootObj = this;
			if(!project.id)
				project.$save(function(data){
					rootObj.reloadAll();
				});
			else
				project.$update(function(data){
					rootObj.reloadAll();
				});
		},
		deleteProject: function(project){
			var rootObj = this;
			var index = projects.items.indexOf(project);
			project.$delete(function(data){
				rootObj.reloadAll();
			});
		}
	};
}])
.factory('RecordManager', ['$resource', 'Record', function($resource, Record) {
	var records = {items:[]}; 
	var isNewRec = true; 
	return{
		data: records,
		getAll: function(){
			if(records.items.length === 0)
				records.items = Record.query();
			return records;
		},
		reloadAll:function(){
			records.items = [];
			this.getAll();
		},
		saveRecord: function(record, stageId){
			var rootObj = this;
			if(!record.id){
				record.stage_id = stageId;
				record.$save(function(data){
					rootObj.reloadAll();
				});
			}
			else
				record.$update(function(data){
					rootObj.reloadAll();
				});
		},
		deleteRecord: function(record){
			var rootObj = this;
			var index = records.items.indexOf(record);
			record.$delete(function(data){
				rootObj.reloadAll();
			});
		}
	};
}]);