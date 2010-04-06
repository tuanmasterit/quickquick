<?php
/**
 *
 * @category    Quick
 * @package     Quick_Locale
 * @subpackage  Route
 * @author      trungpm
 */
class Quick_Controller_Router_Rewrite extends Zend_Controller_Router_Rewrite
{
    public function addDefaultRoutes()
    {
        if (!$this->hasRoute('default')) {
            $dispatcher = $this->getFrontController()->getDispatcher();
            $request = $this->getFrontController()->getRequest();
            
            $compat = new Quick_Controller_Router_Route_Module(array(), $dispatcher, $request);
            $this->_routes = array_merge(array('default' => $compat), $this->_routes);
        }
    }
}