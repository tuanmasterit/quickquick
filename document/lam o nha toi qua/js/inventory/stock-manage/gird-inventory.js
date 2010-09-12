var inventoryObject;
var selectedInventoryVoucherIndex;

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
    Ext.QuickTips.init();
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    var myDataTypeVote = [[1, 'Nhập'], [2, 'Xuất'], [3, 'Vận chuyển nội bộ']];

    var storeTypeVote = new Ext.data.ArrayStore({
        fields: [{
            name: 'type_vote_id'
        }, {
            name: 'type_vote_name'
        }]
    });

    storeTypeVote.loadData(myDataTypeVote);

    function render_type_vote_name(val){
        try {
            if (val == null || val == '')
                return '';
            return storeTypeVote.queryBy(function(rec){
                return rec.data.type_vote_id == val;
            }).itemAt(0).data.type_vote_name;
        }
        catch (e) {
        }
    }

    var inventoryRecord = [{
        name: 'inventory_voucher_id',
        type: 'string'
    }, {
        name: 'voucher_type_id',
        type: 'string'
    }, {
        name: 'inventory_voucher_number',
        type: 'string'
    }, {
        name: 'inventory_voucher_date_format',
        type: 'date'
    }, {
        name: 'in_out',
        type: 'string'
    }, {
        name: 'department_id',
        type: 'string'
    }, {
        name: 'department_name',
        type: 'string'
    }, {
        name: 'subject_id',
        type: 'string'
    }, {
        name: 'subject_name',
        type: 'string'
    }, {
        name: 'subject_contact',
        type: 'string'
    }, {
        name: 'in_warehouse_id',
        type: 'string'
    }, {
        name: 'out_warehouse_id',
        type: 'string'
    }, {
        name: 'currency_id',
        type: 'string'
    }, {
        name: 'forex_rate',
        type: 'string'
    }, {
        name: 'total_inventory_amount',
        type: 'string'
    }, {
        name: 'description',
        type: 'string'
    }, {
        name: 'period_id',
        type: 'string'
    }, {
        name: 'voucher_id',
        type: 'string'
    }, {
        name: 'batch_id',
        type: 'string'
    }, {
        name: 'is_locked',
        type: 'string'
    }, {
        name: 'to_accountant',
        type: 'string'
    }, {
        name: 'is_inheritanced',
        type: 'string'
    }, {
        name: 'locked',
        type: 'string'
    }];

    inventoryObject = Ext.data.Record.create(inventoryRecord);
	//
    var Inventory = {
        remove: function(){
            var records = gridInventory.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm'.translator('stock-manage'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Bạn muốn xóa phiếu hàng tồn kho?',
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecord = new Array();
                            for (var i = 0; i < records.length; i++) {
                                var isLocked = (records[i].data.is_locked == 1) ? true : false;
                                if (!isEmpty(records[i].data.inventory_voucher_id) && !isLocked) {
                                    arrRecord.push({
                                        inventory_voucher_id: records[i].data.inventory_voucher_id,
										batch_id: records[i].data.batch_id,
										is_inheritanced: records[i].data.is_inheritanced
                                    });
                                    gridInventory.getStore().remove(records[i]);
                                }
                            }
                            gridInventory.getView().refresh(true);
                            baseDeleteInventory(arrRecord);
                        }
                    }
                });
            }
            else {
                warning('Warning'.translator('stock-manage'), 'Not row to delete'.translator('stock-manage'));
            }
        },
        find: function(){
            gridInventory.getStore().load();
        }
    };

    var storeInventory = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'inventory_voucher_id'
        }, inventoryObject),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListInventoryVoucher/1'
        }),
        autoLoad: true
    });

    var tbarInventory = new Ext.Toolbar({
        items: [{
            text: 'Delete'.translator('stock-manage'),
            id: 'delete_Inventory',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Inventory.remove
        }, '-', {
            xtype: 'label',
            text: 'Inventory Voucher Number'.translator('stock-manage'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, {
            xtype: 'textfield',
            id: 'srch_inventory_number',
            width: 100,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                    }
                }
            }
        }, '-', {
            xtype: 'label',
            text: 'From Date'.translator('stock-manage'),
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
            text: 'To Date'.translator('stock-manage'),
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
            xtype: 'label',
            text: 'Type Vote'.translator('stock-manage'),
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
            id: 'srch_type_vote',
            store: new Ext.data.SimpleStore({
                data: [[1, 'Input'.translator('stock-manage')], [2, 'Output'.translator('stock-manage')], [3, 'Internal transport'.translator('stock-manage')], [0, 'All'.translator('stock-manage')]],
                id: 0,
                fields: ['type_vote_id', 'type_vote_name']
            }),
            forceSelection: true,
            displayField: 'type_vote_name',
            valueField: 'type_vote_id',
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
                    Inventory.find();
                }
            }
        }), {
            text: 'Find'.translator('stock-manage'),
            id: 'find_inventory',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            style: 'padding-left: 5px;',
            handler: Inventory.find
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
        bbarInventory.pageSize = parseInt(record.get('id'), 10);
        bbarInventory.doLoad(bbarInventory.cursor);
    }, this);

    var bbarInventory = new Ext.PagingToolbar({
        store: storeInventory, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size,
        items: ['-', 'Per Page'.translator('stock-manage'), cmbPerPage]
    });

    var cmInventory = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Inventory Voucher Number'.translator('stock-manage'),
            dataIndex: 'inventory_voucher_number',
            id: 'inventory_voucher_number',
            width: 90
        }, {
            header: 'Inventory Voucher Date'.translator('stock-manage'),
            dataIndex: 'inventory_voucher_date_format',
            id: 'inventory_voucher_date_format',
            width: 77,
            renderer: formatDate
        }, {
            header: 'Type Vote'.translator('stock-manage'),
            dataIndex: 'in_out',
            id: 'in_out',
            width: 77,
            renderer: render_type_vote_name
        }, {
            header: 'Input Warehouse'.translator('stock-manage'),
            dataIndex: 'in_warehouse_id',
            id: 'in_warehouse_id',
            width: 70,
            renderer: render_warehouse_name
        }, {
            header: 'Output Warehouse'.translator('stock-manage'),
            dataIndex: 'out_warehouse_id',
            id: 'out_warehouse_id',
            width: 70,
            renderer: render_warehouse_name
        }, {
            header: 'Subject Name'.translator('stock-manage'),
            dataIndex: 'subject_name',
            id: 'subject_name',
            width: 120
        }, {
            header: 'Contact Subject'.translator('stock-manage'),
            dataIndex: 'subject_contact',
            id: 'subject_contact',
            width: 120
        }, {
            header: 'Department'.translator('stock-manage'),
            dataIndex: 'department_name',
            id: 'department_name',
            width: 90
        }, {
            header: 'Currency Type'.translator('stock-manage'),
            dataIndex: 'currency_id',
            id: 'currency_id',
            width: 100,
            renderer: render_currency_name,
            hidden: true
        }, {
            header: 'Forex Rate'.translator('stock-manage'),
            dataIndex: 'forex_rate',
            id: 'forex_rate',
            width: 79,
            align: 'right',
            renderer: render_number,
            hidden: true
        }, {
            header: 'Total Amount'.translator('stock-manage'),
            dataIndex: 'total_inventory_amount',
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

    gridInventory = new Ext.grid.GridPanel({
        title: '',
        store: storeInventory,
        cm: cmInventory,
        stripeRows: true,
        height: 557,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        tbar: tbarInventory,
        bbar: bbarInventory,
        id: 'gridInventory'
    });

    gridInventory.on('keydown', function(e){
        if (e.keyCode == 46) {
            Inventory.remove();
        }
    }, this);

    gridInventory.on('rowdblclick', function(e){
        display_detail_inventory();
    }, this);

    function display_detail_inventory(){
        var record = gridInventory.getSelectionModel().getSelected();
        if (record) {
            //if (currentPeriodId == record.data.period_id) {
            selectedInventoryVoucherIndex = gridInventory.getStore().indexOf(record);
            Ext.getCmp('subject_id').setValue(record.data.subject_id);
            // set value for form
            Ext.getCmp('inventoryInfo').setTitle("thong tin phieu" + " - " + record.data.inventory_voucher_number);
            Ext.getCmp('inventory_voucher_id').setValue(record.data.inventory_voucher_id);
            Ext.getCmp('inventory_voucher_number').setValue(record.data.inventory_voucher_number);
            Ext.getCmp('voucher_type_id').setValue(record.data.voucher_type_id);
            Ext.getCmp('inventory_voucher_date').setValue(record.data.inventory_voucher_date_format);
            Ext.getCmp('subject_code').setValue(record.data.subject_id);
            Ext.getCmp('subject_contact').setValue(record.data.subject_contact);
            Ext.getCmp('department_id').setValue(record.data.department_id);
            Ext.getCmp('department_code').setValue(record.data.department_id);
            Ext.getCmp('in_warehouse_id').setValue(record.data.in_warehouse_id != 0 ? record.data.in_warehouse_id : null);
            Ext.getCmp('out_warehouse_id').setValue(record.data.out_warehouse_id != 0 ? record.data.out_warehouse_id : null);
            Ext.getCmp('forex_rate').setValue(render_number(record.data.forex_rate));
            Ext.getCmp('in_out').setValue(record.data.in_out);

            storeVoucherType.baseParams = {
				'typeVote': record.data.in_out
			};

            Ext.getCmp('currency_code').setValue(record.data.currency_id);
            Ext.getCmp('currency_id').setValue(record.data.currency_id);
            Ext.getCmp('description').setValue(record.data.description);

			Ext.getCmp('is_inheritanced').setValue(record.data.is_inheritanced);
            Ext.getCmp('is_locked').setValue(record.data.is_locked);

            Ext.getCmp('to_accountant').setValue(record.data.to_accountant);
            if (record.data.in_out == 1) {
                Ext.getCmp('currency_code').enable();
                Ext.getCmp('currency_id').enable();
                Ext.getCmp('forex_rate').enable();

                if (isEmpty(record.data.is_inheritanced)) {
                    Ext.getCmp('to_accountant').enable();
                }
                else {
                    Ext.getCmp('to_accountant').disable();
                }
            }
            else
                // xuat va van chuyen noi bo thi bat buoc hach toan
                if ((record.data.in_out == 2) || (record.data.in_out == 3)) {
                    Ext.getCmp('currency_code').disable();
                    Ext.getCmp('currency_id').disable();
                    Ext.getCmp('forex_rate').disable();
                    Ext.getCmp('to_accountant').disable();
                }

            gridDetail.getStore().baseParams.type = null;
            gridDetail.getStore().baseParams.purchaseInherId = null;
            if ((record.data.in_out == 1) && !isEmpty(record.data.is_inheritanced)) {
                gridDetail.getStore().baseParams.type = PURC_INHER;
            }
            else
                if ((record.data.in_out == 2) && !isEmpty(record.data.is_inheritanced)) {
                    gridDetail.getStore().baseParams.type = SALE_INHER;
                }



            Ext.getCmp('reload_detail').enable();
            Ext.getCmp('btn_nheritance').disable();
            Ext.getCmp('in_out').disable();
            Ext.getCmp('voucher_type').disable();
			Ext.getCmp('inventory_voucher_number').disable();

            storeSubject.baseParams.typeSubject = record.data.in_out;
            storeSubject.load();

            gridDetail.getStore().baseParams.inventoryVoucherId = record.data.inventory_voucher_id;
            gridDetail.getStore().baseParams.voucherId = record.data.voucher_id;
			gridDetail.getStore().baseParams.batchId = record.data.batch_id;
            gridDetail.getStore().load();

            status = 'update';
            Ext.getCmp('btn_save').disable();
            Ext.getCmp('btn_delete').enable();

            // phan hach toan
			var entryTypeId;
			if(record.data.in_out == 1){
				entryTypeId = 19;
			}else if(record.data.in_out == 2){
				entryTypeId = 20;
			}else{
				entryTypeId = 21;
			}
            gridAcc.getStore().baseParams = {
                'batchId': record.data.batch_id,
				'entryTypeId': entryTypeId
            };
            gridAcc.getStore().removeAll();
            gridAcc.getStore().load();
        }
        else
            warning('Warning'.translator('stock-manage'), ' Check show detail'.translator('stock-manage'));
    }

    storeInventory.on('beforeload', function(){
        var srchNumber = gridInventory.topToolbar.items.get('srch_inventory_number').getValue();

        var srchFromDate = gridInventory.topToolbar.items.get('srch_from_date').getValue();
        if (srchFromDate != null && srchFromDate != '')
            srchFromDate = srchFromDate.dateFormat('Y-m-d 00:00:00');
        else
            srchFromDate = '';

        var srchToDate = gridInventory.topToolbar.items.get('srch_to_date').getValue();
        if (srchToDate != null && srchToDate != '')
            srchToDate = srchToDate.dateFormat('Y-m-d 00:00:00');
        else
            srchToDate = '';

        storeInventory.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
        storeInventory.baseParams.fromDate = srchFromDate;
        storeInventory.baseParams.toDate = srchToDate;
        storeInventory.baseParams.typeVote = Ext.getCmp('srch_type_vote').getValue();
        storeInventory.baseParams.start = 0;
        storeInventory.baseParams.limit = page_size;
    });
});
//
var baseDeleteInventory = function(arrRecord){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteInventoryVoucher/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                msg('Info'.translator('buy-billing'), 'Phiếu hàng tồn kho đã xóa.', Ext.MessageBox.INFO);
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