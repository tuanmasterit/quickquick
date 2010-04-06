<?php
/**
 * 
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */
class Quick_View_Helper_Href
{
    /**
     * @var string
     */
    private $_baseUrl;

    /**
     * @var bool
     */
    private $_enabledSsl;
    
    public function __construct()
    {
        $this->_baseUrl = $_SERVER['HTTP_HOST'] 
                        . Zend_Controller_Front::getInstance()->getBaseUrl();

        $this->_enabledSsl = (!function_exists('apache_get_modules')
            || in_array('mod_ssl', apache_get_modules())) &&
            Quick::config()->main->store->useFrontendSsl;
    }

    /**
     *
     * @param string $href
     * @param bool $ssl [optional]
     * @return string
     */
    public function href($href = '', $ssl = false)
    {
        return ($ssl && $this->_enabledSsl ? 'https://' : 'http://')
            . $this->_baseUrl
            . Quick_Locale::getLanguageUrl() . '/'
            . ltrim($href, '/');
    }
}