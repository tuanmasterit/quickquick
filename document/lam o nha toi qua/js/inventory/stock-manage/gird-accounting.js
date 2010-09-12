var storeAcc;
var isLoadedAccCost = false;
var storeDebitAccount; // with entry type 19, 20, 21
var storeCreditAccount; // with entry type 19, 20, 21

function render_number1(val){
    try {
        if (val == null || val == '')
            return '';
        return number_format_extra(val, decimals, decimalSeparator, thousandSeparator);
    }
    catch (e) {
    }
};

function render_account_code(val){
    try {
        if (val == null || val == '')
            return '';
        return storeAccountList.queryBy(function(rec){
            return rec.data.account_id == val;
        }).itemAt(0).data.account_code;
    }
    catch (e) {
    }
};

function render_account_name(val){
    try {
        if (val == null || val == '')
            return '';
        return storeAccountList.queryBy(function(rec){
            return rec.data.account_id == val;
        }).itemAt(0).data.account_name;
    }
    catch (e) {
    }
};

Ext.onReady(function(){
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

	var arrayEntryTypeId = new Array({
        'entry_type_id': 19
    }, {
        'entry_type_id': 20
    }, {
        'entry_type_id': 21
    });

    storeDebitAccount = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'entry_type_id', 'account_code', 'account_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDebitAccount/1'
        }),
        autoLoad: false
    });

    function load_debit_account(entryTypeId){
        for (var i = 0; i < storeDebitAccount.getCount(); i++) {
            if (storeDebitAccount.getAt(i).data.entry_type_id == entryTypeId) {
                var recordDebit = new Array();
                recordDebit['account_id'] = storeDebitAccount.getAt(i).data.account_id;
                recordDebit['account_code'] = storeDebitAccount.getAt(i).data.account_code;
                recordDebit['account_name'] = storeDebitAccount.getAt(i).data.account_name;
                var rec = new Ext.data.Record(recordDebit);
                comboDebitOption.store.add(rec);
            }
        }
    };

    storeCreditAccount = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'entry_type_id', 'account_code', 'account_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getCreditAccount/1'
        }),
        autoLoad: false
    });

    function load_credit_account(entryTypeId){
        for (var i = 0; i < storeCreditAccount.getCount(); i++) {
            if (storeCreditAccount.getAt(i).data.entry_type_id == entryTypeId) {
                var recordCredit = new Array();
                recordCredit['account_id'] = storeCreditAccount.getAt(i).data.account_id;
                recordCredit['account_code'] = storeCreditAccount.getAt(i).data.account_code;
                recordCredit['account_name'] = storeCreditAccount.getAt(i).data.account_name;
                var rec = new Ext.data.Record(recordCredit);
                comboCreditOption.store.add(rec);
            }
        }
    };

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
                //selectedRow.data.account_name = record.data.account_name;
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
                //selectedRow.data.account_name = record.data.account_name;
            }
        }
    });

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

    var recAcc = [{
        name: 'debit_credit',
        type: 'string'
    }, {
        name: 'product_name',
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
        name: 'account_id',
        type: 'string'
    }, {
        name: 'original_amount',
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
    }, {
        name: 'entry_type_id',
        type: 'string'
    }, {
        name: 'entry_id',
        type: 'string'
    }, {
        name: 'correspondence_id',
        type: 'string'
    }];

    var obj_recAcc = Ext.data.Record.create(recAcc);

    storeAcc = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'detail_id'
        }, obj_recAcc),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getAccountingOfInventory/1'
        }),
        autoLoad: false,
        groupField: 'product_name',
        sortInfo: {
            field: 'product_name',
            direction: 'ASC'
        }
    });

	storeAcc.on('beforeload', function(){
        if (!isLoadedAccCost) {
            isLoadedAccCost = true;
            storeDebitAccount.load({
                params: {
                    arr: Ext.encode(arrayEntryTypeId)
                }
            });

            storeCreditAccount.load({
                params: {
                    arr: Ext.encode(arrayEntryTypeId)
                }
            });
        }
    });

    storeAcc.on('load', function(){
        var totalDebit = 0;
        var totalCredit = 0;
        for (var i = 0; i < storeAcc.getCount(); i++) {
            var record = storeAcc.getAt(i);
            if (record.data.debit_credit == -1)
                totalDebit += cN(record.data.original_amount);
            else
                totalCredit += cN(record.data.original_amount);
            if (!isEmpty(record.data.debit_account_id)) {
                record.data.account_name = storeAccountList.queryBy(function(rec){
                    return rec.data.account_id == record.data.debit_account_id;
                }).itemAt(0).data.account_name;
            }
            else
                if (!isEmpty(record.data.credit_account_id)) {
                    record.data.account_name = storeAccountList.queryBy(function(rec){
                        return rec.data.account_id == record.data.credit_account_id;
                    }).itemAt(0).data.account_name;
                }
        }
        Ext.getCmp('lblDebit_Acc').setText(number_format_extra(totalDebit, decimals, decimalSeparator, thousandSeparator));
		Ext.getCmp('lblCredit_Acc').setText(number_format_extra(totalCredit, decimals, decimalSeparator, thousandSeparator));
        storeAcc.sort('original_amount', 'ASC');

    });

    var tbarAcc = new Ext.Toolbar({
        items: [{
            text: 'Total Debt'.translator('buy-billing'),
            id: 'txtDebit_Acc'
        }, {
            xtype: 'label',
            id: 'lblDebit_Acc'
        }, '-', {
            text: 'Total Credit'.translator('buy-billing'),
            id: 'txtCredit_Acc'
        }, {
            xtype: 'label',
            id: 'lblCredit_Acc'
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_Acc',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                gridAcc.getStore().removeAll();
                gridAcc.getStore().reload();
            }
        }]
    });

    var cmAcc = new Ext.grid.ColumnModel({
        defaults: {
            sortable: false
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Account Name'.translator('buy-billing'),
            dataIndex: 'account_id',
            width: 180,
            renderer: render_account_name
        }, {
            header: 'Debit'.translator('buy-billing'),
            dataIndex: 'debit_account_id',
            id: 'debit_account_id',
            width: 50,
            align: 'right',
            renderer: render_account_code,
            editable: true
        }, {
            header: 'Credit'.translator('buy-billing'),
            dataIndex: 'credit_account_id',
            id: 'credit_account_id',
            width: 50,
            align: 'right',
            renderer: render_account_code,
            editable: true
        }, {
            header: 'Original Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'original_amount',
            id: 'original_amount',
            align: 'right',
            renderer: render_number
        }, {
            header: 'Currency Type'.translator('buy-billing'),
            width: 100,
            dataIndex: 'currency_name',
            align: 'right'
        }, {
            header: 'Forex Rate'.translator('buy-billing'),
            width: 100,
            dataIndex: 'forex_rate',
            align: 'right',
            renderer: render_number1
        }, {
            header: 'Converted Original Amount'.translator('buy-billing'),
            width: 150,
            dataIndex: 'converted_amount',
            align: 'right',
            renderer: render_number
        }, {
            header: 'Product'.translator('buy-billing'),
            width: 250,
            dataIndex: 'product_name',
            align: 'right',
            hidden: true
        }],
        editors: {
            'creditCombo': new Ext.grid.GridEditor(comboCreditOption),
            'debitCombo': new Ext.grid.GridEditor(comboDebitOption)
        },
        getCellEditor: function(colIndex, rowIndex){
            var rec = gridAcc.getStore().getAt(rowIndex);
            if (colIndex == 2 && (rec.data.master_type == 1)) {
                return this.editors['debitCombo'];
            }
            if (colIndex == 3 && (rec.data.master_type == 0)) {
                return this.editors['creditCombo'];
            }
        }
    });

    // create the Grid
    gridAcc = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeAcc,
        cm: cmAcc,
        tbar: tbarAcc,
        stripeRows: true,
        height: 557,
        loadMask: true,
        trackMouseOver: true,
        frame: true,        
        clicksToEdit: 1,
        id: 'gridAcc',
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'.translator('buy-billing')
        },
        view: new Ext.grid.GroupingView({
            forceFit: true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "' + 'Items'.translator('buy-billing') + '" : "' + 'Item'.translator('buy-billing') + '"]})'
        }),
        listeners: {
            beforeedit: function(e){

            },
            afteredit: function(e){
				if ((e.field == 'debit_account_id') || (e.field == 'credit_account_id')) {
                    Ext.Ajax.request({
                        url: pathRequestUrl + '/updateAccountingCost/1',
                        method: 'post',
                        success: function(result, options){
                            var result = Ext.decode(result.responseText);
                            if (result.success) {
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
                            record.reject();
                        },
                        params: {
                            entryId: Ext.encode(e.record.data.entry_id),
                            correspondenceId: Ext.encode(e.record.data.correspondence_id),
                            accountId: Ext.encode(e.value)
                        }
                    });
                }
            },
            cellclick: function(grid, rowIndex, columnIndex, e){
				var rec = gridAcc.getSelectionModel().getSelected();

                if ((gridAcc.getColumnModel().getColumnId(columnIndex) == 'debit_account_id') &&
                (rec.data.master_type == 1)) {

                    comboDebitOption.store.removeAll();
                    load_debit_account(rec.data.entry_type_id);
                }

                if ((gridAcc.getColumnModel().getColumnId(columnIndex) == 'credit_account_id') &&
                (rec.data.master_type == 0)) {

                    comboCreditOption.store.removeAll();
                    load_credit_account(rec.data.entry_type_id);
                }
            }
        }
    });

    gridAcc.getView().getRowClass = function(record, index){
        if (record.data.master_type == 1)
            return 'blue-row';
        return 'green-row';
    };
});
