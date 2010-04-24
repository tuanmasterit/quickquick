<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Cache
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Cache extends Quick_Db_Table
{    
    protected $_name = 'core_cache';

    /**
     * @var array
     */
    private $_lifetime = array();
    
    /**
     * Returns an instance of Zend_Cache_Core
     *
     * @static
     * @return Zend_Cache_Core Provides a fluent interface
     */
    public static function getCache()
    {
        if (!Zend_Registry::isRegistered('cache') 
            || !(Zend_Registry::get('cache') instanceof Zend_Cache_Core))
        {
            $defaultLifetime = Quick::single('core/config_value')->fetchOne(
                'value', 
                'path = ?', 
                array('cache/main/default_lifetime')
            );
            $frontendOptions = array(
                'lifetime' => $defaultLifetime,
                'automatic_serialization' => true
            );
            $cacheDir = Quick::config()->system->path . '/var/cache';
            if (!is_readable($cacheDir)) {
                mkdir($cacheDir, 0777);
            } elseif(!is_writable($cacheDir)) {
                chmod($cacheDir, 0777);
            }
            $backendOptions = array(
                'cache_dir' => $cacheDir,
                'hashed_directory_level' => 1,
                'file_name_prefix' => 'Quick_cache',
                'hashed_directory_umask' => 0777
            );
            Zend_Registry::set('cache', Zend_Cache::factory(
                'Core', 'Quick_Cache_Backend_File', 
                $frontendOptions, 
                $backendOptions,
                false,
                true
            ));
        }
        return Zend_Registry::get('cache');
    }
    
    /**
     * Retrieve array of cache tags with their lifetimes
     * 
     * @return array
     */
    public function getList()
    {
        $query = "SELECT *
            FROM {$this->_name}";
        
        return $this->getAdapter()->fetchAll($query);
    }
    
    /**
     * Retrieve the list of disabled tags
     * 
     * @return array
     */
    public function getDisabled()
    {
        $query = "SELECT name
            FROM {$this->_name}
            WHERE is_active = 0";
        
        return $this->getAdapter()->fetchCol($query);
    }
    
    /**
     * Retrieve the lifetime for the array of tags
     * In case if tags have different lifetime values - 
     * min value will be returned
     * 
     * @param mixed $tags
     * @return mixed (integer|false)
     */
    public function getLifetimeByTags($tags)
    {
        if (!is_array($tags)) {
            $tags = array($tags);
        }
        $key = implode('-', $tags);
        if (!array_key_exists($key, $this->_lifetime)) {
            $select = $this->getAdapter()->select()
                ->from(array('c' => $this->_name), 'lifetime')
                ->where('c.name IN (?)', $tags);
            
            $result = array_filter($this->getAdapter()->fetchCol($select));
            
            if (!count($result) || min($result) == 0) {
                $this->_lifetime[$key] = false;
            } else {
                $this->_lifetime[$key] = min($result);
            }
        }
        return $this->_lifetime[$key];
    }
    
    /**
     * Updates the cache rows
     * 
     * @param array $data
     * @return bool
     */
    public function save($data)
    {
        foreach ($data as $id => $values) {
            if (!$row = $this->find($id)->current()) {
                $row = $this->createRow();
                $row->name = $values['name'];
            }
            if (is_array($values)) {
                $row->is_active = $values['is_active'];
                $row->lifetime = (int)$values['lifetime'] ?
                    (int)$values['lifetime'] : new Zend_Db_Expr('NULL');
            } else {
                $row->is_active = $values;
            }
            $row->save();
        }
        Quick::message()->addSuccess('Data was saved successffully');
        return true;
    }
    
    /**
     * Inserts row to core_cache table
     * 
     * @param string $name
     * @param int $is_active
     * @param int $lifetime
     * @return Quick_Core_Model_Cache Provides fluent interface
     */
    public function add($name, $is_active = 1, $lifetime = null)
    {
        if ($this->fetchOne('id', "name = '{$name}'")) {
            return $this;
        }
        
        $this->createRow(array(
            'name' => $name,
            'is_active' => $is_active,
            'lifetime' => $lifetime
        ))->save();
        
        return $this;
    }
    
    /**
     * Clear cache linked with any of recieved tags
     * 
     * @param mixed $tags
     * @return boolean
     */
    public function clean($tags)
    {
        if (!is_array($tags)) {
            $tags = array($tags);
        }
        return self::getCache()->clean('matchingAnyTag', $tags);
    }
}