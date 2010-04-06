<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Crypt
 * @subpackage  Handler
 * @author      trungpm
 */
class Quick_Collect_Handler_Example implements Quick_Collect_Handler_Interface
{

    /**
     *
     * @static
     * @param string $value
     * @return string
     */
    public static function getSaveValue($value)
    {
        // return $result by using call into another class;
    }

    /**
     *
     * @param string $value
     * @param Zend_View_Interface $view
     * @return string
     */
    public static function getHtml($value, Zend_View_Interface $view = null) 
    {
        // return $resultview by using call into another class;
    }

    /**
     *
     * @param string $value
     * @return string
     */
    public static function getConfig($value)
    {   	
        // return $result by using call into another class;
    }
}