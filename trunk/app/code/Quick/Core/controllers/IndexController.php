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
    
	public function testAction()
    {
        $this->view->pageTitle = 'test';
    
        $this->render();
    }
    
	public function listAction()
    {
    	$result = array();
    	foreach (Quick::single('core/language')
                    ->getAllList() as $language) {
            
            if (!isset($result[$language['id']])) {
                $result[$language['id']] = $language;
            }            
        }
    	
    	return $this->_helper->json->sendSuccess(array(
            'data' => array_values($result)
        ));
    }
    
	public function testAuthAction()
    {
        $this->view->pageTitle = 'test-auth';
    
        $this->render();
    }
}