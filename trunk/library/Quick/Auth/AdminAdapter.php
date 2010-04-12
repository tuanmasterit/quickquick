<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Auth
 * @author      trungpm
 */
class Quick_Auth_AdminAdapter implements Zend_Auth_Adapter_Interface
{
    /**
     *
     * @var string
     */
    private $_username;

    /**
     *
     * @var string
     */
    private $_password;

    /**
     *
     * @param string $username
     * @param string $password
     */
    public function __construct($username, $password)
    {
        $this->_username = $username;
        $this->_password = $password;
    }
    
    /**
     *
     * @return Zend_Auth_Result 
     */
    public function authenticate()
    {
        $row = Quick::single('admin/user')->fetchRow(
            Quick::db()->quoteInto("username = ?", $this->_username)
        );
        
        echo "dd";
    }
}