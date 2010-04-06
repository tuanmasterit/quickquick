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
class Ecart_View_Helper_Pagination
{
    const NUM_TO_DISPLAY = 3;
    
    private $_output = '';
    
    public function setView($view)
    {
        $this->view = $view;
    }
    
    public function __toString()
    {
        return $this->_output;
    }
    
    public function pagination($pagination, $url = 'url')
    {
        if ($pagination['pages'] <= 1) {
            $this->_output = '';
            return $this;
        }
        
        if (!empty($this->_output)) {
            return $this->_output;
        }
        
        $this->_output = '<ol class="pagination"><li>';
        if ($pagination['page'] == 1) {
            $this->_output .= '<span class="previous">&#8592;</span>';
        } else {
            $this->_output .= '<a href="' 
            . $this->view->{$url}(array('page' => $pagination['page'] - 1))
            . '" class="previous">&#8592;</a>';
        }
        $this->_output .= '</li>';
        
        $display = $this->_getNumToDisplay();
        
        $extra = array();
        $extra['begin'] = $display -
            ($pagination['pages'] - $pagination['page']);
        if ($extra['begin'] < 0) {
            $extra['begin'] = 0;
        }
        $extra['end'] = $display + 1 - $pagination['page'];
        if ($extra['end'] < 0) {
            $extra['end'] = 0;
        }
        $beginCondition = $pagination['page'] - $display - $extra['begin'] > 2;
        $endCondition = array();
        $endCondition[0] = $pagination['page'] + $display + $extra['end'] + 1;
        $endCondition[1] = $endCondition[0] < $pagination['pages'];
        
        for ($i = 1; $i <= $pagination['pages']; $i++) {
            // jump to page
            if ($i == 2 && $beginCondition) {
                $this->_output .= '<li>...</li>';
                $i = $pagination['page'] - $display - $extra['begin'] - 1;
                continue;
            } elseif ($i == $endCondition[0] && $endCondition[1]) {
                $this->_output .= '<li>...</li>';
                $i = $pagination['pages'];
            }
            
            $this->_output .= '<li>';
            if ($pagination['page'] == $i) {
                $this->_output .= '<span class="current">'. $i . '</span>';
            } else {
                $this->_output .= '<a href="' 
                    . $this->view->{$url}(array('page' => $i))
                    . '">' . $i . '</a>';
            }
            $this->_output .= '</li>';
        }
        
        $this->_output .= '<li>';
        if ($pagination['page'] == $pagination['pages']) {
            $this->_output .= '<span class="next">&#8594;</span>';
        } else {
            $this->_output .= '<a href="' 
            . $this->view->{$url}(array('page' => $pagination['page'] + 1))
            . '" class="next">&#8594;</a>';
        }
        $this->_output .= '</li></ol>';
        
        return $this;
    }
    
    private function _getNumToDisplay()
    {
        return self::NUM_TO_DISPLAY;
    }
    
}