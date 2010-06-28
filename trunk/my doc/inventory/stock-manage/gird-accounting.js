var selectedRowIndex = -1;
var selectedRow;
var beforeCreditAccount;
var beforeDebitAccount;

var isStartAccount = false;
var storeDebitAccount;
var storeCreditAccount;
var storeAccounting;
var storeAccountingTemp;

var inWarehouseId = 0;
var outWarehouseId = 0;

var load_store_entry_temp = function(){
    storeAccountingTemp.removeAll();
    storeAccounting.each(function(r){
        storeAccountingTemp.add(r.copy());
    });
    gridAccounting.getSelectionModel().selections.clear();
}

function render_accounting_product(val){
    try {
        if (isEmpty(val)) 
            return '';
        return storeDetail.queryBy(function(rec){
            return rec.data.detail_inventory_id == val;
        }).itemAt(0).data.product_unit_name;
    } 
    catch (e) {
    }
}

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    storeDebitAccount = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'account_code', 'account_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDebitAccount/1'
        }),
        autoLoad: false
    });
    
    function render_debit_option(val){
        try {
            if (isEmpty(val)) 
                return '';
            return storeDebitAccount.queryBy(function(rec){
                return rec.data.account_id == val;
            }).itemAt(0).data.account_code;
        } 
        catch (e) {
        }
    }
    
    function load_debit_account(){
        for (var i = 0; i < storeDebitAccount.getCount(); i++) {
            var recordDebit = new Array();
            recordDebit['account_id'] = storeDebitAccount.getAt(i).data.account_id;
            recordDebit['account_code'] = storeDebitAccount.getAt(i).data.account_code;
            recordDebit['account_name'] = storeDebitAccount.getAt(i).data.account_name;
            var rec = new Ext.data.Record(recordDebit);
            comboDebitOption.store.add(rec);
        }
    }
    
    storeCreditAccount = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'account_code', 'account_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getCreditAccount/1'
        }),
        autoLoad: false
    });
    
    function render_credit_option(val){
        try {
            if (isEmpty(val)) 
                return '';
            return storeCreditAccount.queryBy(function(rec){
                return rec.data.account_id == val;
            }).itemAt(0).data.account_code;
        } 
        catch (e) {
        }
    }
    
    function load_credit_account(){
        for (var i = 0; i < storeCreditAccount.getCount(); i++) {
            var recordCredit = new Array();
            recordCredit['account_id'] = storeCreditAccount.getAt(i).data.account_id;
            recordCredit['account_code'] = storeCreditAccount.getAt(i).data.account_code;
            recordCredit['account_name'] = storeCreditAccount.getAt(i).data.account_name;
            var rec = new Ext.data.Record(recordCredit);
            comboCreditOption.store.add(rec);
        }
    }
    
    var storeDebitOption = new Ext.data.ArrayStore({
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
    
    var comboDebitOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeDebitOption,
        valueField: 'account_id',
        displayField: 'account_code',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:32px;">{account_code}</div><div style="float:left; text-align:left;">|</div><div>{account_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 150,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 600,
        listeners: {
            select: function(combo, record, index){
                selectedRow.data.account_name = record.data.account_name;
            }
        }
    });
    
    var storeCreditOption = new Ext.data.ArrayStore({
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
    
    var comboCreditOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeCreditOption,
        valueField: 'account_id',
        displayField: 'account_code',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:32px;">{account_code}</div><div style="float:left; text-align:left;">|</div><div>{account_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 150,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 600,
        listeners: {
            select: function(combo, record, index){
                selectedRow.data.account_name = record.data.account_name;
            }
        }
    });
    
    var Accounting = {
    
        add: function(){
            if (!isEmpty(selectedRow.data.id)) {
                var newIndex = selectedRowIndex + 1;
                var product = storeDetail.queryBy(function(rec){
                    return rec.data.detail_inventory_id == selectedRow.data.detail_purchase_id;
                }).itemAt(0);
                
                var debitCredit = null;
                if (selectedRow.data.master_type) {
                    debitCredit = -selectedRow.data.debit_credit;
                }
                else {
                    debitCredit = selectedRow.data.debit_credit;
                }
                
                var entryNewRecord = new test_object({
                    id: selectedRow.data.id,
                    entry_id: selectedRow.data.entry_id,
                    debit_credit: debitCredit,
                    debit_account_id: null,
                    credit_account_id: null,
                    product_id: product.data.product_id,
                    unit_id: product.data.unit_id,
                    detail_purchase_id: product.data.product_id + '_' + product.data.unit_id,
                    product_unit_name: selectedRow.data.product_unit_name,
                    original_amount: '0' + decimalSeparator + '00',
                    currency_id: product.data.currency_id,
                    converted_amount: '0' + decimalSeparator + '00',
                    master_type: false
                });
                
                gridAccounting.getStore().insert(newIndex, entryNewRecord);
                //gridAccounting.startEditing(newIndex, 4);
                //gridAccounting.getSelectionModel().selectRow(newIndex);
                //gridAccounting.bottomToolbar.items.get('add_entry_debit').disable();
            }
        },
        remove: function(){
            // action delete entry
            var records = gridAccounting.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm'.translator('buy-billing'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Ask delete entry'.translator('buy-billing'),
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecordEntry = new Array();
                            var objectRecordEntry = new Array();
                            var arrRecordCorrespondence = new Array();
                            var objectRecordCorrespondence = new Array();
                            for (var i = 0; i < records.length; i++) {
                                if (records[i].data.master_type &&
                                !isEmpty(records[i].data.entry_id)) {
                                    arrRecordEntry.push({
                                        entryId: records[i].data.entry_id
                                    });
                                }
                                else 
                                    if (!records[i].data.master_type &&
                                    !isEmpty(records[i].data.correspondence_id)) {
                                        arrRecordCorrespondence.push({
                                            correspondenceId: records[i].data.correspondence_id
                                        });
                                    }
                            }
                            baseDeleteAccountingInfo(gridAccounting.getStore(), arrRecordEntry, arrRecordCorrespondence);
                        }
                    }
                });
            }
            else 
                warning('Warning'.translator('buy-billing'), 'Not row to delete'.translator('buy-billing'));
        },
        addEntry: function(){
            var entryNewRecord = new test_object({
                id: null,
                debit_account_id: null,
                credit_account_id: null,
                master_type: true
            });
            
            gridAccounting.getStore().insert(gridAccounting.getStore().getCount(), entryNewRecord);
            gridAccounting.startEditing(gridAccounting.getStore().getCount() - 1, 1);
        }
    };
    
    var record = [{
        name: 'id',
        type: 'string'
    }, {
        name: 'entry_id',
        type: 'string'
    }, {
        name: 'debit_credit',
        type: 'string'
    }, {
        name: 'correspondence_id',
        type: 'string'
    }, {
        name: 'product_id',
        type: 'string'
    }, {
        name: 'unit_id',
        type: 'string'
    }, {
        name: 'detail_purchase_id',
        type: 'string'
    }, {
        name: 'product_unit_name',
        type: 'string'
    }, {
        name: 'master_type',
        type: 'boolean'
    }, {
        name: 'debit_account_id',
        type: 'string'
    }, {
        name: 'credit_account_id',
        type: 'string'
    }, {
        name: 'account_name',
        type: 'string'
    }, {
        name: 'original_amount',
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
        name: 'converted_amount',
        type: 'string'
    }];
    var test_object = Ext.data.Record.create(record);
    
    storeAccounting = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'id'
        }, test_object),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getEntryDebitOfPurchase/1'
        }),
        autoLoad: false,
        groupField: 'detail_purchase_id',
        sortInfo: {
            field: 'detail_purchase_id',
            direction: 'ASC'
        }
    });
    
    storeAccounting.on('beforeload', function(){
        gridAccounting.topToolbar.items.get('add_entry').enable();
    });
    
    storeAccountingTemp = new Ext.data.Store({
        recordType: storeAccounting.recordType
    });
    
    storeAccounting.on('load', function(){
        load_store_entry_temp();
    });
    
    var tbarAccounting = new Ext.Toolbar({
        items: [{
            text: 'Add Entry'.translator('buy-billing'),
            id: 'add_entry',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Accounting.addEntry
        }, '-', {
            text: 'Add Entry Detail'.translator('buy-billing'),
            id: 'add_entry_debit',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Accounting.add
        }, '-', {
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_entry_debit',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Accounting.remove
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_entry',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                storeAccountingTemp.removeAll();
                gridAccounting.getStore().removeAll();
                gridAccounting.getStore().reload();
            }
        }]
    });
    
    var cmAccounting = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Account Name'.translator('buy-billing'),
            dataIndex: 'account_name',
            width: 180
        }, {
            header: 'Debit'.translator('buy-billing'),
            dataIndex: 'debit_account_id',
            id: 'debit_account_id',
            width: 50,
            align: 'right',
            editor: comboDebitOption,
            renderer: render_debit_option
        }, {
            header: 'Credit'.translator('buy-billing'),
            dataIndex: 'credit_account_id',
            id: 'credit_account_id',
            width: 50,
            align: 'right',
            editor: comboCreditOption,
            renderer: render_credit_option
        }, {
            header: 'Original Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'original_amount',
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
            header: 'Currency Type'.translator('buy-billing'),
            width: 100,
            dataIndex: 'currency_name',
            align: 'right'
        }, {
            header: 'Forex Rate'.translator('buy-billing'),
            width: 100,
            dataIndex: 'forex_rate',
            align: 'right'
        }, {
            header: 'Converted Original Amount'.translator('buy-billing'),
            width: 150,
            dataIndex: 'converted_amount',
            align: 'right'
        }, {
            header: 'Product'.translator('buy-billing'),
            width: 250,
            dataIndex: 'detail_purchase_id',
            id: 'detail_purchase_id',
            align: 'right',
            editor: comboAccounting,
            renderer: render_accounting_product
        }]
    });
    
    // create the Grid
    gridAccounting = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeAccounting,
        cm: cmAccounting,
        stripeRows: true,
        height: 530,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'.translator('buy-billing')
        },
        view: new Ext.grid.GroupingView({
            forceFit: true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "' + 'Items'.translator('buy-billing') + '" : "' + 'Item'.translator('buy-billing') + '"]})'
        }),
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        tbar: tbarAccounting,
        stateful: true,
        stateId: 'gridAccounting',
        id: 'gridAccounting',
        listeners: {
            beforeedit: function(e){
                // save before debit account                        
                if ((e.field == 'debit_account_id') &&
                !isEmpty(selectedRow.data.id) &&
                !isEmpty(e.value) &&
                (selectedRow.data.debit_credit == -1)) {
                    beforeDebitAccount = e.record.data.debit_account_id;
                }
                
                // save before debit account
                if ((e.field == 'credit_account_id') &&
                !isEmpty(selectedRow.data.id) &&
                !isEmpty(e.value) &&
                (selectedRow.data.debit_credit == 1)) {
                    beforeCreditAccount = e.record.data.credit_account_id;
                }
            },
            afteredit: function(e){
                if (e.field == 'detail_purchase_id') {
                    if (isEmpty(e.record.data.id)) {
                        var product = storeDetail.queryBy(function(rec){
                            return rec.data.detail_inventory_id == e.value;
                        }).itemAt(0);
                        e.record.data.product_unit_name = product.data.product_unit_name;
                        e.record.data.product_id = product.data.product_id;
                        e.record.data.unit_id = product.data.unit_id;
                        e.record.data.detail_purchase_id = product.data.product_id + '_' + product.data.unit_id;
                        e.record.data.original_amount = product.data.amount;
                        e.record.data.currency_id = product.data.currency_id;
                        e.record.data.currency_name = product.data.currency_name;
                        e.record.data.forex_rate = product.data.forex_rate;
                        e.record.data.converted_amount = product.data.converted_amount;
                        e.record.commit();
                    }
                    else {
                        e.record.reject();
                        warning('Warning'.translator('buy-billing'), 'no change');
                    }
                }
                
                // check inputed value into original amount column
                if ((e.field == 'original_amount')) {
                    if (parseFloat(formatNumber(e.value)) < 0.0) {
                        e.record.reject();
                        msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                        return;
                    }
                    if (!isEmpty(e.record.data.id)) {
                        // if this row is master type, don't allow change value
                        if (e.record.data.master_type) {
                            e.record.reject();
                            warning('Warning'.translator('buy-billing'), 'Can\'t change value'.translator('buy-billing'));
                            return;
                        }// if this row is detail type, check total master == total detail
                        else {
                            // get total master of entry
                            var masterValue = 0.0;
                            var forexRate = storeAccountingTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.forex_rate;
                            
                            masterValue = parseFloat(formatNumber(storeAccountingTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.original_amount));
                            
                            // get total detail of entry
                            var detailValue = 0.0;
                            for (var i = 0; i < storeAccounting.getCount(); i++) {
                                if ((storeAccounting.getAt(i).data.entry_id == e.record.data.entry_id) &&
                                !storeAccounting.getAt(i).data.master_type) {
                                    detailValue += parseFloat(formatNumber(storeAccounting.getAt(i).data.original_amount));
                                }
                            }
                            // if total detail > total master, don't update value
                            if (detailValue > masterValue) {
                                e.record.reject();
                                warning('Warning'.translator('buy-billing'), 'Check total amount'.translator('buy-billing'));
                            }
                            else {
                            
                                if (!isEmpty(e.record.data.debit_account_id) ||
                                !isEmpty(e.record.data.credit_account_id)) {
                                    baseUpdateFieldOfCorrespondence(e.record, e.record.data.entry_id, e.record.data.correspondence_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, forexRate);
                                }
                            }
                        }
                    }
                    else {
                        // if this row is new entry and master type, don't allow change value
                        if (e.record.data.master_type) {
                            e.record.reject();
                            warning('Warning'.translator('buy-billing'), 'Can\'t change value'.translator('buy-billing'));
                        }
                    }
                }
                // end check
                
                // check inputed value into debit account id column
                if ((e.field == 'debit_account_id') && !isEmpty(e.value)) {
                    if (!isEmpty(e.record.data.id) && (e.record.data.debit_credit == -1)) {
                        // if this row is not master type, check exist of debit account id in store entry temp
                        if (!e.record.data.master_type) {
                            for (var i = 0; i < storeAccountingTemp.getCount(); i++) {
                                // search in entry
                                if ((storeAccountingTemp.getAt(i).data.entry_id == e.record.data.entry_id) &&
                                (storeAccountingTemp.getAt(i).data.debit_account_id == e.value)) {
                                    // if debit account exist in entry,  don't change value
                                    if (!isEmpty(beforeDebitAccount)) {
                                        e.record.data.account_name = storeDebitAccount.queryBy(function(rec){
                                            return rec.data.account_id == beforeDebitAccount;
                                        }).itemAt(0).data.account_name;
                                    }
                                    else {
                                        e.record.data.account_name = null;
                                    }
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Debit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            var forexRate = storeAccountingTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.forex_rate;
                            
                            // not exist is update value
                            baseUpdateFieldOfCorrespondence(e.record, e.record.data.entry_id, e.record.data.correspondence_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, forexRate, e.record.data.product_id, e.record.data.unit_id);
                        }// if this row is master type, check debit account exist in entry of product
                        else {
                            for (var i = 0; i < storeAccountingTemp.getCount(); i++) {
                                if ((storeAccountingTemp.getAt(i).data.product_id == e.record.data.product_id) &&
                                (storeAccountingTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
                                storeAccountingTemp.getAt(i).data.master_type &&
                                (storeAccountingTemp.getAt(i).data.debit_account_id == e.value)) {
                                    // if debit account exist in entry,  don't change value
                                    if (!isEmpty(beforeDebitAccount)) {
                                        e.record.data.account_name = storeDebitAccount.queryBy(function(rec){
                                            return rec.data.account_id == beforeDebitAccount;
                                        }).itemAt(0).data.account_name;
                                    }
                                    else {
                                        e.record.data.account_name = null;
                                    }
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Debit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            
                            // not exist is update value
                            baseUpdateFieldOfEntry(e.record, storeAccounting.baseParams.batchId, e.record.data.entry_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
                        }
                    }
                    else 
                        if (e.record.data.master_type) {
                            for (var i = 0; i < storeAccountingTemp.getCount(); i++) {
                                if ((storeAccountingTemp.getAt(i).data.product_id == e.record.data.product_id) &&
                                (storeAccountingTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
                                storeAccountingTemp.getAt(i).data.master_type &&
                                (storeAccountingTemp.getAt(i).data.debit_account_id == e.value)) {
                                    e.record.data.account_name = null;
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Debit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            
                            // not exist is update value , e.record.data.product_id, e.record.data.unit_id
                            baseUpdateFieldOfEntry(e.record, storeAccounting.baseParams.batchId, null, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
                        }
                }
                
                // check inputed value into credit account id column
                if ((e.field == 'credit_account_id') && !isEmpty(e.value)) {
                    if (!isEmpty(e.record.data.id) && (e.record.data.debit_credit == 1)) {
                        // if this row is not master type, check exist of credit account id in store entry temp												
                        if (!e.record.data.master_type) {
                            for (var i = 0; i < storeAccountingTemp.getCount(); i++) {
                                // search in entry
                                if ((storeAccountingTemp.getAt(i).data.entry_id == e.record.data.entry_id) &&
                                (storeAccountingTemp.getAt(i).data.credit_account_id == e.value)) {
                                    // if debit account exist in entry,  don't change value
                                    if (!isEmpty(beforeCreditAccount)) {
                                        e.record.data.account_name = storeCreditAccount.queryBy(function(rec){
                                            return rec.data.account_id == beforeCreditAccount;
                                        }).itemAt(0).data.account_name;
                                    }
                                    else {
                                        e.record.data.account_name = null;
                                    }
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Credit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            
                            var forexRate = storeAccountingTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.forex_rate;
                            
                            
                            // not exist is update value
                            baseUpdateFieldOfCorrespondence(e.record, e.record.data.entry_id, e.record.data.correspondence_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, forexRate, e.record.data.product_id, e.record.data.unit_id);
                        }// if this row is master type, check credit account exist in entry of product
                        else {
                            for (var i = 0; i < storeAccountingTemp.getCount(); i++) {
                                if ((storeAccountingTemp.getAt(i).data.product_id == e.record.data.product_id) &&
                                (storeAccountingTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
                                storeAccountingTemp.getAt(i).data.master_type &&
                                (storeAccountingTemp.getAt(i).data.credit_account_id == e.value)) {
                                    // if credit account exist in entry,  don't change value
                                    if (!isEmpty(beforeCreditAccount)) {
                                        e.record.data.account_name = storeCreditAccount.queryBy(function(rec){
                                            return rec.data.account_id == beforeCreditAccount;
                                        }).itemAt(0).data.account_name;
                                    }
                                    else {
                                        e.record.data.account_name = null;
                                    }
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Credit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            // not exist is update value
                            baseUpdateFieldOfEntry(e.record, storeAccounting.baseParams.batchId, e.record.data.entry_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
                        }
                    }
                    else {
                        if (e.record.data.master_type) {
                            for (var i = 0; i < storeAccountingTemp.getCount(); i++) {
                                if ((storeAccountingTemp.getAt(i).data.product_id == e.record.data.product_id) &&
                                (storeAccountingTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
                                storeAccountingTemp.getAt(i).data.master_type &&
                                (storeAccountingTemp.getAt(i).data.credit_account_id == e.value)) {
                                    e.record.data.account_name = null;
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Credit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            // not exist is update value
                            baseUpdateFieldOfEntry(e.record, storeAccounting.baseParams.batchId, null, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
                        }
                    }
                }
            },
            cellclick: function(grid, rowIndex, columnIndex, e){
            
                selectedRowIndex = rowIndex;
                selectedRow = gridAccounting.getSelectionModel().getSelected();
                
                if (!isEmpty(selectedRow.data.id)) {
                    if (isEmpty(selectedRow.data.correspondence_id) && !selectedRow.data.master_type) 
                        gridAccounting.topToolbar.items.get('add_entry_debit').disable();
                    else 
                        gridAccounting.topToolbar.items.get('add_entry_debit').enable();
                }
                else {
                    gridAccounting.topToolbar.items.get('add_entry_debit').disable();
                }
                comboDebitOption.store.removeAll();
                comboCreditOption.store.removeAll();
                if (gridAccounting.getColumnModel().getColumnId(columnIndex) == 'debit_account_id') {
                
                    if (!isEmpty(selectedRow.data.id) && (selectedRow.data.debit_credit == -1)) {
                        load_debit_account();
                    }
                    else 
                        if (isEmpty(selectedRow.data.id) &&
                        isEmpty(selectedRow.data.credit_account_id) &&
                        isEmpty(selectedRow.data.debit_credit)) {
                            var recordDebit = new Array({
                                account_id: null,
                                account_code: null,
                                account_name: null
                            });
                            comboDebitOption.store.add(new Ext.data.Record(recordDebit));
                            load_debit_account();
                        }
                    
                }
                
                if (gridAccounting.getColumnModel().getColumnId(columnIndex) == 'credit_account_id') {
                    if (!isEmpty(selectedRow.data.id) && (selectedRow.data.debit_credit == 1)) {
                        load_credit_account();
                    }
                    else 
                        if (isEmpty(selectedRow.data.id) &&
                        isEmpty(selectedRow.data.debit_account_id) &&
                        isEmpty(selectedRow.data.debit_credit)) {
                            var recordCredit = new Array({
                                account_id: null,
                                account_code: null,
                                account_name: null
                            });
                            comboCreditOption.store.add(new Ext.data.Record(recordCredit));
                            load_credit_account();
                        }
                }
            }
        }
    });
    
    gridAccounting.getView().getRowClass = function(record, index){
        if (record.data.master_type) 
            return 'blue-row';
        return 'green-row';
    };
    
    gridAccounting.on('keydown', function(e){
        if (e.keyCode == 46) {
            Accounting.remove();
        }
    });
});

var get_in_out_warehouse = function(){
    var inOut = gridDetail.getStore().baseParams.inOut;
    if (inOut == DEFAULT_INPUT_VOTE_TYPE) {
        inWarehouseId = outWarehouseId = Ext.getCmp('in_warehouse_id').getValue();
    }
    else 
        if (inOut == DEFAULT_OUTPUT_VOTE_TYPE) {
            inWarehouseId = outWarehouseId = Ext.getCmp('out_warehouse_id').getValue();
        }
        else {
            inWarehouseId = Ext.getCmp('in_warehouse_id').getValue();
            outWarehouseId = Ext.getCmp('out_warehouse_id').getValue();
        }
}

var baseUpdateFieldOfEntry = function(record, batchId, entryId, field, value, debitOrCredit, originalAmount, currencyId, forexRate, productId, unitId){
    get_in_out_warehouse();
    Ext.Ajax.request({
        url: pathRequestUrl + '/updateFieldOfTransactionEntry/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                if (isEmpty(entryId)) {
                    record.id = record.data.product_id + '_' + record.data.unit_id + '_' + result.data.entry_id + '_0';
                    record.data.entry_id = result.data.entry_id;
                    record.data.id = record.data.product_id + '_' + record.data.unit_id + '_' + result.data.entry_id + '_0';
                    record.data.debit_credit = result.data.debit_credit;
                    if (field == 'debit_account_id') 
                        record.data.debit_account_id = result.data.master_account_id;
                    else 
                        record.data.credit_account_id = result.data.master_account_id;
                }
                record.commit();
                load_store_entry_temp();
                gridAccounting.getSelectionModel().selections.clear();
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
            batchId: Ext.encode(batchId),
            entryId: Ext.encode(entryId),
            field: Ext.encode(field),
            value: Ext.encode(value),
            debitOrCredit: Ext.encode(debitOrCredit),
            originalAmount: Ext.encode(formatNumber(originalAmount)),
            currencyId: Ext.encode(currencyId),
            forexRate: Ext.encode(formatNumber(forexRate)),
            productId: Ext.encode(productId),
            unitId: Ext.encode(unitId),
            inWarehouseId: Ext.encode(inWarehouseId),
            outWarehouseId: Ext.encode(outWarehouseId),
            subjectId: Ext.encode(Ext.getCmp('subject_id').getValue()),
            departmentId: Ext.encode(Ext.getCmp('department_id').getValue())
        }
    });
}

var baseUpdateFieldOfCorrespondence = function(record, entryId, correspondenceId, field, value, debitOrCredit, originalAmount, currencyId, forexRate, productId, unitId){
    get_in_out_warehouse();
    if (field == 'original_amount') {
        value = formatNumber(value);
    }
    
    Ext.Ajax.request({
        url: pathRequestUrl + '/updateFieldOfTransactionCorrespondence/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                if (isEmpty(correspondenceId)) {
                    record.id = record.data.product_id + '_' + record.data.unit_id + '_' + record.data.entry_id + '_' + result.data.correspondence_id;
                    record.data.correspondence_id = result.data.correspondence_id;
                    record.data.original_amount = result.data.original_amount;
                    record.data.id = record.data.product_id + '_' + record.data.unit_id + '_' + record.data.entry_id + '_' + result.data.correspondence_id;
                    record.data.converted_amount = result.data.converted_amount;
                    record.data.debit_credit = result.data.debit_credit;
                    if (field == 'debit_account_id') 
                        record.data.debit_account_id = result.data.detail_account_id;
                    else 
                        record.data.credit_account_id = result.data.detail_account_id;
                }
                else {
                    if (field == 'original_amount') {
                        record.data.original_amount = result.data.original_amount;
                        record.data.converted_amount = result.data.converted_amount;
                    }
                }
                record.commit();
                load_store_entry_temp();
                gridAccounting.getSelectionModel().selections.clear();
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
            correspondenceId: Ext.encode(correspondenceId),
            entryId: Ext.encode(entryId),
            field: Ext.encode(field),
            value: Ext.encode(value),
            debitOrCredit: Ext.encode(debitOrCredit),
            originalAmount: Ext.encode(formatNumber(originalAmount)),
            currencyId: Ext.encode(currencyId),
            forexRate: Ext.encode(formatNumber(forexRate)),
            productId: Ext.encode(productId),
            unitId: Ext.encode(unitId),
            inWarehouseId: Ext.encode(inWarehouseId),
            outWarehouseId: Ext.encode(outWarehouseId),
            subjectId: Ext.encode(Ext.getCmp('subject_id').getValue()),
            departmentId: Ext.encode(Ext.getCmp('department_id').getValue())
        }
    });
}

var baseDeleteAccountingInfo = function(dataStore, arrEntryId, arrCorrespondenceId){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteTransactionEntry/1',
        method: 'post',
        success: function(result, options){
            // set up tam thoi, se toi uu lai cho tung gird
            var result = Ext.decode(result.responseText);
            if (result.success) {
                msg('Info'.translator('buy-billing'), 'Delete accounting success'.translator('buy-billing'), Ext.MessageBox.INFO);
                var i, j, k;
                var arrRecord = new Array();
                for (i = 0; i < arrEntryId.length; i++) {
                    for (j = 0; j < dataStore.getCount(); j++) {
                        if (dataStore.getAt(j).data.entry_id == arrEntryId[i].entryId) {
                            arrRecord.push(dataStore.getAt(j));
                        }
                    }
                }
                for (k = 0; k < arrRecord.length; k++) {
                    dataStore.remove(arrRecord[k]);
                }
                arrRecord.length = 0;
                for (i = 0; i < arrCorrespondenceId.length; i++) {
                    for (j = 0; j < dataStore.getCount(); j++) {
                        if (dataStore.getAt(j).data.correspondence_id == arrCorrespondenceId[i].correspondenceId) {
                            arrRecord.push(dataStore.getAt(j));
                        }
                    }
                }
                for (k = 0; k < arrRecord.length; k++) {
                    dataStore.remove(arrRecord[k]);
                }
                load_store_entry_temp();
                gridAccounting.getView().refresh(true);
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
            arrEntryId: Ext.encode(arrEntryId),
            arrCorrespondenceId: Ext.encode(arrCorrespondenceId)
        }
    });
}
