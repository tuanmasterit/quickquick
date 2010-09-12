var stockManageTable;
var page_size = 50;
var date_format_string = 'd/m/Y';
var date_sql_format_string = 'Y-m-d';
var status = null;

var gridInvoice;
var gridSaleInvoice;
var gridInventory;
var gridAcc;
var storeAccountList;

var SALE_INHER = 'SALE_INHER';
var PURC_INHER = 'PURC_INHER';

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
	$('#div-form-product').css('display', 'none');
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

    stockManageTable = new Ext.FormPanel({
        frame: true,
        title: 'Stock Manage'.translator('stock-manage'),
        width: 1000,
        renderTo: 'StockManageTables',
        iconCls: 'icon-form',
        items: [tabs]
    });

	for (var i = 0; i < arrayCurrencyWithForex.length; i++) {
        var newRecord = new Array();
        newRecord['currency_id'] = arrayCurrencyWithForex[i].currency_id;
        newRecord['currency_name'] = arrayCurrencyWithForex[i].currency_name;
        newRecord['forex_rate'] = arrayCurrencyWithForex[i].forex_rate;
        newRecord['currency_code'] = arrayCurrencyWithForex[i].currency_code;
        storeCurrencyWithForexRate.add(new Ext.data.Record(newRecord));
    }

	for (var i = 0; i < arrayWarehouse.length; i++) {
        var newRecord = new Array();
        newRecord['warehouse_id'] = arrayWarehouse[i].warehouse_id;
        newRecord['warehouse_name'] = arrayWarehouse[i].warehouse_name;
        storeWarehouse.add(new Ext.data.Record(newRecord));
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
});