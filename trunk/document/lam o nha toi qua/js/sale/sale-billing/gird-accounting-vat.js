var gridVat;
var storeVat;

function render_number1(val){
    try {
        if (val == null || val == '')
            return '';
        return number_format_extra(val, decimals, decimalSeparator, thousandSeparator);
    }
    catch (e) {
    }
};

function render_account_code(val){
    try {
        if (val == null || val == '')
            return '';
        return storeAccountList.queryBy(function(rec){
            return rec.data.account_id == val;
        }).itemAt(0).data.account_code;
    }
    catch (e) {
    }
};

function render_account_name(val){
    try {
        if (val == null || val == '')
            return '';
        return storeAccountList.queryBy(function(rec){
            return rec.data.account_id == val;
        }).itemAt(0).data.account_name;
    }
    catch (e) {
    }
};

Ext.onReady(function(){
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    var rec1 = [{
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

    var obj_rec1 = Ext.data.Record.create(rec1);

    storeVat = new Ext.data.GroupingStore({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'detail_id'
        }, obj_rec1),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getAccountingOfSale/1'
        }),
        autoLoad: false,
        groupField: 'product_name',
        sortInfo: {
            field: 'product_name',
            direction: 'ASC'
        }
    });

    storeVat.on('load', function(){
		var totalDebit = 0;
        var totalCredit = 0;
        for (var i = 0; i < storeVat.getCount(); i++) {
            var record = storeVat.getAt(i);
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
		Ext.getCmp('lblDebit_vat').setText(number_format_extra(totalDebit, decimals, decimalSeparator, thousandSeparator));
		Ext.getCmp('lblCredit_vat').setText(number_format_extra(totalCredit, decimals, decimalSeparator, thousandSeparator));
		storeVat.sort('original_amount', 'ASC');
    });

    var tbar1 = new Ext.Toolbar({
        items: [{
            text: 'Total Debt'.translator('buy-billing'),
            id: 'txtDebit_vat'
        }, {
            xtype: 'label',
            id: 'lblDebit_vat'
        }, '-', {
            text: 'Total Credit'.translator('buy-billing'),
            id: 'txtCredit_vat'
        }, {
            xtype: 'label',
            id: 'lblCredit_vat'
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_vat',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                gridVat.getStore().removeAll();
                gridVat.getStore().reload();
            }
        }]
    });

    var cm1 = new Ext.grid.ColumnModel({
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
    gridVat = new Ext.grid.GridPanel({
        title: '',
        store: storeVat,
        cm: cm1,
        tbar: tbar1,
        stripeRows: true,
        height: 557,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        id: 'gridVat',
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

    gridVat.getView().getRowClass = function(record, index){
        if (record.data.master_type == 1)
            return 'blue-row';
        return 'green-row';
    };
});
