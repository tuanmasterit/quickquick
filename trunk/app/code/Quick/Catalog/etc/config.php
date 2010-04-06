<?php
/**
 * @category    Quick
 * @package     Quick_Catalog
 * @author		trungpm
 */

$config = array(
    'Quick_Catalog' => array(
        'package' => 'Quick_Catalog',
        'name' => 'Catalog',
        'version' => '0.1',
        'required' => 1,
        'events' => array(
            'catalog_product_update_stock' => array(
                'notify' => array(
                    'type' => 'model',
                    'model' => 'catalog/observer',
                    'method' => 'notifyStockUpdate'
                )
            ),
            'catalog_product_update_quantity' => array(
                'notify' => array(
                    'type' => 'model',
                    'model' => 'catalog/observer',
                    'method' => 'notifyQuantityUpdate'
                )
            )
        )
    )
);