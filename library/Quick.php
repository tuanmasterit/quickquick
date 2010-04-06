<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick
{
	static $siteId = 0;
    
    static $template;
    
	/**
     * Retrieve config object or config value,
     * if name is requested
     *
     * @static
     * @param string $name[optional] config value to load
     * @param string $default[optional] default value to return
     * @return object Quick_Config|mixed
     */
    public static function config($name = null, $default = null)
    {
        if (!Zend_Registry::isRegistered('config')) {
            throw new Quick_Exception(
                /*Quick::translate('core')->__(
                    'Config is not initialized'
                )*/
            );
        }        
        if (null === $name) {
            return Zend_Registry::get('config');
        } else {
            return Zend_Registry::get('config')->get($name, $default);
        }
    }
    
	/**
     * Retrieve session object
     *
     * @static
     * @return Zend_Session_Namespace
     */
    public static function session() 
    {
        return Zend_Registry::get('nsMain');
    }
    
	/*
     * Retrieve database adapter object
     *
     * @static
     * @return Zend_Db  
     */
    public static function db()
    {
        return Zend_Registry::get('db');
    }
    
	/**
     * Returns singleton object
     *
     * @static
     * @param string $class
     * @param array $arguments [optional]
     * @return Quick_Db_Table_Abstract
     */
    public static function single($class, $arguments = array())
    {
        $class = self::_getClass($class);
        
        if (!Zend_Registry::isRegistered($class)) {
            $instance = new $class($arguments);
            Zend_Registry::set($class, $instance);
        }
        return Zend_Registry::get($class);
    }
    
	/**
     * Return class name by shortname
     *
     * @static
     * @param string $name
     * @param string $type
     * @return string
     */
    private static function _getClass($name, $type = 'model')
    {
        if (false === strpos($name, '/')) {
            return $name;
        }

        list($module, $class) = explode('/', $name);

        // @todo
        /* if (null === $class) {
            return new Quick_Db_Table(
                array_merge($arguments, array('name' => $model))
            );
        }*/
        $class = str_replace(' ', '_', ucwords(str_replace('_', ' ', $class)));

        return 'Quick_'
            . ucfirst($module) . '_'
            . ucfirst($type) . '_'
            . $class;
    }
    
	/**
     * @static
     * @param bool $withParams
     * @return string
     */
    public static function getCurrentUrl($withParams = true)
    {
         // Filter php_self to avoid a security vulnerability.
        $phpRequestUri = htmlentities(
            substr(
                $_SERVER['REQUEST_URI'],
                0,
                strcspn($_SERVER['REQUEST_URI'], "\n\r")
            ),
            ENT_QUOTES
        );

        if (isset($_SERVER['HTTPS']) && strtolower($_SERVER['HTTPS']) == 'on') {
            $protocol = 'https://';
        } else {
            $protocol = 'http://';
        }
        $host = $_SERVER['HTTP_HOST'];
        if (isset($_SERVER['HTTP_PORT']) && $_SERVER['HTTP_PORT'] != '' &&
            (($protocol == 'http://' && $_SERVER['HTTP_PORT'] != '80') ||
            ($protocol == 'https://' && $_SERVER['HTTP_PORT'] != '443'))) {
            $port = ':' . $_SERVER['HTTP_PORT'];
        } else {
            $port = '';
        }
        $url = $protocol . $host . $port . $phpRequestUri;
        if (!$withParams && $end = strpos($url, '?')) {
            $url = substr($url, 0, $end);
        }
        return $url;
    }
    
	/**
     * Return current site id
     *
     * @static
     * @return int 
     */
    public static function getSiteId()
    {
        if (!self::$siteId) {
            $url = Quick::getCurrentUrl();
            if (!self::$siteId = self::single('core/site')->getIdByUrl($url)) {
                // provide site access through ip-address
                if (!self::$siteId = self::single('core/site')->fetchOne('id')) {
                    throw new Quick_Exception(
                        "There is no site linked with url " . $url
                    );
                }
            }
        }
        return self::$siteId;
    }
    
	/**
     * Retrieve cache object
     *
     * @static
     * @return Zend_Cache_Core
     */
    public static function cache() 
    {
        return Zend_Registry::get('cache');
    }
    
	/**
     * Retrieve array of paths to route files
     *
     * @static
     * @return array 
     */
    public static function getRoutes()
    {
        if (!($routes = self::cache()->load('routes_list'))) {
            $modules = self::getModules();            
            $routes = array();
            foreach ($modules as $moduleCode => $path) {            	
                if (file_exists($path . '/etc/routes.php') 
                    && is_readable($path . '/etc/routes.php')) {
                    
                    $routes[] = $path . '/etc/routes.php';
                }
            }            
            self::cache()->save(
                $routes, 'routes_list', array('modules')
            );
        }
        return $routes;
    }
    
	/**
     * Retrieve the list of active, installed modules
     *
     * @static
     * @return array code => path pairs
     */
    public static function getModules()
    {
        if (Zend_Registry::isRegistered('modules')) {
            return Zend_Registry::get('modules');
        }
        if (!$modules = self::cache()->load('modules_list')) {
            $list = Quick::single('core/module')->getList('is_active = 1');            
            $result = array();
            foreach ($list as $moduleCode => $values) {
                list($category, $module) = explode('_', $moduleCode, 2);
                $modules[$moduleCode] = Quick::config()->system->path
                    . '/app/code/' . $category . '/' . $module;
            }
            self::cache()->save($modules, 'modules_list', array('modules'));
        }
        Zend_Registry::set('modules', $modules);
        return Zend_Registry::get('modules');
    }
    
	/**
     * Retrieve the controllers paths
     *
     * @static
     * @return array code => path pairs
     */
    public static function getControllers()
    {
        if (!$result = self::cache()->load('controllers_list')) {
            $modules = self::getModules();
            $result = array();
            foreach ($modules as $moduleCode => $path) {
                if (is_readable($path . '/controllers')) {
                    $result[$moduleCode] = $path . '/controllers';
                }
            }
            self::cache()->save(
                $result, 'controllers_list', array('modules')
            );
        }
        return $result;        
    }
    
}