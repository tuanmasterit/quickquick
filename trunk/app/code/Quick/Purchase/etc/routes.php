<?php 
/**
 * @category    Quick
 * @package     Quick_Purchase
 * @author   	trungpm
 */

$router->addRoute('purchase', new Quick_Controller_Router_Route(
    Quick::config()->purchase->main->purchaseRoute . '/:controller/:action/*',
    array(
        'module' => 'Quick_Purchase',
        'controller' => 'index',
        'action' => 'index'
    )
));