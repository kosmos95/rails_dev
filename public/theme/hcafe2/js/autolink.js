jQuery.fn.highlight = function (text, o) {
	return this.each( function(){
		var replace = o || '<span class="highlight">$1</span>';
		$(this).html( $(this).html().replace( new RegExp('('+text+'(?![\\w\\s?&.\\/;#~%"=-]*>))', "ig"), replace) );
	});
}
 
// jQuery.fn.autolink = function (target) {
    // if (target == null) target = '_parent';
	// return this.each( function(){
		// var re = /((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g;
		// $(this).html( $(this).html().replace(re, '<a href="$1" target="'+ target +'">$1</a> ') );
	// });
// }
 

jQuery.fn.autolink = function (target) {
	var protocol_re = '(https?|ftp|news|telnet|irc)://';
	var domain_re   = '(?:[\\w\\-]+\\.)+(?:[a-z]+)';
	var max_255_re  = '(?:1[0-9]{2}|2[0-4][0-9]|25[0-5])';
	var ip_re       = '(?:'+max_255_re+'\\.){3}'+max_255_re;
	var port_re     = '(?::([0-9]+))?';
	var path_re     = '((?:/[\\w!"$-/:-@]+)*)';
	var hash_re     = '(?:#([\\w!-@]+))?';

	var url_regex = new RegExp('('+protocol_re+'('+domain_re+'|'+ip_re+')'+port_re+path_re+hash_re+')', 'ig');
	
	if (target == null) target = '_parent';

	var AutoLink = {
		targets : [],
		init : function() {
			this.targets = [];
		},
		start : function(_this) {
			var thisPlugin = this;

			// extract target text nodes
			this.extractTargets(_this);

			$(this.targets).each(function(){
					thisPlugin.do_autolink([this]);
			});
		},
		do_autolink : function(params) {
			var textNode = params[0];
			var content  = textNode.nodeValue;
			var dummy    = $('<span>');

			content = content.replace(/</g, '&lt;').replace(/>/g, '&gt;');
			content = content.replace(url_regex, '<a href="$1" target="_blank">$1</a>');

			$(textNode).before(dummy);
			$(textNode).replaceWith(content);
			params[0] = dummy.next('a');
			dummy.remove();
		},
		extractTargets : function(obj) {
			var thisPlugin = this;

			$(obj)
			.contents()
			.each(function(){
				// FIX ME : When this meanless code wasn't executed, url_regex do not run correctly. why?
				url_regex.exec('');

				if (!$(this).is('a,pre,xml,code,script,style,:input')) {
					if (this.nodeType == 3 && url_regex.test(this.nodeValue)) { // text node
						thisPlugin.targets.push(this);
					} else {							
						thisPlugin.extractTargets(this);
					}
				}
			});
		}
	};

	return this.each( function() {
		//var re = /((http|https|ftp):\/\/[\w?=&.\/-;#~%-]+(?![\w\s?&.\/;#~%"=-]*>))/g;
		//$(this).html( $(this).html().replace(re, '<a href="$1" target="'+ target +'">$1</a> ') );
		//console.log($(this));
		AutoLink.init();
		AutoLink.start($(this));
	});
};
 
jQuery.fn.mailto = function () {
	return this.each( function() {
		var re = /(([a-z0-9*._+]){1,}\@(([a-z0-9]+[-]?){1,}[a-z0-9]+\.){1,}([a-z]{2,4}|museum)(?![\w\s?&.\/;#~%"=-]*>))/g;
		$(this).html( $(this).html().replace( re, '<a href="mailto:$1">$1</a>' ) );
	});
}
 
jQuery.fn.hashtaglink = function (target) {
    if (target == null) target = '_parent';
	return this.each( function() {
        var re = /#([^\s]+)/g;
		$(this).html( $(this).html().replace( re, '<a href="https://twitter.com/search?q=%23$1" target="'+ target +'">#$1</a>' ) );
	});
}