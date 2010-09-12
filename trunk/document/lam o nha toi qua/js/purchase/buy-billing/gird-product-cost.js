var storeDetailExpense;
var obj_recDetailExpense;
var storeCurrency;
var storeUnit;

function render_unit_name(val){
    try {
        if (val == null || val == '')
            return '';
        return storeUnit.queryBy(function(rec){
            return rec.data.unit_id == val;
        }).itemAt(0).data.unit_name;
    }
    catch (e) {
    }
};

function render_currency_name(val){
    try {
        if (val == null || val == '')
            return '';
        return storeCurrency.queryBy(function(rec){
            return rec.data.currency_id == val;
        }).itemAt(0).data.currency_name;
    }
    catch (e) {
    }
};

Ext.onReady(function(){
    Ext.QuickTips.init();
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

	storeCurrency = new Ext.data.ArrayStore({
        fields: [{
            name: 'currency_id'
        }, {
            name: 'currency_name'
        }]
    });

    var recDetailExpense = [{
        name: 'product_name',
        type: 'string'
    }, {
        name: 'product_id',
        type: 'string'
    }, {
        name: 'unit_id',
        type: 'string'
    }, {
        name: 'amount',
        type: 'string'
    }, {
        name: 'currency_id',
        type: 'string'
    }, {
        name: 'forex_rate',
        type: 'string'
    }, {
        name: 'converted_amount',
        type: 'string'
    }, {
        name: 'original_quantity',
        type: 'string'
    }, {
        name: 'original_converted_quantity',
        type: 'string'
    }, {
        name: 'original_price',
        type: 'string'
    }, {
        name: 'original_amount',
        type: 'string'
    }, {
        name: 'original_converted_amount',
        type: 'string'
    }, {
        name: 'original_total_amount',
        type: 'string'
    }, {
        name: 'original_import_amount',
        type: 'string'
    }, {
        name: 'original_excise_amount',
        type: 'string'
    }, {
        name: 'original_vat_amount',
        type: 'string'
    }];

    obj_recDetailExpense = Ext.data.Record.create(recDetailExpense);

    storeDetailExpense = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'product_service_id'
        }, obj_recDetailExpense),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDetailCostOfPurchase/1'
        }),
        autoLoad: false
    });

    storeDetailExpense.on('load', function(){
        var total_original_quantity = 0;
        var total_original_converted_quantity = 0;
        var total_original_price = 0;
        var total_original_amount = 0;
        var total_original_converted_amount = 0;
        var total_original_import_amount = 0;
        var total_original_excise_amount = 0;
        var total_original_vat_amount = 0;
        var total_original_total_amount = 0;

        for (var i = 0; i < storeDetailExpense.getCount(); i++) {
            var record = storeDetailExpense.getAt(i);
            total_original_quantity += cN(record.data.original_quantity);
            total_original_converted_quantity += cN(record.data.original_converted_quantity);
            total_original_price += cN(record.data.original_price);
            total_original_amount += cN(record.data.original_amount);
            total_original_converted_amount += cN(record.data.original_converted_amount);
            total_original_import_amount += cN(record.data.original_import_amount);
            total_original_excise_amount += cN(record.data.original_excise_amount);
            total_original_vat_amount += cN(record.data.original_vat_amount);
            total_original_total_amount += cN(record.data.original_total_amount);
        }
        var rec = gridCost.getSelectionModel().getSelected();
        storeDetailExpense.baseParams = {
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
    });

    var cmDetailExpense = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Product Name'.translator('buy-billing'),
            dataIndex: 'product_name',
            id: 'product_name',
            width: 300
        }, {
            header: 'Unit'.translator('buy-billing'),
            dataIndex: 'unit_id',
            id: 'unit_id',
            width: 100,
            renderer: render_unit_name
        }, {
            header: 'Amount'.translator('buy-billing'),
            dataIndex: 'amount',
            id: 'amount',
            width: 120,
            align: 'right',
            renderer: render_number
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
            header: 'Converted Amount'.translator('buy-billing'),
            dataIndex: 'converted_amount',
            width: 100,
            align: 'right',
            renderer: render_number
        }]
    });

    var tbarDetailExpense = new Ext.Toolbar({
        items: ['->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_DetailExpense',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){

            }
        }]
    });

    gridDetailExpense = new Ext.grid.GridPanel({
        title: '',
        store: storeDetailExpense,
        cm: cmDetailExpense,
        //tbar: tbarDetailExpense,
        stripeRows: true,
        height: 255,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        stateful: true,
        stateId: 'gridDetailExpense',
        id: 'gridDetailExpense'
    });
});

var baseUpdateDetailExpense = function(coefficients){

    var activeTag = tabsExpense.getActiveTab();
    var rec;
    var serviceAmount;
    var purchaseInvoiceId;
    var costInvoiceId = 0;
    var cashVoucherId = 0;
    var noDocDescription = '';
    var type = '';
    var serviceId = 0;
    var serviceUnitId = 0;
    var bankId = 0;
    var bankAccountId = 0;
    var currencyId = null;
    var forexRate = null;
    switch (activeTag.id) {
        case 'invoiceExpense':
            rec = gridCost.getSelectionModel().getSelected();
            purchaseInvoiceId = gridCost.getStore().baseParams.purchaseInvoiceId;
            costInvoiceId = rec.data.cost_invoice_id;
            type = 'cost';
            serviceId = rec.data.service_id;
            serviceUnitId = rec.data.unit_id;
            currencyId = rec.data.currency_id;
            forexRate = rec.data.forex_rate;
            break;
        case 'noExpense':
            rec = gridNo.getSelectionModel().getSelected();
            purchaseInvoiceId = gridNo.getStore().baseParams.purchaseInvoiceId;
            noDocDescription = rec.data.no_document_description;
            type = 'noDoc';
            break;
        case 'cashExpense':
            rec = gridCash.getSelectionModel().getSelected();
            purchaseInvoiceId = gridCash.getStore().baseParams.purchaseInvoiceId;
            cashVoucherId = rec.data.cash_voucher_id;
            type = 'cash';
            bankId = rec.data.out_bank_id;
            bankAccountId = rec.data.out_bank_account_id;
            currencyId = rec.data.currency_id;
            forexRate = rec.data.forex_rate;
            break;
    }
    if (!isEmpty(rec)) {
        serviceAmount = cN(rec.data.total_amount);
    }
    else {
        return;
    }

    var detail = baseUpdateAmountDetail(currencyId, forexRate, coefficients, serviceAmount, purchaseInvoiceId,
	costInvoiceId, serviceId, serviceUnitId, cashVoucherId, bankId, bankAccountId, noDocDescription);
    if (!rec.data.is_load) {
		Ext.getCmp('coefficient').setValue(0);
		switch (activeTag.id) {
	        case 'invoiceExpense':
	            if(!baseCheckExistedCost(costInvoiceId)){
	           	 	gridCost.getStore().remove(rec);
					gridCost.getView().refresh(true);
	            	warning('Warning'.translator('buy-billing'), 'Cost existed'.translator('buy-billing'));
                    return;
	            }
	            break;
	        case 'noExpense':
				if(!baseCheckExistedNoDoc(noDocDescription)){
	           	 	gridNo.getStore().remove(rec);
					gridNo.getView().refresh(true);
	            	warning('Warning'.translator('buy-billing'), 'Cost existed'.translator('buy-billing'));
                    return;
	            }
	            break;
	        case 'cashExpense':
				if(!baseCheckExistedCash(cashVoucherId)){
	           	 	gridCash.getStore().remove(rec);
					gridCash.getView().refresh(true);
	            	warning('Warning'.translator('buy-billing'), 'Cost existed'.translator('buy-billing'));
                    return;
	            }
	            break;
	    }

        Ext.Ajax.request({
            url: pathRequestUrl + '/insertPurchaseCost/1',
            method: 'post',
            success: function(result, options){
                var result = Ext.decode(result.responseText);
                if (result.success) {
                	if(activeTag.id == 'noExpense'){
                		Ext.getCmp('add_no').disable();
                	}
					rec.data.is_load = true;
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
                purchaseInvoiceId: Ext.encode(purchaseInvoiceId),
                detail: Ext.encode(detail),
                batchId: Ext.encode(gridAccCost.getStore().baseParams.batchId),
                type: Ext.encode(type)
            }
        });
    }
    else {
    	var costInvoiceArray = new Array();
        costInvoiceArray.push(({
            'costInvoiceId': costInvoiceId,
            'serviceId': serviceId,
            'serviceUnitId': serviceUnitId
        }));
		var cashVoucherArray = new Array();
        cashVoucherArray.push(({
            'cashVoucherId': cashVoucherId,
            'bankId': bankId,
            'bankAccountId': bankAccountId
        }));
        Ext.Ajax.request({
            url: pathRequestUrl + '/updatePurchaseCost/1',
            method: 'post',
            success: function(result, options){
                var result = Ext.decode(result.responseText);
                if (result.success) {
                    Ext.getCmp('coefficient').setValue(0);
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
				purchaseInvoiceId: Ext.encode(purchaseInvoiceId),
                detail: Ext.encode(detail),
				batchId: Ext.encode(gridAccCost.getStore().baseParams.batchId),
                type: Ext.encode(type),
				costInvoiceArray: Ext.encode(costInvoiceArray),
				cashVoucherArray: Ext.encode(cashVoucherArray),
				noDocDescription: Ext.encode(noDocDescription)
            }
        });
    }
};

var baseUpdateAmountDetail = function(currencyId, forexRate, coefficients, serviceAmount, purchaseInvoiceId, costInvoiceId, serviceId, serviceUnitId, cashVoucherId, bankId, bankAccountId, noDocDescription){

    initDetailExpenseOfPurchase(currencyId, forexRate);
    var detail = new Array();
    for (var i = 0; i < gridDetailExpense.getStore().getCount(); i++) {
        var record = gridDetailExpense.getStore().getAt(i);
        switch (coefficients) {
            case 1:
                record.data.amount = serviceAmount * record.data.original_quantity / gridDetailExpense.getStore().baseParams.total_original_quantity;
                break;
            case 2:
                record.data.amount = serviceAmount * record.data.original_converted_quantity / gridDetailExpense.getStore().baseParams.total_original_converted_quantity;
                break;
            case 3:
                record.data.amount = serviceAmount * record.data.original_price / gridDetailExpense.getStore().baseParams.total_original_price;
                break;
            case 4:
                record.data.amount = serviceAmount * record.data.original_amount / gridDetailExpense.getStore().baseParams.total_original_amount;
                break;
            case 5:
                record.data.amount = serviceAmount * record.data.original_converted_amount / gridDetailExpense.getStore().baseParams.total_original_converted_amount;
                break;
            case 6:
                record.data.amount = serviceAmount * record.data.original_import_amount / gridDetailExpense.getStore().baseParams.total_original_import_amount;
                break;
            case 7:
                record.data.amount = serviceAmount * record.data.original_excise_amount / gridDetailExpense.getStore().baseParams.total_original_excise_amount;
                break;
            case 8:
                record.data.amount = serviceAmount * record.data.original_vat_amount / gridDetailExpense.getStore().baseParams.total_original_vat_amount;
                break;
            case 9:
                record.data.amount = serviceAmount * record.data.original_total_amount / gridDetailExpense.getStore().baseParams.total_original_total_amount;
                break;
        }
        record.data.converted_amount = record.data.amount * record.data.forex_rate;
        var record = ({
            'purchase_invoice_id': purchaseInvoiceId,
            'product_id': record.data.product_id,
            'service_id': serviceId,
            'service_unit_id': serviceUnitId,
            'unit_id': record.data.unit_id,
            'out_bank_id': bankId,
            'out_bank_account_id': bankAccountId,
            'cost_invoice_id': costInvoiceId,
            'cash_voucher_id': cashVoucherId,
            'no_document_description': noDocDescription,
            'amount': record.data.amount,
            'currency_id': record.data.currency_id,
            'forex_rate': record.data.forex_rate,
            'converted_amount': record.data.converted_amount
        });
        detail.push(record);
    }
    gridDetailExpense.getView().refresh(true);
    return detail;
};
