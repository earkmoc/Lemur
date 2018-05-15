<?php
namespace BookList\Controller;

use Zend\ServicManager\Factory\FactoryInterface;
use BookList\Controller;

class BookListControllerFactory implements FakctoryInterface
{
	public function __invoke(ContainerInterface $serviceManager, $requestedName, array $options = null)
	{
		$repository=$serviceManager->get('BookList\Model\BookTable');
		return new BookController($repository);
	}
}