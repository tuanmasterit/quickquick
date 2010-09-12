/*checkbox column*/
Ext.grid.CheckColumn = function(config){
    Ext.apply(this, config);
    if (!this.id) {
        this.id = Ext.id();
    }
    this.renderer = this.renderer.createDelegate(this);
};

Ext.grid.CheckColumn.prototype = {
    init: function(grid){
        this.grid = grid;
        this.grid.on('render', function(){
            var view = this.grid.getView();
            view.mainBody.on('mousedown', this.onMouseDown, this);
        }, this);
    },
    
    onMouseDown: function(e, t){
        if (t.className &&
        t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            
            record.set(this.dataIndex, !record.data[this.dataIndex]);
        }
    },
    
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="approved-column x-grid3-check-col' +
        (v ? '-on' : '') +
        ' x-grid3-cc-' +
        this.id +
        '">&#160;</div>';
    }
};
/*end of checkbox column*/

Ext.apply(Ext.form.VTypes, {
    daterange: function(val, field){
        var date = field.parseDate(val);
        
        if (!date) {
            return;
        }
        if (field.startDateField && (!this.dateRangeMax || (date.getTime() != this.dateRangeMax.getTime()))) {
            var start = Ext.getCmp(field.startDateField);
            start.setMaxValue(date);
            start.validate();
            this.dateRangeMax = date;
        }
        else 
            if (field.endDateField && (!this.dateRangeMin || (date.getTime() != this.dateRangeMin.getTime()))) {
                var end = Ext.getCmp(field.endDateField);
                end.setMinValue(date);
                end.validate();
                this.dateRangeMin = date;
            }
        /*
         * Always return true since we're only using this vtype to set the
         * min/max allowed values (these are tested for after the vtype test)
         */
        return true;
    }
});

Ext.onReady(function(){
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
	storeAccountList = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'account_id',
            fields: ['account_id', 'account_name', 'account_code']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListAccount/1'
        }),
        autoLoad: true
    });
	
    //
    var storeByImportType = new Ext.data.ArrayStore({
        fields: [{
            name: 'by_export'
        }, {
            name: 'name'
        }, ],
        data: [[0, 'trong nước'], [1, 'xuất khẩu']]
    });
    
    var storeForServiceType = new Ext.data.ArrayStore({
        fields: [{
            name: 'for_service'
        }, {
            name: 'name'
        }, ],
        data: [[0, 'hàng hóa'], [1, 'dịch vụ']]
    });
    
    function render_by_export_type(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeByImportType.queryBy(function(rec){
                return rec.data.by_export == val;
            }).itemAt(0).data.name;
        } 
        catch (e) {
        }
    };
    
    function render_for_service_type(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeForServiceType.queryBy(function(rec){
                return rec.data.for_service == val;
            }).itemAt(0).data.name;
        } 
        catch (e) {
        }
    };
    
    var InvoiceRecord = [{
        name: 'sales_invoice_id',
        type: 'string'
    }, {
        name: 'voucher_id',
        type: 'string'
    }, {
        name: 'sales_serial_number',
        type: 'string'
    }, {
        name: 'sales_invoice_number',
        type: 'string'
    }, {
        name: 'sales_invoice_date',
        type: 'date'
    }, {
        name: 'customer_id',
        type: 'string'
    }, {
        name: 'customer_name',
        type: 'string'
    }, {
        name: 'customer_tax_code',
        type: 'string'
    }, {
        name: 'customer_address',
        type: 'string'
    }, {
        name: 'customer_contact',
        type: 'string'
    }, {
        name: 'payment_type',
        type: 'string'
    }, {
        name: 'currency_id',
        type: 'string'
    }, {
        name: 'currency_name',
        type: 'string'
    }, {
        name: 'forex_rate',
        type: 'string'
    }, {
        name: 'by_export',
        type: 'string'
    }, {
        name: 'for_service',
        type: 'string'
    }, {
        name: 'total_sale_amount',
        type: 'string'
    }, {
        name: 'description',
        type: 'string'
    }, {
        name: 'arr_batch',
        type: 'array'
    }, {
        name: 'period_id',
        type: 'string'
    }, {
        name: 'subject_id',
        type: 'string'
    }, {
        name: 'subject_contact',
        type: 'string'
    }, {
        name: 'department_id',
        type: 'string'
    }, {
        name: 'is_locked',
        type: 'string'
    }, {
        name: 'is_inheritanced',
        type: 'string'
    }, {
        name: 'locked',
        type: 'string'
    }, {
        name: 'real_batch_id',
        type: 'string'
    }];
    
    invoice_object = Ext.data.Record.create(InvoiceRecord);
    //
    var Invoice = {
    
        remove: function(){
            var records = gridInvoice.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm'.translator('stock-manage'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Ask delete invoice'.translator('sale-billing'),
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecord = new Array();
                            for (var i = 0; i < records.length; i++) {
                                var isLocked = (records[i].data.is_locked == 1) ? true : false;
                                if (!isEmpty(records[i].data.sales_invoice_id) && !isLocked) {
                                    arrRecord.push({
                                        sales_invoice_id: records[i].data.sales_invoice_id,
                                        batch_id: records[i].data.real_batch_id,
                                        is_inheritanced: records[i].data.is_inheritanced
                                    });
                                    gridInvoice.getStore().remove(records[i]);
                                }
                            }
                            gridInvoice.getView().refresh(true);
                            baseDeleteSaleInvoice(arrRecord);
                        }
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Not row to delete'.translator('buy-billing'));
            }
        },
        find: function(){
            gridInvoice.getStore().load();
        },
        exportSale: function(){
            // chi xuat mot hoa don
            var records = gridInvoice.getSelectionModel().getSelections();
            var checkDuplicate = false;
            if (records.length > 1) {
                // kiem tra truong hop phai trung ky hieu hoa don, so hoa don, ngay hoa don, ma so thue
                for (var i = 1; i < records.length; i++) {
                    if ((records[i].data.sales_serial_number != records[0].data.sales_serial_number) ||
                    (records[i].data.sales_invoice_number != records[0].data.sales_invoice_number) ||
                    (records[i].data.sales_invoice_date.dateFormat(date_format_string) != records[0].data.sales_invoice_date.dateFormat(date_format_string)) ||
                    (records[i].data.customer_tax_code != records[0].data.customer_tax_code)) {
                        checkDuplicate = true;
                    }
                }
            }
            
            if (!checkDuplicate) {
                var params = '';
                for (var i = 0; i < records.length; i++) {
                    if (params == '') {
                        params += records[i].data.sales_invoice_id;
                    }
                    else {
                        params += '_' + records[i].data.sales_invoice_id;
                    }
                }
                
                window.open(Quick.baseUrl + '/accountant/sale/sale-billing/export/' + params + '/type/' + Ext.getCmp('export_sale_type').getValue().inputValue, null, "height=200,width=400,status=yes,toolbar=no,menubar=no,location=no");
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Please check invoice again'.translator('sale-billing'));
                return;
            }
        }
    };
    
    var storeInvoice = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'sales_invoice_id'
        }, invoice_object),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSalesInvoice/1'
        }),
        autoLoad: false
    });
    
    
    var tbarInvoice = new Ext.Toolbar({
        items: [{
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Invoice.remove
        }, '-', {
            xtype: 'label',
            text: 'Invoice Number'.translator('buy-billing'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'textfield',
            id: 'srch_invoice_number',
            width: 100,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        Invoice.find();
                    }
                }
            }
        }, '-', {
            xtype: 'label',
            text: 'From Date'.translator('buy-billing'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'datefield',
            width: 99,
            labelSeparator: '',
            id: 'srch_from_date',
            format: date_format_string,
            //readOnly: true,
            vtype: 'daterange',
            endDateField: 'srch_to_date'
        }, '-', {
            xtype: 'label',
            text: 'To Date'.translator('buy-billing'),
            style: 'padding-left: 5px;padding-right: 5px;'
        }, {
            xtype: 'datefield',
            width: 99,
            labelSeparator: '',
            id: 'srch_to_date',
            format: date_format_string,
            //readOnly: true,
            vtype: 'daterange',
            startDateField: 'srch_from_date'
        }, '-', {
            text: 'Find'.translator('buy-billing'),
            id: 'find_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            style: 'padding-left: 5px;',
            handler: Invoice.find
        }, '->', {
            xtype: 'radiogroup',
            //fieldLabel: 'Type Vote'.translator('stock-manage'),
            id: 'export_sale_type',
            value: 1,
            items: [{
                boxLabel: 'Sales Invoice'.translator('sale-billing'),
                name: 'rb-export',
                width: 210,
                inputValue: 1
            }, {
                boxLabel: 'Detail List'.translator('sale-billing'),
                name: 'rb-export',
                inputValue: 2
            }]
        }, {
            text: 'Export Invoice'.translator('sale-billing'),
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/export.jpg',
            handler: Invoice.exportSale
        }]
    });
    
    var cmbPerPage = new Ext.form.ComboBox({
        name: 'perpage',
        width: 80,
        store: new Ext.data.SimpleStore({
            data: [[50, '50'], [100, '100'], [150, '150'], [200, '200'], [250, '250'], [300, '300'], [500, '500'], [1000, '1000']],
            id: 0,
            fields: ['id', 'value']
        }),
        mode: 'local',
        value: '50',
        listWidth: 80,
        triggerAction: 'all',
        displayField: 'value',
        valueField: 'value',
        editable: false,
        forceSelection: true
    });
    
    cmbPerPage.on('select', function(combo, record){
        bbarInvoice.pageSize = parseInt(record.get('id'), 10);
        bbarInvoice.doLoad(bbarInvoice.cursor);
    }, this);
    
    var bbarInvoice = new Ext.PagingToolbar({
        store: storeInvoice, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size,
        items: ['-', 'Per Page'.translator('buy-billing'), cmbPerPage]
    });
    
    function setCharAt(str, index, chr){
        if (index > str.length - 1) 
            return str;
        return str.substr(0, index) + chr + str.substr(index + 1);
    };
    
    var sm = new Ext.grid.CheckboxSelectionModel();
    
    var cmInvoice = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), sm, {
            header: 'Invoice Seri Number'.translator('buy-billing'),
            dataIndex: 'sales_serial_number',
            id: 'sales_serial_number',
            width: 110
        }, {
            header: 'Invoice Number'.translator('buy-billing'),
            dataIndex: 'sales_invoice_number',
            id: 'sales_invoice_number',
            width: 100
        }, {
            header: 'Invoice Date'.translator('buy-billing'),
            dataIndex: 'sales_invoice_date',
            id: 'sales_invoice_date',
            width: 77,
            renderer: formatDate
        }, {
            header: 'Customer'.translator('buy-billing'),
            dataIndex: 'customer_name',
            id: 'customer_name',
            width: 150
        }, {
            header: 'Customer Tax code'.translator('buy-billing'),
            dataIndex: 'customer_tax_code',
            id: 'customer_tax_code',
            width: 100
        }, {
            header: 'Customer Contact'.translator('buy-billing'),
            dataIndex: 'customer_contact',
            id: 'customer_contact',
            width: 140
        }, {
            header: 'Invoice Export'.translator('buy-billing'),
            dataIndex: 'by_export',
            id: 'by_export',
            width: 80,
            align: 'center',
            renderer: render_by_export_type
        }, {
            header: 'Invoice Service'.translator('buy-billing'),
            dataIndex: 'for_service',
            id: 'for_service',
            width: 80,
            align: 'center',
            renderer: render_for_service_type
        }, {
            header: 'Total Amount'.translator('buy-billing'),
            dataIndex: 'total_sale_amount',
            width: 100,
            align: 'right',
            renderer: render_number
        }, new Ext.grid.CheckColumn({
            header: 'Inheritanced'.translator('sale-billing'),
            dataIndex: 'is_inheritanced',
            id: 'is_inheritanced',
            width: 60
        }), new Ext.grid.CheckColumn({
            header: 'Locked'.translator('sale-billing'),
            dataIndex: 'locked',
            id: 'locked',
            width: 60
        })]
    });
    
    // create the Grid
    gridInvoice = new Ext.grid.GridPanel({
        title: '',
        store: storeInvoice,
        cm: cmInvoice,
        sm: sm,
        stripeRows: true,
        height: 557,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'
        },
        tbar: tbarInvoice,
        bbar: bbarInvoice,
        //stateful: true,
        //stateId: 'gridInvoice',
        id: 'gridInvoice'
    });
    
    gridInvoice.on('rowdblclick', function(grid, rowIndex, e){
        var record = grid.store.getAt(rowIndex);
        if (record) {
        
            // set value on form // form sales
            var chkByExport = (record.data.by_export == 1) ? true : false;
            var chkForService = (record.data.for_service == 1) ? true : false;
            Ext.getCmp('invoiceInfo').setTitle("General Information".translator('buy-billing') +
            " - " +
            record.data.sales_serial_number);
            Ext.getCmp('sales_invoice_id').setValue(record.data.sales_invoice_id);
            Ext.getCmp('sales_invoice_number').setValue(record.data.sales_invoice_number);
            Ext.getCmp('sales_serial_number').setValue(record.data.sales_serial_number);
            Ext.getCmp('sales_invoice_date').setValue(record.data.sales_invoice_date);
            Ext.getCmp('customer_code').setValue(record.data.customer_id);
            Ext.getCmp('customer_id').setValue(record.data.customer_id);
            Ext.getCmp('customer_name').setValue(record.data.customer_name);
            Ext.getCmp('customer_address').setValue(record.data.customer_address);
            Ext.getCmp('customer_tax_code').setValue(record.data.customer_tax_code);
            Ext.getCmp('customer_contact').setValue(record.data.customer_contact);
            Ext.getCmp('payment_type').setValue(record.data.payment_type);
            Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
            Ext.getCmp('currency_code').setValue(record.data.currency_id);
            Ext.getCmp('currency_id').setValue(record.data.currency_id);
            Ext.getCmp('by_export').setValue(chkByExport);
            Ext.getCmp('for_service').setValue(chkForService);
            
            Ext.getCmp('is_inheritanced').setValue(record.data.is_inheritanced);
            Ext.getCmp('is_locked').setValue(record.data.is_locked);
            Ext.getCmp('by_export').disable();
            Ext.getCmp('for_service').disable();
            Ext.getCmp('description').setValue(record.data.description);
            
            Ext.getCmp('reload_detail').enable();
            selectedSaleInvoiceIndex = gridInvoice.getStore().indexOf(record);
            
            display_detail_by_export(chkByExport, chkForService);
            
            gridDetail.getStore().removeAll();
            gridDetail.getStore().baseParams.salesInvoiceId = record.data.sales_invoice_id;
            gridDetail.getStore().baseParams.forexrate = record.data.forex_rate;
            gridDetail.getStore().baseParams.currency_id = record.data.currency_id;
            gridDetail.getStore().baseParams.voucherId = record.data.voucher_id;
            gridDetail.getStore().baseParams.batchId = record.data.real_batch_id;
            
            gridDetail.getStore().load();
            // end form sales
            
            status = 'update';
            Ext.getCmp('btn_nheritance').disable();
            Ext.getCmp('btn_save').disable();
            Ext.getCmp('btn_delete').enable();
            
            // dung cho hach toan
            //getArrayEntryTypeOfSale(record.data.real_batch_id, record.data.by_export, record.data.for_service);
        }
        else 
            warning('Warning'.translator('buy-billing'), 'Not in current period'.translator('sale-billing'));
    });
    
    gridInvoice.on('keydown', function(e){
        if (e.keyCode == 46) {
            Invoice.remove();
        }
    }, this);
    
    storeInvoice.on('beforeload', function(){
        var srchNumber = gridInvoice.topToolbar.items.get('srch_invoice_number').getValue();
        
        var srchFromDate = gridInvoice.topToolbar.items.get('srch_from_date').getValue();
        if (srchFromDate != null && srchFromDate != '') 
            srchFromDate = srchFromDate.dateFormat('Y-m-d 00:00:00');
        else 
            srchFromDate = '';
        
        var srchToDate = gridInvoice.topToolbar.items.get('srch_to_date').getValue();
        if (srchToDate != null && srchToDate != '') 
            srchToDate = srchToDate.dateFormat('Y-m-d 00:00:00');
        else 
            srchToDate = '';
        
        storeInvoice.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
        storeInvoice.baseParams.fromDate = srchFromDate;
        storeInvoice.baseParams.toDate = srchToDate;
        storeInvoice.baseParams.customer = 0;
        storeInvoice.baseParams.start = 0;
        storeInvoice.baseParams.limit = page_size;
        
    });
});

var getArrayEntryTypeOfSale = function(batchId, chkByExport, chkForService){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getArrayEntryTypeOfSale/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
            
                if (chkByExport == 1) {
                    title = 'Accounting Export'.translator('sale-billing');
                }
                else {
                    title = 'Accounting Excise'.translator('sale-billing');
                }
                tabsAccounting.getItem('gridExport').setTitle(title);
                baseLoadAccounting(storeAmount, batchId, result.data[0]['typeId'], chkForService);
                baseLoadAccounting(storeVat, batchId, result.data[1]['typeId'], chkForService);
                baseLoadAccounting(storeExport, batchId, result.data[2]['typeId'], chkForService);
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            chkByExport: chkByExport,
            chkForService: chkForService
        }
    });
};

var baseLoadAccounting = function(store, batchId, entryTypeId, chkForService){
    store.baseParams = {
        'batchId': batchId,
        'entryTypeId': entryTypeId,
        'forService': chkForService
    };
    store.load();
};

var baseDeleteSaleInvoice = function(arrRecord){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteSaleInvoice/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                msg('Info'.translator('buy-billing'), 'Delete success'.translator('sale-billing'), Ext.MessageBox.INFO);
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        },
        params: {
            arrRecord: Ext.encode(arrRecord)
        }
    });
};
