// Replaces all instances of the given substring.
String.prototype.replaceAll = function(strTarget, // The substring you want to replace
 strSubString // The string you want to replace in.
){
    var strText = this;
    var intIndexOfMatch = strText.indexOf(strTarget);
    
    // Keep looping while an instance of the target string
    // still exists in the string.
    while (intIndexOfMatch != -1) {
        // Relace out the current instance.
        strText = strText.replace(strTarget, strSubString)
        
        // Get the index of any next matching substring.
        intIndexOfMatch = strText.indexOf(strTarget);
    }
    
    // Return the updated string with ALL the target strings
    // replaced out with the new substring.
    return (strText);
}

var formatNumber = function(number){
    number = number.replaceAll(thousandSeparator, '');
    if (decimalSeparator == ',') 
        number = number.replace(decimalSeparator, '.');
    return number;
}

function isEmpty(obj){
    if (typeof obj == 'undefined' || obj === null || obj === '') 
        return true;
    if (typeof obj == 'number' && isNaN(obj)) 
        return true;
    if (obj instanceof Date && isNaN(Number(obj))) 
        return true;
    return false;
}

var setLabelInOut = function(inout){
    var lblSubject = '';
    var lblContact = '';
    var lblDepartment = '';
    storeDebitAccount.removeAll();
    storeCreditAccount.removeAll();
    if (inout == DEFAULT_INPUT_VOTE_TYPE) {
        Ext.getCmp('out_warehouse_id').setDisabled(true);
        Ext.getCmp('in_warehouse_id').setDisabled(false);
        lblSubject = 'Input Subject'.translator('stock-manage');
        lblContact = 'Input Contact'.translator('stock-manage');
        lblDepartment = 'Input Department'.translator('stock-manage');
        storeDebitAccount.baseParams = {
            'accountTypeId': DEFAULT_INPUT_ENTRY_TYPE
        };
        storeCreditAccount.baseParams = {
            'accountTypeId': DEFAULT_INPUT_ENTRY_TYPE
        };
    }
    else 
        if (inout == DEFAULT_OUTPUT_VOTE_TYPE) {
            Ext.getCmp('in_warehouse_id').setDisabled(true);
            Ext.getCmp('out_warehouse_id').setDisabled(false);
            lblSubject = 'Output Subject'.translator('stock-manage');
            lblContact = 'Output Contact'.translator('stock-manage');
            lblDepartment = 'Output Department'.translator('stock-manage');
            storeDebitAccount.baseParams = {
                'accountTypeId': DEFAULT_OUTPUT_ENTRY_TYPE
            };
            storeCreditAccount.baseParams = {
                'accountTypeId': DEFAULT_OUTPUT_ENTRY_TYPE
            };
        }
        else 
            if (inout == DEFAULT_INTERNAL_VOTE_TYPE) {
                Ext.getCmp('in_warehouse_id').setDisabled(false);
                Ext.getCmp('out_warehouse_id').setDisabled(false);
                lblSubject = 'Internal Subject'.translator('stock-manage');
                lblContact = 'Internal Contact'.translator('stock-manage');
                lblDepartment = 'Internal Department'.translator('stock-manage');
                storeDebitAccount.baseParams = {
                    'accountTypeId': DEFAULT_INTERNAL_ENTRY_TYPE
                };
                storeCreditAccount.baseParams = {
                    'accountTypeId': DEFAULT_INTERNAL_ENTRY_TYPE
                };
            }
    generalTab.findById('subject_id').label.dom.innerHTML = lblSubject;
    generalTab.findById('subject_contact').label.dom.innerHTML = lblContact;
    generalTab.findById('department_id').label.dom.innerHTML = lblDepartment;
    storeDebitAccount.load();
    storeCreditAccount.load();
}

var set_subject_by_inout = function(inout, subId){
    storeSubject.removeAll();
    tabs.getItem('accountInfo').setDisabled(false);
    if (inout == DEFAULT_INPUT_VOTE_TYPE) {
        if (!isLoadedSubIn) {
            isLoadedSubIn = true;
            storeSubjectIn.baseParams = {
                'currentSubjectId': subId
            };
            storeSubjectIn.load();
        }
        else {
            storeSubjectIn.each(function(r){
                storeSubject.add(r.copy());
            });
            Ext.getCmp('subject_id').setValue(subId);
        }
    }
    else 
        if (inout == DEFAULT_OUTPUT_VOTE_TYPE) {
            if (!isLoadedSubOut) {
                isLoadedSubOut = true;
                storeSubjectOut.baseParams = {
                    'currentSubjectId': subId
                };
                storeSubjectOut.load();
            }
            else {
                storeSubjectOut.each(function(r){
                    storeSubject.add(r.copy());
                });
                Ext.getCmp('subject_id').setValue(subId);
            }
        }
        else 
            if (!isLoadedSubInter) {
                isLoadedSubInter = true;
                storeSubjectInter.baseParams = {
                    'currentSubjectId': subId
                };
                storeSubjectInter.load();
            }
            else {
                storeSubjectInter.each(function(r){
                    storeSubject.add(r.copy());
                });
                Ext.getCmp('subject_id').setValue(subId);
            }
}

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
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    var myDataTypeVote = [[1, 'Input'.translator('stock-manage')], [2, 'Output'.translator('stock-manage')], [3, 'Internal transport'.translator('stock-manage')]];
    
    var storeTypeVote = new Ext.data.ArrayStore({
        fields: [{
            name: 'type_vote_id'
        }, {
            name: 'type_vote_name'
        }]
    });
    
    storeTypeVote.loadData(myDataTypeVote);
    
    var comboTypeVote = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeTypeVote,
        valueField: 'type_vote_id',
        displayField: 'type_vote_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
            }
        }
    });
    
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
    
    storeCurrencyWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name', 'forex_rate']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCurrencyWithForexRate/1'
        }),
        autoLoad: true
    });
    
    storeCurrencyWithForexRate.on('beforeload', function(){
        storeCurrencyWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });
    
    function render_currency_name(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeCurrencyWithForexRate.queryBy(function(rec){
                return rec.data.currency_id == val;
            }).itemAt(0).data.currency_name;
        } 
        catch (e) {
        }
    }
    
    var comboGirdCurrency = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeCurrencyWithForexRate,
        valueField: 'currency_id',
        displayField: 'currency_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                gridInventory.getSelectionModel().getSelected().data.forex_rate = record.data.forex_rate;
            }
        }
    });
    
    storeWarehouse = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'warehouse_id',
            fields: ['warehouse_id', 'warehouse_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListWarehouse/1'
        }),
        autoLoad: true
    });
    
    storeWarehouse.on('load', function(){
        storeWarehouse.insert(0, new Ext.data.Record({
            warehouse_id: 0,
            warehouse_name: ''
        }));
        storeInventory.load();
    });
    
    function render_warehouse_name(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeWarehouse.queryBy(function(rec){
                return rec.data.warehouse_id == val;
            }).itemAt(0).data.warehouse_name;
        } 
        catch (e) {
        }
    }
    
    var comboWarehouseIn = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeWarehouse,
        valueField: 'warehouse_id',
        displayField: 'warehouse_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true
    });
    
    var comboWarehouseOut = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeWarehouse,
        valueField: 'warehouse_id',
        displayField: 'warehouse_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true
    });
    
    function render_in_out(value){
        if (value == DEFAULT_INPUT_VOTE_TYPE) 
            return 'Debit'.translator('fund-manage');
        else 
            if (value == DEFAULT_OUTPUT_VOTE_TYPE) 
                return 'Credit'.translator('fund-manage');
            else 
                if (value == DEFAULT_INTERNAL_VOTE_TYPE) 
                    return 'Transfer'.translator('fund-manage');
    }
    
    function formatDate(value){
        try {
            return value ? ((value.dateFormat(date_format_string) != '01/01/1970') ? value.dateFormat(date_format_string) : '') : '';
        } 
        catch (e) {
        }
    };
    
    var inventoryRecord = [{
        name: 'inventory_voucher_id',
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
        name: 'subject_id',
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
        name: 'batch_id',
        type: 'string'
    }, {
        name: 'voucher_id',
        type: 'string'
    }];
    
    var inventoryObject = Ext.data.Record.create(inventoryRecord);
    
    var Inventory = {
        add: function(){
            var inventoryNewRecord = new inventoryObject();
            gridInventory.getStore().insert(gridInventory.getStore().getCount(), inventoryNewRecord);
            gridInventory.startEditing(gridInventory.getStore().getCount() - 1, 0);
            gridInventory.bottomToolbar.items.get('add_Inventory').disable();
        },
        remove: function(){
            var records = gridInventory.getSelectionModel().getSelections();
            if (records.length >= 1) {
                Ext.Msg.show({
                    title: 'Confirm'.translator('stock-manage'),
                    buttons: Ext.MessageBox.YESNO,
                    icon: Ext.MessageBox.QUESTION,
                    msg: 'Are delete inventory'.translator('stock-manage'),
                    fn: function(btn){
                        if (btn == 'yes') {
                            var arrRecord = new Array();
                            for (var i = 0; i < records.length; i++) {
                                if (!isEmpty(records[i].data.inventory_voucher_id)) {
                                    arrRecord.push({
                                        inventory_voucher_id: records[i].data.inventory_voucher_id
                                    });
                                }
                                gridInventory.getStore().remove(records[i]);
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
        autoLoad: false
    });
    
    var tbarInventory = new Ext.Toolbar({
        items: [{
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
                }
            }
        }), {
            text: 'Find'.translator('stock-manage'),
            id: 'find_inventory',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            style: 'padding-left: 5px;',
            handler: Inventory.find
        }, '-', {
            xtype: 'button',
            width: 70,
            height: 20,
            text: 'Show Detail'.translator('stock-manage'),
            id: 'btnDetail',
            handler: function(){
            
            }
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
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Inventory Voucher Date'.translator('stock-manage'),
            dataIndex: 'inventory_voucher_date_format',
            id: 'inventory_voucher_date_format',
            width: 77,
            renderer: formatDate,
            editor: new Ext.form.DateField({
                allowBlank: false,
                format: date_format_string
            })
        }, {
            header: 'Type Vote'.translator('stock-manage'),
            dataIndex: 'in_out',
            id: 'in_out',
            width: 120,
            editor: comboTypeVote,
            renderer: render_type_vote_name
        }, {
            header: 'Input Warehouse'.translator('stock-manage'),
            dataIndex: 'in_warehouse_id',
            id: 'in_warehouse_id',
            width: 150,
            editor: comboWarehouseIn,
            renderer: render_warehouse_name
        }, {
            header: 'Output Warehouse'.translator('stock-manage'),
            dataIndex: 'out_warehouse_id',
            id: 'out_warehouse_id',
            width: 150,
            editor: comboWarehouseOut,
            renderer: render_warehouse_name
        }, {
            header: 'Currency Type'.translator('stock-manage'),
            dataIndex: 'currency_id',
            id: 'currency_id',
            width: 110,
            editor: comboGirdCurrency,
            renderer: render_currency_name
        }, {
            header: 'Forex Rate'.translator('stock-manage'),
            dataIndex: 'forex_rate',
            id: 'forex_rate',
            width: 79,
            align: 'right',
            editor: new Ext.form.TextField({
                allowBlank: false,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                    }
                }
            })
        }, {
            header: 'Total Amount'.translator('stock-manage'),
            dataIndex: 'total_inventory_amount',
            width: 150,
            align: 'right'
        }]
    });
    
    gridInventory = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeInventory,
        cm: cmInventory,
        stripeRows: true,
        height: 530,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        tbar: tbarInventory,
        bbar: [{
            text: 'Add'.translator('stock-manage'),
            id: 'add_Inventory',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Inventory.add
        }, {
            text: 'Delete'.translator('stock-manage'),
            id: 'delete_Inventory',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Inventory.remove
        }, bbarInventory],
        stateful: true,
        stateId: 'gridInventory',
        id: 'gridInventory',
        listeners: {
            cellclick: function(grid, rowIndex, columnIndex, e){
            
            },
            afteredit: function(e){
                var status = false;
                if (!e.record.data.inventory_voucher_number ||
                !e.record.data.inventory_voucher_date_format ||
                !e.record.data.in_out) {
                    status = true;
                }
                if (!status) {
                    if (Ext.getCmp('add_Inventory').disabled) {
                        insertRecordInventory(e.record, e.record.data.inventory_voucher_number, e.record.data.inventory_voucher_date_format, e.record.data.in_out, e.record.data.in_warehouse_id, e.record.data.out_warehouse_id, e.record.data.currency_id, e.record.data.forex_rate);
                    }
                    else {
                        if (e.field == 'in_out') {
                            Ext.Ajax.request({
                                url: pathRequestUrl + '/updateTypeVoteOfPurchase/' + e.record.id,
                                method: 'post',
                                success: function(result, options){
                                    var result = Ext.decode(result.responseText);
                                    if (result.success) {
                                        e.record.commit();
                                    }
                                    else {
                                        e.record.reject();
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
                                    voucherId: Ext.encode(e.record.data.voucher_id),
                                    batchId: Ext.encode(e.record.data.batch_id),
                                    field: Ext.encode(e.field),
                                    value: Ext.encode(e.value)
                                }
                            });
                        }
                        else {
                            if (e.field == 'forex_rate') {
                                if (parseFloat(e.value) < 0) {
                                    e.record.reject();
                                    msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                                    return;
                                }
                                else {
                                    e.value = formatNumber(e.value);
                                }
                            }
                            if (e.field == 'inventory_voucher_date_format') {
                                e.field = 'inventory_voucher_date';
                                e.value = e.value.dateFormat(date_sql_format_string);
                            }
                            Ext.Ajax.request({
                                url: pathRequestUrl + '/updateInventoryVoucher/' + e.record.id,
                                method: 'post',
                                success: function(result, options){
                                    var result = Ext.decode(result.responseText);
                                    if (result.success) {
                                        if (e.field == 'currency_id' || e.field == 'forex_rate') {
                                            if (result.data.change_currency) {
                                                e.record.data.total_inventory_amount = result.data.total_inventory_amount;
                                            }
                                            else {
                                                var currencyName = storeCurrencyWithForexRate.queryBy(function(rec){
                                                    return rec.data.currency_id == e.record.data.currency_id;
                                                }).itemAt(0).data.currency_name;
                                                warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + currencyName + 'Not forexrate'.translator('buy-billing'));
                                            }
                                            e.record.data.currency_id = result.data.currency_id;
                                            e.record.data.forex_rate = result.data.forex_rate;
                                        }
                                        e.record.commit();
                                    }
                                    else {
                                        e.record.reject();
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
                                    batchId: Ext.encode(e.record.data.batch_id),
                                    convertCurrency: convertedCurrencyId,
                                    field: Ext.encode(e.field),
                                    value: Ext.encode(e.value)
                                }
                            });
                        }
                    }
                }
            }
        }
    });
    
    gridInventory.on('keydown', function(e){
        if (e.browserEvent.keyCode == e.ENTER) {
            display_detail_inventory();
        }
        else 
            if (e.keyCode == 46) {
                Inventory.remove();
            }
    }, this);
    
    function display_detail_inventory(){
        var record = gridInventory.getSelectionModel().getSelected();
        if (isNaN(record.id)) 
            return;
        if (record) {
            if (currentPeriodId == record.data.period_id) {
                tabs.getItem('inventoryInfo').setDisabled(false);
                tabs.getItem('accountInfo').setDisabled(false);
                tabs.setActiveTab('inventoryInfo');
                if (!isStart) {
                    isStart = true;
                    storeUnit.load();
                    storeDepartment.baseParams = {
                        'currentDepartmentId': record.data.department_id
                    };
                    storeDepartment.load();
                }
                else 
                    Ext.getCmp('department_id').setValue(record.data.department_id);
                selectedInventoryId = record.id;
                selectedInventoryIndex = gridInventory.getStore().indexOf(record);
                forexRate = record.data.forex_rate;
                currencyType = record.data.currency_id;
                gridDetail.getStore().baseParams = {
                    'inventoryVoucherId': selectedInventoryId,
                    'voucherId': record.data.voucher_id,
                    'batchId': record.data.batch_id,
                    'inOut': record.data.in_out
                };
                gridDetail.getStore().load();
                // set subject store by in_out
                set_subject_by_inout(record.data.in_out, record.data.subject_id);
                // set value for form
                setLabelInOut(record.data.in_out);
                if (record.data.in_out == DEFAULT_INPUT_VOTE_TYPE) 
                    generalTab.findById('in_out').items.items[0].el.dom.checked = true;
                
                else 
                    if (record.data.in_out == DEFAULT_OUTPUT_VOTE_TYPE) 
                        generalTab.findById('in_out').items.items[1].el.dom.checked = true;
                    
                    else 
                        if (record.data.in_out == DEFAULT_INTERNAL_VOTE_TYPE) 
                            generalTab.findById('in_out').items.items[2].el.dom.checked = true;
                Ext.getCmp('inventory_voucher_number').setValue(record.data.inventory_voucher_number);
                Ext.getCmp('inventory_voucher_date').setValue(record.data.inventory_voucher_date_format);
                Ext.getCmp('subject_contact').setValue(record.data.subject_contact);
                Ext.getCmp('in_warehouse_id').setValue(record.data.in_warehouse_id);
                Ext.getCmp('out_warehouse_id').setValue(record.data.out_warehouse_id);
                //Ext.getCmp('in_out').setValue(record.data.in_out);
                Ext.getCmp('forex_rate').setValue(record.data.forex_rate);
                Ext.getCmp('currency_id').setValue(record.data.currency_id);
                Ext.getCmp('description').setValue(record.data.description);
                
                gridAccounting.getStore().baseParams = {
                    batchId: record.data.batch_id
                };
                gridAccounting.getStore().removeAll();
                gridAccounting.getStore().load();
            }
            else 
                warning('Warning'.translator('stock-manage'), 'Check edit inventory'.translator('stock-manage'));
        }
        else 
            warning('Warning'.translator('stock-manage'), ' Check show detail'.translator('stock-manage'));
    }
    
    storeInventory.on('beforeload', function(){
        var srchNumber = gridInventory.topToolbar.items.get('srch_inventory_number').getValue();
        
        var srchFromDate = gridInventory.topToolbar.items.get('srch_from_date').getValue();
        if (srchFromDate != null && srchFromDate != '') 
            srchFromDate = srchFromDate.dateFormat('Y-m-d');
        else 
            srchFromDate = '';
        
        var srchToDate = gridInventory.topToolbar.items.get('srch_to_date').getValue();
        if (srchToDate != null && srchToDate != '') 
            srchToDate = srchToDate.dateFormat('Y-m-d');
        else 
            srchToDate = '';
        
        storeInventory.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
        storeInventory.baseParams.fromDate = srchFromDate;
        storeInventory.baseParams.toDate = srchToDate;
        storeInventory.baseParams.typeVote = Ext.getCmp('srch_type_vote').getValue();
        storeInventory.baseParams.start = 0;
        storeInventory.baseParams.limit = page_size;
        
        gridInventory.bottomToolbar.items.get('add_Inventory').enable();
    });
});

var insertRecordInventory = function(record, inventoryNumber, inventoryDate, typeVote, inWarehouse, outWarehouse, currencyId, forexRate){

    inventoryDate = inventoryDate.dateFormat(date_sql_format_string);
    if (!isEmpty(forexRate)) 
        forexRate = formatNumber(forexRate);
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertInventoryVoucher/' + inventoryNumber,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                record.id = result.data.inventory_voucher_id;
                record.data.inventory_voucher_id = result.data.inventory_voucher_id;
                record.data.total_inventory_amount = result.data.total_inventory_amount;
                record.data.voucher_id = result.data.voucher_id;
                record.data.period_id = result.data.period_id;
                record.data.in_warehouse_id = result.data.in_warehouse_id;
                record.data.out_warehouse_id = result.data.out_warehouse_id;
                record.data.currency_id = result.data.currency_id;
                record.data.forex_rate = result.data.forex_rate;
                record.data.batch_id = result.data.batch_id;
                record.data.created_by_userid = result.data.created_by_userid;
                record.data.date_entered = result.data.date_entered;
                record.data.last_modified_by_userid = result.data.last_modified_by_userid;
                record.data.date_last_modified = result.data.date_last_modified;
                record.data.description = result.data.description;
                record.commit();
                gridInventory.bottomToolbar.items.get('add_Inventory').enable();
                gridInventory.getSelectionModel().selections.clear();
            }
            else {
                record.reject();
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
            record.reject();
        },
        params: {
            inventoryDate: Ext.encode(inventoryDate),
            typeVote: Ext.encode(typeVote),
            inWarehouse: Ext.encode(inWarehouse),
            outWarehouse: Ext.encode(outWarehouse),
            currencyId: Ext.encode(currencyId),
            forexrate: Ext.encode(forexRate)
        }
    });
}

var baseDeleteInventory = function(arrRecord){

    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteInventoryVoucher/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                msg('Info'.translator('stock-manage'), 'Delete success'.translator('stock-manage'), Ext.MessageBox.INFO);
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
}
