<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Purchase
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Purchase_TransactionController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }
	
	public function indexAction()
    {
        $this->view->pageTitle = 'Sale-Transaction-index';
        
        $this->render();
    }
    
	public function addOrderAction()
    {
        $this->view->pageTitle = 'Sale-Transaction-addOrder';
        
        $this->render();
    }

}