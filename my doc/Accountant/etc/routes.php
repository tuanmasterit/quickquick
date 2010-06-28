<?php 
/**
 * @category    Quick
 * @package     Quick_Accountant
 * @author   	trungpm
 */

$router->addRoute('accountant', new Quick_Controller_Router_Route(
    Quick::config()->accountant->main->accountantRoute . '/:controller/:action/*',
    array(
        'module' => 'Quick_Accountant',
        'controller' => 'index',
        'action' => 'index'
    )
));