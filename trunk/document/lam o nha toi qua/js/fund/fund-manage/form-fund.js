Ext.onReady(function(){
    Ext.QuickTips.init();
    
    var resultTplSubjectCode = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{subject_code} | {subject_name}</span><br />', '</div></tpl>');
    
    var resultTplCurrency = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{currency_code} | {currency_name}</span><br />', '</div></tpl>');
    
    var resultTplBank = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{subject_code} | {subject_name}</span><br />', '</div></tpl>');
    
    // form
    formFundTab = new Ext.Panel({
        frame: true,
        title: '',
        id: 'formFundTab',
        items: [{
            layout: 'column',
            style: 'padding-left:5px',
            items: [{
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [{
                    xtype: 'radiogroup',
                    fieldLabel: 'in out'.translator('fund-manage'),
                    id: 'radioInOut',
                    width: 300,
                    items: [{
                        boxLabel: 'Debit'.translator('fund-manage'),
                        name: 'rb-auto',
                        inputValue: 1
                    }, {
                        boxLabel: 'Credit'.translator('fund-manage'),
                        name: 'rb-auto',
                        inputValue: 2
                    }, {
                        boxLabel: 'Transfer'.translator('fund-manage'),
                        name: 'rb-auto',
                        inputValue: 3
                    }],
                    listeners: {
                        change: function(e){
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'cboVoucherType',
                    typeAhead: true,
                    store: null,
                    valueField: 'voucher_type_id',
                    displayField: 'voucher_type_name',
                    mode: 'local',
                    forceSelection: true,
                    triggerAction: 'all',
                    fieldLabel: 'Voucher Type'.translator('fund-manage'),
                    editable: false,
                    width: 250,
                    minListWidth: 100,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                        
                        },
                        change: function(e){
                        
                        }
                    }
                }), {
                    xtype: 'textfield',
                    fieldLabel: 'Cash Voucher Number'.translator('fund-manage'),
                    width: 150,
                    id: 'txtCashVoucherNumber',
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                        
                        }
                    }
                }, {
                    xtype: 'datefield',
                    width: 100,
                    labelSeparator: '',
                    fieldLabel: 'Ngày chứng từ',
                    format: date_format_string,
                    id: 'dateCashVoucher',
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                        
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'cboDivisionCode',
                    store: null,
                    fieldLabel: 'Division Code'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'subject_code',
                    valueField: 'subject_id',
                    typeAhead: true,
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    lazyRender: true,
                    selectOnFocus: true,
                    tpl: resultTplSubjectCode,
                    itemSelector: 'div.search-item',
                    pageSize: 50,
                    minChars: 1,
                    listWidth: 400,
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'cboDivision',
                    store: null,
                    fieldLabel: 'Division'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: true,
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: true,
                    width: 250,
                    lazyRender: true,
                    selectOnFocus: true,
                    tpl: resultTplSubjectCode,
                    itemSelector: 'div.search-item',
                    pageSize: 50,
                    listWidth: 400,
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                }), {
                    xtype: 'textfield',
                    fieldLabel: 'Division name'.translator('fund-manage'),
                    width: 300,
                    allowBlank: true,
                    id: 'txtDivisionName',
                    listeners: {
                        change: function(e){
                        
                        }
                    }
                }, {
                    xtype: 'textfield',
                    fieldLabel: 'Address'.translator('fund-manage'),
                    width: 300,
                    allowBlank: true,
                    id: 'txtAddress',
                    listeners: {
                        change: function(e){
                        
                        }
                    }
                }, {
                    xtype: 'textfield',
                    fieldLabel: 'Contact'.translator('fund-manage'),
                    width: 300,
                    allowBlank: true,
                    id: 'txtContact',
                    listeners: {
                        change: function(e){
                        
                        }
                    }
                }, new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Staff'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'staff_name',
                    valueField: 'staff_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: false,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    id: 'cboStaff',
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                }), new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Department'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'department_name',
                    valueField: 'department_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: false,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    id: 'cboDepartment',
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                })]
            }, {
                columnWidth: .5,
                layout: 'form',
                labelWidth: 165,
                style: 'padding-left:10px',
                items: [new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Debit Bank'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: true,
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: true,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    tpl: resultTplBank,
                    itemSelector: 'div.search-item',
                    pageSize: 50,
                    minChars: 1,
                    id: 'cboDebitBank',
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                }), new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Account Debit Bank'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'bank_account_number',
                    valueField: 'bank_account_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: false,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    id: 'cboAccountDebitBank'
                }), new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Credit Bank'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: true,
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: false,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    tpl: resultTplBank,
                    itemSelector: 'div.search-item',
                    pageSize: 50,
                    minChars: 1,
                    id: 'cboCreditBank',
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                }), new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Account Credit Bank'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'bank_account_number',
                    valueField: 'bank_account_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: false,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    id: 'cboAccountCreditBank'
                }), new Ext.form.ComboBox({
                    store: null,
                    fieldLabel: 'Expense'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'expense_name',
                    valueField: 'expense_id',
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: false,
                    width: 200,
                    lazyRender: true,
                    selectOnFocus: true,
                    id: 'cboExpense',
                    listeners: {
                        select: function(combo, record, index){
                        
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'cboCurrencyId',
                    store: null,
                    fieldLabel: 'Currency'.translator('fund-manage'),
                    forceSelection: true,
                    displayField: 'currency_name',
                    valueField: 'currency_id',
                    typeAhead: true,
                    triggerAction: 'all',
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    lazyRender: true,
                    selectOnFocus: true,
                    tpl: resultTplCurrency,
                    itemSelector: 'div.search-item',
                    pageSize: 50,
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                        },
                        change: function(e){
                        
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'txtForexRate',
                    fieldLabel: 'Forexchange rate'.translator('fund-manage'),
                    width: 150,
                    enableKeyEvents: true,
                    listeners: {
                        keypress: function(my, e){
                            if (!forceNumber(e)) 
                                e.stopEvent();
                        },
                        change: function(e){
                        }
                    }
                }, {
                    xtype: 'textarea',
                    fieldLabel: 'Debit Reason'.translator('fund-manage'),
                    width: 300,
                    height: 50,
                    allowBlank: true,
                    id: 'txtReason',
                    listeners: {
                        change: function(e){
                        
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'cboDebit',
                    typeAhead: true,
                    //labelStyle: 'text-align: right',
                    store: null,
                    valueField: 'account_id',
                    displayField: 'account_code',
                    mode: 'local',
                    forceSelection: true,
                    triggerAction: 'all',
                    fieldLabel: 'Tk Có',
					allowBlank: false,
                    editable: false,
                    width: 150,
                    minListWidth: 100,
                    tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:40px;">{account_code}</div><div style="float:left; text-align:left;">| </div><div>{account_name}</div></div></tpl>',
                    listWidth: 380,
                    lazyRender: true,
                    selectOnFocus: true
                })]
            }]
        }, gridInvoice]
    });
    
    var FormAction = {
        addNew: function(){
        },
        saveNew: function(){
        },
        deleteInvoice: function(){
        }
    };
    
    tabs = new Ext.TabPanel({
        id: 'tabs',
        width: 987,
        enableTabScroll: true,
        activeTab: 0,
        frame: true,
        defaults: {
            autoHeight: true
        },
        items: [{
            title: "General Information".translator('fund-manage'),
            id: 'invoiceInfo',
            items: [formFundTab],
            buttons: [{
                id: 'btn_new',
                text: 'New'.translator('fund-manage'),
                handler: FormAction.addNew
            }, {
                'id': 'btn_save',
                'text': 'Save'.translator('fund-manage'),
                handler: FormAction.saveNew
            }, {
                'id': 'btn_delete',
                'text': 'Delete'.translator('fund-manage'),
                handler: FormAction.deleteInvoice
            }]
        }, {
            title: "List Managed Funds".translator('fund-manage'),
            id: 'listFund',
            items: [gridFund]
        }]
    });
});
