var pathRequestUrl;
var tabs;
var gridInventory;
var storeDetail;
var gridDetail;
var storeWarehouse;
var storeCurrencyWithForexRate;
var gridAccounting;
var comboAccounting;
var generalTab;

var DEFAULT_INPUT_ENTRY_TYPE = 19;
var DEFAULT_OUTPUT_ENTRY_TYPE = 20;
var DEFAULT_INTERNAL_ENTRY_TYPE = 21;

var DEFAULT_INPUT_VOTE_TYPE = 1;
var DEFAULT_OUTPUT_VOTE_TYPE = 2;
var DEFAULT_INTERNAL_VOTE_TYPE = 3;

var date_format_string = 'd/m/Y';
var date_sql_format_string = 'Y-m-d';
var page_size = 50;
var page_size_product = 100;
var startLoadProduct = false;
var selectedInventoryId;
var selectedInventoryIndex;
var forexRate = 0.00;
var currencyType = 0;
var isStart = false;

function forceNumber(event){
    var keyCode = event.keyCode ? event.keyCode : event.charCode;
    if ((keyCode < 48 || keyCode > 58) &&
    keyCode != 8 &&
    keyCode != 9 &&
    keyCode != 32 &&
    keyCode != 37 &&
    keyCode != 39 &&
    keyCode != 40 &&
    keyCode != 41 &&
    keyCode != 43 &&
    keyCode != 44 &&
    keyCode != 45 &&
    keyCode != 46) 
        return false;
    return true;
}

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
    
    var stockManageTable = new Ext.FormPanel({
        frame: true,
        title: 'Stock Manage'.translator('stock-manage'),
        width: 1000,
        renderTo: 'StockManageTables',
        iconCls: 'icon-form',
        items: [tabs]
    });
});

var msg = function(title, msg, icon){
    Ext.Msg.show({
        title: title,
        msg: msg,
        minWidth: 200,
        modal: true,
        icon: (icon != null) ? icon : Ext.Msg.INFO,
        buttons: Ext.Msg.OK
    });
};
var warning = function(title, message, icon){
    msg(title, message, Ext.MessageBox.WARNING)
};