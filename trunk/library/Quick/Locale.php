<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Locale
 * @author      trungpm
 */
class Quick_Locale
{
    const DEFAULT_LOCALE    = 'en_US';
    const DEFAULT_CURRENCY  = 'USD';
    const DEFAULT_TIMEZONE  = 'America/Los_Angeles';
    
    /**
     * Retrieve locale object
     *
     * @static
     * @return Zend_Locale
     */
    public static function getLocale()
    {
        if (!Zend_Registry::isRegistered('Zend_Locale')) {
            if (Zend_Registry::get('app') == 'front' 
                && Ecart_Controller_Router_Route::hasLocaleInUrl()) {

                self::setLocale(Ecart_Controller_Router_Route::getCurrentLocale());
            } elseif (Zend_Registry::get('app') == 'admin' 
                && isset(Ecart::session()->locale)) {

                self::setLocale(Ecart::session()->locale);
            } else {
                self::setLocale(Ecart::config()->main->store->locale);
            }
        }
        return Zend_Registry::get('Zend_Locale');
    }
    
	/**
     * Retrieve default locale from config
     *
     * @static
     * @return string Locale ISO code
     */
    public static function getDefaultLocale()
    {  
        return self::DEFAULT_LOCALE;
    }
    
	/**
     * Returns a list of all known locales, or all installed locales
     *
     * @static
     * @return array
     */
    public static function getLocaleList($installedOnly = false)
    {
        if (!$installedOnly) {
            return array_keys(Zend_Locale::getLocaleList());
        }
        return Quick::single('locale/language')->getLocaleList();
    }
}