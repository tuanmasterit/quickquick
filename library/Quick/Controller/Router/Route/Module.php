<?php
/**
 *
 * @category    Quick
 * @package     Quick_Locale
 * @subpackage  Route
 * @author      trungpm
 */
 class Quick_Controller_Router_Route_Module extends Zend_Controller_Router_Route_Module
{
    /**
     *
     * @static
     * @var const array
     */
    protected static $_locales = array('en', 'vi');

    /**
     *
     * @static
     * @var string
     */
    protected static $_defaultLocale = 'en';     

/**
     * @static
     * @param array $locales
     */
    public static function setLocales(array $locales)
    {
        self::$_locales = $locales;
    }

    /**
     *
     * @static
     * @param string $locale
     */
    public static function setDefaultLocale($locale) 
    {
        self::$_defaultLocale = $locale;
    }
}
