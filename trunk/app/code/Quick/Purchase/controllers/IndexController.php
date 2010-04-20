<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Purchase
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Purchase_IndexController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }

	public function indexAction()
    {
        $this->view->pageTitle = 'Purchase';
        
        $this->render();
    }

}