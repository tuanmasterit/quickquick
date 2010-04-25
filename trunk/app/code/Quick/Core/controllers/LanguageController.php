<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class LanguageController extends Quick_Core_Controller_Back
{
    public function init()
    {
    	$this->_disableAcl = true;
    	$this->_disableAuth = true;
        parent::init();        
    }
    
    /**
     * Change the locale
     * 
     */
    public function changeAction()
    {
    	$this->_helper->layout->disableLayout();
        $locale = $this->_getParam('new_locale');
        if ($locale) {
            Quick_Locale::setLocale($locale);
        }
        
        $this->_redirect($_SERVER['HTTP_REFERER']);
    }
}