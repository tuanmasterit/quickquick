<?php
/**
 * 
 * @category    Quick
 * @package     Quick_Core
 * @subpackage  Controller
 * @author      trungpm
 */
class IndexController extends Quick_Core_Controller_Front
{
    public function init()
    {
        parent::init();
        $this->view->crumbs()->disable();
    }

    public function indexAction()
    {
        /*$this->view->meta()
            ->setTitle(Quick::config()->design->htmlHead->homeTitle)
            ->setDescription(Quick::config()->design->htmlHead->homeDescription)
            ->setKeywords(Quick::config()->design->htmlHead->homeKeywords)
        ; */
    	echo "ddd";
    	$this->view->meta()
            ->setTitle("Quick::config()->design->htmlHead->homeTitle")
            ->setDescription("Quick::config()->design->htmlHead->homeDescription")
            ->setKeywords("Quick::config()->design->htmlHead->homeKeywords")
        ; 
        $this->render();
    }
}