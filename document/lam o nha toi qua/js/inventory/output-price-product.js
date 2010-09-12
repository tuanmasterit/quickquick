Ext.onReady(function(){
	var productCodeFrom = '';
	var productCodeTo = '';
	var recordPeriod;
	var recordProductFrom;
	var recordProductTo;
	var tplStoreProduct = new Ext.XTemplate('<tpl for="."><div class="search-item">', '<span>{product_code} | {product_name}</span><br />', '</div></tpl>');
	var tplStorePeriod = new Ext.XTemplate('<tpl for="."><div class="item-selecttor-period">', '<span>{subject_name} | {month}/{year}</span><br />', '</div></tpl>');
    // Create path
    strPath = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;
    
	// storePeriod
	var storePeriod = new Ext.data.Store({
	    reader: new Ext.data.JsonReader({
	        root: 'data',
//	        totalProperty: 'count',
	        id: 'storePeriod',
	        fields: ['period_id', 'subject_id', 'length', 'month', 'year', 'subject_code', 'subject_name']
	    }),
	    proxy: new Ext.data.HttpProxy({
	        url: strPath + '/getListPeriodCombo/1'
	    }),
	    autoLoad: false,
	    remoteSort: true
	}); 
	
	// storeProductFrom
	var storeProductFrom = new Ext.data.Store({
	    reader: new Ext.data.JsonReader({
	        root: 'data',
	        totalProperty: 'count',
	        id: 'storeProductFrom',
	        fields: ['product_id', 'product_code', 'product_name']
	    }),
	    proxy: new Ext.data.HttpProxy({
	        url: strPath + '/getListProductComboFrom/1'
	    }),
	    autoLoad: false,
	    remoteSort: true
	});
	// storeProductTo
	var storeProductTo = new Ext.data.Store({
	    reader: new Ext.data.JsonReader({
	        root: 'data',
	        totalProperty: 'count',
	        id: 'storeProductTo',
	        fields: ['product_id', 'product_code', 'product_name']
	    }),
	    proxy: new Ext.data.HttpProxy({
	        url: strPath + '/getListProductComboTo/1'
	    }),
	    autoLoad: false,
	    remoteSort: true
	});
	// before load
	storeProductFrom.on('beforeload', function(){
		storeProductFrom.baseParams.start = 0;
		storeProductFrom.baseParams.limit = 50;
		storeProductFrom.baseParams.product_code = productCodeTo;
	});
	storeProductTo.on('beforeload', function(){
		storeProductTo.baseParams.start = 0;
		storeProductTo.baseParams.limit = 50;
		storeProductTo.baseParams.product_code = productCodeFrom;
	});
	
	// load
	storePeriod.load();
	storePeriod.on('load', function() {
//		console.debug(storePeriod);
//		storeProduct.load();
//		storeProduct.on('load', function() {
//			console.debug(storeProduct);
//		});
	});
	
    var outputPriceProductTable = new Ext.FormPanel({
        frame: true,
        title: 'Tinh gia xuat kho?',
        width: 520,
        renderTo: 'OutputPriceProductTables',
        iconCls: 'icon-form',
		buttonAlign: 'center',
		plain:true,
		labelWidth : 140,
        items: [new Ext.form.ComboBox({
        	id: 'storePeriod',
            typeAhead: true,
            store: storePeriod,
            valueField: 'period_id',
            displayField: 'subject_name',
            mode: 'local',
            forceSelection: true,
            triggerAction: 'all',
            fieldLabel: 'Start Period Name',
            editable: false,
            width: 300,
            minListWidth: 100,
            lazyRender: true,
            tpl: tplStorePeriod,
            itemSelector: 'div.item-selecttor-period',
            selectOnFocus: true,
            listeners: {
                select: function(combo, record, index){
        			Ext.getCmp('storePeriod').setValue(record.data.subject_name + ' | ' + record.data.month + '/' + record.data.year);
        			recordPeriod = record;
                }
            }
        }), new Ext.form.ComboBox({
        	id: 'storeProductFrom',
            store: storeProductFrom,
            fieldLabel: 'From Product Name',
            forceSelection: true,
            displayField: 'product_name',
            valueField: 'product_id',
            typeAhead: false,
            tpl: tplStoreProduct,
            triggerAction: 'all',
            selectOnFocus: true,
            editable: true,
            itemSelector: 'div.search-item',
            width: 320,
            minChars: 1,
            pageSize: 50,
            lazyRender: true,
            selectOnFocus: true,
            listWidth: 300,
            listeners: {
                select: function(combo, record, index){
        			productCodeFrom = record.data.product_code;
        			recordProductFrom = record;
					if(productCodeFrom) {
						storeProductTo.load();
					}
                }
            }
        }), new Ext.form.ComboBox({
        	id: 'storeProductTo',
            store: storeProductTo,
            fieldLabel: 'To Product Name',
            forceSelection: true,
            displayField: 'product_name',
            valueField: 'product_id',
            typeAhead: false,
            tpl: tplStoreProduct,
            triggerAction: 'all',
            selectOnFocus: true,
            editable: true,
            itemSelector: 'div.search-item',
            width: 320,
            minChars: 1,
            pageSize: 50,
            lazyRender: true,
            selectOnFocus: true,
            listWidth: 300,
            listeners: {
	        	select: function(combo, record, index){
					productCodeTo = record.data.product_code;
					recordProductTo = record;
					if(productCodeTo) {
						storeProductFrom.load();
					}
	        	}
            }
        })],
        buttons: [{
			cls: 'button-cal',
        	text: 'Calculate',
        	handler: function(){
	        	if(recordPeriod && recordProductFrom && recordProductTo) {
	        		Ext.Ajax.request({
	    		        url: strPath + '/calculateOutputPrice/1',
	    		        method: 'post',
	    		        success: function(resp,opt) {
	            			
	    					var result = Ext.util.JSON.decode(resp.responseText);
//	    					if (result.successful) {
//	    						Ext.Msg.alert('Info'.translator('voucher-type'), 'Voucher type insert successfully!'.translator('voucher-type'));
//	    					    storeListVoucherType.load({
//	    					        params: {
//	    					            start: 0,
//	    					            limit: page_size,
//	    					            action: 'get'
//	    					        }
//	    					    });
//	    						resetForm();
//	    					} else {
//	    						Ext.Msg.alert('Error'.translator('voucher-type'), 'Voucher type can not insert!'.translator('voucher-type'));
//	    					}
//	    					Ext.getCmp('buttonSave').setDisabled(false);
	    				},
	    		        params: {
	    					period_id: Ext.encode(recordPeriod.data.period_id),
	    					subject_id: Ext.encode(recordPeriod.data.subject_id),
	    					subject_code: Ext.encode(recordPeriod.data.subject_code),
	    					subject_name: Ext.encode(recordPeriod.data.subject_name),
	    					length: Ext.encode(recordPeriod.data.length),
	    					year: Ext.encode(recordPeriod.data.year),
	    					month: Ext.encode(recordPeriod.data.month),
	    					product_code_from: Ext.encode(recordProductFrom.data.product_code),
	    					product_code_to: Ext.encode(recordProductTo.data.product_code)
	    		        }
	    		    });
	        	}
        	}
        }]
    });
});
