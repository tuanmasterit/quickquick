<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Catalog
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Catalog_IndexController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }

	public function viewAction()
    {
        $this->view->pageTitle = 'Product Catalog';
        
        $this->render();
    }

}