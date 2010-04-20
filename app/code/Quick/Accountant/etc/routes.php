<?php 
/**
 * @category    Quick
 * @package     Quick_Accountant
 * @author   	trungpm
 */

$router->addRoute('accountant', new Quick_Controller_Router_Route(
    'accountant/*',
    array(
        'module' => 'Quick_Accountant',
        'controller' => 'index',
        'action' => 'index'
    )
));