var tabs;
var Fund_object;
var gridFund;
var date_format_string = 'd/m/Y';
var date_sql_format_string = 'Y-m-d';
var page_size = 50;
var formFundTab;
var gridInvoice;

Ext.onReady(function(){

    /*
     * Ext.MessageBox.INFO
     Ext.MessageBox.WARNING
     Ext.MessageBox.QUESTION
     Ext.MessageBox.ERROR
     */
    if (convertedCurrencyId == 0) {
        Ext.Msg.show({
            title: 'Confirm the period current',
            buttons: Ext.MessageBox.YESNO,
            msg: 'Hệ thống chưa có kỳ kế toán hiện hành, bạn không thể sử dụng chức năng này. Bạn có muốn thiết lập kỳ hiện hành?',
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
    
    var fundManageTable = new Ext.FormPanel({
        id: 'fundManageTable',
        frame: true,
        title: 'Managed Funds'.translator('fund-manage'),
        width: 1000,
        renderTo: 'FundManageTables',
        iconCls: 'icon-form',
        items: [tabs]
    });
    
});
