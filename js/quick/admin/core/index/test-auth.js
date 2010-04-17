Ext.onReady(function(){
    $('#div-form-role').css('display', 'none');
    
    var roleWin;
    
    Ext.grid.CheckColumn = function(config){
        Ext.apply(this, config);
        if (!this.id) {
            this.id = Ext.id();
        }
        this.renderer = this.renderer.createDelegate(this);
    };
    
    Ext.grid.CheckColumn.prototype = {
        init: function(grid){
            this.grid = grid;
            this.grid.on('render', function(){
                var view = this.grid.getView();
                view.mainBody.on('mousedown', this.onMouseDown, this);
            }, this);
        },
        
        onMouseDown: function(e, t){
            if (t.className && t.className.indexOf('x-grid3-cc-' + this.id) != -1) {
                e.stopEvent();
                var index = this.grid.getView().findRowIndex(t);
                var record = this.grid.store.getAt(index);
                //alert(record.data.resource_id);
                record.set(this.dataIndex, !record.data[this.dataIndex]);
            }
        },
        
        renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="approved-column x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
        }
    };
    
    var Role = {
        clearForm: function(){
        
        },
        add: function(){
            if (grid.topToolbar.items.get('roleName').getValue() == null ||
            grid.topToolbar.items.get('roleName').getValue() == '') {
                Ext.Msg.alert('Warning', 'Please enter Role name');
                return;
            }
            else {
                var roleName = grid.topToolbar.items.get('roleName').getValue();
                Ext.Ajax.request({
                    url: Quick.baseUrl + Quick.adminUrl + 'test/new-role/role/' + roleName + '/',
                    method: 'get',
                    success: function(result, options){
                        var data = Ext.decode(result.responseText);
						reload();
                    },
                    failure: function(response, request){
                        var data = Ext.decode(response.responseText);
                        if (!data.success) {
                            alert(data.error);
                            return;
                        }
                    }
                });
            }
        },
        
        load: function(selectedFunction){
            Role.clearForm();
            
            $('#div-form-role').css('display', 'block');
            $('#selectedFunction').val(selectedFunction);
            
            Ext.getCmp('grid1').store.load();
            
            roleWin.setTitle('New Role');
            roleWin.show();
            roleWin.doLayout();
        },
        
        edit: function(){
            Role.clearForm();
            
            if (grid.getSelectionModel().selections.items.length > 0) {
                var selectedFunction = grid.getSelectionModel().getSelected().id;
                
                Role.load(selectedFunction);
            }
        }
    };
    /**
     * Custom function used for column renderer
     * @param {Object} val
     */
    function change(val){
        if (val == 'Quick_Accountant') {
            return '<span style="color:green;">' + val + '</span>';
        }
        else 
            if (val == 'Quick_Core') {
                return '<span style="color:red;">' + val + '</span>';
            }
            else 
                if (val == 'Quick_Sale') {
                    return '<span style="color:#33cc00;">' + val + '</span>';
                }
                else 
                    if (val == 'Quick_Purchase') {
                        return '<span style="color:#663366;">' + val + '</span>';
                    }
                    else 
                        if (val == 'Quick_Inventory') {
                            return '<span style="color:#cccc99;">' + val + '</span>';
                        }
        return val;
    }
    
    var record = [{
        name: 'resource_id',
        type: 'string'
    }, {
        name: 'title_key',
        type: 'string'
    }, {
        name: 'package',
        type: 'string'
    }];
    
    for (var langId in Roles.roleValue) {
        if (Roles.roleValue[langId].role_name != undefined) 
            record.push({
                name: Roles.roleValue[langId].role_name,
                type: 'bool'
            });
    }
    
    var test_object = Ext.data.Record.create(record);
    
    var ds = new Ext.data.Store({
        reader: new Ext.data.JsonReader({
            root: 'data',
            totalProperty: 'count',
            id: 'resource_id'
        }, test_object),
        proxy: new Ext.data.HttpProxy({
            url: Quick.baseUrl + Quick.adminUrl + 'test/test-get-resources'
        }),
        sortInfo: {
            field: 'package',
            direction: "ASC"
        },
        autoLoad: false,
        remoteSort: true
        //groupField:'package'
    });
    
    
    var columns = [];
    columns.push({
        header: 'Package',
        dataIndex: 'package',
        //autoWidth: true,
		width: 200,
        renderer: change
    }, {
        header: 'Function',
        dataIndex: 'title_key',
        //autoWidth: true
    });
    var roleArray = [];
    for (var langId in Roles.roleValue) {
        if (Roles.roleValue[langId].role_name != undefined) {
            var role = new Ext.grid.CheckColumn({
                header: Roles.roleValue[langId].role_name,
                dataIndex: Roles.roleValue[langId].role_name,
                //autoWidth: true,
                align: 'center'
            });
            roleArray.push(role);
            columns.push(role);
        }
    }
    var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true
        },
        columns: columns
    });
    
    var tbar = new Ext.Toolbar({
        items: [{
            xtype: 'tbtext',
            text: 'Role Name'
        }, {
            xtype: 'textfield',
            id: 'roleName',
            width: 200
        }, '-', {
            text: 'Add',
            handler: Role.add,
            iconCls: 'x-btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/add.png',
            tooltip: 'Add new Role'
        }, '-', {
            text: 'Edit',
            handler: Role.edit,
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/page_edit.png'
        }, '->', {
            text: 'Reload',
            handler: reload,
            iconCls: 'btn-text-icon',
            icon: Quick.skinUrl + '/images/icons/refresh.png'
        }]
    });
    var grid = new Ext.grid.EditorGridPanel({
        cm: cm,
        id: 'grid',
        title: 'Authenticate',
        height: 300,
        width: 800,
        renderTo: 'test-grid',
        store: ds,
        clicksToEdit: 1,
        loadMask: true,
        trackMouseOver: true,
        viewConfig: {
            forceFit: true,
            deferEmptyText: true,
            emptyText: 'No records found'
        },
        /*view: new Ext.grid.GroupingView({
         forceFit:true,
         groupTextTpl: '{text} ({[values.rs.length]} {[values.rs.length > 1 ? "Items" : "Item"]})'
         }),*/
        frame: true,
        collapsible: true,
        animCollapse: false,
        sm: new Ext.grid.RowSelectionModel({
            singleSelect: true
        }),
        plugins: roleArray,
        tbar: tbar
    });
    grid.on('rowdblclick', Role.edit);
    Ext.getCmp('grid').store.load();
    
    Ext.QuickTips.init();
    
    // functions
    function reload(){
        Ext.getCmp('grid').store.load();
		//grid.render();
    }
    
    var tabsWraper = new Ext.Panel({
        region: 'center',
        collapsible: false,
        border: false,
        layout: 'fit',
        contentEl: 'div-form-role',
        autoScroll: true
    });
    
    /* Creating popup windows */
    roleWin = new Ext.Window({
        items: [tabsWraper], //tabPanel, created in form-product.phtml
        layout: 'border',
        constrainHeader: true,
        width: 830,
        height: 300,
        closeAction: 'hide',
        maximizable: true,
        border: false,
        buttons: [{
            text: 'Close',
            handler: function(){
                roleWin.hide();
            }
        }]
    });
});
