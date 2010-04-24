<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class InformerController extends Quick_Core_Controller_Back
{
    public function init()
    {
        $this->_disableAcl = true;
        parent::init();
    }
    
	public function accessDeniedAction()
	{
		$this->view->pageTitle = 'Access Denied';
		$this->view->message = Quick_Miscfunction::getMsg('You do not have privileges to access this action.', 'warn');
		$this->render();
	}
}