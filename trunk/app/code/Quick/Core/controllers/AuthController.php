<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class AuthController extends Quick_Core_Controller_Back
{
	public function init()
    {
    	$this->_disableAcl = true;
    	$this->_disableAuth = true;
    	parent::init();        
    }
    
    public function indexAction()
    {
    	$this->_helper->layout->disableLayout();
    	if ($this->_hasParam('messages')) {
            $this->view->messages = $this->_getParam('messages');
        }
        $this->render('login');
    }
    
	public function loginAction()
    {
    	$this->_helper->layout->disableLayout();
    	$username = $this->_getParam('username');
        $password = $this->_getParam('password');
    	$auth = Zend_Auth::getInstance();
    	$authAdapter = new Quick_Auth_AdminAdapter($username, $password);
    	
    	$result = $auth->authenticate($authAdapter);
    	
    	if (!$result->isValid()) {
            Quick::dispatch('admin_user_login_failed', array('username' => $username));
            $this->_redirect($_SERVER['HTTP_REFERER']);
        } else {
            Quick::dispatch('admin_user_login_success', array('username' => $username));
            Quick::session()->roleId = Quick::single('general/user')->getRole($result->getIdentity());
            $this->_redirect($_SERVER['HTTP_REFERER']);
        }
    }
    
	public function logoutAction()
    {
        Zend_Auth::getInstance()->clearIdentity();
        unset(Quick::session()->roleId);
        $this->_redirect(Quick::config()->system->adminurl);
    }
    
    public function rolePermissionAction(){
    	$this->view->pageTitle = 'Role Permission';
        $roles = Quick::single('core/acl_role')->getRoles();
        $this->view->roles = $roles;
        $this->render();        
    }
}