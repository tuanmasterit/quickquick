<?php
/**
 *
 * @category    Quick
 * @package     Quick_View
 * @subpackage  Quick_View_Helper
 * @author      trungpm
 */
class Quick_View_Helper_Meta
{
    private $_meta = array();
    private $_modes = array('cms_category', 'cms_page', 'category', 'product');


    public function  __construct()
    {
        $this->_config = Quick::config()->design->htmlHead;

    }

    public function setDefaults() 
    {
        $this->setTitle();
        $this->setDescription();
        $this->setKeywords();
        $this->setRobots();
    }

    /**
     * Enter description here...
     *
     * @param array $meta
     * @param string $mode ['cms_category', 'cms_page', 'category', 'product']
     * @param int $parentId
     * @return array
     */
    public function set($meta = false, $mode = null, $parentId = null)
    {
        $this->setTitle($meta['title'], $mode, $parentId);
        unset($meta['title']);

        $meta = array_filter($meta);
        if (is_array($meta)) {
            $this->_meta = array_merge($this->_meta, $meta);
        }
        return $this->_meta;
    }
    
    public function meta()
    {
        return $this;
    }

    public function setTitle($title = null, $mode = null, $parentId = null)
    {
//        if (null !== $mode && in_array($mode, $this->_modes)) {
//            $title = $this->_getMeta($title, $mode, 'title');
//        }
        $titleArray = array();
        foreach ($this->_config->titlePattern as $titlePart) {
            switch (strtolower($titlePart)) {
                case 'page title':
                    if (null !== $title) {
                        $titleArray[] = $title;
                    } else {
                        $titleArray[] = $this->_config->defaultTitle;
                    }
                break;
                case 'parent page titles':
                    if (null === $mode || !in_array($mode, $this->_modes)) {
                        break;
                    }

                    switch ($mode) {
                        case 'category':
                            $path = array_reverse(
                                Quick::single('catalog/category')->getParentItems(
                                    $parentId, Quick::getLanguageId()
                                )
                            );
                            array_shift($path);
                            break;
                        case 'product':
                            $path = array_reverse(
                                Quick::single('catalog/product')
                                    ->find($parentId)->current()->getParentItems()
                            );
                            break;
                        case 'cms_category':
                            $path = array_reverse(
                                Quick::single('cms/category')
                                    ->getParentsCategory($parentId)
                            );
                            array_shift($path);
                            break;
                        case 'cms_page':
                            $path= array_reverse(
                                Quick::single('cms/category')
                                    ->getParentsCategory($parentId, true)
                            );
                            break;
                    }

                    foreach ($path as $item) {
                        $item['name'] = isset($item['name']) ?
                            $item['name'] : $item['title'];
                        $titleArray[] = trim($item['meta_title']) == '' ?
                            trim($item['name']) : trim($item['meta_title']);
                    }

                break;
                case 'site name':                    
                	$titleArray[] = Quick::config()->system->namesite;
                break;
            }
        }

        $this->_meta['title'] = htmlspecialchars(
                $this->_config->titlePrefix .
                trim(implode($this->_config->titleDivider, $titleArray)).
                $this->_config->titleSuffix
        );
        return $this;
    }

    public function getTitle()
    {
        return $this->_meta['title'];
    }

    public function setDescription($description = null, $mode = null)
    {
        if (null === $description) {
            $description = $this->_config->defaultDescription;
        }
        if (null !== $mode && in_array($mode, $this->_modes)) {
            $description = $this->_getMeta($description, $mode, 'description');
        }
        if (!empty($description)) {
            $this->_meta['description'] = $description;
        }
        return $this;
    }

    public function getDescription()
    {
        return $this->_meta['description'];
    }

    public function setKeywords($keywords = null, $mode = null)
    {
        if (null === $keywords) {
            $keywords = $this->_config->defaultRobots;
        }
        if (null !== $mode && in_array($mode, $this->_modes)) {
            $keywords = $this->_getMeta($keywords, $mode, 'keywords');
        }
        if (!empty($keywords)) {
            $this->_meta['keywords'] = $keywords;
        }
        return $this;
    }

    public function getKeywords()
    {
        return $this->_meta['keywords'];
    }

    public function setRobots($robots = null)
    {
        if (null === $robots) {
            $robots = $this->_config->defaultRobots;
        }
        if (!empty($robots)) {
            $this->_meta['robots'] = str_replace(' ', ',', $robots);
        }
        return $this;
    }

    public function getRobots()
    {
        return $this->_meta['robots'];
    }

    private function _getMeta($id, $mode, $type = 'title')
    {
        switch ($mode) {
            case 'category':
                $entry = Quick::single('catalog/category_description')
                    ->find($id, Quick::getLanguageId())->current();
                break;
            case 'product':
                $entry = Quick::single('catalog/product_description')
                    ->find($id, Quick::getLanguageId())->current();
                break;
            case 'cms_category':
                $entry = Quick::single('cms/category_content')
                    ->find($id, Quick::getLanguageId())->current();
                $entry->name = $entry->title;
                break;
            case 'cms_page':
                $entry = Quick::single('cms/page_content')
                    ->find($id, Quick::getLanguageId())->current();
                $entry->name = $entry->title;
                break;
        }
        
        $result = null;
        switch ($type) {
//            case 'title':
//                $result = $entry->meta_title == '' ?
//                    $entry->name : $entry->meta_title;
//                break;
            case 'description':
                $result = $entry->meta_description == '' ?
                    $entry->description : $entry->meta_title;
                break;
            case 'keywords':
                $result = $entry->meta_keyword;
                break;
        }
        return $result;
    }
}