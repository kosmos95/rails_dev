function page_goto(url) {
  document.location.href = url; 
}

function gohome() {
  page_goto('/');
}

function empty_selection() {
  if (window.getSelection) {
    if (window.getSelection().empty) {  // Chrome
      window.getSelection().empty();
    } else if (window.getSelection().removeAllRanges) {  // Firefox
      window.getSelection().removeAllRanges();
    }
  } else if (document.selection) {  // IE?
    document.selection.empty();
  }  
}

function notify(msg) {
  $.notify({
    // options
    message: msg,
  },{
    // settings
    element: 'body',
    position: null,
    type: "info",
    allow_dismiss: true,
    newest_on_top: false,
    showProgressbar: false,
    placement: {
      from: "top",
      align: "center"
    },
    offset: 20,
    spacing: 10,
    z_index: 1031,
    delay: 2000,
    timer: 1000,
    url_target: '_blank',
    mouse_over: null,
    animate: {
      enter: 'animated fadeInDown',
      exit: 'animated fadeOutUp'
    },
    onShow: null,
    onShown: null,
    onClose: null,
    onClosed: null,
    icon_type: 'class',
    template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
      '<button type="button" aria-hidden="true" class="close" data-notify="dismiss">×</button>' +
      '<span data-notify="icon"></span> ' +
      '<span data-notify="title">{1}</span> ' +
      '<span data-notify="message">{2}</span>' +
      '<div class="progress" data-notify="progressbar">' +
        '<div class="progress-bar progress-bar-{0}" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 0%;"></div>' +
      '</div>' +
      '<a href="{3}" target="{4}" data-notify="url"></a>' +
    '</div>' 
  });
  
}

function check_host() {
	var host_urls = ['m.hanryumoa.net'];
	host_urls.forEach(function(url) { 
		if(location.href.indexOf(url) >= 0)
			location.replace(location.href.replace(url, "www.hanryumoa.net"))
	});
}

function start_url_replace(from, to) {
	return location.href.replace("/^"+from+"/", to)
}

// load youtube js api 
function reloadYoutube() {
	// if YT already initialized return 
	console.log('reloadYoutube');
	if (window.YT) { return; };
	var tag = document.createElement('script');
	tag.src = "https://www.youtube.com/iframe_api";
	var firstScriptTag = document.getElementsByTagName('script')[0];
	firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

function get_youtube_id(url) {
	var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
	var match = url.match(regExp);
	return (match&&match[7].length==11)? match[7] : false;
}


// youtube callback 
/*
var ytplayer = null;
function onYouTubeIframeAPIReady1() {
	// it is important to return when window.ytplayer 
	// is already created - because you will be missing
	// certain methods like getCurrentTime
	if (!window.YT || window.ytplayer) {
		return;
	}
	ytplayer = new YT.Player('main_player_div', {
		height: '315',
		width: '560',
		videoId: getVideoId(),
			events: {
				'onReady': onPlayerReady
			}
	});
}


$(document).on('ready', function() {
	console.log('ready');
	//onYouTubeIframeAPIReady1 && onYouTubeIframeAPIReady1();
});


$(document).on('turbolinks:load', function() {
	console.log('turbolinks:load');
	reloadYoutube();
	//onYouTubeIframeAPIReady1 && onYouTubeIframeAPIReady1();
});
*/


//$(document).ready(function() {
$(document).on('turbolinks:load', function() {
  //$(".content").oembed();
  console.log('turbolinks:load');

  $(".content").autolink('_new');
  
  $(".content a").each(function(index, value) { 
      var href = $(this).attr('href');
      if( href.match( /youtube.com|youtu\.be/g ) ) {
        $(this).addClass("oembed");
      }
    }
  );
  
  $("a.oembed").oembed(null,{
    apikeys: {
    },
    //maxHeight: 200, maxWidth:350
  });
});
