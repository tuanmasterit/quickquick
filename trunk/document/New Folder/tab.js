Ext.onReady(function(){
    Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
    
    var storeListProductGroup = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'product_id',
            fields: ['product_id']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListProductOfGroup/1'
        }),
        autoLoad: false,
        remoteSort: true
    });
    
    var ProductGroup = {
    
        add: function(){
        },
        
        remove: function(){
        },
        
        find: function(){
        }
    };
    
    var tbarPg = new Ext.Toolbar({
        items: [{
            text: 'Add',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: ProductGroup.add
        }, {
            text: 'Delete',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: ProductGroup.remove
        }, '-', {
            xtype: 'tbtext',
            text: 'Product Name'
        }, {
            xtype: 'textfield',
            id: 'productGroupName',
            width: 150,
            listeners: {
                specialkey: function(s, e){
                    if (e.getKey() == Ext.EventObject.ENTER) {
                        // action enter
                    }
                    
                }
            }
        }, {
            xtype: 'tbbutton',
            text: 'Find',
            tooltip: 'Find Product Name',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/find.png',
            id: 'find_product_group',
            handler: function(){
                // action find
            }
        }]
    });
    
    var bbarPg = new Ext.PagingToolbar({
        store: storeListProductGroup, //the store you use in your grid
        displayInfo: true,
        pageSize: page_size
    });
    
    var cmPg = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: [{
            header: 'Product ID',
            dataIndex: 'product_id',
            width: 200,
            editor: new Ext.form.TextField({
                allowBlank: false
            })
        }]
    });
    // by default columns are sortable
    cmPg.defaultSortable = true;
    
    var gridProductGroup = new Ext.grid.EditorGridPanel({
        store: storeListProductGroup,
        cm: cmPg,
        stripeRows: true,
        width: 480,
        height: 560,
        loadMask: true,
        trackMouseOver: true,
        frame: true,
        title: '',
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        tbar: tbarPg,
        bbar: bbarPg,
        stateful: true,
        stateId: 'grid_product_group',
		id: 'grid_product_group'
    });
    
    updateProductTabs = new Ext.TabPanel({
        title: '',
        plain: true,
        activeTab: 0,
        width: 480,
        height: 561,
        style: 'margin-left: 5px;',
        items: [{
            title: 'Product List',
            id: 'productListTab',
            items: [gridProductGroup]
        }]
    });
});
