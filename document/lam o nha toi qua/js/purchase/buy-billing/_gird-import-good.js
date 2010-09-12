var selectedRowIndexImport = -1;
var selectedRowImport;
var beforeCreditAccountImport;
var beforeDebitAccountImport;

var storeDebitAccountImport;
var storeCreditAccountImport;
var storeImportGood;
var storeImportGoodTemp;

var load_store_import_good = function(){
    storeImportGoodTemp.removeAll();
    storeImportGood.each(function(r){
        storeImportGoodTemp.add(r.copy());
    });
    gridImportGood.getSelectionModel().selections.clear();
};

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    storeDebitAccountImport = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'account_code', 'account_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDebitAccount/' + ENTRY_TYPE_VAT_GOOD
        }),
        autoLoad: false
    });
    
    function render_debit_option_import(val){
        try {
            if (isEmpty(val)) 
                return '';
            return storeDebitAccountImport.queryBy(function(rec){
                return rec.data.account_id == val;
            }).itemAt(0).data.account_code;
        } 
        catch (e) {
        }
    }
    
    function load_debit_account_import(){
        for (var i = 0; i < storeDebitAccountImport.getCount(); i++) {
            var recordDebit = new Array();
            recordDebit['account_id'] = storeDebitAccountImport.getAt(i).data.account_id;
            recordDebit['account_code'] = storeDebitAccountImport.getAt(i).data.account_code;
            recordDebit['account_name'] = storeDebitAccountImport.getAt(i).data.account_name;
            var rec = new Ext.data.Record(recordDebit);
            comboDebitOptionImport.store.add(rec);
        }
    }
    
    storeCreditAccountImport = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'account_code', 'account_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getCreditAccount/' + ENTRY_TYPE_VAT_GOOD
        }),
        autoLoad: false
    });
    
    function render_credit_option_import(val){
        try {
            if (isEmpty(val)) 
                return '';
            return storeCreditAccountImport.queryBy(function(rec){
                return rec.data.account_id == val;
            }).itemAt(0).data.account_code;
        } 
        catch (e) {
        }
    }
    
    function load_credit_account_import(){
        for (var i = 0; i < storeCreditAccountImport.getCount(); i++) {
            var recordCredit = new Array();
            recordCredit['account_id'] = storeCreditAccountImport.getAt(i).data.account_id;
            recordCredit['account_code'] = storeCreditAccountImport.getAt(i).data.account_code;
            recordCredit['account_name'] = storeCreditAccountImport.getAt(i).data.account_name;
            var rec = new Ext.data.Record(recordCredit);
            comboCreditOptionImport.store.add(rec);
        }
    }
    
    var storeDebitOptionImport = new Ext.data.ArrayStore({
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
    
    var comboDebitOptionImport = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeDebitOptionImport,
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
                selectedRowImport.data.account_name = record.data.account_name;
            }
        }
    });
    
    var storeCreditOptionImport = new Ext.data.ArrayStore({
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
    
    var comboCreditOptionImport = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeCreditOptionImport,
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
                selectedRowImport.data.account_name = record.data.account_name;
            }
        }
    });
    
    var ImportGood = {
    
        add: function(){
            if (!isEmpty(selectedRowImport.data.id)) {
                var newIndexImport = selectedRowIndexImport + 1;
                var product = storeDetailEntry.queryBy(function(rec){
                    return rec.data.detail_purchase_id == selectedRowImport.data.detail_purchase_id;
                }).itemAt(0);
                
                var debitCredit = null;
                if (selectedRowImport.data.master_type) {
                    debitCredit = -selectedRowImport.data.debit_credit;
                }
                else {
                    debitCredit = selectedRowImport.data.debit_credit;
                }
                
                var entryNewRecord = new test_object({
                    id: selectedRowImport.data.id,
                    entry_id: selectedRowImport.data.entry_id,
                    debit_credit: debitCredit,
                    debit_account_id: null,
                    credit_account_id: null,
                    product_id: product.data.product_id,
                    unit_id: product.data.unit_id,
                    detail_purchase_id: product.data.product_id + '_' + product.data.unit_id,
                    product_unit_name: selectedRowImport.data.product_unit_name,
                    original_amount: '0' + decimalSeparator + '00',
                    currency_id: product.data.currency_id,
                    converted_amount: '0' + decimalSeparator + '00',
                    master_type: false
                });
                
                gridImportGood.getStore().insert(newIndexImport, entryNewRecord);
            }
        },
        remove: function(){
            var records = gridImportGood.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm',
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Ask delete entry'.translator('buy-billing'),
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecordEntry = new Array();
                            var arrRecordCorrespondence = new Array();
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
                            baseDeleteAccountingInfo(ENTRY_TYPE_VAT_GOOD, gridImportGood.getStore(), arrRecordEntry, arrRecordCorrespondence);
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
            
            gridImportGood.getStore().insert(gridImportGood.getStore().getCount(), entryNewRecord);
            gridImportGood.startEditing(gridImportGood.getStore().getCount() - 1, 1);
        }
    };
    
    var recordImport = [{
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
    var test_object = Ext.data.Record.create(recordImport);
    
    storeImportGood = new Ext.data.GroupingStore({
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
    
    storeImportGood.on('beforeload', function(){
        gridImportGood.topToolbar.items.get('add_entry_import_good').enable();
    });
    
    storeImportGoodTemp = new Ext.data.Store({
        recordType: storeImportGood.recordType
    });
    
    storeImportGood.on('load', function(){
        load_store_import_good();
    });
    
    var tbarImportGood = new Ext.Toolbar({
        items: [{
            text: 'Add Entry'.translator('buy-billing'),
            id: 'add_entry_good',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: ImportGood.addEntry
        }, '-', {
            text: 'Add Entry Detail'.translator('buy-billing'),
            id: 'add_entry_import_good',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: ImportGood.add
        }, '-', {
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_entry_debit_good',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: ImportGood.remove
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_import',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
				storeImportGoodTemp.removeAll();
                gridImportGood.getStore().removeAll();
                gridImportGood.getStore().reload();
            }
        }]
    });
    
    var cmImportGood = new Ext.grid.ColumnModel({
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
            editor: comboDebitOptionImport,
            renderer: render_debit_option_import
        }, {
            header: 'Credit'.translator('buy-billing'),
            dataIndex: 'credit_account_id',
            id: 'credit_account_id',
            width: 50,
            align: 'right',
            editor: comboCreditOptionImport,
            renderer: render_credit_option_import
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
            align: 'right',
            editor: comboVatGood,
            renderer: render_accounting_product
        }]
    });
    
    // create the Grid
    gridImportGood = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeImportGood,
        cm: cmImportGood,
        stripeRows: true,
        height: 504,
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
        tbar: tbarImportGood,
        stateful: true,
        stateId: 'gridImportGood',
        id: 'gridImportGood',
        listeners: {
            beforeedit: function(e){
                // save before debit account                        
                if ((e.field == 'debit_account_id') &&
                !isEmpty(selectedRowImport.data.id) &&
                !isEmpty(e.value) &&
                (selectedRowImport.data.debit_credit == -1)) {
                    beforeDebitAccountImport = e.record.data.debit_account_id;
                }
                
                // save before debit account
                if ((e.field == 'credit_account_id') &&
                !isEmpty(selectedRowImport.data.id) &&
                !isEmpty(e.value) &&
                (selectedRowImport.data.debit_credit == 1)) {
                    beforeCreditAccountImport = e.record.data.credit_account_id;
                }
            },
            afteredit: function(e){
                if (e.field == 'detail_purchase_id') {
                    if (isEmpty(e.record.data.id)) {
                        var product = storeDetailEntry.queryBy(function(rec){
                            return rec.data.detail_purchase_id == e.value;
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
                            var forexRate = storeImportGoodTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.forex_rate;
                            
                            masterValue = parseFloat(formatNumber(storeImportGoodTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.original_amount));
                            
                            // get total detail of entry
                            var detailValue = 0.0;
                            for (var i = 0; i < storeImportGood.getCount(); i++) {
                                if ((storeImportGood.getAt(i).data.entry_id == e.record.data.entry_id) &&
                                !storeImportGood.getAt(i).data.master_type) {
                                    detailValue += parseFloat(formatNumber(storeImportGood.getAt(i).data.original_amount));
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
                                    baseUpdateFieldOfCorrespondence(ENTRY_TYPE_VAT_GOOD, e.record, e.record.data.entry_id, e.record.data.correspondence_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, forexRate);
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
							for (var i = 0; i < storeImportGoodTemp.getCount(); i++) {
								// search in entry
								if ((storeImportGoodTemp.getAt(i).data.entry_id == e.record.data.entry_id) &&
								(storeImportGoodTemp.getAt(i).data.debit_account_id == e.value)) {
									// if debit account exist in entry,  don't change value
									if (!isEmpty(beforeDebitAccountImport)) {
										e.record.data.account_name = storeDebitAccountImport.queryBy(function(rec){
											return rec.data.account_id == beforeDebitAccountImport;
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
							var forexRate = storeImportGoodTemp.queryBy(function(rec){
								return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
							}).itemAt(0).data.forex_rate;
							
							// not exist is update value
							baseUpdateFieldOfCorrespondence(ENTRY_TYPE_VAT_GOOD, e.record, e.record.data.entry_id, e.record.data.correspondence_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, forexRate, e.record.data.product_id, e.record.data.unit_id);
							
						}// if this row is master type, check debit account exist in entry of product
						else {
							for (var i = 0; i < storeImportGoodTemp.getCount(); i++) {
								if ((storeImportGoodTemp.getAt(i).data.product_id == e.record.data.product_id) &&
								(storeImportGoodTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
								storeImportGoodTemp.getAt(i).data.master_type &&
								(storeImportGoodTemp.getAt(i).data.debit_account_id == e.value)) {
									// if debit account exist in entry,  don't change value
									if (!isEmpty(beforeDebitAccountImport)) {
										e.record.data.account_name = storeDebitAccountImport.queryBy(function(rec){
											return rec.data.account_id == beforeDebitAccountImport;
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
							baseUpdateFieldOfEntry(ENTRY_TYPE_VAT_GOOD, e.record, storeImportGood.baseParams.batchId, e.record.data.entry_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
						}
					}
					else {
						if (isEmpty(e.record.data.product_id)) {
                            e.record.data.account_name = '';
                            e.record.reject();
                            warning('Warning'.translator('buy-billing'), 'Please choose product to accounting'.translator('buy-billing'));
                            return;
                        }
						if (e.record.data.master_type) {
							for (var i = 0; i < storeImportGoodTemp.getCount(); i++) {
								if ((storeImportGoodTemp.getAt(i).data.product_id == e.record.data.product_id) &&
								(storeImportGoodTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
								storeImportGoodTemp.getAt(i).data.master_type &&
								(storeImportGoodTemp.getAt(i).data.debit_account_id == e.value)) {
									e.record.data.account_name = null;
									e.record.reject();
									warning('Warning'.translator('buy-billing'), 'Debit account existed'.translator('buy-billing'));
									return;
								}
							}
							
							// not exist is update value , e.record.data.product_id, e.record.data.unit_id
							baseUpdateFieldOfEntry(ENTRY_TYPE_VAT_GOOD, e.record, storeImportGood.baseParams.batchId, null, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
						}
					}
                }
                
                // check inputed value into credit account id column
                if ((e.field == 'credit_account_id') && !isEmpty(e.value)) {
                    if (!isEmpty(e.record.data.id) && (e.record.data.debit_credit == 1)) {
                        // if this row is not master type, check exist of credit account id in store entry temp												
                        if (!e.record.data.master_type) {
                            for (var i = 0; i < storeImportGoodTemp.getCount(); i++) {
                                // search in entry
                                if ((storeImportGoodTemp.getAt(i).data.entry_id == e.record.data.entry_id) &&
                                (storeImportGoodTemp.getAt(i).data.credit_account_id == e.value)) {
                                    // if debit account exist in entry,  don't change value
                                    if (!isEmpty(beforeCreditAccountImport)) {
                                        e.record.data.account_name = storeCreditAccountImport.queryBy(function(rec){
                                            return rec.data.account_id == beforeCreditAccountImport;
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
                            
                            var forexRate = storeImportGoodTemp.queryBy(function(rec){
                                return ((rec.data.entry_id == e.record.data.entry_id) && (rec.data.master_type));
                            }).itemAt(0).data.forex_rate;
                            // not exist is update value
                            baseUpdateFieldOfCorrespondence(ENTRY_TYPE_VAT_GOOD, e.record, e.record.data.entry_id, e.record.data.correspondence_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, forexRate, e.record.data.product_id, e.record.data.unit_id);
                        }// if this row is master type, check credit account exist in entry of product
                        else {
                            for (var i = 0; i < storeImportGoodTemp.getCount(); i++) {
                                if ((storeImportGoodTemp.getAt(i).data.product_id == e.record.data.product_id) &&
                                (storeImportGoodTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
                                storeImportGoodTemp.getAt(i).data.master_type &&
                                (storeImportGoodTemp.getAt(i).data.credit_account_id == e.value)) {
                                    // if credit account exist in entry,  don't change value
                                    if (!isEmpty(beforeCreditAccountImport)) {
                                        e.record.data.account_name = storeCreditAccountImport.queryBy(function(rec){
                                            return rec.data.account_id == beforeCreditAccountImport;
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
                            baseUpdateFieldOfEntry(ENTRY_TYPE_VAT_GOOD, e.record, storeImportGood.baseParams.batchId, e.record.data.entry_id, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
                        }
                    }
                    else {
						if (isEmpty(e.record.data.product_id)) {
                            e.record.data.account_name = '';
                            e.record.reject();
                            warning('Warning'.translator('buy-billing'), 'Please choose product to accounting'.translator('buy-billing'));
                            return;
                        }
                        if (e.record.data.master_type) {
                            for (var i = 0; i < storeImportGoodTemp.getCount(); i++) {
                                if ((storeImportGoodTemp.getAt(i).data.product_id == e.record.data.product_id) &&
                                (storeImportGoodTemp.getAt(i).data.unit_id == e.record.data.unit_id) &&
                                storeImportGoodTemp.getAt(i).data.master_type &&
                                (storeImportGoodTemp.getAt(i).data.credit_account_id == e.value)) {
                                    e.record.data.account_name = null;
                                    e.record.reject();
                                    warning('Warning'.translator('buy-billing'), 'Credit account existed'.translator('buy-billing'));
                                    return;
                                }
                            }
                            // not exist is update value
                            baseUpdateFieldOfEntry(ENTRY_TYPE_VAT_GOOD, e.record, storeImportGood.baseParams.batchId, null, e.field, e.value, e.record.data.debit_credit, e.record.data.original_amount, e.record.data.currency_id, e.record.data.forex_rate, e.record.data.product_id, e.record.data.unit_id);
                        }
                    }
                }
                
            },
            cellclick: function(grid, rowIndex, columnIndex, e){
            
                selectedRowIndexImport = rowIndex;
                selectedRowImport = gridImportGood.getSelectionModel().getSelected();
                
                if (!isEmpty(selectedRowImport.data.id)) {
                    if (isEmpty(selectedRowImport.data.correspondence_id) && !selectedRowImport.data.master_type) 
                        gridImportGood.topToolbar.items.get('add_entry_import_good').disable();
                    else 
                        gridImportGood.topToolbar.items.get('add_entry_import_good').enable();
                }
                else {
                    gridImportGood.topToolbar.items.get('add_entry_import_good').disable();
                }
                
                comboDebitOptionImport.store.removeAll();
                comboCreditOptionImport.store.removeAll();
                if (gridImportGood.getColumnModel().getColumnId(columnIndex) == 'debit_account_id') {
                
                    if (!isEmpty(selectedRowImport.data.id) && (selectedRowImport.data.debit_credit == -1)) {
                        load_debit_account_import();
                    }
                    else 
                        if (isEmpty(selectedRowImport.data.id) &&
                        isEmpty(selectedRowImport.data.credit_account_id) &&
                        isEmpty(selectedRowImport.data.debit_credit)) {
                            var recordDebit = new Array({
                                account_id: null,
                                account_code: null,
                                account_name: null
                            });
                            comboDebitOptionImport.store.add(new Ext.data.Record(recordDebit));
                            load_debit_account_import();
                        }
                    
                }
                
                if (gridImportGood.getColumnModel().getColumnId(columnIndex) == 'credit_account_id') {
                    if (!isEmpty(selectedRowImport.data.id) && (selectedRowImport.data.debit_credit == 1)) {
                        load_credit_account_import();
                    }
                    else 
                        if (isEmpty(selectedRowImport.data.id) &&
                        isEmpty(selectedRowImport.data.debit_account_id) &&
                        isEmpty(selectedRowImport.data.debit_credit)) {
                            var recordCredit = new Array({
                                account_id: null,
                                account_code: null,
                                account_name: null
                            });
                            comboCreditOptionImport.store.add(new Ext.data.Record(recordCredit));
                            load_credit_account_import();
                        }
                }
            }
        }
    });
    
    gridImportGood.getView().getRowClass = function(record, index){
        if (record.data.master_type) 
            return 'blue-row';
        return 'green-row';
    };
    
    gridImportGood.on('keydown', function(e){
        if (e.keyCode == 46) {
            ImportGood.remove();
        }
    });
    
});

