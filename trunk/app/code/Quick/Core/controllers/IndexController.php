<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class IndexController extends Quick_Core_Controller_Back
{
	public function init()
    {
    	parent::init();        
    }
    
    public function indexAction()
    {
        $this->view->pageTitle = Quick::translate('Core')->__('Home');
                
        $this->render();
    }
}