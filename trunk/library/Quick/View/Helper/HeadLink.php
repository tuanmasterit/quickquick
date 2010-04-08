<?php
/**
 *
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */

class Quick_View_Helper_HeadLink extends Zend_View_Helper_HeadLink
{
    /**
     * Flag that is responsible for links rendering mode
     * @var bool
     */
    private $_useProxy = false;
    
    /**
     * headLink() - View Helper Method
     *
     * Returns current object instance. Optionally, allows passing array of
     * values to build link.
     *
     * @return Zend_View_Helper_HeadLink
     */
    public function headLink(
        array $attributes = null,
        $placement = Zend_View_Helper_Placeholder_Container_Abstract::APPEND)
    {
        $this->_useProxy = false;
        return parent::headLink($attributes, $placement);
    }
    
    /**
     * @param bool $flag
     * @return Quick_View_Helper_HeadScript Provides fluent interface
     */
    public function setUseProxy($flag)
    {
        $this->_useProxy = (bool)$flag;
        return $this;
    }
    
    /**
     * Search algorithm:
     *  - from current template
     *  - from default template
     *  - from Quick_ROOT
     *  
     * @param string $css
     * @param bool $absolute [optional]
     * @return string
     */
    public function getCss($css, $absolute = false)
    {
        if (strstr($css, 'http://') || strstr($css, 'https://')) {
            return $css;
        }
        
        $file = '/skin/' . $this->view->applicationName . '/' 
            . $this->view->templateName . '/css/' . $css;
        
        if (!is_readable($this->view->path . $file)) {
            $file = '/skin/' . $this->view->applicationName
                  . '/default/css/' . $css;
        }
        if (!is_readable($this->view->path . $file)) {
            $file = $css;
        }
        $baseUrl = $absolute ? 
            $this->view->baseUrl : Zend_Controller_Front::getInstance()->getBaseUrl();
        
        return $baseUrl . '/' . trim($file, '/');
    }
    
    /**
     * Create HTML link element from data item
     *
     * @param  stdClass $item
     * @return string
     */
    public function itemToString(stdClass $item)
    {
        $attributes = (array) $item;
        $link       = '<link ';
        
        if (isset($attributes['href'])) {
            $href = ($attributes['rel'] == 'stylesheet') ? 
                $this->getCss($attributes['href']) : $attributes['href'];
            
            $link .= 'href="'.$href.'" ';
        }
        
        $this->_completeItem($link, $attributes);
        
        return $link;
    }
    
    /**
     * Create HTML link element from data item
     * 
     * @param array $group
     * @param string $indent
     * @param bool $disableProxy
     * @return string
     */
    public function groupToString($group, $indent, $disableProxy)
    {
        if ($disableProxy) {
            $items = array();
            foreach ($group as $item) {
                $items[] = $this->itemToString($item);
            }
            $html = $indent . implode($this->_escape($this->getSeparator()) . $indent, $items);
        } else {
            $item = current($group);
            $attributes = (array) $item;
            $html = '<link ';
            
            foreach ($group as $item) {
                $hrefs[] = trim($this->getCss($item->href), '/');
            }
            $html .= 'href="'.$this->view->baseUrl.'/min.php?f=' . implode(',', $hrefs) . '" ';
            
            $this->_completeItem($html, $attributes);
        }
        
        return $html;
    }
    
    /**
     * Completes HTML link element
     * 
     * @param string $item
     * @param array $attributes
     * @return void
     */
    private function _completeItem(&$item, $attributes)
    {
        foreach ($this->_itemKeys as $itemKey) {
            if ($itemKey == 'href') {
                continue;
            }
            if (isset($attributes[$itemKey])) {
                if(is_array($attributes[$itemKey])) {
                    foreach($attributes[$itemKey] as $key => $value) {
                        $item .= sprintf('%s="%s" ', $key, ($this->_autoEscape) ?
                            $this->_escape($value) : $value);
                    }
                } else {
                    $item .= sprintf('%s="%s" ', $itemKey, ($this->_autoEscape) ?
                        $this->_escape($attributes[$itemKey]) : $attributes[$itemKey]);
                }
            }
        }

        if ($this->view instanceof Zend_View_Abstract) {
            $item .= ($this->view->doctype()->isXhtml()) ? '/>' : '>';
        } else {
            $item .= '/>';
        }

        if (($item == '<link />') || ($item == '<link >')) {
            $item = '';
        } elseif (isset($attributes['conditionalStylesheet'])
            && !empty($attributes['conditionalStylesheet'])
            && is_string($attributes['conditionalStylesheet'])) {
            
            $item = '<!--[if ' . $attributes['conditionalStylesheet'] . ']> ' 
                  . $item
            . '<![endif]-->';
        }
    }
    
    /**
     * Render link elements as string
     *
     * @param  string|int $indent
     * @return string
     */
    public function toString($indent = null)
    {
        $indent = (null !== $indent)
                ? $this->getWhitespace($indent)
                : $this->getIndent();

        $items = array();
        $this->getContainer()->ksort();
        $groups = array();
        foreach ($this as &$item) {
            if (isset($item->disableProxy) && $item->disableProxy) {
                $groups['disableProxy'][] =& $item;
            } else {
                if ($item->rel == 'stylesheet') {
                    if (isset($item->conditionalStylesheet)
                        && !empty($item->conditionalStylesheet)
                        && is_string($item->conditionalStylesheet)) {
                            
                        $groups[$item->conditionalStylesheet][] =& $item;
                    } elseif (isset($item->media)
                        && !empty($item->media)
                        && is_string($item->media)) {
                            
                        $groups[$item->media][] =& $item;
                    }
                } else {
                    $items[] = $this->itemToString($item);
                }
            }
        }
        
        foreach ($groups as $key => $group) {
            $items[] = $this->groupToString($group, $indent, $key == 'disableProxy');
        }

        return $indent . implode($this->_escape($this->getSeparator()) . $indent, $items);
    }
    
    /**
     * Create data item for stack
     *
     * @param  array $attributes
     * @return stdClass
     */
    public function createData(array $attributes)
    {
        $attributes['disableProxy'] = !$this->_useProxy;
        $data = (object) $attributes;
        return $data;
    }
}
