Ext.onReady(function(){

    var comboCriteria = new Ext.form.ComboBox({
        typeAhead: true,
        //store: ,
        valueField: 'criteria_id',
        displayField: 'criteria_name',
        mode: 'local',
        forceSelection: true,
        triggerAction: 'all',
        emptyText: 'Select detail criteria',
        fieldLabel: 'Criteria Group',
        editable: false,
        width: 290,
        minListWidth: 100,
        id: 'comboCriteria',
        lazyRender: true,
        selectOnFocus: true,
        listeners: {
            select: function(combo, record, index){
                // action select
            }
        }
    });
    
    productForm = new Ext.Panel({
        frame: true,
        width: 827,
        height: 630,
        hidden: true,
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [comboCriteria]
        }, {
            layout: 'column',
            items: [{
                columnWidth: .396,
                layout: 'form',
                items: [tree]
            }, {
                columnWidth: .596,
                layout: 'form',
                id: 'ExplorerForm',
                items: [{
                    xtype: 'label',
                    text: 'abc',
                    style: 'font-size:15; font-weight:bold; color:#428284; padding-left: 5px;',
                    hidden: true
                }, updateProductTabs]
            }]
        }]
    });
    
});
