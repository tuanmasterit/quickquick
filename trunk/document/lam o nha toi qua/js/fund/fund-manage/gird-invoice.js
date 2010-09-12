var objInvoice;

Ext.onReady(function(){
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    var invoiceRecord = [{
        name: 'cash_voucher_id',
        type: 'string'
    }];
    objInvoice = Ext.data.Record.create(invoiceRecord);
    
    var Invoice = {
        add: function(){
        },
        remove: function(){
        
        },
        find: function(){
        }
    };
    
    // store invoice
    var storeInvoice = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: ''
        }, objInvoice),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + "/getInvoice/1"
        }),
        autoLoad: false
    });
    
    var resultTplSubjectCode = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{subject_code} | {subject_name}</span><br />', '</div></tpl>');
    
    function render_number(val){
        try {
            if (is_string(val) && (val.indexOf('/') == 0)) {
                var arrayValue = val.split('/');
                switch (arrayValue[1]) {
                    case 'Sum':
                        return '<b>' + arrayValue[1].translator('buy-billing') + '</b>';
                        break;
                    default:
                        return '<b>' + number_format_extra(parseFloat(arrayValue[1]), decimals, decimalSeparator, thousandSeparator) + '</b>';
                        break;
                }
            }
            if (val == null || val == '') 
                val = 0.00;
            return number_format_extra(cN(val), decimals, decimalSeparator, thousandSeparator);
        } 
        catch (e) {
        }
    };
    
    var cmFund = new Ext.grid.ColumnModel({
        defaults: {
            sortable: false
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Ngày hóa đơn',
        }, {
            header: 'Số seri',
        }, {
            header: 'Số hóa đơn',
        }, {
            header: 'Khách hàng',
        }, {
            header: 'Tên khách hàng',
        }, {
            header: 'Địa chỉ',
        }, {
            header: 'Mã số thuế',
        }, {
            header: 'Mặt hàng',
        }, {
            header: 'Diễn giải chứng từ',
        }, {
            header: 'Bộ phận',
        },{
            header: 'Chi phí',
        },{
            header: 'Tiền tệ',
        }, {
            header: 'Tỷ giá quy đổi',
        }, {
            header: 'Số lượng',
        }, {
            header: 'Đơn giá',
        }, {
            header: 'Nguyên tệ',
        }, {
            header: 'Thành tiền qui đổi',
        }, {
            header: 'Tk Nợ',
        }, {
            header: 'Diễn giải bút toán',
        }, {
            header: 'VAT (%)',
        },  {
            header: 'Tiền thuế',
        }, {
            header: 'Tk Nợ',
        }, {
            header: 'Diễn giải bút toán',
        }]
    });
    
    gridInvoice = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeInvoice,
        cm: cmFund,
        stripeRows: true,
        height: 189,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        listeners: {
            beforeedit: function(e){
            },
            afteredit: function(e){
            },
            rowclick: function(){
            
            }
        },
        tbar: [{
            text: 'Add'.translator('fund-manage'),
            id: 'add_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Invoice.add
        }, {
            text: 'Delete'.translator('fund-manage'),
            id: 'delete_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Invoice.remove
        }, '->', {
            text: 'Reload'.translator('fund-manage'),
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
            
            }
        }],
        id: 'gridInvoice'
    });
    
    gridInvoice.getView().getRowClass = function(record, index){
        if (record.data.isTotal) 
            return 'format-row-total';
    };
    
});
