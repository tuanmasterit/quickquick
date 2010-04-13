<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Module_Language extends Quick_Db_Table
{
	protected $_name = 'core_module_language';
	protected $_rowClass = 'Quick_Db_Table_Row';

	/**
	 * Retrieve the value for translation
	 *
	 * @param string $module
	 * @param string $locale
	 * @param string $key
	 * @return translated value
	 */
	public function getTranslatedValue($module, $locale, $key){
		$select = $this->getAdapter()->select();
		$select->from(
					array('cml' => $this->_name), 
					array('cml.key', 'cml.value'))
				->joinLeft(
					array('cm' => 'core_module'), 
					"cm.id = cml.module_id", 
					array('package'))
				->joinLeft(
					array('cl' => 'core_language'), 
					"cl.id = cml.language_id", 
					array('locale'))
				->where('cm.package = ?', $module)
				->where('cl.locale = ?', $locale)
				->where('cml.key = ?', $key);
		$rows = $select->query()->fetch();
		return $rows['value'];
	}
}