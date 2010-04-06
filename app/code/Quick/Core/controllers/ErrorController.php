<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class ErrorController extends Quick_Controller_Action
{
    public function errorAction()
    {
        $this->view->pageTitle = Quick::translate('core')->__(
            'An error has occured processing your request'
        );
        $this->_helper->layout->setLayout('layout_error');
        $errors = $this->_getParam('error_handler');
        $exception = $errors->exception;
        
        try {
            $log = new Zend_Log(
                new Zend_Log_Writer_Stream(
                    Quick::config()->system->path . "/var/logs/exceptions_log"
                    //Quick::config()->log->main->php
                )
            );
            $log->debug(
                $exception->getMessage() . "\n" .  $exception->getTraceAsString()
            );
        } catch (Zend_Log_Exception $e) {
            //who cares
        }
        
        //$this->getResponse()->clearBody();
        $this->view->error = $exception->getMessage() . 
            "\n<strong>" . Quick::translate('core')->__('Trace') . ":</strong>\n"
            . $this->view->escape($exception->getTraceAsString());
    }
}