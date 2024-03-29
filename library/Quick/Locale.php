<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Locale
 * @author      trungpm
 */
class Quick_Locale
{
    const DEFAULT_LOCALE    = 'vi_VN';
    const DEFAULT_CURRENCY  = 'USD';
    const DEFAULT_TIMEZONE  = 'America/Los_Angeles';
    const DEFAULT_LOCALENAME  = 'English';
    	    
	/**
     * Retrieve default locale from config
     *
     * @static
     * @return string Locale ISO code
     */
    public static function getDefaultLocale()
    {
    	// access database for multi locale
        return empty(Quick::config()->main->store->locale) ? 
           self::DEFAULT_LOCALE : Quick::config()->main->store->locale;
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
        return Quick::single('core/language')->getLocaleList();
    }
    
	/**
     * get default store timezone
     *
     * @static
     * @return  string  example : "Australia/Hobart"
     */
    public static function getDefaultTimezone()
    {    	
        return self::DEFAULT_TIMEZONE;
    }
    
	/** 
     * set timezone
     *
     * @static
     * @param mixed void|string
     * @return bool  
     */
    public static function setTimezone($timezone = null)
    {
        if (null === $timezone) {
            $timezone = self::DEFAULT_TIMEZONE;
        }
        if (@date_default_timezone_set($timezone)) {
            return true;
        }
        return @date_default_timezone_set(self::DEFAULT_TIMEZONE);
    }
    
	/**
     * Set locale and language if possible
     *
     * @static
     * @param string (locale or language) $locale
     */
    public static function setLocale($locale = 'auto')
    {
        $nsMain = Quick::session();
        if (!strstr($locale, '_')) {
            $locale = self::_getLocaleFromLanguageCode();
        }
        
        if (Zend_Registry::isRegistered('Zend_Locale')) {
            $currentLocale = Zend_Registry::get('Zend_Locale');
            $currentLocale->setLocale($locale);
        } else {
            try {
                $currentLocale = new Zend_Locale($locale);
            } catch (Zend_Locale_Exception $e) {
                $currentLocale = new Zend_Locale(self::DEFAULT_LOCALE);
            }
            Zend_Locale::setCache(Quick::cache());
            Zend_Registry::set('Zend_Locale', $currentLocale);
        }       
        if (Zend_Registry::isRegistered('app') && Zend_Registry::get('app') == 'admin') {
            $nsMain->locale = $locale;
        }    
    
        self::setTimezone();
    }
    
	/**
     * Retrieve locale object
     *
     * @static
     * @return Zend_Locale
     */
    public static function getLocale()
    {
        if (!Zend_Registry::isRegistered('Zend_Locale')) {
            if (Zend_Registry::get('app') == 'admin' 
                && isset(Quick::session()->locale)) {

                self::setLocale(Quick::session()->locale);
            } else {
                self::setLocale(Quick::config()->main->store->locale);
            }
        }
        return Zend_Registry::get('Zend_Locale');
    }
    
	/**
     * Retrieve first suitable locale with language
     *
     * @static
     * @param string $code Language ISO code 
     * @return string Locale ISO code
     */
    private static function _getLocaleFromLanguageCode()
    {        
        return self::DEFAULT_LOCALE;
    }
}