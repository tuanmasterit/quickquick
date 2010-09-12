Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    function render_unit_name_product(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeUnit.queryBy(function(rec){
                return rec.data.unit_id == val;
            }).itemAt(0).data.unit_name;
        } 
        catch (e) {
        }
    }
    
    var storeUnitOptionProduct = new Ext.data.ArrayStore({
        fields: [{
            name: 'unit_id'
        }, {
            name: 'unit_name'
        }, {
            name: 'default_purchase_price'
        }]    
    });
    
    var comboUnitOptionProduct = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeUnitOptionProduct,
        valueField: 'unit_id',
        displayField: 'unit_name',
		tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:100px;">{unit_name}</div><div style="float:left; text-align:left;">|</div><div>{default_purchase_price}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
		listWidth: 200
    });
    
    var Product = {
        find: function(){
            gridProduct.getStore().load();
        }
    };
    
    var recordProduct = [{
        name: 'product_id',
        type: 'string'
    }, {
        name: 'product_code',
        type: 'string'
    }, {
        name: 'product_name',
        type: 'string'
    }, {
        name: 'subject_name',
        type: 'string'
    }, {
        name: 'product_model',
        type: 'string'
    }, {
        name: 'product_description',
        type: 'string'
    }, {
        name: 'arr_unit_id',
        type: 'array'
    }, {
        name: 'regular_unit_id',
        type: 'string'
    }];
    
    var product_object = Ext.data.Record.create(recordProduct);
    
    var storeProduct = new Ext.data.Store({
        id: 'storeProduct',
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'product_id'
        }, product_object),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListProduct/1'
        }),
        autoLoad: false
    });
    
    var tbarProduct = new Ext.Toolbar({
        items: [{
            xtype: 'label',
            text: 'Product Code'.translator('buy-billing'),
            style: 'padding-left: 5px;padding-right: 2px;'
        }, {
            xtype: 'textfield',
            width: 100,
            id: 'product_code',
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        Product.find();
                    }
                }
            }
        }, '-', {
            xtype: 'label',
            text: 'Product Name'.translator('buy-billing'),
            style: 'padding-left: 5px;padding-right: 2px;'
        }, {
            xtype: 'textfield',
            id: 'product_name',
            width: 150,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        Product.find();
                    }
                }
            }
        }, {
            xtype: 'tbbutton',
            text: 'Find'.translator('buy-billing'),
            tooltip: 'Find Product Name',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            handler: Product.find
        }]
    });
    
    var cmbPerPageProduct = new Ext.form.ComboBox({
        name: 'cmbPerPageProduct',
        width: 80,
        store: new Ext.data.SimpleStore({
            data: [[100, '100'], [150, '150'], [200, '200'], [250, '250'], [300, '300'], [500, '500'], [0, 'All']],
            id: 0,
            fields: ['id', 'value']
        }),
        mode: 'local',
        value: '100',
        listWidth: 80,
        triggerAction: 'all',
        displayField: 'value',
        valueField: 'value',
        editable: false,
        forceSelection: true
    });
    
    cmbPerPageProduct.on('select', function(combo, record){
        bbarProduct.pageSize = parseInt(record.get('id'), 10);
        bbarProduct.doLoad(bbarProduct.cursor);
    }, this);
    
    var bbarProduct = new Ext.PagingToolbar({
        store: storeProduct, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size_product,
        items: ['-', 'Per Page'.translator('buy-billing'), cmbPerPageProduct]
    });
    
    var cmProduct = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Product Code'.translator('buy-billing'),
            dataIndex: 'product_code',
            width: 80
        }, {
            header: 'Product Name'.translator('buy-billing'),
            dataIndex: 'product_name',
            width: 130
        }, {
            header: 'Unit'.translator('buy-billing'),
            width: 80,
            dataIndex: 'regular_unit_id',
            id: 'unit_id',
            renderer: render_unit_name_product,
            editor: comboUnitOptionProduct
        }, {
            header: 'Producer Name'.translator('buy-billing'),
            dataIndex: 'subject_name',
            width: 150
        }, {
            header: 'Product Model'.translator('buy-billing'),
            dataIndex: 'product_model',
            width: 100
        }]
    });
    // by default columns are sortable
    cmProduct.defaultSortable = true;
    
    // create the Grid
    gridProduct = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeProduct,
        cm: cmProduct,
        stripeRows: true,
        height: 500,
        width: 475,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
		border: false,
        ddGroup: 'firstGridDDGroup',
        enableDragDrop: true,
        viewConfig: {
            emptyText: 'No record found'
        },
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        clicksToEdit: 1,
        tbar: tbarProduct,
        bbar: bbarProduct,
        stateful: true,
        stateId: 'gridProduct',
        id: 'gridProduct',
        listeners: {
            afteredit: function(e){				
                e.record.commit();
            },
            cellclick: function(gridSpec, rowIndex, columnIndex, e){
                if (gridProduct.getColumnModel().getColumnId(columnIndex) == 'unit_id') {
                    comboUnitOptionProduct.store.removeAll();
                    var arrUnit = gridProduct.getStore().getAt(rowIndex).data.arr_unit_id;
                    var i;
                    for (i = 0; i < arrUnit.length; i++) {
                        var recordUnit = new Array();
                        recordUnit['unit_id'] = arrUnit[i]['unit_id'];
                        recordUnit['unit_name'] = arrUnit[i]['unit_name'];
						recordUnit['default_purchase_price'] = arrUnit[i]['default_purchase_price'];
                        var rec = new Ext.data.Record(recordUnit);
                        comboUnitOptionProduct.store.add(rec);
                    }
                }
            }
        }
    });
    
    productPanel = new Ext.Panel({
        frame: true,
        title: '',
        renderTo: 'frm-product',
        items: [gridProduct]
    });
    
    storeProduct.on('beforeload', function(){
        var ProductName = gridProduct.topToolbar.items.get('product_name').getValue();
        if (ProductName != '') {
            storeProduct.baseParams.productName = ProductName;
        }
        else {
            storeProduct.baseParams.productName = '';
        }
        var ProductCode = gridProduct.topToolbar.items.get('product_code').getValue();
        if (ProductCode != '') {
            storeProduct.baseParams.productCode = ProductCode;
        }
        else {
            storeProduct.baseParams.productCode = '';
        }
        storeProduct.baseParams.start = 0;
        storeProduct.baseParams.limit = page_size_product;
    });
});
