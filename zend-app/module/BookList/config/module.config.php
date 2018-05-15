<?php
namespace BookList;

use BookList\Controller;
/*
*/
return array(
	'controllers'=>array(
		'factories'=>array(
			BookList\Controller\Book::class => BookList\Controller\BookController::class,
			BookController::class => BookControllerFactory::class
		),
	),
	'router'=>array(
		'routes'=>array(
			'book'=>array(
				'type'=>'segment',
				'options'=>array(
					'route'=>'/book[/][:action][/:id]',
					'constraints'=>array(
						'action'=>'[a-zA-Z][a-zA-Z0-9_-]*',
						'id'=>'[0-9]+',
					),
					'defaults'=>array(
						'controller'=>Controller\BookList\Controller::class,
						'action'=>'index',
					),
				),
			),
		),
	),
	'view_manager'=>array(
		'template_path_stack'=>array(
			'book'=>__DIR__.'/../view',
		),
	),
);