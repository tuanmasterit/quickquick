<?php 
/**
 * @category    Quick
 * @package     Quick_General
 * @author   	trungpm
 */

$router->addRoute('general', new Quick_Controller_Router_Route(
    Quick::config()->general->main->generalRoute . '/:controller/:action/*',
    array(
        'module' => 'Quick_General',
        'controller' => 'index',
        'action' => 'index'
    )
));