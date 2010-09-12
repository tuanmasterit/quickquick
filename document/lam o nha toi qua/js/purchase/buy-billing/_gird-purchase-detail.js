var storeImportRate;
var storeExciseRate;
var storeVatRate;
var storeUnit;

Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    storeImportRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'tax_rate_id',
            fields: ['tax_rate_id', 'rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getTaxRate/' + IMPORT_RATE
        }),
        autoLoad: false
    });
    
    function render_import_rate(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeImportRate.queryBy(function(rec){
                return rec.data.tax_rate_id == val;
            }).itemAt(0).data.rate;
        } 
        catch (e) {
        }
    }
    
    var storeImportOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id'
        }, {
            name: 'specification_name'
        }, {
            name: 'rate'
        }]
    });
    
    var comboImportOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeImportOption,
        valueField: 'tax_rate_id',
        displayField: 'rate',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:15px;">{rate}</div><div style="float:left; text-align:left;">|</div><div>{specification_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 600
    });
    
    storeExciseRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'tax_rate_id',
            fields: ['tax_rate_id', 'rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getTaxRate/' + EXCISE_RATE
        }),
        autoLoad: false
    });
    
    function render_excise_rate(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeExciseRate.queryBy(function(rec){
                return rec.data.tax_rate_id == val;
            }).itemAt(0).data.rate;
        } 
        catch (e) {
        }
    }
    
    var storeExciseOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id'
        }, {
            name: 'specification_name'
        }, {
            name: 'rate'
        }]
    });
    
    var comboExciseOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeExciseOption,
        valueField: 'tax_rate_id',
        displayField: 'rate',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:15px;">{rate}</div><div style="float:left; text-align:left;">|</div><div>{specification_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 600
    });
    
    storeVatRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'tax_rate_id',
            fields: ['tax_rate_id', 'rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getTaxRate/' + VAT_RATE
        }),
        autoLoad: false
    });
    
    function render_vat_rate(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeVatRate.queryBy(function(rec){
                return rec.data.tax_rate_id == val;
            }).itemAt(0).data.rate;
        } 
        catch (e) {
        }
    }
    
    var storeVatOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id'
        }, {
            name: 'specification_name'
        }, {
            name: 'rate'
        }]
    });
    
    var comboVatOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeVatOption,
        valueField: 'tax_rate_id',
        displayField: 'rate',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:15px;">{rate}</div><div style="float:left; text-align:left;">|</div><div>{specification_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 600
    });
    
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
    
    var DetailEntry = {
    
        remove: function(){
            var records = gridDetailEntry.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm',
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Are delete products'.translator('buy-billing') + Ext.getCmp('purchase_invoice_number').getValue() + '\' ?',
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
                            baseDeleteDetailPurchase(gridDetailEntry.getStore().baseParams.purchaseInvoiceId, arrRecord, gridDetailEntry.getStore().baseParams.voucherId);
                        }
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Not row to delete'.translator('buy-billing'));
            }
        }
    };
    
    storeDetailEntry = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'detail_purchase_id',
            fields: ['purchase_invoice_id', 'detail_purchase_id', 'product_id', 'unit_id', 'product_unit_name', 'arr_unit_id', 'product_name', 'currency_id', 'currency_name', 'forex_rate', 'unit_id', 'quantity', 'converted_quantity', 'price', 'amount', 'converted_amount', 'import_rate_id', 'import_rate', 'import_amount', 'excise_rate_id', 'excise_rate', 'excise_amount', 'vat_rate_id', 'vat_rate', 'vat_amount', 'total_amount', 'note', 'arr_import_rate_id', 'arr_excise_rate_id', 'arr_vat_rate_id']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDetailPurchaseInvoiceById/1'
        }),
        autoLoad: false
    });
    
    comboDomestic = new Ext.form.ComboBox({
        id: 'comboDomestic',
        store: storeDetailEntry,
        forceSelection: true,
        displayField: 'product_unit_name',
        valueField: 'detail_purchase_id',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        emptyText: 'Select a product to accounting'.translator('buy-billing'),
        selectOnFocus: true,
        editable: true,
        width: 250,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                gridDomestic.topToolbar.items.get('add_entry_domestic').enable();
            }
        }
    });
    
    comboEntryDebit = new Ext.form.ComboBox({
        id: 'comboEntryDebit',
        store: storeDetailEntry,
        forceSelection: true,
        displayField: 'product_unit_name',
        valueField: 'detail_purchase_id',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        emptyText: 'Select a product to accounting'.translator('buy-billing'),
        selectOnFocus: true,
        editable: true,
        width: 300,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                gridEntryDebit.topToolbar.items.get('add_entry').enable();
            }
        }
    });
    
    comboVatGood = new Ext.form.ComboBox({
        id: 'comboVatGood',
        store: storeDetailEntry,
        forceSelection: true,
        displayField: 'product_unit_name',
        valueField: 'detail_purchase_id',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        emptyText: 'Select a product to accounting'.translator('buy-billing'),
        selectOnFocus: true,
        editable: true,
        width: 250,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                gridImportGood.topToolbar.items.get('add_entry_import').enable();
            }
        }
    });
    
    var bbarDetailEntry = new Ext.PagingToolbar({
        store: storeDetailEntry, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size
    });
    
    var cmDetailEntry = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Product Name'.translator('buy-billing'),
            width: 100,
            dataIndex: 'product_name'
        }, {
            header: 'Unit'.translator('buy-billing'),
            width: 80,
            dataIndex: 'unit_id',
            id: 'unit_id',
            renderer: render_unit_name,
            editor: comboUnitOption
        }, {
            header: 'Qty'.translator('buy-billing'),
            width: 75,
            dataIndex: 'quantity',
            id: 'quantity',
            editor: new Ext.form.TextField({
                allowBlank: false,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                    }
                }
            }),
            align: 'right'
        }, {
            header: 'Price'.translator('buy-billing'),
            width: 100,
            dataIndex: 'price',
            align: 'right',
            editor: new Ext.form.TextField({
                allowBlank: false,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                    }
                }
            })
        }, {
            header: 'Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'amount',
            align: 'right'
        }, {
            header: 'Converted Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'converted_amount',
            align: 'right'
        }, {
            header: 'Import Rate'.translator('buy-billing'),
            width: 100,
            id: 'import_rate_id',
            dataIndex: 'import_rate_id',
            align: 'right',
            editor: comboImportOption,
            renderer: render_import_rate
        }, {
            header: 'Import Amount'.translator('buy-billing'),
            width: 130,
            dataIndex: 'import_amount',
            align: 'right'
        }, {
            header: 'Excise Rate'.translator('buy-billing'),
            width: 140,
            id: 'excise_rate_id',
            dataIndex: 'excise_rate_id',
            align: 'right',
            renderer: render_excise_rate,
            editor: comboExciseOption
        }, {
            header: 'Excise Amount'.translator('buy-billing'),
            width: 140,
            dataIndex: 'excise_amount',
            align: 'right'
        }, {
            header: 'Vat Rate'.translator('buy-billing'),
            width: 120,
            id: 'vat_rate_id',
            dataIndex: 'vat_rate_id',
            align: 'right',
            renderer: render_vat_rate,
            editor: comboVatOption
        }, {
            header: 'Vat Amount'.translator('buy-billing'),
            width: 130,
            dataIndex: 'vat_amount',
            align: 'right'
        }, {
            header: 'Total Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'total_amount',
            align: 'right'
        }, {
            header: 'Note'.translator('buy-billing'),
            width: 200,
            dataIndex: 'note',
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }]
    });
    // by default columns are sortable
    cmDetailEntry.defaultSortable = true;
    
    // create the Grid
    gridDetailEntry = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeDetailEntry,
        cm: cmDetailEntry,
        stripeRows: true,
        height: 351,
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
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_detail_entry',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: DetailEntry.remove
        }, bbarDetailEntry, '-', {
            xtype: 'button',
            width: 70,
            height: 20,
            text: 'Show list product'.translator('buy-billing'),
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
        stateId: 'gridDetailEntry',
        id: 'gridDetailEntry',
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
                else 
                    if (e.field == 'import_rate_id') {
                        for (var i = 0; i < storeImportOption.getCount(); i++) {
                            if (storeImportOption.getAt(i).data.tax_rate_id == e.value) {
                                e.value = storeImportOption.getAt(i).data.tax_rate_id + '_' + storeImportOption.getAt(i).data.rate;
                                break;
                            }
                        }
                    }
                    else 
                        if (e.field == 'excise_rate_id') {
                            for (var i = 0; i < storeExciseOption.getCount(); i++) {
                                if (storeExciseOption.getAt(i).data.tax_rate_id == e.value) {
                                    e.value = storeExciseOption.getAt(i).data.tax_rate_id + '_' + storeExciseOption.getAt(i).data.rate;
                                    break;
                                }
                            }
                        }
                        else 
                            if (e.field == 'vat_rate_id') {
                                for (var i = 0; i < storeVatOption.getCount(); i++) {
                                    if (storeVatOption.getAt(i).data.tax_rate_id == e.value) {
                                        e.value = storeVatOption.getAt(i).data.tax_rate_id + '_' + storeVatOption.getAt(i).data.rate;
                                        break;
                                    }
                                }
                            }
                
                Ext.Ajax.request({
                    url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateDetailPurchase/' + selectedPurchaseInvoiceId,
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (result.success) {
                            if (e.field != 'unit_id') {
                                if (Ext.getCmp('by_import').getValue()) {
                                    e.record.data.import_rate_id = result.data.import_rate_id;
                                    e.record.data.import_amount = result.data.import_amount;
                                    e.record.data.excise_rate_id = result.data.excise_rate_id;
                                    e.record.data.excise_amount = result.data.excise_amount;
                                }
                                e.record.data.price = result.data.price;
                                e.record.data.quantity = result.data.quantity;
                                e.record.data.amount = result.data.amount;
                                e.record.data.converted_amount = result.data.converted_amount;
                                e.record.data.vat_rate_id = result.data.vat_rate_id;
                                e.record.data.vat_amount = result.data.vat_amount;
                                e.record.data.total_amount = result.data.total_amount;
                            }
                            e.record.commit();
                            if ((e.field == 'quantity') || (e.field == 'price')) {
                                reload_accounting(Ext.getCmp('by_import').getValue() ? 1 : 0);
                            }
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
                        voucherId: Ext.encode(gridDetailEntry.getStore().baseParams.voucherId),
                        productId: Ext.encode(e.record.id),
                        field: Ext.encode(e.field),
                        value: Ext.encode(e.value),
                        forexRate: Ext.encode(formatNumber(Ext.getCmp('forex_rate').getValue()))
                    }
                });
            },
            cellclick: function(gridSpec, rowIndex, columnIndex, e){
                if (gridDetailEntry.getColumnModel().getColumnId(columnIndex) == 'unit_id') {
                    comboUnitOption.store.removeAll();
                    var arrUnit = gridDetailEntry.getStore().getAt(rowIndex).data.arr_unit_id;
                    var i;
                    for (i = 0; i < arrUnit.length; i++) {
                        var recordUnit = new Array();
                        recordUnit['unit_id'] = arrUnit[i]['unit_id'];
                        recordUnit['unit_name'] = arrUnit[i]['unit_name'];
                        var rec = new Ext.data.Record(recordUnit);
                        comboUnitOption.store.add(rec);
                    }
                }
                else {
                    var recordNull = new Array();
                    recordNull['tax_rate_id'] = 0;
                    recordNull['specification_name'] = '';
                    recordNull['rate'] = 0;
                    var recNull = new Ext.data.Record(recordNull);
                    if (gridDetailEntry.getColumnModel().getColumnId(columnIndex) == 'import_rate_id') {
                        comboImportOption.store.removeAll();
                        comboImportOption.store.add(recNull);
                        var arrImport = gridDetailEntry.getStore().getAt(rowIndex).data.arr_import_rate_id;
                        var i;
                        for (i = 0; i < arrImport.length; i++) {
                            var recordImport = new Array();
                            recordImport['tax_rate_id'] = arrImport[i]['tax_rate_id'];
                            recordImport['specification_name'] = arrImport[i]['specification_name'];
                            recordImport['rate'] = arrImport[i]['rate'];
                            var rec = new Ext.data.Record(recordImport);
                            comboImportOption.store.add(rec);
                        }
                    }
                    else 
                        if (gridDetailEntry.getColumnModel().getColumnId(columnIndex) == 'excise_rate_id') {
                            comboExciseOption.store.removeAll();
                            comboExciseOption.store.add(recNull);
                            var arrExcise = gridDetailEntry.getStore().getAt(rowIndex).data.arr_excise_rate_id;
                            var i;
                            for (i = 0; i < arrExcise.length; i++) {
                                var recordExcise = new Array();
                                recordExcise['tax_rate_id'] = arrExcise[i]['tax_rate_id'];
                                recordExcise['specification_name'] = arrExcise[i]['specification_name'];
                                recordExcise['rate'] = arrExcise[i]['rate'];
                                var rec = new Ext.data.Record(recordExcise);
                                comboExciseOption.store.add(rec);
                            }
                        }
                        else 
                            if (gridDetailEntry.getColumnModel().getColumnId(columnIndex) == 'vat_rate_id') {
                                comboVatOption.store.removeAll();
                                comboVatOption.store.add(recNull);
                                var arrVat = gridDetailEntry.getStore().getAt(rowIndex).data.arr_vat_rate_id;
                                var i;
                                for (i = 0; i < arrVat.length; i++) {
                                    var recordVat = new Array();
                                    recordVat['tax_rate_id'] = arrVat[i]['tax_rate_id'];
                                    recordVat['specification_name'] = arrVat[i]['specification_name'];
                                    recordVat['rate'] = arrVat[i]['rate'];
                                    var rec = new Ext.data.Record(recordVat);
                                    comboVatOption.store.add(rec);
                                }
                            }
                }
            },
            "render": {
                scope: this,
                fn: function(grid){
                    var gridGridDropTargetEl = gridDetailEntry.getView().scroller.dom;
                    var productGridDropTarget = new Ext.dd.DropTarget(gridGridDropTargetEl, {
                        ddGroup: 'firstGridDDGroup',
                        notifyDrop: function(ddSource, e, data){
                            var records = ddSource.dragData.selections;
                            var arrProduct = new Array();
                            //search product Id is exist in grid detail entry             
                            for (var i = 0; i < records.length; i++) {
                                var purchasePrice = '';
                                for (var j = 0; j < records[i].data.arr_unit_id.length; j++) {
                                    if (records[i].data.arr_unit_id[j].unit_id == records[i].data.regular_unit_id) {
                                        purchasePrice = records[i].data.arr_unit_id[j].default_purchase_price;
                                        purchasePrice = formatNumber(purchasePrice);
                                        break;
                                    }
                                }
                                
                                if (!detect_product(gridDetailEntry.getStore(), records[i].data.product_id, records[i].data.regular_unit_id)) {
                                    var recordNewProduct = {
                                        product_id: records[i].data.product_id,
                                        unit_id: records[i].data.regular_unit_id,
                                        price: purchasePrice
                                    };
                                    arrProduct.push(recordNewProduct);
                                }
                            }
                            if (arrProduct.length > 0) {
                                baseInsertDetailPurchase(gridDetailEntry.getStore().baseParams.purchaseInvoiceId, arrProduct);
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
    
    gridDetailEntry.on('keydown', function(e){
        if (e.keyCode == 46) {
            DetailEntry.remove();
        }
    });
    
    function detect_product(gridStore, productId, unitId){
        var j = 0;
        while (j < gridStore.getCount()) {
            if ((productId == gridStore.getAt(j).data.product_id) &&
            (unitId == gridStore.getAt(j).data.unit_id)) {
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
    
    storeDetailEntry.on('beforeload', function(){
    
        storeDetailEntry.baseParams.start = 0;
        storeDetailEntry.baseParams.limit = page_size;
    });
    
});

var baseInsertDetailPurchase = function(purchaseInvoiceId, records){

    Ext.Ajax.request({
        url: pathRequestUrl + '/insertDetailPurchase/' + purchaseInvoiceId,
        method: 'post',
        success: function(result, options){
            gridDetailEntry.store.load();
			reload_accounting(Ext.getCmp('by_import').getValue());
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            records: Ext.encode(records)
        }
    });
};

var baseDeleteDetailPurchase = function(purchaseInvoiceId, records, voucherId){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteDetailPurchase/' + purchaseInvoiceId,
        method: 'post',
        success: function(result, options){
            gridDetailEntry.store.load();
			reload_accounting(Ext.getCmp('by_import').getValue());
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
};
