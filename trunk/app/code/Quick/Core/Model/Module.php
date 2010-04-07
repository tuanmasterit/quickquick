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
     
}