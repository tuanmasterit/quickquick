var FormAction;
var resultTplAccount;

var display_detail_for_service = function(forService){
    if (forService) {
        Ext.getCmp('btn_nheritance').disable();
        gridDetail.getColumnModel().setHidden(1, false);
        gridDetail.getColumnModel().setHidden(2, false);
        gridDetail.getColumnModel().setHidden(3, true);
        gridDetail.getColumnModel().setHidden(4, true);
    }
    else {
        Ext.getCmp('btn_nheritance').enable();
        gridDetail.getColumnModel().setHidden(1, true);
        gridDetail.getColumnModel().setHidden(2, true);
        gridDetail.getColumnModel().setHidden(3, false);
        gridDetail.getColumnModel().setHidden(4, false);
    }
};

var display_detail_by_import = function(byImport, forService){
    if (byImport) {
        gridDetail.getColumnModel().setHidden(11, false);
        gridDetail.getColumnModel().setHidden(12, false);
        gridDetail.getColumnModel().setHidden(13, false);
        gridDetail.getColumnModel().setHidden(14, false);
    }
    else {
        gridDetail.getColumnModel().setHidden(11, true);
        gridDetail.getColumnModel().setHidden(12, true);
        gridDetail.getColumnModel().setHidden(13, true);
        gridDetail.getColumnModel().setHidden(14, true);
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
        import_amount: "/0.00/",
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
        purchase_specificity_id: null,
        arr_unit: new Array(),
        quantity: null,
		coefficient: null,
        amount: null,
        converted_amount: null,
        import_rate_id: null,
        import_rate: 0,
        arr_import: new Array(),
        import_amount: null,
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
    
    Ext.getCmp('purchase_invoice_id').setValue("");
    Ext.getCmp('purchase_invoice_number').setValue("");
    Ext.getCmp('purchase_invoice_date').setValue((new Date()).format(date_format_string));
    Ext.getCmp('purchase_serial_number').setValue("");
    Ext.getCmp('purchase_serial_number').focus(true, 1);
    Ext.getCmp('supplier_code').setValue(null);
    Ext.getCmp('supplier_id').setValue(null);
    Ext.getCmp('supplier_name').setValue("");
    Ext.getCmp('supplier_address').setValue("");
    Ext.getCmp('supplier_tax_code').setValue("");
    Ext.getCmp('supplier_contact').setValue("");
    Ext.getCmp('forex_rate').setValue("");
    Ext.getCmp('currency_code').setValue(null);
    Ext.getCmp('currency_id').setValue(null);
    Ext.getCmp('by_import').setValue(0);
    Ext.getCmp('description').setValue("");
    
    gridInvoice.getSelectionModel().selections.clear();
    
    display_detail_by_import(false, false);
};

Ext.onReady(function(){
    Ext.QuickTips.init();
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    var resultTplSupplierCode = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{subject_code} | {subject_name}</span><br />', '</div></tpl>');
    
    var resultTplCurrencyCode = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{currency_code} | {currency_name}</span><br />', '</div></tpl>');
    resultTplAccount = new Ext.XTemplate('<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:40px;">{account_code}</div><div style="float:left; text-align:left;">| </div><div>{account_name}</div></div></tpl>');
    
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
                    id: 'purchase_invoice_id'
                }, {
                    xtype: 'hidden',
                    id: 'is_locked'
                }, {
                    xtype: 'textfield',
                    id: 'purchase_serial_number',
                    fieldLabel: 'Invoice Seri Number'.translator('buy-billing'),
                    width: 100,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'purchase_invoice_number',
                    fieldLabel: 'Invoice Number'.translator('buy-billing'),
                    width: 100,
                    selectOnFocus: true,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'datefield',
                    width: 100,
                    id: 'purchase_invoice_date',
                    fieldLabel: 'Invoice Date'.translator('buy-billing'),
                    format: date_format_string,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'supplier_code',
                    store: storeSupplierCodeWithForexRate,
                    fieldLabel: 'Supplier Code'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'subject_code',
                    valueField: 'subject_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    emptyText: 'Select code a supplier'.translator('buy-billing'),
                    tpl: resultTplSupplierCode,
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
                                var objectSupplier = storeSupplierCodeWithForexRate.queryBy(function(rec){
                                    return rec.data.subject_id == combo.value;
                                });
                                Ext.getCmp('supplier_name').setValue(objectSupplier.itemAt(0).data.subject_name);
                                Ext.getCmp('supplier_id').setValue(combo.value);
                                Ext.getCmp('supplier_address').setValue(objectSupplier.itemAt(0).data.subject_address);
                                Ext.getCmp('supplier_tax_code').setValue(objectSupplier.itemAt(0).data.subject_tax_code);
                                Ext.getCmp('supplier_contact').setValue(objectSupplier.itemAt(0).data.subject_contact_person);
                                if (objectSupplier.itemAt(0).data.currency_id > 0) {
                                    Ext.getCmp('currency_id').setValue(objectSupplier.itemAt(0).data.currency_id);
                                    Ext.getCmp('currency_code').setValue(objectSupplier.itemAt(0).data.currency_id);
                                    Ext.getCmp('forex_rate').setValue(render_number(objectSupplier.itemAt(0).data.forex_rate));
                                }
                                return;
                            }
                            baseUpdatePurchaseInvoice('supplier_id', combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'supplier_id',
                    store: storeSupplierNameWithForexRate,
                    fieldLabel: 'Supplier'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    pageSize: 50,
                    emptyText: 'Select name a supplier'.translator('buy-billing'),
                    tpl: resultTplSupplierCode,
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
                                var objectSupplier = storeSupplierNameWithForexRate.queryBy(function(rec){
                                    return rec.data.subject_id == combo.value;
                                });
                                Ext.getCmp('supplier_name').setValue(objectSupplier.itemAt(0).data.subject_name);
                                Ext.getCmp('supplier_code').setValue(combo.value);
                                Ext.getCmp('supplier_address').setValue(objectSupplier.itemAt(0).data.subject_address);
                                Ext.getCmp('supplier_tax_code').setValue(objectSupplier.itemAt(0).data.subject_tax_code);
                                Ext.getCmp('supplier_contact').setValue(objectSupplier.itemAt(0).data.subject_contact_person);
                                if (objectSupplier.itemAt(0).data.currency_id > 0) {
                                    Ext.getCmp('currency_code').setValue(objectSupplier.itemAt(0).data.currency_id);
                                    Ext.getCmp('currency_id').setValue(objectSupplier.itemAt(0).data.currency_id);
                                    Ext.getCmp('forex_rate').setValue(render_number(objectSupplier.itemAt(0).data.forex_rate));
                                    baseChangeForexrate(cN(objectSupplier.itemAt(0).data.forex_rate));
                                }
                                return;
                            }
                            baseUpdatePurchaseInvoice(combo.getId(), combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'supplier_name',
                    fieldLabel: 'Supplier Name'.translator('buy-billing'),
                    width: 300,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'supplier_address',
                    fieldLabel: 'Supplier Address'.translator('buy-billing'),
                    width: 300,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'supplier_tax_code',
                    fieldLabel: 'Supplier Tax code'.translator('buy-billing'),
                    width: 120,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, ]
            }, {
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [new Ext.form.ComboBox({
                    id: 'currency_code',
                    store: storeCurrencyCodeWithForexRate,
                    fieldLabel: 'Currency Code'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_code',
                    valueField: 'currency_id',
                    typeAhead: false,
                    tpl: resultTplCurrencyCode,
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
                                var objectCurrency = storeCurrencyCodeWithForexRate.queryBy(function(rec){
                                    return rec.data.currency_id == combo.value;
                                });
                                Ext.getCmp('currency_id').setValue(combo.value);
                                Ext.getCmp('currency_code').setValue(combo.value);
                                Ext.getCmp('forex_rate').setValue(render_number(objectCurrency.itemAt(0).data.forex_rate));
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                                return;
                            }
                            baseUpdatePurchaseInvoice('currency_id', combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'currency_id',
                    store: storeCurrencyNameWithForexRate,
                    fieldLabel: 'Currency Type'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_name',
                    valueField: 'currency_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    tpl: resultTplCurrencyCode,
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
                                var objectCurrency = storeCurrencyNameWithForexRate.queryBy(function(rec){
                                    return rec.data.currency_id == combo.value;
                                });
                                Ext.getCmp('currency_code').setValue(combo.value);
                                Ext.getCmp('forex_rate').setValue(render_number(objectCurrency.itemAt(0).data.forex_rate));
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                                return;
                            }
                            baseUpdatePurchaseInvoice(combo.getId(), combo.value);
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
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        },
                        keypress: function(my, e){
                            if (!forceNumber(e)) 
                                e.stopEvent();
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'supplier_contact',
                    fieldLabel: 'Supplier Contact'.translator('buy-billing'),
                    width: 300,
                    allowBlank: true,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
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
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Invoice Import'.translator('buy-billing'),
                    labelSeparator: ':',
                    boxLabel: '',
                    id: 'by_import',
                    listeners: {
                        check: function(it, e){
                            if (status == "insert") {
                                display_detail_by_import(e, Ext.getCmp('for_service').getValue());
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
                    id: 'cboCredit',
                    typeAhead: true,
                    //labelStyle: 'text-align: right',
                    store: null,
                    valueField: 'account_id',
                    displayField: 'account_code',
                    mode: 'local',
                    forceSelection: true,
                    triggerAction: 'all',
                    fieldLabel: 'Tk Có',
					allowBlank: false,
                    editable: false,
                    width: 80,
                    minListWidth: 100,
                    tpl: resultTplAccount,
                    listWidth: 380,
                    lazyRender: true,
                    selectOnFocus: true
                })]
            }]
        }, gridDetail]
    });
    
    var clearAccountingGrid = function(field, value){
        grid2.getStore().removeAll();
        grid2.topToolbar.items.get('lblDebit_2').setText("");
        grid2.topToolbar.items.get('lblCredit_2').setText("");
        grid2.getStore().baseParams = {
            batchId: null
        };
        grid23.getStore().removeAll();
        grid23.topToolbar.items.get('lblDebit_23').setText("");
        grid23.topToolbar.items.get('lblCredit_23').setText("");
        grid23.getStore().baseParams = {
            batchId: null
        };
        grid24.getStore().removeAll();
        grid24.topToolbar.items.get('lblDebit_24').setText("");
        grid24.topToolbar.items.get('lblCredit_24').setText("");
        grid24.getStore().baseParams = {
            batchId: null
        };
        grid1.getStore().removeAll();
        grid1.topToolbar.items.get('lblDebit_1').setText("");
        grid1.topToolbar.items.get('lblCredit_1').setText("");
        grid1.getStore().baseParams = {
            batchId: null
        };
        grid3.getStore().removeAll();
        grid3.topToolbar.items.get('lblDebit_3').setText("");
        grid3.topToolbar.items.get('lblCredit_3').setText("");
        grid3.getStore().baseParams = {
            batchId: null
        };
        grid22.getStore().removeAll();
        grid22.topToolbar.items.get('lblDebit_22').setText("");
        grid22.topToolbar.items.get('lblCredit_22').setText("");
        grid22.getStore().baseParams = {
            batchId: null
        };
    };
    
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
        checkErrorSpecificity: function(){
            for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                if (isEmpty(gridDetail.getStore().getAt(i).data.purchase_specificity_id) &&
                gridDetail.getStore().getAt(i).data.isChecked) {
                    return false;
                }
            }
            return true;
        },
        addNew: function(){
            clear_form();
            
            status = 'insert';
            Ext.getCmp('by_import').setValue(false);
            Ext.getCmp('for_service').setValue(false);
            Ext.getCmp('by_import').enable();
            Ext.getCmp('for_service').enable();
            Ext.getCmp('btn_save').enable();
            Ext.getCmp('btn_delete').disable();
            Ext.getCmp('reload_detail').disable();
            Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing'));
            
            Ext.getCmp('btn_nheritance').enable();
            
            gridDetail.getStore().baseParams = {
                'purchaseInvoiceId': null,
                'forexrate': null,
                'currency_id': null,
                'voucherId': null,
				'batchId': null,
                'type': false, // hoa don mua hang thuoc loai ke thua hay khong,
                'arrayInventoryId': new Array()
            };
        },
        saveNew: function(){
            if ((status == 'insert') && buyBillingTable.getForm().isValid()) {
                if (FormAction.checkErrorSpecificity()) {
                    var detail = new Array();
                    for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                        var isImport = Ext.getCmp('by_import').getValue();
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
                                'purchase_specificity_id': r.data.purchase_specificity_id,
                                'quantity': cN(r.data.quantity),
								'converted_quantity': cN(r.data.quantity) * cN(r.data.coefficient),
                                'price': cN(r.data.price),
                                'amount': cN(r.data.amount),
                                'converted_amount': cN(r.data.converted_amount),
                                'import_rate_id': isImport && !isService && !isEmpty(r.data.import_rate_id) ? r.data.import_rate_id : 0,
                                'import_rate': isImport && !isService && !isEmpty(r.data.import_rate) ? r.data.import_rate : 0,
                                'import_amount': isImport && !isEmpty(r.data.import_amount) ? cN(r.data.import_amount) : 0,
                                'excise_rate_id': isImport && !isService && !isEmpty(r.data.excise_rate_id) ? r.data.excise_rate_id : 0,
                                'excise_rate': isImport && !isService && !isEmpty(r.data.excise_rate) ? r.data.excise_rate : 0,
                                'excise_amount': isImport && !isEmpty(r.data.excise_amount) ? cN(r.data.excise_amount) : 0,
                                'vat_rate_id': !isEmpty(r.data.vat_rate_id) ? r.data.vat_rate_id : 0,
                                'vat_rate': !isEmpty(r.data.vat_rate) ? r.data.vat_rate : 0,
                                'vat_amount': !isEmpty(r.data.vat_amount) ? cN(r.data.vat_amount) : 0,
                                'total_amount': !isEmpty(r.data.total_amount) ? r.data.total_amount : 0,
                                'note': r.data.note
                            });
                            detail.push(record);
                        }
                    }
                    insertRecordInvoice(Ext.getCmp('purchase_invoice_number').getValue(), Ext.getCmp('purchase_invoice_date').getValue(), Ext.getCmp('purchase_serial_number').getValue(), Ext.getCmp('supplier_id').getValue(), Ext.getCmp('supplier_name').getValue(), Ext.getCmp('supplier_address').getValue(), Ext.getCmp('supplier_tax_code').getValue(), Ext.getCmp('supplier_contact').getValue(), Ext.getCmp('currency_id').getValue(), Ext.getCmp('forex_rate').getValue(), isImport, isService, Ext.getCmp('description').getValue(), gridDetail.getStore().baseParams.type, gridDetail.getStore().baseParams.arrayInventoryId, detail);
                }
                else {
                    msg('Error'.translator('buy-billing'), 'Specificity not null'.translator('buy-billing'), Ext.MessageBox.ERROR);
                    return;
                }
            }
            else {
                msg('Error'.translator('buy-billing'), 'Check error form'.translator('buy-billing'), Ext.MessageBox.ERROR);
            }
        },
        deleteInvoice: function(){
            if ((status == 'update') && !isEmpty(Ext.getCmp('purchase_invoice_id').getValue())) {
                var arrRecord = new Array({
                    purchase_invoice_id: Ext.getCmp('purchase_invoice_id').getValue()
                });
                var record = gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex);
                gridInvoice.getStore().remove(record);
                baseDeletePurchaseInvoice(arrRecord);
                FormAction.addNew();
                clearAccountingGrid();
                gridInvoice.getSelectionModel().selections.clear();
            }
        },
        cancel: function(){
            FormAction.addNew();
        }
    };
    
    tabsAccounting1 = new Ext.TabPanel({
        id: 'tabsAccounting1',
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
            title: "Accounting I 1".translator('buy-billing'),
            id: 'grid2',
            items: [grid2]
        }, {
            title: "Accounting I 2".translator('buy-billing'),
            id: 'grid23',
            items: [grid23]
        }, {
            title: "Accounting I 3".translator('buy-billing'),
            id: 'grid24',
            items: [grid24]
        }, {
            title: "Accounting I 4".translator('buy-billing'),
            id: 'grid1',
            items: [grid1]
        }]
    });
    
    tabsAccounting2 = new Ext.TabPanel({
        id: 'tabsAccounting2',
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
            title: "Accounting Not 1".translator('buy-billing'),
            id: 'grid22',
            items: [grid22]
        }, {
            title: "Accounting Not 2".translator('buy-billing'),
            id: 'grid3',
            items: [grid3]
        }]
    });
    
    tabsExpense = new Ext.TabPanel({
        id: 'tabsExpense',
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
            title: "Invoice Expense".translator('buy-billing'),
            id: 'invoiceExpense',
            items: [gridCost]
        }, {
            title: "Payable Expense".translator('buy-billing'),
            id: 'cashExpense',
            items: [gridCash]
        }, {
            title: "No Expense".translator('buy-billing'),
            id: 'noExpense',
            items: [gridNo]
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
        }, {
            title: "Info Expense".translator('buy-billing'),
            id: 'infoExpense',
            items: [tabsExpense, {
                layout: 'form',
                labelWidth: 170,
                frame: true,
                items: [{
                    xtype: 'radiogroup',
                    fieldLabel: 'Distribution Coefficient'.translator('buy-billing'),
                    id: 'coefficient',
                    columns: 5,
                    items: [{
                        boxLabel: 'Qty'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 1
                    }, {
                        boxLabel: 'Converted Qty'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 2
                    }, {
                        boxLabel: 'Sale Price'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 3
                    }, {
                        boxLabel: 'Amount'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 4
                    }, {
                        boxLabel: 'Converted Amount'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 5
                    }, {
                        boxLabel: 'Import Rate'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 6
                    }, {
                        boxLabel: 'Excise Rate'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 7
                    }, {
                        boxLabel: 'Vat Rate'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 8
                    }, {
                        boxLabel: 'Total Amount'.translator('buy-billing'),
                        name: 'rb-group',
                        inputValue: 9
                    }],
                    listeners: {
                        change: function(e){
                            if (!isEmpty(e.getValue())) {
                                baseUpdateDetailExpense(e.getValue().inputValue);
                            }
                        }
                    }
                }, gridDetailExpense]
            }]
        }, {
            title: "Accounting Expense".translator('buy-billing'),
            id: 'accountingExpense',
            items: [gridAccCost]
        }, {
            title: "Accounting Import".translator('buy-billing'),
            id: 'accountInfo1',
            items: [tabsAccounting1]
        }, {
            title: "Accounting Not Import".translator('buy-billing'),
            id: 'accountInfo2',
            items: [tabsAccounting2]
        }, {
            title: "List Invoices".translator('buy-billing'),
            id: 'listInvoice',
            items: [gridInvoice]
        }]
    });
    
    FormAction.addNew();
});

var baseUpdatePurchaseInvoice = function(field, value){
    if ((status == 'update') && !isEmpty(Ext.getCmp('purchase_invoice_id').getValue())) {
        var record = gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex);
        if (currentPeriodId == record.data.period_id) {
            var isLocked = (record.data.is_locked == 1) ? true : false;
            if (!isLocked) {
                var lastInvoiceDate;
                if (field == 'purchase_invoice_date') {
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
                    url: pathRequestUrl + '/updatePurchase/' +
                    Ext.getCmp('purchase_invoice_id').getValue(),
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (result.success) {
                            var record = gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex);
                            switch (field) {
                                case 'purchase_serial_number':
                                    record.data.purchase_serial_number = result.data.purchase_serial_number;
                                    break;
                                case 'purchase_invoice_number':
                                    record.data.purchase_invoice_number = result.data.purchase_invoice_number;
                                    Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing') + " - " + result.data.purchase_invoice_number);
                                    break;
                                case 'purchase_invoice_date':
                                    record.data.purchase_invoice_date = lastInvoiceDate;
                                    break;
                                case 'supplier_name':
                                    record.data.supplier_name = value;
                                    break;
                                case 'supplier_id':
                                    Ext.getCmp('supplier_name').setValue(result.data.supplier_name);
                                    Ext.getCmp('supplier_address').setValue(result.data.supplier_address);
                                    Ext.getCmp('supplier_tax_code').setValue(result.data.supplier_tax_code);
                                    Ext.getCmp('supplier_contact').setValue(result.data.supplier_contact);
                                    
                                    record.data.supplier_id = result.data.supplier_id;
                                    record.data.supplier_name = result.data.supplier_name;
                                    record.data.supplier_tax_code = result.data.supplier_tax_code;
                                    record.data.supplier_contact = result.data.supplier_contact;                                   
                                    break;
                                case 'supplier_address':
                                    record.data.supplier_address = value;
                                    break;
                                case 'supplier_tax_code':
                                    record.data.supplier_tax_code = value;
                                    break;
                                case 'supplier_contact':
                                    record.data.supplier_contact = value;
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
                                    record.data.total_purchase_amount = result.data.total_purchase_amount;
                                    gridDetail.getStore().baseParams.forexrate = result.data.forex_rate;
                                    gridDetail.getStore().baseParams.currency_id = result.data.currency_id;
                                }
                                else {
                                    warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + $('#currency_id').val() + 'Not forexrate'.translator('buy-billing'));
                                    Ext.getCmp('currency_id').setValue(result.data.currency_id);
                                    Ext.getCmp('forex_rate').setValue(render_number(result.data.forex_rate));
                                }
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                                baseGetBatchOfPurchase(record.data.voucher_id, record.data.by_import, record.data.for_service);
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
                        convertCurrency: convertedCurrencyId,
                        field: Ext.encode(field),
                        value: Ext.encode(value)
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'hoa don mua hang da khoa?'.translator('buy-billing'));
            }
        }
        else {
            warning('Warning'.translator('buy-billing'), 'Not in current period'.translator('buy-billing'));
        }
    }
};

var insertRecordInvoice = function(invoiceNumber, invoiceDate, serialNumber, suppId, suppName, suppAddress, suppTaxCode, suppContact, currencyId, forexRate, byImport, forService, description, type, arrayInventoryId, detail){
    var lastInvoiceDate = invoiceDate;
    invoiceDate = invoiceDate.dateFormat(date_sql_format_string);
    forexRate = formatNumber(forexRate);
    
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertPurchaseInvoice/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing') + " - " + result.data.purchase_invoice_number);
                var invoiceNewRecord = new invoice_object({
                    'purchase_invoice_id': result.data.purchase_invoice_id,
                    'purchase_invoice_number': result.data.purchase_invoice_number,
                    'purchase_serial_number': result.data.purchase_serial_number,
                    'purchase_invoice_date': lastInvoiceDate,
                    'supplier_id': result.data.supplier_id,
                    'supplier_name': result.data.supplier_name,
                    'supplier_tax_code': result.data.supplier_tax_code,
                    'supplier_address': result.data.supplier_address,
                    'supplier_contact': result.data.supplier_contact,
                    'currency_id': result.data.currency_id,
                    'forex_rate': result.data.forex_rate,
                    'by_import': result.data.by_import,
                    'for_service': result.data.for_service,
                    'total_purchase_amount': result.data.total_purchase_amount,
                    'description': result.data.description,
                    'period_id': result.data.period_id,
                    'voucher_id': result.data.voucher_id
                });
                Ext.getCmp('reload_detail').enable();
                Ext.getCmp('purchase_invoice_id').setValue(result.data.purchase_invoice_id);
                
                
                
                if (result.data.for_service == 1) {
                    storeListServiceInvoiceNotDistribution.removeAll();
                    storeListServiceInvoiceNotDistribution.load();
                }
                
                FormAction.addNew();
                msg('Info'.translator('buy-billing'), 'Insert successful'.translator('buy-billing'), Ext.MessageBox.INFO);
                gridInvoice.getStore().insert(gridInvoice.getStore().getCount(), invoiceNewRecord);
                gridInvoice.getView().refresh(true);
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
            suppId: Ext.encode(suppId),
            suppName: Ext.encode(suppName),
            suppAddress: Ext.encode(suppAddress),
            suppTaxCode: Ext.encode(suppTaxCode),
            suppContact: Ext.encode(suppContact),
            currencyId: Ext.encode(currencyId),
            forexrate: Ext.encode(forexRate),
            byImport: Ext.encode(byImport),
            forService: Ext.encode(forService),
            description: Ext.encode(description),
            type: Ext.encode(type),
            arrayInventoryId: Ext.encode(arrayInventoryId),
            detail: Ext.encode(detail)
        }
    });
};
