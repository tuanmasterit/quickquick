Ext.onReady(function(){
    var Tree = Ext.tree;
    
    Ext.QuickTips.init();
	
	var TreeProperty = {
	
		add: function(){
		},
		remove: function(){
		}
	};
	
    treeProperty = new Tree.TreePanel({
        id: 'treeProperty',
        animate: true,
        autoScroll: true,
        loader: new Tree.TreeLoader({
            dataUrl: Quick.baseUrl + Quick.adminUrl + Quick.requestUrl + '/getLoadTreeProperty/1'
        }),
        containerScroll: true,
        enableDD: true,
        border: false,
        height: 435,
        width: 295,
        rootVisible: false,
		title: 'Property Options',
        style: 'margin-top:0px; margin-left:5px;border:1px solid #99BBE8;',
        tbar: [{
            text: 'Add',          
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            handler: TreeProperty.add
        }, {
            text: 'Delete',          
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            handler: TreeProperty.remove
        }, '->', {
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
    
    var rootProperty = new Tree.AsyncTreeNode({
        text: 'Options',
        draggable: false, // disable root node dragging
        icon: '',
        iconCls: '',
        id: '0'
    });	
    treeProperty.setRootNode(rootProperty);
    rootProperty.expand(true, true);
});
