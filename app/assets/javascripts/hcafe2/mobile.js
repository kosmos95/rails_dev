function scrollTop() {
  $('html, body').animate({ 
    scrollTop: 0
  }, 800);
  
  $('#goto_top').css('display', 'none');      
}

// smooth scroll 
$(function() {
  $('a[href*="#"]:not([href="#"])').click(function() {
    if (location.pathname.replace(/^\//,'') == this.pathname.replace(/^\//,'') && location.hostname == this.hostname) {
      var target = $(this.hash);
      target = target.length ? target : $('[name=' + this.hash.slice(1) +']');
      if (target.length) {
        $('html, body').animate({ 
        scrollTop: target.offset().top - 20
        }, 800);
        return false;
      }
    }
  });
});

//$(document).ready(function() {
$(document).on("turbolinks:load", function() {

  // mobile/pc common code -------------
  
  // Target your .container, .wrapper, .post, etc.
  var iframe = $(".content iframe");
  $.each(iframe, function(idx, item) {
    var re = /youtube|youtu\.be/;
    var src = item.src;
    if(src.match(re)) {
      $(item).addClass('fitvids');
      $(item).attr('frameborder', '0');
    }
  });

  // desktopmode 
  if($(".mobile").size() == 0)
	  return;
  
  // mobile only codes -------------------------- 
  console.log('mobile mode');
     
  // 사이드바  
  $("#sidebar").simplerSidebar({
    selectors: {
      trigger: "#toggle-sidebar",
      quitter: ".close-sidebar"
    },
    animation: {
      duration: 200,
    }
  });

  $( "#goto_top" ).click(function( e ) {
    e.preventDefault();
    scrollTop();
    return false;
  });
  
  var _oldtop=0;
  var _window_top = 0;
  var _scroll_down = true; 
  $(window).scroll(function() {
    var wtop = $(window).scrollTop();
    var wheight = $(window).height();
    //var h = $('#header').height();
    var upsliding =   (wtop - _oldtop <  -5);
    var downsliding = (wtop - _oldtop >   5);

    //$('#header').css('z-index', 9999);
    if(upsliding) {
      if(_scroll_down == true) {
        $('#goto_top').css('top', wheight-80).css('display', 'block'); 
        _scroll_down = false;
      }
      
    } else if(downsliding) {
      if(_scroll_down == false) {
        $('#goto_top').css('display', 'none');
        _scroll_down = true;
      }
    }
    
    if(wtop < wheight) {
      $('#goto_top').css('display', 'none');
    }
    
    _oldtop = wtop; 
    _window_top  = wtop; 
  });
  
  //$('iframe.fitvids').parent().fitVids(); 

});

