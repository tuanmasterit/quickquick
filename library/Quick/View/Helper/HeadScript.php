<?php
/**
 *
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Helper
 * @author      trungpm
 */

class Quick_View_Helper_HeadScript extends Zend_View_Helper_HeadScript
{
    /**
     * Flag that is responsible for script rendering mode
     * @var bool
     */
    private $_useProxy = false;
    
    /**
     * Return headScript object
     *
     * Returns headScript helper object; optionally, allows specifying a script
     * or script file to include.
     *
     * @param  string $mode Script or file
     * @param  string $spec Script/url
     * @param  string $placement Append, prepend, or set
     * @param  array $attrs Array of script attributes
     * @param  string $type Script type and/or array of script attributes
     * @return Zend_View_Helper_HeadScript
     */
    public function headScript(
        $mode = Zend_View_Helper_HeadScript::FILE,
        $spec = null,
        $placement = 'APPEND',
        array $attrs = array(),
        $type = 'text/javascript')
    {
        $this->_useProxy = false;
        return parent::headScript($mode, $spec, $placement, $attrs, $type);
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
    public function getJs($js, $absolute = false)
    {
        if (strstr($js, 'http://') || strstr($js, 'https://')) {
            return $js;
        }
        
        $file = '/skin/' . $this->view->applicationName . '/' 
            . $this->view->templateName . '/js/' . $js;
         
        if (!is_readable($this->view->path . $file)) {
            $file = '/skin/' . $this->view->applicationName
                  . '/default/js/' . $js;
        }
        if (!is_readable($this->view->path . $file)) {
            $file = $js;
        }
        
        $baseUrl = $absolute ? 
            $this->view->baseUrl : Zend_Controller_Front::getInstance()->getBaseUrl();
        
        return $baseUrl . '/' . trim($file, '/');
    }
    
    /**
     * Create script HTML
     */
    public function itemToString($item, $indent, $escapeStart, $escapeEnd)
    {
        $type = ($this->_autoEscape) ? $this->_escape($item->type) : $item->type;
        $html = $indent . '<script type="' . $type . '"';
        
        if (isset($item->attributes['src'])) {
            $html .= ' src="' . $this->getJs($item->attributes['src']) . '"';
        }
        
        $this->_completeItem($html, $item, $indent, $escapeStart, $escapeEnd);

        return $html;
    }
    
    /**
     * Create script HTML
     */
    public function groupToString($group, $indent, $escapeStart, $escapeEnd, $disableProxy)
    {
        if ($disableProxy) {
            $items = array();
            foreach ($group as $item) {
                $items[] = $this->itemToString($item, $indent, $escapeStart, $escapeEnd);
            }
            $html = implode($this->getSeparator(), $items);
        } else {
            $item = current($group);
            $type = ($this->_autoEscape) ? $this->_escape($item->type) : $item->type;
            $html = $indent . '<script type="' . $type . '"';
            
            if (isset($item->attributes['src'])) {
                foreach ($group as $item) {
                    $srcs[] = trim($this->getJs($item->attributes['src']), '/');
                }
                
                $html .= ' src="' . $this->view->baseUrl . '/' . implode(',', $srcs) . '"';
            }

            $this->_completeItem($html, $item, $indent, $escapeStart, $escapeEnd);
        }
        
        return $html;
    }
    
     /**
     * Completes HTML link element
     */
    private function _completeItem(&$html, $item, $indent, $escapeStart, $escapeEnd)
    {
        $attrString = '';
        if (!empty($item->attributes)) {
            foreach ($item->attributes as $key => $value) {
                if ('src' == $key) {
                    continue;
                }
                if (!$this->arbitraryAttributesAllowed()
                    && !in_array($key, $this->_optionalAttributes)) {
                        
                    continue;
                }
                if ('defer' == $key) {
                    $value = 'defer';
                }
                $attrString .= sprintf(' %s="%s"', $key, ($this->_autoEscape) ? $this->_escape($value) : $value);
            }
        }
        
        $html .= $attrString . '>';
        if (!empty($item->source)) {
            $html .= PHP_EOL . $indent . '    ' . $escapeStart . PHP_EOL . $item->source . $indent . '    ' . $escapeEnd . PHP_EOL . $indent;
        }
        $html .= '</script>';

        if (isset($item->attributes['conditional'])
            && !empty($item->attributes['conditional'])
            && is_string($item->attributes['conditional'])) {
            
            $html = '<!--[if ' . $conditional . ']> ' . $html . '<![endif]-->';
        }
    }

    /**
     * Retrieve string representation
     *
     * @param  string|int $indent
     * @return string
     */
    public function toString($indent = null)
    {
        $indent = (null !== $indent)
                ? $this->getWhitespace($indent)
                : $this->getIndent();

        if ($this->view) {
            $useCdata = $this->view->doctype()->isXhtml() ? true : false;
        } else {
            $useCdata = $this->useCdata ? true : false;
        }
        $escapeStart = ($useCdata) ? '//<![CDATA[' : '//<!--';
        $escapeEnd   = ($useCdata) ? '//]]>'       : '//-->';

        $items = array();
        $this->getContainer()->ksort();
        $groups = array();
        foreach ($this as &$item) {
            if (!$this->_isValid($item)) {
                continue;
            }
            
            if ($item->attributes['disableProxy']) {
                $groups['disableProxy'][] =& $item;
            } else {
                if (isset($item->attributes['conditional'])
                    && !empty($item->attributes['conditional'])
                    && is_string($item->attributes['conditional'])) {
                    
                    $groups[$item->attributes['conditional']][] =& $item;
                } elseif (empty($item->source)) {
                    $groups['general'][] =& $item;
                } else {
                    $groups['script'][] =& $item;
                }
            }
        }
        
        foreach ($groups as $key => $group) {
            $items[] = $this->groupToString($group, $indent, $escapeStart, $escapeEnd, $key == 'disableProxy');
        }
        
        $return = implode($this->getSeparator(), $items);
        return $return;
    }
    
    /**
     * Create data item containing all necessary components of script
     *
     * @param  string $type
     * @param  array $attributes
     * @param  string $content
     * @return stdClass
     */
    public function createData($type, array $attributes, $content = null)
    {
        $data             = new stdClass();
        $data->type       = $type;
        $data->attributes = $attributes;
        $data->attributes['disableProxy'] = !$this->_useProxy;
        $data->source     = $content;
        return $data;
    }
}
