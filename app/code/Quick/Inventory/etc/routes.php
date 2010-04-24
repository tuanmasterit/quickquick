<?php 
/**
 * @category    Quick
 * @package     Quick_Inventory
 * @author   	trungpm
 */

$router->addRoute('inventory', new Quick_Controller_Router_Route(
    Quick::config()->inventory->main->inventoryRoute . '/:controller/:action/*',
    array(
        'module' => 'Quick_Inventory',
        'controller' => 'index',
        'action' => 'index'
    )
));