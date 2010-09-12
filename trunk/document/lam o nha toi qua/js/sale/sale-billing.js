var saleBillingTable;
var tabs;
// invoice
var gridInvoice;
var invoice_object;
var storeCurrencyWithForexRate;
var storeCustomer;
// detail
var gridDetail;
var storeDetail;
var storeImportRate;
var storeExciseRate;
var storeVatRate;
var storeUnit;
// accounting
var storeCurrency;
var storeAccountList;
// inventory
var gridInventory;
var storeWarehouse;

var tabsAccounting;

var page_size = 50;

var EXPORT_RATE = 3;
var EXCISE_RATE = 2;
var VAT_RATE = 1;
var SEPC_DEFAULT = 6;
var date_format_string = 'd/m/Y';
var date_sql_format_string = 'Y-m-d';

var status = null; // insert, update
var selectedSaleInvoiceIndex;

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

function render_warehouse_name(val){
    try {
        if (val == null || val == '')
            return '';
        return storeWarehouse.queryBy(function(rec){
            return rec.data.warehouse_id == val;
        }).itemAt(0).data.warehouse_name;
    }
    catch (e) {
    }
};

function render_currency_name(val){
    try {
        if (val == null || val == '')
            return '';
        return storeCurrencyWithForexRate.queryBy(function(rec){
            return rec.data.currency_id == val;
        }).itemAt(0).data.currency_name;
    }
    catch (e) {
    }
};

function render_number(val){
    try {
        if (val == null || val == '')
            val = 0.00;
        return number_format_extra(val, decimals, decimalSeparator, thousandSeparator);
    }
    catch (e) {
    }
};

Ext.onReady(function(){
    if (currentPeriodId == 0) {
        Ext.Msg.show({
            title: 'Confirm the period current'.translator('sale-billing'),
            buttons: Ext.MessageBox.YESNO,
            msg: 'Msg confirm the period current'.translator('sale-billing'),
            icon: Ext.MessageBox.QUESTION,
            fn: function(btn){
                if (btn == 'yes') {
                    window.location.href = Quick.baseUrl + '/accountant/maintenance/period-accounting';
                }
                else {
                    window.location.href = Quick.baseUrl + '/accountant';
                }
            }
        });
    }

    saleBillingTable = new Ext.FormPanel({
        frame: true,
        title: 'Sale Invoice'.translator('sale-billing'),
        width: 1000,
        renderTo: 'SaleBillingTables',
        iconCls: 'icon-form',
        items: [tabs]
    });

	storeImportRate = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id',
            type: 'string'
        }, {
            name: 'rate',
            type: 'string'
        }]
    });

	storeExciseRate = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id',
            type: 'string'
        }, {
            name: 'rate',
            type: 'string'
        }]
    });

	storeVatRate = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id',
            type: 'string'
        }, {
            name: 'rate',
            type: 'string'
        }]
    });

    for (var i = 0; i < arrayTaxRate.length; i++) {
        var newRecord = new Array();
        newRecord['tax_rate_id'] = arrayTaxRate[i].tax_rate_id;
        newRecord['rate'] = arrayTaxRate[i].rate;
        if (arrayTaxRate[i].tax_id == EXPORT_RATE) {
            storeImportRate.add(new Ext.data.Record(newRecord));
        }
        else
            if (arrayTaxRate[i].tax_id == EXCISE_RATE) {
                storeExciseRate.add(new Ext.data.Record(newRecord));
            }
            else
                if (arrayTaxRate[i].tax_id == VAT_RATE) {
                    storeVatRate.add(new Ext.data.Record(newRecord));
                }
    }

	storeCurrency = new Ext.data.ArrayStore({
        fields: [{
            name: 'currency_id',
            type: 'string'
        }, {
            name: 'currency_name',
            type: 'string'
        }]
    });

	for (var i = 0; i < arrayCurrency.length; i++) {
        var newRecord = new Array();
        newRecord['currency_id'] = arrayCurrency[i].currency_id;
        newRecord['currency_name'] = arrayCurrency[i].currency_name;
        storeCurrency.add(new Ext.data.Record(newRecord));
    }

	storeUnit = new Ext.data.ArrayStore({
        fields: [{
            name: 'unit_id',
            type: 'string'
        }, {
            name: 'unit_name',
            type: 'string'
        }]
    });

    for (var i = 0; i < arrayUnit.length; i++) {
        var newRecord = new Array();
        newRecord['unit_id'] = arrayUnit[i].unit_id;
        newRecord['unit_name'] = arrayUnit[i].unit_name;
        storeUnit.add(new Ext.data.Record(newRecord));
    }
	
	storeWarehouse = new Ext.data.ArrayStore({
        fields: [{
            name: 'warehouse_id',
            type: 'string'
        }, {
            name: 'warehouse_name',
            type: 'string'
        }]
    });


	for (var i = 0; i < arrayWarehouse.length; i++) {
        var newRecord = new Array();
        newRecord['warehouse_id'] = arrayWarehouse[i].warehouse_id;
        newRecord['warehouse_name'] = arrayWarehouse[i].warehouse_name;
        storeWarehouse.add(new Ext.data.Record(newRecord));
    }

	gridInvoice.getStore().load();
});
