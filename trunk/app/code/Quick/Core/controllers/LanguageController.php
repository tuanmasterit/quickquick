<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class LanguageController extends Quick_Admin_Controller_Back
{
    public function init()
    {
        parent::init();        
    }
    
    /**
     * Change the locale
     * 
     */
    public function changeAction()
    {
        $locale = $this->_getParam('new_locale');
        echo $locale;
        if ($locale) {
            Quick_Locale::setLocale($locale);
        }
        
        $this->_redirect($_SERVER['HTTP_REFERER']);
    }
}