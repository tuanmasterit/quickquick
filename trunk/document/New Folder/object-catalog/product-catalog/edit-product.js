Ext.apply(Ext.util.Format, {
    numberFormat: {
        decimalSeparator: '.',
        decimalPrecision: 2,
        groupingSeparator: ',',
        groupingSize: 3,
        currencySymbol: ''
    },
    formatNumber: function(value, numberFormat){
        var format = Ext.apply(Ext.apply({}, Ext.util.Format.numberFormat), numberFormat);
        if (typeof value !== 'number') {
            value = String(value);
            if (format.currencySymbol) {
                value = value.replace(format.currencySymbol, '');
            }
            if (format.groupingSeparator) {
                value = value.replace(new RegExp(format.groupingSeparator, 'g'), '');
            }
            if (format.decimalSeparator !== '.') {
                value = value.replace(format.decimalSeparator, '.');
            }
            value = parseFloat(value);
        }
        var neg = value < 0;
        value = Math.abs(value).toFixed(format.decimalPrecision);
        var i = value.indexOf('.');
        if (i >= 0) {
            if (format.decimalSeparator !== '.') {
                value = value.slice(0, i) + format.decimalSeparator + value.slice(i + 1);
            }
        }
        else {
            i = value.length;
        }
        if (format.groupingSeparator) {
            while (i > format.groupingSize) {
                i -= format.groupingSize;
                value = value.slice(0, i) + format.groupingSeparator + value.slice(i);
            }
        }
        if (format.currencySymbol) {
            value = value + ' ' + format.currencySymbol;
        }
        if (neg) {
            value = '-' + value;
        }
        return value;
    }
});

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    
    var storeProducerList = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListSubject/is_producer'
        }),
        autoLoad: true
    });
    
    storeProducerList.on('load', function(){
        storeProducerList.insert(0, new Ext.data.Record({
            subject_id: 0,
            subject_name: ''
        }));
    });
    
    var comboProducer = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeProducerList,
        valueField: 'subject_id',
        displayField: 'subject_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select a producer',
        fieldLabel: 'Producer',
        editable: false,
        width: 352,
        minListWidth: 100,
        id: 'producer_id',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                baseUpdateProductForm(combo.id, record.id);
            }
        }
    });
    
    var storeUnit = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'unit_id',
            fields: ['unit_id', 'unit_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListUnit/1'
        }),
        autoLoad: true
    });
    
    storeUnit.on('load', function(){
        storeUnit.insert(0, new Ext.data.Record({
            unit_id: 0,
            unit_name: ''
        }));
    });
    
    var comboUnitBasic = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeUnit,
        valueField: 'unit_id',
        displayField: 'unit_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select a unit basic',
        fieldLabel: 'Basic Unit',
        editable: false,
        width: 352,
        minListWidth: 100,
        id: 'base_unit_id',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
            
            }
        }
    });
    
    var comboUnitUsing = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeUnit,
        valueField: 'unit_id',
        displayField: 'unit_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select a regular unit',
        fieldLabel: 'Regular Unit',
        editable: false,
        width: 352,
        minListWidth: 100,
        id: 'regular_unit_id',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
    function render_unit_name(val){
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
    
    var DetailUnitRecord = Ext.data.Record.create(['sku_number', 'unit_id', 'coefficient', 'default_sales_price', 'default_purchasing_price', 'default_inventory_price']);
    
    var storeUnitDetail = new Ext.data.Store({
        // the return will be XML, so lets set up a reader
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'unit_id'
        }, DetailUnitRecord),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getUnitDetail/1'
        }),
        autoLoad: false,
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
            header: 'Sku Number',
            dataIndex: 'sku_number',
            id: 'sku_number',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Unit Name',
            dataIndex: 'unit_id',
            id: 'unit_id',
            width: 150,
            renderer: render_unit_name
        }, {
            header: 'Coefficient',
            dataIndex: 'coefficient',
            id: 'coefficient',
            width: 75,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Default Sales Price',
            dataIndex: 'default_sales_price',
            id: 'default_sales_price',
            width: 100,
            editor: new Ext.form.NumberField({
                allowBlank: false
            }),
            renderer: 'formatNumber',
            align: 'right'
        }, {
            header: 'Default Purchasing Price',
            dataIndex: 'default_purchasing_price',
            id: 'default_purchasing_price',
            width: 130,
            editor: new Ext.form.NumberField({
                allowBlank: false
            }),
            renderer: 'formatNumber',
            align: 'right'
        }, {
            header: 'Default Inventory Price',
            dataIndex: 'default_inventory_price',
            id: 'default_inventory_price',
            width: 130,
            editor: new Ext.form.NumberField({
                allowBlank: false
            }),
            renderer: 'formatNumber',
            align: 'right'
        }]
    });
    
    cmUd.defaultSortable = true;
    
    var tbarUd = new Ext.Toolbar({
        items: [{
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
        width: 506,
        height: 171,
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
        id: 'grid_detail_unit',
        listeners: {
            afteredit: function(e){
                if ((e.record.data.unit_id == Ext.getCmp('base_unit_id').getValue()) && e.field == 'coefficient') {
                    e.record.reject();
                    gridDetailUnit.startEditing(gridDetailUnit.getStore().getCount() - 1, 0);
                    return;
                }
                
                if (e.value <= 0) {
                    if (e.field == 'coefficient') 
                        e.value = 1;
                    else 
                        e.value = 0;
                }
                
                Ext.Ajax.request({
                    url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateFieldUnitProduct/' + $('#selectedProduct').val(),
                    method: 'post',
                    success: function(result, options){
                        switch (e.field) {
                            case 'coefficient':
                                e.record.data.coefficient = e.value;
                                break;
                            case 'default_sales_price':
                                e.record.data.default_sales_price = e.value;
                                break;
                            case 'default_purchasing_price':
                                e.record.data.default_purchasing_price = e.value;
                                break;
                            case 'default_inventory_price':
                                e.record.data.default_inventory_price = e.value;
                                break;
                        }
                        e.record.commit();
                    },
                    failure: function(response, request){
                        e.record.reject();
                        var data = Ext.decode(response.responseText);
                        if (!data.success) {
                            alert(data.error);
                            return;
                        }
                    },
                    params: {
                        field: Ext.encode(e.field),
                        value: Ext.encode(e.value)
                    }
                });
            }
        }
    });
    
    var fl_basic_imag = new Ext.form.FieldSet({
        //height: Ext.isIE ? 115 : 125,
        bodyStyle: 'padding: 5px 5px 0px 5px;',
        width: 506,
        items: [{
            layout: 'column',
            items: [{
                xtype: 'box',
                id: 'photo',
                autoEl: {
                    id: 'photo_link',
                    tag: 'a',
                    rel: 'lightbox',
                    href: Quick.uploadProduct + "1.jpg",
                    html: '<img id="pic_product" src="' + Quick.uploadProduct + 'thumbnail/1.jpg">'
                }
            }, {
                xtype: 'button',
                value: 'Insert Image',
                text: 'Insert Image',
                style: 'margin: 10px;',
                id: 'upload_button',
                //disabled: (EmployeeID == 0 || read_only) ? true : false,
                handler: function(){
                    //upload_window.show();
                }
            }]
        }]
    });
    
    productTabForm = new Ext.form.FieldSet({
        title: '',
        height: 545,
        width: 580,
        collapsed: false,
        layout: 'form',
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [fl_basic_imag]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 352,
                height: 20,
                fieldLabel: 'Product Code',
                id: 'product_code',
                listeners: {
                    change: function(e){
                        baseUpdateProductForm(e.getId(), e.getValue());
                    }
                }
            }]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 352,
                height: 20,
                id: 'product_name',
                fieldLabel: 'Product Name',
                labelWidth: 200,
                listeners: {
                    change: function(e){
                        baseUpdateProductForm(e.getId(), e.getValue());
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
                width: 352,
                height: 20,
                id: 'product_model',
                fieldLabel: 'Product Model',
                listeners: {
                    change: function(e){
                        baseUpdateProductForm(e.getId(), e.getValue());
                    }
                }
            }]
        }, {
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textarea',
                width: 352,
                height: 60,
                id: 'product_description',
                fieldLabel: 'Product Description',
                listeners: {
                    change: function(e){
                        baseUpdateProductForm(e.getId(), e.getValue());
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
    
    factorForm = new Ext.form.FieldSet({
        title: '',
        height: 100,
        width: 295,
        collapsed: false,
        layout: 'form',
		labelWidth: 80,
		hidden: true,
		style: 'margin-left: 5px; border:0px;',
        items: [{
            xtype: 'textfield',
            width: 190,
            height: 20,
            fieldLabel: 'Factor Name',
            id: 'factor_name',
            listeners: {
                change: function(e){
                }
            }
        }]
    });
	
	propertyForm = new Ext.form.FieldSet({
        title: '',
        height: 100,
        width: 295,
        collapsed: false,
        layout: 'form',
		labelWidth: 90,
		style: 'margin-left: 5px; border:0px;',
        items: [{
            xtype: 'textfield',
            width: 180,
            height: 20,
            fieldLabel: 'Property Name',
            id: 'property_text',
            listeners: {
                change: function(e){
                }
            }
        }, {
            xtype: 'textfield',
            width: 180,
            height: 20,
            fieldLabel: 'Max Number',
            id: 'max_property_number',
            listeners: {
                change: function(e){
                }
            }
        }, {
            xtype: 'textfield',
            width: 180,
            height: 20,
            fieldLabel: 'Min Number',
            id: 'min_property_number',
            listeners: {
                change: function(e){
                }
            }
        }]
    });
	
	
    var EditProductTabs = new Ext.TabPanel({
        title: '',
        activeTab: 0,
        width: 540,
        height: 560,
        items: [{
            title: 'General',
            id: 'tabGeneral',
            items: [{
                layout: 'form',
                frame: true,
                defaults: {
                    border: false
                },
                items: [productTabForm]
            }]
        }, {
            title: 'Properties',
            id: 'tabProperties',
            items: [{
                layout: 'form',
                frame: true,
                defaults: {
                    border: false
                },
                items: []
            }]
        }]
    });
    var productEditForm = new Ext.FormPanel({
        frame: true,
        id: 'productEditForm',
        width: 853,
        height: 595,
        renderTo: 'frm-edit-product',
        iconCls: 'icon-form',
        items: [{
            layout: 'column',
            items: [{
                columnWidth: .5,
                layout: 'form',
                items: [EditProductTabs]
            }, {
                columnWidth: .4,
                layout: 'form',
                items: [treeProperty, factorForm, propertyForm]
            }]
        }]
    });
    
    storeUnitDetail.on('beforeload', function(){
    
        storeUnitDetail.baseParams.productId = $('#selectedProduct').val();
        storeUnitDetail.baseParams.start = 0;
        storeUnitDetail.baseParams.limit = page_size;
    });
});

var baseUpdateProductForm = function(field, value){

    Ext.Ajax.request({
        url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateFieldProduct/1',
        method: 'post',
        success: function(result, options){
            Ext.getCmp('grid_roduct').getStore().reload();
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            productId: Ext.encode($('#selectedProduct').val()),
            field: Ext.encode(field),
            value: Ext.encode(value)
        }
    });
}
