Storage.prototype.setObject = function(key, value) {
    this.setItem(key, JSON.stringify(value));
}
 
Storage.prototype.getObject = function(key) {
    return JSON.parse(this.getItem(key));
}

var Sigular = function () {
	//Initialize data from localstorage
	this.kendoka = new Object();
	this.lastTest = 12;
	this.dump('up');
}
var sigular;

Sigular.prototype.execute = function () {
	this.lastTest++;
	$.ajax('/evaluate', {
		'type'   : 'POST',
		'data'   : ['myNumber=', this.lastTest, '&', $('#sigular-regex').serialize()].join(''),
		dataType : 'json',
		success  : function (data, textStatus, jqXH) {
			sigular.handleResponse(data);	
		},
		error    : function (jqXHR, textStatus, errorThrown) {
			//Just ignore, we dont care it for now
		}
	});
}

Sigular.prototype.handleResponse = function (data) {
	if (data[0]['myNumber']<this.lastTest) {
		console.log('Ignore step'.concat(data[0]['myNumber']))
		return; //Just ignore it 
	}

	var l = data.length;
	var matches;
	for (var i=1; i<l; i++) {
		$('.test-result > p', '#test-string-wrap').eq(i-1).html(data[i][0]);
		$('.test-result > pre', '#test-string-wrap').eq(i-1).html('');

		var elem  = $('<ol class="linenums">');
		var matcheObject, li;
		for (var j=0; j<data[i][1].length; j++) {
			matcheObject = data[i][1][j];		
			li = [];
			console.log(matcheObject);
			
			if ($.isArray(matcheObject)) {
				elem.append($('<li>').text(matcheObject));						
			} else {	
				for (var k in matcheObject) {
					li.push( ['<code class="label">',k, '</code>:&nbsp;', matcheObject[k]].join('') );								
				}
				console.log(li);
				elem.append($('<li>').html(li.join("\n")));			
			}					
		}
		$('.test-result > pre', '#test-string-wrap').eq(i-1).append(elem);
	}
}

Sigular.prototype.addTest = function () {
	var newElem = $('.test-string:first').clone();
	$('textarea', newElem).val('').text('');
	$('pre', newElem).val('').text('');
	$('p', newElem).val('').text('');

	newElem.appendTo('#test-string-wrap');
	return newElem;
}

Sigular.prototype.newOne = function () {

}

Sigular.prototype.share = function () {
	
}

Sigular.prototype.save = function () {
	
}

Sigular.prototype.viewGist = function () {
	
}

Sigular.prototype.storeTyping = function () {
	this.dump();
}


Sigular.prototype.dump = function (direction) {
	var kendoka;
	if (direction && direction=='up') {
		kendoka = localStorage.getObject('kendoka');
		if (kendoka) {
			if (kendoka.descrition) {
				$('#description').val(kendoka.descrition);			
			}

			if (kendoka.r) {
				$('#r').val(kendoka.r);
			}

			if (kendoka.s) {
				var s = kendoka.s.shift();
				var testContainer;
				$('textarea', '#test-string-wrap').val(s);

				for (var i=0, l=kendoka.s.length;i<l;i++) {
					testContainer = this.addTest();
					$('textarea', testContainer).val(kendoka.s[i]);
				}
			}

			this.kendoka = kendoka;
		}
		return kendoka;	
	} 
	kendoka = {
		descrition : $('#description').val(),
		r : $('#r').val(),
		s : []
	}
	$('textarea', '#test-string-wrap').length && $('textarea', '#test-string-wrap').each(function (idx, elem) {
		kendoka.s.push($(elem).val());
	})
	this.kendoka = kendoka;
	localStorage.setObject('kendoka', this.kendoka);
	return kendoka;
}



;(function ($) {
	$(document).ready(function () {

		sigular = new Sigular();
		console.log('Start to run');

		$('#more-test').click(function (e) {
			e.preventDefault();
			sigular.addTest();
		});

		//$('input, textarea', '#sigular-regex').keyup(function () {
		$('#sigular-regex').keyup(function () {	
			sigular.execute();
			sigular.storeTyping();

		})

	})	
})(jQuery);