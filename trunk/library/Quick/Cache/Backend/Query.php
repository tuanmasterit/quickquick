<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Cache
 * @subpackage  Backend
 * @author      trungpm
 */
class Quick_Cache_Backend_Query extends Quick_Cache_Backend_Abstract
{
    /**
     * @var string
     */
    private $_customId = null;

    /**
     * @var array
     */
    protected $_nonCachedMethods = array(
        'insert', 'update', 'delete', 'save'//, 'set*', 'add*', 'remove*'
    );

    /**
     * @param Object $instance model class __instance__
     * @param string $customId
     * @return Quick_Cache_Backend_Abstract Fluent interface
     */
    public function setInstance($instance, $customId = null)
    {
        $this->_instance = $instance;
        $this->_customId = $customId;
        return $this;
    }

    /**
     *
     * @return Quick_Db_Table_Abstract
     */
    protected function _getModel()
    {
        return $this->_instance;
    }

    /**
     *
     * @param string $methodName
     * @param array $arguments
     * @return mixed
     */
    public function __call($methodName, $arguments)
    {
        $cacheBool1 = $this->_cacheByDefault;
        $cacheBool2 = in_array($methodName, $this->_cachableMethods);
        $cacheBool3 = in_array($methodName, $this->_nonCachedMethods);
        $cache = (($cacheBool1 || $cacheBool2) && (!$cacheBool3));
        if (!$cache) {
            // We do not have not cache
            return call_user_func_array(
                array($this->_getModel(), $methodName), $arguments
            );
        }

        /** Get cache instance */
        $cache = Quick::cache();

        $id = $this->_makeId($methodName, $arguments);
        //Quick_FirePhp::log($id);
        if ($cache->test($id)) {
            // A cache is available
            $result = $cache->load($id);
            $output = $result[0];
            $return = $result[1];
        } else {
            // A cache is not available
            ob_start();
            ob_implicit_flush(false);
            $return = call_user_func_array(
                array($this->_getModel(), $methodName), $arguments
            );
            $output = ob_get_contents();
            ob_end_clean();
            $data = array($output, $return);
            $cache->save(
                $data, $id,
                array_merge($this->_tags, array('query')),
                $this->_specificLifetime,
                $this->_priority
            );
        }
        echo $output;
        return $return;
    }

    /**
     * Make a cache id from the method name and parameters
     *
     * @param  string $methodName       Method name
     * @param  array  $parameters Method parameters
     * @return string Cache id
     */
    protected function _makeId($methodName, $parameters)
    {
        asort($parameters);
        return md5(
            get_class($this->_getModel())
            . $methodName
            . serialize($parameters)
            . Quick::getSiteId()
            //. Quick::getLanguageId()
            . $this->_customId 
            //. Quick::getCustomerId()
        );
    }
}