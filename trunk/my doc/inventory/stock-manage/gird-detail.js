var storeUnit;

Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    storeUnit = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'unit_id',
            fields: ['unit_id', 'unit_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListUnit/1'
        }),
        autoLoad: false
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
    
    var storeUnitOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'unit_id'
        }, {
            name: 'unit_name'
        }]
    });
    
    var comboUnitOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeUnitOption,
        valueField: 'unit_id',
        displayField: 'unit_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true
    });
    
    var Detail = {
        remove: function(){
            var records = gridDetail.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm',
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Are delete products'.translator('buy-billing') + Ext.getCmp('inventory_voucher_number').getValue() + '\' ?',
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecord = new Array();
                            for (var i = 0; i < records.length; i++) {
                                var record = {
                                    product_id: records[i].data.product_id,
                                    unit_id: records[i].data.unit_id
                                };
                                arrRecord.push(record);
                            }
                            baseDeleteDetailInventory(gridDetail.getStore().baseParams.inventoryVoucherId, arrRecord, gridDetail.getStore().baseParams.voucherId);
                        }
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Not row to delete'.translator('buy-billing'));
            }
        }
    };
    
    storeDetail = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'detail_inventory_id',
            fields: ['inventory_voucher_id', 'detail_inventory_id', 'product_id', 'unit_id', 'product_unit_name', 'arr_unit_id', 'product_name', 'unit_id', 'quantity', 'price', 'amount', 'converted_amount', 'note', 'currency_id', 'currency_name', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDetailInventoryVoucher/1'
        }),
        autoLoad: false
    });
    
    comboAccounting = new Ext.form.ComboBox({
        id: 'comboAccounting',
        store: storeDetail,
        forceSelection: true,
        displayField: 'product_unit_name',
        valueField: 'detail_inventory_id',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        selectOnFocus: true,
        editable: true,
        width: 250,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
            }
        }
    });
    
    var bbarDetail = new Ext.PagingToolbar({
        store: storeDetail, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size
    });
    
    var cmDetail = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Product Name'.translator('stock-manage'),
            width: 250,
            dataIndex: 'product_name'
        }, {
            header: 'Unit'.translator('stock-manage'),
            width: 100,
            dataIndex: 'unit_id',
            id: 'unit_id',
            renderer: render_unit_name,
            editor: comboUnitOption
        }, {
            header: 'Qty'.translator('stock-manage'),
            width: 75,
            dataIndex: 'quantity',
            id: 'quantity',
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                    }
                }
            }),
            align: 'right'
        }, {
            header: 'Price'.translator('stock-manage'),
            width: 100,
			id: 'price',
            dataIndex: 'price',
            align: 'right',
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                    }
                }
            })
        }, {
            header: 'Amount'.translator('stock-manage'),
            width: 110,
            dataIndex: 'amount',
            align: 'right'
        }, {
            header: 'Converted Amount'.translator('stock-manage'),
            width: 110,
            dataIndex: 'converted_amount',
            align: 'right'
        }, {
            header: 'Note'.translator('stock-manage'),
            width: 290,
            dataIndex: 'note',
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }]
    });
    
    gridDetail = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeDetail,
        cm: cmDetail,
        stripeRows: true,
        height: 353,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        clicksToEdit: 1,
        ddGroup: 'secondGridDDGroup',
        ddText: 'Update detail of purchase invoice',
        enableDragDrop: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        bbar: [{
            text: 'Delete'.translator('stock-manage'),
            id: 'delete_detail_entry',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Detail.remove
        }, bbarDetail, '-', {
            xtype: 'button',
            width: 70,
            height: 20,
            text: 'Show list product'.translator('stock-manage'),
            id: 'btnProduct',
            handler: function(){
                if (!startLoadProduct) {
                    startLoadProduct = true;
                    gridProduct.getStore().load();
                }
                $('#div-form-product').css('display', 'block');
                showProductWin.setTitle('List Product'.translator('buy-billing'));
                showProductWin.show();
                showProductWin.doLayout();
            }
        }],
        stateful: true,
        stateId: 'gridDetail',
        id: 'gridDetail',
        listeners: {
            afteredit: function(e){
                if (e.record.id == -1) {
                    e.record.reject();
                    return;
                }
                if ((e.field == 'quantity') || (e.field == 'price')) {
                    if (parseFloat(e.value) < 0) {
                        e.record.reject();
                        msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                        return;
                    }
                    else 
                        e.value = formatNumber(e.value);
                }
                Ext.Ajax.request({
                    url: pathRequestUrl + '/updateDetailInventory/' + gridDetail.getStore().baseParams.inventoryVoucherId,
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (result.success) {
                            if ((e.field == 'price') || (e.field == 'quantity')) {
                                e.record.data.amount = result.data.amount;
                                e.record.data.converted_amount = result.data.converted_amount;
                                gridAccounting.getStore().removeAll();
                                gridAccounting.getStore().load();
                                gridAccounting.getView().refresh(true);
                            }
                            if (e.field == 'unit_id') {
                                e.record.id = result.data.product_id + '_' + result.data.unit_id;
                            }
                            e.record.commit();
                        }
                        else {
                            e.record.reject();
                        }
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
                        recordId: Ext.encode(e.record.id),
                        voucherId: Ext.encode(gridDetail.getStore().baseParams.voucherId),
                        field: Ext.encode(e.field),
                        value: Ext.encode(e.value),
                        forexRate: Ext.encode(formatNumber(Ext.getCmp('forex_rate').getValue()))
                    }
                });
            },
            cellclick: function(gridSpec, rowIndex, columnIndex, e){
                if (gridDetail.getColumnModel().getColumnId(columnIndex) == 'unit_id') {
                    comboUnitOption.store.removeAll();
                    var arrUnit = gridDetail.getStore().getAt(rowIndex).data.arr_unit_id;
                    var i;
                    for (i = 0; i < arrUnit.length; i++) {
                        var recordUnit = new Array();
                        recordUnit['unit_id'] = arrUnit[i]['unit_id'];
                        recordUnit['unit_name'] = arrUnit[i]['unit_name'];
                        var rec = new Ext.data.Record(recordUnit);
                        comboUnitOption.store.add(rec);
                    }
                }
            },
            "render": {
                scope: this,
                fn: function(grid){
                    var gridGridDropTargetEl = gridDetail.getView().scroller.dom;
                    var productGridDropTarget = new Ext.dd.DropTarget(gridGridDropTargetEl, {
                        ddGroup: 'firstGridDDGroup',
                        notifyDrop: function(ddSource, e, data){
                            var records = ddSource.dragData.selections;
                            var arrProduct = new Array();
                            for (var i = 0; i < records.length; i++) {
                                var inventoryPrice = '';
                                for (var j = 0; j < records[i].data.arr_unit_id.length; j++) {
                                    if (records[i].data.arr_unit_id[j].unit_id == records[i].data.regular_unit_id) {
                                        inventoryPrice = records[i].data.arr_unit_id[j].default_inventory_price;
                                        inventoryPrice = formatNumber(inventoryPrice);
                                        break;
                                    }
                                }
                                if (!detect_product(gridDetail.getStore(), records[i].data.product_id, records[i].data.regular_unit_id)) {
                                    var recordNewProduct = {
                                        product_id: records[i].data.product_id,
                                        unit_id: records[i].data.regular_unit_id,
                                        in_warehouse_id: Ext.getCmp('in_warehouse_id').getValue(),
                                        out_warehouse_id: Ext.getCmp('out_warehouse_id').getValue(),
                                        department_id: Ext.getCmp('department_id').getValue(),
                                        subject_id: Ext.getCmp('subject_id').getValue(),
                                        price: inventoryPrice
                                    };
                                    arrProduct.push(recordNewProduct);
                                }
                            }
                            if (arrProduct.length > 0) {
                                baseInsertDetailInventory(gridDetail.getStore().baseParams.inventoryVoucherId, arrProduct, gridDetail.getStore().baseParams.inOut);
                            }
                            else {
                                warning('Warning'.translator('buy-billing'), 'Selected products existed'.translator('buy-billing'));
                            }
                            return true
                        }
                    });
                }
            }
        }
    });
    
    gridDetail.on('keydown', function(e){
        if (e.keyCode == 46) {
            Detail.remove();
        }
    });
    
    storeDetail.on('beforeload', function(){
        storeDetail.baseParams.start = 0;
        storeDetail.baseParams.limit = page_size;
    });
    
    function detect_product(gridDetail, productId, unitId){
        var j = 0;
        while (j < gridDetail.getCount()) {
            if ((productId == gridDetail.getAt(j).data.product_id) &&
            (unitId == gridDetail.getAt(j).data.unit_id)) {
                return true;
            }
            else {
                j++;
            }
        }
        return false;
    }
    
    var wraperProduct = new Ext.Panel({
        region: 'center',
        collapsible: false,
        border: false,
        layout: 'fit',
        contentEl: 'div-form-product',
        autoScroll: true
    });
    
    /* Creating popup windows */
    var showProductWin = new Ext.Window({
        items: [wraperProduct], //tabPanel, created in form-product.phtml
        layout: 'border',
        constrainHeader: true,
        height: 604,
        width: 500,
        closeAction: 'hide',
        maximizable: true,
        border: false
    });
});

var baseInsertDetailInventory = function(inventoryVoucherId, records, typeVote){

    Ext.Ajax.request({
        url: pathRequestUrl + '/insertDetailInventory/' + inventoryVoucherId,
        method: 'post',
        success: function(result, options){
            gridDetail.store.load();
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            records: Ext.encode(records),
            typeVote: Ext.encode(typeVote)
        }
    });
}

var baseDeleteDetailInventory = function(inventoryVoucherId, records, voucherId){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteDetailInventory/' + inventoryVoucherId,
        method: 'post',
        success: function(result, options){
            gridDetail.store.load();
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            records: Ext.encode(records),
            voucherId: Ext.encode(voucherId)
        }
    });
}
