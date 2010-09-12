var buyBillingTable;
var tabs;
var gridInvoice;
var invoice_object;

var gridDetail;
var storeProductList;
var comboProductList;
var storeDetail;

var grid1;
var grid2;
var grid23;
var grid24;
var grid3;
var grid22;
var tabsAccounting1;
var tabsExpense;

var gridCost;
var gridCash;
var gridNo;
var gridDetailExpense;
var gridAccCost;
var gridInventory;
var storeWarehouse;

var gridProduct;
var productPanel;

var storeAccountList;

var page_size = 50;
var startLoadProduct = false;
var page_size_product = 100;

var IMPORT_RATE = 4;
var EXCISE_RATE = 2;
var VAT_RATE = 1;
var SEPC_DEFAULT = 6;

var date_format_string = 'd/m/Y';
var date_sql_format_string = 'Y-m-d';

var status = null; // insert, update
var selectedPurchaseInvoiceIndex;

var DetailRecord = Ext.data.Record.create(['product_id']);

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
            title: 'Confirm the period current'.translator('buy-billing'),
            buttons: Ext.MessageBox.YESNO,
            msg: 'Msg confirm the period current'.translator('buy-billing'),
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

    buyBillingTable = new Ext.FormPanel({
        frame: true,
        title: 'Purchase Invoice'.translator('buy-billing'),
        width: 1000,
        renderTo: 'BuyBillingTables',
        iconCls: 'icon-form',
        items: [tabs]
    });
    /*
    for (var i = 0; i < arrayProduct.length; i++) {
        var newRecord = new Array();
        newRecord['product_id'] = arrayProduct[i].product_id;
        newRecord['product_code'] = arrayProduct[i].product_code;
        newRecord['product_name'] = arrayProduct[i].product_name;
        newRecord['regular_unit_id'] = arrayProduct[i].regular_unit_id;
        newRecord['default_purchase_price'] = arrayProduct[i].default_purchase_price;
        var rec = new Ext.data.Record(newRecord);
        storeProductList.add(rec);
    }
    for (var i = 0; i < arrayService.length; i++) {
        var newRecord = new Array();
        newRecord['service_id'] = arrayService[i].service_id;
        newRecord['service_code'] = arrayService[i].service_code;
        newRecord['service_name'] = arrayService[i].service_name;
        newRecord['unit_id'] = arrayService[i].unit_id;
        var rec = new Ext.data.Record(newRecord);
        storeListService.add(rec);
    }*/

    for (var i = 0; i < arrayTaxRate.length; i++) {
        var newRecord = new Array();
        newRecord['tax_rate_id'] = arrayTaxRate[i].tax_rate_id;
        newRecord['rate'] = arrayTaxRate[i].rate;
        if (arrayTaxRate[i].tax_id == IMPORT_RATE) {
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

	for (var i = 0; i < arraySpecificity.length; i++) {
        var newRecord = new Array();
        newRecord['purchase_specificity_id'] = arraySpecificity[i].purchase_specificity_id;
        newRecord['specificity_text'] = arraySpecificity[i].specificity_text;
        newRecord['importValue'] = arraySpecificity[i].importValue;
        storeSpecificity.add(new Ext.data.Record(newRecord));
    }

	for (var i = 0; i < arrayCurrency.length; i++) {
        var newRecord = new Array();
        newRecord['currency_id'] = arrayCurrency[i].currency_id;
        newRecord['currency_name'] = arrayCurrency[i].currency_name;
        storeCurrency.add(new Ext.data.Record(newRecord));
    }

    for (var i = 0; i < arrayUnit.length; i++) {
        var newRecord = new Array();
        newRecord['unit_id'] = arrayUnit[i].unit_id;
        newRecord['unit_name'] = arrayUnit[i].unit_name;
        storeUnit.add(new Ext.data.Record(newRecord));
    }

    for (var i = 0; i < arrayAccount.length; i++) {
        var newRecord = new Array();
        newRecord['account_id'] = arrayAccount[i].account_id;
        newRecord['account_code'] = arrayAccount[i].account_code;
        newRecord['account_name'] = arrayAccount[i].account_name;
        storeAccountList.add(new Ext.data.Record(newRecord));
    }

    var newRecord = new Array();
    newRecord['subject_id'] = 0;
    newRecord['subject_name'] = 'All'.translator('stock-manage');
    storeSupplier.add(new Ext.data.Record(newRecord));
    for (var i = 0; i < arraySupplier.length; i++) {
        var newRecord = new Array();
        newRecord['subject_id'] = arraySupplier[i].subject_id;
        newRecord['subject_name'] = arraySupplier[i].subject_name;
        storeSupplier.add(new Ext.data.Record(newRecord));
    }

	for (var i = 0; i < arrayWarehouse.length; i++) {
        var newRecord = new Array();
        newRecord['warehouse_id'] = arrayWarehouse[i].warehouse_id;
        newRecord['warehouse_name'] = arrayWarehouse[i].warehouse_name;
        storeWarehouse.add(new Ext.data.Record(newRecord));
    }

	gridInvoice.getStore().load();
});
