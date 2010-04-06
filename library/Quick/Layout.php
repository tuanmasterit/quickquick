<?php
/**
 * 
 * @category    Quick
 * @package     Quick_View
 * @author      trungpm
 */
class Quick_Layout extends Zend_Layout
{
	/**
     * Box to Block assignment
     *
     * @var array
     */
    protected $_assignments;
    
    protected $_tabAssignments;
    
    protected $_pages;
    
    protected $_layout = null;
    
    protected $_quickLayout = null;

    protected $_defaultLayout = '3rows';
    
	/**
     * Static method for initialization with MVC support
     *
     * @static
     * @param  string|array|Zend_Config $options 
     * @return Quick_Layout
     */
    public static function startMvc($options = null)
    {
        if (null === self::$_mvcInstance) {
            self::$_mvcInstance = new self($options, true);
        } else {
            self::$_mvcInstance->setOptions($options);
        }

        return self::$_mvcInstance;
    }
    
	public function getLayout()
    {
        if (Zend_Registry::get('app') == 'admin') {
            return 'layout';
        }
        
        if (null !== $this->_layout) {
            $this->_quickLayout = 'layout' . substr($this->_layout, strpos($this->_layout, '_'));
        } elseif (null === $this->_quickLayout) {
            $pages = $this->getMatchedPages();
            $templateId = Quick::config()->design->main->frontTemplateId;
            $rows = Quick::single('core/template_layout_page')->fetchAll(
               'template_id = ' . $templateId . ' AND ' . 
                Quick::db()->quoteInto('page_id IN(?)', array_keys($pages))
            )->toArray();
            $layout = '';
            
            foreach ($rows as $row) {
                if (isset($page_id)) {
                    if (!$this->_catRewrite($pages[$page_id], $pages[$row['page_id']])) {
                        continue;
                    }
                }
                $page_id = $row['page_id'];
                $layout = $row['layout'];
            }
            
            if (empty($layout)) {
                $layout = $this->_getDefaultLayout();
            }
            
            $this->_quickLayout = 'layout' . substr($layout, strpos($layout, '_'));
        }

        return $this->_quickLayout;
    }
    
    private function _getDefaultLayout()
    {
        if (!($template = Quick::single('core/template')->find(
                Quick::config()->design->main->frontTemplateId)->current())
            || empty($template->default_layout))
        {
            return $this->_defaultLayout;
        }
        
        return $template->default_layout;
    }
    
	public function getMatchedPages()
    {
        if (null === $this->_pages) {
            $request = Zend_Controller_Front::getInstance()->getRequest();
            list($category, $module) = explode('_', $request->getModuleName(), 2);
            $this->_pages = Quick::single('core/page')->getPagesByRequest(
                strtolower($module), 
                $request->getControllerName(),
                $request->getActionName() 
            );
        }
        return $this->_pages;
    }
}