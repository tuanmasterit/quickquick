<?php
/**
 *
 * @category    Quick
 * @package     Quick_Admin
 * @subpackage  Controller
 * @author      trungpm
 * @abstract
 */
abstract class Quick_Core_Controller_Back extends Quick_Controller_Action
{
	/**
	 * Acl
	 * @var Quick_Acl
	 */
	public $acl;

	/**
	 *
	 * @var bool
	 */
	protected $_disableAuth = false;

	/**
	 *
	 * @var bool
	 */
	protected $_disableAcl  = false;

	public function init()
	{
		parent::init();
		$this->view->themeStyle = Quick::config()->main->store->defaultTheme;
		$this->view->companyName = Quick::config()->main->store->companyName;
		$this->view->defaultDateTime = Quick::config()->main->store->defaultDateTime;
		$this->view->adminUrl = Quick::config()->system->adminurl;
		$locale = Quick_Locale::getLocale()->toString();
		$module = $this->getRequest()->getModuleName();
		$configModule = Quick::single('core/module')->getConfig($module);
		$this->view->moduleId = $configModule[$module]['idInDb'];

		$this->view->mainMenu = Quick::single('core/module')->getListModules($locale);
		$i=0;
		$longest_module_name = 0;
		while ($i < count($this->view->mainMenu)){
			if (mb_strlen($this->view->mainMenu[$i]['value'],'UTF-8')>$longest_module_name)
			$longest_module_name = mb_strlen($this->view->mainMenu[$i]['value'],'UTF-8');
			$i++;
		}
		$i=0;
		while ($i < count($this->view->mainMenu)){
			$this->view->mainMenu[$i]['spaceLenght'] = Quick_Miscfunction::spaceToMakeTheSameWidth($this->view->mainMenu[$i]['value'],$longest_module_name,'&nbsp;');
			$i++;
		}

		if($this->view->isSetMenu){
			$this->view->executionMenu = Quick::single('core/execution')->getListExecutions($this->view->moduleId, $locale);
			$i=0;
			$longest_module_name = 0;
			while ($i < count($this->view->executionMenu)){
				if (mb_strlen($this->view->executionMenu[$i]['value'],'UTF-8')>$longest_module_name)
				$longest_module_name = mb_strlen($this->view->executionMenu[$i]['value'],'UTF-8');
				$i++;
			}
			$i=0;
			while ($i < count($this->view->executionMenu)){
				$this->view->executionMenu[$i]['spaceLenght'] = Quick_Miscfunction::spaceToMakeTheSameWidth($this->view->executionMenu[$i]['value'],$longest_module_name,'&nbsp;');
				$i++;
			}
		}

		Zend_Auth::getInstance()->setStorage(
		new Zend_Auth_Storage_Session('admin')
		);
		$this->view->startTime = microtime(true);
		$this->acl = Quick::single('core/acl');
		// lock authenticate function
		//if (!empty(Quick::session()->roleId)) {
		$this->view->userName = 'admin';
		Quick::session()->roleId = 2;
		$this->acl->loadRules(Quick::session()->roleId);
		//}
	}

	public function preDispatch()
	{
		//$this->auth();
		$this->checkPermission();
	}

	public function auth()
	{
		if (!$this->_disableAuth) {
			if (!Zend_Auth::getInstance()->hasIdentity()) {
				if ($this->getRequest()->isXmlHttpRequest()) {
					Quick::message()->addError('Your session has been expired. Please relogin');
					//$this->_helper->json->sendFailure();
					die();
				}
				$this->_forward('index', 'auth', 'Quick_Core');
			} elseif (!Quick::single('general/user')->find(
			Zend_Auth::getInstance()->getIdentity())->current()) {
				$this->view->action('logout', 'auth', 'Quick_Core');
			}
		}
	}

	public function checkPermission()
	{
		if ($this->_disableAcl) {
			return true;
		}

		$request = $this->getRequest();

		$action = $request->getActionName();
		list($category, $module) = explode(
                '_', strtolower($request->getModuleName()), 2
		);
		$controller = $request->getControllerName();
		$role = Quick::session()->roleId;
		echo "$module/$controller/$action";
		$resourceIds = explode('/', "$module/$controller/$action");

		// admin is the name of parent resource_id

		while (count($resourceIds)) {
			$resourceId = implode('/', $resourceIds);
			if ($this->acl->has($resourceId)) {
				if ($this->acl->isAllowed($role, $resourceId)) {
					return true;
				} else {
					break;
				}
			}
			array_pop($resourceIds);
		}

		if ($request->isXmlHttpRequest()) {
			Quick::message()->addError('You have no permission for this operation');

			$this->_helper->json->sendFailure();

			die(); // Zend_Controller_Action_Helper_Json if $suppressExit = true;
		}

		$this->_forward('access-denied', 'informer', 'Quick_Core');
		return false;
	}

	/**
	 * Set "actionName to aclResource" assignment
	 *
	 * Assignment used for auto-checkPermission in preDispatch method
	 *
	 * Use this method in init() method
	 *
	 * Example:
	 * setActionToAclAssignment(array(
	 *  'index' => 'admin/site/view',
	 *  'edit'  => 'admin/site/edit'
	 * ))
	 *
	 * @param array
	 */
	public function setActionToAclAssignment($assignment)
	{
		$this->_aclAssignment = $assignment;
	}

	/**
	 * Redirect to another URL. Adds adminRoute by default to given $url parameter
	 *
	 * @param string $url
	 * @param bool $addAdmin
	 * @param array $options Options to be used when redirecting
	 * @return void
	 */
	//@todo */*/* === referer , */*/otherAction
	protected function _redirect($url, array $options = array(), $addAdmin = true)
	{
		if ((isset($_SERVER['HTTP_REFERER'])
		&& $url == $_SERVER['HTTP_REFERER']) || !$addAdmin) {

			parent::_redirect($url, $options);
		}

		parent::_redirect($this->view->adminUrl . '/' . ltrim($url, '/ '), $options);
	}
}