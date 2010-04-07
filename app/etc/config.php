<?php

$config = array(
    'system' => array(
        'path'		=> 'D:/program/xampp/htdocs/quickquick',
        'baseurl' 	=> 'http://localhost/quickquick',
		'namesite'	=> 'Quick Quick - ERP'
        ),
        
    'crypt' => array(
        'key' => 'baeafd3e02e78f85d6f40998791a2990'
        ),

    'db' => array(
        'host'     => 'localhost',
        'username' => 'root',
        'password' => '',
        'dbname'   => 'quickdb',
        'prefix'   => ''
        ),

    'front' => array(
        'humanUrlAdapter' => "Readable"
        ),

    'template' => array(
        'name'			=> "default",
        'default_layout'=> "_default"          
        )
        );
