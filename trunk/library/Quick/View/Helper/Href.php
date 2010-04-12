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

    public function __construct()
    {
        $this->_baseUrl = $_SERVER['HTTP_HOST'] 
                        . Zend_Controller_Front::getInstance()->getBaseUrl();
    }

    /**
     *
     * @param string $href
     * @param bool $ssl [optional]
     * @return string
     */
    public function href($href = '')
    {
        return 'http://'
            . $this->_baseUrl
            . '/'
            . ltrim($href, '/');
    }
}