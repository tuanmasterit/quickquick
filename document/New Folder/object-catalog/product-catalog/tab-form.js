Ext.onReady(function(){
	Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	
    var comboProducer = new Ext.form.ComboBox({
        typeAhead: true,
        store: '',
        valueField: 'producer_id',
        displayField: 'producer_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select detail producer',
        fieldLabel: 'Producer',
        editable: false,
        width: 290,
        minListWidth: 100,
        id: 'comboProducer',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
    var comboUnitBasic = new Ext.form.ComboBox({
        typeAhead: true,
        store: '',
        valueField: 'unit_id',
        displayField: 'unit_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select detail unit basic',
        fieldLabel: 'Unit basic',
        editable: false,
        width: 290,
        minListWidth: 100,
        id: 'comboUnitBasic',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
    var comboUnitUsing = new Ext.form.ComboBox({
        typeAhead: true,
        store: '',
        valueField: 'unit_id',
        displayField: 'unit_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select detail using unit',
        fieldLabel: 'Unit using',
        editable: false,
        width: 290,
        minListWidth: 100,
        id: 'comboUnitUsing',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
	var storeUnitDetail = new Ext.data.Store({
        // the return will be XML, so lets set up a reader
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'unit_id',
			fields: ['unit_id']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getUnitDetail/1'
        }),
        autoLoad: true,
        sortInfo: {
            field: 'unit_id',
            direction: 'ASC'
        }
    });
	
	var UnitDetail = {
    
        add: function(){
        },
        
        remove: function(){
        }
    };
	
    var cmUd = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [{
            header: 'Detail Name',
            dataIndex: '',
            width: 200,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }]
    });
    
	cmUd.defaultSortable = true;
	 
    var tbarUd = new Ext.Toolbar({
        items: [{
            text: 'Add',
            tooltip: {
                text: 'Add SubCategory to selected category',
                title: 'Add Category'
            },
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: UnitDetail.add
        }, {
            text: 'Delete',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: UnitDetail.remove
        }]
    });
    
    var bbarUd = new Ext.PagingToolbar({
        store: storeUnitDetail, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size
    });
    
    var gridDetailUnit = new Ext.grid.EditorGridPanel({
		store: storeUnitDetail,
        cm: cmUd,
        stripeRows: true,
        width: 455,
        height: 340,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        title: '',
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        tbar: tbarUd,
        bbar: bbarUd,
        stateful: true,
        stateId: 'grid_detail_unit',
		id: 'grid_detail_unit'
    });
    
    productTabForm = new Ext.form.FieldSet({
        title: '',
        height: 580,
        width: 480,
        collapsed: false,
        hidden: false,
        layout: 'form',
        items: [{
            layout: 'form',
            labelWidth: 150,
			style: 'margin-top: 5px;',
            items: [{
                xtype: 'textfield',
                width: 290,
                height: 20,
                fieldLabel: 'Product Code',
                id: 'product_code',
                listeners: {
                    change: function(e){
                        // action change
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
                id: 'product_name',
                fieldLabel: 'Product Name',
                labelWidth: 200,
                listeners: {
                    change: function(e){
                        // action change
                    }
                }
            }]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [comboProducer]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 290,
                height: 20,
                id: 'product_model',
                fieldLabel: 'Product Model',
                listeners: {
                    change: function(e){
                        // action change
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
                id: 'product_picture',
                fieldLabel: 'Product Image',
                listeners: {
                    change: function(e){
                        // action change
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
                id: 'product_description',
                fieldLabel: 'Product Description',
                listeners: {
                    change: function(e){
                        // action change
                    }
                }
            }]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [comboUnitBasic]
        }, {
			layout: 'form',
            labelWidth: 150,
            items: [comboUnitUsing]
		}, {
			layout: 'form',
            labelWidth: 150,
            items: [gridDetailUnit]
		}]
    });
    
});
