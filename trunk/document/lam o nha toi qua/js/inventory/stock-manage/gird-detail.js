var gridDetail;
var DetailRecord;
var formInvoiceWin;
var comboUnitOption;

Ext.onReady(function(){
    Ext.QuickTips.init();
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

    var storeUnitOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'unit_id'
        }, {
            name: 'unit_name'
        }, {
            name: 'default_inventory_price'
        }, {
            name: 'coefficient'
        }]
    });

    comboUnitOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeUnitOption,
        valueField: 'unit_id',
        displayField: 'unit_name',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:100px;">{unit_name}</div><div style="float:left; text-align:left;">|</div><div>{default_inventory_price}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: true,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 200,
        enableKeyEvents: true,
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(3);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    });

    DetailRecord = Ext.data.Record.create(['product_id']);

    function render_number(val){
        try {
            if (is_string(val) && (val.indexOf('/') == 0)) {
                var arrayValue = val.split('/');
                switch (arrayValue[1]) {
                    case 'Qty':
                        return "";
                        break;
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

    Detail = {
        add: function(atIndex, atColumnIndex){
            var newRecord = new DetailRecord({
                isTotal: false,
                isChecked: false,
                isLoadedData: false,
                isInsertData: true,
                product_id: null,
                product_code: null,
                product_name: null,
                price: null,
                unit_id: null,
                arr_unit: new Array(),
                quantity: null,
				coefficient: null,
                amount: null,
                converted_amount: null,
                note: ''
            });

            gridDetail.getView().refresh(true);
            var rec = gridDetail.getStore().getAt(gridDetail.getStore().getCount() - 1);
            if (rec.data.isChecked) {

                gridDetail.getStore().insert(gridDetail.getStore().getCount(), newRecord);
                // bat dau edit tai ma san pham cua dong moi
                gridDetail.startEditing(gridDetail.getStore().getCount() - 1, 1);
                gridDetail.getSelectionModel().selectRow(gridDetail.getStore().getCount() - 1);
            }
            else {
                gridDetail.startEditing(atIndex, atColumnIndex);
                gridDetail.getSelectionModel().selectRow(atIndex);
            }

        },
        remove: function(){
            var records = gridDetail.getSelectionModel().getSelections();
            if (records.length >= 1) {
                if ((status == 'insert') && isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].data.isChecked) {
                            gridDetail.getStore().remove(records[i]);
                        }
                    }
                    baseCalTotalAmmount();
                    gridDetail.getSelectionModel().selectRow(gridDetail.getStore().getCount() - 1);
                    gridDetail.getView().refresh(true);
                    if (gridDetail.getStore().getCount() == 2) {
                        gridDetail.getStore().baseParams.type = null; // neu xoa het thi chuyen sang dang khong ke thua
                        gridDetail.getStore().baseParams.purchaseInherId = null;
                    }
                }
                else {
                    // trang thai insert record
                    var arrRecord = new Array();
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].data.isChecked) {
                            var record = {
                                product_id: records[i].data.product_id,
                                unit_id: records[i].data.unit_id
                            };
                            arrRecord.push(record);
                        }
                    }
                    if (arrRecord.length > 0) {
                        baseDeleteDetail(gridDetail.getStore().baseParams.inventoryVoucherId, arrRecord, gridDetail.getStore().baseParams.voucherId);
                    }
                }
            }
        }
    };

    var detailRecord = [{
        name: 'detail_id',
        type: 'string'
    }, {
        name: 'inventory_voucher_id',
        type: 'string'
    }, {
        name: 'isTotal', // la dong total
        type: 'bool'
    }, {
        name: 'isChecked', // la dong da duoc chon san pham
        type: 'bool'
    }, {
        name: 'isLoadedData', // la dong chua duoc load
        type: 'bool'
    }, {
        name: 'isInsertData', // la dong them vao database
        type: 'bool'
    }, {
        name: 'product_id',
        type: 'string'
    }, {
        name: 'product_code',
        type: 'string'
    }, {
        name: 'product_name',
        type: 'string'
    }, {
        name: 'price',
        type: 'string'
    }, {
        name: 'quantity',
        type: 'string'
    }, {
        name: 'coefficient',
        type: 'string'
    }, {
        name: 'arr_unit',
        type: 'array'
    }, {
        name: 'unit_id',
        type: 'string'
    }, {
        name: 'amount',
        type: 'string'
    }, {
        name: 'converted_amount',
        type: 'string'
    }, {
        name: 'note',
        type: 'string'
    }];

    var detail_object = Ext.data.Record.create(detailRecord);

    storeDetail = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'detail_id',
        }, detail_object),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getDetailInventoryVoucherById/1'
        }),
        autoLoad: false
    });

    storeDetail.on('load', function(){
        if (!isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
            var recordTotal = new DetailRecord({
                isTotal: true,
                isChecked: false,
                isLoadedData: false,
                isInsertData: false,
                quantity: "/Qty/",
                price: "/Sum/",
                amount: "/0.00/",
                converted_amount: "/0.00/"
            });
            storeDetail.insert(0, recordTotal);
            baseCalTotalAmmount();
            var newRecord = new DetailRecord({
                isTotal: false,
                isChecked: false,
                isLoadedData: false,
                isInsertData: true,
                product_id: null,
                product_code: null,
                product_name: null,
                price: null,
                unit_id: null,
                arr_unit: new Array(),
                quantity: null,
				coefficient: null,
                amount: null,
                converted_amount: null,
                note: ''
            });
            gridDetail.getStore().insert(gridDetail.getStore().getCount(), newRecord);
            gridDetail.getSelectionModel().selectRow(gridDetail.getStore().getCount() - 1);
        }
    });

    var dsCode = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getSearchProduct/1'
        }),
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'product_id'
        }, [{
            name: 'product_id',
            type: 'string'
        }, {
            name: 'product_name',
            type: 'string'
        }, {
            name: 'product_code',
            type: 'string'
        }, {
            name: 'default_inventory_price',
            type: 'string'
        }, {
            name: 'default_sales_price',
            type: 'string'
        }, {
            name: 'regular_unit_id',
            type: 'string'
        }, {
            name: 'coefficient',
            type: 'string'
        }]),
        autoLoad: false
    });
    dsCode.on('beforeload', function(){
        if (Ext.getCmp('searchProductCode').hasFocus) {
            dsCode.baseParams.type = 'code';
        }
        else {
            dsCode.baseParams.type = 'name';
        }
    });
    var resultTplCode = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{product_code} | {product_name}</span><br />', '</div></tpl>');
    var searchProductCode = new Ext.form.ComboBox({
        id: 'searchProductCode',
        store: dsCode,
        valueField: 'product_id',
        typeAhead: false,
        width: 570,
        pageSize: 50,
        triggerAction: 'all',
        //hideTrigger:true,
        tpl: resultTplCode,
        width: 150,
        lazyRender: true,
        listWidth: 350,
        selectOnFocus: true,
        minChars: 1,
        itemSelector: 'div.search-item',
        enableKeyEvents: true,
        onSelect: function(record){ // override default onSelect to do redirect
            this.collapse();
            var rec = gridDetail.getSelectionModel().getSelected();
            var index = gridDetail.getStore().indexOf(rec);
            rec.data.product_name = record.data.product_name;
            rec.data.product_code = record.data.product_code;
            rec.data.product_id = record.data.product_id;
            if ((status == 'insert') && isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
                rec.data.unit_id = record.data.regular_unit_id;
				rec.data.coefficient = record.data.coefficient;
                if (Ext.getCmp('in_out').getValue().inputValue == 2) {
					rec.data.price = parseFloat(record.data.default_sales_price);
				}else{
					rec.data.price = parseFloat(record.data.default_inventory_price);
				}
            }
            else {
                rec.data.unit_id = null;
                rec.data.price = null;
                rec.data.quantity = null;
				rec.data.coefficient = null;
                rec.data.amount = null;
                rec.data.converted_amount = null;
            }

            rec.data.isChecked = true;
            rec.data.isLoadedData = true;
            // get gia tri load unit va tax
            baseGetUnitOfProduct(record.data.product_id, index, index + 1, 1);// bat dau edit cot tiep theo
        },
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(1);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    });

    var searchProductName = new Ext.form.ComboBox({
        store: dsCode,
        id: 'searchProductName',
        valueField: 'product_id',
        typeAhead: false,
        width: 570,
        pageSize: 50,
        triggerAction: 'all',
        //hideTrigger:true,
        tpl: resultTplCode,
        width: 150,
        lazyRender: true,
        listWidth: 350,
        selectOnFocus: true,
        minChars: 1,
        itemSelector: 'div.search-item',
        enableKeyEvents: true,
        onSelect: function(record){ // override default onSelect to do redirect
            this.collapse();
            var rec = gridDetail.getSelectionModel().getSelected();
            var index = gridDetail.getStore().indexOf(rec);
            rec.data.product_name = record.data.product_name;
            rec.data.product_code = record.data.product_code;
            rec.data.product_id = record.data.product_id;
            if ((status == 'insert') && isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
                rec.data.unit_id = record.data.regular_unit_id;
				rec.data.coefficient = record.data.coefficient;
				if (Ext.getCmp('in_out').getValue().inputValue == 2) {
					rec.data.price = parseFloat(record.data.default_sales_price);
				}else{
					rec.data.price = parseFloat(record.data.default_inventory_price);
				}
            }
            else {
                rec.data.unit_id = null;
                rec.data.price = null;
                rec.data.quantity = null;
				rec.data.coefficient = null;
                rec.data.amount = null;
                rec.data.converted_amount = null;
            }

            rec.data.isChecked = true;
            rec.data.isLoadedData = true;
            baseGetUnitOfProduct(record.data.product_id, index, index + 1, 2);
        },
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(2);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }

    });

    var cmDetail = new Ext.grid.ColumnModel({
        defaults: {
            sortable: false
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Product Code'.translator('buy-billing'),
            id: 'product_code',
            width: 80,
            dataIndex: 'product_code',
            editable: true
        }, {
            header: 'Product Name'.translator('buy-billing'),
            width: 350,
            dataIndex: 'product_name',
            id: 'product_name',
            editable: true
        }, {
            header: 'Unit'.translator('buy-billing'),
            width: 80,
            dataIndex: 'unit_id',
            id: 'unit_id',
            editable: true,
            renderer: render_unit_name
        }, {
            header: 'Qty'.translator('buy-billing'),
            width: 75,
            dataIndex: 'quantity',
            id: 'quantity',
            editable: true,
            align: 'right',
            renderer: render_number
        }, {
            header: 'Price'.translator('buy-billing'),
            id: 'price',
            width: 100,
            dataIndex: 'price',
            align: 'right',
            editable: true,
            renderer: render_number
        }, {
            header: 'Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'amount',
            align: 'right',
            renderer: render_number
        }, {
            header: 'Converted Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'converted_amount',
            id: 'converted_amount',
            align: 'right',
            renderer: render_number
        }, {
            header: 'Note'.translator('buy-billing'),
            width: 200,
            dataIndex: 'note',
            id: 'note',
            editable: true
        }],
        editors: {
            'product_name': new Ext.grid.GridEditor(searchProductName),
            'product_code': new Ext.grid.GridEditor(searchProductCode),
            'unit_id': new Ext.grid.GridEditor(comboUnitOption),
            'price': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e))
                            e.stopEvent();
                        if (e.getCharCode() == 38) {
                            baseNextStartingEdit(5);
                        }
                        else
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 5);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            })),
            'quantity': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e))
                            e.stopEvent();
                        if (e.getCharCode() == 38) {
                            baseNextStartingEdit(4);
                        }
                        else
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 4);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            })),
            'note': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true
            }))
        },
        getCellEditor: function(colIndex, rowIndex){
            var isLocked = (Ext.getCmp('is_locked').getValue() == 1) ? true : false;
            var isType = gridDetail.getStore().baseParams.type;
            var rec = gridDetail.getStore().getAt(rowIndex);
            var isTotal = rec.data.isTotal;
            var isChecked = rec.data.isChecked;
            var isInsertData = rec.data.isInsertData;
            if (!isLocked) {
                // chi cho phep cap nhat price trong truong hop ke thua phieu ban hang
                if (colIndex == 5 && !isTotal && isChecked &&
                (isEmpty(isType) || (!isEmpty(isType) && (isType == SALE_INHER)))) {
                    return this.editors['price'];
                }
                if (colIndex == 4 && !isTotal && isChecked && isEmpty(isType)) {
                    return this.editors['quantity'];
                }
                if (colIndex == 1 && !isTotal && isEmpty(isType) && isInsertData) {
                    return this.editors['product_code'];
                }
                if (colIndex == 2 && !isTotal && isEmpty(isType) && isInsertData) {
                    return this.editors['product_name'];
                }
                if (colIndex == 3 && !isTotal && isChecked && isEmpty(isType)) {
                    return this.editors['unit_id'];
                }
                if (colIndex == 8 && !isTotal && isChecked) {
                    return this.editors['note'];
                }
            }
        }
    });

    var tbarDetail = new Ext.Toolbar({
        items: [{
            text: 'Delete'.translator('buy-billing'),
            id: 'delete_detail',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Detail.remove
        }, {
            text: 'Inheritance Invoice'.translator('stock-manage'),
            id: 'btn_nheritance',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/inheritance-icon.png',
            handler: function(){
                loadGridInheritance(Ext.getCmp('in_out').getValue().inputValue);
            }
        }, '->', {
            text: 'Reload'.translator('buy-billing'),
            id: 'reload_detail',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                gridDetail.getStore().removeAll();
                gridDetail.getStore().load();
            }
        }]
    });

    // create the Grid
    gridDetail = new Ext.grid.EditorGridPanel({
        title: '',
        store: storeDetail,
        cm: cmDetail,
        stripeRows: true,
        height: 294,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        clicksToEdit: 1,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: false
        }),
        tbar: tbarDetail,
        //stateful: true,
        //stateId: 'gridDetail',
        id: 'gridDetail',
        listeners: {
            beforeedit: function(e){
                if (e.record.data.isChecked && !e.record.data.isTotal) {
                    // kiem tra du lieu da load chua
                    if (e.record.data.isLoadedData) {
                        baseLoadUnit(e.record.data.arr_unit);
                    }
                    else {
                        e.record.data.isLoadedData = true;
                        baseGetUnitOfProduct(e.record.data.product_id, gridDetail.getStore().indexOf(e.record), gridDetail.getStore().indexOf(e.record), e.column);
                    }
                }

                if ((e.field == 'quantity') || (e.field == 'price')) {
                    e.value = cN(e.value);
                }
                switch (e.field) {
                    case 'quantity':
                        e.record.data.quantity = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    case 'price':
                        e.record.data.price = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    default:
                        return;                }
            },
            afteredit: function(e){
                if (e.record.data.isInsertData) {
                    var index = gridDetail.getStore().indexOf(e.record);
                    if (e.field == 'unit_id') {
                        if (FormAction.checkExistedProduct(e.record.data.product_id, e.value) > 0) {
                            msg('Error'.translator('buy-billing'), 'Existed Info'.translator('sale-billing'), Ext.MessageBox.ERROR);
                            e.record.reject();
                            return;
                        }
                        else {
                            var objectUnit = comboUnitOption.store.queryBy(function(rec){
                                return rec.data.unit_id == e.value;
                            }).itemAt(0);
                            e.record.data.price = !isEmpty(objectUnit) ? formatNumber(objectUnit.data.default_inventory_price) : 0;
							e.record.data.coefficient = objectUnit.data.coefficient;
                        }
                    }

                    if ((e.field == 'quantity') || (e.field == 'price') || (e.field == 'unit_id')) {
                        switch (e.field) {
                            case 'quantity':
                                e.record.data.quantity = formatNumber(e.value);
                                break;
                            case 'price':
                                e.record.data.price = formatNumber(e.value);
                                break;
                        }
                        baseCalculateDetail(e.record, e.record.data.quantity, e.record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()));
                    }
                    if ((status == 'insert') && isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
                        e.record.commit();
                    }
                    else {
                        // khong thuoc loai ke thua moi insert san pham vao
                        if (!isEmpty(e.record.data.unit_id) && !isEmpty(e.record.data.quantity)) {
                            baseInsertRecordDetail(e.record);
                        }
                    }
                }
                else {

                    if ((e.field == 'quantity') || (e.field == 'price')) {
                        if (parseFloat(e.value) < 0) {
                            e.record.reject();
                            msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                            return;
                        }
                        else
                            e.value = formatNumber(e.value);
                    }
                    else {
						if (e.field == 'unit_id') {
							if (FormAction.checkExistedProduct(e.record.data.product_id, e.value) > 0) {
								msg('Error'.translator('buy-billing'), 'Existed Info'.translator('sale-billing'), Ext.MessageBox.ERROR);
								e.record.reject();
								return;
							}
							else {
								var objectUnit = comboUnitOption.store.queryBy(function(rec){
									return rec.data.unit_id == e.value;
								}).itemAt(0);
								e.record.data.coefficient = objectUnit.data.coefficient;
							}
						}
					
					}

                    baseUpdateDetailInventoryVoucher(e.record, e.record.data.inventory_voucher_id, e.record.data.detail_id, e.field, e.value);
                }
            },
            cellclick: function(gridSpec, rowIndex, columnIndex, e){
                var selectedRecord = gridDetail.getSelectionModel().getSelected();
                isRowTotal = selectedRecord.data.isTotal;
                if (gridDetail.getColumnModel().getColumnId(columnIndex) == 'unit_id' && !selectedRecord.data.isTotal) {
                    baseLoadUnit(selectedRecord.data.arr_unit);
                }
            },
            "render": {
                scope: this,
                fn: function(grid){

                }
            }
        }
    });

    gridDetail.on('keydown', function(e){
        if (e.keyCode == 46) {
            Detail.remove();
        }
    });

	gridDetail.getView().getRowClass = function(record, index){
        if (record.data.isTotal)
            return 'format-row-total';
    };

    storeDetail.on('beforeload', function(){

        storeDetail.baseParams.start = 0;
        storeDetail.baseParams.limit = page_size;
    });

});

var baseNextStartingEdit = function(colIndex){
    var rec = gridDetail.getSelectionModel().getSelected();
    if (!rec.data.isTotal) {
        var index = gridDetail.getStore().indexOf(rec);
        if (index > 1) {
            // bat dau edit tai ma san pham cua dong moi
            gridDetail.startEditing(index - 1, colIndex);
            gridDetail.getSelectionModel().selectRow(index - 1);
        }
    }
};

var baseChangeForexrate = function(forexrate){
    for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
        var record = gridDetail.getStore().getAt(i);
        if (record.data.isChecked) {
            baseCalculateDetail(record, record.data.quantity, record.data.price, forexrate);
        }
    }
};

var baseCalculateDetail = function(record, quantity, price, forexrate){
    record.data.amount = cN(record.data.quantity) * cN(record.data.price);
    record.data.converted_amount = record.data.amount * forexrate;

    return baseCalTotalAmmount();
};

var baseCalTotalAmmount = function(){
    var amount = 0;
    var convertedAmount = 0;
    for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
        var record = gridDetail.getStore().getAt(i);
        amount += cN(record.data.amount);
        convertedAmount += cN(record.data.converted_amount);
    }
    var recordTotal = gridDetail.getStore().getAt(0);
    recordTotal.data.amount = '/' + amount + '/';
    recordTotal.data.converted_amount = '/' + convertedAmount + '/';

    gridDetail.getView().refresh(true);
	return convertedAmount;
};

var baseLoadUnit = function(arrUnit){
    comboUnitOption.store.removeAll();
    if (!isEmpty(arrUnit)) {
        var i;
        for (i = 0; i < arrUnit.length; i++) {
            var recordUnit = new Array();
            recordUnit['unit_id'] = arrUnit[i]['unit_id'];
            recordUnit['unit_name'] = arrUnit[i]['unit_name'];
			recordUnit['coefficient'] = arrUnit[i]['coefficient'];
            recordUnit['default_inventory_price'] = arrUnit[i]['default_inventory_price'];
            var rec = new Ext.data.Record(recordUnit);
            comboUnitOption.store.add(rec);
        }

    }
};

var baseGetUnitOfProduct = function(productId, index, rowEditIndex, colIndex){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getUnitOfProductId/' + productId,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                gridDetail.getStore().getAt(index).data.arr_unit = new Array();
                for (var i = 0; i < result.data.length; i++) {
                    var recordUnit = new Array();
                    recordUnit['unit_id'] = result.data[i]['unit_id'];
                    recordUnit['unit_name'] = result.data[i]['unit_name'];
					recordUnit['coefficient'] = result.data[i]['coefficient'];
					if(Ext.getCmp('in_out').getValue().inputValue == 2){
						recordUnit['default_inventory_price'] = number_format_extra(result.data[i]['default_sales_price'], decimals, decimalSeparator, thousandSeparator);
					}else{
						recordUnit['default_inventory_price'] = number_format_extra(result.data[i]['default_inventory_price'], decimals, decimalSeparator, thousandSeparator);
					}
                    gridDetail.getStore().getAt(index).data.arr_unit.push(recordUnit);
                }

                baseLoadUnit(gridDetail.getStore().getAt(index).data.arr_unit);
                Detail.add(rowEditIndex, colIndex);
            }
        },
        failure: function(response, request){
            var data = Ext.decode(response.responseText);
            if (!data.success) {
                alert(data.error);
                return;
            }
        }
    });
};

var loadGridInheritance = function(type){

    if (type == 1) {
		Ext.Msg.show({
			title: 'Confirm'.translator('receivable-manage'),
			buttons: Ext.MessageBox.YESNO,
			icon: Ext.MessageBox.QUESTION,
			msg: 'Ask inheritance purchase invoice'.translator('stock-manage'),
			fn: function(btn){
				if (btn == 'yes') {
					createGridInvoice();
					gridInvoice.getStore().load();
					formInvoiceWin = new Ext.Window({
						title: 'List invoice'.translator('stock-manage'),
						layout: 'fit',
						height: 600,
						width: 1000,
						modal: true,
						items: gridInvoice,
						closable: false,
						//buttonAlign: 'right',
						buttons: [{
							text: 'Inher Ok'.translator('sale-billing'),
							handler: function(){
								// post id of purchase
								var rec = gridInvoice.getSelectionModel().getSelected();
								if (!isEmpty(rec)) {
									getDetailRecordsOfPurchase(rec.data.purchase_invoice_id);
								}
							}
						}, {
							text: 'Cancel'.translator('sale-billing'),
							handler: function(){
								formInvoiceWin.close();
							}
						}]
					});
					formInvoiceWin.show();
				}
			}
		});
	}
	else
		if (type == 2) {
			Ext.Msg.show({
			title: 'Confirm'.translator('receivable-manage').translator('stock-manage'),
			buttons: Ext.MessageBox.YESNO,
			icon: Ext.MessageBox.QUESTION,
			msg: 'Ask inheritance sale invoice',
			fn: function(btn){
				if (btn == 'yes') {
					createGridSaleInvoice();
					gridSaleInvoice.getStore().load();
					formInvoiceWin = new Ext.Window({
						title: 'List invoice'.translator('stock-manage'),
						layout: 'fit',
						height: 600,
						width: 1000,
						modal: true,
						items: gridSaleInvoice,
						closable: false,
						//buttonAlign: 'right',
						buttons: [{
							text: 'Inher Ok'.translator('sale-billing'),
							handler: function(){
								// post id of purchase
								var rec = gridSaleInvoice.getSelectionModel().getSelected();
								if (!isEmpty(rec)) {
									gridDetail.getStore().baseParams.purchaseInherId = rec.data.sales_invoice_id;
									gridDetail.getStore().baseParams.voucherInherId = rec.data.voucher_id;
									getDetailRecordsOfSale(rec.data.sales_invoice_id);
								}
							}
						}, {
							text: 'Cancel'.translator('sale-billing'),
							handler: function(){
								formInvoiceWin.close();
							}
						}]
					});
					formInvoiceWin.show();
				}
			}
		});
		}
};

function cN(val){
	if(isEmpty(val)){
		return 0;
	}
    if (is_string(val)) {
        if (val.indexOf(thousandSeparator) > 0) {
            val = val.replaceAll(thousandSeparator, decimalSeparator);
        }
        val = formatNumber(val);
    }
    return val;
};

var getDetailRecordsOfPurchase = function(purchaseId){
    gridDetail.getStore().baseParams.purchaseInherId = purchaseId;
    Ext.Ajax.request({
        url: pathRequestUrl + '/getDetailOfPurchaseIdNotInheritance/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                baseInsertRecordsInGridDetail(result.data);
                // truong hop chon ke thua mua hang thi, phieu nhap kho phai khong hach toan
                Ext.getCmp('to_accountant').setValue(false);
                Ext.getCmp('to_accountant').disable();

                Ext.getCmp('currency_code').setValue(convertedCurrencyId);
                Ext.getCmp('currency_id').setValue(convertedCurrencyId);
                Ext.getCmp('forex_rate').setValue(render_number(1));
                Ext.getCmp('currency_code').disable();
                Ext.getCmp('currency_id').disable();
                Ext.getCmp('forex_rate').disable();

                formInvoiceWin.close();
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
            purchaseId: Ext.encode(purchaseId)
        }
    });
};

var getDetailRecordsOfSale = function(saleId){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getDetailOfSaleIdNotInheritance/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                baseInsertRecordsSaleInGridDetail(result.data);

                formInvoiceWin.close();
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
            saleId: Ext.encode(saleId)
        }
    });
};

var baseInsertRecordsInGridDetail = function(records){
    initGridDetail();
    var j = 1;
    for (var i = 0; i < records.length; i++) {
        var newRecord = new DetailRecord({
            isTotal: false,
            isChecked: true,
            isLoadedData: true,
            isInsertData: true,
            product_id: records[i].product_id,
            product_code: records[i].product_code,
            product_name: records[i].product_name,
            price: records[i].price,
            unit_id: records[i].unit_id,
            arr_unit: new Array(),
            quantity: records[i].quantity,
            amount: records[i].total_converted_amount,
            converted_amount: records[i].total_converted_amount,
            note: records[i].note
        });
        gridDetail.getStore().insert(j, newRecord);
        j++;
    }
    baseCalTotalAmmount();
    gridDetail.getView().refresh(true);

    gridDetail.getStore().baseParams.type = PURC_INHER; // loai ke thua tu hoa don mua hang
};

var baseInsertRecordsSaleInGridDetail = function(records){
    initGridDetail();
    var j = 1;
    for (var i = 0; i < records.length; i++) {
        var newRecord = new DetailRecord({
            isTotal: false,
            isChecked: true,
            isLoadedData: true,
            isInsertData: true,
            product_id: records[i].product_id,
            product_code: records[i].product_code,
            product_name: records[i].product_name,
            price: null,
            unit_id: records[i].unit_id,
            arr_unit: new Array(),
            quantity: records[i].quantity,
            amount: null,
            converted_amount: null,
            note: records[i].note
        });
        gridDetail.getStore().insert(j, newRecord);
        j++;
    }
    baseCalTotalAmmount();
    gridDetail.getView().refresh(true);

    gridDetail.getStore().baseParams.type = SALE_INHER; // loai ke thua tu hoa don mua hang
};

var baseUpdateDetailInventoryVoucher = function(record, inventoryId, recordId, field, value){
    Ext.Ajax.request({
        url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateDetailInventory/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                record.commit();
                switch (field) {
                    case 'unit_id':
                        record.data.detail_id = result.data;
                        break;
                    case 'quantity':
                    case 'price':
                        var total = baseCalculateDetail(record, record.data.quantity, record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()));
						var rec = gridInventory.getStore().getAt(selectedInventoryVoucherIndex);
						rec.data.total_inventory_amount = total;
						gridInventory.getView().refresh(true);
                        break;
                }
            }
            else {
                record.reject();
            }
        },
        failure: function(response, request){
        },
        params: {
            inventoryId: Ext.encode(inventoryId),
			batchId: Ext.encode(gridAcc.getStore().baseParams.batchId),
            recordId: Ext.encode(recordId),
            field: Ext.encode(field),
            value: Ext.encode(value),
			coefficient: Ext.encode(record.data.coefficient)
        }
    });
};

var baseInsertRecordDetail = function(r){
    var record = ({
        'product_id': r.data.product_id,
        'unit_id': r.data.unit_id,
        'quantity': !isEmpty(cN(r.data.quantity)) ? cN(r.data.quantity) : 0,
		'converted_quantity': cN(r.data.quantity) * cN(r.data.coefficient),
        'price': !isEmpty(cN(r.data.price)) ? cN(r.data.price) : 0,
        'amount': !isEmpty(cN(r.data.amount)) ? cN(r.data.amount) : 0,
        'converted_amount': !isEmpty(cN(r.data.converted_amount)) ? cN(r.data.converted_amount) : 0,
        'note': r.data.note
    });
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertRecordDetail/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                r.data.isInsertData = false;
                r.data.detail_id = result.data.product_id + '_' + result.data.unit_id;
                r.commit();
            }
            else {

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
            inventoryId: Ext.encode(Ext.getCmp('inventory_voucher_id').getValue()),
			batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
            record: Ext.encode(record)
        }
    });
};

var baseDeleteDetail = function(inventoryId, records, voucherId){
    Ext.Ajax.request({
        url: pathRequestUrl + '/deleteDetail/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                gridDetail.getStore().removeAll();
                gridDetail.getStore().load();
            }
            else {

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
            inventoryId: Ext.encode(inventoryId),
			batchId: Ext.encode(gridAcc.getStore().baseParams.batchId),
            records: Ext.encode(records),
            voucherId: Ext.encode(voucherId)
        }
    });
};
