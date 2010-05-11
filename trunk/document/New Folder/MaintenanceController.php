<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      tuvv
 */
class MaintenanceController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Product Group Action
	 * @author	tuvv
	 */
	public function productGroupAction() {
		if($this->_hasParam('getLoadDetail')){
			$total = 0;
			$result = Quick_Core_Remoter_MaintenanceRemoter::getCriteria(
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}else if($this->_hasParam('editCriteria')){
			$result = Quick_Core_Remoter_MaintenanceRemoter::editCriteria(
			Zend_Json_Decoder::decode($this->_getParam('actionName')),
			Zend_Json_Decoder::decode($this->_getParam('criteriaField')),
			Zend_Json_Decoder::decode($this->_getParam('criteriacId')),
			Zend_Json_Decoder::decode($this->_getParam('criteriaValue')));
			if($result){
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		}else if($this->_hasParam('getModule')){
			$result = Quick_Core_Remoter_MaintenanceRemoter::getModule();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}

		$this->render();
	}

	/**
	 * @desc	Product Catalog Action
	 * @author	trungpm
	 */
	public function productCatalogAction()
	{
		if($this->_hasParam('getListProduct')){
			$total = 0;
			$result = Quick_Core_Remoter_ProductCatalog::getListProduct(
			$this->_getParam('limit'),
			$this->_getParam('start'),
			$this->_getParam('productName'),
			&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('getListSubject')){
			$result = Quick_Core_Remoter_ProductCatalog::getSubjectByType($this->_getParam('getListSubject'));
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('updateFieldProduct')){
			$result = Quick_Core_Remoter_ProductCatalog::updateFieldOfProduct(
			Zend_Json_Decoder::decode($this->_getParam('productId')),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'recordId' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}elseif($this->_hasParam('getProductById')){
			$result = Quick_Core_Remoter_ProductCatalog::getProductById($this->_getParam('getProductById'));
			if(isset($result)){
				return $this->_helper->json->sendSuccess(array(
	            	'data' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}else if($this->_hasParam('getListUnit')){
			$result = Quick_Core_Remoter_ProductCatalog::getListUnit();
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result
			));
		}elseif($this->_hasParam('getUnitDetail')){
			$total = 0;
			$result = Quick_Core_Remoter_ProductCatalog::getUnitOfProduct(
			$this->_getParam('productId'),
			$this->_getParam('limit'),
			$this->_getParam('start'),
			&$total);
			return $this->_helper->json->sendSuccess(array(
	            'data' => $result,
				'count' => $total
			));
		}elseif($this->_hasParam('updateFieldUnitProduct')){
			$result = Quick_Core_Remoter_ProductCatalog::updateFieldUnitOfProduct($this->_getParam('updateFieldUnitProduct'),
			Zend_Json_Decoder::decode($this->_getParam('field')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess(array(
		            'recordId' => $result
				));
			}
			return $this->_helper->json->sendFailure();
		}
		$this->render();
	}
}
?>
