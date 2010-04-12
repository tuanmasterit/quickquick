<?php
/**
 * 
 * @category    Quick
 * @package     Quick_General
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_General_Model_User extends Quick_Db_Table
{    
    protected $_name = 'admin_user';
    
    public function getRole($id){
    	return $this->getAdapter()->fetchOne("SELECT role_id FROM {$this->_name} WHERE id = ?", $id);
    }
}