<?php
/**
 * 
 * @category    Ecart
 * @package     Ecart_View
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Quick_Layout extends Zend_Layout
{
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
}