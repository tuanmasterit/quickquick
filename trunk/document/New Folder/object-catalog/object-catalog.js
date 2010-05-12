var gridSubject;
var formSubject;
var treeRank;
var comboTerm;
var gridSubjectTab;
var page_size = 20;

Ext.onReady(function(){
	$('#div-form-subject').css('display', 'none');
	
    var objectCatalogForm = new Ext.FormPanel({
        frame: true,
        title: 'Object Catalog',
        width: 850,
        height: 700,
        renderTo: 'ObjectCatalogTables',
        iconCls: 'icon-form',
        bodyStyle: 'padding: 5px 5px 5px 5px;',
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'checkbox',
                height: 18,
                width: 30,
                fieldLabel: 'Cập nhật theo phân nhóm',
                labelSeparator: '',
                boxLabel: '',
                id: 'chkUpdateFor',
                name: 'chkUpdateFor',
                listeners: {
                    check: function(it, e){
                    	var checkdvalue = e? -1 : 0;
						if(checkdvalue == 0){
							gridSubject.setVisible(true);
							formSubject.setVisible(false);
						}else{
							gridSubject.setVisible(false);
							formSubject.setVisible(true);
						}
                    }
                }
            }]
        }, {
            layout: 'form',
            items: [				
				gridSubject,
				formSubject
            ]
        }]
    });
  
});
