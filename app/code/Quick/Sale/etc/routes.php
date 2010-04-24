<?php 
/**
 * @category    Quick
 * @package     Quick_Sale
 * @author   	trungpm
 */

$router->addRoute('sale', new Quick_Controller_Router_Route(
    Quick::config()->sale->main->saleRoute . '/:controller/:action/*',
    array(
        'module' => 'Quick_Sale',
        'controller' => 'index',
        'action' => 'index'
    )
));