<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Handler
 * @author      trungpm
 */
interface Quick_Collect_Handler_Interface
{
    /**
     * Add params
     *
     * @static
     * @param  array $params
     * @return string
     */
    public static function getSaveValue($params);
    
    /**
     * Get html
     *
     * @static
     * @param string $value
     * @return string
     */ 
    public static function getHtml($value, Zend_View_Interface $view = null);
    
    /**
     * Get config
     *
     * @static
     * @param  string $value
     * @return mixed
     */ 
    public static function getConfig($value);
}
