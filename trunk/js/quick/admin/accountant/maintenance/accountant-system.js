var tree;
var AccountantForm;
var selectedNodeid;
var treeNode = new Array();
treeNode[0] = "0";
var page_size = 20;

Ext.onReady(function(){
    var accountantTable = new Ext.FormPanel({
        frame: true,
        title: 'Accountant System'.translator('accountant'),
        width: 855,
        height: 538,
        renderTo: 'AccountantSystemTables',
        iconCls: 'icon-form',
        items: [{
            layout: 'column',
            items: [{
                columnWidth: .396,
                layout: 'form',
                items: [tree]
            }, {
                columnWidth: .604,
                layout: 'form',
                id: 'ExplorerForm',
                items: [{
                    xtype: 'label',
                    text: 'abc',
                    style: 'font-size:15; font-weight:bold; color:#428284; padding-left: 5px;',
                    hidden: true
                }, AccountantForm]
            }]
        }]
    });
    
});
