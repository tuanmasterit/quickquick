Ext.onReady(function(){
	
	var columns = [];
	var sm = new Ext.grid.CheckboxSelectionModel();
	columns.push(sm);
	columns.push({
		header: 'Code'.translator(),
		dataIndex: 'code',
		width: 40,
        menuDisabled: true
	}, {
		header: 'Name'.translator(),
        dataIndex: 'name',
        menuDisabled: true,
        editor: new Ext.form.TextField({
            allowBlank: false,
            maxLength: 128
        })
	}, {
		header: 'Address'.translator(),
        dataIndex: 'address',
        menuDisabled: true,
        editor: new Ext.form.TextField({
            allowBlank: false,
            maxLength: 250
        })
	});
	var cm = new Ext.grid.ColumnModel(columns);
	cm.defaultSortable = true;
	
    var grid = new Ext.grid.EditorGridPanel({
		cm: cm,
        sm: sm,
        id: 'grid',
        enableColumnMove: false,
        height: 550,
        renderTo: 'test-grid',
        clicksToEdit: 1,
		viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'.translator()
        }
	})
	
	Ext.getCmp('grid').store.load();
});
