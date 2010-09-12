Ext.apply(Ext.form.VTypes, {
    daterange: function(val, field){
        var date = field.parseDate(val);
        
        if (!date) {
            return;
        }
        if (field.startDateField &&
        (!this.dateRangeMax ||
        (date.getTime() !=
        this.dateRangeMax.getTime()))) {
            var start = Ext.getCmp(field.startDateField);
            start.setMaxValue(date);
            start.validate();
            this.dateRangeMax = date;
        }
        else 
            if (field.endDateField &&
            (!this.dateRangeMin ||
            (date.getTime() !=
            this.dateRangeMin.getTime()))) {
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
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    Ext.PagingToolbar.prototype.doRefresh = function(){
        if (this.getId() == 'bbar_Fund') {
            var sm = gridFund ? gridFund.getSelectionModel() : false;
            if (sm.hasSelection()) 
                sm.clearSelections();
            gridFund.getTopToolbar().items.get('btnDetail').disable();
            this.doLoad(this.cursor);
        }
    };
    
    var FundRecord = [{
        name: 'cash_voucher_id',
        type: 'string'
    }];
    
    Fund_object = Ext.data.Record.create(FundRecord);
    
    var Fund = {
        add: function(){
        },
        remove: function(){         
        },        
        find: function(){           
        }
    };
    
    // store fund
    storeFund = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'cash_voucher_id'
        }, Fund_object),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + "/getCashVoucher/1"
        }),
        autoLoad: false,
        sortInfo: {
            field: 'cash_voucher_id',
            direction: 'ASC'
        }
    });
        
    var tbarFund = new Ext.Toolbar({
        items: [{
            text: 'Delete'.translator('fund-manage'),
            id: 'delete_Fund',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Fund.remove
        }, '-', {
            xtype: 'label',
            text: 'Cash Voucher Number'.translator('fund-manage'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'textfield',
            id: 'srch_prepaid_Fund_code',
            width: 100
        }, '-', {
            xtype: 'label',
            text: 'From Date'.translator('fund-manage'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'datefield',
            width: 99,
            labelSeparator: '',
            id: 'srch_from_date',
            format: date_format_string,
            // readOnly: true,
            vtype: 'daterange',
            endDateField: 'srch_to_date'
        }, '-', {
            xtype: 'label',
            text: 'To Date'.translator('fund-manage'),
            style: 'padding-left: 5px;padding-right: 5px;'
        }, {
            xtype: 'datefield',
            width: 99,
            labelSeparator: '',
            id: 'srch_to_date',
            format: date_format_string,
            // readOnly: true,
            vtype: 'daterange',
            startDateField: 'srch_from_date'
        }, '-', {
            xtype: 'label',
            text: 'Type Vote'.translator('stock-manage'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
            id: 'srch_type_vote',
            store: new Ext.data.SimpleStore({
                data: [[1, 'Debit'.translator('fund-manage')], [2, 'Credit'.translator('fund-manage')], [3, 'Transfer'.translator('fund-manage')], [null, 'All'.translator('stock-manage')]],
                id: 0,
                fields: ['type_vote_id', 'type_vote_name']
            }),
            valueField: 'type_vote_id',
            displayField: 'type_vote_name',
            forceSelection: true,
            typeAhead: true,
            mode: 'local',
            triggerAction: 'all',
            emptyText: 'Select a type vote'.translator('stock-manage'),
            selectOnFocus: true,
            editable: true,
            width: 150,
            lazyRender: true,
            selectOnFocus: true,
            listeners: {
                select: function(combo, record, index){
                    Fund.find();
                }
            }
        }), {
            text: 'Find'.translator('fund-manage'),
            id: 'find_invoice',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            style: 'padding-left: 5px;',
            handler: Fund.find
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
        bbarFund.pageSize = parseInt(record.get('id'), 10);
        bbarFund.doLoad(bbarFund.cursor);
    }, this);
    
    var bbarFund = new Ext.PagingToolbar({
        store: storeFund, // the store you use in your grid
        displayInfo: true,
        pageSize: page_size,
        id: 'bbar_Fund',
        items: ['-', 'Per Page', cmbPerPage]
    });
    
    var cmFund = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Cash Voucher Number'.translator('fund-manage'),
            dataIndex: 'cash_voucher_number'
        }, {
            header: 'Cash Voucher Date'.translator('fund-manage'),
            dataIndex: 'cash_voucher_date'
        }, {
            header: 'in out'.translator('fund-manage'),
            dataIndex: 'in_out'
        }, {
            header: 'Amount'.translator('fund-manage'),
            dataIndex: 'amount'
        }, {
            header: 'Currency'.translator('fund-manage'),
            dataIndex: 'currency_id'
        }, {
            header: 'Forexchange rate'.translator('fund-manage'),
            dataIndex: 'forex_rate'
        }, {
            header: 'Thành tiền qui đổi',
            dataIndex: 'converted_amount'
        }]
    });
    gridFund = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeFund,
        cm: cmFund,
        stripeRows: true,
        height: 530,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        listeners: {
            rowclick: function(){
                loadCashVoucherInfor();
                gridFund.getTopToolbar().items.get('btnDetail').enable();
            }
        },
        tbar: tbarFund,
        bbar: [bbarFund],
        id: 'gridFund'
    });
    
    storeFund.on('beforeload', function(){
        var cashVoucherNumber = gridFund.getTopToolbar().items.get('srch_prepaid_Fund_code').getValue();
        var dateFromSearch = gridFund.getTopToolbar().items.get('srch_from_date').getValue();
        dateFromSearch = (dateFromSearch != null && dateFromSearch != '') ? dateFromSearch.dateFormat('Y-m-d') : '';
        
        var dateToSearch = gridFund.getTopToolbar().items.get('srch_to_date').getValue();
        dateToSearch = (dateToSearch != null && dateToSearch != '') ? dateToSearch.dateFormat('Y-m-d') : '';
        
        storeFund.baseParams.typeVote = Ext.getCmp('srch_type_vote').getValue();
        storeFund.baseParams.cashVoucherNumber = cashVoucherNumber;
        storeFund.baseParams.dateFromSearch = dateFromSearch;
        storeFund.baseParams.dateToSearch = dateToSearch;
        storeFund.baseParams.start = 0;
        storeFund.baseParams.limit = page_size;
    });
    storeFund.load();
	
});
