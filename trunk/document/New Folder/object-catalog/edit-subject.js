Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    
    var storeCurrencies = new Ext.data.Store({
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
    
    storeCurrencies.on('load', function(){
        storeCurrencies.insert(0, new Ext.data.Record({
            currency_id: 0,
            currency_name: ''
        }));
    });
    
    var comboCurrency = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeCurrencies,
        valueField: 'currency_id',
        displayField: 'currency_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        editable: false,
        width: 352,
        fieldLabel: 'Currency',
        minListWidth: 100,
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
    editSubjectForm = new Ext.form.FieldSet({
        title: '',
        height: 285,
        width: 530,
        collapsed: false,
        hidden: false,
        layout: 'form',
        renderTo: 'frm-edit-subject',
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'textfield',
                width: 352,
                height: 20,
                fieldLabel: 'Subject Code',
                id: 'subject_code',
                listeners: {
                    change: function(e){
                        //baseUpdateSubjectForm(e.getId(), e.getValue());
                    }
                }
            }, {
                xtype: 'textfield',
                width: 352,
                height: 20,
                fieldLabel: 'Subject Name',
                id: 'subject_name',
                listeners: {
                    change: function(e){
                        //baseUpdateSubjectForm(e.getId(), e.getValue());
                    }
                }
            }, {
                xtype: 'textfield',
                width: 352,
                height: 20,
                fieldLabel: 'Subject Address',
                id: 'subject_address',
                listeners: {
                    change: function(e){
                        //baseUpdateSubjectForm(e.getId(), e.getValue());
                    }
                }
            }, {
                xtype: 'textfield',
                width: 352,
                height: 20,
                fieldLabel: 'Subject Tax Code',
                id: 'subject_tax_code',
                listeners: {
                    change: function(e){
                        //baseUpdateSubjectForm(e.getId(), e.getValue());
                    }
                }
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [comboCurrency]
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [{
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Software User',
                    labelSeparator: '',
                    boxLabel: '',
                    id: 'is_software_user',
                    name: 'is_software_user',
                    listeners: {
                        check: function(it, e){
                            //baseUpdateSubjectForm(e.getId(), e.getValue());
                        }
                    }
                }]
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [{
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Producer',
                    labelSeparator: '',
                    boxLabel: '',
                    id: 'is_producer',
                    name: 'is_producer',
                    listeners: {
                        check: function(it, e){
                            //baseUpdateSubjectForm(e.getId(), e.getValue());
                        }
                    }
                }]
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [{
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Supplier',
                    labelSeparator: '',
                    boxLabel: '',
                    id: 'is_supplier',
                    name: 'is_supplier',
                    listeners: {
                        check: function(it, e){
                            //baseUpdateSubjectForm(e.getId(), e.getValue());
                        }
                    }
                }]
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [{
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Customer',
                    labelSeparator: '',
                    boxLabel: '',
                    id: 'is_customer',
                    name: 'is_customer',
                    listeners: {
                        check: function(it, e){
                            //baseUpdateSubjectForm(e.getId(), e.getValue());
                        }
                    }
                }]
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [{
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Government',
                    labelSeparator: '',
                    boxLabel: '',
                    id: 'is_government',
                    name: 'is_government',
                    listeners: {
                        check: function(it, e){
                            //baseUpdateSubjectForm(e.getId(), e.getValue());
                        }
                    }
                }]
            }, {
                layout: 'form',
                labelWidth: 150,
                items: [{
                    xtype: 'checkbox',
                    height: 18,
                    width: 30,
                    fieldLabel: 'Bank',
                    labelSeparator: '',
                    boxLabel: '',
                    id: 'is_bank',
                    name: 'is_bank',
                    listeners: {
                        check: function(it, e){
                            //baseUpdateSubjectForm(e.getId(), e.getValue());
                        }
                    }
                }]
            }]
        }]
    });
    
    var subjectEditForm = new Ext.FormPanel({
        frame: true,
        id: 'subjectEditForm',
        //title: 'Edit Subject',
        width: 555.5,
        height: 300.5,
        renderTo: 'frm-edit-subject',
        iconCls: 'icon-form',
        bodyStyle: 'padding: 5px 5px 5px 5px;',
        items: [editSubjectForm]
    });
    
});
