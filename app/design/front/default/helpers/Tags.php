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
 * @package     Ecart_Tag
 * @copyright   Copyright 2008-2009 E-Cart LLC
 * @license     GNU Public License V3.0
 */

/**
 * 
 * @category    Ecart
 * @package     Ecart_Tag
 * @subpackage  Helper
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Ecart_View_Helper_Tags
{
    protected  $_tags = array();
    private    $_statusAction = true;
    private    $_disableWeight = false;
    private    $_usageTagAsId = true;  
    
    
    public function __toString()
    {
        $content = '';
        if (!count($this->_tags)) {
            return '<p class="empty-query">' 
                . Ecart::translate('tag')->__('No tags found') . '</p>';
        }
        $content .= '<ul class="tagcloud">';
        foreach ($this->_tags as $tag) {
            if (is_array($tag)) {
                $content .= '<li><span title="' . $tag['name'] . '"  class="'
                    . $tag['class']  . ' nowrap">';
                $content .= '<a  style="font-size:'
                         . $this->view->escape($tag['font-size']) . '%" href="'
                         . $this->view->href('tag/index/show-products/');
                if ($this->_usageTagAsId) {
                    $content .= 'tag/' . $this->view->escape($tag['name']);
                } else {
                    $content .= 'tagId/' . $this->view->escape($tag['id']); 
                }    
                $content .= '">'. $this->view->escape($tag['name']);
                if ($this->_disableWeight) {       
                    $content .= '(' . $this->view->escape($tag['weight']) .')';
                }
                $content .= '</a>';
                if ($this->_statusAction) {
                    $content .= '<a class="remove-tag" href="' 
                        . $this->view->href('/account/tag/remove/tagId/'
                        . $tag['id'], true)
                        . '" title="' . Ecart::translate('tag')->__('Remove item') . '">'
                        . $this->view->image('bullet-delete.gif', 'alt="'
                        . Ecart::translate('tag')->__('Remove item').'"') . '</a>';
                }
                $content .= '</span></li>'; 
            }
        }
        $content .= '</ul>';
        
        return $content;
    }
    
    public function setView($view)
    {
        $this->view = $view;
    }
    
    public function tags($tags = array())
    {
        if (count($tags)) {
            $currentTag = current($tags);    
            $min_weight = $currentTag['weight'];
            $max_weight = $currentTag['weight'];
            foreach ($tags as $tag ) {
              if ($min_weight > $tag['weight'])
                 $min_weight = $tag['weight'];
              if ($max_weight < $tag['weight'])
                 $max_weight = $tag['weight'];
            }
            
            $max_size = 200; // max font size in pixels
            $min_size = 80; // min font size in pixels
            // find the range of values
            $spread = $max_weight - $min_weight;
            if ($spread == 0) { // we don't want to divide by zero
                    $spread = 1;
            }
           
            // set the font-size increment
            $step = ($max_size - $min_size) / ($spread);
            
            foreach ($tags as &$tag ) {
                $tag['font-size'] =
                    round($min_size + (($tag['weight'] - $min_weight) * $step));
                $percent = floor(($tag['weight'] / $max_weight) * 100); 
                if ($percent < 20) {
                    $tag['class'] = 'tag0';
                } elseif ($percent >= 20 and $percent < 40) {
                    $tag['class'] = 'tag1';
                } elseif ($percent >= 40 and $percent < 60) {
                    $tag['class'] = 'tag2';
                } elseif ($percent >= 60 and $percent < 80) {
                    $tag['class'] = 'tag3';
                } else {
                    $tag['class'] = 'tag4';
                }   
            }
            
        }
        $this->_tags = $tags;
        return $this;
    }
    
    public function disableAction()
    {
        $this->_statusAction = false;
    }
    
    public function enableAction()
    {
        $this->_statusAction = true;
    }
    
    public function disableWeight()
    {
        $this->_disableWeight = false;
    }
    
    public function enableWeight()
    {
        $this->_disableWeight = true;
    }
    
    public function disableUsageTag()
    {
        $this->_usageTagAsId = false;
    }
    
    public function enableUsageTag()
    {
        $this->_usageTagAsId = true;
    }
}