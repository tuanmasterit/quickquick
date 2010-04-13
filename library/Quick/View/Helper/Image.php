<?php
/**
 * 
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */
class Quick_View_Helper_Image
{
    public function image($src, $attribute = '', $absolute = true)
    {
        $path = $this->view->baseUrl;
        if (!$absolute) {
            //@todo use parse_url
            $path = $this->view->baseUrl;    
        }

        if (!strstr($attribute, 'alt=')) {
            $attribute .= ' alt="' . str_replace(' ', '', strtolower($src)) . '"';
        }

        if (is_readable($this->view->path . '/skin/' . $this->view->applicationName
                . '/' . $this->view->templateName . '/images/' . $src)) {
            return '<img src="' . $path .
                '/skin/' . $this->view->applicationName .'/' . $this->view->templateName . '/images/' .
                $src . '" ' . $attribute . ' />';
        } else {
            return '<img src="' . $path .
                '/skin/' . $this->view->applicationName . '/default/images/' . $src . '" ' . $attribute .' />';
        }
    }
    
    public function setView($view)
    {
        $this->view = $view;
    }
}
