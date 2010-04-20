<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_IndexController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }

	public function indexAction()
    {
        $this->view->pageTitle = 'Accountant';
        
        $this->render();
    }

}