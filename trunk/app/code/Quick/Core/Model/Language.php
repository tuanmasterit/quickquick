<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Locale
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Language extends Quick_Db_Table
{
    protected $_name = 'core_language';
    protected $_rowClass = 'Quick_Db_Table_Row';
    
    protected $_localeList = null;
    
    public function getLocaleList()
    {
        if (null === $this->_localeList) {
            $this->_localeList = $this->getAdapter()->fetchCol("SELECT locale FROM {$this->_name}");
        }
        return $this->_localeList;
    }
    
	/**
     * Get list of manufacturers on all available languages
     * @return array
     */
    public function getAllList()
    {
        return $this->getAdapter()->fetchAll("
            SELECT lg.* 
            FROM " . $this->_name . " AS lg
        ");
    }
}