Ext.onReady(function(){

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
        	if(t.className && t.className.indexOf('x-grid3-cc-'+this.id) != -1){
	            e.stopEvent();				
	            var index = this.grid.getView().findRowIndex(t);
	            var record = this.grid.store.getAt(index);
				alert(record.data.resource_id);
	            record.set(this.dataIndex, !record.data[this.dataIndex]);	            
	        }
        },
        
        renderer: function(v, p, record){
            p.css += ' x-grid3-check-col-td';
            return '<div class="approved-column x-grid3-check-col' + (v ? '-on' : '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
        }
    };
    
	/**
     * Custom function used for column renderer
     * @param {Object} val
     */
    function change(val){
        if(val == 'Quick_Accountant'){
            return '<b><span style="color:green;">' + val + '</span></b>';
        }else if(val == 'Quick_Core'){
            return '<b><span style="color:red;">' + val + '</span></b>';
        }else if(val == 'Quick_Sale'){
            return '<b><span style="color:#33cc00;">' + val + '</span></b>';
        }else if(val == 'Quick_Purchase'){
            return '<b><span style="color:#663366;">' + val + '</span></b>';
        }
		else if(val == 'Quick_Inventory'){
            return '<b><span style="color:#cccc99;">' + val + '</span></b>';
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
            id: 'code'
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
        autoWidth: true,
		renderer: change
    }, {
        header: 'Function',
        dataIndex: 'title_key',
        autoWidth: true
    });
    var role = new Ext.grid.CheckColumn({
        header: 'Administrator',
        dataIndex: 'Administrator',
        autoWidth: true
    });
    var roleArray = [];
    for (var langId in Roles.roleValue) {
        if (Roles.roleValue[langId].role_name != undefined) {
            var role = new Ext.grid.CheckColumn({
                header: Roles.roleValue[langId].role_name,
                dataIndex: Roles.roleValue[langId].role_name,
                autoWidth: true
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
    
    var grid = new Ext.grid.EditorGridPanel({
        cm: cm,
        id: 'grid',
        title: 'Authenticate',
        height: 500,
        width: 800,
        renderTo: 'test-grid',
        store: ds,
        clicksToEdit: 1,
        loadMask: true,
        trackMouseOver: true,
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
		plugins: roleArray
    });
    
    Ext.getCmp('grid').store.load();
    
    Ext.QuickTips.init();
});
