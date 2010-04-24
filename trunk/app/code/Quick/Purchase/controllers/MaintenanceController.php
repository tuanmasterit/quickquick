<?php
/**
 *
 * @category    Quick
 * @package     Quick_Purchase
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Purchase_MaintenanceController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	public function productGroupAction()
	{
		$this->view->pageTitle = 'product-group';

		$this->render();
	}

	public function productCatalogAction()
	{
		$this->view->pageTitle = 'product-catalog';

		$this->render();
	}
}