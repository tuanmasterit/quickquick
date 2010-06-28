<?php
/**
 *
 * @category    Quick
 * @package     Quick_Accountant
 * @subpackage  Controller
 * @author      trungpm
 */
class Quick_Accountant_ReceivableController extends Quick_Core_Controller_Back
{
	public function init()
	{
		parent::init();
	}

	/**
	 * @desc	Receivable Manage Action
	 * @author	trungpm
	 */
	public function receivableManageAction()
	{
		$this->view->decimalSeparator = Quick_Number::getDecimalSeparator();
		$this->view->thousandSeparator = Quick_Number::getThousandSeparator();
		$currentPeriod = Quick::single('core/definition_period')->cache()->getPeriodCurrent();
		$this->view->convertedCurrencyId = 0;
		if(!empty($currentPeriod)){
			$this->view->convertedCurrencyId =  $currentPeriod['currency_id'];
			$this->view->currentPeriodId =  $currentPeriod['period_id'];
		}

		// action in here

		$this->render();
	}
}
