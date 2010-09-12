var tabs;
var FormAction;
var generalTab;
var gridAccounting;
var gridInventory;

var storeCurrencyWithForexRate;
var storeSubject;
var storeDepartment;
var storeWarehouse;
var storeUnit;
var storeVoucherType;

function render_unit_name(val){

    try {
        if (val == null || val == '') 
            return '';
        return storeUnit.queryBy(function(rec){
            return rec.data.unit_id == val;
        }).itemAt(0).data.unit_name;
    } 
    catch (e) {
    }
};

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
};

var setLabelInOut = function(inout){
    var lblSubject = '';
    var lblContact = '';
    var lblDepartment = '';
    
    if ((status == "insert")) {
        // neu dang loai ke thua ma thay doi loai phieu thi xoa ke thua di
        if (!isEmpty(gridDetail.getStore().baseParams.type)) {
            initGridDetail();
            gridDetail.getStore().baseParams.type = null;
            gridDetail.getStore().baseParams.purchaseInherId = null;
        }
        
        // nhap thi co the hach toan hay khong
        if (inout == 1) {
            Ext.getCmp('to_accountant').setValue(true);
            Ext.getCmp('to_accountant').enable();
            Ext.getCmp('currency_code').setValue(null);
            Ext.getCmp('currency_id').setValue(null);
            Ext.getCmp('forex_rate').setValue("");
            Ext.getCmp('currency_code').enable();
            Ext.getCmp('currency_id').enable();
            Ext.getCmp('forex_rate').enable();
        }
        else 
            // xuat va van chuyen noi bo thi bat buoc hach toan
            if ((inout == 2) || (inout == 3)) {
                Ext.getCmp('to_accountant').setValue(true);
                Ext.getCmp('to_accountant').disable();
                
                Ext.getCmp('currency_code').setValue(convertedCurrencyId);
                Ext.getCmp('currency_id').setValue(convertedCurrencyId);
                Ext.getCmp('forex_rate').setValue(render_number(1));
                Ext.getCmp('currency_code').disable();
                Ext.getCmp('currency_id').disable();
                Ext.getCmp('forex_rate').disable();
            }
    }
    
    if (inout == 1) {
        Ext.getCmp('out_warehouse_id').setDisabled(true);
        Ext.getCmp('in_warehouse_id').setDisabled(false);
        lblSubject = 'Input Subject'.translator('stock-manage');
        lblContact = 'Input Contact'.translator('stock-manage');
        lblDepartment = 'Input Department'.translator('stock-manage');
    }
    else 
        if (inout == 2) {
            Ext.getCmp('in_warehouse_id').setDisabled(true);
            Ext.getCmp('out_warehouse_id').setDisabled(false);
            lblSubject = 'Output Subject'.translator('stock-manage');
            lblContact = 'Output Contact'.translator('stock-manage');
            lblDepartment = 'Output Department'.translator('stock-manage');
        }
        else 
            if (inout == 3) {
                Ext.getCmp('in_warehouse_id').setDisabled(false);
                Ext.getCmp('out_warehouse_id').setDisabled(false);
                lblSubject = 'Internal Subject'.translator('stock-manage');
                lblContact = 'Internal Contact'.translator('stock-manage');
                lblDepartment = 'Internal Department'.translator('stock-manage');
            }
    generalTab.findById('subject_id').label.dom.innerHTML = lblSubject;
    generalTab.findById('subject_contact').label.dom.innerHTML = lblContact;
    generalTab.findById('department_id').label.dom.innerHTML = lblDepartment;
};

function initGridDetail(){
    gridDetail.getStore().removeAll();
    var recordTotal = new DetailRecord({
        isTotal: true,
        isChecked: false,
        isLoadedData: true,
        isInsertData: false,
        quantity: "/Qty/",
        price: "/Sum/",
        amount: "/0.00/",
        converted_amount: "/0.00/"
    });
    gridDetail.getStore().insert(0, recordTotal);
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
};

function clear_form(){
    initGridDetail();
    
    Ext.getCmp('inventory_voucher_id').setValue("");
    Ext.getCmp('is_locked').setValue(0);
    Ext.getCmp('inventory_voucher_number').setValue("");
    Ext.getCmp('inventory_voucher_date').setValue((new Date()).format(date_format_string));
    Ext.getCmp('inventory_voucher_number').focus(true, 1);
    Ext.getCmp('in_out').setValue(1);
    Ext.getCmp('subject_contact').setValue("");
    Ext.getCmp('description').setValue("");
    Ext.getCmp('in_warehouse_id').setValue(null);
    Ext.getCmp('out_warehouse_id').setValue(null);
    Ext.getCmp('subject_id').setValue(null);
    Ext.getCmp('subject_code').setValue(null);
    Ext.getCmp('department_id').setValue(null);
    Ext.getCmp('department_code').setValue(null);
    Ext.getCmp('currency_code').setValue(null);
    Ext.getCmp('currency_id').setValue(null);
    Ext.getCmp('forex_rate').setValue("");
    
    Ext.getCmp('currency_code').enable();
    Ext.getCmp('currency_id').enable();
    Ext.getCmp('forex_rate').enable();
    
    Ext.getCmp('out_warehouse_id').setDisabled(true);
    Ext.getCmp('to_accountant').setValue(true);
    Ext.getCmp('to_accountant').enable();
    Ext.getCmp('btn_nheritance').enable();
    
    gridInventory.getSelectionModel().selections.clear();
    
    storeVoucherType.baseParams = {
        'typeVote': 1
    };
    storeVoucherType.load();
};


Ext.onReady(function(){
    Ext.QuickTips.init();
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    storeVoucherType = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'voucher_type_id',
            fields: ['voucher_type_id', 'voucher_type_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListVoucherType/1'
        }),
        autoLoad: false
    });
    
    storeVoucherType.on('load', function(){
        Ext.getCmp('voucher_type').setValue(Ext.getCmp('voucher_type_id').getValue());
    });
    
    storeCurrencyWithForexRate = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name', 'forex_rate', 'currency_code']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListCurrencyWithForexRate/1'
        }),
        autoLoad: false
    });
    
    storeCurrencyWithForexRate.on('beforeload', function(){
        if (Ext.getCmp('currency_code').hasFocus) {
            storeCurrencyWithForexRate.baseParams.type = 'code';
        }
        else {
            storeCurrencyWithForexRate.baseParams.type = 'name';
        }
        storeCurrencyWithForexRate.baseParams.convertCurrency = convertedCurrencyId;
    });
    
    storeSubject = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id',
            fields: ['subject_id', 'subject_code', 'subject_name', 'subject_contact_person']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListSubject/1'
        }),
        autoLoad: true
    });
    
    storeSubject.on('beforeload', function(){
        if (Ext.getCmp('subject_code').hasFocus) {
            storeSubject.baseParams.type = 'code';
            storeSubject.baseParams.typeSubject = Ext.getCmp('in_out').getValue().inputValue;
        }
        else 
            if (Ext.getCmp('subject_id').hasFocus) {
                storeSubject.baseParams.type = 'name';
                storeSubject.baseParams.typeSubject = Ext.getCmp('in_out').getValue().inputValue;
            }
            else {
                storeSubject.baseParams.typeSubject = 3;
            }
        
        storeSubject.baseParams.start = 0;
        storeSubject.baseParams.limit = 50;
    });
    
    storeSubject.on('load', function(){
        generalTab.doLayout();
    });
    
    storeDepartment = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'department_id',
            fields: ['department_id', 'department_code', 'department_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getListDepartment/1'
        }),
        autoLoad: true
    });
    
    storeDepartment.on('beforeload', function(){
        if (Ext.getCmp('department_code').hasFocus) {
            storeDepartment.baseParams.type = 'code';
        }
        else {
            storeDepartment.baseParams.type = 'name';
        }
        storeDepartment.baseParams.start = 0;
        storeDepartment.baseParams.limit = 50;
    });
    
    storeWarehouse = new Ext.data.ArrayStore({
        fields: [{
            name: 'warehouse_id',
            type: 'string'
        }, {
            name: 'warehouse_name',
            type: 'string'
        }]
    });
    
    storeUnit = new Ext.data.ArrayStore({
        fields: [{
            name: 'unit_id',
            type: 'string'
        }, {
            name: 'unit_name',
            type: 'string'
        }]
    });
    
    var resultTplSubjectCode = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{subject_code} | {subject_name}</span><br />', '</div></tpl>');
    
    var resultTplCurrency = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{currency_code} | {currency_name}</span><br />', '</div></tpl>');
    
    var resultTplDepartment = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{department_code} | {department_name}</span><br />', '</div></tpl>');
    
    generalTab = new Ext.Panel({
        frame: true,
        title: '',
        id: 'generalTab',
        items: [{
            layout: 'column',
            items: [{
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [{
                    xtype: 'hidden',
                    id: 'inventory_voucher_id'
                }, {
                    xtype: 'hidden',
                    id: 'voucher_type_id'
                }, {
                    xtype: 'hidden',
                    id: 'is_inheritanced'
                }, {
                    xtype: 'hidden',
                    id: 'is_locked'
                }, {
                    xtype: 'hidden',
                    id: 'format_number_voucher'
                }, {
                    xtype: 'radiogroup',
                    fieldLabel: 'Type Vote'.translator('stock-manage'),
                    id: 'in_out',
                    items: [{
                        boxLabel: 'Input'.translator('stock-manage'),
                        name: 'rb-auto',
                        width: 100,
                        inputValue: 1
                    }, {
                        boxLabel: 'Output'.translator('stock-manage'),
                        name: 'rb-auto',
                        inputValue: 2
                    }, {
                        boxLabel: 'Internal transport'.translator('stock-manage'),
                        name: 'rb-auto',
                        inputValue: 3
                    }],
                    listeners: {
                        change: function(e){
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'voucher_type',
                    store: storeVoucherType,
                    displayField: 'voucher_type_name',
                    valueField: 'voucher_type_id',
                    emptyText: 'Chọn loại chứng từ',
                    typeAhead: true,
                    triggerAction: 'all',
                    lazyRender: true,
                    selectOnFocus: true,
                    editable: true,
                    mode: 'local',
                    allowBlank: false,
                    lazyRender: true,
                    fieldLabel: 'Chứng từ',
                    forceSelection: true,
                    width: 250,
                    listWidth: 350,
                    listeners: {
                        select: function(combo, record, index){
                            baseGetAutoNumber(combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'inventory_voucher_number',
                    fieldLabel: 'Inventory Voucher Number'.translator('stock-manage'),
                    width: 150,
                    allowBlank: false,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                        
                            if (e.getValue().search(Ext.getCmp('format_number_voucher').getValue()) == -1) {
                                warning('Warning'.translator('buy-billing'), 'Không thể thay đổi phần định dạnh phiếu');
                                baseGetAutoNumber(Ext.getCmp('voucher_type').getValue());
                            }
                            //baseUpdatePurchaseInventory(e.getId(), e.getValue());
                        }
                    }
                },                /*{
                 xtype: 'spinnerfield',
                 name: 'auto_incre',
                 width: 100,
                 length: 4,
                 minValue: 0,
                 allowDecimals: false,
                 incrementValue: 1,
                 accelerate: true
                 },*/
                {
                    xtype: 'datefield',
                    width: 100,
                    labelSeparator: '',
                    id: 'inventory_voucher_date',
                    fieldLabel: 'Inventory Voucher Date'.translator('stock-manage'),
                    format: date_format_string,
                    selectOnFocus: true,
                    allowBlank: false,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInventory(e.getId(), e.getValue());
                        }
                    }
                }, new Ext.form.ComboBox({
                    store: storeWarehouse,
                    fieldLabel: 'Input Warehouse'.translator('stock-manage'),
                    id: 'in_warehouse_id',
                    forceSelection: true,
                    displayField: 'warehouse_name',
                    valueField: 'warehouse_id',
                    listWidth: 300,
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select input warehouse'.translator('stock-manage'),
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdatePurchaseInventory(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                }), new Ext.form.ComboBox({
                    store: storeWarehouse,
                    fieldLabel: 'Output Warehouse'.translator('stock-manage'),
                    id: 'out_warehouse_id',
                    forceSelection: true,
                    displayField: 'warehouse_name',
                    valueField: 'warehouse_id',
                    listWidth: 300,
                    typeAhead: true,
                    mode: 'local',
                    triggerAction: 'all',
                    emptyText: 'Select output warehouse'.translator('stock-manage'),
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    lazyRender: true,
                    selectOnFocus: true,
                    listeners: {
                        select: function(combo, record, index){
                            baseUpdatePurchaseInventory(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'currency_code',
                    store: storeCurrencyWithForexRate,
                    fieldLabel: 'Currency Code'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_code',
                    valueField: 'currency_id',
                    typeAhead: false,
                    tpl: resultTplCurrency,
                    triggerAction: 'all',
                    emptyText: 'Select code a currency'.translator('buy-billing'),
                    selectOnFocus: true,
                    editable: true,
                    itemSelector: 'div.search-item',
                    width: 150,
                    minChars: 1,
                    pageSize: 50,
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 300,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                var objectCurrency = storeCurrencyWithForexRate.queryBy(function(rec){
                                    return rec.data.currency_id == combo.value;
                                });
                                Ext.getCmp('currency_id').setValue(combo.value);
                                Ext.getCmp('forex_rate').setValue(render_number(objectCurrency.itemAt(0).data.forex_rate));
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                                return;
                            }
                            baseUpdatePurchaseInventory('currency_id', combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'currency_id',
                    store: storeCurrencyWithForexRate,
                    fieldLabel: 'Currency Type'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'currency_name',
                    valueField: 'currency_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    tpl: resultTplCurrency,
                    emptyText: 'Select a currency'.translator('buy-billing'),
                    selectOnFocus: true,
                    editable: true,
                    pageSize: 50,
                    minChars: 1,
                    width: 150,
                    itemSelector: 'div.search-item',
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 300,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                var objectCurrency = storeCurrencyWithForexRate.queryBy(function(rec){
                                    return rec.data.currency_id == combo.value;
                                });
                                Ext.getCmp('currency_code').setValue(combo.value);
                                Ext.getCmp('forex_rate').setValue(render_number(objectCurrency.itemAt(0).data.forex_rate));
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                                return;
                            }
                            baseUpdatePurchaseInventory(combo.getId(), combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'forex_rate',
                    fieldLabel: 'Forex Rate'.translator('buy-billing'),
                    width: 100,
                    allowBlank: false,
                    enableKeyEvents: true,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            if (status == "insert") {
                                baseChangeForexrate(formatNumber(e.getValue()));
                                return;
                            }
                            baseUpdatePurchaseInventory(e.getId(), e.getValue());
                        },
                        keypress: function(my, e){
                            if (!forceNumber(e)) 
                                e.stopEvent();
                        }
                    }
                }]
            }, {
                columnWidth: .5,
                layout: 'form',
                labelWidth: 170,
                items: [new Ext.form.ComboBox({
                    id: 'subject_code',
                    store: storeSubject,
                    fieldLabel: 'Inventory Subject Code'.translator('stock-manage'),
                    forceSelection: true,
                    displayField: 'subject_code',
                    valueField: 'subject_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    emptyText: 'Select code subject'.translator('stock-manage'),
                    tpl: resultTplSubjectCode,
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    pageSize: 50,
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 350,
                    itemSelector: 'div.search-item',
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('subject_id').setValue(combo.value);
                                Ext.getCmp('subject_contact').setValue(record.data.subject_contact_person);
                                return;
                            }
                            baseUpdatePurchaseInventory(combo.getId(), combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'subject_id',
                    store: storeSubject,
                    fieldLabel: 'Inventory Subject'.translator('stock-manage'),
                    forceSelection: true,
                    displayField: 'subject_name',
                    valueField: 'subject_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    pageSize: 50,
                    emptyText: 'Select a subject'.translator('stock-manage'),
                    tpl: resultTplSubjectCode,
                    selectOnFocus: true,
                    editable: true,
                    width: 300,
                    lazyRender: true,
                    listWidth: 350,
                    itemSelector: 'div.search-item',
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('subject_code').setValue(combo.value);
                                Ext.getCmp('subject_contact').setValue(record.data.subject_contact_person);
                                return;
                            }
                            baseUpdatePurchaseInventory(combo.getId(), combo.value);
                        }
                    }
                }), {
                    xtype: 'textfield',
                    id: 'subject_contact',
                    fieldLabel: 'Contact Subject'.translator('stock-manage'),
                    width: 300,
                    selectOnFocus: true,
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInventory(e.getId(), e.getValue());
                        }
                    }
                }, new Ext.form.ComboBox({
                    id: 'department_code',
                    store: storeDepartment,
                    fieldLabel: 'Inventory Department Code'.translator('stock-manage'),
                    forceSelection: true,
                    displayField: 'department_code',
                    valueField: 'department_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    emptyText: 'Select code subject'.translator('stock-manage'),
                    tpl: resultTplDepartment,
                    selectOnFocus: true,
                    editable: true,
                    width: 150,
                    pageSize: 50,
                    lazyRender: true,
                    selectOnFocus: true,
                    listWidth: 350,
                    itemSelector: 'div.search-item',
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('department_id').setValue(combo.value);
                                return;
                            }
                            baseUpdatePurchaseInventory('department_id', combo.value);
                        }
                    }
                }), new Ext.form.ComboBox({
                    id: 'department_id',
                    store: storeDepartment,
                    fieldLabel: 'Inventory Department'.translator('buy-billing'),
                    forceSelection: true,
                    displayField: 'department_name',
                    valueField: 'department_id',
                    typeAhead: false,
                    triggerAction: 'all',
                    pageSize: 50,
                    emptyText: 'Select a department'.translator('buy-billing'),
                    tpl: resultTplDepartment,
                    selectOnFocus: true,
                    editable: true,
                    width: 300,
                    lazyRender: true,
                    listWidth: 350,
                    itemSelector: 'div.search-item',
                    minChars: 1,
                    listeners: {
                        select: function(combo, record, index){
                            if (status == "insert") {
                                Ext.getCmp('department_code').setValue(combo.value);
                                return;
                            }
                            baseUpdatePurchaseInventory(combo.getId(), combo.value);
                        },
                        change: function(e){
                        }
                    }
                }), {
                    xtype: 'textarea',
                    width: 300,
                    height: 50,
                    id: 'description',
                    selectOnFocus: true,
                    fieldLabel: 'Description'.translator('stock-manage'),
                    listeners: {
                        change: function(e){
                            baseUpdatePurchaseInventory(e.getId(), e.getValue());
                        }
                    }
                }, {
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Accounting'.translator('buy-billing'),
                    labelSeparator: ':',
                    boxLabel: '',
                    id: 'to_accountant',
                    listeners: {
                        change: function(e){
                            if (status == "insert") {
                                if (e.getValue()) {
                                    gridDetail.getStore().baseParams.type = null;
                                    gridDetail.getStore().baseParams.purchaseInherId = null;
                                }
                                return;
                            }
                            baseUpdatePurchaseInventory(e.getId(), e.getValue());
                        }
                    }
                }]
            }]
        }, gridDetail]
    });
    
    FormAction = {
        checkExistedProduct: function(productId, unitId){
            var c = -1;
            for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                var rec = gridDetail.getStore().getAt(i);
                if ((rec.data.product_id == productId) &&
                (rec.data.unit_id == unitId) &&
                rec.data.isChecked) {
                    c++;
                }
            }
            return c;
        },
        addNew: function(){
            clear_form();
            
            status = 'insert';
            Ext.getCmp('in_out').enable();
            Ext.getCmp('voucher_type').enable();
            Ext.getCmp('inventory_voucher_number').enable();
            
            Ext.getCmp('btn_save').enable();
            Ext.getCmp('btn_delete').disable();
            Ext.getCmp('reload_detail').disable();
            Ext.getCmp('inventoryInfo').setTitle("General Information".translator('buy-billing'));
            
            gridDetail.getStore().baseParams = {
                'inventoryVoucherId': null,
                'voucherId': null,
                'batchId': null,
                'type': null, // phieu nhap thuoc loai ke thua hay khong,
                'purchaseInherId': null, // mang purchase id da ke thua
                'voucherInherId': null // luu voucher id cua hoa don ban hang. Phieu xuat kho ke thua
            };
        },
        saveNew: function(){
            if ((status == 'insert') && stockManageTable.getForm().isValid()) {
                var detail = new Array();
                for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
                    var r = gridDetail.getStore().getAt(i);
                    if (r.data.isChecked) {
                        if (FormAction.checkExistedProduct(r.data.product_id, r.data.unit_id) > 0) {
                            msg('Error'.translator('buy-billing'), 'trung san pham', Ext.MessageBox.ERROR);
                            return;
                        }
                        
                        var record = ({
                            'product_id': r.data.product_id,
                            'unit_id': r.data.unit_id,
                            'quantity': cN(r.data.quantity),
                            'converted_quantity': cN(r.data.quantity) * cN(r.data.coefficient),
                            'price': cN(r.data.price),
                            'amount': cN(r.data.amount),
                            'converted_amount': cN(r.data.converted_amount),
                            'note': r.data.note
                        });
                        detail.push(record);
                    }
                }
                insertRecordInventory(Ext.getCmp('inventory_voucher_number').getValue(), Ext.getCmp('voucher_type').getValue(), Ext.getCmp('inventory_voucher_date').getValue(), Ext.getCmp('in_out').getValue().inputValue, Ext.getCmp('in_warehouse_id').getValue(), Ext.getCmp('out_warehouse_id').getValue(), Ext.getCmp('currency_id').getValue(), Ext.getCmp('forex_rate').getValue(), Ext.getCmp('subject_id').getValue(), Ext.getCmp('subject_contact').getValue(), Ext.getCmp('department_id').getValue(), Ext.getCmp('to_accountant').getValue(), Ext.getCmp('description').getValue(), gridDetail.getStore().baseParams.type, gridDetail.getStore().baseParams.purchaseInherId, gridDetail.getStore().baseParams.voucherInherId, Ext.getCmp('format_number_voucher').getValue(), detail);
            }
            else {
                msg('Error'.translator('buy-billing'), 'Check error form'.translator('buy-billing'), Ext.MessageBox.ERROR);
            }
        },
        deleteInventory: function(){
            if ((status == 'update') && !isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
                var arrRecord = new Array({
                    inventory_voucher_id: Ext.getCmp('inventory_voucher_id').getValue(),
                    batch_id: gridDetail.getStore().baseParams.batchId,
                    is_inheritanced: Ext.getCmp('is_inheritanced').getValue()
                });
                var record = gridInventory.getStore().getAt(selectedInventoryVoucherIndex);
                gridInventory.getStore().remove(record);
                baseDeleteInventory(arrRecord);
                FormAction.addNew();
                gridInventory.getSelectionModel().selections.clear();
            }
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
            title: "General Information".translator('stock-manage'),
            id: 'inventoryInfo',
            items: [generalTab],
            buttons: [{
                id: 'btn_new',
                text: 'Action New'.translator('sale-billing'),
                handler: FormAction.addNew
            }, {
                'id': 'btn_save',
                'text': 'Action Save'.translator('sale-billing'),
                handler: FormAction.saveNew
            }, {
                'id': 'btn_delete',
                'text': 'Action Delete'.translator('sale-billing'),
                handler: FormAction.deleteInventory
            }]
        }, {
            title: "Accounting information".translator('stock-manage'),
            id: 'accountInfo',
            items: [gridAcc]
        }, {
            title: "List Inventory Voucher".translator('stock-manage'),
            id: 'listInventory',
            items: [gridInventory]
        }]
    });
    
    FormAction.addNew();
});


var baseGetAutoNumber = function(voucherTypeId){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getAutoNumberOfVoucherType/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                Ext.getCmp('inventory_voucher_number').setValue(result.data['strNumber']);
                Ext.getCmp('format_number_voucher').setValue(result.data['strFormat']);
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
            voucherTypeId: Ext.encode(voucherTypeId)
        }
    });
};

var insertRecordInventory = function(inventoryNumber, voucherType, inventoryDate, inOut, inWarehouseId, outWarehouseId, currencyId, forexRate, subId, subContact, depId, toAcc, desc, type, purchaseInherId, voucherInherId, formatNumberVoucher, detail){
    var lastInventoryDate = inventoryDate;
    inventoryDate = inventoryDate.dateFormat(date_sql_format_string);
    forexRate = formatNumber(forexRate);
    
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertInventoryVoucher/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                if (!isEmpty(result.data.msgErrorExisted) && result.data.msgErrorExisted) {
                    warning('Warning'.translator('buy-billing'), 'Số phiếu đã tồn tại. Vui lòng chọn số phiếu khác.');
                    return;
                }
                
                Ext.getCmp('inventoryInfo').setTitle("General Information".translator('stock-manage') + " - " + result.data.inventory_voucher_number);
                var inventoryNewRecord = new inventoryObject({
                    'inventory_voucher_id': result.data.inventory_voucher_id,
                    'voucher_type_id': result.data.voucher_type_id,
                    'inventory_voucher_number': result.data.inventory_voucher_number,
                    'inventory_voucher_date_format': lastInventoryDate,
                    'in_out': result.data.in_out,
                    'subject_id': result.data.subject_id,
                    'subject_contact': result.data.subject_contact,
                    'department_id': result.data.department_id,
                    'currency_id': result.data.currency_id,
                    'forex_rate': result.data.forex_rate,
                    'in_warehouse_id': result.data.in_warehouse_id,
                    'out_warehouse_id': result.data.out_warehouse_id,
                    'total_inventory_amount': result.data.total_inventory_amount,
                    'description': result.data.description,
                    'period_id': result.data.period_id,
                    'voucher_id': result.data.voucher_id
                });
                gridInventory.getStore().insert(gridInventory.getStore().getCount(), inventoryNewRecord);
                FormAction.addNew();
                
                Ext.getCmp('in_out').setValue(result.data.in_out);
                Ext.getCmp('voucher_type_id').setValue(result.data.voucher_type_id);
                baseGetAutoNumber(result.data.voucher_type_id);
                
                
                msg('Info'.translator('buy-billing'), 'Phiếu hàng tồn kho đã tạo.', Ext.MessageBox.INFO);
                //gridInventory.getView().refresh(true);
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
            record.reject();
        },
        params: {
            inventoryNumber: Ext.encode(inventoryNumber),
            voucherType: Ext.encode(voucherType),
            inventoryDate: Ext.encode(inventoryDate),
            inOut: Ext.encode(inOut),
            inWarehouseId: Ext.encode(inWarehouseId),
            outWarehouseId: Ext.encode(outWarehouseId),
            currencyId: Ext.encode(currencyId),
            forexrate: Ext.encode(forexRate),
            subId: Ext.encode(subId),
            subContact: Ext.encode(subContact),
            depId: Ext.encode(depId),
            toAcc: Ext.encode(toAcc),
            desc: Ext.encode(desc),
            type: Ext.encode(type),
            purchaseInherId: Ext.encode(purchaseInherId),
            voucherInherId: Ext.encode(voucherInherId),
            formatNumberVoucher: Ext.encode(formatNumberVoucher),
            detail: Ext.encode(detail)
        }
    });
};

var baseUpdatePurchaseInventory = function(field, value){
    if ((status == 'update') && !isEmpty(Ext.getCmp('inventory_voucher_id').getValue())) {
        var record = gridInventory.getStore().getAt(selectedInventoryVoucherIndex);
        if (currentPeriodId == record.data.period_id) {
            var isLocked = (record.data.is_locked == 1) ? true : false;
            if (!isLocked) {
                var lastInventoryDate;
                if (field == 'inventory_voucher_date') {
                    lastInventoryDate = value;
                    value = value.dateFormat(date_sql_format_string);
                }
                if (field == 'forex_rate') {
                    if (value < 0) {
                        Ext.getCmp('forex_rate').setValue(forexRate);
                        msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                        return;
                    }
                    else {
                        forexRate = Ext.getCmp('forex_rate').getValue();
                        value = formatNumber(value);
                    }
                }
                
                Ext.Ajax.request({
                    url: pathRequestUrl + '/updateInventory/' +
                    Ext.getCmp('inventory_voucher_id').getValue(),
                    method: 'post',
                    success: function(result, options){
                        var result = Ext.decode(result.responseText);
                        if (result.success) {
                            switch (field) {
                                case 'inventory_voucher_number':
                                    record.data.inventory_voucher_number = result.data.inventory_voucher_number;
                                    Ext.getCmp('inventoryInfo').setTitle("thong tin phieu" + " - " + result.data.inventory_voucher_number);
                                    break;
                                case 'inventory_voucher_date':
                                    record.data.inventory_voucher_date_format = lastInventoryDate;
                                    break;
                                case 'subject_code':
                                case 'subject_id':
                                    Ext.getCmp('subject_contact').setValue(result.data.subject_contact);
                                    Ext.getCmp('subject_code').setValue(result.data.subject_id);
                                    Ext.getCmp('subject_id').setValue(result.data.subject_id);
                                    record.data.subject_id = result.data.subject_id;
                                    record.data.subject_contact = result.data.subject_contact;
                                    break;
                                case 'department_code':
                                case 'department_id':
                                    Ext.getCmp('department_id').setValue(result.data.department_id);
                                    Ext.getCmp('department_code').setValue(result.data.department_id);
                                    record.data.department_id = result.data.department_id;
                                    break;
                                case 'subject_contact':
                                    record.data.supplier_contact = value;
                                    break;
                                case 'description':
                                    record.data.description = value;
                                    break;
                                case 'currency_id':
                                    record.data.currency_id = value;
                                    break;
                            }
                            
                            if (field == 'forex_rate') {
                                if (result.data.change_currency) {
                                    record.data.total_inventory_amount = result.data.total_inventory_amount;
                                }
                                else {
                                    warning('Warning'.translator('buy-billing'), 'Currency Type'.translator('buy-billing') + ' \'' + $('#currency_id').val() + 'Not forexrate'.translator('buy-billing'));
                                }
                                Ext.getCmp('currency_id').setValue(result.data.currency_id);
                                Ext.getCmp('currency_code').setValue(result.data.currency_id);
                                Ext.getCmp('forex_rate').setValue(number_format_extra(result.data.forex_rate, decimals, decimalSeparator, thousandSeparator));
                                record.data.currency_id = result.data.currency_id;
                                record.data.forex_rate = result.data.forex_rate;
                                
                                baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
                            }
                            gridInventory.getView().refresh(true);
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
                        batchId: Ext.encode(gridAcc.getStore().baseParams.batchId),
                        convertCurrency: Ext.encode(convertedCurrencyId),
                        field: Ext.encode(field),
                        value: Ext.encode(value)
                    }
                });
            }
            else {
                warning('Warning'.translator('buy-billing'), 'Phiếu định khoản hàng tồn kho đã khóa.');
            }
        }
        else {
            warning('Warning'.translator('buy-billing'), 'Phiếu hàng tồn kho không thuộc kế toán hiện hành.');
        }
    }
};
