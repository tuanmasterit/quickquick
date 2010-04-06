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
 * @package     Ecart_Catalog
 * @copyright   Copyright 2008-2009 E-Cart LLC
 * @license     GNU Public License V3.0
 */

/**
 * 
 * @category    Ecart
 * @package     Ecart_Catalog
 * @subpackage  Helper
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Ecart_View_Helper_Modifier
{
    protected function _getSubPrice($amount, $change, $price_type = null)
    {
        $priceStr = '';
        if ($change != 0 && isset($amount)) {
            $priceStr = Ecart_Catalog_Model_Product_Row::getNewPrice(
               $amount,
               $change, 
               $price_type
            );
            $pricePrefix = $amount > $priceStr ? '-' : '+';
            $priceStr = abs($priceStr - $amount);
            $priceStr = ' ' . $pricePrefix . ' '
                      . Ecart::single('locale/currency')->toCurrency($priceStr);
        }
        return $priceStr;
    }
    
    protected function _haveSubPrice($values)
    {
        $ret = '';
        foreach ($values as $value) {
            if ($value['price'] != 0) {
                $ret = 'class="sub-price"';
                break;
            }
        }
        return $ret;
    }
    
    public function modifier($modifier)
    {   
        $html = '';
        
        if (is_array($modifier['price'])) {
            if (isset($modifier['price']['price'])) {
                $modifier['price'] = $modifier['price']['price'];
            } else {
                unset($modifier['price']);
            }
        }
        /*
         * 0 - select
         * 1 - text
         * 2 - radio
         * 3 - checkbox
         * 4 - textarea 
         */
	    switch ($modifier['type']) {
	        case 0:
	            $html .= '<input type="hidden" id="modifier-' . $modifier['id'] 
                      . '-id" value="' . $modifier['attribute_id'] . '"/>';
	            $html .= '<select id="modifier-' . $modifier['id'] 
	                  . '" name="modifier[id][' . $modifier['id'] 
	                  . ']" ' . $this->_haveSubPrice($modifier['values']) . ' >';
	            foreach ($modifier['values'] as $value) {
	                $addPrice = $this->_getSubPrice(
	                    $modifier['price'], $value['price'], $value['price_type']
	                );
	                $html .= '<option value="' . $value['id'] . '" id="modifier-' . $modifier['id'] . '-' . $value['attribute_id']
	                      . '">' . $value['name'] 
	                      . $addPrice . '</option>';
	            }
	            $html .= '</select>';
	            break;
	        case 1:
	            $value = current($modifier['values']);
                $addPrice = $this->_getSubPrice(
                    $modifier['price'], $value['price'], $value['price_type']
                );
	            $html .= '<input type="hidden" id="modifier-' . $modifier['id'] 
                      . '-id" value="' . $modifier['attribute_id'] . '"/>';
                $html .= '<input id="modifier-' . $modifier['id'] 
                      . '" type="text" name="modifier[value]['
                      . $modifier['id'] . ']" value=""  ' 
                      . $this->_haveSubPrice($modifier['values']) . ' />'
                      . '<label for="modifier-' . $modifier['id'] 
                      . '" id="modifier-' . $modifier['id'] . '-text" >' 
                      . $addPrice . '</label>';
	            break;
	        case 2:
	            $checked = 'checked="true"';
	            $html .= '<ul id="modifier-' . $modifier['id'] . '">';
	            foreach ($modifier['values'] as $value) {
	                $addPrice = $this->_getSubPrice(
                        $modifier['price'], $value['price'], $value['price_type']
                    );
	                $html .= '<li><input id="modifier-' . $modifier['id'] . '-' . $value['attribute_id']
	                      . '" type="radio" name="modifier[id][' . $modifier['id'] . ']" value="'
	                      . $value['id'] . '" ' . $this->_haveSubPrice($modifier['values']) 
	                      . $checked . ' />' 
	                      . '<label for="modifier-' . $modifier['id'] . '-' . $value['attribute_id']
                          . '" id="modifier-' . $modifier['id'] . '-' 
	                      . $value['attribute_id'] . '-text" >' . $value['name'] 
	                      . $addPrice . '</label></li>';
	                if ($checked) {
	                    $checked = '';
	                }
	            }
	            $html .= '</ul>';
	            break;
	        case 3:
            	$html .= '<ul id="modifier-' . $modifier['id'] . '">';
                foreach ($modifier['values'] as $value) {
                    $addPrice = $this->_getSubPrice(
                        $modifier['price'], $value['price'], $value['price_type']
                    );
                    $html .= '<li><input id="modifier-' . $modifier['id'] . '-' . $value['attribute_id']
                          . '" type="checkbox" name="modifier[id][' . $modifier['id'] . ']['
                          . $value['id'] . ']" value="' . $value['id'] . '" '
                          . $this->_haveSubPrice($modifier['values']) . ' /> '
                          . '<label for="modifier-' . $modifier['id'] . '-' . $value['attribute_id']
                          . '" id="modifier-' . $modifier['id'] . '-' 
                          . $value['attribute_id'] . '-text" >' . $value['name']
                          . $addPrice . '</label></li>';
                }
                $html .= '</ul>';
	            break;
	         case 4:
	            $value = current($modifier['values']);
	            $addPrice = $this->_getSubPrice(
                    $modifier['price'], $value['price'], $value['price_type']
                );
                $html .= '<input type="hidden" id="modifier-' . $modifier['id'] 
                      . '-id" value="' . $modifier['attribute_id'] . '"/>';
                $html .= '<textarea id="modifier-' . $modifier['id'] 
                      . '" rows="4" cols="30" name="modifier[value][' 
                      . $modifier['id'] . ']" ' . $this->_haveSubPrice($modifier['values']) 
                      . ' >' . '</textarea>
                      <label for="modifier-' . $modifier['id'] 
                      . '" id="modifier-' . $modifier['id'] . '-text" >' 
                      . $addPrice . '</label>';
                break;
	    }
	    
	    return $html;
    }
}