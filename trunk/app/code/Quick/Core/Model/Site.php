<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Site extends Quick_Db_Table 
{
    protected $_name = 'core_site';
    
	/**
     *
     * @param string $url
     * @return mixed
     */
    public function getIdByUrl($url)
    {
        $sites = $this->fetchAll()->toArray();

        $scheme = 'https://';
        $base = 'secure';
        if (substr($url, 0, strlen($scheme)) != $scheme) {
            $base = 'base';
            $scheme = 'http://';
        }

        foreach ($sites as $site) {
            $www = $site[$base];
            if (substr($url, 0, strlen($www)) === $www) {
               return $site['id'];
            }

            if (substr($www, 0, strlen($scheme . 'www.')) === $scheme . 'www.') {
                $www = str_replace($scheme . 'www.', $scheme , $www);
            }

            if (substr($url, 0, strlen($scheme . 'www.')) === $scheme . 'www.') {
                $url = str_replace($scheme . 'www.', $scheme, $url);
            }

            if (substr($url, 0, strlen($www)) === $www) {
               return $site['id'];
            }
        }
        return false;
    }
    
	/**
     *
     * @param string $url
     * @return string
     */
    public function getBaseUrlByUrl($url)
    {
        $sites = $this->fetchAll()->toArray();

        $scheme = 'https://';
        $base = 'secure';
        if (substr($url, 0, strlen($scheme)) != $scheme) {
            $base = 'base';
            $scheme = 'http://';
        }

        foreach ($sites as $site) {
            $www = $site[$base];
            if (substr($url, 0, strlen($www)) === $www) {
               return $site[$base];
            }

            if (substr($www, 0, strlen($scheme . 'www.')) === $scheme . 'www.') {
                $www = str_replace($scheme . 'www.', $scheme , $www);

            }

            if (substr($url, 0, strlen($scheme . 'www.')) === $scheme . 'www.') {
                $url = str_replace($scheme . 'www.', $scheme, $url);
            }

            if (substr($url, 0, strlen($www)) === $www) {
               return $site[$base];
            }
        }

        return false;
    }
}