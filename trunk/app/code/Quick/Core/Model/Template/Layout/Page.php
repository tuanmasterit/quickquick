<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Model
 * @author      trungpm
 */
class Quick_Core_Model_Template_Layout_Page extends Quick_Db_Table
{
    protected $_name = 'core_template_layout_page';
    
    /**
     * Save or insert layout_to_page assignments
     * 
     * @param int $templateId
     * @param array $data
     * @return bool
     */
    public function save($templateId, $data)
    {
        if (!sizeof($data)) {
            Quick::message()->addError(
                Quick::translate('core')->__(
                    'No data to save'
            ));
            return false;
        }
        
        foreach ($data as $id => $values) {
            $rowData = array(
                'page_id'  => $values['page_id'] == '' ?
                    new Zend_Db_Expr('NULL') : $values['page_id'],
                'layout'   => $values['layout'],
                'priority' => $values['priority']
            );
            if (!isset($values['id']) 
                || !$row = $this->find($values['id'])->current()) {
                
                $rowData['template_id'] = $templateId;
                $row = $this->createRow();
            }
            $row->setFromArray($rowData);
            $row->save();
        }
        
        Quick::message()->addSuccess(
            Quick::translate('core')->__(
                'Data was saved successfully'
        ));
        return true;
    }
    
    /**
     * Insert layout_to_page assignment
     * 
     * @param string $layout
     * @param string $page
     * @param int $priority
     * @param int $templateId
     * @return Quick_Core_Model_Template_Layout_Page Provides fluent interface
     */
    public function add($layout, $page, $priority = 100, $templateId = null)
    {
        if (null === $templateId) {
            $templateId = isset(Quick::config()->design->main->frontTemplateId) ? 
                Quick::config()->design->main->frontTemplateId : 1;
        }
        $page_id = Quick::single('core/page')->getPageIdByRequest($page);
        if (!$page_id) {
            $request = explode('/', $page);
            $page_id = Quick::single('core/page')->insert(array(
                'module_name' => $request[0],
                'controller_name' => $request[1],
                'action_name' => $request[2]
            ));
        }
        $this->insert(array(
            'template_id' => $templateId,
            'page_id' => $page_id,
            'layout' => $layout,
            'priority' => $priority
        ));
        return $this;
    }
    
    /**
     * Removes layout_to_page assignments
     * 
     * @param string $layout
     * @param string $page
     * @param int $templateId
     * @return Quick_Core_Model_Template_Layout_Page Provides fluent interface
     */
    public function remove($layout, $page, $templateId = null)
    {
        if (null === $templateId 
            && !$templateId = Quick::config()->design->main->frontTemplateId) {

            $templateId = 1;
        }
        $pageId = Quick::single('core/page')->getPageIdByRequest($page);
        if (!$pageId) {
            return $this;
        }
        $this->delete(
            "template_id = {$templateId} AND page_id = {$pageId} AND layout = '{$layout}'"
        );
        return $this;
    }
}