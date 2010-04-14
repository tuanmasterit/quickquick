<?php
/**
 *
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */

class Quick_View_Helper_HeadScript extends Zend_View_Helper_HeadScript
{
    /**
     * Flag that is responsible for script rendering mode
     * @var bool
     */
    private $_useProxy = false;
    
    /**
     * Return headScript object
     *
     * Returns headScript helper object; optionally, allows specifying a script
     * or script file to include.
     *
     * @param  string $mode Script or file
     * @param  string $spec Script/url
     * @param  string $placement Append, prepend, or set
     * @param  array $attrs Array of script attributes
     * @param  string $type Script type and/or array of script attributes
     * @return Zend_View_Helper_HeadScript
     */
    public function headScript(
        $mode = Zend_View_Helper_HeadScript::FILE,
        $spec = null,
        $placement = 'APPEND',
        array $attrs = array(),
        $type = 'text/javascript')
    {
        $this->_useProxy = false;
        return parent::headScript($mode, $spec, $placement, $attrs, $type);
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
