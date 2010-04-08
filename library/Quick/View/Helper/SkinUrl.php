<?php
/**
 * 
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */
class Quick_View_Helper_SkinUrl
{
    
    public function skinUrl($src = null, $relativePath = false)
    {
        $skinUrl = $relativePath ?
            substr($this->view->skinUrl, strlen($this->view->baseUrl)) : $this->view->skinUrl;
        
        if (null === $src) {
            return $skinUrl;
        }

        if (is_readable($this->view->skinPath . '/' . $src)) {
            return $skinUrl . '/' .  ltrim($src, '/');
        }
        $baseUrl = $relativePath ? 
            Zend_Controller_Front::getInstance()->getBaseUrl() : $this->view->baseUrl;
        return $baseUrl . '/skin/'
             . $this->view->applicationName
             . '/' . $this->view->defaultTemplate
             . '/' .  ltrim($src, '/');
    }

    public function setView($view)
    {
        $this->view = $view;
    }
}