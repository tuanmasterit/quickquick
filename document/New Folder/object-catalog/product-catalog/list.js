Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    
    var editProductWin;
    var IMAGE_WIDTH = 40;
    var IMAGE_HEIGHT = 50;
    var Product = {
    
        clearForm: function(){
            $('#producer_id').val('Select a producer');
            $('#base_unit_id').val('Select a unit basic');
            $('#regular_unit_id').val('Select a regular unit');
            $('#product_code').val('');
            $('#product_code').val('');
            $('#product_name').val('');
            $('#product_model').val('');
            $('#product_picture').val('');
            $('#product_description').val('');
        },
        
        add: function(){
            Product.clearForm();
            
            var productNewRecord = new product_object();
            gridProduct.getStore().insert(gridProduct.getStore().getCount(), productNewRecord);
            gridProduct.startEditing(gridProduct.getStore().getCount() - 1, 0);
            gridProduct.topToolbar.items.get('add_product').disable();
        },
        
        remove: function(){
        },
        
        find: function(){
            if (gridProduct.topToolbar.items.get('SearchProductName').getValue() == null || gridProduct.topToolbar.items.get('SearchProductName').getValue() == '') {
                Ext.Msg.alert('Warning', 'Please enter Product Name');
                return;
            }
            Ext.getCmp('grid_roduct').getStore().reload();
        },
        
        load: function(selectedProduct){
            Product.id = selectedProduct;
            
            Ext.Ajax.request({
                url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getProductById/' + Product.id,
                method: 'get',
                success: function(result, options){
                
                    var result = Ext.decode(result.responseText);
                    $('#div-form-product').css('display', 'block');
                    $('#selectedProduct').val(Product.id);
                    
                    Ext.getCmp('product_code').setValue(result.data.product_code);
                    Ext.getCmp('product_name').setValue(result.data.product_name);
                    Ext.getCmp('product_model').setValue(result.data.product_model);
                    Ext.getCmp('product_description').setValue(result.data.product_description);
                    Ext.getCmp('producer_id').setValue(result.data.producer_id);
                    Ext.getCmp('regular_unit_id').setValue(result.data.regular_unit_id);
                    Ext.getCmp('base_unit_id').setValue(result.data.base_unit_id);
					Ext.getCmp('grid_detail_unit').getStore().reload();
                    					
					if(result.data.product_picture == null || result.data.product_picture == '')
                    	$('#pic_product').attr('src', Quick.uploadProduct + 'thumbnail/noimage.jpg');
					else
						$('#pic_product').attr('src', Quick.uploadProduct + 'thumbnail/' + result.data.product_picture);
                    editProductWin.setTitle('Edit Product');
                    editProductWin.show();
                    editProductWin.doLayout();
                },
                failure: function(response, request){
                    var data = Ext.decode(response.responseText);
                    if (!data.success) {
                        alert(data.error);
                        return;
                    }
                }
            });
            //Ext.getCmp('gridEditRole').store.load();                       
        },
        
        edit: function(selectedProduct){
            Product.clearForm();
            Product.load(selectedProduct);
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
        name: 'producer_id',
        type: 'string'
    }, {
        name: 'subject_name',
        type: 'string'
    }, {
        name: 'product_model',
        type: 'string'
    }, {
        name: 'product_picture',
        type: 'string'
    }, {
        name: 'product_description',
        type: 'string'
    }, {
        name: 'product_base_unit',
        type: 'string'
    }, {
        name: 'product_regular_unit',
        type: 'string'
    }];
    
    var product_object = Ext.data.Record.create(recordProduct);
    
    var storeProducerListGird = new Ext.data.Store({
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
    
    storeProducerListGird.on('load', function(){
        storeProducerListGird.insert(0, new Ext.data.Record({
            subject_id: 0,
            subject_name: ''
        }));
        Ext.getCmp('grid_roduct').getStore().reload();
    });
    
    var comboProducerGird = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeProducerListGird,
        valueField: 'subject_id',
        displayField: 'subject_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
    function render_producer_name(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeProducerListGird.queryBy(function(rec){
                return rec.data.subject_id == val;
            }).itemAt(0).data.subject_name;
        } 
        catch (e) {
        }
    }
    
    function render_picture(val){
        return '<img src="' + Quick.uploadProduct + '/thumbnail/' + val + '" width="' + IMAGE_WIDTH + '" height="' + IMAGE_HEIGHT + '">';
    }
    
    function render_detail(val){
        return '<div class="extensive-detail" style="width: 16px; height: 16px;"></div>';
    }
    
    var storeProductList = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'product_id'
        }, product_object),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListProduct/1'
        }),
        autoLoad: false,
        remoteSort: true
    });
    
    var cmbPerPage = new Ext.form.ComboBox({
        name: 'perpage',
        width: 40,
        store: new Ext.data.SimpleStore({
            data: [[10, '10'], [15, '15'], [20, '20'], [25, '25'], [30, '30'], [50, '50'], [0, 'All']],
            id: 0,
            fields: ['id', 'value']
        }),
        mode: 'local',
        value: '20',
        listWidth: 40,
        triggerAction: 'all',
        displayField: 'value',
        valueField: 'value',
        editable: false,
        forceSelection: true
    });
    
    cmbPerPage.on('select', function(combo, record){
        bbar.pageSize = parseInt(record.get('id'), 10);
        bbar.doLoad(bbar.cursor);
    }, this);
    
    var tbar = new Ext.Toolbar({
        items: [{
            id: 'add_product',
            text: 'Add',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Product.add
        }, {
            text: 'Delete',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Product.remove
        }, '-', {
            xtype: 'tbtext',
            text: 'Product Name'
        }, {
            xtype: 'textfield',
            id: 'SearchProductName',
            width: 200,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        Product.find();
                    }
                }
            }
        }, {
            xtype: 'tbbutton',
            text: 'Find',
            tooltip: 'Find Product Name',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            id: 'find_product',
            handler: Product.find
        }]
    });
    
    var bbar = new Ext.PagingToolbar({
        store: storeProductList, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size,
        items: ['-', 'Per Page: ', cmbPerPage]
    });
    
    var cm2 = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [{
            id: 'detail_id',
            header: '',
            dataIndex: 'product_id',
            width: 30,
            renderer: render_detail
        }, {
            header: 'Product Code',
            dataIndex: 'product_code',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Product Name',
            dataIndex: 'product_name',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Producer Name',
            dataIndex: 'producer_id',
            width: 200,
            renderer: render_producer_name,
            editor: comboProducerGird
        }, {
            header: 'Product Model',
            dataIndex: 'product_model',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Product Picture',
            dataIndex: 'product_picture',
            width: 100,
            renderer: render_picture
        }, {
            header: 'Product Description',
            dataIndex: 'product_description',
            width: 250,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }]
    });
    // by default columns are sortable
    cm2.defaultSortable = true;
    
    gridProduct = new Ext.grid.EditorGridPanel({
        store: storeProductList,
        cm: cm2,
        stripeRows: true,
        width: 827,
        height: 630,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        title: '',
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        tbar: tbar,
        bbar: bbar,
        stateful: true,
        stateId: 'grid_roduct',
        id: 'grid_roduct',
        listeners: {
            cellclick: function(grid, rowIndex, columnIndex, e){
                if (grid.getColumnModel().getColumnId(columnIndex) == 'detail_id') {
                    Product.edit(grid.getStore().getAt(rowIndex).id);
                }
            },
            afteredit: function(e){
            
                if (!e.record.data.product_id && e.field != 'product_code') {
                    Ext.Msg.alert('Error', 'Please input Product Code before', Ext.Msg.ERROR);
                    e.record.reject();
                    gridProduct.startEditing(gridProduct.getStore().getCount() - 1, 0);
                    return;
                }
                
                Ext.Ajax.request({
                    url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateFieldProduct/1',
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (!e.record.data.product_id) 
                            gridProduct.topToolbar.items.get('add_product').enable();
                        
                        e.record.data.product_id = result.recordId;
                        gridProduct.getStore().getAt(e.row).id = result.recordId;
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
                        productId: Ext.encode(e.record.data.product_id),
                        field: Ext.encode(e.field),
                        value: Ext.encode(e.value)
                    }
                });
            }
        }
    
    });
    //gridProduct.on('rowclick', Product.edit);
    
    storeProductList.on('beforeload', function(){
        var ProductName = gridProduct.topToolbar.items.get('SearchProductName').getValue();
        
        if (ProductName != '') {
            storeProductList.baseParams.productName = ProductName;
        }
        else {
            storeProductList.baseParams.productName = '';
        }
        
        storeProductList.baseParams.start = 0;
        storeProductList.baseParams.limit = page_size;
        
        gridProduct.topToolbar.items.get('add_product').enable();
    });
    
    var tabsWraper = new Ext.Panel({
        region: 'center',
        collapsible: false,
        border: false,
        layout: 'fit',
        contentEl: 'div-form-product',
        autoScroll: true
    });
    
    /* Creating popup windows */
    editProductWin = new Ext.Window({
        items: [tabsWraper], //tabPanel, created in form-product.phtml
        layout: 'border',
        constrainHeader: true,
        height: 665,
        width: 865,
        closeAction: 'hide',
        maximizable: true,
        border: false,
        buttons: [{
            text: 'Close',
            handler: function(){
                editProductWin.hide();
            }
        }]
    });
    
    Ext.QuickTips.init();
});
