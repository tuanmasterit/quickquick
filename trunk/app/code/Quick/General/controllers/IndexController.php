<?php
/**
 * 
 * @category    Quick
 * @package     Quick_General
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_General_IndexController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	parent::init();
    }

	public function indexAction()
    {
        
        $this->render();
    }

}