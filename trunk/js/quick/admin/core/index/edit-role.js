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
            this.gridEditRole = grid;
            this.gridEditRole.on('render', function(){
                var view = this.gridEditRole.getView();
                view.mainBody.on('mousedown', this.onMouseDown, this);
            }, this);
        },
        
        onMouseDown: function(e, t){
            if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
                e.stopEvent();
                var index = this.gridEditRole.getView().findRowIndex(t);
                var record = this.gridEditRole.store.getAt(index);
                //alert(record.data.resource_id);
                if(!record.data.resource_id) {
	            	Ext.Msg.alert('Error', 'Please input Resource before',Ext.MessageBox.ERROR);
					record.reject();
					return;
	            }
                record.set(this.dataIndex, !record.data[this.dataIndex]);

                Ext.Ajax.request({
                    url: Quick.baseUrl + Quick.adminUrl + 'test/edit-rule-resource/',
                    method: 'post',
                    success: function(result, options){
                        // display message
                        //reload()
                    },
                    failure: function(response, request){
                        var data = Ext.decode(response.responseText);
                        if (!data.success) {
                            alert(data.error);
                            return;
                        }
                    },
                    params: {
                        resourceId: Ext.encode(record.data.resource_id),
                        roleId: Ext.encode(record.id),
						field: Ext.encode(this.dataIndex),
                        value: Ext.encode(record.data[this.dataIndex] ? 1: 0)
                    }
                });
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
        name: 'is_view',
        type: 'bool'
    }, {
        name: 'is_list',
        type: 'bool'
    }, {
        name: 'is_print',
        type: 'bool'
    }, {
        name: 'role_name',
        type: 'string'
    }, {
        name: 'id',
        type: 'string'
    }];
    
    var test_object = Ext.data.Record.create(record);
    
    var dsRole = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'id'
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
    var is_view = new Ext.grid.CheckColumn({
        header: 'Is View',
        dataIndex: 'is_view',
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
    }, is_add, is_modify, is_change, is_delete, is_view, is_list, is_print);
    
    var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: columns
    });
    
    var tbar = new Ext.Toolbar({
        items: ['->', {
            text: 'Reload',
            handler: reloadGridRole,
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png'
        }]
    });
    var gridEditRole = new Ext.grid.EditorGridPanel({
        cm: cm,
        id: 'gridEditRole',
        //title: 'Authenticate',
        height: 300,
        width: 800,
        renderTo: 'gird-edit-role',
        store: dsRole,
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
        plugins: [is_add, is_modify, is_change, is_delete, is_view, is_print, is_list],
        tbar: tbar
    });
    
    //Ext.getCmp('grid1').store.load();
    dsRole.on('beforeload', function(){
    
        dsRole.baseParams.selectedFunction = Ext.getDom('selectedFunction').value;
    });
    
    Ext.QuickTips.init();
    
    // functions
    function reloadGridRole(){
        Ext.getCmp('gridEditRole').store.reload();
    }
    
});
