<?php
/**
 * 
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */
class Quick_View_Helper_Crumbs
{
    protected $_crumbs = array();
    private $_status = true;
    
    /**
     * Add crumb 
     * @return void 
     * @param string $title
     * @param string $url
     */
    public function add($title, $url = null)
    {
        if (null === $url) {
            $url = Quick::getCurrentUrl();
        } elseif (substr($url, 0 , 4) != 'http') {
            $url = $this->view->href($url);
        }
        
        if (empty($this->_crumbs[$url])) {
            $this->_crumbs[$url] = array('title' => $title, 'url' => $url);
        }
    }
    
    /**
     *  Set crumbs
     * @return void 
     * @param array of array $crumbs[optional]
     */
    public function set(array $crumbs = array())
    {
        $this->_crumbs = array();
        foreach($crumbs as $crumb) {
            $this->_crumbs[md5($crumb['url'] . $crumb['title'])] = $crumb;
        }
    }
    
    public function __toString()
    {
        if (!$this->_status) {
            return '';
        }
        
        $crumbs = $this->_crumbs;
        $last = array_pop($crumbs);
        $crumbs[] = array('title' => $last['title']);
        $content = '';
        $content .= '<div class="breadcrumbs-container"><ul class="breadcrumbs">';
        foreach ($crumbs as $crumb) {
            if (!empty($crumb['url'])) {
                $content .= '<li><a href="' . $crumb['url'].'">'
                          . $this->view->escape($crumb['title']) . '</a></li>';
            } else {
                $content .= '<li><span>' . $this->view->escape($crumb['title'])
                    . '</span></li>';
            }
        }
        $content .= '</ul></div>';
        return $content;
    }
    
    public function setView($view)
    {
        $this->view = $view;
    }
    
    public function crumbs()
    {
        return $this;
    }
    
    public function disable()
    {
    	$this->_status = false;
    }
    
    public function enable()
    {
        $this->_status = true;
    }
}