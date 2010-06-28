<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Model
 * @author      datnh
 */
class Quick_Accountant_Model_List_Product extends Quick_Db_Table
{
	protected $_name = 'accountant_relation_tax';
	protected $pageSize = 10;

	/**
	 * Get list of product by search condition
	 *	@author datnh
	 */
	public function getListProduct($data, &$total) {
	
		$data['tax_id'] = isset($data['tax_id']) ? $data['tax_id'] : -1;
		$data['tax_rate_id'] = isset($data['tax_rate_id']) ? $data['tax_rate_id'] : -1;
		$data['specification_id'] = isset($data['specification_id']) ? $data['specification_id'] : -1;
				
		$limit = isset($data['limit']) ? $data['limit'] : $this->pageSize;
		$start = isset($data['start']) ? $data['start'] : 0;
		if ($start == '') {
			$start = 0;
		}
		$pagingSize = '';
		if ($limit > 0) {
			$pagingSize = " LIMIT $start, $limit";
		}

		//Get size:
		$query_size = "SELECT COUNT(*)
						FROM
							definition_list_product AS dlp
							Left Join definition_list_subject AS dls ON dlp.producer_id = dls.subject_id
							Left Join 
							(Select 
								product_id,
								tax_id,
								specification_id,
								tax_rate_id
							FROM accountant_relation_tax 
							WHERE ";
							$query_size .= " tax_id = ".$data['tax_id'];
							$query_size .= " AND tax_rate_id = ".$data['tax_rate_id'];
							$query_size .= " AND specification_id = ".$data['specification_id'];						
							$query_size .= " ) t ON dlp.product_id = t.product_id 
						WHERE
							dls.is_producer =  1";
							if(isset($data['product_code'])) $query_size .= " AND dlp.product_code LIKE '%".trim($data['product_code'])."%'";
							if(isset($data['product_name'])) $query_size .= " AND dlp.product_name LIKE '%".trim($data['product_name'])."%'";	
		$total = $this->getAdapter()->fetchOne($query_size);
		
		//Get data with limit
				
		$query = "SELECT
						dlp.product_id,
						dlp.product_code,
						dlp.product_name,
						dlp.producer_id,
						dlp.product_model,
						dlp.product_picture,
						dlp.product_description,
						dlp.base_unit_id,
						dlp.regular_unit_id,
						dlp.inactive,
						dlp.created_by_userid,
						dlp.date_entered,
						dlp.last_modified_by_userid,
						dlp.date_last_modified,
						ifnull(t.tax_id,0) AS tax_id,
						ifnull(t.specification_id,0) AS specification_id,
						ifnull(t.tax_rate_id,0) AS tax_rate_id,
						dls.subject_name,
						t.product_id  AS check_value
					FROM
						definition_list_product AS dlp
						Left Join definition_list_subject AS dls ON dlp.producer_id = dls.subject_id
						Left Join 
						(Select 
							product_id,
							tax_id,
							specification_id,
							tax_rate_id
						FROM accountant_relation_tax 
						WHERE ";
						$query .= " tax_id = ".$data['tax_id'];
						$query .= " AND tax_rate_id = ".$data['tax_rate_id'];
						$query .= " AND specification_id = ".$data['specification_id'];						
						$query .= " ) t ON dlp.product_id = t.product_id 
					WHERE
						dls.is_producer =  1";
						if(isset($data['product_code'])) $query .= " AND dlp.product_code LIKE '%".trim($data['product_code'])."%'";
						if(isset($data['product_name'])) $query .= " AND dlp.product_name LIKE '%".trim($data['product_name'])."%'";
						$query .= " ". $pagingSize;		
		
		return $this->getAdapter()->fetchAll($query);
	}	
}
