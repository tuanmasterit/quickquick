<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Cache
 * @subpackage  Backend
 * @author      trungpm
 */
class Quick_Cache_Backend_File extends Zend_Cache_Backend_File  
{
    private $_disabledTags = array();

    /**
     *
     * @param array $options
     */
    public function __construct(array $options = array())
    {
        parent::__construct($options);
        $this->_disabledTags = Quick::single('core/cache')->getDisabled();
    }

    /**
     * Extended parent save method
     * Save some string datas into a cache record
     *
     * Note : $data is always "string" (serialization is done by the
     * core not by the backend)
     *
     * @param  string $data             Datas to cache
     * @param  string $id               Cache id
     * @param  array  $tags             Array of strings, the cache record will be tagged by each string entry
     * @param  int    $specificLifetime If != false, set a specific lifetime for this cache record (null => infinite lifetime)
     * @return boolean true if no problem
     */
    public function save($data, $id, $tags = array(), $specificLifetime = false)
    {   
        if (count(array_intersect($tags, $this->_disabledTags))) {
            return false;
        }
        
        if (!$specificLifetime && count($tags)) {
            $specificLifetime = Quick::single('core/cache')->getLifetimeByTags($tags);
        }
        return parent::save($data, $id, $tags, $specificLifetime);
    }
    
    /**
     * Extended parent load method
     * Test if a cache is available for the given id and (if yes) return it (false else)
     *
     * @param string $id cache id
     * @param boolean $doNotTestCacheValidity if set to true, the cache validity won't be tested
     * @return string|false cached datas
     */
    public function load($id, $doNotTestCacheValidity = false)
    {
        $metadatas = $this->getMetadatas($id);
        
        if (count($metadatas['tags'])) {
            if (count(array_intersect($metadatas['tags'], $this->_disabledTags))) {
                return false;
            }
        }
        
        return parent::load($id, $doNotTestCacheValidity);
    }
    
    /**
     * Extended parent test method
     * Test if a cache is available or not (for the given id)
     *
     * @param string $id cache id
     * @return mixed false (a cache is not available) or "last modified" timestamp (int) of the available cache record
     */
    public function test($id)
    {
        $metadatas = $this->getMetadatas($id);
        
        if (count($metadatas['tags'])) {
            if (count(array_intersect($metadatas['tags'], $this->_disabledTags))) {
                return false;
            }
        }
        return parent::test($id);
    }
       
}