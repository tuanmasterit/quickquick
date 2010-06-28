<?php
/**
 *
 * @category    Tax
 * @package     Quick_Accountant
 * @author      datnh
 */
class Quick_Accountant_Remoter_TaxCatalog {

	/**
	 * Get list of Tax
	 * url: accountant_list_tax
	 * @author	datnh
	 * @return list
	 */
	public static function getListTax() {		
		return Quick::single('accountant/list_tax')->cache()->getListTax();
	}
	/**
	 * Get list of TaxRate
	 * url: accountant_list_tax
	 * @author	datnh
	 * @return list
	 */
	public static function getListTaxRate($tax_id, $limit, $start, &$total) {
		return Quick::single('accountant/list_tax')->cache()->getListTaxRate($tax_id, $limit, $start, &$total);
	}
	
	/**
	 * Update TaxRate
	 * url: accountant_tax_rate
	 * @author datnh
	 */
	public static function updateTaxRate($tax_rate_id, $field, $value, $tax_id, $rate) {		
		return Quick::single('accountant/tax_rate')->cache()->updateTaxRate($tax_rate_id, $field, $value, $tax_id, $rate);
	}
	
	/**
	 * Insert TaxRate
	 * @author datnh
	 */
	public static function insertTaxRate($value, $tax_id) {		
		
		$taxRate = array(				
			'tax_id' => $tax_id,
			'rate' => $value,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/tax_rate')->cache()->insertTaxRate($taxRate);
		if ($newId) {
			return $newId;
		} else {
			return null;
		}				
	}
	
	/**
	 * Get list of specification
	 * @author datnh
	 *
	 */
	public static function getListSpecification($limit, $start, &$total) {
		return Quick::single('accountant/list_specification')->cache()->getListSpecification($limit, $start, &$total);
	}
	
	/**
	 * Insert Specification
	 * @author datnh
	 */
	public static function insertSpecification($value) {	
		$spec = array(				
			'specification_name' => $value,
			'inactive' => 0,
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/list_specification')->cache()->insertSpecification($spec);
		if ($newId) {
			return $newId;
		} else {
			return null;
		}				
	}
	
	/**
	 * Update Specification
	 * @author datnh
	 */
	public static function updateSpecification($specification_id, $field, $value) {
		return Quick::single('accountant/list_specification')->cache()->updateSpecification($specification_id, $field, $value);
	}
	
	/**
	 * Get list tax_rate by tax_id
	 * @author datnh
	 */
	public static function getListTaxRateByTaxId($tax_id) {
		return Quick::single('accountant/list_tax')->cache()->getListTaxRateByTaxId($tax_id);
	}
	
	/**
	 * getList Specification list For Product
	 * @author datnh
	 */
	public static function getListSpecForProduct() {
		return Quick::single('accountant/list_tax')->cache()->getListSpecForProduct();
	}
	
	/**
	 * Get list products 
	 * @author datnh 
	 */
	public static function getListProduct($data, &$total) {
		return Quick::single('accountant/list_product')->cache()->getListProduct($data, &$total);
	}
	
	/**
	 * Insert relation_tax
	 * @author datnh
	 */
	public static function insertRelationTax($data){
		$relationTax = array(				
			'product_id' => $data['product_id'],
			'tax_id' => $data['tax_id'],
			'specification_id' => $data['specification_id'],
			'tax_rate_id' => $data['tax_rate_id'],
			'created_by_userid' => Quick::session()->userId,
			'date_entered' => Quick_Date::now()->toSQLString(),
			'last_modified_by_userid' => Quick::session()->userId,
			'date_last_modified' => Quick_Date::now()->toSQLString()
		);
		$newId = Quick::single('accountant/relation_tax')->cache()->insertRelationTax($relationTax);
		if ($newId) {
			$result['product_id'] 		= $data['product_id'];
			$result['tax_id'] 			= $data['tax_id'];
			$result['specification_id'] = $data['specification_id'];
			$result['tax_rate_id'] 		= $data['tax_rate_id'];
			return $result;
		} else {
			return null;
		}				
	}
	
	/**
	 * Insert relation_tax by array
	 * @author datnh
	 */
	public static function insertRelationTaxByArr($arrRelationTax) {
		$result = true;
		foreach($arrRelationTax as $relationTax){
			$recordRelationTax = array(				
				'product_id' => $relationTax['product_id'],
				'tax_id' => $relationTax['tax_id'],
				'specification_id' => $relationTax['specification_id'],
				'tax_rate_id' => $relationTax['tax_rate_id'],
				'created_by_userid' => Quick::session()->userId,
				'date_entered' => Quick_Date::now()->toSQLString(),
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			$result &= Quick::single('accountant/relation_tax')->cache()->insertRelationTax($recordRelationTax);
		}
		return $result;
	}
	
	/**
	 * Delete relation_tax
	 * @author datnh
	 */
	public static function deleteRelationTax($data) {
		return Quick::single('accountant/relation_tax')->cache()->deleteRelationTax($data);
	}
	
	/**
	 * Delete relation_tax by array
	 * @author datnh
	 */
	public static function deleteRelationTaxByArr($arrRelationTax){
		$result = true;
		foreach($arrRelationTax as $relationTax){
			$result &= Quick::single('accountant/relation_tax')->cache()->deleteRelationTax($relationTax);
		}
		return $result;
	}
	
	/**
	 * Delete tax_rate by array
	 * @author datnh
	 */
	public static function deleteTaxRateByArr($arrTaxRateId) {
		$result = true;
		foreach($arrTaxRateId as $tax_rate_id){
			$result &= Quick::single('accountant/relation_tax')->cache()->deleteRelationTaxByField('tax_rate_id',$tax_rate_id);
			$result &= Quick::single('accountant/tax_rate')->cache()->deleteTaxRateByTaxRateId($tax_rate_id);
		}
		return $result;
	}
	
	/**
	 * Delete Specification by array
	 * @author datnh
	 */
	 
	public static function deleteSpecificationByArr($arrSpecificationId) {
		$result = true;
		foreach($arrSpecificationId as $specification_id){
			$result &= Quick::single('accountant/relation_tax')->cache()->deleteRelationTaxByField('specification_id', $specification_id);
			$result &= Quick::single('accountant/list_specification')->cache()->deleteSpecificationBySpecId($specification_id);
		}
		return $result;
	}
	
}
?>