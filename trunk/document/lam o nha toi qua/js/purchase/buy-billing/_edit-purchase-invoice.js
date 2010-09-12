var date_format_string = 'd/m/Y';
var date_sql_format_string = 'Y-m-d';
var selectedPurchaseInvoiceId;
var selectedPurchaseInvoiceIndex;
var forexRate = 0.0;
var currencyType = 0;

Ext.onReady(function(){
    Ext.QuickTips.init();
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
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
                    xtype: 'textfield',
                    id: 'purchase_invoice_number',
                    fieldLabel: 'Invoice Number'.translator('buy-billing'),
                    width: 300,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                            gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex).data.purchase_invoice_number = e.getValue();
                            gridInvoice.getView().refresh(true);
                        }
                    }
                }, {
                    xtype: 'datefield',
                    width: 120,
                    labelSeparator: '',
                    id: 'purchase_invoice_date',
                    fieldLabel: 'Invoice Date'.translator('buy-billing'),
                    format: date_format_string,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                            gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex).data.purchase_invoice_date_format = e.getValue();
                            gridInvoice.getView().refresh(true);
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'supplier_id',
                    store: storeSupplierWithForexRate,
                    fieldLabel: 'Supplier'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select a supplier'.translator('buy-billing'),
                    selectOnFocus: true,
                    editable: false,
                    width: 300,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdatePurchaseInvoice(combo.getId(), combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'supplier_name',
                    fieldLabel: 'Supplier Name'.translator('buy-billing'),
                    width: 300,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                            gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex).data.supplier_name = e.getValue();
                            gridInvoice.getView().refresh(true);
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'supplier_address',
                    fieldLabel: 'Supplier Address'.translator('buy-billing'),
                    width: 300,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                            gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex).data.supplier_address = e.getValue();
                            gridInvoice.getView().refresh(true);
                        }
                    }
                }, {
                    xtype: 'textfield',
                    id: 'supplier_tax_code',
                    fieldLabel: 'Supplier Tax code'.translator('buy-billing'),
                    width: 120,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                            gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex).data.supplier_tax_code = e.getValue();
                            gridInvoice.getView().refresh(true);
                        }
                    }
                }]
            }, {
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [{
                    xtype: 'textfield',
                    id: 'supplier_contact',
                    fieldLabel: 'Supplier Contact'.translator('buy-billing'),
                    width: 300,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                            gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex).data.supplier_contact = e.getValue();
                            gridInvoice.getView().refresh(true);
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'currency_id',
                    store: storeCurrencyWithForexRate,
                    fieldLabel: 'Currency Type'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_name',
                    valueField: 'currency_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select a currency',
                    selectOnFocus: true,
                    editable: false,
                    width: 300,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            var objectCurrency = storeCurrencyWithForexRate.queryBy(function(rec){
                                return rec.data.currency_id == combo.value;
                            });
                            if (parseFloat(objectCurrency.itemAt(0).data.forex_rate) <= 0) {
                                warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + $('#currency_id').val() + 'Not forexrate'.translator('buy-billing'));
                                Ext.getCmp('currency_id').setValue(currencyType);
                                Ext.getCmp('forex_rate').setValue(forexRate);
                            }
                            else {
                                Ext.getCmp('forex_rate').setValue(objectCurrency.itemAt(0).data.forex_rate);
                                forexRate = objectCurrency.itemAt(0).data.forex_rate;
                                currencyType = objectCurrency.itemAt(0).data.currency_id;
                                baseUpdatePurchaseInvoice(combo.getId(), combo.value);
                            }
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'forex_rate',
                    fieldLabel: 'Forex Rate'.translator('buy-billing'),
                    width: 120,
                    allowBlank: false,
					enableKeyEvents: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        },
                        keypress: function(my, e){
                            if (!forceNumber(e)) 
                                e.stopEvent();
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
                            display_detail_by_import(e ? 1 : null);
                            if (!isEmpty(gridDetailEntry.getStore().baseParams.purchaseInvoiceId) &&
                            (selectedPurchaseInvoiceId == gridDetailEntry.getStore().baseParams.purchaseInvoiceId)) {
                                Ext.Ajax.request({
                                    url: pathRequestUrl + '/updateByImportOfPurchase/' + gridDetailEntry.getStore().baseParams.purchaseInvoiceId,
                                    method: 'post',
                                    success: function(result, options){
                                        var result = Ext.decode(result.responseText);
                                        if (result.success) {
                                            var record = gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex);
                                            record.data.by_import_format = e;
											record.data.by_import_format = e ? 1 : 0;
                                            record.data.arr_batch = result.data;
                                            gridInvoice.getView().refresh(true);
                                            display_accounting_by_import(record, e ? 1 : 0);
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
                                        voucherId: Ext.encode(gridDetailEntry.getStore().baseParams.voucherId),
                                        field: Ext.encode(it.id),
                                        value: Ext.encode(e ? 1 : 0)
                                    }
                                });
                            }
                        }
                    }
                }, {
                    xtype: 'textarea',
                    width: 300,
                    height: 60,
                    id: 'description',
                    fieldLabel: 'Description'.translator('buy-billing'),
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInvoice(e.getId(), e.getValue());
                        }
                    }
                }]
            }]
        }, gridDetailEntry]
    });
    
    var accountingTab = new Ext.Panel({
        frame: true,
        title: ''
    });
    
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
            title: "Imported goods".translator('buy-billing'),
            id: 'purchaseImport',
            items: [gridEntryDebit]
        }, {
            title: "Vat imported goods".translator('buy-billing'),
            id: 'vatImportGood',
            items: [gridImportGood]
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
            title: "Domestic invoice".translator('buy-billing'),
            id: 'purchaseDomestic',
            items: [gridDomestic]
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
            title: "List Invoices".translator('buy-billing'),
            id: 'listInvoice',
            items: [gridInvoice]
        }, {
            title: "General Information".translator('buy-billing'),
            id: 'invoiceInfo',
            items: [generalTab],
            disabled: true
        }, {
            title: "Accounting information".translator('buy-billing'),
            id: 'accountInfo',
            items: [tabsAccounting1, tabsAccounting2],
            disabled: true
        }]
    });
});

var reload_accounting = function(type){
    if (type == 1) {
        storeEntryDebit.removeAll();
        storeEntryDebit.load();
        //gridEntryDebit.getView().refresh(true);
		storeImportGood.removeAll();
        storeImportGood.load();
        //gridImportGood.getView().refresh(true);
    }
    else {
    	storeDomestic.removeAll();
        storeDomestic.load();
        //gridDomestic.getView().refresh(true);
    }
};

var baseUpdatePurchaseInvoice = function(field, value){

    if (field == 'purchase_invoice_date') {
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
        url: pathRequestUrl + '/updatePurchase/' + selectedPurchaseInvoiceId,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                var record = gridInvoice.getStore().getAt(selectedPurchaseInvoiceIndex);
                if (field == 'supplier_id') {
                    Ext.getCmp('supplier_name').setValue(result.data.supplier_name);
                    Ext.getCmp('supplier_address').setValue(result.data.supplier_address);
                    Ext.getCmp('supplier_tax_code').setValue(result.data.supplier_tax_code);
                    Ext.getCmp('supplier_contact').setValue(result.data.supplier_contact);
                    Ext.getCmp('forex_rate').setValue(result.data.forex_rate);
                    
                    if (result.data.change_currency) {
                        Ext.getCmp('currency_id').setValue(result.data.currency_id);
                        gridDetailEntry.store.load();
                        record.data.total_purchase_amount = result.data.total_purchase_amount;
                    }
                    else {
                        var currencyName = storeSupplierWithForexRate.queryBy(function(rec){
                            return rec.data.subject_id == value;
                        }).itemAt(0).data.currency_name;
                        warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + currencyName + 'Not forexrate'.translator('buy-billing'));
                    }
                    
                    record.data.supplier_id = result.data.supplier_id;
                    record.data.supplier_name = result.data.supplier_name;
                    record.data.supplier_tax_code = result.data.supplier_tax_code;
                    record.data.supplier_contact = result.data.supplier_contact;
                    record.data.currency_id = result.data.currency_id;
                    record.data.forex_rate = result.data.forex_rate;
                }
                else 
                    if (field == 'currency_id' || field == 'forex_rate') {
                        record.data.currency_id = result.data.currency_id;
                        record.data.forex_rate = result.data.forex_rate;
						Ext.getCmp('forex_rate').setValue(result.data.forex_rate);
                        if (result.data.change_currency) {
                            gridDetailEntry.store.load();
                            record.data.total_purchase_amount = result.data.total_purchase_amount;
                        }
                        reload_accounting(Ext.getCmp('by_import').getValue() ? 1 : 0);
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
};
