Ext.onReady(function(){
    var start = true;
    var Tree = Ext.tree;
    
    Ext.QuickTips.init();
    
	var storeTermCriteria = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'term_id',
            fields: ['term_id', 'term_name']
        }),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getListTerm/1'
        }),
        autoLoad: true
    });
	
    comboTerm = new Ext.form.ComboBox({
        typeAhead: true,
        store: storeTermCriteria,
        valueField: 'term_id',
        displayField: 'term_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select a term',
        fieldLabel: 'Term Group',
        editable: false,
        width: 290,
        minListWidth: 100,
        id: 'comboTerm',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){			
				
            }
        }
    });
	
    treeRank = new Tree.TreePanel({
        id: 'tp',
        animate: true,
        autoScroll: true,
        loader: new Tree.TreeLoader({
            dataUrl: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getLoadTreeData/1'
        }),
        containerScroll: true,
        enableDD: true,
        border: false,
        height: 555,
        width: 315,
        rootVisible: false,
        style: 'margin-top:4px; margin-left:5px;border:1px solid #99BBE8;',
        tbar: ['->', {
            text: 'Reload',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                // action reload
            }
        }],
        listeners: {
            click: function(node, e){
                // action click node                
            },
            load: function(node){
                // action load data
            }
        }
    });
    
    var root = new Tree.AsyncTreeNode({
        text: '',
        draggable: false, // disable root node dragging
        icon: '',
        iconCls: '',
        id: '0'
    });
    treeRank.setRootNode(root);
    root.expand(false, /*no anim*/ false);
});
