var tabs;
var gridInvoice;
var gridDetailEntry;
var gridEntryDebit;
var gridProduct;
var productPanel;
var tabsAccounting1;
var tabsAccounting2;
var gridImportGood;
var gridDomestic;
var storeDetailEntry;
var comboDomestic;
var comboEntryDebit;
var comboVatGood;
var page_size = 50;
var startLoadProduct = false;
var page_size_product = 100;

var IMPORT_RATE = 4;
var EXCISE_RATE = 2;
var VAT_RATE = 1;

var ENTRY_TYPE_PURCHASE_IMPORT = 1;
var ENTRY_TYPE_VAT_GOOD = 2;
var ENTRY_TYPE_DOMESTIC = 3;

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
    
    var buyBillingTable = new Ext.FormPanel({
        frame: true,
        title: 'Purchase Invoice'.translator('buy-billing'),
        width: 1000,
        renderTo: 'BuyBillingTables',
        iconCls: 'icon-form',
        items: [tabs]
    });
});
