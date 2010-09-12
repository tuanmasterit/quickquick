var display_detail_by_import = function(byImport){
    if (isEmpty(byImport)) {
        gridDetailEntry.getColumnModel().setHidden(7, true);
        gridDetailEntry.getColumnModel().setHidden(8, true);
        gridDetailEntry.getColumnModel().setHidden(9, true);
        gridDetailEntry.getColumnModel().setHidden(10, true);
    }
    else {
        gridDetailEntry.getColumnModel().setHidden(7, false);
        gridDetailEntry.getColumnModel().setHidden(8, false);
        gridDetailEntry.getColumnModel().setHidden(9, false);
        gridDetailEntry.getColumnModel().setHidden(10, false);
    }
};

var display_accounting_by_import = function(record, byImport){
    if (byImport == 1) {
        if (!isStart1) {
            isStart1 = true;
            storeDebitAccount.load();
            storeCreditAccount.load();
            storeDebitAccountImport.load();
            storeCreditAccountImport.load();
        }
        Ext.getCmp('tabsAccounting2').setVisible(false);
        Ext.getCmp('tabsAccounting1').setVisible(true);
        var batchPurchase, batchVat;
        for (var i = 0; i < record.data.arr_batch.length; i++) {
            if (record.data.arr_batch[i].entry_type_id == ENTRY_TYPE_PURCHASE_IMPORT) {
                batchPurchase = record.data.arr_batch[i].batch_id;
            }
            else 
                if (record.data.arr_batch[i].entry_type_id == ENTRY_TYPE_VAT_GOOD) {
                    batchVat = record.data.arr_batch[i].batch_id;
                }
        }
        gridEntryDebit.getStore().baseParams = {
            batchId: batchPurchase
        };
        gridImportGood.getStore().baseParams = {
            batchId: batchVat
        };
        gridEntryDebit.getStore().removeAll();
        gridImportGood.getStore().removeAll();
        gridEntryDebit.getStore().load();
        gridImportGood.getStore().load();
    }
    else {
        if (!isStart2) {
            isStart2 = true;
            storeDebitAccountDomestic.load();
            storeCreditAccountDomestic.load();
        }
        Ext.getCmp('tabsAccounting1').setVisible(false);
        Ext.getCmp('tabsAccounting2').setVisible(true);
        var batchDomestic;
        for (var i = 0; i < record.data.arr_batch.length; i++) {
            if (record.data.arr_batch[i].entry_type_id == ENTRY_TYPE_DOMESTIC) {
                batchDomestic = record.data.arr_batch[i].batch_id;
                break;
            }
        }
        gridDomestic.getStore().baseParams = {
            batchId: batchDomestic
        };
        gridDomestic.getStore().removeAll();
        gridDomestic.getStore().load();
    }
};

var clickedColumnIndex = 0;
var storeSupplierWithForexRate;
var storeCurrencyWithForexRate;
var isStart = false;

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
                if (!record.data.purchase_invoice_number || !record.data.purchase_invoice_date_format) {
                    warning('Warning'.translator('buy-billing'), 'Check purchase number and date'.translator('buy-billing'));
                    record.reject();
                    return;
                }
                var importValue = record.data[this.dataIndex] ? 1 : 0;
                var value = record.data[this.dataIndex];
                Ext.Ajax.request({
                    url: pathRequestUrl + '/updateByImportOfPurchase/' + record.data.purchase_invoice_id,
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (result.success) {
                            record.data.by_import_format = value ? "1" : "";
                            record.data.arr_batch = result.data;
                            if (!tabs.getItem('invoiceInfo').disabled) {
                                display_accounting_by_import(record, importValue);
                            }
                            record.commit();
                        }
                        else {
                            record.reject();
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
                        voucherId: Ext.encode(record.data.voucher_id),
                        field: Ext.encode(this.id),
                        value: Ext.encode(record.data[this.dataIndex] ? 1 : 0)
                    }
                });
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
    
    function formatDate(value){
        try {
            return value ? ((value.dateFormat(date_format_string) != '01/01/1970') ? value.dateFormat(date_format_string) : '') : '';
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
        name: 'purchase_invoice_number',
        type: 'string'
    }, {
        name: 'purchase_invoice_date',
        type: 'date'
    }, {
        name: 'purchase_invoice_date_format',
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
        name: 'by_import_format',
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
    }];
    
    var invoice_object = Ext.data.Record.create(InvoiceRecord);
    
    var Invoice = {
    
        add: function(){
            var invoiceNewRecord = new invoice_object();
            gridInvoice.getStore().insert(gridInvoice.getStore().getCount(), invoiceNewRecord);
            gridInvoice.startEditing(gridInvoice.getStore().getCount() - 1, 0);
            gridInvoice.bottomToolbar.items.get('add_invoice').disable();
        },
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
                                if (!isEmpty(records[i].data.purchase_invoice_id)) {
                                    arrRecord.push({
                                        purchase_invoice_id: records[i].data.purchase_invoice_id
                                    });
                                }
                                gridInvoice.getStore().remove(records[i]);
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
    
    storeSupplierWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_name', 'subject_address', 'subject_tax_code', 'currency_id', 'currency_name', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubjectWithForexRate/1'
        }),
        autoLoad: true
    });
    
    storeSupplierWithForexRate.on('beforeload', function(){
        storeSupplierWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });
    
    storeCurrencyWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCurrencyWithForexRate/1'
        }),
        autoLoad: true
    });
    
    storeCurrencyWithForexRate.on('beforeload', function(){
        storeCurrencyWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });
    
    var storeSupplier = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubject/is_supplier'
        }),
        autoLoad: true
    });

    storeSupplier.on('load', function(){
        storeSupplier.insert(0, new Ext.data.Record({
            subject_id: 0,
            subject_name: 'All'.translator('stock-manage')
        }));
        storeInvoice.load();
    });
    
    function render_currency_name(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeCurrencyWithForexRate.queryBy(function(rec){
                return rec.data.currency_id == val;
            }).itemAt(0).data.currency_name;
        } 
        catch (e) {
        }
    }
    
    var comboGirdCurrency = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeCurrencyWithForexRate,
        valueField: 'currency_id',
        displayField: 'currency_name',
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
                gridInvoice.getSelectionModel().getSelected().data.forex_rate = record.data.forex_rate;
            }
        }
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
    }
    
    var comboSupplierGird = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeSupplierWithForexRate,
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
                gridInvoice.getSelectionModel().getSelected().data.forex_rate = record.data.forex_rate;
                gridInvoice.getSelectionModel().getSelected().data.currency_id = record.data.currency_id;
                gridInvoice.getSelectionModel().getSelected().data.supplier_tax_code = record.data.subject_tax_code;
            }
        }
    });
    
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
            xtype: 'label',
            text: 'Supplier'.translator('buy-billing'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
            id: 'srch_supplier',
            store: storeSupplier,
            forceSelection: true,
            displayField: 'subject_name',
            valueField: 'subject_id',
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText: 'Select a supplier'.translator('buy-billing'),
            selectOnFocus: true,
            editable: true,
            width: 150,
            lazyRender: true,
            selectOnFocus: true,
            listeners: {
                select: function(combo, record, index){
                    Invoice.find();
                }
            }
        }), {
            text: 'Find'.translator('buy-billing'),
            id: 'find_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            style: 'padding-left: 5px;',
            handler: Invoice.find
        }, '-', {
            xtype: 'button',
            width: 70,
            height: 20,
            text: 'Show Detail'.translator('buy-billing'),
            id: 'btnDetail',
            handler: function(){
                display_detail_purchase();
            }
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
    
    var checkByImport = new Ext.grid.CheckColumn({
        header: 'Invoice Import'.translator('buy-billing'),
        dataIndex: 'by_import_format',
        id: 'by_import',
        width: 75
    });
    
    function setCharAt(str, index, chr){
        if (index > str.length - 1) 
            return str;
        return str.substr(0, index) + chr + str.substr(index + 1);
    }
    
    var cmInvoice = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Invoice Number'.translator('buy-billing'),
            dataIndex: 'purchase_invoice_number',
            id: 'purchase_invoice_number',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Invoice Date'.translator('buy-billing'),
            dataIndex: 'purchase_invoice_date_format',
            id: 'purchase_invoice_date_format',
            width: 77,
            renderer: formatDate,
            editor: new Ext.form.DateField({
                allowBlank: false,
                format: date_format_string
            })
        }, {
            header: 'Supplier'.translator('buy-billing'),
            dataIndex: 'supplier_name',
            id: 'supplier_id',
            width: 150,
            editor: comboSupplierGird,
            renderer: render_supplier_name
        }, {
            header: 'Supplier Tax code'.translator('buy-billing'),
            dataIndex: 'supplier_tax_code',
            id: 'supplier_tax_code',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Supplier Contact'.translator('buy-billing'),
            dataIndex: 'supplier_contact',
            id: 'supplier_contact',
            width: 140,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Currency Type'.translator('buy-billing'),
            dataIndex: 'currency_id',
            id: 'currency_id',
            width: 100,
            editor: comboGirdCurrency,
            renderer: render_currency_name
        }, {
            header: 'Forex Rate'.translator('buy-billing'),
            dataIndex: 'forex_rate',
            id: 'forex_rate',
            width: 100,
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
        }, checkByImport, {
            header: 'Total Amount'.translator('buy-billing'),
            dataIndex: 'total_purchase_amount',
            width: 100,
            align: 'right'
        }]
    });
    // by default columns are sortable
    cmInvoice.defaultSortable = true;
    
    var clickedRowIndex = 0;
    // create the Grid
    gridInvoice = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeInvoice,
        cm: cmInvoice,
        stripeRows: true,
        height: 530,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        plugins: checkByImport,
        tbar: tbarInvoice,
        bbar: [{
            text: 'Add'.translator('buy-billing'),
            id: 'add_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Invoice.add
        }, {
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Invoice.remove
        }, bbarInvoice],
        stateful: true,
        stateId: 'gridInvoice',
        id: 'gridInvoice',
        listeners: {
            cellclick: function(grid, rowIndex, columnIndex, e){
                clickedColumnIndex = columnIndex;
                clickedRowIndex = rowIndex;
            },
            afteredit: function(e){
                var status = false;
                if (!e.record.data.purchase_invoice_number ||
                !e.record.data.purchase_invoice_date_format ||
                !e.record.data.supplier_name ||
                !e.record.data.supplier_tax_code ||
                !e.record.data.currency_id ||
                !e.record.data.forex_rate) {
                
                    status = true;
                }
                
                if (!status) {
                    if (Ext.getCmp('add_invoice').disabled) {
                        var objectSubject = storeSupplierWithForexRate.queryBy(function(rec){
                            return rec.data.subject_id == e.record.data.supplier_name;
                        });
                        insertRecordInvoice(e.record, e.record.data.purchase_invoice_number, e.record.data.purchase_invoice_date_format, e.record.data.supplier_name, objectSubject.itemAt(0).data.subject_name, objectSubject.itemAt(0).data.subject_address, e.record.data.supplier_tax_code, e.record.data.supplier_contact, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.by_import_format);
                    }
                    else {
                        if (e.field == 'supplier_name') 
                            e.field = 'supplier_id';
                        if (e.field == 'forex_rate') {
                            if (parseFloat(e.value) < 0) {
                                e.record.reject();
                                msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                                return;
                            }
                            else {
                                e.value = formatNumber(e.value);
                            }
                        }
                        if (e.field == 'purchase_invoice_date_format') {
                            e.field = 'purchase_invoice_date';
                            e.value = e.value.dateFormat(date_sql_format_string);
                        }
                        Ext.Ajax.request({
                            url: pathRequestUrl + '/updatePurchase/' + e.record.id,
                            method: 'post',
                            success: function(result, options){
                                var result = Ext.decode(result.responseText);
                                if (result.success) {
                                    if (e.field == 'supplier_id' || e.field == 'currency_id' || e.field == 'forex_rate') {
                                        if (result.data.change_currency) {
                                            e.record.data.total_purchase_amount = result.data.total_purchase_amount;
                                        }
                                        else {
                                            var currencyName = storeCurrencyWithForexRate.queryBy(function(rec){
                                                return rec.data.currency_id == e.record.data.currency_id;
                                            }).itemAt(0).data.currency_name;
                                            warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + currencyName + 'Not forexrate'.translator('buy-billing'));
                                        }
                                        e.record.data.currency_id = result.data.currency_id;
                                        e.record.data.forex_rate = result.data.forex_rate;
                                    }
                                    e.record.commit();
                                }
                                else {
                                    e.record.reject();
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
                                convertCurrency: convertedCurrencyId,
                                field: Ext.encode(e.field),
                                value: Ext.encode(e.value)
                            }
                        });
                    }
                }
            }
        }
    });
    
    gridInvoice.on('keydown', function(e){
        if (e.browserEvent.keyCode == e.ENTER) {
            display_detail_purchase();
        }
        else 
            if (e.keyCode == 46) {
                Invoice.remove();
            }
    }, this);
    
    function display_detail_purchase(){
        var record = gridInvoice.getSelectionModel().getSelected();
        if (isNaN(record.id)) 
            return;
        if (record) {
            if (convertedCurrencyId == record.data.period_id) {
                tabs.getItem('invoiceInfo').setDisabled(false);
                tabs.setActiveTab('invoiceInfo');
                
                if (!isStart) {
                    isStart = true;
                    storeImportRate.load();
                    storeExciseRate.load();
                    storeVatRate.load();
                    storeUnit.load();
                }
                //update form purchase
                selectedPurchaseInvoiceId = record.id;
                selectedPurchaseInvoiceIndex = gridInvoice.getStore().indexOf(record);
                forexRate = record.data.forex_rate;
                currencyType = record.data.currency_id;
                Ext.getCmp('purchase_invoice_number').setValue(record.data.purchase_invoice_number);
                Ext.getCmp('purchase_invoice_date').setValue(record.data.purchase_invoice_date_format);
                Ext.getCmp('supplier_id').setValue(record.data.supplier_id);
                Ext.getCmp('supplier_name').setValue(record.data.supplier_name);
                Ext.getCmp('supplier_address').setValue(record.data.supplier_address);
                Ext.getCmp('supplier_tax_code').setValue(record.data.supplier_tax_code);
                Ext.getCmp('supplier_contact').setValue(record.data.supplier_contact);
                Ext.getCmp('forex_rate').setValue(record.data.forex_rate);
                Ext.getCmp('currency_id').setValue(record.data.currency_id);
                Ext.getCmp('by_import').setValue(record.data.by_import_format);
                Ext.getCmp('description').setValue(record.data.description);
                // end update form purchase
                // load detail purchase
                display_detail_by_import(record.data.by_import_format);
                gridDetailEntry.getStore().baseParams = {
                    'purchaseInvoiceId': selectedPurchaseInvoiceId,
                    'voucherId': record.data.voucher_id
                };
                gridDetailEntry.getStore().load();
                // end load detail purchase
                
                tabs.getItem('accountInfo').setDisabled(false);
                // check show tab accounting
                display_accounting_by_import(record, record.data.by_import_format);
            }
            else 
                warning('Warning'.translator('buy-billing'), 'Check edit purchase invoice'.translator('buy-billing'));
        }
        else 
            warning('Warning'.translator('buy-billing'), ' Check show detail'.translator('buy-billing'));
    }
    
    storeInvoice.on('beforeload', function(){
        var srchNumber = gridInvoice.topToolbar.items.get('srch_invoice_number').getValue();
        
        var srchFromDate = gridInvoice.topToolbar.items.get('srch_from_date').getValue();
        if (srchFromDate != null && srchFromDate != '') 
            srchFromDate = srchFromDate.dateFormat('Y-m-d');
        else 
            srchFromDate = '';
        
        var srchToDate = gridInvoice.topToolbar.items.get('srch_to_date').getValue();
        if (srchToDate != null && srchToDate != '') 
            srchToDate = srchToDate.dateFormat('Y-m-d');
        else 
            srchToDate = '';
        
        storeInvoice.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
        storeInvoice.baseParams.fromDate = srchFromDate;
        storeInvoice.baseParams.toDate = srchToDate;
        storeInvoice.baseParams.supplier = Ext.getCmp('srch_supplier').getValue();
        storeInvoice.baseParams.start = 0;
        storeInvoice.baseParams.limit = page_size;
        
        gridInvoice.bottomToolbar.items.get('add_invoice').enable();
    });
});

var insertRecordInvoice = function(record, invoiceNumber, invoiceDate, suppId, suppName, suppAddress, suppTaxCode, suppContact, currencyId, forexRate, byImport){

    invoiceDate = invoiceDate.dateFormat(date_sql_format_string);
    forexRate = formatNumber(forexRate);
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertPurchaseInvoice/' + invoiceNumber,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                record.id = result.data.purchase_invoice_id;
                record.data.purchase_invoice_id = result.data.purchase_invoice_id;
                record.data.total_purchase_amount = result.data.total_purchase_amount;
                record.data.voucher_id = result.data.voucher_id;
                record.data.period_id = result.data.period_id;
                record.data.arr_batch = result.data.arr_batch;
                record.data.supplier_id = result.data.supplier_id;
                record.data.supplier_name = result.data.supplier_name;
                record.data.supplier_address = result.data.supplier_address;
                record.data.supplier_address = result.data.supplier_address;
                //record.data.by_import = result.data.by_import;
                record.data.by_import_format = (result.data.by_import == 1) ? result.data.by_import : '';
                record.data.created_by_userid = result.data.created_by_userid;
                record.data.date_entered = result.data.date_entered;
                record.data.last_modified_by_userid = result.data.last_modified_by_userid;
                record.data.date_last_modified = result.data.date_last_modified;
                record.data.description = result.data.description;
                record.commit();
                gridInvoice.bottomToolbar.items.get('add_invoice').enable();
            }
            else {
                record.reject();
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
            record.reject();
        },
        params: {
            invoiceDate: Ext.encode(invoiceDate),
            suppId: Ext.encode(suppId),
            suppName: Ext.encode(suppName),
            suppAddress: Ext.encode(suppAddress),
            suppTaxCode: Ext.encode(suppTaxCode),
            suppContact: Ext.encode(suppContact),
            currencyId: Ext.encode(currencyId),
            forexrate: Ext.encode(forexRate),
            byImport: Ext.encode(byImport)
        }
    });
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
