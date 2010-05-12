var gridProduct;
var productForm;
var tree;
var updateProductTabs;
var productTabForm;
var treeProperty;
var page_size = 20;

Ext.onReady(function(){
	$('#div-form-product').css('display', 'none');
	
    var productCatalogForm = new Ext.FormPanel({
        frame: true,
        title: 'Product Catalog',
        width: 850,
        height: 700,
        renderTo: 'ProductCatalogTables',
        iconCls: 'icon-form',
        bodyStyle: 'padding: 5px 5px 5px 5px;',
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [{
                xtype: 'checkbox',
                height: 18,
                width: 30,
                //hideLabel: true,
                fieldLabel: 'Cập nhật theo phân nhóm',
                labelSeparator: '',
                boxLabel: '',
                id: 'chkUpdateFor',
                name: 'chkUpdateFor',
                listeners: {
                    check: function(it, e){
                    	var checkdvalue = e? -1 : 0;
						if(checkdvalue == 0){
							gridProduct.setVisible(true);
							productForm.setVisible(false);
						}else{
							gridProduct.setVisible(false);
							productForm.setVisible(true);
						}
                    }
                }
            }]
        }, {
            layout: 'form',
            items: [				
				gridProduct,
				productForm
            ]
        }]
    });
  
});
