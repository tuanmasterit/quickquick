Ext.onReady(function(){
    var start = true;
    var Tree = Ext.tree;
    
    Ext.QuickTips.init();
	
	tree = new Tree.TreePanel({
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
    tree.setRootNode(root);
    root.expand(false, /*no anim*/ false);
});
