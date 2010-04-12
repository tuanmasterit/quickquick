<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Acl extends Zend_Acl
{
	protected $_table;
    private $_rescs;
    
    private function _loadResources(){
    	foreach ($this->getResources() as $resource){
    	if (false !== ($pos = strrpos($resource['resource_id'], '/'))) {
                $parentId = substr($resource['resource_id'], 0, $pos);
            } else {
                $parentId = null;
            }
            $this->add(new Zend_Acl_Resource($resource['resource_id']), $parentId);
    	}
    }
    
    public function __construct(){
    	$this->_table = Quick::single('core/acl_role');
    	$this->_loadResources();
    }
    
    public function getResources(){
    	if(null === $this->_rescs){
    		$this->_rescs = Quick::single('core/acl_resource')->fetchAll(null, 'resource_id ASC')->toArray();
    	}
    	return $this->_rescs;
    }
}