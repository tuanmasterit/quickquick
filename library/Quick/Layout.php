<?php
/**
 * 
 * @category    Quick
 * @package     Quick_View
 * @author      trungpm
 */
class Quick_Layout extends Zend_Layout
{
	/**
     * Box to Block assignment
     *
     * @var array
     */
    protected $_assignments;
    
    protected $_tabAssignments;
    
    protected $_pages;
    
    protected $_layout = null;
    
    protected $_quickLayout = "_default";

    protected $_defaultLayout = '_default';
    
	/**
     * Static method for initialization with MVC support
     *
     * @static
     * @param  string|array|Zend_Config $options 
     * @return Quick_Layout
     */
    public static function startMvc($options = null)
    {
        if (null === self::$_mvcInstance) {
            self::$_mvcInstance = new self($options, true);
        } else {
            self::$_mvcInstance->setOptions($options);
        }

        return self::$_mvcInstance;
    }
    
	public function getLayout()
    {
        if (Zend_Registry::get('app') == 'admin') {
            return 'layout'.Quick::config()->template->default_layout;
        }
                
        return $this->_quickLayout;
    }
    
    private function _getDefaultLayout()
    {   
        return $template->default_layout;
    }
   
}