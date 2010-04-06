<?php
/**
 * @category    Quick
 * @package     Quick_Core
 * @author		trungpm
 */
$router->addRoute('core', new Quick_Controller_Router_Route(
    '*/:controller/:action/*',
    array(
        'module' => 'Quick_Core',
        'controller' => 'index',
        'action' => 'index'
    )
));