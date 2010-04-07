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
        //$this->view->pageTitle = Ecart::translate('admin')->__('Home');
        $this->view->pageTitle = 'Home';
        
        $this->render();
    }
}