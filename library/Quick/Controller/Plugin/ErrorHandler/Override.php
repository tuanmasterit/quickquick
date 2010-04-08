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
 */

/**
 *
 * @category    Ecart
 * @package     Ecart_Core
 * @author      Ecart Core Team <core@ecartcommerce.com>
 */
class Ecart_Controller_Plugin_ErrorHandler_Override extends Zend_Controller_Plugin_Abstract
{
    /**
     * Set different errorHandler module 
     * while Ecart_Admin is using
     * 
     * @param Zend_Controller_Request_Abstract $request
     * @return void
     */
    public function preDispatch(Zend_Controller_Request_Abstract $request)
    {
        if ($request->getParam('module') != 'Ecart_Admin') {
            return;
        }
        $errorHandler = Zend_Controller_Front::getInstance()
            ->getPlugin('Zend_Controller_Plugin_ErrorHandler')
            ->setErrorHandlerModule('Ecart_Admin');
    } 
}
