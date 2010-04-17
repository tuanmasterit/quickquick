Ext.onReady(function(){
	
	var record = [
        {name: 'code', type: 'string'},
        {name: 'name', type: 'string'},
        {name: 'address', type: 'string'}
    ];
	
    var test_object = Ext.data.Record.create(record);
	
	var columns = [];
	var sm = new Ext.grid.CheckboxSelectionModel();
	columns.push(sm);
	columns.push({
		header: 'Code'.translator(),
		dataIndex: 'code',
		width: 40,
        menuDisabled: true
	}, {
		header: 'Language'.translator(),
        dataIndex: 'language',
        menuDisabled: true,
        editor: new Ext.form.TextField({
            allowBlank: false,
            maxLength: 128
        })
	}, {
		header: 'Locale'.translator(),
        dataIndex: 'locale',
        menuDisabled: true,
        editor: new Ext.form.TextField({
            allowBlank: false,
            maxLength: 250
        })
	});
	var cm = new Ext.grid.ColumnModel(columns);
	cm.defaultSortable = true;
	
	var ds = new Ext.data.Store({
		reader: new Ext.data.JsonReader({
            root : 'data',
            totalProperty: 'count',
            id: 'code',
			fields: ['code', 'language', 'locale']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + 'test/list'
        }),
        autoLoad: true,
        remoteSort: true
    });
	
    var grid = new Ext.grid.EditorGridPanel({
		cm: cm,
        sm: sm,
        id: 'grid1',
		title: 'test',
        enableColumnMove: false,
        height: 300,
		width: 200,
        renderTo: 'test-grid1',
		store: ds,
        clicksToEdit: 1,
		loadMask: true,
        trackMouseOver: true,
        frame: true,
	});
	
	Ext.getCmp('grid1').store.load();
	
	Ext.QuickTips.init();
});
