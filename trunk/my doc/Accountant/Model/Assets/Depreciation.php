<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      datnh
 */
class Quick_Accountant_Model_Assets_Depreciation extends Quick_Db_Table {
	
	protected $_name = 'accountant_assets_depreciation';
	
		
	/**
	 * Get list asset depreciation
	 * @author datnh
	 */
	public function getAssetsDepreciationById($data, &$total){			
		$total = $this->getAssetsDepreciationSize($data);				
		return $this->getAssetsDepreciationList($data);
	}
	
	/**
	 * Get size of list
	 * @author datnh
	 */
	private function getAssetsDepreciationSize($data) {
		$data['assets_voucher_id'] = isset($data['assets_voucher_id']) ? $data['assets_voucher_id']: 0;
		$select = $this->getAdapter()->select();
		$select->from(array('aad' => $this->_name), array('count(*)'))		
			->where("aad.assets_voucher_id =(?)", $data['assets_voucher_id']);
							
		return $this->getAdapter()->fetchOne($select->__toString());
	}
	/**
	 * Get assetvoucher list
	 * @author datnh
	 */
	private function getAssetsDepreciationList($data) {
		$data['assets_voucher_id'] = isset($data['assets_voucher_id']) ? $data['assets_voucher_id']: 0;
		$limit = isset($data['limit']) ? $data['limit'] : $this->pageSize;
		$start = isset($data['start']) ? $data['start'] : 0;
		if ($start == '') {
			$start = 0;
		}				
		//Get records
		$select = $this->getAdapter()->select();
		$select->from(array('aad' => $this->_name),
					array('aad.assets_voucher_id AS assets_voucher_id',
							'DATE_FORMAT(aad.depreciation_date, \'%Y/%m/%d\') AS depreciation_date_hdn',
							'DATE_FORMAT(aad.depreciation_date, \'%Y/%m/%d\') AS depreciation_date',
							'aad.voucher_id AS voucher_id',
							'aad.depreciation_note AS depreciation_note',
							'aad.depreciation_amount AS depreciation_amount'))

		->where("aad.assets_voucher_id =(?)", $data['assets_voucher_id'])
		->limit($limit, $start);
					
		return $this->getAdapter()->fetchAll($select->__toString());
	}
	
	/**
	 * Get all assets depreciation by asset_voucher_id
	 * @author datnh
	 */
	public function getAssetsDepreciationByAssetVoucherId($assets_voucher_id) {		
		$select = $this->getAdapter()->select();
        $select->from(array('aad' => $this->_name));
        $select->where("aad.assets_voucher_id =(?)", $assets_voucher_id);	
           
     	return $this->getAdapter()->fetchAll($select->__toString());		
	}
	
	/**
	 * Insert asset depreciation
	 * @author	datnh
	 * @return array
	 */
	public function insertAssetsDepreciation($assetsDepreciation = array())	{		
		return $this->insert($assetsDepreciation);		
	}
	
	/**
	 * Check primary key of asset depreciation existed
	 * @author datnh
	 *
	 */

	public function checkAssetDepreciationExisted($assetsDepreciation = array()) {
		$result = array();	
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('assets_voucher_id = ?', $assetsDepreciation['assets_voucher_id']),
						$db->quoteInto('DATE(depreciation_date) = ?', $assetsDepreciation['depreciation_date'])));		
		if (isset($row)) {	
			return true;
		}			
		return false;
	}
	
	/**
	 * 	Update AssetsDepreciation
	 *	@author datnh
	 */
	public function updateAssetsDepreciation($data) {
		$result = array();		
		$db = $this->getAdapter();
		$row = $this->fetchRow(array($db->quoteInto('assets_voucher_id = ?', $data['assets_voucher_id']),
									$db->quoteInto('depreciation_date = ?', $data['depreciation_date_hdn'])));		
		if (isset($row)) {	
			if($data['depreciation_date'] != $data['depreciation_date_hdn']) {
				$rowWithNewKey = $this->fetchRow(array($db->quoteInto('assets_voucher_id = ?', $data['assets_voucher_id']),
										$db->quoteInto('depreciation_date = ?', $data['depreciation_date'])));	
										
				if(isset($rowWithNewKey)) {
					//Error existed
					$result['errs'] = 1;
				}else{
					$row = array(
						'assets_voucher_id' => $data['assets_voucher_id'],
						'depreciation_date' => $data['depreciation_date'].' '.date('H:i:s'),
						'depreciation_note' => $data['depreciation_note'],
						'depreciation_amount' => $data['depreciation_amount'],		
						'last_modified_by_userid' => Quick::session()->userId,
						'date_last_modified' => Quick_Date::now()->toSQLString()
					);			
					$result['result'] = $this->update($row, array($db->quoteInto('assets_voucher_id = ?', $data['assets_voucher_id']),
											$db->quoteInto('depreciation_date = ?', $data['depreciation_date_hdn'])));				
				}				
			}else{
				$row = array(
						'assets_voucher_id' => $data['assets_voucher_id'],
						'depreciation_date' => $data['depreciation_date'].' '.date('H:i:s'),
						'depreciation_note' => $data['depreciation_note'],
						'depreciation_amount' => $data['depreciation_amount'],		
						'last_modified_by_userid' => Quick::session()->userId,
						'date_last_modified' => Quick_Date::now()->toSQLString()
					);			
					$result['result'] = $this->update($row, array($db->quoteInto('assets_voucher_id = ?', $data['assets_voucher_id']),
											$db->quoteInto('depreciation_date = ?', $data['depreciation_date_hdn'])));			
			}
		}else{
			$result['errs'] = 2;
		}
		return $result;
	}
	
	/**
	 * Update asset depreciation amounts by asset_voucher_id
	 * @author datnh
	 */
	public function updateRecordAssetsDepreciationByAssetVoucherId($depreciations, $assets_voucher_id) {
		$db = $this->getAdapter();			
		return $this->update($depreciations, $db->quoteInto('assets_voucher_id = ?', $assets_voucher_id));
	}
}
