Ext.onReady(function(){
    
    var selectedDetail;
    
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
                
                if (!record.data.object_id) {
                    Ext.Msg.alert('Error', 'Please input Table before', Ext.MessageBox.ERROR);
                    record.reject();
                    return;
                }
                
                record.set(this.dataIndex, !record.data[this.dataIndex]);
                Ext.Ajax.request({
                    url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateDetailFor/1',
                    method: 'post',
                    success: function(result, options){
                        record.commit();
                    },
                    failure: function(response, request){
                        var data = Ext.decode(response.responseText);
                        if (!data.success) {
                            alert(data.error);
                            return;
                        }
                    },
                    params: {
						accountId: Ext.encode(selectedNodeid),
                        tableId: Ext.encode(selectedDetail),
                        detailId: Ext.encode(record.data.object_id),
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
    
    var recordDetailFor = [{
        name: 'table_id',
        type: 'string'
    }, {
        name: 'description',
        type: 'string'
    }];
    
    var detail_object = Ext.data.Record.create(recordDetailFor);
    
    var storeDetailFor = new Ext.data.Store({
        // the return will be XML, so lets set up a reader
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'table_id'
        }, detail_object),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getDetailFor/1'
        }),
        autoLoad: true,
        sortInfo: {
            field: 'table_id',
            direction: 'ASC'
        }
    });
    
    var storeDetail = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'object_id',
            fields: ['object_id', 'object_name', 'check_value']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getLoadDetail/1'
        }),
        autoLoad: false,
        remoteSort: true
    });
    
    var comboDetailFor = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeDetailFor,
        valueField: 'table_id',
        displayField: 'description',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select a detail',
        fieldLabel: 'Detail For Accountant',
        editable: false,
        width: 290,
        minListWidth: 100,
        id: 'comboDetailFor',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
            
                selectedDetail = record.data.table_id;
                
                storeDetail.load({
                    params: {
                        start: 0,
                        limit: page_size,
                        action: 'get'
                    }
                });
            }
        }
    });
    
    var checkDetail = new Ext.grid.CheckColumn({
        header: 'Checked',
        dataIndex: 'check_value',
        width: 100
    });
    
    var cm2 = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [{
            header: 'Name',
            dataIndex: 'object_name',
            width: 200,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, checkDetail]
    });
    // by default columns are sortable
    cm2.defaultSortable = true;
    
    var tbar = new Ext.Toolbar({
        items: [{
            text: 'Add',
            tooltip: {
                text: 'Add SubCategory to selected category',
                title: 'Add Category'
            },
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            //handler: Category.add
        }, {
            text: 'Delete',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            //handler: Category.remove
        }]
    });
    
    var bbar = new Ext.PagingToolbar({
        store: storeDetail, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size
    });
    
    var grid_detail = new Ext.grid.EditorGridPanel({
        id: 'grid_detail',
        title: '',
        store: storeDetail,
        cm: cm2,
        width: 500,
        height: 391,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        plugins: [checkDetail],
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        //tbar: tbar,
        bbar: bbar
    });
    
    AccountantForm = new Ext.form.FieldSet({
        title: '',
        height: 530,
        width: 508,
        collapsed: false,
        style: 'padding-top:0px; padding-left:0px; padding-right:0px; margin-top:0px; margin-bottom:0px; border-width: 0px;',
        hidden: false,
        layout: 'form',
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 290,
                height: 20,
                fieldLabel: 'Accountant Code',
                id: 'account_code',
                listeners: {
                    change: function(e){
                        //baseUpdateTelRateTableForm('TelephoneRateTableName', e.getValue());
                    }
                }
            }]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 290,
                height: 20,
                id: 'account_name',
                fieldLabel: 'Accountant Name',
                labelWidth: 200,
                listeners: {
                    change: function(e){
                        //baseUpdateTelRateTableForm('ServiceProvider', e.getValue());
                    }
                }
            }]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 290,
                height: 20,
                id: 'account_note',
                fieldLabel: 'Accountant Node',
                listeners: {
                    change: function(e){
                        //baseUpdateTelRateTableForm('Note', e.getValue());
                    }
                }
            }]
        
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [comboDetailFor]
        }, {
            layout: 'form',
            style: 'padding-top:9px;',
            items: [grid_detail]
        }]
    });
    
    storeDetail.on('beforeload', function(){
    
        storeDetail.baseParams.selectedDetailFor = selectedDetail;
        storeDetail.baseParams.selectedNode = selectedNodeid;
    });
    
    storeDetail.load({
        params: {
            start: 0,
            limit: page_size,
            action: 'get'
        }
    });
    
    Ext.QuickTips.init();
    
});

var loadDataAccountantForm = function(){

    Ext.Ajax.request({
        url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getDetailOfNode/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            $('#account_code').val(result.data['account_code']);
            $('#account_name').val(result.data['account_name']);
            $('#account_note').val(result.data['account_note']);
            
            AccountantForm.findById('grid_detail').getStore().load({
                params: {
                    start: 0,
                    limit: page_size,
                    action: 'get'
                }
            });
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            nodeId: Ext.encode(selectedNodeid)
        }
    });
}
