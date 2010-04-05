<?php
/**
 * Quick
 * @category    Quick
 * @package     Quick_Core
 * @copyright   Copyright 2009-2010 VTM J.S.C.
 * @license     V0.1
 */
define('QUICK_ROOT', realpath(dirname(__FILE__)));

set_include_path(
    realpath('library')  . PATH_SEPARATOR
    . realpath('app/code') . PATH_SEPARATOR
    . get_include_path()
);

@include_once 'Zend/Application.php';
if (!class_exists('Zend_Application')) {
    echo 'Please, copy Zend Framework to the "library" folder: '
        . realpath('library');
    exit();
}

defined('APPLICATION_ENV')
    || define('APPLICATION_ENV',
        (getenv('APPLICATION_ENV') ? 
            getenv('APPLICATION_ENV') : 'production'
        )
    );

$displayErrors = (int)(APPLICATION_ENV !== 'production');

$bootstrapConfig = array(
    'bootstrap' => array(
        'path' =>'Quick/Bootstrap.php',
        'class' => 'Quick_Bootstrap'
    ),
    'phpSettings' => array(
        'display_startup_errors' => $displayErrors,
        'display_errors' => $displayErrors
    )
);

$application = new Zend_Application(APPLICATION_ENV, $bootstrapConfig);

$application->bootstrap()->run();