Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    
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
                
                if (!record.data.object_id) {
                    Ext.Msg.alert('Error', 'Please input Table before', Ext.MessageBox.ERROR);
                    record.reject();
                    return;
                }
                
                record.set(this.dataIndex, !record.data[this.dataIndex]);
            }
        },
        
        renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="approved-column x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
        }
    };
    
    var editSubjectWin;
    var Subject = {
    
        clearForm: function(){
        
        },
        
        add: function(){
            $('#div-form-subject').css('display', 'block');
            editSubjectWin.setTitle('Edit Subject');
            editSubjectWin.show();
            editSubjectWin.doLayout();
        },
        
        remove: function(){
        },
        
        find: function(){
        
        },
        
        load: function(selectedProduct){
        
        },
        
        edit: function(selectedProduct){
        
        }
    };
    
    var recordSubject = [{
        name: 'subject_id',
        type: 'string'
    }, {
        name: 'subject_code',
        type: 'string'
    }, {
        name: 'subject_name',
        type: 'string'
    }, {
        name: 'subject_address',
        type: 'string'
    }, {
        name: 'subject_tax_code',
        type: 'string'
    }, {
        name: 'currency_id',
        type: 'string'
    }, {
        name: 'currency_name',
        type: 'string'
    }, {
        name: 'is_software_user',
        type: 'integer'
    }, {
        name: 'is_producer',
        type: 'integer'
    }, {
        name: 'is_supplier',
        type: 'integer'
    }, {
        name: 'is_customer',
        type: 'integer'
    }, {
        name: 'is_government',
        type: 'integer'
    }, {
        name: 'is_bank',
        type: 'integer'
    }];
    
    var subject_object = Ext.data.Record.create(recordSubject);
    
    var storeListCurrency = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'currency_id',
            fields: ['currency_id', 'currency_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListCurrency/1'
        }),
        autoLoad: true
    });
    
    storeListCurrency.on('load', function(){
        storeListCurrency.insert(0, new Ext.data.Record({
            currency_id: 0,
            currency_name: ''
        }));
        Ext.getCmp('grid_roduct').getStore().reload();
    });
    
    var comboCurrencyGird = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeListCurrency,
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
                // action select
            }
        }
    });
    
    var checkSoftware = new Ext.grid.CheckColumn({
        header: 'Software User',
        dataIndex: 'is_software_user',
        width: 100
    });
	var checkProducer = new Ext.grid.CheckColumn({
        header: 'Producer',
        dataIndex: 'is_producer',
        width: 100
    });
    var checkSupplier = new Ext.grid.CheckColumn({
        header: 'Supplier',
        dataIndex: 'is_supplier',
        width: 100
    });
    var checkCustomer = new Ext.grid.CheckColumn({
        header: 'Customer',
        dataIndex: 'is_customer',
        width: 100
    });
    var checkGovernment = new Ext.grid.CheckColumn({
        header: 'Government',
        dataIndex: 'is_government',
        width: 100
    });
    var checkBank = new Ext.grid.CheckColumn({
        header: 'Bank',
        dataIndex: 'is_bank',
        width: 100
    });
    
    function render_currency_name(val){
        try {
            if (val == null || val == '') 
                return '';
            return storeListCurrency.queryBy(function(rec){
                return rec.data.currency_id == val;
            }).itemAt(0).data.currency_name;
        } 
        catch (e) {
        }
    }
    
    function render_detail(val){
        return '<div class="extensive-detail" style="width: 16px; height: 16px;"></div>';
    }
    
    var storeSubjectList = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'subject_id'
        }, subject_object),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListSubject/1'
        }),
        autoLoad: true,
        remoteSort: true
    });
    
    var cmbPerPage = new Ext.form.ComboBox({
        name: 'perpage',
        width: 40,
        store: new Ext.data.SimpleStore({
            data: [[10, '10'], [15, '15'], [20, '20'], [25, '25'], [30, '30'], [50, '50'], [0, 'All']],
            id: 0,
            fields: ['id', 'value']
        }),
        mode: 'local',
        value: '20',
        listWidth: 40,
        triggerAction: 'all',
        displayField: 'value',
        valueField: 'value',
        editable: false,
        forceSelection: true
    });
    
    cmbPerPage.on('select', function(combo, record){
        bbar.pageSize = parseInt(record.get('id'), 10);
        bbar.doLoad(bbar.cursor);
    }, this);
    
    var tbar = new Ext.Toolbar({
        items: [{           
            text: 'Add',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: Subject.add
        }, {
            text: 'Delete',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: Subject.remove
        }, '-', {
            xtype: 'tbtext',
            text: 'Subject Name'
        }, {
            xtype: 'textfield',
            id: 'SearchSubjectName',
            width: 200,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        Subject.find();
                    }
                }
            }
        }, {
            xtype: 'tbbutton',
            text: 'Find',
            tooltip: 'Find Subject Name',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',            
            handler: Subject.find
        }]
    });
    
    var bbar = new Ext.PagingToolbar({
        store: storeSubjectList, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size,
        items: ['-', 'Per Page: ', cmbPerPage]
    });
    
    var cm2 = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [{
            id: 'subject_id',
            header: '',
            dataIndex: 'subject_id',
            width: 30,
            renderer: render_detail
        }, {
            header: 'Subject Code',
            dataIndex: 'subject_code',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Subject Name',
            dataIndex: 'subject_name',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Subject Address',
            dataIndex: 'subject_address',
            width: 200,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Subject Tax Code',
            dataIndex: 'subject_tax_code',
            width: 100,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }, {
            header: 'Currency Name',
            dataIndex: 'currency_id',
            width: 100,
            renderer: render_currency_name,
            editor: comboCurrencyGird
        }, checkSoftware, checkProducer, checkSupplier, checkCustomer, checkGovernment, checkBank]
    });
    // by default columns are sortable
    cm2.defaultSortable = true;
    
    gridSubject = new Ext.grid.EditorGridPanel({
        store: storeSubjectList,
        cm: cm2,
        stripeRows: true,
        width: 827,
        height: 630,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        title: '',
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        tbar: tbar,
        bbar: bbar,
        stateful: true,
        stateId: 'grid_subject',
        id: 'grid_subject',
        listeners: {
            cellclick: function(grid, rowIndex, columnIndex, e){
            
            },
            afteredit: function(e){
            
            }
        }
    
    });
    
    storeSubjectList.on('beforeload', function(){
    
    });
    
    var tabsWraper = new Ext.Panel({
        region: 'center',
        collapsible: false,
        border: false,
        layout: 'fit',
        contentEl: 'div-form-subject',
        autoScroll: true
    });
    
    /* Creating popup windows */
    editSubjectWin = new Ext.Window({
        items: [tabsWraper],
        layout: 'border',
        constrainHeader: true,
        height: 371,
        width: 567,
        closeAction: 'hide',
        maximizable: true,
        border: false,
        buttons: [{
            text: 'Close',
            handler: function(){
                editSubjectWin.hide();
            }
        }]
    });
    
    Ext.QuickTips.init();
});
