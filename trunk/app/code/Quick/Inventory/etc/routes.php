<?php 
/**
 * @category    Quick
 * @package     Quick_Inventory
 * @author   	trungpm
 */

$router->addRoute('inventory', new Quick_Controller_Router_Route(
    'inventory/*',
    array(
        'module' => 'Quick_Inventory',
        'controller' => 'index',
        'action' => 'index'
    )
));