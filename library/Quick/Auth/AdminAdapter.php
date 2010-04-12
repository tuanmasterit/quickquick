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
        $row = Quick::single('general/user')->fetchRow(
            Quick::db()->quoteInto("username = ?", $this->_username)
        );
        
    	if (!$row) {
            $code = Zend_Auth_Result::FAILURE_IDENTITY_NOT_FOUND;
            Quick::message()->addError('Such user does not exists');
            return new Zend_Auth_Result($code, null);
        }
        
    	if ($row->password != md5($this->_password)) {
            $code = Zend_Auth_Result::FAILURE_CREDENTIAL_INVALID;
            Quick::message()->addError('Wrong password');
            return new Zend_Auth_Result($code, null);
        }
        
        $code = Zend_Auth_Result::SUCCESS;
        // luu tru khi dang nhap thanh cong, thoi gian dang nhap
        //$row->lastlogin = Ecart_Date::now()->toZendDbExpr();
        //$row->save();
        
        return new Zend_Auth_Result($code, $row->id);
    }
}