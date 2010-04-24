<?php
/**
 * @category    Quick
 * @package     Quick_Core
 * @author		trungpm
 */
$config = array(
    'Quick_Core' => array(
        'package' => 'Quick_Core',
        'name' => 'Core',
        'version' => '0.1',
        'required' => 1,
        'idInDb' => 7 // id of package in database
        /*, // goi ham tu dong khi co su kien xay ra
		'events' => array(
            'core_event' => array(
                'notify' => array(
                    'type' => 'model',
                    'model' => 'core/module',
                    'method' => 'testStock'
                )
            )
        )*/
    )
);