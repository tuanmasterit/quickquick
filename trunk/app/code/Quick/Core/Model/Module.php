<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Module extends Quick_Db_Table
{    
    protected $_name 						= 'definition_list_module';
    protected $_TABLE_CORE_MODULE_LANGUAGE 	= 'core_module_language';
    protected $_TABLE_CORE_LANGUAGE 		= 'core_language';
    
    private $_processed_modules = null;
    
    /**
     * Retrieve array of installed modules
     * 
     * @return array
     */
    public function getList($where = null)
    {
        $query = "SELECT cm.package  
            FROM {$this->_name} AS cm ";
        
        if (null !== $where) {
            $query .= " WHERE {$where}";
        }
        
        $query .= ' ORDER BY load_route_order ASC';
        
        return $this->getAdapter()->fetchAssoc($query);
    }
    
	/**
     * Retrieve array of installed modules
     * 
     * @return array
     */
    public function getListModules($locale)
    {    	
    	$select = $this->getAdapter()->select();
		$select->from(
		array('cm' => $this->_name),
		array('cm.module_id', 'cm.package', 'cm.module_action'))
		->joinLeft(
				array('cml' => $this->_TABLE_CORE_MODULE_LANGUAGE),
				"cml.record_id = cm.module_id", 
				array('cml.language_id', 'cml.value'))
		->joinLeft(
				array('cl' => 'core_language'), 
				"cl.id = cml.language_id", 
				array())
		->where('cm.inactive = ?', 0)
		->where('cl.locale = ?', $locale)
		->where('cml.table_name = ?', $this->_name)
		->order('cm.display_order');

		return $this->getAdapter()->fetchAll($select->__toString());
    }
    
    /**
     * Retrieve the config of module
     * 
     * @param string $module
     * @return mixed(array|boolean)
     */
    public function getConfig($module = null)
    {
        if (null === $module) {
        	if (!$result = Quick::cache()->load('quick_modules_config')) {
        		$modules = Quick::getModules();        		
                $result = array();
                foreach ($modules as $moduleCode => $path) {
                    if (file_exists($path . '/etc/config.php') 
                        && is_readable($path . '/etc/config.php')) {
                        
                        include_once($path . '/etc/config.php');
                        if (!isset($config)) {
                            continue;
                        }
                        $result += $config;
                    }
                }
                Quick::cache()->save(
                    $result, 'quick_modules_config', array('modules')
                );
        	}
        	$config = $result;
        } else {
            list($category, $module) = explode('_', $module, 2);
            $configFile = Quick::config()->system->path . '/app/code/'
                . $category . '/' . $module . '/etc/config.php';
    
            if (!is_file($configFile)) {
                return false;
            }
                
            include($configFile);
            
            if (!isset($config)) {
                return false;
            }
        }
        return $config;
    }
}