<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Db
 * @author      trungpm
 */
class Quick_Db_Table_Row extends Zend_Db_Table_Row_Abstract
{
    /**
     *
     * @var string
     */
    static protected $_db_prefix;
    
    /**
     * Initialize object
     *
     * Called from {@link __construct()} as final step of object instantiation.
     *
     * @return void
     */
    public function init()
    {
        parent::init();
        
        self::$_db_prefix = $this->getTable()->getPrefix();

//        // auto type converting
//        $table = $this->getTable();
//        if (!$table) {
//            return;
//        }
//        $cols = $table->info(Zend_Db_Table_Abstract::METADATA);
//        foreach ($cols as $name => $col) {
//            $dataType = strtolower($col['DATA_TYPE']);
//            if (array_key_exists($dataType, $this->_dataTypes)) {
//                settype($this->_data[$name], $this->_dataTypes[$dataType]);
//            }
//        }
    }

    /**
     * Sets all data in the row from an array.
     *
     * @param  array $data
     * @return Ecart_Db_Table_Row Provides a fluent interface
     */
    public function setFromArray(array $data)
    {
        foreach ($this->getTable()->info('cols') as $fieldName) {
            if (isset($data[$fieldName]))
                $this->$fieldName = $data[$fieldName];
        }
        return $this;
    }

    /**
     * Returns the table object, or null if this is disconnected row
     *
     * @return Zend_Db_Table_Abstract|null
     */
    public function getTable()
    {
        $table = $this->_table;
        if (null === $table && !empty($this->_tableClass)) {
            $tableClass = $this->_tableClass;
            $tableClass = strtolower($tableClass);
            $tableClass = str_replace('ecart_', '', $tableClass);
            $tableClass = str_replace('_model_', '/', $tableClass);
            //$this->setTable(Ecart::single($tableClass));
            $table = Ecart::single($tableClass);
        }
        return $table;
    }
    
    /**
     * Retrun current datebase adapter 
     * 
     * @return Zend_Db_Adapter_Abstract
     */
    public function getAdapter()
    {
        return $this->getTable()->getAdapter();
    }

    /**
     * @return mixed The primary key value(s), as an associative array if the
     *     key is compound, or a scalar if the key is single-column.
     */
    public function save()
    {
        try {
            return parent::save();
        } catch (Exception $e) {
            Ecart::message()->addError($e->getMessage());
            return false;
        }
    }

    /**
     * @return Ecart_Db_Table_Row
     */
    public function cache()
    {
        $args = func_num_args() ? serialize(func_get_args()) : '';
        return Ecart::single('Ecart_Cache_Frontend_Query')->setInstance(
            $this, $args
        );
    }
}