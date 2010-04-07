<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Config_Value extends Quick_Db_Table
{
    protected $_name = 'core_config_value';

    /**
     *
     * @param string $path
     * @param int $siteId
     * @return <type>
     */
    public function getValue($path, $siteId)
    {
        $where = array(
            $this->getAdapter()->quoteInto('path = ?', $path),
            $this->getAdapter()->quoteInto(
                'site_id IN(?)', array_unique(array('0', $siteId))
            )
        );
        $row = $this->fetchRow($where, 'site_id desc');
        if ($row) {
            return $row->value;
        }
        return '';
    }

    /**
     *
     * @param string $path
     * @param array $siteIds
     * @return array
     */
    public function getValues($path, $siteIds = null)
    {
        
        if (!$siteIds) {
            $siteIds = array_keys(Quick_Collect_Site::collect());
        }
        $siteIds[count($siteIds) + 1] = 0;
        
        $select = $this->getAdapter()->select();
        $select->from(array('cv' => $this->_name), array('site_id', 'value'));
        $select->where($this->getAdapter()->quoteInto('path = ?', $path))
               ->where($this->getAdapter()->quoteInto('site_id IN(?)', 
                   array_unique($siteIds))
        );
        return $this->getAdapter()->fetchPairs($select->__toString());
    }
    
    /**
     * Update config value
     * 
     * @param array $data
     * @return bool
     */
    public function save($data)
    {
        if (!$row = $this->fetchRow($this->_name . '.`path` = "' . $data['path'] . '"')) {
            Quick::message()->addError("Config field '%s' was not found", $data['path']);
            return false;
        }
        $row->value = $data['value'];
        $row->site_id = isset($data['site_id']) ? $data['site_id'] : 0;
        $row->save();
        Quick::message()->addSuccess('Data was saved successfully');
        return true;
    }
    
    /**
     * Removes config values, and all of it childrens
     * 
     * @param string $path
     * @return Quick_Core_Model_Config_Value Provides fluent intarface
     */
    public function remove($path)
    {
        $this->delete("path LIKE '{$path}%'");
        return $this;
    }
}