Ext.onReady(function(){

    formSubject = new Ext.Panel({
        frame: true,
        width: 827,
        height: 630,
        hidden: true,
        items: [{
            layout: 'form',
            labelWidth: 150,
            items: [comboTerm]
        }, {
            layout: 'column',
            items: [{
                columnWidth: .396,
                layout: 'form',
                items: [treeRank]
            }, {
                columnWidth: .650,
                layout: 'form',
                id: 'ExplorerForm',
				style: 'margin-top:4px; margin-left:10px;border:0px solid #99BBE8;',
                items: [gridSubjectTab]
            }]
        }]
    });    
});
