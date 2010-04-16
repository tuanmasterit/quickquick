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
    			$resources[$i][$role['role_name']] = "0";
    		}
    		$i++;
        }
        $rules = Quick::single('core/acl_rule')->getRulesWithRoles();
        $i = 0;
    	foreach ($resources as $resource) {
    		foreach ($rules as $rule) {
    			if (($resource['resource_id'] == $rule['resource_id']) && ($rule['permission'] == 'allow'))
    				$resources[$i][$rule['role_name']] = "1";
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
}