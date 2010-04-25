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
		//$this->view->pageTitle = Quick::translate('Core')->__('Home');
		$this->view->pageTitle = _('Home');


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
		if ($this->_hasParam('getLoadData')){

			return $this->_helper->json->sendSuccess(array(
	            'data' => array_values(Quick_Core_Remoter_IndexRemoter::getResources())
			));
		}
		$this->render();
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
			$result[] = Quick::single('core/acl_rule')->editRule($resourceId, $roleId, $value);
		} else {
			Quick::message()->addError('Invalid parameter recieved. Parameters is required');
			return $this->_helper->json->sendFailure();
		}

		$this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
		));
	}

	public function editRuleResourceAction()
	{
		$resourceId = Zend_Json_Decoder::decode($this->_getParam('resourceId'));
		$roleId = Zend_Json_Decoder::decode($this->_getParam('roleId'));
		$field = Zend_Json_Decoder::decode($this->_getParam('field'));
		$value = Zend_Json_Decoder::decode($this->_getParam('value'));
		$result = array();
		$this->layout->disableLayout();
		if ($this->_hasParam('roleId') && $this->_hasParam('resourceId') &&
		$this->_hasParam('value') && $this->_hasParam('value')) {
			$result[] = Quick::single('core/acl_rule')->editRuleOfResource($resourceId, $roleId, $value, $field);
		} else {
			Quick::message()->addError('Invalid parameter recieved. Parameters is required');
			return $this->_helper->json->sendFailure();
		}

		$this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
		));
	}
}