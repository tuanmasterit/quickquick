<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Sale
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Sale_IndexController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }

	public function indexAction()
    {
        $this->view->pageTitle = 'Sale';
        
        $this->render();
    }

}