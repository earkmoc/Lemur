<?php
namespace BookList\Controller;

use Zend\Mvc\Controller\AbstractActionController;
use Zend\View\Model\ViewModel;
use BookList\Form\BookForm;

class BookController extends AbstractActionController
{
	public function indexAction()
	{
		return new ViewModel(array(
			'books'=>[]
		));
	}
	public function addAction()
	{
		$form=new BookForm();
		$form->get('submit')->setValue('Add');
		
		$request=$this->getRequest();
		if($request->isPost())
		{
			
		}
		return array('form'=>$form);
	}
	public function editAction()
	{
		$form=new BookForm();
		//$form->bind($book);
		$form->get('submit')->setAttribute('value','Edit');
		
		$request=$this->getRequest();
		if($request->isPost())
		{
			
		}
		return array(
			'id'=>$id,
			'form'=>$form,
		);
	}
	public function deleteAction()
	{
		
	}
}