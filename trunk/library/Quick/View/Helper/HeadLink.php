<?php
/**
 *
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */

class Quick_View_Helper_HeadLink extends Zend_View_Helper_HeadLink
{
    /**
     * Flag that is responsible for links rendering mode
     * @var bool
     */
    private $_useProxy = false;
    
    /**
     * headLink() - View Helper Method
     *
     * Returns current object instance. Optionally, allows passing array of
     * values to build link.
     *
     * @return Zend_View_Helper_HeadLink
     */
    public function headLink(
        array $attributes = null,
        $placement = Zend_View_Helper_Placeholder_Container_Abstract::APPEND)
    {
        $this->_useProxy = false;
        return parent::headLink($attributes, $placement);
    }
    
    /**
     * @param bool $flag
     * @return Quick_View_Helper_HeadScript Provides fluent interface
     */
    public function setUseProxy($flag)
    {
        $this->_useProxy = (bool)$flag;
        return $this;
    }
    
    
}
