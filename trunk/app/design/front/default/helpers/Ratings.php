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
 * @package     Ecart_Community
 * @copyright   Copyright 2008-2009 E-Cart LLC
 * @license     GNU Public License V3.0
 */

/**
 * 
 * @category    Ecart
 * @package     Ecart_Community
 * @subpackage  Helper
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Ecart_View_Helper_Ratings
{
    private $_config;
    
    public function __construct()
    {
        $this->_config = Ecart::config()->community->review->toArray();
    }
    
    public function setView($view)
    {
        $this->view = $view;
    }
    
    /**
     * Build rating stars, according to recieved ratings array
     * 
     * @param array $ratings
     *  array(
     *      array(
     *          'mark' => int, 
     *          'title' => string, 
     *          'product_id' => int[optional]
     *      ),...
     *  )
     * @param string $url [optional]
     * @param boolean $smallStars [optional]
     * @return string
     */
    public function ratings($ratings, $url = '', $smallStars = true)
    {
        if (isset($this->_config['rating_enabled']) 
            && !$this->_config['rating_enabled']) {
            
            return '';
        }
        if (!is_array($ratings)) {
            $ratings = array();
        }
        $url = empty($url) ? '#' : $url;
        $hasRating = false;
        $html = '';
        foreach ($ratings as $rating) {
            if (!count($rating)) {
                continue;
            }
            $hasRating = true;
            $html .= '<li>';
            $html .= $this->_getRatingTitle($rating['title']);
            $html .= '<a href="' . $url 
                  . '" class="review-stars review-rate' . ($smallStars ? '-sm' : '')
                  . ' "title="' . $rating['title'] . ': ' . $rating['mark'] . ' '
                  . Ecart::translate('community')->__('stars')
                  . '">
                      <span style="width: ' . $rating['mark']*100/5 . '%">'
                  . Ecart::translate('community')->__("%s stars", $rating['mark'])
                  . '</span>
            </a>';
            $html .= '</li>';
        }
        if ($hasRating) {
            $html = '<ul class="review-ratings">' . $html . '</ul>';
        }
        return $html;
    }
    
    private function _getRatingTitle($title)
    {
        if (!empty($title)
            && isset($this->_config['rating_title'])
            && $this->_config['rating_title']) {
            
            return '<label class="rating-title">' . $title . '</label>';
        }
        return '';
    }
}