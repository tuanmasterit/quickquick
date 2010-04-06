<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 * @abstract
 */
abstract class Quick_Controller_Action extends Zend_Controller_Action
{
    protected $_lang;
    protected $_langId;
    protected $_siteId;
    protected $_nsMain;

    /**
     *
     * @param  string $app
     * @return string
     */
    private function _getScriptsPath($app)
    {
        if ('front' === $app) {
            list($category, $module) = explode(
                '_', strtolower($this->getRequest()->getModuleName()), 2
            );
        } else {
            $controller = $this->getRequest()->getControllerName();
            $module = false === strpos($controller, '_') ?
                'core' : current(explode('_', $controller));
        }
        return $module;
    }
    
    /**
     * Initialize View object
     * 
     * @return Zend_View_Interface
     * @see Zend_Controller_Action initView() 
     */
    public function initView($app = null, array $template = null)
    {
        if (null === $app) {
            $app = Zend_Registry::get('app');
        }
        if (null === $template) {
            $template = Quick::getTemplate($app);
        }        
        //$view = parent::initView();
        require_once 'Zend/View/Interface.php';
        if (!$this->getInvokeArg('noViewRenderer') 
            && $this->_helper->hasHelper('viewRenderer')) {

            $view = $this->view;
        } elseif (isset($this->view)
            && ($this->view instanceof Zend_View_Interface)) {

            $view = $this->view;
        } else {
            require_once 'Zend/View.php';
            $view = new Zend_View();
        }
        
        $this->view = $view;

        $systemPath = Quick::config()->system->path;

        $view->templateName = $template['name'];
        $view->applicationName = $app;
        $module = $this->getRequest()->getModuleName();
        list($category, $module) = explode('_', $module, 2);
        $view->moduleCategory = $category;
        $view->moduleName = $module;

        $view->path = $systemPath;
        $view->skinPath = $systemPath 
                        . '/skin/'
                        . $app . '/'
                        . $template['name'];
		
        $dbBaseUrl = Quick::single('core/site')->getBaseUrlByUrl(
            Quick::getCurrentUrl()
        );
        $view->baseUrl = $dbBaseUrl ?
            $dbBaseUrl : Zend_Controller_Front::getInstance()->getBaseUrl();
        $view->catalogUrl = Quick::config()->catalog->main->catalogRoute;
        $view->skinUrl = $view->baseUrl . '/skin/'
            . $app . '/' . $template['name'];
        //@todo every template shoud have own defaults
        $view->defaultTemplate = 'default'; 
        
        /* for use in ->render('../[script.php]')  */
        $view->setLfiProtection(false);
        
        //Initialize Zend_View stack 
        $module = $this->_getScriptsPath($app);

        $view->addFilterPath(
            $systemPath . '/library/Quick/View/Filter', 'Quick_View_Filter'
        );
        $view->addHelperPath(
            $systemPath . '/library/Quick/View/Helper', 'Quick_View_Helper'
        );

        $templatePath = $systemPath
                      . '/app/design/'
                      . $app . '/'
                      . $template['name'];

        $view->addHelperPath($templatePath . '/helpers', 'Quick_View_Helper');
        $view->addScriptPath($templatePath . '/templates');
        $view->addScriptPath($templatePath . '/templates/' . $module);

        if ($template['name'] !== $view->defaultTemplate) {
            $templatePath = $systemPath
                          . '/app/design/'
                          . $app . '/'
                          . $view->defaultTemplate;

            $view->addHelperPath(
                $templatePath . '/helpers', 'Quick_View_Helper'
            );
            $view->addScriptPath($templatePath . '/templates');
            $view->addScriptPath($templatePath . '/templates/' . $module);
            $view->addScriptPath($templatePath . '/layouts');
        }

        //for compatibility
        $viewRenderer = Zend_Controller_Action_HelperBroker::getStaticHelper(
            'viewRenderer'
        );
        $viewRenderer->setView($view);

        return $view;
    }
    
    /**
     * Init layout
     */
    public function initLayout(
        $view = null, $app = null, array $template = null)
    {
        if (null === $view) {
            $view = $this->view;
        }
        if (null === $app) {
            $app = Zend_Registry::get('app');
        }
        if (null === $template) {
            $template = Quick::getTemplate($app);
        }
        
        $this->layout = Quick_Layout::getMvcInstance();
        
        $this->layout->setView($view)->setOptions(array('layoutPath' =>
                Quick::config()->system->path
                . '/app/design/'
                . $app . '/'
                . $template['name']
                . '/layouts'
        ));

        return $this->layout;
    }
    
    /**
     *  Main init
     */
    public function init()
    {    	
        parent::init();        
        $this->_nsMain = Quick::session();
        $this->config = Quick::config();
        $this->c = Quick::config();
        $this->db = Quick::db();
        
        $module = $this->getRequest()->getParam('module'); // = $this->getRequest()->getModuleName()
        $app = ($module === 'Quick_Admin') ? 'admin' : 'front';
        Zend_Registry::set('app', $app);
        
        $template = Quick::getTemplate($app);
        $this->initView($app, $template);
        $this->initLayout($this->view, $app, $template);
        $this->_siteId = Quick::getSiteId();
        
        if ($app == 'front') {
            if ($this->_hasParam('locale') 
                && Quick_Controller_Router_Route::hasLocaleInUrl()) {

                Quick_Locale::setLocale($this->_getParam('locale'));
            }
        } else {
            $locale = isset(Quick::session()->locale) ? 
                Quick::session()->locale : Quick_Locale::getDefaultLocale();
            Quick_Locale::setLocale($locale);
        }
        $this->_langId = Quick_Locale::getLanguageId();

        //Quick_Translate::getInstance();
		
        // setting default meta tags 
        $this->view->meta()->setDefaults();

        $this->view->doctype('XHTML1_STRICT');

        $this->view->setEncoding('UTF-8');
		
        //$this->_helper->removeHelper('json');
        $this->_helper->addHelper(new Quick_Controller_Action_Helper_Json());
        
    }
    
    /**
     * Write a snapshot to session
     * 
     * @param string $snapshot
     * @return void
     */
    protected function _setSnapshot($snapshot)
    {
        Quick::session()->snapshot = $snapshot;
    }
    
    /**
     * Retrieve snapshot from session
     * 
     * @return string
     */
    protected function _getSnapshot()
    {
        $snapshot = Quick::session()->snapshot;
        unset(Quick::session()->snapshot);
        return $snapshot;
    }
    
    /**
     * @return bool
     */
    protected function _hasSnapshot()
    {
        return isset(Quick::session()->snapshot)
            && !empty(Quick::session()->snapshot);
    }

    /**
     * Return module name
     *
     * @return string
     */
    public function getModule()
    {
        list($category, $module) =  explode('_', get_class($this));
        return $category . '_' . $module;
    }

    /**
     *
     * @return Quick_Translate
     */
    public function translate($module = null)
    {
        if (null === $module) {
            $module = $this->getModule();
        }
        return Quick_Translate::getInstance($module);
    }

    /**
     * Translate 
     *
     * @return string
     */
    public function __()
    {
        return Quick_Translate::getInstance(
            $this->getModule()
        )->translate(func_get_args());
    }
}