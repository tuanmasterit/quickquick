var storeNo;

Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    var recNo = [{
        name: 'no_document_description',
        type: 'string'
    }, {
        name: 'is_load',
        type: 'boolean'
    }, {
        name: 'total_amount',
        type: 'string'
    }];

    var obj_recNo = Ext.data.Record.create(recNo);

    storeNo = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'no_document_description'
        }, obj_recNo),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getCostOfPurchase/1'
        }),
        autoLoad: false
    });

	storeNo.on('load', function(){
		if(storeNo.getCount() > 0){
			Ext.getCmp('add_no').disable();
		}else{
			Ext.getCmp('add_no').enable();
		}
	});

	var No = {
        add: function(){
            var newRecord = new obj_recNo();
            gridNo.getStore().insert(gridNo.getStore().getCount(), newRecord);
            gridNo.startEditing(gridNo.getStore().getCount() - 1, 1);
            gridNo.getSelectionModel().selectRow(gridNo.getStore().getCount() - 1);

            Ext.getCmp('coefficient').setValue(0);

        },
        remove: function(){
        	var rec = gridNo.getSelectionModel().getSelected();
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
					            'cashVoucherId': 0,
					            'bankId': 0
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
						            	Ext.getCmp('add_no').enable();
						            	gridNo.getStore().remove(rec);
						            	gridNo.getView().refresh(true);
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
						            noDoc: Ext.encode(rec.data.no_document_description),
						            type: Ext.encode('noDoc'),
						            batchId: Ext.encode(gridAccCost.getStore().baseParams.batchId)
						        }
						    });
                        }
                    }
                });
        	}
        }
    };

    var tbarNo = new Ext.Toolbar({
        items: [{
            id: 'add_no',
            text: 'Add'.translator('buy-billing'),
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: No.add
        }, {
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_no',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: No.remove
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_no',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
				gridNo.getStore().removeAll();
                gridNo.getStore().load();
            }
        }]
    });

    var cmNo = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(),{
            header: 'No Document Description'.translator('buy-billing'),
            dataIndex: 'no_document_description',
            id: 'no_document_description',
            width: 400,
            editable: true
        }, {
            header: 'Total Amount'.translator('buy-billing'),
            dataIndex: 'total_amount',
            id: 'total_amount',
            width: 100,
            align: 'right',
            renderer: render_number,
            editable: true
        }],
        editors: {
        	'total_amount': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e))
                            e.stopEvent();
                    }
                }
            })),
            'no_document_description': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
				allowBlank: false
            }))
        },
        getCellEditor: function(colIndex, rowIndex){
        	var rec = gridNo.getStore().getAt(rowIndex);
            if ((colIndex == 1) && !rec.data.is_load) {
                return this.editors['no_document_description'];
            }
			if ((colIndex == 2) && !rec.data.is_load) {
                return this.editors['total_amount'];
            }
        }
    });

    // create the Grid
    gridNo = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeNo,
        cm: cmNo,
        tbar: tbarNo,
        stripeRows: true,
        height: 180,
        loadMask: true,
        clicksToEdit: 1,
        trackMouseOver: true,
        frame: true,
		 sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        stateful: true,
        stateId: 'gridNo',
        id: 'gridNo',
        listeners: {
            beforeedit: function(e){
				if ((e.field == 'total_amount')) {
                    e.record.data.total_amount = number_format_extra(cN(e.value), decimals, decimalSeparator, '');
                }
            },
            afteredit: function(e){
	            if (e.field == 'total_amount'){
	            	e.record.data.total_amount = formatNumber(e.value);
	            }
	            if (e.field == 'no_document_description') {
					if (!e.record.data.is_load) {
	                    // insert
	                    if(!baseCheckExistedNoDoc(e.value)){
	                    	e.record.reject();
	                        warning('Warning'.translator('buy-billing'), 'Cost existed'.translator('buy-billing'));
	                        return;
	                    }
	                    e.record.commit();
	                    gridNo.getStore().baseParams.purchaseInvoiceId = gridDetail.getStore().baseParams.purchaseInvoiceId;
                		gridNo.getView().refresh(true);

	                }else{
	                	// update
	                }
                }
				if(!isEmpty(e.record.data.no_document_description) && !isEmpty(e.record.data.total_amount)){
		        	e.record.commit();
					initDetailExpenseOfPurchase(null, null);
			    }
            }
       	}
    });

    gridNo.on('rowclick', function(grid, rowIndex, e){
        var rec = grid.store.getAt(rowIndex);
        Ext.getCmp('coefficient').setValue(0);
        if (!rec.data.is_load) {
            // insert new cost
            initDetailExpenseOfPurchase();

        }
        else {
            // display detail of cost with cost id

			gridDetailExpense.getStore().removeAll();
            gridDetailExpense.getStore().baseParams = {
                'no_document_description': rec.data.no_document_description,
                'purchase_invoice_id': gridNo.getStore().baseParams.purchaseInvoiceId,
                'cost_invoice_id': 0,
                'cash_voucher_id': 0
            };
			gridDetailExpense.getStore().load();
        }
        grid.getView().focusEl.focus();
    });

});

var baseCheckExistedNoDoc = function(noDoc){
	for (var i = 0; i < storeNo.getCount(); i++) {
	   	var rec = storeNo.getAt(i);
    	if ((rec.data.no_document_description == noDoc) && rec.data.is_load){
            return false;
        }
    }
    return true;
};
