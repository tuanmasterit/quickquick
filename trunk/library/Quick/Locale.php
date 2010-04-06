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
                && Quick_Controller_Router_Route::hasLocaleInUrl()) {

                self::setLocale(Quick_Controller_Router_Route::getCurrentLocale());
            } elseif (Zend_Registry::get('app') == 'admin' 
                && isset(Ecart::session()->locale)) {

                self::setLocale(Quick::session()->locale);
            } else {
                self::setLocale(Quick::config()->main->store->locale);
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
    	// access database for multi locale
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
    
	/**
     * get default store timezone
     *
     * @static
     * @return  string  example : "Australia/Hobart"
     */
    public static function getDefaultTimezone()
    {    	
        return Quick::config()->main->store->timezone;
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
            $timezone = Quick::config()->main->store->timezone;
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
            $locale = self::_getLocaleFromLanguageCode($locale);
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
        
        $row = Quick::single('locale/language')->fetchRow(Quick::db()->quoteInto(
            'code = ?', $currentLocale->getLanguage()
        ));
        
        if ($row) {
            $nsMain->language = $row->id;
        } else {
            $nsMain->language = Quick::config()->main->store->language;
        }
        self::setTimezone();
    }
    
	/**
     * Retrieve languageId from session;
     *
     * @static
     * @return int
     */
    public static function getLanguageId()
    {
        if (!isset(Quick::session()->language)) {
            Quick::session()->language = Quick::config()->main->store->language;
        }
        return Quick::session()->language;
    }
    
	/**
     * Retrieve part of url, responsible for locale
     *
     * @static
     * @return string Part of url ('/uk')
     */
    public static function getLanguageUrl()
    {
        
        $language = self::getLocale()->getLanguage();
        $locale = self::getLocale()->toString();
        
        if ($locale == self::getDefaultLocale()) {
            return '';
        }
        if ($locale == self::_getLocaleFromLanguageCode($language)) {
            return '/' . $language;
        }
        
        return '/' . $locale;
    }
    
	/**
     * Retrieve first suitable locale with language
     *
     * @static
     * @param string $code Language ISO code 
     * @return string Locale ISO code
     */
    private static function _getLocaleFromLanguageCode($code)
    {
        $localeList = self::getLocaleList(true);
        
        foreach ($localeList as $locale) {
            if (strstr($locale, $code)) {
                return $locale;
            }
        }
        
        return self::DEFAULT_LOCALE;
    }
}