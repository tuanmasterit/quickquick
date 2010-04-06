<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Config_Field extends Quick_Db_Table
{
    protected $_name = 'core_config_field';
    
/**
     *
     * @param string $key
     * @param int $siteId[optional]
     * @return array
     */
    public function getFieldsByKey($key, $siteId = 1) 
    {
        $hasCache =  (bool) Zend_Registry::isRegistered('cache') ?
            Quick::cache() instanceof Zend_Cache_Core : false;

        if (!$hasCache
            || !$fields = Quick::cache()->load("config_{$key}_site_{$siteId}")) {

            $fields = $this->getAdapter()->fetchAssoc(
                "SELECT f.path, f.config_type, v.value, f.model " .
                "FROM {$this->_name} f " .
                "INNER JOIN " . self::$_db_prefix . "core_config_value v ON v.config_field_id = f.id " .
                "WHERE f.path LIKE '{$key}/%' AND v.site_id IN('0', ?) " .
                "ORDER BY v.site_id",
                $siteId
            );

            if ($hasCache) {
                Quick::cache()->save(
                    $fields, "config_{$key}_site_{$siteId}", array('config')
                );
            }
        }
        return $fields;
    }
}