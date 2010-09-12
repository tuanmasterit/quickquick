var storeCost;
var comboServiceInvoiceNotDistribution;
var storeListServiceInvoiceNotDistribution;
var initDetailExpenseOfPurchase;

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    storeListServiceInvoiceNotDistribution = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'purchase_invoice_id',
            fields: ['purchase_invoice_id', 'purchase_serial_number', 'purchase_invoice_number', 'purchase_invoice_date', 'service_id', 'unit_id', 'supplier_name', 'supplier_address', 'supplier_tax_code', 'currency_id', 'forex_rate', 'total_amount', 'description']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListServiceInvoiceNotDistribution/1'
        }),
        autoLoad: true
    });

    comboServiceInvoiceNotDistribution = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeListServiceInvoiceNotDistribution,
        valueField: 'purchase_invoice_id',
        displayField: 'purchase_serial_number',
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

    function render_service_invoice(val){
        try {
            if (val == null || val == '')
                return '';
            return storeListServiceInvoiceNotDistribution.queryBy(function(rec){
                return rec.data.purchase_invoice_id == val;
            }).itemAt(0).data.purchase_serial_number;
        }
        catch (e) {
        }
    };

    var recCost = [{
        name: 'cost_invoice_id',
        type: 'string'
    }, {
        name: 'service_id',
        type: 'string'
    }, {
        name: 'unit_id',
        type: 'string'
    }, {
        name: 'is_load',
        type: 'boolean'
    }, {
        name: 'purchase_serial_number',
        type: 'string'
    }, {
        name: 'purchase_invoice_number',
        type: 'string'
    }, {
        name: 'purchase_invoice_date',
        type: 'string'
    }, {
        name: 'supplier_name',
        type: 'string'
    }, {
        name: 'supplier_address',
        type: 'string'
    }, {
        name: 'supplier_tax_code',
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
    }];

    var obj_recCost = Ext.data.Record.create(recCost);

    storeCost = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'cost_invoice_id'
        }, obj_recCost),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getCostOfPurchase/1'
        }),
        autoLoad: false
    });

    var Cost = {
        add: function(){
            var newRecord = new obj_recCost();
            gridCost.getStore().insert(gridCost.getStore().getCount(), newRecord);
            gridCost.startEditing(gridCost.getStore().getCount() - 1, 1);
            gridCost.getSelectionModel().selectRow(gridCost.getStore().getCount() - 1);

            Ext.getCmp('coefficient').setValue(0);

        },
        remove: function(){
        	var rec = gridCost.getSelectionModel().getSelected();
        	if(!isEmpty(rec) && rec.data.is_load){
				Ext.Msg.show({
                    title: 'Confirm'.translator('stock-manage'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Are delete cost'.translator('buy-billing'),
                    fn: function(btn){
                        if (btn == 'yes') {
                        	var costInvoiceArray = new Array();
					        costInvoiceArray.push(({
					            'costInvoiceId': rec.data.cost_invoice_id,
					            'serviceId': rec.data.service_id
					        }));
					        var cashVoucherArray = new Array();
					        cashVoucherArray.push(({
					            'cashVoucherId': 0,
					            'bankId': 0
					        }));
                        	Ext.Ajax.request({
						        url: pathRequestUrl + '/deleteCostOfPurchase/1',
						        method: 'post',
						        success: function(result, options){
						            var result = Ext.decode(result.responseText);
						            if (result.success) {
						            	gridCost.getStore().remove(rec);
						            	gridCost.getView().refresh(true);
						            	gridDetailExpense.getStore().removeAll();
						            	gridAccCost.getStore().removeAll();
               							gridAccCost.getStore().load();
						            }
						        },
						        failure: function(response, request){
						        },
						        params: {
						            purchaseInvoiceId: Ext.encode(gridCost.getStore().baseParams.purchaseInvoiceId),
						            costInvoiceArray: Ext.encode(costInvoiceArray),
						            cashVoucherArray: Ext.encode(cashVoucherArray),
						            noDoc: Ext.encode(''),
						            type: Ext.encode('cost'),
						            batchId: Ext.encode(gridAccCost.getStore().baseParams.batchId)
						        }
						    });
                        }
                    }
                });
        	}
        }
    };

    initDetailExpenseOfPurchase = function(currencyId, forexRate){
        gridDetailExpense.getStore().removeAll();
        var total_original_quantity = 0;
        var total_original_converted_quantity = 0;
        var total_original_price = 0;
        var total_original_amount = 0;
        var total_original_converted_amount = 0;
        var total_original_import_amount = 0;
        var total_original_excise_amount = 0;
        var total_original_vat_amount = 0;
        var total_original_total_amount = 0;

        for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
            var record = gridDetail.getStore().getAt(i);
            if(record.data.isChecked){
	            var newDetailRecord = new obj_recDetailExpense({
	                is_load: false,
	                product_name: record.data.product_name,
	                product_id: record.data.product_id,
	                unit_id: record.data.unit_id,
	                currency_id: isEmpty(currencyId) ? gridDetail.getStore().baseParams.currency_id : currencyId,
	                amount: null,
	                forex_rate: isEmpty(forexRate) ? gridDetail.getStore().baseParams.forexrate : forexRate,
	                converted_amount: null,
	                original_quantity: cN(record.data.quantity),
	                original_converted_quantity: 0,
	                original_price: cN(record.data.price),
	                original_amount: cN(record.data.amount),
	                original_converted_amount: cN(record.data.converted_amount),
	                original_import_amount: cN(record.data.import_amount),
	                original_excise_amount: cN(record.data.excise_amount),
	                original_vat_amount: cN(record.data.vat_amount),
	                original_total_amount: cN(record.data.total_amount)
	            });
	            gridDetailExpense.getStore().insert(gridDetailExpense.getStore().getCount(), newDetailRecord);
	            total_original_quantity += cN(record.data.quantity);
	            total_original_converted_quantity += 0;
	            total_original_price += cN(record.data.price);
	            total_original_amount += cN(record.data.amount);
	            total_original_converted_amount += cN(record.data.converted_amount);
	            total_original_import_amount += cN(record.data.import_amount);
	            total_original_excise_amount += cN(record.data.excise_amount);
	            total_original_vat_amount += cN(record.data.vat_amount);
	            total_original_total_amount += cN(record.data.total_amount);
            }
        }
        gridDetailExpense.getStore().baseParams = {
            'total_original_quantity': total_original_quantity,
            'total_original_converted_quantity': total_original_converted_quantity,
            'total_original_price': total_original_price,
            'total_original_amount': total_original_amount,
            'total_original_converted_amount': total_original_converted_amount,
            'total_original_import_amount': total_original_import_amount,
            'total_original_excise_amount': total_original_excise_amount,
            'total_original_vat_amount': total_original_vat_amount,
            'total_original_total_amount': total_original_total_amount
        };
        gridDetailExpense.getView().refresh(true);
    };

    var tbarCost = new Ext.Toolbar({
        items: [{
            id: 'add_cost',
            text: 'Add'.translator('buy-billing'),
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Cost.add
        }, {
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_cost',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Cost.remove
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_cost',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                Ext.getCmp('coefficient').setValue(0);
                gridDetailExpense.getStore().removeAll();
                gridCost.getStore().removeAll();
                gridCost.getStore().load();
            }
        }]
    });

    var cmCost = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Invoice Seri Number'.translator('buy-billing'),
            dataIndex: 'cost_invoice_id',
            id: 'cost_invoice_id',
            width: 105,
            editable: true,
            renderer: render_service_invoice
        }, {
            header: 'Invoice Number'.translator('buy-billing'),
            dataIndex: 'purchase_invoice_number',
            id: 'purchase_invoice_number',
            width: 100
        }, {
            header: 'Invoice Date'.translator('buy-billing'),
            dataIndex: 'purchase_invoice_date',
            id: 'purchase_invoice_date',
            width: 77
        }, {
            header: 'Saler Name'.translator('buy-billing'),
            dataIndex: 'supplier_name',
            id: 'supplier_name',
            width: 150
        }, {
            header: 'Saler Address'.translator('buy-billing'),
            dataIndex: 'supplier_address',
            id: 'supplier_address',
            width: 100
        }, {
            header: 'Saler Tax'.translator('buy-billing'),
            dataIndex: 'supplier_tax_code',
            id: 'supplier_tax_code',
            width: 120
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
            header: 'Original Amount'.translator('buy-billing'),
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
    		'costInvoiceId': new Ext.grid.GridEditor(comboServiceInvoiceNotDistribution)
    	},
    	getCellEditor: function(colIndex, rowIndex) {
    		var rec = gridCost.getStore().getAt(rowIndex);
			if (colIndex == 1 && !rec.data.is_load) {
                return this.editors['costInvoiceId'];
            }
    	}
    });

    // create the Grid
    gridCost = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeCost,
        cm: cmCost,
        tbar: tbarCost,
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
        stateId: 'gridCost',
        id: 'gridCost',
        listeners: {
            afteredit: function(e){
                if (e.field == 'cost_invoice_id') {
                    //insert cost for purchase
                    if (!e.record.data.is_load) {

                    	if(!baseCheckExistedCost(e.value)){
                    		e.record.reject();
                            warning('Warning'.translator('buy-billing'), 'Cost existed'.translator('buy-billing'));
                            return;
                    	}
                        var objectService = storeListServiceInvoiceNotDistribution.queryBy(function(rec){
                            return rec.data.purchase_invoice_id == e.value;
                        }).itemAt(0);
                        if (!isEmpty(objectService)) {
                            e.record.data.service_id = objectService.data.service_id;
                            e.record.data.unit_id = objectService.data.unit_id;
                            e.record.data.purchase_invoice_number = objectService.data.purchase_invoice_number;
                            e.record.data.purchase_invoice_date = objectService.data.purchase_invoice_date;
                            e.record.data.supplier_name = objectService.data.supplier_name;
                            e.record.data.supplier_address = objectService.data.supplier_address;
                            e.record.data.supplier_tax_code = objectService.data.supplier_tax_code;
                            e.record.data.currency_id = objectService.data.currency_id;
                            e.record.data.forex_rate = objectService.data.forex_rate;
                            e.record.data.total_amount = objectService.data.total_amount;
                            e.record.data.description = objectService.data.description;
                        }
                        e.record.commit();
                        gridCost.getView().refresh(true);
                        gridCost.getStore().baseParams.purchaseInvoiceId = gridDetail.getStore().baseParams.purchaseInvoiceId;

						initDetailExpenseOfPurchase(objectService.data.currency_id, objectService.data.forex_rate);
                        //gridDetailExpense.getStore().baseParams.service_amount = cN(objectService.data.total_amount);
                    }
                    else {

                        // update cost for purchase
                    }
                }
            }
        }
    });

    gridCost.on('rowclick', function(grid, rowIndex, e){
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
                'cost_invoice_id': rec.data.cost_invoice_id,
                'purchase_invoice_id': gridCost.getStore().baseParams.purchaseInvoiceId,
                'no_document_description': '',
                'cash_voucher_id': 0
            };
            gridDetailExpense.getStore().load();
        }
        grid.getView().focusEl.focus();
    });

    gridCost.on('keydown', function(e){
	    if (e.keyCode == 46) {
        	Cost.remove();
        }
    }, this);

});

var baseCheckExistedCost = function(costInvoiceId){
	for (var i = 0; i < storeCost.getCount(); i++) {
	   	var rec = storeCost.getAt(i);
    	if ((rec.data.cost_invoice_id == costInvoiceId) && rec.data.is_load){
            return false;
        }
    }
    return true;
};
