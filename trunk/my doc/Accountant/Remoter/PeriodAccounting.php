<?php
	/**
	 *
	 * @category    Quick
	 * @package     Quick_Accountant
	 * @author      bichttn
	 */
	class Quick_Accountant_Remoter_PeriodAccounting {
		/**
		 * getListPeriod
		 * @author	bichttn
		 * @return array Functions|mixed
		 */
		public static function getListPeriod($limit, $start, &$total)
		{
			
			return Quick::single('core/definition_period')->cache()->getListPeriod($limit, $start, &$total);
		}
		
		/**
		 * getListPeriod
		 * @author	bichttn
		 * @return array Functions|mixed
		 */
		public static function getListPeriodCombo()
		{
			
			return Quick::single('core/definition_period')->cache()->getListPeriodCombo();
		}
		/**
		 * getListSubject
		 * @author	bichttn
		 * @return array Functions|mixed
		 */
		public static function getListSubject()
		{
			
			return Quick::single('core/definition_subject')->cache()->getListSubject();
		}
		
		/**
		 * @desc insert a record of period
		 * 
		 * @author	bichttn
		 * @return array
		 */
		public static function insertPeriod($subjectId, $length, $month, $year, $current)
		{
			$period = array(
				'subject_id'=> $subjectId,
				'length' => $length,
				'month' => $month,
				'year' => $year,
				'lock' => 0,
				'current' => $current,
				'inactive' => 0,
				'created_by_userid' => Quick::session()->userId,
				'date_entered' => Quick_Date::now()->toSQLString(),
				'last_modified_by_userid' => Quick::session()->userId,
				'date_last_modified' => Quick_Date::now()->toSQLString()
			);
			if ($current == 1) {
				$update = Quick::single('core/definition_period')->cache()->updatePeriodByCurrent();
				
			}
			$newId = Quick::single('core/definition_period')->cache()->insertPeriod($period);
			if ($newId) {
				
				return $newId;
			} else {
				
				return null;
			}
		}
		
		/**
		 * update a record of period by period_id
		 * @author	bichttn
		 * @return array
		 */
		static function updatePeriodById($periodId, $lengh, $current)
		{
			if ($current == 1) {
				$update = Quick::single('core/definition_period')->cache()->updatePeriodByCurrent();	
			}
			return Quick::single('core/definition_period')->cache()->updatePeriodById($periodId, $lengh, $current);
		}
		
		/**
		 * delete
		 * @author	bichttn
		 * @return array
		 */
		static function deletePeriod($periodId)
		{
			
			return Quick::single('core/definition_period')->cache()->deletePeriod($periodId);
		}
		
	}
?>