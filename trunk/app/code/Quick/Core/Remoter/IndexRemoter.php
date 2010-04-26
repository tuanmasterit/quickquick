<?php
/**
 *
 * @category    Quick
 * @package     Quick_Core
 * @author      trungpm
 */
class Quick_Core_Remoter_IndexRemoter{

	/**
	 * Retrieve Resource object for permission asignment
	 *
	 * @return array Functions|mixed
	 */
	public static function getResources()
	{
		$result = array();
		$resources = Quick::single('core/function')->cache()->getFunctions(Quick_Locale::getLocale());
		$roles = Quick::single('core/acl_role')->cache()->getRoles();
		$i = 0;
		foreach ($resources as $resource) {
			foreach ($roles as $role) {
				$resources[$i][$role['role_name']] = "";
			}
			$i++;
		}
		$rules = Quick::single('core/acl_rule')->cache()->getRulesWithRoles();
		$i = 0;
		foreach ($resources as $resource) {
			foreach ($rules as $rule) {
				if (($resource['function_id'] == $rule['function_id']) && ($rule['permission'] == 'allow'))
				$resources[$i][$rule['role_name']] = "allow";
			}
			$i++;
		}
		foreach ($resources as $resource) {

			if (!isset($result[$resource['function_id']])) {
				$result[$resource['function_id']] = $resource;
			}
		}
		return $result;
	}
}