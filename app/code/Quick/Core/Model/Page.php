<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Page extends Quick_Db_Table
{
    /**
     * The default table name 
     */
    protected $_name = 'core_page';

    /**
     *
     * @return int
     */
    public function getCount()
    {
        return $this->count();
    }

    /**
     *
     * @param bool $likeString [optional]
     * @return array
     */
    public function getPages($likeString = false)
    {
        $pages = array();
        $pagesRowset = $this->fetchAll(
            null, array('module_name', 'controller_name', 'action_name')
        )->toArray();
        foreach ($pagesRowset as $page) {
            if ($likeString){
                $pages[$page['id']] = $page['module_name'] . '/' 
                     . $page['controller_name'] . '/'
                     . $page['action_name'];
            } else {
                $pages[$page['id']] = array(
                    'module' => $page['module_name'],
                    'controller' => $page['controller_name'],
                    'action' => $page['action_name']
                );
            }
        }
        return $pages;
    }
    
    /**
     * call in library/Quick/Layout.php
     * @param string module name
     * @param string controller name
     * @param string action name 
     * @return array
     */
    public function getPagesByRequest($module = '*', $controller = '*', $action = '*')
    {
        if (strpos($module, '/')) {
            $request = explode('/', $module);
            $module = $request[0];
            $controller = $request[1];
            $action = $request[2];
        }
        return $this->getAdapter()->fetchAssoc(
            "SELECT * FROM {$this->_name} " . 
            "WHERE module_name IN('*', ?) AND controller_name IN('*', ?) AND action_name IN('*', ?) ",
             array($module, $controller, $action)
        );
    }

    /**
     *
     * @param string $request [optional]
     * @return string
     */
    public function getPageIdByRequest($request = '*/*/*')
    {
        $request = explode('/', $request);
        $module = $request[0];
        $controller = isset($request[1]) ? $request[1] : '*';
        $action = isset($request[2]) ? $request[2] : '*';

        return $this->fetchOne(
            'id', 
            "module_name = ? AND controller_name = ? AND action_name = ?",
             array($module, $controller, $action)
        );
    
    }
    
    /**
     * Remove pages 
     * Provide fluent interface
     * @param string $module
     * @param string $controller
     * @param string $action
     * @return int
     */
    public function remove($module = '*', $controller = '*', $action = '*')
    {
        if (strpos($module, '/')) {
            $request = explode('/', $module);
            $module = $request[0];
            $controller = $request[1];
            $action = $request[2];
        }
        
        $this->delete(
            "module_name = '{$module}' AND controller_name = '{$controller}' AND action_name = '{$action}'"
        );
        return $this;
    }
    
    /**
     * Save or insert page data
     * 
     * @param array $data ('module_name' =>, 'controller_name' =>, 'action_name' =>)
     * @return bool
     */
    public function save($data)
    {
        if (!sizeof($data)) {
            Quick::message()->addError(
                Quick::translate('core')->__(
                    'No data to save'
            ));
            return false;
        }
        
        foreach ($data as $id => $row) {
            if (isset($row['id'])) {
                $this->update(
                    array(
                        'module_name' => $row['module_name'],
                        'action_name' => $row['action_name'],
                        'controller_name' => $row['controller_name']
                    ), 
                    'id = ' . intval($id)
                );
            } else {
                $this->insert(array(
                    'module_name' => $row['module_name'],
                    'action_name' => $row['action_name'],
                    'controller_name' => $row['controller_name']
                ));
            }
        }

        Quick::message()->addSuccess(
            Quick::translate('core')->__(
                'Data was saved successfully'
        ));
        return true;
    }
    
    /**
     * Add page if not exist
     * Provide fluent interface
     * @return bool
     */
    public function add($request = '*/*/*')
    {
        if ($this->getPageIdByRequest($request)) {
            return $this;
        }
        $request = explode('/', $request);
        
        $this->insert(array(
            'module_name' => $request[0],
            'controller_name' => $request[1],
            'action_name' => $request[2]
        ));
        return $this;
    }
}
