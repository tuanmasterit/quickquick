var storeSaleInvoice;

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

function createGridSaleInvoice(){
	Ext.onReady(function(){
		//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
		pathRequestUrl = Quick.baseUrl + Quick.adminUrl + Quick.requestUrl;

		var storeByImportType = new Ext.data.ArrayStore({
			fields: [{
				name: 'by_export'
			}, {
				name: 'name'
			}, ],
			data: [[0, 'Trong nước'], [1, 'Xuất khẩu']]
		});

		var storeForServiceType = new Ext.data.ArrayStore({
			fields: [{
				name: 'for_service'
			}, {
				name: 'name'
			}, ],
			data: [[0, 'Hàng hóa'], [1, 'Dịch vụ']]
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
			name: 'sales_serial_number',
			type: 'string'
		}, {
			name: 'sales_invoice_number',
			type: 'string'
		}, {
			name: 'sales_invoice_date',
			type: 'date'
		}, {
			name: 'customer_name',
			type: 'string'
		}, {
			name: 'customer_tax_code',
			type: 'string'
		}, {
			name: 'customer_contact',
			type: 'string'
		}, {
			name: 'by_export',
			type: 'string'
		}, {
			name: 'for_service',
			type: 'string'
		}, {
			name: 'total_amount',
			type: 'string'
		}, {
			name: 'voucher_id',
			type: 'string'
		}];

		invoice_object = Ext.data.Record.create(InvoiceRecord);

		var Invoice = {

			find: function(){
				gridSaleInvoice.getStore().load();
			}
		};

		var storeSaleInvoice = new Ext.data.Store({
			reader: new Ext.data.JsonReader({
				root: 'data',
				totalProperty: 'count',
				id: 'sales_invoice_id'
			}, invoice_object),
			proxy: new Ext.data.HttpProxy({
				url: pathRequestUrl + '/getListSalesInvoiceNotInheritance/1'
			}),
			autoLoad: false
		});


		var tbarInvoice = new Ext.Toolbar({
			items: [{
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
				id: 'srch_from_date_sale',
				format: date_format_string,
				//readOnly: true,
				vtype: 'daterange',
				endDateField: 'srch_to_date_sale'
			}, '-', {
				xtype: 'label',
				text: 'To Date'.translator('buy-billing'),
				style: 'padding-left: 5px;padding-right: 5px;'
			}, {
				xtype: 'datefield',
				width: 99,
				labelSeparator: '',
				id: 'srch_to_date_sale',
				format: date_format_string,
				//readOnly: true,
				vtype: 'daterange',
				startDateField: 'srch_from_date_sale'
			}, '-', {
				text: 'Find'.translator('buy-billing'),
				id: 'find_invoice',
				cls: 'x-btn-text-icon',
				icon: Quick.skinUrl + '/images/icons/find.png',
				style: 'padding-left: 5px;',
				handler: Invoice.find
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
			store: storeSaleInvoice, //the store you use in your grid
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
				dataIndex: 'total_amount',
				width: 100,
				align: 'right',
				renderer: render_number
			}]
		});

		// create the Grid
		gridSaleInvoice = new Ext.grid.GridPanel({
			title: '',
			store: storeSaleInvoice,
			cm: cmInvoice,
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
			tbar: tbarInvoice,
			bbar: bbarInvoice,			
			id: 'gridSaleInvoice'
		});

		storeSaleInvoice.on('beforeload', function(){
			var srchNumber = gridSaleInvoice.topToolbar.items.get('srch_invoice_number').getValue();

			var srchFromDate = gridSaleInvoice.topToolbar.items.get('srch_from_date_sale').getValue();
			if (srchFromDate != null && srchFromDate != '')
				srchFromDate = srchFromDate.dateFormat('Y-m-d 00:00:00');
			else
				srchFromDate = '';

			var srchToDate = gridSaleInvoice.topToolbar.items.get('srch_to_date_sale').getValue();
			if (srchToDate != null && srchToDate != '')
				srchToDate = srchToDate.dateFormat('Y-m-d 00:00:00');
			else
				srchToDate = '';

			storeSaleInvoice.baseParams.invoiceNumber = srchNumber != '' ? srchNumber : '';
			storeSaleInvoice.baseParams.fromDate = srchFromDate;
			storeSaleInvoice.baseParams.toDate = srchToDate;
			storeSaleInvoice.baseParams.customer = 0;
			storeSaleInvoice.baseParams.start = 0;
			storeSaleInvoice.baseParams.limit = page_size;

		});
	});
};