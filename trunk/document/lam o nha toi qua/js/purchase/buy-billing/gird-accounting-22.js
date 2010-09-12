var store22;

var baseLoad22 = function(batchId, forService){
    store22.load({
        params: {
            batchId: Ext.encode(batchId),
            forService: forService
        }
    });    
};

Ext.onReady(function(){
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    var rec22 = [{
        name: 'debit_credit',
        type: 'string'
    }, {
        name: 'product_name',
        type: 'string'
    }, {
        name: 'master_type',
        type: 'boolean'
    }, {
        name: 'debit_account_id',
        type: 'string'
    }, {
        name: 'credit_account_id',
        type: 'string'
    }, {
        name: 'account_id',
        type: 'string'
    }, {
        name: 'original_amount',
        type: 'string'
    }, {
        name: 'currency_name',
        type: 'string'
    }, {
        name: 'forex_rate',
        type: 'string'
    }, {
        name: 'converted_amount',
        type: 'string'
    }];
    
    var obj_rec22 = Ext.data.Record.create(rec22);
    
    store22 = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: ['count'],
            id: 'detail_id'
        }, obj_rec22),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getAccountingOfPurchase/1'
        }),
        autoLoad: false,
        groupField: 'product_name',
        sortInfo: {
            field: 'product_name',
            direction: 'ASC'
        }
    });
    
    store22.on('load', function(){
        var totalDebit = 0;
        var totalCredit = 0;
        for (var i = 0; i < store22.getCount(); i++) {
            var record = store22.getAt(i);
            if (record.data.debit_credit == -1) 
                totalDebit += cN(record.data.original_amount);
            else 
                totalCredit += cN(record.data.original_amount);
            if (!isEmpty(record.data.debit_account_id)) {
                record.data.account_name = storeAccountList.queryBy(function(rec){
                    return rec.data.account_id == record.data.debit_account_id;
                }).itemAt(0).data.account_name;
            }
            else 
                if (!isEmpty(record.data.credit_account_id)) {
                    record.data.account_name = storeAccountList.queryBy(function(rec){
                        return rec.data.account_id == record.data.credit_account_id;
                    }).itemAt(0).data.account_name;
                }
        }
        
		Ext.getCmp('lblDebit_22').setText(number_format_extra(totalDebit, decimals, decimalSeparator, thousandSeparator));
		Ext.getCmp('lblCredit_22').setText(number_format_extra(totalCredit, decimals, decimalSeparator, thousandSeparator));
		store22.sort('original_amount', 'ASC');
    });
    
    var tbar22 = new Ext.Toolbar({
        items: [{
            text: 'Total Debt'.translator('buy-billing'),
            id: 'txtDebit_22'
        }, {
            xtype: 'label',
            text: '',
            id: 'lblDebit_22'
        }, '-', {
            text: 'Total Credit'.translator('buy-billing'),
            id: 'txtCredit_22'
        }, {
            xtype: 'label',
            text: '',
            id: 'lblCredit_22'
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_22',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                grid22.getStore().removeAll();
                grid22.getStore().reload();
            }
        }]
    });
    
    var cm22 = new Ext.grid.ColumnModel({
        defaults: {
            sortable: false
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Account Name'.translator('buy-billing'),
            dataIndex: 'account_id',
            width: 180,
            renderer: render_account_name
        }, {
            header: 'Debit'.translator('buy-billing'),
            dataIndex: 'debit_account_id',
            id: 'debit_account_id',
            width: 50,
            align: 'right',
            renderer: render_account_code
        }, {
            header: 'Credit'.translator('buy-billing'),
            dataIndex: 'credit_account_id',
            id: 'credit_account_id',
            width: 50,
            align: 'right',
            renderer: render_account_code
        }, {
            header: 'Original Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'original_amount',
            align: 'right',
            renderer: render_number
        }, {
            header: 'Currency Type'.translator('buy-billing'),
            width: 100,
            dataIndex: 'currency_name',
            align: 'right'
        }, {
            header: 'Forex Rate'.translator('buy-billing'),
            width: 100,
            dataIndex: 'forex_rate',
            align: 'right',
            renderer: render_number1
        }, {
            header: 'Converted Original Amount'.translator('buy-billing'),
            width: 150,
            dataIndex: 'converted_amount',
            align: 'right',
            renderer: render_number
        }, {
            header: 'Product'.translator('buy-billing'),
            width: 250,
            dataIndex: 'product_name',
            align: 'right',
            hidden: true
        }]
    });
    
    // create the Grid
    grid22 = new Ext.grid.GridPanel({
        title: '',
        store: store22,
        cm: cm22,
        tbar: tbar22,
        stripeRows: true,
        height: 504,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        id: 'grid22',
        viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'.translator('buy-billing')
        },
        view: new Ext.grid.GroupingView({
            forceFit: true,
            groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "' + 'Items'.translator('buy-billing') + '" : "' + 'Item'.translator('buy-billing') + '"]})'
        })
    });
    
    grid22.getView().getRowClass = function(record, index){
        if (record.data.master_type == 1) 
            return 'blue-row';
        return 'green-row';
    };
});
