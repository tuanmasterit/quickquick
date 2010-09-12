var inventoryObject;

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
        if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
            e.stopEvent();
            var index = this.grid.getView().findRowIndex(t);
            var record = this.grid.store.getAt(index);
            record.set(this.dataIndex, record.data[this.dataIndex] == 'enabled' ? 'disabled' : 'enabled');
        }
    },
    
    renderer: function(v, p, record){
        p.css += ' x-grid3-check-col-td';
        return '<div class="x-grid3-check-col' + (v == 'enabled' ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
    }
};
/*end of checkbox column*/

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

function createGridInventory(){
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
            name: 'inventory_voucher_number',
            type: 'string'
        }, {
            name: 'inventory_voucher_date_format',
            type: 'date'
        }, {
            name: 'in_out',
            type: 'string'
        }, {
            name: 'subject_contact',
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
            name: 'voucher_id',
            type: 'string'
        }];
        
        inventoryObject = Ext.data.Record.create(inventoryRecord);
        
        var Inventory = {           
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
                url: pathRequestUrl + '/getListInventoryVoucherNotInheritance/1'
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
                id: 'srch_from_date_inventory',
                format: date_format_string,
                //readOnly: true,
                vtype: 'daterange',
                endDateField: 'srch_to_date_inventory'
            }, '-', {
                xtype: 'label',
                text: 'To Date'.translator('stock-manage'),
                style: 'padding-left: 5px;padding-right: 5px;'
            }, {
                xtype: 'datefield',
                width: 99,
                labelSeparator: '',
                id: 'srch_to_date_inventory',
                format: date_format_string,
                //readOnly: true,
                vtype: 'daterange',
                startDateField: 'srch_from_date_inventory'
            }, '-', {
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
        
        var sm = new Ext.grid.CheckboxSelectionModel();
        
        var cmInventory = new Ext.grid.ColumnModel({
            defaults: {
                sortable: true
            },
            columns: [new Ext.grid.RowNumberer(), sm, {
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
                width: 100,
                renderer: render_type_vote_name
            }, {
                header: 'Output Warehouse'.translator('stock-manage'),
                dataIndex: 'out_warehouse_id',
                id: 'out_warehouse_id',
                width: 70,
                renderer: render_warehouse_name
            }, {
                header: 'Contact Subject'.translator('stock-manage'),
                dataIndex: 'subject_contact',
                id: 'subject_contact',
                width: 120
            }, {
                header: 'Currency Type'.translator('stock-manage'),
                dataIndex: 'currency_id',
                id: 'currency_id',
                width: 100,
                renderer: render_currency_name
            }, {
                header: 'Forex Rate'.translator('stock-manage'),
                dataIndex: 'forex_rate',
                id: 'forex_rate',
                width: 79,
                align: 'right',
                renderer: render_number
            }, {
                header: 'Total Amount'.translator('stock-manage'),
                dataIndex: 'total_inventory_amount',
                width: 120,
                align: 'right',
                renderer: render_number
            }]
        });
        
        gridInventory = new Ext.grid.EditorGridPanel({
            title: '',
            store: storeInventory,
            cm: cmInventory,
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
			sm: new Ext.grid.RowSelectionModel({
	            singleSelect: true
	        }),
            tbar: tbarInventory,
            bbar: bbarInventory,
            id: 'gridInventory'
        });
        
        storeInventory.on('beforeload', function(){
            var srchNumber = gridInventory.topToolbar.items.get('srch_inventory_number').getValue();
            
            var srchFromDate = gridInventory.topToolbar.items.get('srch_from_date_inventory').getValue();
            if (srchFromDate != null && srchFromDate != '') 
                srchFromDate = srchFromDate.dateFormat('Y-m-d 00:00:00');
            else 
                srchFromDate = '';
            
            var srchToDate = gridInventory.topToolbar.items.get('srch_to_date_inventory').getValue();
            if (srchToDate != null && srchToDate != '') 
                srchToDate = srchToDate.dateFormat('Y-m-d 00:00:00');
            else 
                srchToDate = '';
            
            storeInventory.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
            storeInventory.baseParams.fromDate = srchFromDate;
            storeInventory.baseParams.toDate = srchToDate;
            storeInventory.baseParams.customerId = Ext.getCmp('customer_id').getValue();
            storeInventory.baseParams.start = 0;
            storeInventory.baseParams.limit = page_size;
        });
    });
    
};
