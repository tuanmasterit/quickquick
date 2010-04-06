<?php
/**
 * Ecart
 * 
 * This file is part of Ecart.
 * 
 * Ecart is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * Ecart is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with Ecart.  If not, see <http://www.gnu.org/licenses/>.
 * 
 * @category    Ecart
 * @package     Ecart_GoogleAnalytics
 * @copyright   Copyright 2008-2009 E-Cart LLC
 * @license     GNU Public License V3.0
 */

/**
 * 
 * @category    Ecart
 * @package     Ecart_GoogleAnalytics
 * @subpackage  Helper
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Ecart_View_Helper_GoogleAnalytics
{
    private $_config;
    
    public function __construct()
    {
        $this->_config = Ecart::config()->analytics;
    }
    
    private function _getTracking() {
        if (!empty($this->_config->tracking->linksPrefix))
            $outgoing = $this->_config->tracking->linksPrefix;
        else
            $outgoing = '/outgoing/'; 
        $html = '<script type="text/javascript">' 
              . 'function isLinkExternal(link) {
                      var r = new RegExp( \'^https?://(?:www.)?\' + location.host.replace(/^www./, \'\') );
                      return !r.test(link);
                }'
              . '$(document).ready(function () {'
              . '$(document).bind(\'click\', function(e) {
                    var target = (window.event) ? e.srcElement : e.target;
                    while (target) {
                      if (target.href) break;
                      target = target.parentNode;
                    }
                    if (!target || !isLinkExternal(target.href))
                      return true;
                    var link = target.href;
                    link = \'' . $outgoing . '\' 
                      + link.replace(/:\/\//, \'/\')
                      .replace(\'/^mailto:/\', \'mailto/\');
                    pageTracker._trackPageview(link);
                  });
                });'
              . '</script>';
        return $html;
    }
    
    private function _getConvesion($orderTotal) {
        if ($orderTotal > 0) {
            $gcv = number_format($orderTotal, 3, '.', '');
        } else {
            $gcv = 1;
        }
        $html = '<script type="text/javascript">'
              . ' var google_conversion_id = ' . $this->_config->conversion->id .';'
              . ' var google_conversion_language = "' . $this->_config->conversion->language .'";'
              . ' var google_conversion_format = "1";' 
              . ' var google_conversion_color = "FFFFFF";'
              . ' if (' . $gcv .') {'
              . '   var google_conversion_value = '. $gcv .';
                 }'
              . ' var google_conversion_label = "Purchase";'
               . '</script>';
        $proto = "http" . ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == "on") ? "s" : "") . "://";
        $html .= '<script type="text/javascript" src="'
              . $proto
              . 'www.googleadservices.com/pagead/conversion.js"></script>'
              . '<noscript><img height="1" width="1" border="0" alt="convertetion" src="'
              . $proto
              . 'www.googleadservices.com/pagead/conversion/'
              . $this->_config->conversion->id
              . '/?value='
              . $gcv
              . '&amp;label=Purchase&amp;script=0"/>
              </noscript>';
        return  $html;
    }
    
    private function _getCheckout()
    {
        if (!isset($this->_config->main->checkoutSuccess)) {
            return '';
        }
        if (Ecart::getCustomerId()) {
            return '';
        }
        $orderId =  Ecart::single('checkout/checkout')->getOrderId();
        $order = Ecart::single('sales/order')->find($orderId)->current();
        //$order = Ecart::single('sales/order')->fetchRow("customer_id = {Ecart::getCustomerId()} ", "id DESC" );
        
        if (!$order instanceof Ecart_Sales_Model_Order_Row) {
            return '';
        }
        
        if(!isset($_SESSION['google_analytics'])) 
            $_SESSION['google_analytics'] = array();
        
        if (in_array($order->id, $_SESSION['google_analytics'])) {
            return '';
        }
        if (null === $order->id)
            return '';
        $_SESSION['google_analytics'][] = $order->id;
          
        //pageTracker._addTrans(Order_ID, Affiliation, Total, Tax, Shipping, City, State, Country);
        $_addTrans = ' pageTracker._addTrans(' .
                '"' . $order->id . '",' .
                '"' . $this->_config->general->affiliation . '",' .
                '"' . number_format($order->order_total, 3, '.', '') . '",' .
                '"' . number_format($order->getTax() + $order->getShippingTax(), 3, '.', '') . '",' .
                '"' . number_format($order->getShipping(), 3, '.', '') . '",' .
                '"' . $order->billing_city . '",' .
                '"' . $order->billing_state . '",' .
                '"' . $order->billing_country . '");';
        $_addItems = '';
        $tableProduct = Ecart::single('catalog/product');
        // begin for addItems
        foreach ($order->getProducts() as $item) {
           /*
            *  get Attributes Product 
            */
            $attributes = '';
            if (isset($item['attrs'])) {
                foreach ($item['attrs'] as $attribute) {
                    $attributes .= ' ' 
                                . $attribute['product_option'] 
                                . ': ' 
                                . $attribute['product_option_value']
                                . $this->_config->atributes->delemiter;
                }
                $attributes = substr($this->_config->atributes->brackets, 0, 1) 
                            . rtrim($attributes, $this->_config->atributes->delemiter) 
                            . substr($this->_config->atributes->brackets, 1, 1);
            }
                          
            $productCategories = $tableProduct->getProductCategories($item['product_id'], Ecart::getLanguageId());
            $categoryName = '';
            foreach ($productCategories as $category) {
                if (!empty($categoryName))
                    $categoryName .= ', '; //delimiter category
                $categoryName .= $category['category_name'];
            }
           /*
            *  get SKU 
            */
            //$sku =  $tableProduct->getSku($item['product_id']);
                  
            //pageTracker._addItem(Order_ID, SKU, Product_Name, Category, Price, Quantity);
            $_addItems .= '  pageTracker._addItem(' .
                '"' . $order->id. '",' .
                '"' . $item['product_sku'] . '",' . 
                '"' . $item['product_name']. ' ' . $attributes . '",' .
                '"' . $categoryName . '",' .
                '"' . number_format($item['final_price'], 2, '.', '') . '",' .
                '"' . $item['product_quantity'] . '");';
        } //end addItems foreach 
        $_addItems .= 'pageTracker._trackTrans();';//edn transaction
        $_addConver = '';
        if ($this->_config->conversion->used)
            $_addConver = $this->_getConvesion(number_format($order->order_total, 3, '.', ''));
        return '<script type=\'text/javascript\'>' 
            . $_addTrans 
            . $_addItems 
            . '</script>' 
            . $_addConver;
    }
    
    public function googleAnalytics()
    {
        return $this;
    }
    
    public function __toString()
    {
        if (!$this->_config->main->used)
            return '';
        $proto = "http" . ((isset($_SERVER['HTTPS']) && $_SERVER['HTTPS'] == "on") ? "s" : "") . "://";
        $uacct = $this->_config->main->uacct;
        
        $html = '<script src=\'' 
              . $proto 
              . 'www.google-analytics.com/ga.js\' type=\'text/javascript\'>'
              . '</script><script type=\'text/javascript\'>'  
              . 'var pageTracker = _gat._getTracker("' . $uacct . '");' 
              . 'pageTracker._initData();';
        if($this->_config->main->usedPageName) {
            $page = '"' . $_SERVER['REQUEST_URI'] . '"';
        } else {
            $page = '';
        }
        $html .= 'pageTracker._trackPageview(' . $page . ');';
        $html .= '</script>' . $this->_getCheckout();
        
        if ($this->_config->tracking->used)
            $html .= $this->_getTracking(); 
        return $html;
    }
}