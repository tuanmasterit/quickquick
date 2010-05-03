<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_MaintenanceController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}


	public function accountSystemAction(){

		if ($this->_hasParam('getLoadTreeData')){

			$accounts = Quick_Accountant_Remoter_MaintenanceRemoter::getAccountOfNode(
			Zend_Json_Decoder::decode($this->_getParam('node')));

			for($i = 0; $i < count($accounts); $i++) {
				$iconStr = $this->view->skinUrl('/images/icons/Paper2.ico');
				if(isset($accounts[$i]['parent_id'])){
					$iconStr = $this->view->skinUrl('/images/icons/Paper.ico');
				}
				$accounts[$i]['icon'] = $iconStr;
			}
			return $this->_helper->json->sendJson($accounts, false, false);
		}elseif($this->_hasParam('getDetailOfNode')){

			$detail = Quick_Accountant_Remoter_MaintenanceRemoter::getDetailOfNode(
			Zend_Json_Decoder::decode($this->_getParam('nodeId')));
			return $this->_helper->json->sendSuccess(array(
            'data' => $detail
			));
		}elseif($this->_hasParam('getDetailFor')){

			$tables = Quick_Accountant_Remoter_MaintenanceRemoter::getListTables();

			return $this->_helper->json->sendSuccess(array(
            'data' => $tables
			));
		}elseif($this->_hasParam('getLoadDetail')){
			$total = 0;
			$detail = Quick_Accountant_Remoter_MaintenanceRemoter::getDetailAccountByTable(
			Zend_Json_Decoder::decode($this->_getParam('selectedDetailFor')),
			Zend_Json_Decoder::decode($this->_getParam('selectedNode')),
			Zend_Json_Decoder::decode($this->_getParam('limit')),
			Zend_Json_Decoder::decode($this->_getParam('start')),
			&$total);
			return $this->_helper->json->sendSuccess(array(
            'data' => $detail,
			'count' => $total
			));
		}elseif($this->_hasParam('updateDetailFor')){

			$result = Quick_Accountant_Remoter_MaintenanceRemoter::updateDetailAccount(
			Zend_Json_Decoder::decode($this->_getParam('accountId')),
			Zend_Json_Decoder::decode($this->_getParam('tableId')),
			Zend_Json_Decoder::decode($this->_getParam('detailId')),
			Zend_Json_Decoder::decode($this->_getParam('value')));
			if($result){
				return $this->_helper->json->sendSuccess();
			}
			return $this->_helper->json->sendFailure();
		}

		$this->render();
	}
}