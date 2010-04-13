<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Locale
 * @subpackage  Route
 * @author      trungpm
 */
class Quick_Controller_Router_Route extends Zend_Controller_Router_Route
{
    /**
     *
     * @static
     * @var array
     */
    protected static $_locales = array('en', 'vi');

    /**
     *
     * @static
     * @var string
     */
    protected static $_defaultLocale = 'en';

    /**
     *
     * @static
     * @var bool
     */
    private static $_hasLocaleInUrl = false;

    /**
     *
     * @var string
     */
    private static $_currentLocale = 'en';

	/**
     *
     * @static
     * @param string $locale[optional]
     */
    public static function setDefaultLocale($locale = null)
    {
        self::$_defaultLocale = $locale;
    }
    
	/**
     *
     * @static
     * @param array $locales
     */
    public static function setLocales(array $locales)
    {
        self::$_locales = $locales;
    }
}