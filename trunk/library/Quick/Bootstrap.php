<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick_Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
	protected function _initEnviroment()
    {    	
        date_default_timezone_set('UTC');
        error_reporting(E_ALL | E_STRICT);
        /**
         * Custom error handler E_ALL to Exception
         *
         * @param integer $errno
         * @param string $errstr
         * @param string $errfile
         * @param integer $errline
         */
        function QuickErrorHandler($errno, $errstr, $errfile, $errline)
        {
            $errno = $errno & error_reporting();
            if ($errno == 0) {
                return false;
            }
            if (!defined('E_STRICT')) {
                define('E_STRICT', 2048);
            }
            if (!defined('E_RECOVERABLE_ERROR')) {
                define('E_RECOVERABLE_ERROR', 4096);
            }

            $errorMessage = '';

            switch($errno){
                case E_ERROR:
                    $errorMessage .= "Error";
                    break;
                case E_WARNING:
                    $errorMessage .= "Warning";
                    break;
                case E_PARSE:
                    $errorMessage .= "Parse Error";
                    break;
                case E_NOTICE:
                    $errorMessage .= "Notice";
                    break;
                case E_CORE_ERROR:
                    $errorMessage .= "Core Error";
                    break;
                case E_CORE_WARNING:
                    $errorMessage .= "Core Warning";
                    break;
                case E_COMPILE_ERROR:
                    $errorMessage .= "Compile Error";
                    break;
                case E_COMPILE_WARNING:
                    $errorMessage .= "Compile Warning";
                    break;
                case E_USER_ERROR:
                    $errorMessage .= "User Error";
                    break;
                case E_USER_WARNING:
                    $errorMessage .= "User Warning";
                    break;
                case E_USER_NOTICE:
                    $errorMessage .= "User Notice";
                    break;
                case E_STRICT:
                    $errorMessage .= "Strict Notice";
                    break;
                case E_RECOVERABLE_ERROR:
                    $errorMessage .= "Recoverable Error";
                    break;
                default:
                    $errorMessage .= "Unknown error ($errno)";
                    break;
            }

            $errorMessage .= ": {$errstr}  in {$errfile} on line {$errline}";

            throw new Exception($errorMessage);
        }
        set_error_handler('QuickErrorHandler');
    }
    
	protected function _initLoader()
    {
        $this->bootstrap('Enviroment');
        require_once 'Zend/Loader/Autoloader.php';
        $autoloader = Zend_Loader_Autoloader::getInstance();
        $autoloader->registerNamespace(array(
            'Quick'
        ));
        return $autoloader;
    }
    
	protected function _initConfig()
    {
        $this->bootstrap('Loader');
        require_once QUICK_ROOT . '/app/etc/config.php';
        Zend_Registry::set('config', new Quick_Config($config, true));
        return Quick::config();
    }
    
	protected function _initSession()
    {
        $cacheDir = QUICK_ROOT . '/var/sessions';
        if (!is_readable($cacheDir)) {
            mkdir($cacheDir, 0777);
        } elseif(!is_writable($cacheDir)) {
            chmod($cacheDir, 0777);
        }
        Zend_Session::start();
        Zend_Session::setOptions(array(
            'cookie_lifetime' => 864000, // 10 days
            'name' => 'quickid',
            'strict' => 'off',
            'save_path' => $cacheDir
        ));
        Zend_Registry::set('nsMain', new Zend_Session_Namespace());
        return Quick::session();
    }
    
	protected function _initView()
    {
        $this->bootstrap('Session');
        /**
         * Init Layouts
         */
        return Quick_Layout::startMvc();     
    }
    
	protected function _initDbAdapter()
    {
        $this->bootstrap('Config');
        $db = Zend_Db::factory('Pdo_Mysql', array(
            'host'      => Quick::config()->db->host,
            'username'  => Quick::config()->db->username,
            'password'  => Quick::config()->db->password,
            'dbname'    => Quick::config()->db->dbname,
            'driver_options'=> array(
                PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES UTF8'
            )
        ));
        $profiler = new Zend_Db_Profiler_Firebug('All DB Queries');
        $profiler->setEnabled(true);
        $db->setProfiler($profiler);

        //Set default adapter for childrens Zend_Db_Table_Abstract
        Zend_Db_Table_Abstract::setDefaultAdapter($db);

        Zend_Registry::set('db', $db);
        return Quick::db();
    }
    
	protected function _initCache()
    {
        if (null === Quick::db()) {
            $this->bootstrap('DbAdapter');
        }
        //create default cache
        $cache = Quick_Core_Model_Cache::getCache();
        //create database metacache
        Zend_Db_Table_Abstract::setDefaultMetadataCache($cache);
  
        return Quick::cache();
    }
    
	protected function _initLocale()
    {
        $this->bootstrap('Cache');
        $defaultLocale = Quick_Locale::getDefaultLocale();
        $locales = Quick_Locale::getLocaleList(true);
        
        //set default timezone affect on date() and Quick_Date
        Quick_Locale::setTimezone(Quick_Locale::getDefaultTimezone());
        // pre router config
        Quick_Controller_Router_Route::setDefaultLocale($defaultLocale);
       	Quick_Controller_Router_Route::setLocales($locales);

        Quick_Controller_Router_Route_Module::setDefaultLocale($defaultLocale);
        Quick_Controller_Router_Route_Module::setLocales($locales);
    }
    
	protected function _initRouter()
    {
        $this->bootstrap('Cache');
        $router = new Quick_Controller_Router_Rewrite();
        // include routes files
        $routes = Quick::getRoutes();
        foreach ($routes as $route) {
            include_once($route);
        }

        $router->removeDefaultRoutes();
		
        if (!($router instanceof Quick_Controller_Router_Rewrite)) {
            throw new Quick_Exception('Incorrect routes');
        }
        Zend_Controller_Front::getInstance()->setRouter($router);
        return $router;
    }
    
	protected function _initFrontController()
    {
        $this->bootstrap('Router');
        $front = Zend_Controller_Front::getInstance();
        $front->setDefaultModule('Quick_Core');
        $front->setControllerDirectory(Quick::getControllers());
        //$front->setRouter($router);
        $front->setParam('noViewRenderer', true);
        $front->registerPlugin(
            new Quick_Controller_Plugin_ErrorHandler_Override()
        );

        return $front; // this is *VERY* important
    }
}