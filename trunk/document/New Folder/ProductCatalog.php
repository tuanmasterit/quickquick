<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick_Core_Remoter_ProductCatalog {

	/**
	 * Retrieve product list, limit, start
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListProduct($limit, $start, $name, &$total)
	{

		return Quick::single('core/definition_product')->cache()->getListProduct($limit, $start, $name, &$total);
	}

	/**
	 * Retrieve product list unit
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getListUnit()
	{

		return Quick::single('core/definition_unit')->cache()->getListUnit();
	}

	/**
	 * Retrieve subject by is_producer
	 * @author	trungpm
	 * @return array Functions|mixed
	 */
	public static function getSubjectByType($type)
	{

		return Quick::single('core/definition_subject')->cache()->getSubjectByType($type);
	}

	/**
	 * Update field of Product by id
	 * @author	trungpm
	 * @return array
	 */
	public static function updateFieldOfProduct($productId, $field, $value)
	{

		return Quick::single('core/definition_product')->cache()->updateFieldOfProduct($productId, $field, $value);
	}

	/**
	 * Update Product by id
	 * @author	trungpm
	 * @return array
	 */
	public static function getProductById($productId)
	{
		return Quick::single('core/definition_product')->cache()->getProductById($productId);
	}

	/**
	 * Retrieve Retrieve unit of product list, limit, start
	 * @author	trungpm
	 * @return array
	 */
	public static function getUnitOfProduct($productId, $limit, $start, &$total)
	{
		return Quick::single('core/definition_relation_product_unit')->cache()->getUnitOfProduct($productId, $limit, $start, &$total);
	}

	/**
	 * Update field of detail unit product by id
	 * @author	trungpm
	 * @return array
	 */
	public static function updateFieldUnitOfProduct($productId, $field, $value)
	{

		return Quick::single('core/definition_relation_product_unit')->cache()->updateFieldUnitOfProduct($productId, $field, $value);
	}
}
