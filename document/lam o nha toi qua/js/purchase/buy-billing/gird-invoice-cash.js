var storeCash;
var storeListCashVoucherNotDistribution;
var comboCashVoucherNotDistribution;

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

	storeListCashVoucherNotDistribution = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'cash_voucher_id',
            fields: ['cash_voucher_id', 'cash_voucher_number', 'cash_voucher_date',
            'subject_name', 'subject_address', 'currency_id', 'forex_rate',
            'total_amount', 'out_bank_id', 'out_bank_account_id', 'description']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCashVoucherNotDistribution/1'
        }),
        autoLoad: true
    });

	comboCashVoucherNotDistribution = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeListCashVoucherNotDistribution,
        valueField: 'cash_voucher_id',
        displayField: 'cash_voucher_number',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: true,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 200
    });

    function render_cash_voucher(val){
        try {
            if (val == null || val == '')
                return '';
            return storeListCashVoucherNotDistribution.queryBy(function(rec){
                return rec.data.cash_voucher_id == val;
            }).itemAt(0).data.cash_voucher_number;
        }
        catch (e) {
        }
    };

    var recCash = [{
        name: 'cash_voucher_id',
        type: 'string'
    }, {
        name: 'is_load',
        type: 'boolean'
    }, {
        name: 'cash_voucher_date',
        type: 'string'
    }, {
        name: 'subject_name',
        type: 'string'
    }, {
        name: 'subject_address',
        type: 'string'
    }, {
        name: 'currency_id',
        type: 'string'
    }, {
        name: 'forex_rate',
        type: 'string'
    }, {
        name: 'total_amount',
        type: 'string'
    }, {
        name: 'description',
        type: 'string'
    }, {
        name: 'out_bank_id',
        type: 'string'
    }, {
        name: 'out_bank_account_id',
        type: 'string'
    }];

    var obj_recCash = Ext.data.Record.create(recCash);

    storeCash = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'cash_voucher_id'
        }, obj_recCash),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getCostOfPurchase/1'
        }),
        autoLoad: false
    });

	var Cash = {
        add: function(){
            var newRecord = new obj_recCash();
            gridCash.getStore().insert(gridCash.getStore().getCount(), newRecord);
            gridCash.startEditing(gridCash.getStore().getCount() - 1, 1);
            gridCash.getSelectionModel().selectRow(gridCash.getStore().getCount() - 1);

            Ext.getCmp('coefficient').setValue(0);
        },
        remove: function(){
        	var rec = gridCash.getSelectionModel().getSelected();
        	if(!isEmpty(rec) && rec.data.is_load){
				Ext.Msg.show({
                    title: 'Confirm'.translator('stock-manage'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Are delete cost'.translator('buy-billing'),
                    fn: function(btn){
                        if (btn == 'yes') {
                        	var cashVoucherArray = new Array();
					        cashVoucherArray.push(({
					            'cashVoucherId': rec.data.cash_voucher_id,
					            'bankId': rec.data.out_bank_id
					        }));
					        var costInvoiceArray = new Array();
					        costInvoiceArray.push(({
					            'costInvoiceId': 0,
					            'serviceId': 0
					        }));
                        	Ext.Ajax.request({
						        url: pathRequestUrl + '/deleteCostOfPurchase/1',
						        method: 'post',
						        success: function(result, options){
						            var result = Ext.decode(result.responseText);
						            if (result.success) {
						            	gridCash.getStore().remove(rec);
						            	gridCash.getView().refresh(true);
						            	gridDetailExpense.getStore().removeAll();
						            	gridAccCost.getStore().removeAll();
               							gridAccCost.getStore().load();
						            }
						        },
						        failure: function(response, request){
						        },
						        params: {
						            purchaseInvoiceId: Ext.encode(gridCash.getStore().baseParams.purchaseInvoiceId),
						            costInvoiceArray: Ext.encode(costInvoiceArray),
						            cashVoucherArray: Ext.encode(cashVoucherArray),
						            noDoc: Ext.encode(null),
						            type: Ext.encode('cash'),
						            batchId: Ext.encode(gridAccCost.getStore().baseParams.batchId)
						        }
						    });
                        }
                    }
                });
        	}
        }
    };

    var tbarCash = new Ext.Toolbar({
        items: [{
            id: 'add_Cash',
            text: 'Add'.translator('buy-billing'),
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Cash.add
        }, {
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_Cash',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Cash.remove
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_Cash',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
				gridDetailExpense.getStore().removeAll();
                gridCash.getStore().removeAll();
                gridCash.getStore().load();
            }
        }]
    });

    var cmCash = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Cash Voucher Number'.translator('buy-billing'),
            dataIndex: 'cash_voucher_id',
            id: 'cash_voucher_id',
            width: 105,
            editable: true,
            renderer: render_cash_voucher
        }, {
            header: 'Cash Voucher Date'.translator('buy-billing'),
            dataIndex: 'cash_voucher_date',
            id: 'cash_voucher_date',
            width: 77
        }, {
            header: 'Cash Subject Name'.translator('buy-billing'),
            dataIndex: 'subject_name',
            id: 'subject_name',
            width: 150
        }, {
            header: 'Cash Subject Address'.translator('buy-billing'),
            dataIndex: 'subject_address',
            id: 'subject_address',
            width: 130
        }, {
            header: 'Currency Type'.translator('buy-billing'),
            dataIndex: 'currency_id',
            id: 'currency_id',
            width: 100,
            renderer: render_currency_name
        }, {
            header: 'Forex Rate'.translator('buy-billing'),
            dataIndex: 'forex_rate',
            id: 'forex_rate',
            width: 80,
            align: 'right',
            renderer: render_number
        }, {
            header: 'Total Amount'.translator('buy-billing'),
            dataIndex: 'total_amount',
            width: 100,
            align: 'right',
            renderer: render_number
        }, {
            header: 'Description'.translator('buy-billing'),
            width: 200,
            dataIndex: 'description',
            id: 'description'
        }],
        editors: {
    		'cashVoucherId': new Ext.grid.GridEditor(comboCashVoucherNotDistribution)
    	},
    	getCellEditor: function(colIndex, rowIndex) {
    		var rec = gridCash.getStore().getAt(rowIndex);
			if (colIndex == 1 && !rec.data.is_load) {
                return this.editors['cashVoucherId'];
            }
    	}
    });

    // create the Grid
    gridCash = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeCash,
        cm: cmCash,
        tbar: tbarCash,
        stripeRows: true,
        height: 180,
        loadMask: true,
        trackMouseOver: true,
        clicksToEdit: 1,
        frame: true,
		 sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        stateful: true,
        stateId: 'gridCash',
        id: 'gridCash',
        listeners: {
            afteredit: function(e){
                if (e.field == 'cash_voucher_id') {
					//insert cash for purchase
                    if (!e.record.data.is_load) {

                    	if(!baseCheckExistedCash(e.value)){
                    		e.record.reject();
                            warning('Warning'.translator('buy-billing'), 'Cost existed'.translator('buy-billing'));
                            return;
                    	}

                        var objectCash = storeListCashVoucherNotDistribution.queryBy(function(rec){
                            return rec.data.cash_voucher_id == e.value;
                        }).itemAt(0);
                        if (!isEmpty(objectCash)) {
	                        e.record.data.out_bank_id = objectCash.data.out_bank_id;
	                        e.record.data.out_bank_account_id = objectCash.data.out_bank_account_id;
                            e.record.data.cash_voucher_date = objectCash.data.cash_voucher_date;
                            e.record.data.subject_name = objectCash.data.subject_name;
                            e.record.data.subject_address = objectCash.data.subject_address;
                            e.record.data.currency_id = objectCash.data.currency_id;
                            e.record.data.forex_rate = objectCash.data.forex_rate;
                            e.record.data.total_amount = objectCash.data.total_amount;
                            e.record.data.description = objectCash.data.description;
                        }
                        e.record.commit();
                        gridCash.getView().refresh(true);
                        gridCash.getStore().baseParams.purchaseInvoiceId = gridDetail.getStore().baseParams.purchaseInvoiceId;

			            initDetailExpenseOfPurchase(objectCash.data.currency_id, objectCash.data.forex_rate);
                    }
                    else {

                        // update cash for purchase
                    }
                }
            }
        }
    });

    gridCash.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.store.getAt(rowIndex);
        Ext.getCmp('coefficient').setValue(0);
        if (!rec.data.is_load) {
            // insert new cost
            initDetailExpenseOfPurchase(rec.data.currency_id, rec.data.forex_rate);
        }
        else {
            // display detail of cost with cost id

			gridDetailExpense.getStore().removeAll();
            gridDetailExpense.getStore().baseParams = {
                'cost_invoice_id': 0,
                'purchase_invoice_id': gridCost.getStore().baseParams.purchaseInvoiceId,
                'no_document_description': '',
                'cash_voucher_id': rec.data.cash_voucher_id
            };
			gridDetailExpense.getStore().load();
        }
        grid.getView().focusEl.focus();
    });

    gridCash.on('keydown', function(e){
	    if (e.keyCode == 46) {
        	Cash.remove();
        }
    }, this);
});

var baseCheckExistedCash = function(cashInvoiceId){
	for (var i = 0; i < storeCash.getCount(); i++) {
	   	var rec = storeCash.getAt(i);
    	if ((rec.data.cash_voucher_id == cashInvoiceId) && rec.data.is_load){
            return false;
        }
    }
    return true;
};
