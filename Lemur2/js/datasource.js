/*
 * Flickr DataSource for Fuel UX Datagrid
 * https://github.com/adamalex/fuelux-dgdemo
 *
 * Copyright (c) 2012 Adam Alexander
 * Demo source released to public domain.
 */

var FlickrDataSource = function (options) {
	this._formatter = options.formatter;
	this._columns = options.columns;
};

FlickrDataSource.prototype = {

	/**
	 * Returns stored column metadata
	 */
	columns: function () {
		return this._columns;
	},

	/**
	 * Called when Datagrid needs data. Logic should check the options parameter
	 * to determine what data to return, then return data by calling the callback.
	 * @param {object} options Options selected in datagrid (ex: {pageIndex:0,pageSize:5,search:'searchterm'})
	 * @param {function} callback To be called with the requested data.
	 */
	data: function (options, callback) {

		var $url = 'data.php?format=json';
		var self = this;

		// Search active.  Add URL parameters for Flickr API.
		$url += '&tags=' + options.search;
		$url += '&per_page=' + options.pageSize;
		$url += '&page=' + (options.pageIndex + 1);

		$.ajax({url: $url 
            ,success: function(response) {

			// Prepare data to return to Datagrid

			var data = response.testdata;
			var count = response.total;
			var startIndex = (response.page - 1) * response.perpage;
			var endIndex = startIndex + 1*response.perpage;
			var end = (endIndex > count) ? count : endIndex;
			var pages = response.pages;
			var page = response.page;
			var start = startIndex + 1;

			// Allow client code to format the data
//				if (self._formatter) self._formatter(data);

			// Return data to Datagrid
			callback({ data: data, start: start, end: end, count: count, pages: pages, page: page });
		}});
	}
};