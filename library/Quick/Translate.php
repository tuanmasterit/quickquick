<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Translate
 * @author      trungpm
 */
class Quick_Translate
{
    /**
     *
     * @var Quick_Translate
     */
    private static $_instance;
    
    /**
     * Translators
     *
     * @var array of Zend_Translate
     */
    private static $_translators = null;

    /**
     *
     * @var string
     */
    private $_locale;

    /**
     *
     * @var string
     */
    private static $_table = 'definition_list_function';

    /**
     * Current module
     *
     * @param string $module [optional]
     */
    public function __construct($_table = 'definition_list_function')
    {
        $this->_locale = Quick_Locale::getLocale()->toString();
        self::$_table = $_table;
    	if (!Quick::config()->translation->main->autodetect) {
             Zend_Translate::setCache(Quick::cache());
        }   
    }
    
    /**
     * Return instance of Quick_Translate
     *
     * @param  string $module [optional]
     * @static
     * @return Quick_Translate
     */
    public static function getInstance($_table = 'definition_list_function')
    {
        if (null === self::$_instance) {
            self::$_instance = new self($_table);
        }
        return self::$_instance;
    }
    
	/**
     *
     * @param array $args
     * @return string
     */
    public function translate(array $args)
    {
        $key = array_shift($args);
        
        if (!count($args)) {
        	return Quick::single('core/module_language')->getTranslatedValue(self::$_table, $this->_locale, $key);
        }
        return null;
    }
    
	/**
     *
     * @param string $locale
     * @param string $module
     * @return string
     */
    protected function _getFileName($locale, $module)
    {
        return Quick::config()->system->path
            . '/app/locale/'
            . $locale . '/'
            . $module . '.csv';
    }
    
	/**
     * Translate text
     *
     * @param array 
     * @return string
     */
    public function __()
    {
        return $this->translate(func_get_args());
    }
}