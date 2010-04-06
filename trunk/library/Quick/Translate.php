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
     *
     * @param array $args
     * @return string
     */
    public function translate(array $args)
    {
        $text = array_shift($args);
        
        if (Quick::config()->translation->main->autodetect
            && (null === $this->getTranslator() // translate file nor exist
                || !$this->getTranslator()->isTranslated($text, false, $this->_locale))) {
            
            $this->addTranslate($text, self::$_module);
        }
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
     * Translate text
     *
     * @param array 
     * @return string
     */
    public function __()
    {
        return $this->translate(func_get_args());
    }
    
    public function getLocale()
    {
        return $this->_locale;
    }
    
    /*
    protected static function _loadTranslation($module, $locale = '')
    {
        if (empty($locale)) {
            $locale = self::$_instance->_locale;
        }

        $filename = self::_getFileName($locale, $module);
        if (!is_readable($filename)) {
            self::$_instance->getTranslator()
                ->addTranslation($filename, $locale);
        }
        self::$_module = $module;
    }
   // */

    /**
     *
     * @param string $filename
     * @param string $locale
     * @param array $options
     * @return array
     */
    protected function _loadTranslationData(
            $filename, $locale, array $options = array())
    {
        $result = array();
        if (!$file = @fopen($filename, 'rb')) {
            throw new Quick_Exception(
                'Error opening translation file \'' . $filename . '\'.'
            );
        }

        while(($data = fgetcsv(
                $file,
                $options['length'],
                $options['delimiter'],
                $options['enclosure'])
            ) !== false) {

            if (substr($data[0], 0, 1) === '#') {
                continue;
            }
            if (!isset($data[1])) {
                continue;
            }
            if (count($data) == 2) {
                $result[$locale][$data[0]] = $data[1];
            } else {
                $singular = array_shift($data);
                $result[$locale][$singular] = $data;
            }
        }
        fclose($file);
        return isset($result[$locale]) ? $result[$locale] : array();
    }

    /**
     * Add new taransllate (key => value )to localization
     *
     * @param string $text
     * @param string $module
     * @param string $locale
     * @example  addTranslate('name')
     *           -//-('name', '..../app/locale/en_US/Quick_Contacts.php')
     * @return bool
     */

    public function addTranslate($text, $module, $locale = null)
    {
        if (null === $locale) {
            $locale = $this->_locale;
        }
        
        $filename = $this->_getFileName($locale, $module);

        if (!is_readable($filename)) {
            
            $dir = dirname($filename);
            if (!is_readable($dir)) {
                mkdir($dir, 0777, true);
            }
            if (!is_writable($dir) && @chmod($dir  , 0777)) {
                Quick::message()->addError(
                    'Can\'t write to folder "' . $dir . '". Permission denied'
                );
                Quick::message()->addNotice(
                   'Workaround: >chmod -R 0777 [root_path]/app/locale'
                );
                return false;
            }
            touch($filename);
            chmod($filename, 0777);
        }
        
        if (!$file = @fopen($filename, 'a')) {
            throw new Quick_Exception(
                'Error writing translation file \'' . $filename . '\'.'
            );
        }
        
        fwrite($file, '"' . $text . '","' . $text . "\"\n");
        fclose($file);
        
        return true;
    }
    
    /**
     * Returns the set cache
     *
     * @return Zend_Cache_Core The set cache
     */
    public static function getCache()
    {
        return self::$_translators[self::$_module]->getCache();
    }

    /**
     * Sets a cache for all instances of Quick_Translate
     *
     * @param  Zend_Cache_Core $cache Cache to store to
     * @return void
     */
    public static function setCache(Zend_Cache_Core $cache)
    {
        if (!self::$_translators[self::$_module] instanceof Zend_Translate) {
            return false;
        }
        return self::$_translators[self::$_module]->setCache($cache);
    }

    /**
     * Returns true when a cache is set
     *
     * @return boolean
     */
    public static function hasCache()
    {
        if (!self::$_translators[self::$_module] instanceof Zend_Translate) {
            return false;
        }
        return self::$_translators[self::$_module]->hasCache();
    }

    /**
     * Removes any set cache
     *
     * @return void
     */
    public static function removeCache()
    {
        if (!self::$_translators[self::$_module] instanceof Zend_Translate) {
            return false;
        }
        return self::$_translators[self::$_module]->removeCache();
    }

    /**
     * Clears all set cache data
     *
     * @return void
     */
    public static function clearCache()
    {
        if (!self::$_translators[self::$_module] instanceof Zend_Translate) {
            return false;
        }
        return self::$_translators[self::$_module]->clearCache();
    }
}

/**
 * Translate function
 *
 * @param string
 * @param args array
 * @return string
 */
function __()
{
    return Quick_Translate::getInstance()->translate(func_get_args());
}