<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Db
 * @author      trungpm
 */
abstract class Quick_Db_Table_Abstract extends Zend_Db_Table_Abstract
{
    /**
     * @var string
     */
    protected $_name = '';

    protected $_rowClass = 'Quick_Db_Table_Row';

    protected $_rowsetClass = 'Quick_Db_Table_Rowset';

    /**
     * @static
     * @var string
     */
    protected static $_db_prefix;

    /**
     * @static
     * @param string $prefix
     * @return void
     */
    public static function setPrefix($prefix = null)
    {
        if (null === $prefix) {
            $prefix = Quick::config()->db->prefix;
        }
        self::$_db_prefix = $prefix;
    }

    /**
     * @static
     * @return string
     */
    public static function getPrefix()
    {
        return self::$_db_prefix;
    }

    /**
     * Initialize table and schema names.
     *
     * If the table name is not set in the class definition,
     * use the class name itself as the table name.
     *
     * A schema name provided with the table name (e.g., "schema.table") overrides
     * any existing value for $this->_schema.
     *
     * @return void
     */
    protected function _setupTableName()
    {
        parent::_setupTableName();
        self::setPrefix(Quick::config()->db->prefix);
        $this->_name = self::$_db_prefix . $this->_name;
    }
    
    /**
     * 
     * @method string hasName
     * @method int getName
     * @method int getNameById
     * @method string cntName
     * @example Quick::single('core/template')->getNameById(1)
     *                   -//-   ->getName(1) used  first primary key
     *                   -//-   ->getIdByName('default')
     *                   -//-   ->hasName('default')
     *                   -//-   ->cntFieldName('try') count by field "field_name" = 'try'     
     */
    public function __call($call, $argv)
    {
//        $columns = array_keys($this->_db->describeTable($this->_name, $this->_schema));
//        $columns = $this->info('cols');
        $fields = explode('By', substr($call, 3));

//        if(false === function_exists('camelize')) {
//            function camelize($str) {
//                $str = str_replace(" ", "", ucwords(str_replace("_", " ", $str)));
//                return (string)(strtolower(substr($str, 0, 1)) . substr($str, 1));
//            }
//        }
        if(false === function_exists('underscore')) {
            function underscore($str = null) {
                return strtolower(
                    preg_replace(array('/(.)([A-Z])/', '/(.)(\d+)/'), "$1_$2", $str)
                );
            }
        }
        
        $ruturnField = underscore($fields[0]);
        
        if (isset($fields[1])) {
            $conditionField = underscore($fields[1]);
        }
        if (!isset($conditionField) 
            || null === $conditionField
            || !$conditionField) {
            
            $conditionField = current($this->info('primary'));
        }
        
        $conditionValue = current($argv);
        if (null === $conditionValue) {
            throw new Quick_Exception('Condition "%" is null', $conditionField);
        }
        switch (substr($call, 0, 3)) {
            case 'get':
                return $this->getAdapter()->fetchOne(
                   "SELECT {$ruturnField} FROM " . $this->_name 
                       . " WHERE {$conditionField} = ? ",
                   $conditionValue
                );
            case 'has':
                $count = $this->getAdapter()->fetchOne(
                   "SELECT COUNT(*) FROM " . $this->_name 
                        . " WHERE {$ruturnField} = ?",
                    $conditionValue
                );
                return $count ? true : false;
            case 'cnt':
                $count = $this->getAdapter()->fetchOne(
                   "SELECT COUNT(*) FROM " . $this->_name 
                        . " WHERE {$ruturnField} = ?",
                    $conditionValue
                );
                return $count;
            default:
                return false;
        }
        
    }

    /**
     *
     * @param  array  $data  Column-value pairs.
     * @return mixed         The primary key of the row inserted.
     */
    public function insert(array $data)
    {
        try {
            return parent::insert($data);
        } catch (Exception $e) {
            Quick::message()->addError($e->getMessage());
            return false;
        }
    }

    /**
     * 
     * @param  array        $data  Column-value pairs.
     * @param  array|string $where An SQL WHERE clause, or an array of SQL WHERE clauses.
     * @return int          The number of rows updated.
     */
    public function update(array $data, $where)
    {
        try {
            return parent::update($data, $where);
        } catch (Exception $e) {
            Quick::message()->addError($e->getMessage());
            return false;
        }
    }

    /**
     *
     * @param  array|string $where SQL WHERE clause(s).
     * @return int          The number of rows deleted.
     */
    public function delete($where)
    {
        try {
            return parent::delete($where);
        } catch (Exception $e) {
            Quick::message()->addError($e->getMessage());
            return false;
        }
    }

    /**
     *
     * @return Quick_Db_Table_Abstract
     */
    public function cache()
    {
        $frontend = Quick::single('Quick_Cache_Frontend_Query');

        if (func_num_args()) {
            $args = serialize(func_get_args());
            return $frontend->setInstance($this, $args);
        }
        return $frontend->setInstance($this);
    }

    /**
     *
     * @param string                            $key
     * @param string|array|Zend_Db_Table_Select $where  OPTIONAL An SQL WHERE clause or Zend_Db_Table_Select object.
     * @param string|array                      $order  OPTIONAL An SQL ORDER clause.
     * @param int                               $count  OPTIONAL An SQL LIMIT count.
     * @param int                               $offset OPTIONAL An SQL LIMIT offset.
     * @parambool $toArray
     * @return array                           array of Zend_Db_Table_Row_Abstract or array
     */
    public function fetchAssoc(
            $key = null,
            $where = null,
            $order = null,
            $count = null,
            $offset = null,
            $toArray = false)
    {
        if (null === $key || $key = '*') {
            $cols = $this->info('primary');
            if (!count($cols)) {
                $cols = $this->info('cols');
            }
            $key = current($cols);
        }
        $rows = array();
        foreach ($this->fetchAll($where, $order, $count, $offset) as $row)
            if ($toArray) {
                $rows[$row->$key] = $row->toArray();
            } else {
                $rows[$row->$key] = $row;
            }
            //@todo see here how ret must row or array
        return $rows;
    }

    /**
     *
     * @param string                            $key
     * @param string|array|Zend_Db_Table_Select $where  OPTIONAL An SQL WHERE clause or Zend_Db_Table_Select object.
     * @param string|array                      $order  OPTIONAL An SQL ORDER clause.
     * @param int                               $count  OPTIONAL An SQL LIMIT count.
     * @param int                               $offset OPTIONAL An SQL LIMIT offset.
     * @return array
     */
    public function fetchPairs(
            $key, $value, $where = null, $order = null, $count = null, $offset = null)
    {
        $rows = array();
        foreach ($this->fetchAll($where, $order, $count, $offset) as $row)
            $rows[$row->$key] = $row->$value;
        return $rows;
    }

    /**
     *
     * @param string $fields
     * @param string|Zend_Db_Select $sql An SQL SELECT statement.
     * @param mixed $bind Data to bind into SELECT placeholders.
     * @return string
     */
    public function fetchOne($fields = '*', $where = null, $bind = array())
    {
        if (is_array($fields)) {
            $fields = implode(', ', $fields);
        }
        $query = "SELECT {$fields} FROM {$this->_name}";
        if (null !== $where) {
            $query = $query . ' WHERE ' . $where;
        }

        return $this->getAdapter()->fetchOne($query, $bind);
    }

    /**
     *
     * @param string|Zend_Db_Select $where
     * @param string $countCondition
     * @return string
     */
    public function count($where = null, $countCondition = 'COUNT(*)')
    {
        if (empty($where)) {
            $select = "SELECT {$countCondition} FROM " . $this->_name;
            return $this->getAdapter()->fetchOne($select);
        }

        if (is_string($where)) {
            $select = "SELECT {$countCondition} FROM " . $this->_name
                    . " WHERE " . $where;
        } elseif (is_array($where)) {

            $select = $this->select()->from(
                $this->_name, new Zend_Db_Expr($countCondition)
            );
            foreach ($where as $condition) {
                if ($condition) {
                    $select->where($condition);
                }
            }

        } elseif ($where instanceof Zend_Db_Select) {
        }

        return $this->getAdapter()->fetchOne($select);
    }

    // @todo remove maybe need use SQL_CALC_FOUND_ROWS
    public function countByFilter($params = array(), Zend_Db_Select $select = null)
    {
        if (null === $select) {
            $select = $this->getAdapter()->select();
            $select->from(array('t' => $this->_name),
                new Zend_Db_Expr('COUNT(*)'));
        }

        $tableShortName = key($select->getPart(Zend_Db_Select::FROM));

        if (isset($params['filter']) && is_array($params['filter'])) {
            foreach ($params['filter'] as $filter) {
                switch ($filter['data']['type']) {
                    case 'numeric': case 'date':
                       $condition = $filter['data']['comparison'] == 'eq' ? '=' :
                            ($filter['data']['comparison'] == 'noteq' ? '<>' :
                            ($filter['data']['comparison'] == 'lt' ? '<' : '>'));
                        $select->where(
                            "{$tableShortName}.{$filter['field']} $condition ?",
                            $filter['data']['value']
                        );
                        break;
                    case 'list':
                        $select->where($this->getAdapter()->quoteInto(
                            "{$tableShortName}.{$filter[field]} IN (?)", 
                            explode(',', $filter['data']['value'])
                        ));
                        break;
                    default:
                        $select->where(
                            "{$tableShortName}.{$filter[field]} LIKE ?",
                            $filter['data']['value'] . "%"
                        );
                        break;
                }
            }
        }
        return $this->getAdapter()->fetchOne($select->__toString());
    }

//    public function getCollection()
//    {
//        return new Quick_Db_Collection($this);
//    }

    /**
     * Return module name
     *
     * @return string
     */
    public function getModule()
    {
        list($category, $module) =  explode('_', get_class($this));
        return $category . '_' . $module;
    }

    /**
     *
     * @return Quick_Translate
     */
    public function translate($module = null)
    {
        if (null === $module) {
            $module = $this->getModule();
        }
        return Quick_Translate::getInstance($module);
    }

    /**
     * Translate
     *
     * @return string
     */
    public function __()
    {
        return Quick_Translate::getInstance(
            $this->getModule()
        )->translate(func_get_args());
    }
}