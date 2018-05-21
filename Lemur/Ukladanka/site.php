<?php

class Site
{
    public $author = 'Lemur² ver 2015-12-09 by ericom Arkadiusz Moch';
    public $title = 'title';
    public $dirApp = '/Lemur2';
    public $includePath = '';
    public $buttons = array();
    public $columns = array();
    public $rows = array();

    function __construct ($title)
    {
        $this->title = $title;
        $this->includePath = dirname(__FILE__);
    }

    function header ()
    {
		$title=$this->title;
		$buttons=$this->buttons;
		require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/header.tpl");
    }

    function footer ()
    {
		$buttons=$this->buttons;
        require("{$_SERVER['DOCUMENT_ROOT']}/Lemur2/footer.tpl");
    }

    function addButton ($key, $name, $action, $js)
    {
        $this->buttons[] = array(
                'klawisz' => $key,
                'nazwa' => $name,
                'akcja' => $action,
                'js' => $js
        );
    }

    function addColumn ($field, $description)
    {
        $this->columns[] = array(
                'pole' => $field,
                'opis' => $description
        );
    }

    function addRow ($row)
    {
        $this->rows[] = $row;
    }
}
