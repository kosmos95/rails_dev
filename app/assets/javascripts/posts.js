//$("document").ready(function() {
/* $(document).on('turbolinks:load', function() {  
  if(is_mobilemode) {
    $(".posts .listitem").click(function() {
      var url = $(this).data('url');
      page_goto(url);
    });
  }
}); */

$(document).on('turbolinks:load', function() {

  // general page options 
  $("[data-myacttype]").click(function(e) {
    e.preventDefault();
    var type = $(this).data("myacttype");
    var url = $(this).data("url");
    var msg = $(this).data("msg");
    
    if(type == 'goto' || type == 'delete') {
      if(typeof msg != "undefined") {
        if(confirm(msg)) page_goto(url);
      } else 
        page_goto(url);

    } else {
      console.log('no relevant type:' + type)
    }
  });
  
  // signature 
  var $sign = $(".posts .signature");
  var $signtext = $(".sign_text.long", $sign);
  if($signtext.length > 0) {
    $signtext.addClass('sign_wrap');
    $(".sign_more", $sign).css('display', 'block');
    $sign.click(function() {
      $text = $(".sign_text", $sign);
      if($text.hasClass('sign_wrap')) {
        $text.removeClass('sign_wrap');
        $(".sign_more", $sign).css('display', 'none');
      } else {
        $text.addClass('sign_wrap');
        $(".sign_more", $sign).css('display', 'block');
      }
    });
  }
  
  // post source options value helper   
  $('.postwrite input#source_options').change(function() {
    if( ! $(this).prop('checked') ) 
      return; 

    var str = $(this).val();    
    
    if( $('#post_source').val() == '' ) {
      $('#post_source').val(str);
      
    } else {
      var confirmed = confirm("출처를 '" + str + "'으로 설정하겠습니까?");
      if(confirmed)
        $('#post_source').val(str);
    }
  });
  
  $('.postwrite input#post_source').keyup(function() {
    var checkbox = $('input#source_options'); 
    var checkbox_str = checkbox.val();
    var str = $(this).val();
    checkbox.prop('checked', (str == checkbox_str));
  });  
  

  $('.postshow .favor').click(function(e) {
    if(is_logged_in) {
      var post_id = $(this).data('post_id');
      var bid = $(this).data('bid');
      var uri = $(this).data('uri');
      $.ajax({ url: uri, method:'patch'}).done(function() {
        //console.log('posts.favor');
      });
    } else {
      notify("로그인을 해주세요.");
    }
  });
  
  $('.postlist .category li').click(function(e) {
    var url = $('a', $(this)).attr('href');
    document.location.href = url;
  });
  
});

var postedit_set_files = function(files, orig_files) {
  //console.log("postedit_set_files");
  var FILES_FILED_ID = 'post_files';
  
  var uniqueArray = function(arrArg) {
    return arrArg.filter(function(elem, pos, arr) {
      return arr.indexOf(elem) == pos;
    });
  };
  
  var files = String(files || "");
  var files_new_arr = files.split(",");
  if(typeof orig_files == 'undefined') {
    orig_files = document.getElementById(FILES_FILED_ID).value || "";
  }
  
  var orig_files_arr = orig_files.split(",");  
  //console.log("orig_files_arr:" + orig_files_arr);
  var new_files_arr = uniqueArray(files_new_arr.concat(orig_files_arr));  
  //console.log("new_files_arr:" + new_files_arr);
  var new_files_arr2 = new_files_arr.filter(function(x) {
    return x != null && x !== "";
  });
  var new_files = new_files_arr2.join(",");

  //console.log("new_files: " + new_files);
  document.getElementById(FILES_FILED_ID).value = new_files;
};

