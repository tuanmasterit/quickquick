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
 * @package     Ecart_Cms
 * @copyright   Copyright 2008-2009 E-Cart LLC
 * @license     GNU Public License V3.0
 */

/**
 * 
 * @category    Ecart
 * @package     Ecart_Cms
 * @subpackage  Helper
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Ecart_View_Helper_CmsTree
{
    /**
     *
     * @param array $pages
     * @return string
     */
    protected function renderPages($pages)
    {
        if (!is_array($pages) || !count($pages))
            return '';    
        $html = '<ul class="no-bullet">';
        foreach ($pages as $page) 
           $html .= '<li>' .
                        '<a href="' . 
                                $this->view->url(array('page' => $page['link']), 'cms_page', true) . 
                            '"
                            class="icon-page">' .
                        ($page['title'] == '' ? $page['link'] : $page['title']) . 
                        '</a>' .
                   '</li>';
        return $html . '</ul>';        
    }

    /**
     *
     * @param array $tree
     * @param int $parentId [optional]
     * @return string
     */
    public function cmsTree(&$tree, $parentId = 0)
    {
        if (!isset($tree[$parentId])) {
            return '';
        }
        $html = '<ul class="no-bullet">';
        foreach ($tree[$parentId] as $item) {
            $html .= '<li>' .
                '<a href="' . $this->view->url(array('cat' => $item['link']), 'cms_category', true) . '"
                    class="icon-folder"
                >' . ($item['title'] == '' ? $item['link'] : $item['title']) . '</a>' . 
                $this->cmsTree($tree, $item['id']) . 
                (isset($item['pages']) ? $this->renderPages($item['pages']) : '' ) .
                '</li>';
        }
        return $html . '</ul>';
    }
    
    public function setView($view)
    {
        $this->view = $view;
    }
}