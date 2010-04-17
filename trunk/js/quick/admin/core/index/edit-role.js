Ext.onReady(function(){

    Ext.grid.CheckColumn = function(config){
        Ext.apply(this, config);
        if (!this.id) {
            this.id = Ext.id();
        }
        this.renderer = this.renderer.createDelegate(this);
    };
    
    Ext.grid.CheckColumn.prototype = {
        init: function(grid){
            this.grid = grid;
            this.grid.on('render', function(){
                var view = this.grid.getView();
                view.mainBody.on('mousedown', this.onMouseDown, this);
            }, this);
        },
        
        onMouseDown: function(e, t){
            if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
                e.stopEvent();
                var index = this.grid.getView().findRowIndex(t);
                var record = this.grid.store.getAt(index);
                //alert(record.data.resource_id);
                record.set(this.dataIndex, !record.data[this.dataIndex]);
            }
        },
        
        renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="approved-column x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
        }
    };
    
    var record = [{
        name: 'resource_id',
        type: 'string'
    }, {
        name: 'is_read',
        type: 'bool'
    }, {
        name: 'is_add',
        type: 'bool'
    }, {
        name: 'is_modify',
        type: 'bool'
    }, {
        name: 'is_change',
        type: 'bool'
    }, {
        name: 'is_delete',
        type: 'bool'
    }, {
        name: 'is_print',
        type: 'bool'
    }, {
        name: 'is_list',
        type: 'bool'
    }, {
        name: 'role_name',
        type: 'string'
    }];
    
    var test_object = Ext.data.Record.create(record);
    
    var ds = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'code'
        }, test_object),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + 'test/get-rules-of-resource'
        }),
        sortInfo: {
            field: 'role_name',
            direction: "ASC"
        },
        autoLoad: false,
        remoteSort: true
        //groupField:'role_name'
    });
    var is_read = new Ext.grid.CheckColumn({
        header: 'Is Read',
        dataIndex: 'is_read',
        autoWidth: true,
        align: 'center'
    });
	var is_add = new Ext.grid.CheckColumn({
        header: 'Is Add',
        dataIndex: 'is_add',
        autoWidth: true,
        align: 'center'
    });
	var is_modify = new Ext.grid.CheckColumn({
        header: 'Is Modify',
        dataIndex: 'is_modify',
        autoWidth: true,
        align: 'center'
    });
	var is_change = new Ext.grid.CheckColumn({
        header: 'Is Change',
        dataIndex: 'is_change',
        autoWidth: true,
        align: 'center'
    });
	var is_delete = new Ext.grid.CheckColumn({
        header: 'Is Delete',
        dataIndex: 'is_delete',
        autoWidth: true,
        align: 'center'
    });
	var is_print = new Ext.grid.CheckColumn({
        header: 'Is Print',
        dataIndex: 'is_print',
        autoWidth: true,
        align: 'center'
    });
	var is_list = new Ext.grid.CheckColumn({
        header: 'Is List',
        dataIndex: 'is_list',
        autoWidth: true,
        align: 'center'
    });
   
    var columns = [];
    columns.push({
        header: 'Role',
        dataIndex: 'role_name',
        autoWidth: true
    }, is_read, is_add, is_modify, is_change, is_delete, is_print, is_list);
    
    var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: columns
    });
    
    var tbar = new Ext.Toolbar({
        items: ['->', {
            text: 'Reload',
            handler: reload,
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png'
        }]
    });
    var grid = new Ext.grid.EditorGridPanel({
        cm: cm,
        id: 'grid1',
        //title: 'Authenticate',
        height: 300,
        width: 800,
        renderTo: 'gird-edit-role',
        store: ds,
        clicksToEdit: 1,
        loadMask: true,
        trackMouseOver: true,
        viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'
        },
        //frame: true,
        //collapsible: true,
        //animCollapse: false,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
		plugins: [is_read, is_add, is_modify, is_change, is_delete, is_print, is_list],
		tbar: tbar
    });
    
    //Ext.getCmp('grid1').store.load();
    ds.on('beforeload', function(){
        
        ds.baseParams.selectedFunction = Ext.getDom('selectedFunction').value;
    });
	
    Ext.QuickTips.init();
    
    // functions
    function reload(){
        Ext.getCmp('grid1').store.reload();
    }
    
});
