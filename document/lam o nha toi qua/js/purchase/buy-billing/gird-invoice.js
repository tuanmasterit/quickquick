var clickedColumnIndex = 0;
var storeSupplier;
var storeSupplierNameWithForexRate;
var storeSupplierCodeWithForexRate;
var storeCurrencyCodeWithForexRate;
var storeCurrencyNameWithForexRate;
var isStart = false;

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
        if (t.className &&
        t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);

            record.set(this.dataIndex, !record.data[this.dataIndex]);
        }
    },

    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="approved-column x-grid3-check-col' +
        (v ? '-on' : '') +
        ' x-grid3-cc-' +
        this.id +
        '">&#160;</div>';
    }
};

Ext.apply(Ext.form.VTypes, {
    daterange: function(val, field){
        var date = field.parseDate(val);

        if (!date) {
            return;
        }
        if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
            var start = Ext.getCmp(field.startDateField);
            start.setMaxValue(date);
            start.validate();
            this.dateRangeMax = date;
        }
        else
            if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
                var end = Ext.getCmp(field.endDateField);
                end.setMinValue(date);
                end.validate();
                this.dateRangeMin = date;
            }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    storeWarehouse = new Ext.data.ArrayStore({
        fields: [{
            name: 'warehouse_id',
            type: 'string'
        }, {
            name: 'warehouse_name',
            type: 'string'
        }]
    });

    var storeByImportType = new Ext.data.ArrayStore({
        fields: [{
            name: 'by_import'
        }, {
            name: 'name'
        }, ],
        data: [[0, 'Trong nước'], [1, 'Nhập khẩu']]
    });

    var storeForServiceType = new Ext.data.ArrayStore({
        fields: [{
            name: 'for_service'
        }, {
            name: 'name'
        }, ],
        data: [[0, 'Hàng hóa'], [1, 'Dịch vụ']]
    });

    function render_by_import_type(val){
        try {
            if (val == null || val == '')
                return '';
            return storeByImportType.queryBy(function(rec){
                return rec.data.by_import == val;
            }).itemAt(0).data.name;
        }
        catch (e) {
        }
    };

    function render_for_service_type(val){
        try {
            if (val == null || val == '')
                return '';
            return storeForServiceType.queryBy(function(rec){
                return rec.data.for_service == val;
            }).itemAt(0).data.name;
        }
        catch (e) {
        }
    };

    var InvoiceRecord = [{
        name: 'purchase_invoice_id',
        type: 'string'
    }, {
        name: 'voucher_id',
        type: 'string'
    }, {
        name: 'purchase_serial_number',
        type: 'string'
    }, {
        name: 'purchase_invoice_number',
        type: 'string'
    }, {
        name: 'purchase_invoice_date',
        type: 'date'
    }, {
        name: 'supplier_id',
        type: 'string'
    }, {
        name: 'supplier_name',
        type: 'string'
    }, {
        name: 'supplier_tax_code',
        type: 'string'
    }, {
        name: 'supplier_address',
        type: 'string'
    }, {
        name: 'supplier_contact',
        type: 'string'
    }, {
        name: 'currency_id',
        type: 'string'
    }, {
        name: 'currency_name',
        type: 'string'
    }, {
        name: 'forex_rate',
        type: 'string'
    }, {
        name: 'by_import',
        type: 'string'
    }, {
        name: 'for_service',
        type: 'string'
    }, {
        name: 'total_purchase_amount',
        type: 'string'
    }, {
        name: 'description',
        type: 'string'
    }, {
        name: 'arr_batch',
        type: 'array'
    }, {
        name: 'period_id',
        type: 'string'
    }, {
        name: 'subject_id',
        type: 'string'
    }, {
        name: 'subject_contact',
        type: 'string'
    }, {
        name: 'department_id',
        type: 'string'
    }, {
        name: 'is_locked',
        type: 'string'
    }, {
        name: 'is_inheritanced',
        type: 'string'
    }, {
        name: 'locked',
        type: 'string'
    }];

    invoice_object = Ext.data.Record.create(InvoiceRecord);

    var Invoice = {

        remove: function(){
            var records = gridInvoice.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm'.translator('stock-manage'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Are delete purchase'.translator('buy-billing'),
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecord = new Array();
                            for (var i = 0; i < records.length; i++) {
								var isLocked = (records[i].data.is_locked == 1) ? true : false;
                                if (!isEmpty(records[i].data.purchase_invoice_id)  && !isLocked) {
                                    arrRecord.push({
                                        purchase_invoice_id: records[i].data.purchase_invoice_id,
										is_inheritanced: records[i].data.is_inheritanced
                                    });
									gridInvoice.getStore().remove(records[i]);
                                }                                
                            }
                            gridInvoice.getView().refresh(true);
                            baseDeletePurchaseInvoice(arrRecord);
                        }
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Not row to delete'.translator('buy-billing'));
            }
        },
        find: function(){
            gridInvoice.getStore().load();
        }
    };

    storeAccountList = new Ext.data.ArrayStore({
        fields: [{
            name: 'account_id',
            type: 'string'
        }, {
            name: 'account_code',
            type: 'string'
        }, {
            name: 'account_name',
            type: 'string'
        }]
    });

    storeSupplierNameWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_code', 'subject_name', 'subject_address', 'subject_tax_code', 'currency_id', 'currency_name', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubjectNameWithForexRate/1'
        }),
        autoLoad: true
    });

    storeSupplierCodeWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_code', 'subject_name', 'subject_address', 'subject_tax_code', 'currency_id', 'currency_name', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubjectCodeWithForexRate/1'
        }),
        autoLoad: true
    });

    storeSupplierCodeWithForexRate.on('beforeload', function(){
        storeSupplierCodeWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });

    storeSupplierNameWithForexRate.on('beforeload', function(){
        storeSupplierNameWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });

    storeCurrencyNameWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name', 'forex_rate', 'currency_code', ]
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCurrencyNameWithForexRate/1'
        }),
        autoLoad: true
    });

    storeCurrencyNameWithForexRate.on('beforeload', function(){
        storeCurrencyNameWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });

    storeCurrencyCodeWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name', 'forex_rate', 'currency_code', ]
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCurrencyCodeWithForexRate/1'
        }),
        autoLoad: true
    });

    storeCurrencyCodeWithForexRate.on('beforeload', function(){
        storeCurrencyCodeWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });

    storeSupplier = new Ext.data.ArrayStore({
        fields: [{
            name: 'subject_id',
            type: 'string'
        }, {
            name: 'subject_name',
            type: 'string'
        }]
    });

    function render_supplier_name(val){
        try {
            if (isNaN(val)) {
                return val;
            }
            if (val == null || val == '')
                return '';
            return storeSupplierWithForexRate.queryBy(function(rec){
                return rec.data.subject_id == val;
            }).itemAt(0).data.subject_name;
        }
        catch (e) {
        }
    };

    var storeInvoice = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'purchase_invoice_id'
        }, invoice_object),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListPurchaseInvoice/1'
        }),
        autoLoad: false
    });


    var tbarInvoice = new Ext.Toolbar({
        items: [{
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Invoice.remove
        }, '-', {
            xtype: 'label',
            text: 'Invoice Number'.translator('buy-billing'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'textfield',
            id: 'srch_invoice_number',
            width: 100,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        Invoice.find();
                    }
                }
            }
        }, '-', {
            xtype: 'label',
            text: 'From Date'.translator('buy-billing'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'datefield',
            width: 99,
            labelSeparator: '',
            id: 'srch_from_date',
            format: date_format_string,
            //readOnly: true,
            vtype: 'daterange',
            endDateField: 'srch_to_date'
        }, '-', {
            xtype: 'label',
            text: 'To Date'.translator('buy-billing'),
            style: 'padding-left: 5px;padding-right: 5px;'
        }, {
            xtype: 'datefield',
            width: 99,
            labelSeparator: '',
            id: 'srch_to_date',
            format: date_format_string,
            //readOnly: true,
            vtype: 'daterange',
            startDateField: 'srch_from_date'
        }, '-', {
            text: 'Find'.translator('buy-billing'),
            id: 'find_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            style: 'padding-left: 5px;',
            handler: Invoice.find
        }]
    });

    var cmbPerPage = new Ext.form.ComboBox({
        name: 'perpage',
        width: 80,
        store: new Ext.data.SimpleStore({
            data: [[50, '50'], [100, '100'], [150, '150'], [200, '200'], [250, '250'], [300, '300'], [500, '500'], [1000, '1000']],
            id: 0,
            fields: ['id', 'value']
        }),
        mode: 'local',
        value: '50',
        listWidth: 80,
        triggerAction: 'all',
        displayField: 'value',
        valueField: 'value',
        editable: false,
        forceSelection: true
    });

    cmbPerPage.on('select', function(combo, record){
        bbarInvoice.pageSize = parseInt(record.get('id'), 10);
        bbarInvoice.doLoad(bbarInvoice.cursor);
    }, this);

    var bbarInvoice = new Ext.PagingToolbar({
        store: storeInvoice, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size,
        items: ['-', 'Per Page'.translator('buy-billing'), cmbPerPage]
    });

    function setCharAt(str, index, chr){
        if (index > str.length - 1)
            return str;
        return str.substr(0, index) + chr + str.substr(index + 1);
    };

    var cmInvoice = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Invoice Seri Number'.translator('buy-billing'),
            dataIndex: 'purchase_serial_number',
            id: 'purchase_serial_number',
            width: 110
        }, {
            header: 'Invoice Number'.translator('buy-billing'),
            dataIndex: 'purchase_invoice_number',
            id: 'purchase_invoice_number',
            width: 100
        }, {
            header: 'Invoice Date'.translator('buy-billing'),
            dataIndex: 'purchase_invoice_date',
            id: 'purchase_invoice_date',
            width: 77,
            renderer: formatDate
        }, {
            header: 'Supplier'.translator('buy-billing'),
            dataIndex: 'supplier_name',
            id: 'supplier_id',
            width: 150,
            renderer: render_supplier_name
        }, {
            header: 'Supplier Tax code'.translator('buy-billing'),
            dataIndex: 'supplier_tax_code',
            id: 'supplier_tax_code',
            width: 100
        }, {
            header: 'Supplier Contact'.translator('buy-billing'),
            dataIndex: 'supplier_contact',
            id: 'supplier_contact',
            width: 140
        }, {
            header: 'Currency Type'.translator('buy-billing'),
            dataIndex: 'currency_id',
            id: 'currency_id',
            width: 100,
            renderer: render_currency_name,
            hidden: true
        }, {
            header: 'Forex Rate'.translator('buy-billing'),
            dataIndex: 'forex_rate',
            id: 'forex_rate',
            width: 80,
            align: 'right',
            renderer: render_number,
            hidden: true
        }, {
            header: 'Invoice Import'.translator('buy-billing'),
            dataIndex: 'by_import',
            id: 'by_import',
            width: 80,
            align: 'center',
            renderer: render_by_import_type
        }, {
            header: 'Invoice Service'.translator('buy-billing'),
            dataIndex: 'for_service',
            id: 'for_service',
            width: 80,
            align: 'center',
            renderer: render_for_service_type
        }, {
            header: 'Total Amount'.translator('buy-billing'),
            dataIndex: 'total_purchase_amount',
            width: 100,
            align: 'right',
            renderer: render_number
        }, new Ext.grid.CheckColumn({
            header: 'Inheritanced'.translator('sale-billing'),
            dataIndex: 'is_inheritanced',
            id: 'is_inheritanced',
            width: 50
        }), new Ext.grid.CheckColumn({
            header: 'Locked'.translator('sale-billing'),
            dataIndex: 'locked',
            id: 'locked',
            width: 50
        })]
    });

    // create the Grid
    gridInvoice = new Ext.grid.GridPanel({
        title: '',
        store: storeInvoice,
        cm: cmInvoice,
        stripeRows: true,
        height: 557,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        tbar: tbarInvoice,
        bbar: bbarInvoice,
        stateful: true,
        stateId: 'gridInvoice',
        id: 'gridInvoice'
    });

    gridInvoice.on('rowdblclick', function(grid, rowIndex, e){
        var record = grid.store.getAt(rowIndex);
        if (record) {
            // set value on form // form purchase
            var chkByImport = (record.data.by_import == 1) ? true : false;
            var chkForService = (record.data.for_service == 1) ? true : false;
            Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing') + " - " + record.data.purchase_invoice_number);
            Ext.getCmp('purchase_invoice_id').setValue(record.data.purchase_invoice_id);
            Ext.getCmp('purchase_invoice_number').setValue(record.data.purchase_invoice_number);
            Ext.getCmp('purchase_serial_number').setValue(record.data.purchase_serial_number);
            Ext.getCmp('purchase_invoice_date').setValue(record.data.purchase_invoice_date);
            Ext.getCmp('supplier_code').setValue(record.data.supplier_id);
            Ext.getCmp('supplier_id').setValue(record.data.supplier_id);
            Ext.getCmp('supplier_name').setValue(record.data.supplier_name);
            Ext.getCmp('supplier_address').setValue(record.data.supplier_address);
            Ext.getCmp('supplier_tax_code').setValue(record.data.supplier_tax_code);
            Ext.getCmp('supplier_contact').setValue(record.data.supplier_contact);
            Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
            Ext.getCmp('currency_code').setValue(record.data.currency_id);
            Ext.getCmp('currency_id').setValue(record.data.currency_id);
            Ext.getCmp('by_import').setValue(chkByImport);
            Ext.getCmp('for_service').setValue(chkForService);
            Ext.getCmp('is_locked').setValue(record.data.is_locked);
            Ext.getCmp('by_import').disable();
            Ext.getCmp('for_service').disable();
            Ext.getCmp('description').setValue(record.data.description);

            Ext.getCmp('reload_detail').enable();
            selectedPurchaseInvoiceIndex = gridInvoice.getStore().indexOf(record);

            display_detail_by_import(chkByImport, chkForService);

            gridDetail.getStore().removeAll();
            gridDetail.getStore().baseParams.purchaseInvoiceId = record.data.purchase_invoice_id;
            gridDetail.getStore().baseParams.forexrate = record.data.forex_rate;
            gridDetail.getStore().baseParams.currency_id = record.data.currency_id;
            gridDetail.getStore().baseParams.voucherId = record.data.voucher_id;

            gridDetail.getStore().load();
            // end form purchase

            baseGetBatchOfPurchase(record.data.voucher_id, record.data.by_import, record.data.for_service);

            // end set value on form

            // cost

            if (!chkForService) {
                tabs.getItem('infoExpense').setDisabled(false);
                gridCost.getStore().baseParams = {
                    'purchaseInvoiceId': gridDetail.getStore().baseParams.purchaseInvoiceId,
                    'type': 'cost'
                };
                gridCost.getStore().load();
                gridNo.getStore().baseParams = {
                    'purchaseInvoiceId': gridDetail.getStore().baseParams.purchaseInvoiceId,
                    'type': 'nodoc'
                };
                gridNo.getStore().load();
                gridCash.getStore().baseParams = {
                    'purchaseInvoiceId': gridDetail.getStore().baseParams.purchaseInvoiceId,
                    'type': 'cash'
                };
                gridCash.getStore().load();
                gridDetailExpense.getStore().removeAll();
            }
            else {
                tabs.getItem('infoExpense').setDisabled(true);
            }
            // end cost

            status = 'update';
            Ext.getCmp('btn_nheritance').disable();
            Ext.getCmp('btn_save').disable();
            Ext.getCmp('btn_delete').enable();
        }
    });

    gridInvoice.on('keydown', function(e){
        if (e.keyCode == 46) {
            Invoice.remove();
        }
    }, this);

    storeInvoice.on('beforeload', function(){
        var srchNumber = gridInvoice.topToolbar.items.get('srch_invoice_number').getValue();

        var srchFromDate = gridInvoice.topToolbar.items.get('srch_from_date').getValue();
        if (srchFromDate != null && srchFromDate != '')
            srchFromDate = srchFromDate.dateFormat('Y-m-d 00:00:00');
        else
            srchFromDate = '';

        var srchToDate = gridInvoice.topToolbar.items.get('srch_to_date').getValue();
        if (srchToDate != null && srchToDate != '')
            srchToDate = srchToDate.dateFormat('Y-m-d 00:00:00');
        else
            srchToDate = '';

        storeInvoice.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
        storeInvoice.baseParams.fromDate = srchFromDate;
        storeInvoice.baseParams.toDate = srchToDate;
        storeInvoice.baseParams.supplier = 0;
        storeInvoice.baseParams.start = 0;
        storeInvoice.baseParams.limit = page_size;

    });
});

var baseGetBatchOfPurchase = function(voucherId, byImport, forService){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getBatchOfPurchase/' + voucherId,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                var title = '';
                if (forService == 1) {
                    title = 'Expense Buy'.translator('buy-billing');
                    tabs.getItem('accountingExpense').setDisabled(true);
                }
                else {
                    tabs.getItem('accountingExpense').setDisabled(false);
                    if (byImport == 1) {
                        title = 'Accounting I 4'.translator('buy-billing');
                    }
                    else {
                        title = 'Accounting Not 2'.translator('buy-billing');
                    }
                }
				
				gridDetail.getStore().baseParams.batchId = result.data[0]['batch_id'];
                if (byImport == 1) {
                    tabs.getItem('accountInfo2').setDisabled(true);
                    tabs.getItem('accountInfo1').setDisabled(false);
                    tabsAccounting1.getItem('grid1').setTitle(title);

                    baseLoadAccounting(store2, result.data[0]['batch_id'], 2, byImport, forService);
                    baseLoadAccounting(store23, result.data[0]['batch_id'], 23, byImport, forService);
                    baseLoadAccounting(store24, result.data[0]['batch_id'], 24, byImport, forService);

                    baseLoadAccounting(store1, result.data[0]['batch_id'], null, byImport, forService);

                    if (forService != 1) {
                        baseLoadAccounting(storeAccCost, result.data[1]['batch_id'], null, byImport, forService);
                    }
                }
                else {
                    tabs.getItem('accountInfo2').setDisabled(false);
                    tabs.getItem('accountInfo1').setDisabled(true);
                    tabsAccounting2.getItem('grid3').setTitle(title);

                    baseLoadAccounting(store22, result.data[0]['batch_id'], 22, byImport, forService);

					baseLoadAccounting(store3, result.data[0]['batch_id'], null, byImport, forService);

                    if (forService != 1) {
                        baseLoadAccounting(storeAccCost, result.data[1]['batch_id'], null, byImport, forService);
                    }
                }
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        }
    });
};

var baseLoadAccounting = function(store, batchId, entryTypeId, byImport, forService){
    store.baseParams = {
        'batchId': batchId,
        'entryTypeId': entryTypeId,
        'byImport': byImport,
        'forService': forService
    };
    store.load();
};

var baseDeletePurchaseInvoice = function(arrRecord){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deletePurchaseInvoice/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                msg('Info'.translator('buy-billing'), 'Delete success'.translator('buy-billing'), Ext.MessageBox.INFO);
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            arrRecord: Ext.encode(arrRecord)
        }
    });
};
