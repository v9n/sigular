var Sibex = function () {
	this.lastTest = 12;
}

Sibex.prototype.execute = function () {
	
}

Sibex.prototype.handleResponse = function () {

}

Sibex.prototype.addTest = function () {
	var newElem = $('.test-string:first').clone();
	$('textarea', newElem).val('').text('');
	$('textarea', newElem).val('').text('');
	
	newElem.appendTo('#test-string-wrap');
}

Sibex.prototype.newOne = function () {

}

Sibex.prototype.share = function () {
	
}

Sibex.prototype.save = function () {
	
}

Sibex.prototype.viewGist = function () {
	
}


;(function ($) {
	var sibex = new Sibex();
	console.log('Start to run');

	$('#more-test').click(function (e) {
		e.preventDefault();
		sibex.addTest();

	})
	console.log($('#sibex-regex'));
	console.log($('#sibex-regex').serialize());
	//sibex.execute();
	//this.lastTest++;
	$.ajax('/do2', {
		'type'   : 'POST',
		'data'   : ['myNumber=', this.lastTest, '&', $('#sibex-regex').serialize()].join(''),
		dataType : 'json',
		success  : function (data, textStatus, jqXH) {
			//If not the last msg from server. Ignore it because the another one is in processing dude
			console.log(data);
			var l = data.length;
			var matches;
			for (var i=1; i<l; i++) {
				$('.test-result > p', '#test-string-wrap').eq(i-1).html(data[i][0]);
				var elem  = $('<ol class="linenums">');
				for (var j=0; j<data[i][1].length; j++) {
					elem.append($('<li>').text(data[i][1][j]));
				}
				console.log(elem);
				$('.test-result > pre', '#test-string-wrap').eq(i-1).append(elem);
			}
		},
		error    : function (jqXHR, textStatus, errorThrown) {
			//Just ignore, we dont care it for now
		}
	});
})(jQuery);