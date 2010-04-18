<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class IndexController extends Quick_Core_Controller_Back
{
	public function init()
    {
    	parent::init();        
    }
    
    public function indexAction()
    {
        $this->view->pageTitle = Quick::translate('Core')->__('Home');
                
        $this->render();
    }
    
	public function testAction()
    {
        $this->view->pageTitle = 'test';
    
        $this->render();
    }
    
	public function listAction()
    {
    	$result = array();
    	foreach (Quick::single('core/language')->getAllList() as $language) {
            
            if (!isset($result[$language['id']])) {
                $result[$language['id']] = $language;
            }
        }
    	
    	return $this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
        ));
    }
    
	public function testAuthAction()
    {
        $this->view->pageTitle = 'test-auth';
        $roles = Quick::single('core/acl_role')->getRoles();
        $this->view->roles = $roles;
        $this->render();
    }
    
	public function testGetResourcesAction()
    {
        $result = array();
        $resources = Quick::single('core/acl_resource')->getResources();    	
        $roles = Quick::single('core/acl_role')->getRoles();
        $i = 0;
    	foreach ($resources as $resource) {
    		foreach ($roles as $role) {
    			$resources[$i][$role['role_name']] = "";
    		}
    		$i++;
        }
        $rules = Quick::single('core/acl_rule')->getRulesWithRoles();
        $i = 0;
    	foreach ($resources as $resource) {
    		foreach ($rules as $rule) {
    			if (($resource['resource_id'] == $rule['resource_id']) && ($rule['permission'] == 'allow'))
    				$resources[$i][$rule['role_name']] = "allow";
    		}
    		$i++;
        }
    	foreach ($resources as $resource) {
            
            if (!isset($result[$resource['resource_id']])) {
                $result[$resource['resource_id']] = $resource;
            }
        }
    	return $this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
        ));
    }
    
	public function editRoleAction()
    {
        $this->view->pageTitle = 'edit-role';
    	
        $this->render();
    }
    
	public function getRulesOfResourceAction()
    {
        $result = array();
        $resources = Quick::single('core/acl_rule')->getRulesOfResource($_POST['selectedFunction']);
        
    	foreach ($resources as $resource) {
            $result[] = $resource;            
        }
    	return $this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
        ));
    }
    
	public function newRoleAction()
    {
    	$result = array();
    	$this->layout->disableLayout();
        if ($this->_hasParam('role')) {
            $role = $this->_getParam('role');
            $result[] = Quick::single('core/acl_role')->save(array('id'=>-1, 'role_name'=>$role));
        } else {
            Quick::message()->addError('Invalid parameter recieved. ProductId is required');
            return $this->_helper->json->sendFailure();
        }
        
        $this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
        ));
    }
    
	public function editRuleAction()
    {
    	$resourceId = Zend_Json_Decoder::decode($this->_getParam('resourceId'));
    	$roleId = Zend_Json_Decoder::decode($this->_getParam('roleId'));
    	$value = Zend_Json_Decoder::decode($this->_getParam('value'));
    	$result = array();
    	$this->layout->disableLayout();
        if ($this->_hasParam('roleId') && $this->_hasParam('resourceId') && $this->_hasParam('value')) {
            $result[] = Quick::single('core/acl_rule')->editRulesOfResource($resourceId, $roleId, $value);
        } else {
            Quick::message()->addError('Invalid parameter recieved. Parameters is required');
            return $this->_helper->json->sendFailure();
        }
        
        $this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
        ));    	
    }
}