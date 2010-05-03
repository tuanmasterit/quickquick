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
        height: 494,
        width: 315,
        rootVisible: false,
        style: 'margin-top:4px; margin-left:5px;border:1px solid #99BBE8;',
        tbar: [{
            text: 'Add',
            tooltip: {
                text: 'Add SubCategory to selected category',
                title: 'Add Category'
            },
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            //handler: Category.add
        }, {
            text: 'Delete',
            cls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/delete.png',
            //handler: Category.remove
        }, '->', {
			text: 'Reload',
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png',
            handler: function(){
                //treeRoot.reload();
            }
        }],
        listeners: {
            click: function(node, e){
            
                selectedNodeid = node.id;
                
                AccountantForm.setVisible(true);
                loadDataAccountantForm();
                
            },
            load: function(node){
                if (start) {
                    start = false;
                    
                    var childNode = node.firstChild;
                    if (childNode != null) {
                        childNode.expand();
                        childNode.fireEvent("click", childNode);
                    }
                }
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
