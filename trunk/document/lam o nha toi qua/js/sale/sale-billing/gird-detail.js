var comboUnitOption;
var comboVatOption;
var comboSpecificityOption;
var comboExportOption;
var comboExciseOption;

var DetailRecord;
var Detail; // actions;
var formInventoryWin;

Ext.onReady(function(){
    Ext.QuickTips.init();
    //Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
    DetailRecord = Ext.data.Record.create(['product_id']);
    
    var storeListServiceName = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getSearchServiceByName/1'
        }),
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'service_id'
        }, [{
            name: 'service_id',
            type: 'string'
        }, {
            name: 'service_code',
            type: 'string'
        }, {
            name: 'service_name',
            type: 'string'
        }, {
            name: 'unit_id',
            type: 'string'
        }, {
            name: 'unit_name',
            type: 'string'
        }])
    });
    
    var storeListServiceCode = new Ext.data.Store({
        proxy: new Ext.data.HttpProxy({
            url: pathRequestUrl + '/getSearchServiceByCode/1'
        }),
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'service_id'
        }, [{
            name: 'service_id',
            type: 'string'
        }, {
            name: 'service_code',
            type: 'string'
        }, {
            name: 'service_name',
            type: 'string'
        }, {
            name: 'unit_id',
            type: 'string'
        }, {
            name: 'unit_name',
            type: 'string'
        }])
    });
    
    var resultTplService = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{service_code} | {service_name}</span><br />', '</div></tpl>');
    
    resultTplAccount = new Ext.XTemplate('<tpl for="."><div class="search-item"><div style="float:left; width:40px;">{account_code}</div><div style="float:left; text-align:left;">| </div><div>{account_name}</div></div></tpl>');
    
    var comboListServiceCode = new Ext.form.ComboBox({
        id: 'comboListServiceCode',
        store: storeListServiceCode,
        valueField: 'service_id',
        typeAhead: false,
        width: 570,
        pageSize: 50,
        triggerAction: 'all',
        tpl: resultTplService,
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
            rec.data.service_name = record.data.service_name;
            rec.data.service_code = record.data.service_code;
            rec.data.service_id = record.data.service_id;
            rec.data.unit_id = record.data.unit_id;
            
            rec.data.arr_unit = new Array();
            var recordUnit = new Array();
            recordUnit['unit_id'] = record.data.unit_id;
            recordUnit['unit_name'] = record.data.unit_name;
            recordUnit['default_sales_price'] = number_format_extra(0, decimals, decimalSeparator, thousandSeparator);
            rec.data.arr_unit.push(recordUnit);
            rec.data.isChecked = true;
            rec.data.isLoadedData = true;
            Detail.add(index + 1, 1);
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
    
    var comboListServiceName = new Ext.form.ComboBox({
        id: 'comboListServiceName',
        store: storeListServiceName,
        valueField: 'service_id',
        typeAhead: false,
        width: 570,
        pageSize: 50,
        triggerAction: 'all',
        tpl: resultTplService,
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
            rec.data.service_name = record.data.service_name;
            rec.data.service_code = record.data.service_code;
            rec.data.service_id = record.data.service_id;
            rec.data.unit_id = record.data.unit_id;
            
            rec.data.arr_unit = new Array();
            var recordUnit = new Array();
            recordUnit['unit_id'] = record.data.unit_id;
            recordUnit['unit_name'] = record.data.unit_name;
            recordUnit['default_sales_price'] = number_format_extra(0, decimals, decimalSeparator, thousandSeparator);
            rec.data.arr_unit.push(recordUnit);
            
            rec.data.isChecked = true;
            rec.data.isLoadedData = true;
            Detail.add(index + 1, 2);
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
    
    function render_export_rate(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeImportRate.queryBy(function(rec){
                return rec.data.tax_rate_id == val;
            }).itemAt(0).data.rate;
        } 
        catch (e) {
        }
    };
    
    var storeImportOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id'
        }, {
            name: 'specification_name'
        }, {
            name: 'rate'
        }]
    });
    
    comboExportOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeImportOption,
        valueField: 'tax_rate_id',
        displayField: 'rate',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:15px;">{rate}</div><div style="float:left; text-align:left;">|</div><div>{specification_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: true,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 400,
        enableKeyEvents: true,
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(11);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    });
    
    function render_excise_rate(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeExciseRate.queryBy(function(rec){
                return rec.data.tax_rate_id == val;
            }).itemAt(0).data.rate;
        } 
        catch (e) {
        }
    }
    
    var storeExciseOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id'
        }, {
            name: 'specification_name'
        }, {
            name: 'rate'
        }]
    });
    
    comboExciseOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeExciseOption,
        valueField: 'tax_rate_id',
        displayField: 'rate',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:15px;">{rate}</div><div style="float:left; text-align:left;">|</div><div>{specification_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: true,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 400,
        enableKeyEvents: true,
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(13);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    });
    
    function render_vat_rate(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeVatRate.queryBy(function(rec){
                return rec.data.tax_rate_id == val;
            }).itemAt(0).data.rate;
        } 
        catch (e) {
        }
    };
    
    var storeVatOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'tax_rate_id'
        }, {
            name: 'specification_name'
        }, {
            name: 'rate'
        }]
    });
    
    comboVatOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeVatOption,
        valueField: 'tax_rate_id',
        displayField: 'rate',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:15px;">{rate}</div><div style="float:left; text-align:left;">|</div><div>{specification_name}</div></div></tpl>',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: true,
        width: 290,
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listWidth: 400,
        enableKeyEvents: true,
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(15);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    });
    
    var storeUnitOption = new Ext.data.ArrayStore({
        fields: [{
            name: 'unit_id'
        }, {
            name: 'unit_name'
        }, {
            name: 'default_sales_price'
        }, {
            name: 'coefficient'
        }]
    });
    
    comboUnitOption = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeUnitOption,
        valueField: 'unit_id',
        displayField: 'unit_name',
        tpl: '<tpl for="."><div class="x-combo-list-item"><div style="float:left; width:100px;">{unit_name}</div><div style="float:left; text-align:left;">|</div><div>{default_sales_price}</div></div></tpl>',
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
                        baseNextStartingEdit(6);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    });
    
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
                service_id: null,
                service_code: null,
                service_name: null,
                price: null,
                unit_id: null,
                arr_unit: new Array(),
                quantity: null,
                coefficient: null,
                amount: null,
                converted_amount: null,
                export_rate_id: null,
                export_rate: 0,
                arr_export: new Array(),
                export_amount: null,
                excise_rate_id: null,
                excise_rate: 0,
                arr_excise: new Array(),
                excise_amount: null,
                vat_rate_id: null,
                vat_rate: 0,
                arr_vat: new Array(),
                vat_amount: null,
                total_amount: null,
                note: ''
            });
            
            gridDetail.getView().refresh(true);
            var rec = gridDetail.getStore().getAt(gridDetail.getStore().getCount() - 1);
            if (rec.data.isChecked) {
            
                gridDetail.getStore().insert(gridDetail.getStore().getCount(), newRecord);
                
                if (Ext.getCmp('for_service').getValue()) {
                    // bat dau edit tai ma dich vu cua dong moi
                    gridDetail.startEditing(gridDetail.getStore().getCount() - 1, 1);
                }
                else {
                    // bat dau edit tai ma san pham cua dong moi
                    gridDetail.startEditing(gridDetail.getStore().getCount() - 1, 3);
                }
                
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
                if ((status == 'insert') && isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].data.isChecked) {
                            gridDetail.getStore().remove(records[i]);
                        }
                    }
                    baseCalTotalAmmount();
                    gridDetail.getSelectionModel().selectRow(gridDetail.getStore().getCount() - 1);
                    gridDetail.getView().refresh(true);
                    if (gridDetail.getStore().getCount() == 2) {
                        gridDetail.getStore().baseParams.type = false; // neu xoa het thi chuyen sang dang khong ke thua
                    }
                }
                else {
                    // trang thai insert record
                    var arrRecord = new Array();
                    for (var i = 0; i < records.length; i++) {
                        if (records[i].data.isChecked) {
                            var record = {
                                product_id: records[i].data.product_id,
                                service_id: records[i].data.service_id,
                                unit_id: records[i].data.unit_id
                            };
                            arrRecord.push(record);
                        }
                    }
                    if (arrRecord.length > 0) {
                        baseDeleteDetail(gridDetail.getStore().baseParams.salesInvoiceId, arrRecord, gridDetail.getStore().baseParams.batchId);
                    }
                }
            }
        }
    };
    
    var detailRecord = [{
        name: 'detail_id',
        type: 'string'
    }, {
        name: 'sales_invoice_id',
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
        name: 'service_id',
        type: 'string'
    }, {
        name: 'service_code',
        type: 'string'
    }, {
        name: 'service_name',
        type: 'string'
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
        name: 'vat_rate_id',
        type: 'string'
    }, {
        name: 'vat_rate',
        type: 'string'
    }, {
        name: 'vat_amount',
        type: 'string'
    }, {
        name: 'arr_vat',
        type: 'array'
    }, {
        name: 'export_rate_id',
        type: 'string'
    }, {
        name: 'export_rate',
        type: 'string'
    }, {
        name: 'export_amount',
        type: 'string'
    }, {
        name: 'arr_export',
        type: 'array'
    }, {
        name: 'excise_rate_id',
        type: 'string'
    }, {
        name: 'excise_rate',
        type: 'string'
    }, {
        name: 'excise_amount',
        type: 'string'
    }, {
        name: 'arr_excise',
        type: 'array'
    }, {
        name: 'total_amount',
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
            url: pathRequestUrl + '/getDetailSaleInvoiceById/1'
        }),
        autoLoad: false
    });
    
    storeDetail.on('load', function(){
        if (!isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
            var recordTotal = new DetailRecord({
                isTotal: true,
                isChecked: false,
                isLoadedData: false,
                isInsertData: false,
                quantity: "/Qty/",
                price: "/Sum/",
                amount: "/0.00/",
                converted_amount: "/0.00/",
                export_amount: "/0.00/",
                excise_amount: "/0.00/",
                vat_amount: "/0.00/",
                total_amount: "/0.00/"
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
                service_id: null,
                service_code: null,
                service_name: null,
                price: null,
                unit_id: null,
                arr_unit: new Array(),
                quantity: null,
                coefficient: null,
                amount: null,
                converted_amount: null,
                export_rate_id: null,
                export_rate: 0,
                arr_export: new Array(),
                export_amount: null,
                export_rate_id: null,
                export_rate: 0,
                arr_export: new Array(),
                export_amount: null,
                vat_rate_id: null,
                vat_rate: 0,
                arr_vat: new Array(),
                vat_amount: null,
                total_amount: null,
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
            name: 'default_sales_price',
            type: 'string'
        }, {
            name: 'regular_unit_id',
            type: 'string'
        }, {
            name: 'coefficient',
            type: 'string'
        }])
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
    
    var searchProductName = new Ext.form.ComboBox({
        id: 'searchProductName',
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
            if ((status == 'insert') && isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
                rec.data.unit_id = record.data.regular_unit_id;
                rec.data.coefficient = record.data.coefficient;
                rec.data.price = parseFloat(record.data.default_sales_price);
            }
            else {
                rec.data.unit_id = null;
                rec.data.price = null;
                rec.data.quantity = null;
                rec.data.coefficient = null;
                rec.data.amount = null;
                rec.data.converted_amount = null;
                rec.data.export_rate_id = null;
                rec.data.export_rate = 0;
                rec.data.export_amount = null;
                rec.data.arr_export = new Array();
                rec.data.excise_rate_id = null;
                rec.data.excise_rate = 0;
                rec.data.arr_excise = new Array();
                rec.data.excise_amount = null;
                rec.data.vat_rate_id = null;
                rec.data.vat_rate = 0;
                rec.data.arr_vat = new Array();
                rec.data.vat_amount = null;
                rec.data.arr_vat = new Array();
                rec.data.total_amount = null;
            }
            rec.data.isChecked = true;
            rec.data.isLoadedData = true;
            //baseGetTaxOfProduct(record.data.product_id, index);
            baseGetUnitOfProduct(record.data.product_id, index, index + 1, 4);
            //baseCalculateDetail(rec, rec.data.quantity, rec.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), rec.data.export_rate, rec.data.excise_rate, rec.data.vat_rate);
        },
        listeners: {
            // Hook into the keypress event to detect if the user pressed the ENTER key
            keypress: function(comboBox, e){
                if (e.getCharCode() == 38) {
                    if (!this.isExpanded()) {
                        baseNextStartingEdit(4);
                    }
                    else {
                        this.selectPrev();
                    }
                }
            }
        }
    
    });
    
    var searchProductCode = new Ext.form.ComboBox({
        id: 'searchProductCode',
        store: dsCode,
        //displayField: 'product_code',
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
            if ((status == 'insert') && isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
                rec.data.unit_id = record.data.regular_unit_id;
                rec.data.coefficient = record.data.coefficient;
                rec.data.price = parseFloat(record.data.default_sales_price);
            }
            else {
                rec.data.unit_id = null;
                rec.data.price = null;
                rec.data.quantity = null;
                rec.data.coefficient = null;
                rec.data.amount = null;
                rec.data.converted_amount = null;
                rec.data.export_rate_id = null;
                rec.data.export_rate = 0;
                rec.data.export_amount = null;
                rec.data.arr_export = new Array();
                rec.data.excise_rate_id = null;
                rec.data.excise_rate = 0;
                rec.data.arr_excise = new Array();
                rec.data.excise_amount = null;
                rec.data.vat_rate_id = null;
                rec.data.vat_rate = 0;
                rec.data.arr_vat = new Array();
                rec.data.vat_amount = null;
                rec.data.arr_vat = new Array();
                rec.data.total_amount = null;
            }
            
            rec.data.isChecked = true;
            rec.data.isLoadedData = true;
            // get gia tri load unit va tax
            baseGetUnitOfProduct(record.data.product_id, index, index + 1, 3);// bat dau edit cot tiep theo
        },
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
    
    
    var cmDetail = new Ext.grid.ColumnModel({
        defaults: {
            sortable: false
        },
        columns: [new Ext.grid.RowNumberer(), {
            header: 'Service Code'.translator('buy-billing'),
            id: 'service_code',
            width: 80,
            dataIndex: 'service_code',
            editable: true
        }, {
            header: 'Service Name'.translator('buy-billing'),
            width: 100,
            dataIndex: 'service_name',
            id: 'service_name',
            editable: true
        }, {
            header: 'Product Code'.translator('buy-billing'),
            id: 'product_code',
            width: 80,
            dataIndex: 'product_code',
            editable: true
        }, {
            header: 'Product Name'.translator('buy-billing'),
            width: 100,
            dataIndex: 'product_name',
            id: 'product_name',
            editable: true
        }, {
            header: 'Specificity'.translator('buy-billing'),
            width: 120,
            hidden: true
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
            header: 'Export Rate'.translator('sale-billing'),
            width: 70,
            id: 'export_rate_id',
            dataIndex: 'export_rate_id',
            align: 'right',
            renderer: render_export_rate,
            editable: true
        }, {
            header: 'Export Amount'.translator('sale-billing'),
            width: 100,
            dataIndex: 'export_amount',
            id: 'export_amount',
            align: 'right',
            editable: true,
            renderer: render_number
        }, {
            header: 'Excise Rate'.translator('buy-billing'),
            width: 70,
            id: 'excise_rate_id',
            dataIndex: 'excise_rate_id',
            align: 'right',
            renderer: render_excise_rate,
            editable: true
        }, {
            header: 'Excise Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'excise_amount',
            id: 'excise_amount',
            align: 'right',
            editable: true,
            renderer: render_number
        }, {
            header: 'Vat Rate'.translator('buy-billing'),
            width: 70,
            id: 'vat_rate_id',
            dataIndex: 'vat_rate_id',
            align: 'right',
            renderer: render_vat_rate,
            editable: true
        }, {
            header: 'Vat Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'vat_amount',
            id: 'vat_amount',
            align: 'right',
            editable: true,
            renderer: render_number
        }, {
            header: 'Total Amount'.translator('buy-billing'),
            width: 100,
            dataIndex: 'total_amount',
            id: 'total_amount',
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
            'service_code': new Ext.grid.GridEditor(comboListServiceCode),
            'service_name': new Ext.grid.GridEditor(comboListServiceName),
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
                            baseNextStartingEdit(8);
                        }
                        else 
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 8);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            })),
            'export_rate_id': new Ext.grid.GridEditor(comboExportOption),
            'export_amount': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                        if (e.getCharCode() == 38) {
                            baseNextStartingEdit(12);
                        }
                        else 
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 12);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            })),
            'excise_rate_id': new Ext.grid.GridEditor(comboExciseOption),
            'excise_amount': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                        if (e.getCharCode() == 38) {
                            baseNextStartingEdit(14);
                        }
                        else 
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 14);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            })),
            'vat_rate_id': new Ext.grid.GridEditor(comboVatOption),
            'vat_amount': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                        if (e.getCharCode() == 38) {
                            baseNextStartingEdit(16);
                        }
                        else 
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 16);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            })),
            'note': new Ext.grid.GridEditor(new Ext.form.TextField({
                allowBlank: false
            })),
            'quantity': new Ext.grid.GridEditor(new Ext.form.TextField({
                selectOnFocus: true,
                enableKeyEvents: true,
                listeners: {
                    keypress: function(my, e){
                        if (!forceNumber(e)) 
                            e.stopEvent();
                        if (e.getCharCode() == 38) {
                            baseNextStartingEdit(7);
                        }
                        else 
                            if (e.getCharCode() == 40) {
                                var rec = gridDetail.getSelectionModel().getSelected();
                                var index = gridDetail.getStore().indexOf(rec);
                                if (index >= 1) {
                                    // bat dau edit tai ma san pham cua dong moi
                                    gridDetail.startEditing(index + 1, 7);
                                    gridDetail.getSelectionModel().selectRow(index + 1);
                                }
                            }
                    }
                }
            }))
        },
        getCellEditor: function(colIndex, rowIndex){
            var isLocked = (Ext.getCmp('is_locked').getValue() == 1) ? true : false;
            var rec = gridDetail.getStore().getAt(rowIndex);
            var isType = gridDetail.getStore().baseParams.type;
            var isTotal = rec.data.isTotal;
            var isChecked = rec.data.isChecked;
            var isInsertData = rec.data.isInsertData;
            var forService = Ext.getCmp('for_service').getValue();
            var byImport = Ext.getCmp('by_export').getValue();
            if (!isLocked) {
                if (colIndex == 4 && !isTotal && !forService && isInsertData && !isType) {
                    return this.editors['product_name'];
                }
                if (colIndex == 7 && !isTotal && isChecked) {
                    return this.editors['quantity'];
                }
                if (colIndex == 1 && !isTotal && forService && isInsertData) {
                    return this.editors['service_code'];
                }
                if (colIndex == 2 && !isTotal && forService && isInsertData) {
                    return this.editors['service_name'];
                }
                if (colIndex == 3 && !isTotal && !forService && isInsertData && !isType) {
                    return this.editors['product_code'];
                }
                if (colIndex == 6 && !isTotal && isChecked && !forService && !isType) {
                    return this.editors['unit_id'];
                }
                if (colIndex == 8 && !isTotal && isChecked) {
                    return this.editors['price'];
                }
                if (colIndex == 15 && !isTotal && isChecked && !forService) {
                    return this.editors['vat_rate_id'];
                }
                if (colIndex == 13 && !isTotal && isChecked && !byImport && !forService) {
                    return this.editors['excise_rate_id'];
                }
                if (colIndex == 11 && !isTotal && isChecked && byImport && !forService) {
                    return this.editors['export_rate_id'];
                }
                if (colIndex == 12 && !isTotal && isChecked && byImport) {
                    return this.editors['export_amount'];
                }
                if (colIndex == 14 && !isTotal && isChecked && !byImport) {
                    return this.editors['excise_amount'];
                }
                if (colIndex == 16 && !isTotal && isChecked) {
                    return this.editors['vat_amount'];
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
            text: 'Kế thừa PhXuất',
            id: 'btn_nheritance',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/inheritance-icon.png',
            handler: function(){
                loadGridInheritance();
            }
        }, '-', {
            xtype: 'label',
            text: 'Tiền hàng-Tk Có:',
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
			store: storeAccountList,
            id: 'cboCreditAmount',
            typeAhead: true,            
            valueField: 'account_id',
            displayField: 'account_code',
            mode: 'local',
            forceSelection: true,
            triggerAction: 'all',
            allowBlank: false,
            editable: true,
            width: 80,
            minListWidth: 100,
            tpl: resultTplAccount,
			itemSelector: 'div.search-item',
			minChars: 1,
            listWidth: 380,
            lazyRender: true,
            selectOnFocus: true
        }),  '-', {
            xtype: 'label',
            text: 'Thuế GTGT-Tk Có:',
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
            id: 'cboCreditVat',
            typeAhead: true,
            store: storeAccountList,
            valueField: 'account_id',
            displayField: 'account_code',
            mode: 'local',
            forceSelection: true,
            triggerAction: 'all',
            fieldLabel: 'Tk Nợ',
            allowBlank: false,
            editable: true,
            width: 80,
            minListWidth: 100,
            tpl: resultTplAccount,
			itemSelector: 'div.search-item',
			minChars: 1,
            listWidth: 380,
            lazyRender: true,
            selectOnFocus: true
        }), '-', {
            xtype: 'label',
            text: 'Thuế XK-Tk Có:',
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
            id: 'cboCreditExport',
            typeAhead: true,
            //labelStyle: 'text-align: right',
            store: storeAccountList,
            valueField: 'account_id',
            displayField: 'account_code',
            mode: 'local',
            forceSelection: true,
            triggerAction: 'all',
            fieldLabel: 'Tk Có',
            allowBlank: false,
            editable: true,
            width: 80,
            minListWidth: 100,
            tpl: resultTplAccount,
			itemSelector: 'div.search-item',
			minChars: 1,
            listWidth: 380,
            lazyRender: true,
            selectOnFocus: true
        }), '-', {
            xtype: 'label',
            text: 'Thuế TTĐB-Tk Có:',
            style: 'padding-left: 5px; padding-right: 5px;'
        }, new Ext.form.ComboBox({
            id: 'cboCreditExcise',
            typeAhead: true,
            //labelStyle: 'text-align: right',
            store: storeAccountList,
            valueField: 'account_id',
            displayField: 'account_code',
            mode: 'local',
            forceSelection: true,
            triggerAction: 'all',
            fieldLabel: 'Tk Có',
            allowBlank: false,
            editable: true,
            width: 80,
            minListWidth: 100,
            tpl: resultTplAccount,
			itemSelector: 'div.search-item',
			minChars: 1,
            listWidth: 380,
            lazyRender: true,
            selectOnFocus: true
        }), '->', {
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
        height: 297,
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
                indexSelectedRow = gridDetail.getStore().indexOf(e.record);
                // kiem tra du lieu da chon san pham chua va khong phai la dong total
                if (e.record.data.isChecked && !e.record.data.isTotal) {
                    // kiem tra du lieu da load chua
                    if (e.record.data.isLoadedData) {
                        baseLoadUnit(e.record.data.arr_unit);
                        baseLoadExport(e.record.data.arr_export);
                        baseLoadExcise(e.record.data.arr_excise);
                        baseLoadVat(e.record.data.arr_vat);
                    }
                    else {
                        e.record.data.isLoadedData = true;
                        if (!Ext.getCmp('for_service').getValue()) {
                            baseGetUnitOfProduct(e.record.data.product_id, indexSelectedRow, indexSelectedRow, e.column);
                        }
                    }
                }
                
                if ((e.field == 'quantity') || (e.field == 'price') || (e.field == 'vat_amount') ||
                (e.field == 'export_amount') ||
                (e.field == 'excise_amount')) {
                    e.value = cN(e.value);
                }
                switch (e.field) {
                    case 'quantity':
                        e.record.data.quantity = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    case 'price':
                        e.record.data.price = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    case 'vat_amount':
                        e.record.data.vat_amount = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    case 'export_amount':
                        e.record.data.export_amount = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    case 'excise_amount':
                        e.record.data.excise_amount = number_format_extra(e.value, decimals, decimalSeparator, '');
                        break;
                    default:
                        return;                }
            },
            afteredit: function(e){
                //if ((status == 'insert') && isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
                if (e.record.data.isInsertData) {
                    var index = gridDetail.getStore().indexOf(e.record);
                    if (e.field == 'unit_id') {
                        if (baseErrorExisted(e.record.data.product_id, e.record.data.service_id, e.value) > 0) {
                            msg('Error'.translator('buy-billing'), 'Existed Info'.translator('sale-billing'), Ext.MessageBox.ERROR);
                            e.record.reject();
                            return;
                        }
                        else {
                            var objectUnit = comboUnitOption.store.queryBy(function(rec){
                                return rec.data.unit_id == e.value;
                            }).itemAt(0);
                            e.record.data.price = !isEmpty(objectUnit) ? formatNumber(objectUnit.data.default_sales_price) : 0;
                            e.record.data.coefficient = objectUnit.data.coefficient;
                        }
                    }
                    switch (e.field) {
                        case 'quantity':
                            e.record.data.quantity = formatNumber(e.value);
                            break;
                        case 'price':
                            e.record.data.price = formatNumber(e.value);
                            break;
                        case 'vat_rate_id':
                            var objectTax = storeVatRate.queryBy(function(rec){
                                return rec.data.tax_rate_id == e.value;
                            }).itemAt(0);
                            var rate = 0;
                            if (!isEmpty(objectTax)) {
                                rate = objectTax.data.rate;
                            }
                            e.record.data.vat_rate = rate;
                            baseCalculateDetail(e.record, e.record.data.quantity, e.record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), e.record.data.export_rate, e.record.data.excise_rate, rate);
                            break;
                        case 'vat_amount':
                            e.record.data.vat_amount = formatNumber(e.value);
                            break;
                        case 'export_rate_id':
                            var objectTax = storeImportRate.queryBy(function(rec){
                                return rec.data.tax_rate_id == e.value;
                            }).itemAt(0);
                            var rate = 0;
                            if (!isEmpty(objectTax)) {
                                rate = objectTax.data.rate;
                            }
                            e.record.data.export_rate = rate;
                            baseCalculateDetail(e.record, e.record.data.quantity, e.record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), rate, e.record.data.excise_rate, e.record.data.vat_rate);
                            break;
                        case 'export_amount':
                            e.record.data.export_amount = formatNumber(e.value);
                            break;
                        case 'excise_rate_id':
                            var objectTax = storeExciseRate.queryBy(function(rec){
                                return rec.data.tax_rate_id == e.value;
                            }).itemAt(0);
                            var rate = 0;
                            if (!isEmpty(objectTax)) {
                                rate = objectTax.data.rate;
                            }
                            e.record.data.excise_rate = rate;
                            baseCalculateDetail(e.record, e.record.data.quantity, e.record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), e.record.data.export_rate, rate, e.record.data.vat_rate);
                            break;
                        case 'excise_amount':
                            e.record.data.excise_amount = formatNumber(e.value);
                            break;
                    }
                    if ((e.field == 'quantity') || (e.field == 'price') || (e.field == 'unit_id')) {
                        baseCalculateDetail(e.record, e.record.data.quantity, e.record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), e.record.data.export_rate, e.record.data.excise_rate, e.record.data.vat_rate);
                    }
                    else 
                        if ((e.field == 'vat_amount') || (e.field == 'export_amount') || (e.field == 'excise_amount')) {
                            baseCalculateAmount(e.record, e.record.data.converted_amount, e.record.data.export_amount, e.record.data.excise_amount, e.record.data.vat_amount);
                        }
                    
                    if ((status == 'insert') && isEmpty(Ext.getCmp('sales_invoice_id').getValue())) {
                        e.record.commit();
                    }
                    else {
                        if (!isEmpty(e.record.data.quantity) && !isEmpty(e.record.data.unit_id)) {
                            baseInsertRecordDetail(e.record);
                        }
                    }
                    
                }
                else {
                
                    if ((e.field == 'quantity') || (e.field == 'price') ||
                    (e.field == 'export_amount') ||
                    (e.field == 'vat_amount') ||
                    (e.field == 'excise_amount')) {
                        if (parseFloat(e.value) < 0) {
                            e.record.reject();
                            msg('Error'.translator('buy-billing'), 'Inputed original value'.translator('buy-billing'), Ext.MessageBox.ERROR);
                            return;
                        }
                        else 
                            e.value = formatNumber(e.value);
                    }
                    else 
                        if (e.field == 'export_rate_id') {
                            e.value = e.value + '_' + baseGetRateById(storeImportOption, e.value);
                        }
                        else 
                            if (e.field == 'excise_rate_id') {
                                e.value = e.value + '_' + baseGetRateById(storeExciseOption, e.value);
                            }
                            else 
                                if (e.field == 'vat_rate_id') {
                                    e.value = e.value + '_' + baseGetRateById(storeVatOption, e.value);
                                }
                    
                    if (e.field == 'unit_id') {
                        if (baseErrorExisted(e.record.data.product_id, e.record.data.service_id, e.value) > 0) {
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
                    
                    baseUpdateDetailSaleInvoice(e.record, e.record.data.sales_invoice_id, e.record.data.detail_id, e.field, e.value);
                }
            },
            cellclick: function(gridSpec, rowIndex, columnIndex, e){
                var selectedRecord = gridDetail.getSelectionModel().getSelected();
                var isTotal = selectedRecord.data.isTotal;
                if (gridDetail.getColumnModel().getColumnId(columnIndex) == 'vat_rate_id' && !isTotal) {
                    baseLoadVat(selectedRecord.data.arr_vat);
                }
                else 
                    if (gridDetail.getColumnModel().getColumnId(columnIndex) == 'export_rate_id' && !isTotal) {
                        baseLoadExport(selectedRecord.data.arr_export);
                    }
                    else 
                        if (gridDetail.getColumnModel().getColumnId(columnIndex) == 'excise_rate_id' && !isTotal) {
                            baseLoadExcise(selectedRecord.data.arr_excise);
                        }
                        else 
                            if (gridDetail.getColumnModel().getColumnId(columnIndex) == 'unit_id' && !isTotal) {
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
    
    var wraperProduct = new Ext.Panel({
        region: 'center',
        collapsible: false,
        border: false,
        layout: 'fit',
        contentEl: 'div-form-product',
        autoScroll: true
    });
    
    /* Creating popup windows */
    var showProductWin = new Ext.Window({
        items: [wraperProduct], //tabPanel, created in form-product.phtml
        layout: 'border',
        constrainHeader: true,
        height: 604,
        width: 500,
        closeAction: 'hide',
        maximizable: true,
        border: false
    });
    
    storeDetail.on('beforeload', function(){
    
        storeDetail.baseParams.start = 0;
        storeDetail.baseParams.limit = page_size;
    });
    
});

var baseErrorExisted = function(productId, serviceId, unitId){
    if (Ext.getCmp('for_service').getValue()) {
        return FormAction.checkExistedService(serviceId, unitId);
    }
    else {
        return FormAction.checkExistedProduct(productId, unitId);
    }
};

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

var baseGetRateById = function(store, id){
    for (var i = 0; i < store.getCount(); i++) {
        if (store.getAt(i).data.tax_rate_id == id) {
            return store.getAt(i).data.rate;
            break;
        }
    }
};

var baseLoadVat = function(arrVat){
    var recordNull = new Array();
    recordNull['tax_rate_id'] = 0;
    recordNull['specification_name'] = '';
    recordNull['rate'] = 0;
    var recNull = new Ext.data.Record(recordNull);
    comboVatOption.store.removeAll();
    comboVatOption.store.add(recNull);
    var i;
    for (i = 0; i < arrVat.length; i++) {
        var recordVat = new Array();
        recordVat['tax_rate_id'] = arrVat[i]['tax_rate_id'];
        recordVat['specification_name'] = arrVat[i]['specification_name'];
        recordVat['rate'] = arrVat[i]['rate'];
        var rec = new Ext.data.Record(recordVat);
        comboVatOption.store.add(rec);
    }
};

var baseLoadExport = function(arrImport){
    var recordNull = new Array();
    recordNull['tax_rate_id'] = 0;
    recordNull['specification_name'] = '';
    recordNull['rate'] = 0;
    var recNull = new Ext.data.Record(recordNull);
    comboExportOption.store.removeAll();
    comboExportOption.store.add(recNull);
    var i;
    for (i = 0; i < arrImport.length; i++) {
        var recordImport = new Array();
        recordImport['tax_rate_id'] = arrImport[i]['tax_rate_id'];
        recordImport['specification_name'] = arrImport[i]['specification_name'];
        recordImport['rate'] = arrImport[i]['rate'];
        var rec = new Ext.data.Record(recordImport);
        comboExportOption.store.add(rec);
    }
};

var baseLoadExcise = function(arrExcise){
    var recordNull = new Array();
    recordNull['tax_rate_id'] = 0;
    recordNull['specification_name'] = '';
    recordNull['rate'] = 0;
    var recNull = new Ext.data.Record(recordNull);
    comboExciseOption.store.removeAll();
    comboExciseOption.store.add(recNull);
    var i;
    for (i = 0; i < arrExcise.length; i++) {
        var recordExcise = new Array();
        recordExcise['tax_rate_id'] = arrExcise[i]['tax_rate_id'];
        recordExcise['specification_name'] = arrExcise[i]['specification_name'];
        recordExcise['rate'] = arrExcise[i]['rate'];
        var rec = new Ext.data.Record(recordExcise);
        comboExciseOption.store.add(rec);
    }
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
            recordUnit['default_sales_price'] = arrUnit[i]['default_sales_price'];
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
                    recordUnit['default_sales_price'] = number_format_extra(result.data[i]['default_sales_price'], decimals, decimalSeparator, thousandSeparator);
                    gridDetail.getStore().getAt(index).data.arr_unit.push(recordUnit);
                }
                
                baseGetTaxOfProduct(productId, index, rowEditIndex, colIndex);
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

var baseGetTaxOfProduct = function(productId, index, rowEditIndex, colIndex){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getTaxOfProductId/' + productId,
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                var record = gridDetail.getStore().getAt(index);
                record.data.arr_vat = new Array();
                record.data.arr_export = new Array();
                record.data.arr_excise = new Array();
                for (var i = 0; i < result.data.length; i++) {
                    var recordVat = new Array();
                    recordVat['tax_rate_id'] = result.data[i]['tax_rate_id'];
                    recordVat['specification_name'] = result.data[i]['specification_name'];
                    recordVat['rate'] = result.data[i]['rate'];
                    if (result.data[i]['tax_id'] == VAT_RATE) {
                        record.data.arr_vat.push(recordVat);
                        if ((result.data[i]['specification_id'] == SEPC_DEFAULT) && record.data.isInsertData) {
                            record.data.vat_rate = result.data[i]['rate'];
                            record.data.vat_rate_id = result.data[i]['tax_rate_id'];
                        }
                    }
                    else 
                        if (result.data[i]['tax_id'] == EXPORT_RATE) {
                            record.data.arr_export.push(recordVat);
                            if ((result.data[i]['specification_id'] == SEPC_DEFAULT) && record.data.isInsertData) {
                                record.data.export_rate = result.data[i]['rate'];
                                record.data.export_rate_id = result.data[i]['tax_rate_id'];
                            }
                        }
                        else 
                            if (result.data[i]['tax_id'] == EXCISE_RATE) {
                                record.data.arr_excise.push(recordVat);
                                if ((result.data[i]['specification_id'] == SEPC_DEFAULT) && record.data.isInsertData) {
                                    record.data.excise_rate = result.data[i]['rate'];
                                    record.data.excise_rate_id = result.data[i]['tax_rate_id'];
                                }
                            }
                }
                if (record.data.isInsertData) {
                    baseCalculateDetail(record, record.data.quantity, record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), record.data.export_rate, record.data.excise_rate, record.data.vat_rate);
                }
                baseLoadUnit(record.data.arr_unit);
                baseLoadExport(index);
                baseLoadExcise(index);
                baseLoadVat(index);
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

function cN(val){
    if (isEmpty(val)) {
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

var baseChangeForexrate = function(forexrate){
    for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
        var record = gridDetail.getStore().getAt(i);
        if (record.data.isChecked) {
            baseCalculateDetail(record, record.data.quantity, record.data.price, forexrate, record.data.export_rate, record.data.excise_rate, record.data.vat_rate);
        }
    }
};

var baseCalculateDetail = function(record, quantity, price, forexrate, exportRate, exciseRate, vatRate){
    if (!Ext.getCmp('by_export').getValue()) {
        exportRate = 0;
    }
    record.data.amount = cN(record.data.quantity) * cN(record.data.price);
    record.data.converted_amount = record.data.amount * forexrate;
    if (!Ext.getCmp('for_service').getValue()) {
        record.data.export_amount = exportRate / 100 * record.data.converted_amount;
        record.data.excise_amount = exciseRate / 100 * record.data.converted_amount * (1 + exportRate / 100);
        record.data.vat_amount = vatRate / 100 * record.data.converted_amount * (1 + (exportRate / 100)) * (1 + (exciseRate / 100));
        record.data.total_amount = record.data.converted_amount + cN(record.data.export_amount) +
        cN(record.data.excise_amount) +
        cN(record.data.vat_amount);
    }
    else {
        record.data.export_amount = 0;
        record.data.total_amount = record.data.converted_amount + cN(record.data.vat_amount) + cN(record.data.excise_amount);
        
    }
    
    return baseCalTotalAmmount();
};

var baseCalTotalAmmount = function(){
    var amount = 0;
    var convertedAmount = 0;
    var exportAmount = 0;
    var exciseAmount = 0;
    var vatAmount = 0;
    var totalAmount = 0;
    for (var i = 1; i < gridDetail.getStore().getCount(); i++) {
        var record = gridDetail.getStore().getAt(i);
        if (record.data.isChecked) {
            amount += cN(record.data.amount);
            convertedAmount += cN(record.data.converted_amount);
            exportAmount += cN(record.data.export_amount);
            exciseAmount += cN(record.data.excise_amount);
            vatAmount += cN(record.data.vat_amount);
            totalAmount += cN(record.data.total_amount);
        }
    }
    var recordTotal = gridDetail.getStore().getAt(0);
    recordTotal.data.amount = '/' + amount + '/';
    recordTotal.data.converted_amount = '/' + convertedAmount + '/';
    recordTotal.data.export_amount = '/' + exportAmount + '/';
    recordTotal.data.excise_amount = '/' + exciseAmount + '/';
    recordTotal.data.vat_amount = '/' + vatAmount + '/';
    recordTotal.data.total_amount = '/' + totalAmount + '/';
    gridDetail.getView().refresh(true);
    return totalAmount;
};

var baseCalculateAmount = function(record, convertedAmount, exportAmount, exciseAmount, vatAmount){
    if (!Ext.getCmp('by_export').getValue()) {
        exportAmount = 0;
    }
    record.data.total_amount = cN(convertedAmount) + cN(exportAmount) + cN(exciseAmount) + cN(vatAmount);
    return baseCalTotalAmmount();
};

var baseUpdateDetailSaleInvoice = function(record, saleId, recordId, field, value){
    Ext.Ajax.request({
        url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/updateDetailSale/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                record.commit();
                switch (field) {
                    case 'vat_amount':
                    case 'export_amount':
                    case 'excise_amount':
                        var total = baseCalculateAmount(record, record.data.converted_amount, record.data.export_amount, record.data.excise_amount, record.data.vat_amount);
                        var rec = gridInvoice.getStore().getAt(selectedSaleInvoiceIndex);
                        rec.data.total_sale_amount = total;
                        gridInvoice.getView().refresh(true);
                        break;
                    case 'unit_id':
                        record.data.detail_id = result.data;
                        break;
                    case 'export_rate_id':
                        var r = value.split('_');
                        record.data.export_rate = r[1];
                        break;
                    case 'excise_rate_id':
                        var r = value.split('_');
                        record.data.excise_rate = r[1];
                        break;
                    case 'vat_rate_id':
                        var r = value.split('_');
                        record.data.vat_rate = r[1];
                        break;
                }
                
                if ((field == 'quantity') || (field == 'price') ||
                (field == 'export_rate_id') ||
                (field == 'excise_rate_id') ||
                (field == 'vat_rate_id')) {
                    var total = baseCalculateDetail(record, record.data.quantity, record.data.price, formatNumber(Ext.getCmp('forex_rate').getValue()), record.data.export_rate, record.data.excise_rate, record.data.vat_rate);
                    var rec = gridInvoice.getStore().getAt(selectedSaleInvoiceIndex);
                    rec.data.total_sale_amount = total;
                    gridInvoice.getView().refresh(true);
                }
            }
            else {
                record.reject();
            }
        },
        failure: function(response, request){
        },
        params: {
            saleId: Ext.encode(saleId),
            batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
            recordId: Ext.encode(recordId),
            field: Ext.encode(field),
            value: Ext.encode(value),
            coefficient: Ext.encode(record.data.coefficient)
        }
    });
};

var baseDeleteDetail = function(saleId, records, voucherId){
    var record = gridInvoice.getStore().getAt(selectedSaleInvoiceIndex);
    var isLocked = (record.data.is_locked == 1) ? true : false;
    if (!isLocked) {
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
                saleId: Ext.encode(saleId),
                batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
                records: Ext.encode(records)
            }
        });
    }
    else {
        warning('Warning'.translator('buy-billing'), 'Locked Invoice'.translator('sale-billing'));
    }
    
};

var baseInsertRecordDetail = function(r){
    var isImport = Ext.getCmp('by_export').getValue();
    var isService = Ext.getCmp('for_service').getValue();
    var record = ({
        'service_id': r.data.service_id,
        'product_id': r.data.product_id,
        'unit_id': r.data.unit_id,
        'quantity': cN(r.data.quantity),
        'converted_quantity': cN(r.data.quantity) * cN(r.data.coefficient),
        'price': cN(r.data.price),
        'amount': cN(r.data.amount),
        'converted_amount': cN(r.data.converted_amount),
        'export_rate_id': isImport && !isService && !isEmpty(r.data.export_rate_id) ? r.data.export_rate_id : 0,
        'export_rate': isImport && !isService && !isEmpty(r.data.export_rate) ? r.data.export_rate : 0,
        'export_amount': isImport && !isEmpty(r.data.export_amount) ? cN(r.data.export_amount) : 0,
        'excise_rate_id': !isImport && !isService && !isEmpty(r.data.excise_rate_id) ? r.data.excise_rate_id : 0,
        'excise_rate': !isImport && !isService && !isEmpty(r.data.excise_rate) ? r.data.excise_rate : 0,
        'excise_amount': !isImport && !isEmpty(r.data.excise_amount) ? cN(r.data.excise_amount) : 0,
        'vat_rate_id': !isEmpty(r.data.vat_rate_id) ? r.data.vat_rate_id : 0,
        'vat_rate': !isEmpty(r.data.vat_rate) ? r.data.vat_rate : 0,
        'vat_amount': !isEmpty(r.data.vat_amount) ? cN(r.data.vat_amount) : 0,
        'total_amount': !isEmpty(r.data.total_amount) ? r.data.total_amount : 0,
        'note': r.data.note
    });
    Ext.Ajax.request({
        url: pathRequestUrl + '/insertRecordDetail/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                r.data.isInsertData = false;
                r.data.detail_id = result.data.product_id + '_' + result.data.service_id + ' ' + result.data.unit_id;
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
            saleId: Ext.encode(Ext.getCmp('sales_invoice_id').getValue()),
            batchId: Ext.encode(gridDetail.getStore().baseParams.batchId),
            record: Ext.encode(record)
        }
    });
};

var loadGridInheritance = function(){

    Ext.Msg.show({
        title: 'Confirm'.translator('receivable-manage'),
        buttons: Ext.MessageBox.YESNO,
        icon: Ext.MessageBox.QUESTION,
        msg: 'Ask inheritance output'.translator('sale-billing'),
        fn: function(btn){
            if (btn == 'yes') {
                if (!isEmpty(Ext.getCmp('customer_id').getValue())) {
                    createGridInventory();
                    gridInventory.getStore().load();
                    formInventoryWin = new Ext.Window({
                        title: 'List Output'.translator('sale-billing'),
                        layout: 'fit',
                        height: 600,
                        width: 1000,
                        modal: true,
                        items: gridInventory,
                        closable: false,
                        buttons: [{
                            text: 'Inher Ok'.translator('sale-billing'),
                            handler: function(){
                                // post inventory id
                                var rec = gridInventory.getSelectionModel().getSelected();
                                if (!isEmpty(rec)) {
                                    gridDetail.getStore().baseParams.inventoryInherId = rec.data.inventory_voucher_id;
                                    gridDetail.getStore().baseParams.inventoryInherVoucherId = rec.data.voucher_id;
                                    gridDetail.getStore().baseParams.forexrate = rec.data.forex_rate;
                                    gridDetail.getStore().baseParams.currency_id = rec.data.currency_id;
                                    Ext.getCmp('forex_rate').setValue(render_number(rec.data.forex_rate));
                                    Ext.getCmp('currency_code').setValue(rec.data.currency_id);
                                    Ext.getCmp('currency_id').setValue(rec.data.currency_id);
                                    getDetailRecordsOfArrayInventory(rec.data.inventory_voucher_id);
                                }
                            }
                        }, {
                            text: 'Cancel'.translator('sale-billing'),
                            handler: function(){
                                formInventoryWin.close();
                            }
                        }]
                    });
                    formInventoryWin.show();
                }
                else {
                    warning('Warning'.translator('buy-billing'), 'Please choose customer'.translator('sale-billing'));
                }
            }
        }
    });
};

var getDetailRecordsOfArrayInventory = function(inventoryId){
    Ext.Ajax.request({
        url: pathRequestUrl + '/getDetailOfInventoryVoucherNotInheritance/1',
        method: 'post',
        success: function(result, options){
            var result = Ext.decode(result.responseText);
            if (result.success) {
                baseInsertRecordsInGridDetail(result.data);
                formInventoryWin.close();
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
            inventoryId: Ext.encode(inventoryId)
        }
    });
};

var baseInsertRecordsInGridDetail = function(records){
    initGridDetail();
    var j = 1;
    for (var i = 0; i < records.length; i++) {
        if (records[i].real_quantity > 0) {
            var newRecord = new DetailRecord({
                isTotal: false,
                isChecked: true,
                isLoadedData: false,
                isInsertData: true,
                product_id: records[i].product_id,
                product_code: records[i].product_code,
                product_name: records[i].product_name,
                service_id: null,
                service_code: null,
                service_name: null,
                price: records[i].price,
                unit_id: records[i].unit_id,
                arr_unit: new Array(),
                quantity: records[i].real_quantity,
                amount: null,
                converted_amount: null,
                arr_unit: new Array(),
                amount: null,
                converted_amount: null,
                export_rate_id: null,
                export_rate: 0,
                arr_export: new Array(),
                export_amount: null,
                excise_rate_id: null,
                excise_rate: 0,
                arr_excise: new Array(),
                excise_amount: null,
                vat_rate_id: null,
                vat_rate: 0,
                arr_vat: new Array(),
                vat_amount: null,
                total_amount: null,
                note: ''
            });
            gridDetail.getStore().insert(j, newRecord);
            j++;
        }
    }
    baseChangeForexrate(formatNumber(Ext.getCmp('forex_rate').getValue()));
    gridDetail.getView().refresh(true);
    
    gridDetail.getStore().baseParams.type = true;
};
