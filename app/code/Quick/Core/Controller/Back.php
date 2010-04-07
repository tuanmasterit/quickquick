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
        /*$this->view->adminUrl = '/' . trim(
            Quick::config()->main->store->adminRoute, '/ '
        );

        Zend_Auth::getInstance()->setStorage(
            new Zend_Auth_Storage_Session('admin')
        );
        
        $this->acl = Quick::single('admin/acl');
        if (!empty(Quick::session()->roleId)) {
            $this->acl->loadRules(Quick::session()->roleId);
        }*/
    }
    
    public function preDispatch()
    {
        /*$url = Quick::getCurrentUrl();
        if (Quick::config()->main->store->useBackendSsl &&
            substr($url, 0, strlen('https://')) != 'https://') {

            parent::_redirect('https://' . substr($url, strlen('http://')));
            die();
        }
        $this->auth();
        $this->checkPermission();*/
    }

    public function auth()
    {
        if (!$this->_disableAuth) {
            if (!Zend_Auth::getInstance()->hasIdentity()) {
                if ($this->getRequest()->isXmlHttpRequest()) {
                    Quick::message()->addError('Your session has been expired. Please relogin');

                    $this->_helper->json->sendFailure();

                    die();
                    // Zend_Controller_Action_Helper_Json if $suppressExit = true;
                }
                $this->_forward('index', 'auth', 'Quick_Admin');
            } elseif (!Quick::single('admin/user')->find(
                    Zend_Auth::getInstance()->getIdentity())->current()) {
                $this->view->action('logout', 'auth', 'Quick_Admin');
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
        //$controller = str_replace('_', '/', $request->getControllerName());
        $controller = $request->getControllerName();
        $role = Quick::session()->roleId;
        $resourceIds = explode('/', "admin/$controller/$action");
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
        
        $this->_forward('access-denied', 'informer', 'Quick_Admin');
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