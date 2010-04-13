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
    private static $_module = 'Quick_Core';

    /**
     * Current module
     *
     * @param string $module [optional]
     */
    public function __construct($module = 'Quick_Core')
    {
        $this->_locale = Quick_Locale::getLocale()->toString();
        self::$_module = $module;   
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
    public static function getInstance($module = 'Quick_Core')
    {    	
        if (null === self::$_instance) {
            self::$_instance = new self($module);
        } elseif (self::$_module !== $module) {
            
            if (!in_array($module, array_keys(Quick::getModules()))) {
                throw new Quick_Exception(
                    'Translate error : module ' . $module . ' not exist'
                );
            }
            self::$_module = $module;
        }
        return self::$_instance;
    }
    
	/**
     * Return instance of Zend_Translate_Adapter
     *
     * @param string $module
     * @return Zend_Translate_Adapter|null
     */
    public function getTranslator($module = null)
    {
        if (null === $module) {
            $module = self::$_module;
        }
        if (!isset(self::$_translators[$module])
           ||(!self::$_translators[$module] instanceof Zend_Translate)) {
           	
            $filename = $this->_getFileName($this->_locale, $module);
            
            if (!is_readable($filename)) {
                return null;
            }

            $translator = new Zend_Translate(
                'csv',
                $filename,
                $this->_locale,
                array('delimiter' => ',')
            );
            self::$_translators[$module] = $translator;
        }

        return self::$_translators[$module];
    }
    
	/**
     *
     * @param array $args
     * @return string
     */
    public function translate(array $args)
    {
        $text = array_shift($args);

        if (null === $this->getTranslator()) {
            return @vsprintf($text, $args);
        }
        
        if (!count($args)) {        	
            return $this->getTranslator()->_($text, $this->_locale);
        }
        return @vsprintf(
            $this->getTranslator()->_($text, $this->_locale),
            $args
        );
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