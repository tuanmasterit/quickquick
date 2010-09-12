var FormAction;
var resultTplAccount;

// truong hop dich vu hay khong
var display_detail_for_service = function(forService){
    if (forService) {// hoa don dich vu
        Ext.getCmp('btn_nheritance').disable();
        gridDetail.getColumnModel().setHidden(1, false); // hien thi service_code
        gridDetail.getColumnModel().setHidden(2, false); // hien thi service_name
        gridDetail.getColumnModel().setHidden(3, true); // an product_code
        gridDetail.getColumnModel().setHidden(4, true); // an product_name
    }
    else {// hoa don hang hoa
        Ext.getCmp('btn_nheritance').enable();
        gridDetail.getColumnModel().setHidden(1, true); // an service_code
        gridDetail.getColumnModel().setHidden(2, true); // an service_name
        gridDetail.getColumnModel().setHidden(3, false); // hien thi product_code
        gridDetail.getColumnModel().setHidden(4, false); // hien thi product_name
    }
};

var display_detail_by_export = function(byExport, forService){
    if (byExport) {// hoa don xuat khau
        gridDetail.getColumnModel().setHidden(11, false);	// hien thi thue xuat khau
        gridDetail.getColumnModel().setHidden(12, false);	// hien thi tien thue xuat khau
        gridDetail.getColumnModel().setHidden(13, true);	// an thue tieu thu dac biet
        gridDetail.getColumnModel().setHidden(14, true);	// an tien thue tieu thu dac biet
    }
    else {
        gridDetail.getColumnModel().setHidden(11, true);	// an thue xuat khau
        gridDetail.getColumnModel().setHidden(12, true);	// an tien thue xuat khau
        gridDetail.getColumnModel().setHidden(13, false);	// hien thi thue tieu thu dac biet
        gridDetail.getColumnModel().setHidden(14, false);	// hien thi tien thue tieu thu dac biet
    }
    display_detail_for_service(forService);
};

function initGridDetail(){
    gridDetail.getStore().removeAll();
    var recordTotal = new DetailRecord({
        isTotal: true,
        isChecked: false,
        isLoadedData: true,
        isInsertData: false,
        quantity: "/Qty/",
        price: "/Sum/",
        amount: "/0.00/",
        converted_amount: "/0.00/",
        export_amount: "/0.00/",
        excise_amount: "/0.00/",
        vat_amount: "/0.00/",
        total_amount: "/0.00/"
    });
    gridDetail.getStore().insert(0, recordTotal);
    var newRecord = new DetailRecord({
        isTotal: false,
        isChecked: false,
        isLoadedData: false,
        isInsertData: true,
        product_id: null,
        product_code: null,
        product_name: null,
        service_id: null,
        service_code: null,
        service_name: null,
        price: null,
        unit_id: null,
        arr_unit: new Array(),
        quantity: null,
        coefficient: null,
        amount: null,
        converted_amount: null,
        export_rate_id: null,
        export_rate: 0,
        arr_export: new Array(),
        export_amount: null,
        excise_rate_id: null,
        excise_rate: 0,
        arr_excise: new Array(),
        excise_amount: null,
        vat_rate_id: null,
        vat_rate: 0,
        arr_vat: new Array(),
        vat_amount: null,
        total_amount: null,
        note: ''
    });
    gridDetail.getStore().insert(gridDetail.getStore().getCount(), newRecord);
};

function clear_form(val){
    initGridDetail();
    
    Ext.getCmp('sales_invoice_id').setValue("");
    Ext.getCmp('sales_invoice_number').setValue("");
    Ext.getCmp('sales_invoice_date').setValue((new Date()).format(date_format_string));
    Ext.getCmp('sales_serial_number').setValue("");
    Ext.getCmp('sales_serial_number').focus(true, 1);
    Ext.getCmp('customer_code').setValue(null);
    Ext.getCmp('customer_id').setValue(null);
    Ext.getCmp('customer_name').setValue("");
    Ext.getCmp('customer_address').setValue("");
    Ext.getCmp('customer_tax_code').setValue("");
    Ext.getCmp('customer_contact').setValue("");
    Ext.getCmp('payment_type').setValue("");
    Ext.getCmp('forex_rate').setValue("");
    Ext.getCmp('currency_code').setValue(null);
    Ext.getCmp('currency_id').setValue(null);
    Ext.getCmp('by_export').setValue(0);
    Ext.getCmp('description').setValue("");
    
    gridInvoice.getSelectionModel().selections.clear();
    
    display_detail_by_export(false, false);
};

Ext.onReady(function(){
    Ext.QuickTips.init();
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    storeCurrencyWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name', 'forex_rate', 'currency_code']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCurrencyWithForexRate/1'
        }),
        autoLoad: true
    });
    
    storeCurrencyWithForexRate.on('beforeload', function(){
        if (Ext.getCmp('currency_code').hasFocus) {
            storeCurrencyWithForexRate.baseParams.type = 'code';
        }
        else {
            storeCurrencyWithForexRate.baseParams.type = 'name';
        }
        storeCurrencyWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });
    
    storeCustomer = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_code', 'subject_name', 'subject_contact_person', 'subject_tax_code', 'subject_address', 'currency_id', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCustomer/1'
        }),
        autoLoad: true
    });
    
    storeCustomer.on('beforeload', function(){
        if (Ext.getCmp('customer_code').hasFocus) {
            storeCustomer.baseParams.type = 'code';
        }
        else {
            storeCustomer.baseParams.type = 'name';
        }
    });
    
    var resultTplCustomer = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{subject_code} | {subject_name}</span><br />', '</div></tpl>');
    
    var resultTplCurrency = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{currency_code} | {currency_name}</span><br />', '</div></tpl>');
    
    FormAction = {
        checkExistedProduct: function(productId, unitId){
            var c = -1;
            for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                var rec = gridDetail.getStore().getAt(i);
                if ((rec.data.product_id == productId) &&
                (rec.data.unit_id == unitId) &&
                rec.data.isChecked) {
                    c++;
                }
            }
            return c;
        },
        checkExistedService: function(serviceId, unitId){
            var c = -1;
            for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                var rec = gridDetail.getStore().getAt(i);
                if ((rec.data.service_id == serviceId) &&
                (rec.data.unit_id == unitId) &&
                rec.data.isChecked) {
                    c++;
                }
            }
            return c;
        },
        addNew: function(){
            clear_form();
            
            status = 'insert';
            Ext.getCmp('by_export').setValue(false);
            Ext.getCmp('for_service').setValue(false);
            Ext.getCmp('by_export').enable();
            Ext.getCmp('for_service').enable();
            Ext.getCmp('btn_save').enable();
            Ext.getCmp('btn_delete').disable();
            Ext.getCmp('reload_detail').disable();
            Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing'));
            
            Ext.getCmp('btn_nheritance').enable();
            
            gridDetail.getStore().baseParams = {
                'salesInvoiceId': null,
                'forexrate': null,
                'currency_id': null,
                'voucherId': null,
                'batchId': null,
                'type': false, // hoa don mua hang thuoc loai ke thua hay khong,
                'inventoryInherId': null,
                'inventoryInherVoucherId': null
            };
        },
        saveNew: function(){
            if ((status == 'insert') && saleBillingTable.getForm().isValid()) {
                var detail = new Array();
                for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                    var isImport = Ext.getCmp('by_export').getValue();
                    var isService = Ext.getCmp('for_service').getValue();
                    var r = gridDetail.getStore().getAt(i);
                    if (r.data.isChecked) {
                        if (isService) {
                            if (FormAction.checkExistedService(r.data.service_id, r.data.unit_id) > 0) {
                                msg('Error'.translator('buy-billing'), 'Existed service'.translator('sale-billing'), Ext.MessageBox.ERROR);
                                return;
                            }
                        }
                        else {
                            if (FormAction.checkExistedProduct(r.data.product_id, r.data.unit_id) > 0) {
                                msg('Error'.translator('buy-billing'), 'Existed product'.translator('sale-billing'), Ext.MessageBox.ERROR);
                                return;
                            }
                        }
                        
                        var record = ({
                            'service_id': r.data.service_id,
                            'product_id': r.data.product_id,
                            'unit_id': r.data.unit_id,
                            'quantity': cN(r.data.quantity),
                            'converted_quantity': cN(r.data.quantity) * cN(r.data.coefficient),
                            'price': cN(r.data.price),
                            'amount': cN(r.data.amount),
                            'converted_amount': cN(r.data.converted_amount),
                            
                            'export_rate_id': isImport && !isService && !isEmpty(r.data.export_rate_id) ? r.data.export_rate_id : 0,
                            'export_rate': isImport && !isService && !isEmpty(r.data.export_rate) ? r.data.export_rate : 0,
                            'export_amount': isImport && !isEmpty(r.data.export_amount) ? cN(r.data.export_amount) : 0,
                            
                            
                            'excise_rate_id': !isImport && !isService && !isEmpty(r.data.excise_rate_id) ? r.data.excise_rate_id : 0,
                            'excise_rate': !isImport && !isService && !isEmpty(r.data.excise_rate) ? r.data.excise_rate : 0,
                            'excise_amount': !isImport && !isEmpty(r.data.excise_amount) ? cN(r.data.excise_amount) : 0,
                            
                            'vat_rate_id': !isEmpty(r.data.vat_rate_id) ? r.data.vat_rate_id : 0,
                            'vat_rate': !isEmpty(r.data.vat_rate) ? r.data.vat_rate : 0,
                            'vat_amount': !isEmpty(r.data.vat_amount) ? cN(r.data.vat_amount) : 0,
                            'total_amount': !isEmpty(r.data.total_amount) ? r.data.total_amount : 0,
                            'note': r.data.note
                        });
                        detail.push(record);
                    }
                }
                insertRecordInvoice(Ext.getCmp('sales_invoice_number').getValue(), Ext.getCmp('sales_invoice_date').getValue(), 
				Ext.getCmp('sales_serial_number').getValue(), Ext.getCmp('customer_id').getValue(), 
				Ext.getCmp('customer_name').getValue(), Ext.getCmp('customer_address').getValue(), 
				Ext.getCmp('customer_tax_code').getValue(), Ext.getCmp('customer_contact').getValue(), 
				Ext.getCmp('payment_type').getValue(), Ext.getCmp('currency_id').getValue(), 
				Ext.getCmp('forex_rate').getValue(), isImport, isService, Ext.getCmp('description').getValue(),
				 Ext.getCmp('cboDebit').getValue(), 
				 Ext.getCmp('cboCreditAmount').getValue(), Ext.getCmp('cboCreditVat').getValue(), 
				 Ext.getCmp('cboCreditExport').getValue(), Ext.getCmp('cboCreditExcise').getValue(),
				gridDetail.getStore().baseParams.type, 
				gridDetail.getStore().baseParams.inventoryInherId, 
				gridDetail.getStore().baseParams.inventoryInherVoucherId, detail);
            }
            else {
                msg('Error'.translator('buy-billing'), 'Check error form'.translator('buy-billing'), Ext.MessageBox.ERROR);
            }
        },
        deleteInvoice: function(){
            if ((status == 'update') && !isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
                var arrRecord = new Array({
                    sales_invoice_id: Ext.getCmp('sales_invoice_id').getValue(),
                    batch_id: gridDetail.getStore().baseParams.batchId,
                    is_inheritanced: Ext.getCmp('is_inheritanced').getValue()
                });
                var record = gridInvoice.getStore().getAt(selectedSaleInvoiceIndex);
                gridInvoice.getStore().remove(record);
                baseDeleteSaleInvoice(arrRecord);
                FormAction.addNew();
                gridInvoice.getSelectionModel().selections.clear();
            }
        }
    };
    
    var generalTab = new Ext.Panel({
        frame: true,
        title: '',
        id: 'generalTab',
        items: [{
            layout: 'column',
            items: [{
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [{
                    xtype: 'hidden',
                    id: 'sales_invoice_id'
                }, {
                    xtype: 'hidden',
                    id: 'is_inheritanced'
                }, {
                    xtype: 'hidden',
                    id: 'is_locked'
                }, {
                    xtype: 'textfield',
                    id: 'sales_serial_number',
                    fieldLabel: 'Invoice Seri Number'.translator('buy-billing'),
                    width: 100,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'sales_invoice_number',
                    fieldLabel: 'Invoice Number'.translator('buy-billing'),
                    width: 100,
                    selectOnFocus: true,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'datefield',
                    width: 100,
                    id: 'sales_invoice_date',
                    fieldLabel: 'Invoice Date'.translator('buy-billing'),
                    format: date_format_string,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'customer_code',
                    store: storeCustomer,
                    fieldLabel: 'Customer Code'.translator('sale-billing'),
                    forceSelection: true,
                    displayField: 'subject_code',
                    valueField: 'subject_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    emptyText: 'Select code a customer'.translator('sale-billing'),
                    tpl: resultTplCustomer,
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    pageSize: 50,
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 350,
                    itemSelector: 'div.search-item',
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('customer_name').setValue(record.data.subject_name);
                                Ext.getCmp('customer_id').setValue(combo.value);
                                Ext.getCmp('customer_address').setValue(record.data.subject_address);
                                Ext.getCmp('customer_tax_code').setValue(record.data.subject_tax_code);
                                Ext.getCmp('customer_contact').setValue(record.data.subject_contact_person);
                                if (record.data.currency_id > 0) {
                                    Ext.getCmp('currency_code').setValue(record.data.currency_id);
                                    Ext.getCmp('currency_id').setValue(record.data.currency_id);
                                    Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
                                    baseChangeForexrate(cN(record.data.forex_rate));
                                }
                                return;
                            }
                            baseUpdateSaleInvoice('customer_id', combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'customer_id',
                    store: storeCustomer,
                    fieldLabel: 'Customer'.translator('sale-billing'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    pageSize: 50,
                    emptyText: 'Select name a customer'.translator('sale-billing'),
                    tpl: resultTplCustomer,
                    selectOnFocus: true,
                    editable: true,
                    width: 300,
                    lazyRender: true,
                    listWidth: 350,
                    itemSelector: 'div.search-item',
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('customer_name').setValue(record.data.subject_name);
                                Ext.getCmp('customer_code').setValue(combo.value);
                                Ext.getCmp('customer_address').setValue(record.data.subject_address);
                                Ext.getCmp('customer_tax_code').setValue(record.data.subject_tax_code);
                                Ext.getCmp('customer_contact').setValue(record.data.subject_contact_person);
                                if (record.data.currency_id > 0) {
                                    Ext.getCmp('currency_code').setValue(record.data.currency_id);
                                    Ext.getCmp('currency_id').setValue(record.data.currency_id);
                                    Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
                                    baseChangeForexrate(cN(record.data.forex_rate));
                                }
                                return;
                            }
                            baseUpdateSaleInvoice(combo.getId(), combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'customer_name',
                    fieldLabel: 'Customer Name'.translator('sale-billing'),
                    width: 300,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'customer_address',
                    fieldLabel: 'Customer Address'.translator('sale-billing'),
                    width: 300,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'customer_tax_code',
                    fieldLabel: 'Supplier Tax code'.translator('buy-billing'),
                    width: 120,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'payment_type',
                    fieldLabel: 'Payment Type'.translator('sale-billing'),
                    width: 120,
                    allowBlank: true,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }]
            }, {
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [new Ext.form.ComboBox({
                    id: 'currency_code',
                    store: storeCurrencyWithForexRate,
                    fieldLabel: 'Currency Code'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_code',
                    valueField: 'currency_id',
                    typeAhead: false,
                    tpl: resultTplCurrency,
                    triggerAction: 'all',
                    emptyText: 'Select code a currency'.translator('buy-billing'),
                    selectOnFocus: true,
                    editable: true,
                    itemSelector: 'div.search-item',
                    width: 150,
                    minChars: 1,
                    pageSize: 50,
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 300,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('currency_id').setValue(combo.value);
                                Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
                                baseChangeForexrate(cN(record.data.forex_rate));
                                return;
                            }
                            baseUpdateSaleInvoice('currency_id', combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'currency_id',
                    store: storeCurrencyWithForexRate,
                    fieldLabel: 'Currency Type'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_name',
                    valueField: 'currency_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    tpl: resultTplCurrency,
                    emptyText: 'Select a currency'.translator('buy-billing'),
                    selectOnFocus: true,
                    editable: true,
                    pageSize: 50,
                    minChars: 1,
                    width: 150,
                    itemSelector: 'div.search-item',
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 300,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('currency_code').setValue(combo.value);
                                Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
                                baseChangeForexrate(cN(record.data.forex_rate));
                                return;
                            }
                            baseUpdateSaleInvoice(combo.getId(), combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'forex_rate',
                    fieldLabel: 'Forex Rate'.translator('buy-billing'),
                    width: 120,
                    allowBlank: false,
                    enableKeyEvents: true,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            if (status == "insert") {
                                baseChangeForexrate(formatNumber(e.getValue()));
                                return;
                            }
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        },
                        keypress: function(my, e){
                            if (!forceNumber(e)) 
                                e.stopEvent();
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'customer_contact',
                    fieldLabel: 'Customer Contact'.translator('buy-billing'),
                    width: 300,
                    allowBlank: true,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textarea',
                    width: 300,
                    height: 50,
                    id: 'description',
                    selectOnFocus: true,
                    fieldLabel: 'Description'.translator('buy-billing'),
                    listeners: {
                        change: function(e){
                            baseUpdateSaleInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Invoice Export'.translator('buy-billing'),
                    labelSeparator: ':',
                    boxLabel: '',
                    id: 'by_export',
                    listeners: {
                        check: function(it, e){
                            if (status == "insert") {
                                display_detail_by_export(e, Ext.getCmp('for_service').getValue());
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                            }
                        }
                    }
                }, {
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Invoice Service'.translator('buy-billing'),
                    labelSeparator: ':',
                    boxLabel: '',
                    id: 'for_service',
                    listeners: {
                        check: function(it, e){
                            if (status == "insert") {
                                if (gridDetail.getStore().getCount() > 2) {
                                    initGridDetail();
                                }
                                display_detail_for_service(e);
                            }
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'cboDebit',
                    typeAhead: true,
                    store: storeAccountList,
                    valueField: 'account_id',
                    displayField: 'account_code',
                    mode: 'local',
                    forceSelection: true,
                    triggerAction: 'all',
                    fieldLabel: 'Tk Nợ',
                    allowBlank: false,
                    editable: true,
                    width: 80,
                    minListWidth: 100,
                    tpl: resultTplAccount,
					itemSelector: 'div.search-item',
					minChars: 1,
                    listWidth: 380,
                    lazyRender: true,
                    selectOnFocus: true
                })]
            }]
        }, gridDetail]
    });
    
    tabsAccounting = new Ext.TabPanel({
        id: 'tabsAccounting',
        width: 987,
        enableTabScroll: true,
        activeTab: 0,
        frame: true,
        tabPosition: 'bottom',
        border: false,
        defaults: {
            autoHeight: true
        },
        items: [{
            title: 'Accounting Amount'.translator('sale-billing'),
            id: 'gridAmount',
            items: [gridAmount]
        }, {
            title: 'Accounting Vat'.translator('sale-billing'),
            id: 'gridVat',
            items: [gridVat]
        }, {
            title: 'Accounting Export'.translator('sale-billing'),
            id: 'gridExport',
            items: [gridExport]
        }]
    });
    
    tabs = new Ext.TabPanel({
        id: 'tabs',
        width: 987,
        enableTabScroll: true,
        activeTab: 0,
        frame: true,
        defaults: {
            autoHeight: true
        },
        items: [{
            title: "General Information".translator('buy-billing'),
            id: 'invoiceInfo',
            items: [generalTab],
            buttons: [{
                id: 'btn_new',
                text: 'Action New'.translator('sale-billing'),
                handler: FormAction.addNew
            }, {
                'id': 'btn_save',
                'text': 'Action Save'.translator('sale-billing'),
                handler: FormAction.saveNew
            }, {
                'id': 'btn_delete',
                'text': 'Action Delete'.translator('sale-billing'),
                handler: FormAction.deleteInvoice
            }]
        },        /*{
         title: 'Accounting Info'.translator('sale-billing'),
         id: 'accountInfo1',
         hidden: true,
         items: [tabsAccounting]
         }, */
        {
            title: "List Invoices".translator('buy-billing'),
            id: 'listInvoice',
            items: [gridInvoice]
        }]
    });
    
    FormAction.addNew();
});

var baseUpdateSaleInvoice = function(field, value){
    if ((status == 'update') && !isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
        var record = gridInvoice.getStore().getAt(selectedSaleInvoiceIndex);
        if (currentPeriodId == record.data.period_id) {
            var isLocked = (record.data.is_locked == 1) ? true : false;
            if (!isLocked) {
                var lastInvoiceDate;
                if (field == 'sales_invoice_date') {
                    lastInvoiceDate = value;
                    value = value.dateFormat(date_sql_format_string);
                }
                if (field == 'forex_rate') {
                    if (value < 0) {
                        Ext.getCmp('forex_rate').setValue(forexRate);
                        msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                        return;
                    }
                    else {
                        forexRate = Ext.getCmp('forex_rate').getValue();
                        value = formatNumber(value);
                    }
                }
                
                Ext.Ajax.request({
                    url: pathRequestUrl + '/updateSaleInvoice/1',
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (result.success) {
                            switch (field) {
                                case 'sales_serial_number':
                                    record.data.sales_serial_number = result.data.sales_serial_number;
                                    Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing') +
                                    " - " +
                                    result.data.sales_serial_number);
                                    break;
                                case 'sales_invoice_number':
                                    record.data.sales_invoice_number = result.data.sales_invoice_number;
                                    break;
                                case 'sales_invoice_date':
                                    record.data.sales_invoice_date = lastInvoiceDate;
                                    break;
                                case 'customer_name':
                                    record.data.customer_name = value;
                                    break;
                                case 'customer_id':
                                    Ext.getCmp('customer_name').setValue(result.data.customer_name);
                                    Ext.getCmp('customer_address').setValue(result.data.customer_address);
                                    Ext.getCmp('customer_tax_code').setValue(result.data.customer_tax_code);
                                    Ext.getCmp('customer_contact').setValue(result.data.customer_contact);
                                    
                                    record.data.customer_id = result.data.customer_id;
                                    record.data.customer_name = result.data.customer_name;
                                    record.data.customer_tax_code = result.data.customer_tax_code;
                                    record.data.customer_contact = result.data.customer_contact;
                                    break;
                                case 'customer_address':
                                    record.data.customer_address = value;
                                    break;
                                case 'customer_tax_code':
                                    record.data.customer_tax_code = value;
                                    break;
                                case 'customer_contact':
                                    record.data.customer_contact = value;
                                    break;
                                case 'payment_type':
                                    record.data.payment_type = value;
                                    break;
                                case 'description':
                                    record.data.description = value;
                                    break;
                                case 'currency_id':
                                    record.data.currency_id = value;
                                    break;
                            }
                            if (field == 'forex_rate') {
                                record.data.currency_id = result.data.currency_id;
                                record.data.forex_rate = result.data.forex_rate;
                                Ext.getCmp('forex_rate').setValue(number_format_extra(result.data.forex_rate, decimals, decimalSeparator, thousandSeparator));
                                if (result.data.change_currency) {
                                    //gridDetailEntry.store.load();
                                    record.data.total_sale_amount = result.data.total_sale_amount;
                                    gridDetail.getStore().baseParams.forexrate = result.data.forex_rate;
                                    gridDetail.getStore().baseParams.currency_id = result.data.currency_id;
                                }
                                else {
                                    warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + $('#currency_id').val() + 'Not forexrate'.translator('buy-billing'));
                                    Ext.getCmp('currency_id').setValue(result.data.currency_id);
                                    Ext.getCmp('currency_code').setValue(result.data.currency_id);
                                    Ext.getCmp('forex_rate').setValue(render_number(result.data.forex_rate));
                                }
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                            }
                            gridInvoice.getView().refresh(true);
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
                        saleInvoiceId: Ext.encode(Ext.getCmp('sales_invoice_id').getValue()),
                        batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
                        convertCurrency: convertedCurrencyId,
                        field: Ext.encode(field),
                        value: Ext.encode(value)
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Locked Invoice'.translator('sale-billing'));
            }
        }
    }
};

var insertRecordInvoice = function(invoiceNumber, invoiceDate, serialNumber, cusId, cusName, cusAddress, cusTaxCode, cusContact, paymentType, 
currencyId, forexRate, 
byExport, forService, description, debitAccountId, creditAmountId, creditVatId, creditExportId, creditExciseId,  
type, inventoryInherId, inventoryInherVoucherId, detail){
    var lastInvoiceDate = invoiceDate;
    invoiceDate = invoiceDate.dateFormat(date_sql_format_string);
    forexRate = formatNumber(forexRate);
    
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertSaleInvoice/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing') + " - " + result.data.purchase_invoice_number);
                var invoiceNewRecord = new invoice_object({
                    'sales_invoice_id': result.data.sales_invoice_id,
                    'sales_invoice_number': result.data.sales_invoice_number,
                    'sales_serial_number': result.data.sales_serial_number,
                    'sales_invoice_date': lastInvoiceDate,
                    'customer_id': result.data.customer_id,
                    'customer_name': result.data.customer_name,
                    'customer_tax_code': result.data.customer_tax_code,
                    'customer_address': result.data.customer_address,
                    'customer_contact': result.data.customer_contact,
                    'payment_type': result.data.payment_type,
                    'currency_id': result.data.currency_id,
                    'forex_rate': result.data.forex_rate,
                    'by_export': result.data.by_export,
                    'for_service': result.data.for_service,
                    'total_sale_amount': result.data.total_sale_amount,
                    'description': result.data.description,
                    'period_id': result.data.period_id,
                    'voucher_id': result.data.voucher_id
                });
                Ext.getCmp('reload_detail').enable();
                Ext.getCmp('sales_invoice_id').setValue(result.data.sales_invoice_id);
                gridInvoice.getStore().insert(gridInvoice.getStore().getCount(), invoiceNewRecord);
                gridInvoice.getView().refresh(true);
				
                //FormAction.addNew();
                msg('Info'.translator('buy-billing'), 'Insert successful'.translator('sale-billing'), Ext.MessageBox.INFO);
                
            }
            else {
            
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
            invoiceNumber: Ext.encode(invoiceNumber),
            invoiceDate: Ext.encode(invoiceDate),
            serialNumber: Ext.encode(serialNumber),
            cusId: Ext.encode(cusId),
            cusName: Ext.encode(cusName),
            cusAddress: Ext.encode(cusAddress),
            cusTaxCode: Ext.encode(cusTaxCode),
            cusContact: Ext.encode(cusContact),
            paymentType: Ext.encode(paymentType),
            currencyId: Ext.encode(currencyId),
            forexrate: Ext.encode(forexRate),
            byExport: Ext.encode(byExport),
            forService: Ext.encode(forService),
            description: Ext.encode(description),
			debitAccountId: Ext.encode(debitAccountId),
			creditAmountId: Ext.encode(creditAmountId),
			creditVatId: Ext.encode(creditVatId),
			creditExportId: Ext.encode(creditExportId),
			creditExciseId: Ext.encode(creditExciseId),
            type: Ext.encode(type),
            inventoryInherId: Ext.encode(inventoryInherId),
            inventoryInherVoucherId: Ext.encode(inventoryInherVoucherId),
            detail: Ext.encode(detail)
        }
    });
};

