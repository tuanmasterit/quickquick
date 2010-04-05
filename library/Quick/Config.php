<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Config
 * @author      trungpm
 */
class Quick_Config extends Zend_Config
{
    private $_siteId = null;
    
    const MULTI_SEPARATOR = ',';
    
    /**
     * @constructor
     * @param  array   $array
     * @param  boolean $allowModifications
     * @return void
     */
    public function __construct(array $array, $allowModifications = false)
    {
        $this->_allowModifications = (boolean) $allowModifications;
        $this->_loadedSection = null;
        $this->_index = 0;
        $this->_data = array();
        foreach ($array as $key => $value) {
            if (is_array($value)) {
                $this->_data[$key] = new self($value, $this->_allowModifications);
            } else {
                $this->_data[$key] = $value;
            }
        }
        $this->_count = count($this->_data);
    }
    
    public function setSiteId($siteId)
    {
        $this->_siteId = $siteId;
    }
    
    public function get($name, $default = null)
    {
        if (strstr($name, '/')) {
            $sections = explode('/', $name);
        } else {
            $sections = array($name);
        }
        
        $section = array_shift($sections);
        if (!array_key_exists($section, $this->_data)) {
            $this->_load($section, $default);
        }
        
        $result = isset($this->_data[$section]) ? $this->_data[$section] : $default;
        
        foreach ($sections as $section) {
            if (!$result instanceof Ecart_Config) {
                $result = $default;
                break;
            }
            $result = isset($result->_data[$section]) ? $result->_data[$section] : $default;
        }
        
        return $result;
    }
    
    private function _load($key, $default)
    {    	
        if (null === $this->_siteId) {
        	echo $key;
            $this->_siteId = Quick::getSiteId();
        }
        
        $rows = Ecart::single('core/config_field')->getFieldsByKey(
            $key, $this->_siteId
        );
        $this->_siteId = null;
        
        if (!sizeof($rows)) {
            $this->_data[$key] = $default;
            return;
        }
        
        $values = array();
        foreach ($rows as $path => $row) {
            $parts = explode('/', $path);
            switch ($row['config_type']) {
                case 'string':
                    $value = $row['value'];
                    break;
                case 'select':
                    $value = $row['value'];
                    break;
                case 'bool':
                    $value = (bool) $row['value'];
                    break;
                case 'handler':
                    $class = 'Ecart_Collect_Handler_' . ucfirst($row['model']);
                    if ($row['model']) {
                        $value = call_user_func(array($class, 'getConfig'), $row['value']);
                    } else {
                        $value = $row['value'];
                    }
                    break;
                case 'multiple':
                    if (empty ($row['value'])) {
                        $value = array();
                    } else {
                        $value = explode(self::MULTI_SEPARATOR, $row['value']);
                    }
                    break;
                default:
                    $value = $row['value'];
                    break;
            }
            $values[$parts[0]][$parts[1]][$parts[2]] = $value;
        }
        foreach ($values as $key => $value) {
            if (is_array($value)) {
                $this->_data[$key] = new Ecart_Config($value, $this->_allowModifications);
            } else {
                $this->_data[$key] = $value;
            }
        }
    }
    
}