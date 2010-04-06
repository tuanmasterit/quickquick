<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Db
 * @author      trungpm
 */
class Quick_Db_Table_Rowset extends Zend_Db_Table_Rowset
{
    /**
     * Returns the table object, or null if this is disconnected rowset
     *
     * @return Ecart_Db_Table_Abstract
     */
    public function getTable()
    {
        $table = $this->_table;
        if (null === $table && !empty($this->_tableClass)) {
            $tableClass = $this->_tableClass;
            $tableClass = strtolower($tableClass);
            $tableClass = str_replace('quick_', '', $tableClass);
            $tableClass = str_replace('_model_', '/', $tableClass);
            //$this->setTable(Ecart::single($tableClass));
            $table = Ecart::single($tableClass);
        }
        return $table;
    }
}