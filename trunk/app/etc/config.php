<?php

$config = array(
    'system' => array(
        'path'		=> 'D:/ProgramFile/xampp/htdocs/quick',
        'baseurl' 	=> 'http://localhost/quick',
		'namesite'	=> 'Quick Quick - ERP',
		'adminurl'	=> '/'
        ),
        
    'crypt' => array(
        'key' => 'baeafd3e02e78f85d6f40998791a2990'
        ),

    'db' => array(
        'host'     => 'localhost',
        'username' => 'root',
        'password' => '',
        'dbname'   => 'quickquickdb',
        'prefix'   => ''
        ),

    'front' => array(
        'humanUrlAdapter' => "Readable"
        ),

    'template' => array(
        'name'			=> "default",
        'default_layout'=> "_default"          
        ),
    
    'developer' => array(
        'enable_proxy'	=> 1
        )
        );
