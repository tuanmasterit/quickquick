Ext.onReady(function(){
	
	var record = [
		{name: 'resource_id', type: 'string'},
		{name: 'title_key', type: 'string'},
	 	{name: 'package', type: 'string'}        
    ];
	for (var langId in Roles.roleValue) {
		record.push({
			name: Roles.roleValue[langId].role_name, type: 'string'
		});		
    }
	
    var test_object = Ext.data.Record.create(record);
	
	var ds = new Ext.data.GroupingStore({
		reader: new Ext.data.JsonReader({
            root : 'data',
            totalProperty: 'count',
            id: 'code'
        }, test_object),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + 'test/test-get-resources'
        }),
		sortInfo:{field: 'package', direction: "ASC"},
		groupField:'package'
    });
	
	var columns = [];
	columns.push({
		header: 'Function',
		dataIndex: 'title_key',
		width: 500,
		sortable: true
	});
	
	for (var langId in Roles.roleValue) {
        columns.push({
            header: Roles.roleValue[langId].role_name,
            dataIndex: Roles.roleValue[langId].role_name,
            width: 200
        });
    }
	
	columns.push({
		header: 'Package',
        dataIndex: 'package',
		sortable: true,
		width: 250
	});
	
	var cm = new Ext.grid.ColumnModel(columns);
	cm.defaultSortable = true;
	
	var grid = new Ext.grid.EditorGridPanel({
		cm: cm,
        id: 'grid',
		title: 'test',
        autoHeight: true,
		width: 800,
        renderTo: 'test-grid',
		store: ds,
        clicksToEdit: 1,
		loadMask: true,
        trackMouseOver: true,		
		view: new Ext.grid.GroupingView({
            forceFit:true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
        }),
        frame:true,
        collapsible: true,
        animCollapse: false,
		sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
	});
	
	Ext.getCmp('grid').store.load();
	
	Ext.QuickTips.init();
});