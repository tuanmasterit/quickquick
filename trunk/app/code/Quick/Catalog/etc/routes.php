<?php 
/**
 * @category    Quick
 * @package     Quick_Catalog
 * @author   	trungpm
 */

$router->addRoute('product_catalog', new Quick_Controller_Router_Route(
    Quick::config()->catalog->main->catalogRoute . '/*',
    array(
        'module' => 'Quick_Catalog',
        'controller' => 'index',
        'action' => 'view'
    )
));