<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick_Controller_Plugin_ErrorHandler_Override extends Zend_Controller_Plugin_Abstract
{
    /**
     * Set different errorHandler module 
     * while Quick_Admin is using
     * 
     * @param Zend_Controller_Request_Abstract $request
     * @return void
     */
    public function preDispatch(Zend_Controller_Request_Abstract $request)
    {
        if ($request->getParam('module') != 'Quick_Admin') {
            return;
        }
        $errorHandler = Zend_Controller_Front::getInstance()
            ->getPlugin('Zend_Controller_Plugin_ErrorHandler')
            ->setErrorHandlerModule('Quick_Admin');
    } 
}
