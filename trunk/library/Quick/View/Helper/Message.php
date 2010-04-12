<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Message
 * @subpackage  Helper
 * @author      trungpm
 */
class Quick_View_Helper_Message
{
    private $_messages = array();
    
    public function __construct()
    {
        $this->_messages = Quick_Message::getInstance()->get();
    }
    
    public function message()
    {
        return $this;
    }
    
    public function __toString()
    {
        $result = "";
        
        if (count($this->_messages)) {
            $result .= "<div id='messages'>";
            foreach ($this->_messages as $type => $messageArray) {
                $result .= "<ul class='{$type}-msg' title='{$type}'>";
                foreach ($messageArray as $message) {
                    $result .= "<li>{$message}</li>";
                }
                $result .= "</ul>";
            }
            $result .= "</div>";
        }
        
        return $result;
    }
}