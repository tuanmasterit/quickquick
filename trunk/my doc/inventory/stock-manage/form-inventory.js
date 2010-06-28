var storeDepartment;
var isLoadedSubIn = false;
var storeSubjectIn;
var isLoadedSubOut = false;
var storeSubjectOut;
var isLoadedSubInter = false;
var storeSubjectInter;
var storeSubject;

Ext.onReady(function(){
    Ext.QuickTips.init();
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    storeDepartment = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'department_id',
            fields: ['department_id', 'department_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListDepartment/1'
        }),
        autoLoad: false
    });
    
    storeDepartment.on('load', function(){
        storeDepartment.insert(0, new Ext.data.Record({
            department_id: 0,
            department_name: ''
        }));
        if (!isEmpty(storeDepartment.baseParams.currentDepartmentId)) 
            Ext.getCmp('department_id').setValue(storeDepartment.baseParams.currentDepartmentId);
    });
    
    storeSubjectIn = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'department_id',
            fields: ['subject_id', 'subject_name', 'subject_contact_person']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubject/1'
        }),
        autoLoad: false
    });
    
    storeSubjectIn.on('load', function(){
        storeSubjectIn.insert(0, new Ext.data.Record({
            subject_id: 0,
            subject_name: ''
        }));
        storeSubjectIn.each(function(r){
            storeSubject.add(r.copy());
        });
        if (!isEmpty(storeSubjectIn.baseParams.currentSubjectId)) 
            Ext.getCmp('subject_id').setValue(storeSubjectIn.baseParams.currentSubjectId);
    });
    
    storeSubjectOut = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'department_id',
            fields: ['subject_id', 'subject_name', 'subject_contact_person']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubject/2'
        }),
        autoLoad: false
    });
    
    storeSubjectOut.on('load', function(){
        storeSubjectOut.insert(0, new Ext.data.Record({
            subject_id: 0,
            subject_name: ''
        }));
        storeSubjectOut.each(function(r){
            storeSubject.add(r.copy());
        });
        if (!isEmpty(storeSubjectOut.baseParams.currentSubjectId)) 
            Ext.getCmp('subject_id').setValue(storeSubjectOut.baseParams.currentSubjectId);
    });
    
    storeSubjectInter = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'department_id',
            fields: ['subject_id', 'subject_name', 'subject_contact_person']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubject/3'
        }),
        autoLoad: false
    });
    
    storeSubjectInter.on('load', function(){
        storeSubjectInter.insert(0, new Ext.data.Record({
            subject_id: 0,
            subject_name: ''
        }));
        storeSubjectInter.each(function(r){
            storeSubject.add(r.copy());
        });
        if (!isEmpty(storeSubjectInter.baseParams.currentSubjectId)) 
            Ext.getCmp('subject_id').setValue(storeSubjectInter.baseParams.currentSubjectId);
    });
    
    storeSubject = new Ext.data.ArrayStore({
        fields: [{
            name: 'subject_id'
        }, {
            name: 'subject_name'
        }, {
            name: 'subject_contact_person'
        }]
    });
    
    generalTab = new Ext.Panel({
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
                    id: 'inventory_voucher_number',
                    fieldLabel: 'Inventory Voucher Number'.translator('stock-manage'),
                    width: 300,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdateInventoryVoucher(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'datefield',
                    width: 120,
                    labelSeparator: '',
                    id: 'inventory_voucher_date',
                    fieldLabel: 'Inventory Voucher Date'.translator('stock-manage'),
                    format: date_format_string,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdateInventoryVoucher(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'radiogroup',
                    fieldLabel: 'Type Vote'.translator('stock-manage'),
                    id: 'in_out',
                    //width: 300,
                    items: [{
                        boxLabel: 'Input'.translator('stock-manage'),
                        name: 'rb-auto',
                        width: 100,
                        inputValue: 1
                    }, {
                        boxLabel: 'Output'.translator('stock-manage'),
                        name: 'rb-auto',
                        inputValue: 2
                    }, {
                        boxLabel: 'Internal transport'.translator('stock-manage'),
                        name: 'rb-auto',
                        inputValue: 3
                    }],
                    listeners: {
                        change: function(e){
                            Ext.Ajax.request({
                                url: pathRequestUrl + '/updateTypeVoteOfPurchase/' + gridDetail.getStore().baseParams.inventoryVoucherId,
                                method: 'post',
                                success: function(result, options){
                                    var result = Ext.decode(result.responseText);
                                    if (result.success) {
                                        Ext.getCmp('in_warehouse_id').setValue(0);
                                        Ext.getCmp('out_warehouse_id').setValue(0);
                                        Ext.getCmp('subject_contact').setValue('');
                                        setLabelInOut(e.getValue().inputValue);
                                        set_subject_by_inout(e.getValue().inputValue, 0);
                                        gridAccounting.getStore().removeAll();
                                        gridAccounting.getStore().load();
                                        gridAccounting.getView().refresh(true);
                                        var record = gridInventory.getStore().getAt(selectedInventoryIndex);
                                        record.data.in_warehouse_id = 0;
                                        record.data.out_warehouse_id = 0;
                                        record.data.in_out = e.getValue().inputValue;
                                        gridInventory.getView().refresh(true);
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
                                    voucherId: Ext.encode(gridDetail.getStore().baseParams.voucherId),
                                    batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
                                    field: Ext.encode(e.id),
                                    value: Ext.encode(e.getValue().inputValue)
                                }
                            });
                        }
                    }
                }, new Ext.form.ComboBox({
                    store: storeWarehouse,
                    fieldLabel: 'Input Warehouse'.translator('stock-manage'),
                    id: 'in_warehouse_id',
                    forceSelection: true,
                    displayField: 'warehouse_name',
                    valueField: 'warehouse_id',
                    listWidth: 300,
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select input warehouse'.translator('stock-manage'),
                    selectOnFocus: true,
                    editable: false,
                    width: 300,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdateInventoryVoucher(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                }), new Ext.form.ComboBox({
                    store: storeWarehouse,
                    fieldLabel: 'Output Warehouse'.translator('stock-manage'),
                    id: 'out_warehouse_id',
                    forceSelection: true,
                    displayField: 'warehouse_name',
                    valueField: 'warehouse_id',
                    listWidth: 300,
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select output warehouse'.translator('stock-manage'),
                    selectOnFocus: true,
                    editable: false,
                    width: 300,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdateInventoryVoucher(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                })]
            }, {
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [new Ext.form.ComboBox({
                    store: storeSubject,
                    fieldLabel: 'Inventory Subject'.translator('stock-manage'),
                    id: 'subject_id',
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    listWidth: 300,
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select a subject'.translator('stock-manage'),
                    selectOnFocus: true,
                    editable: false,
                    width: 300,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdateInventoryVoucher(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'subject_contact',
                    fieldLabel: 'Contact Subject'.translator('stock-manage'),
                    width: 300,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdateInventoryVoucher(e.getId(), e.getValue());
                        }
                    }
                }, new Ext.form.ComboBox({
                    store: storeDepartment,
                    fieldLabel: 'Inventory Department'.translator('stock-manage'),
                    id: 'department_id',
                    forceSelection: true,
                    displayField: 'department_name',
                    valueField: 'department_id',
                    listWidth: 300,
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select a department'.translator('stock-manage'),
                    selectOnFocus: true,
                    editable: false,
                    width: 300,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdateInventoryVoucher(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'currency_id',
                    store: storeCurrencyWithForexRate,
                    fieldLabel: 'Currency Type'.translator('stock-manage'),
                    forceSelection: true,
                    displayField: 'currency_name',
                    valueField: 'currency_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select a currency'.translator('stock-manage'),
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
                                warning('Warning'.translator('stock-manage'), 'Currency Type'.translator('stock-manage') + ' \'' + $('#currency_id').val() + 'Not forexrate'.translator('stock-manage'));
                                Ext.getCmp('currency_id').setValue(currencyType);
                                Ext.getCmp('forex_rate').setValue(forexRate);
                            }
                            else {
                                Ext.getCmp('forex_rate').setValue(objectCurrency.itemAt(0).data.forex_rate);
                                forexRate = objectCurrency.itemAt(0).data.forex_rate;
                                currencyType = objectCurrency.itemAt(0).data.currency_id;
                                baseUpdateInventoryVoucher(combo.getId(), combo.value);
                            }
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'forex_rate',
                    fieldLabel: 'Forex Rate'.translator('stock-manage'),
                    width: 120,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdateInventoryVoucher(e.getId(), e.getValue());
                        },
                        keypress: function(my, e){
                            if (!forceNumber(e)) 
                                e.stopEvent();
                        }
                    }
                }, {
                    xtype: 'textarea',
                    width: 300,
                    height: 30,
                    id: 'description',
                    fieldLabel: 'Description'.translator('stock-manage'),
                    listeners: {
                        change: function(e){
                            baseUpdateInventoryVoucher(e.getId(), e.getValue());
                        }
                    }
                }]
            }]
        }, gridDetail]
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
            title: "List Inventory Voucher".translator('stock-manage'),
            id: 'listInventory',
            items: [gridInventory]
        }, {
            title: "General Information".translator('stock-manage'),
            id: 'inventoryInfo',
            items: [generalTab],
            disabled: true
        }, {
            title: "Accounting information".translator('stock-manage'),
            id: 'accountInfo',
            items: [gridAccounting],
            disabled: true
        }]
    });
});

var baseUpdateInventoryVoucher = function(field, value){
    var inventoryDate = value;
    if (field == 'inventory_voucher_date') {
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
        url: pathRequestUrl + '/updateInventoryVoucher/' + gridDetail.getStore().baseParams.inventoryVoucherId,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                var record = gridInventory.getStore().getAt(selectedInventoryIndex);
                switch (field) {
                    case 'subject_id':
                        Ext.getCmp('subject_contact').setValue(result.data.subject_contact);
                        record.data.subject_id = result.data.subject_id;
                        record.data.subject_contact = result.data.subject_contact;
                        break;
                    case 'subject_contact':
                        record.data.subject_contact = value;
                        break;
                    case 'department_id':
                        record.data.department_id = value;
                        break;
                    case 'inventory_voucher_number':
                        record.data.inventory_voucher_number = value;
                        break;
                    case 'inventory_voucher_date':
                        record.data.inventory_voucher_date_format = inventoryDate;
                        break;
                    case 'description':
                        record.data.description = value;
                        break;
                    case 'in_warehouse_id':
                        record.data.in_warehouse_id = value;
                        break;
                    case 'out_warehouse_id':
                        record.data.out_warehouse_id = value;
                        break;
                }
                
                
                if (field == 'currency_id' || field == 'forex_rate') {
                    record.data.currency_id = result.data.currency_id;
                    record.data.forex_rate = result.data.forex_rate;
                    if (result.data.change_currency) {
                        gridDetail.store.load();
                        record.data.total_inventory_amount = result.data.total_inventory_amount;
                    }
                    gridAccounting.getStore().removeAll();
                    gridAccounting.getStore().load();
                    gridAccounting.getView().refresh(true);
                }
                gridInventory.getView().refresh(true);
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
            batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
            convertCurrency: convertedCurrencyId,
            field: Ext.encode(field),
            value: Ext.encode(value)
        }
    });
}
