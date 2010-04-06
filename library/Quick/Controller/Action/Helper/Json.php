<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Helper
 * @author      trungpm
 */
class Quick_Controller_Action_Helper_Json extends Zend_Controller_Action_Helper_Json
{
    /**
     * Encode JSON response and immediately send
     *
     * @param  mixed   $data
     * @param  boolean|array $keepLayouts
     * NOTE:   if boolean, establish $keepLayouts to true|false
     *         if array, admit params for Zend_Json::encode as enableJsonExprFinder=>true|false
     *         if $keepLayouts and parmas for Zend_Json::encode are required
     *         then, the array can contains a 'keepLayout'=>true|false
     *         that will not be passed to Zend_Json::encode method but will be passed
     *         to Zend_View_Helper_Json
     * @return string|void
     */
    public function sendJson($data, $keepLayouts = false, $wrap = true)
    {
        if (isset($data['success']) && !is_bool($data['success'])) {
            $data['success'] = (bool) $data['success'];
        }

        if ($wrap) {

            $messages = Quick::message()->getAll();
//            if (isset(false === $data['success']) && $data['success']) {
//                unset($messages['success']);
//            }

            $data = array_merge(array('messages' => $messages), $data);
        }

        $data = $this->encodeJson($data, $keepLayouts);
        $response = $this->getResponse();
        $response->setBody($data);

        if (!$this->suppressExit) {
            Zend_Wildfire_Channel_HttpHeaders::getInstance()->flush(); //Quick_FirePhp
            $response->sendResponse();
            exit;
        }

        return $data;
    }

    /**
     * Encode JSON response and immediately send
     * with success => true
     * @param  mixed   $data
     * @param  boolean|array $keepLayouts
     * @return string|void
     */
    public function sendSuccess($data = array(), $keepLayouts = false)
    {
        $data = array_merge($data, array('success' => true));
        return $this->sendJson($data, $keepLayouts, true);
    }

    /**
     * Encode JSON response and immediately send
     * success => false
     * @param  mixed   $data
     * @param  boolean|array $keepLayouts
     * @return string|void
     */
    public function sendFailure($data = array(), $keepLayouts = false)
    {
        $data = array_merge($data, array('success' => false));
        return $this->sendJson($data, $keepLayouts, true);
    }

}
