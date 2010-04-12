<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Auth
 * @author      trungpm
 */
class Quick_Auth_Observer
{
    /**
     * Array of loaded event information
     * @var array
     */
    private $_events = array();
    
    /**
     * Singleton instance
     * @var Quick_Event_Observer
     */
    private static $_instance = null;
    
    /**
     * Reads the event config from modules configuration
     * and cache it
     * 
     * @constructor
     */
    private function __construct()
    {
        if ($result = Quick::cache()->load('module_event_list')) {
            $this->_events = $result;
        } else {
            foreach (Quick::single('core/module')->getConfig() as $code => $config) {
                if (isset($config['events']) && is_array($config['events'])) {
                    foreach ($config['events'] as $eventName => $action) {
                        foreach ($action as $key => $value) {
                            if (!is_array($value) || !count($value)) {
                                continue;
                            }
                            $this->_events[$eventName][] = $value;
                        }
                    }
                }
            }
            Quick::cache()->save(
                $this->_events, 'module_event_list', array('modules')
            );            
        }
    }
    
    /**
     * Retrieve singleton instance of Quick_Event_Observer
     * 
     * @return Quick_Event_Observer
     */
    public static function getInstance()
    {
        if (null === self::$_instance) {
            self::$_instance = new self();
        }
        return self::$_instance;
    }
    
    /**
     * Dispatch event by name
     * 
     * @param string $name
     * @param array $data [optional]
     * @return Quick_Auth_Observer Provides fluent interface
     */
    public function dispatch($name, array $data = array())
    {
        if (isset($this->_events[$name])) {        	
            foreach ($this->_events[$name] as $observer) {
                if (isset($observer['args'])) {
                    if (is_array($observer['args'])) {
                        $data += $observer['args'];
                    } else {
                        $data[] = $observer['args'];
                    }
                }
                Quick::$observer['type']($observer['model'])->$observer['method']($data);
            }
        }
        return $this;
    }
}
