<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Core_Controller_Front extends Quick_Controller_Action
{
    public function auth()
    {
        if (!Quick::getCustomerId()) {
            $this->_redirect('/account/auth');
        }
    }
    
    public function init()
    {    	
        parent::init();
        //Quick::single('account/customer')->checkIdentity();
        $this->view->crumbs()->add(
            Quick::translate('core')->__(
                'Home'
            ),
            $this->view->href('/')
        );
    }
    
    /**
     * Redirect to another URL
     *
     * @param string $url [optional]
     * @param bool $addLanguage [optional]
     * @param array $options Options to be used when redirecting
     * @return void
     */
    protected function _redirect(
        $url, array $options = array(), $addLanguage = true)
    {
        if ((isset($_SERVER['HTTP_REFERER']) &&
                $url == $_SERVER['HTTP_REFERER'])
            || !$addLanguage) {

            parent::_redirect($url, $options);
            exit();
        }
        parent::_redirect(
            rtrim(Quick_Locale::getLanguageUrl(), '/') . '/' . ltrim($url, '/'),
            $options
        );
    }
}