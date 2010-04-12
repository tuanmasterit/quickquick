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
    protected $_name = 'core_module';
    
    private $_processed_modules = null;
    
    /**
     * Retrieve array of installed modules
     * 
     * @return array
     */
    public function getList($where = null)
    {
        $query = "SELECT cm.code, cm.*
            FROM {$this->_name} AS cm";
        
        if (null !== $where) {
            $query .= " WHERE {$where}";
        }
        
        return $this->getAdapter()->fetchAssoc($query);
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