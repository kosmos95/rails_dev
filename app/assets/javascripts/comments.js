// Encoding: UTF-8

var Comment = {
  
  current_user_id: 0,
  
  post_id: 0,
  
  cmt_count: 0,
  
  max_depth: 3, 
  
  update_cmt_count: function() {
    $('.comment_header .cmt_count').html(Comment.cmt_count); 
  },
  
  // 삭제된 댓글 표기 
  check_as_softdeleted: function(cmt_id) {
    var cmt = $("#comment_" + cmt_id);
    cmt.addClass('deleted');
    $('.comment_item_body', cmt).html("<div class='msg'>삭제된 댓글입니다.</div>");
  },
  
  set_main_form_event: function() {
    
    // 입력 댓글 글자 수 변경 
    $('.comments_form textarea').keyup(function() {
      var len = $(this).val().length;
      var parent = $(this).closest('form');
      $('.count', parent).text(len);
    });    

    var re_iframe = /^\<head\>|^\<script/;
    
    // 입력완료 
    $('.comments_form form').on("ajax:success", function(e, data) {
      if(null == data) {
        notify('입력할 수 없습니다.'); 
        return;
      }
    
      // file upload 를 위해서... data-type: html로 하고 그 실행 후, 그 값을 받아 수동으로 실행해줌 !!! 
      if(null == data.match(re_iframe)) {
        var script = data;
        eval(script);
      }
    });

    // 이미지 첨부 입력 완료 
    $('.comments_form form').on("ajax:remotipartComplete", function(e, data) {
      if(data.match(re_iframe)) {
        var iframe = document.createElement('iframe');
        document.body.appendChild(iframe);
        iframe.contentWindow.document.write(data);
        var ta = iframe.contentDocument.getElementsByTagName("textarea")[0];
        if(ta) {
          var script = ta.value;
          eval(script);
        }
        iframe.parentNode.removeChild(iframe);
      }
    });
  },
  
  set_reply_form_event: function() {
  
    $('.comments_list ul li').each(function() {
      var _comment_item  = $(this);
      
      if($(this).data('event') == '1')
        return;
      
      $(this).data('event', 1);
      
      // 댓글 클릭
      $('.comment_item_action .reply', $(this)).click(function() {
        var comment_item = $(this).parent().parent();
        var comment_action = $(this).parent();        
        if(Comment.current_user_id) {
          var depth = $(this).data('parent-depth');
          if(depth >= Comment.max_depth) {
            notify('' + Comment.max_depth + '단 이상 댓글은 이용할 수 없습니다.')
          } else {
            var form = comment_item.find('>.comment_form_reply'); 
            $('form', form).attr('action', '/posts/' + Comment.post_id + '/comments');
            $('form', form).attr('method', 'post');
            form.show();
            comment_action.css('display', 'none');
          }
        } else {
          notify("로그인을 해주세요.");
        }
      });
      
      // 댓글 수정 클릭
      $('.comment_item_action .modify', $(this)).click(function() {
        var comment_id = $(this).data('parent-id');
        var comment_item = $(this).parent().parent();
        var comment_action = $(this).parent();
        var text = $('.comment_item_body p', comment_item).text().trim();
        if(Comment.current_user_id) {
          var form = comment_item.find('>.comment_form_reply'); 
          $('form', form).attr('action', '/posts/' + Comment.post_id + '/comments/' + comment_id);
          $('form', form).attr('method', 'patch');
          $('textarea', form).val(text);
          form.show();
          comment_action.css('display', 'none');
        } else {
          notify("로그인을 해주세요.");
        }
      });      
      
      $('.cancel', $(this)).click(function() {
        $('.comment_item_action', _comment_item).css('display', 'block');
        $('>.comment_form_reply', _comment_item).css('display', 'none');
      });

      // 추천 기능 
      $('.comment_item_action .thumbup', $(this)).click(function() {
        var post_id = Comment.post_id;
        var comment_id = $(this).data('parent-id');
        if(Comment.current_user_id) {
          $.ajax({ url: "/posts/"+post_id+"/comments/"+comment_id+"/favor", method:'patch'}).done(function() {
            //console.log('comments.favor');
          });
        } else {
          notify("로그인을 해주세요.");
        }
      });

      // 신고 기능 
      $('.comment_item_action .report', $(this)).click(function() {
        if(Comment.current_user_id) {
          var post_id = Comment.post_id;
          var comment_id = $(this).data('parent-id');
          $('#reportModal #post_id').val(post_id)
          $('#reportModal #comment_id').val(comment_id)
          $('#reportModal').modal();
        } else {
          notify("로그인을 해주세요.");
        }
      });
      
      // 입력 대댓글 글자 수 변경 
      $('.comment_form_reply form textarea', $(this)).keyup(function() {
        var len = $(this).val().length;
        var parent = $(this).closest('form');
        $('.count', parent).text(len);
      });

      var re_iframe = /^\<head\>|^\<script/;
      
      $('.comment_form_reply form', $(this)).on("ajax:success", function(e, data) {
        var script = data;
        //console.log('comment_form_reply form 1 ');
        if(null == script.match(re_iframe)) {
          eval(script);
        }
      });

      $('.comment_form_reply form', $(this)).on("ajax:remotipartComplete", function(e, data) {
        //console.log('comment_form_reply form 2 ');
    if(null == data) {
      notify('입력할 수 없습니다.'); return;
    }      
        if(data.match(re_iframe)) {
          var iframe = document.createElement('iframe');
          document.body.appendChild(iframe);
          iframe.contentWindow.document.write(data);
          var ta = iframe.contentDocument.getElementsByTagName("textarea")[0];
          if(ta) {
            var script = ta.value;
            eval(script);
          }
          iframe.parentNode.removeChild(iframe);
        }  
      });
      
    });
  }, 

  
  check_new_notify: function(msg) {
    //$(".check_new_result").html(msg).slideDown(200).delay(2000).slideUp(200);
  $('.check_new i.spinner').css('display', 'none');
  $('.check_new i.reply').css('display', 'inline-block');
  
    $(".check_new_result").html(msg)
    .css('display', 'block').delay(2000).slideUp(200);
  },
  
  // 새 댓글 확인 
  check_new_comment: function() {
    var max_id = 0;
    var post_id = Comment.post_id;
    
    $('.comments_list li').each(function(i, v) { 
      var id = $(v).data('id'); 
      if(id > max_id) max_id = id;
    });
  
  $('.check_new i.spinner').css('display', 'inline-block');
  $('.check_new i.reply').css('display', 'none');
    
    $.ajax({ url: "/comments/check_new/" + post_id + "?max_id=" + max_id, remote: true })
      .done(function() { 
        console.log('comment.checknew');
      });
  },
  
  new_item_blink: function(cmt_id) {
    // color animate 
    var item = $("li#comment_" + cmt_id);
    var color_backup = item.css('background-color');
    item.animate(
      { backgroundColor: '#fee8d6' }, 300, 
      function() { item.animate({ backgroundColor: color_backup}, 1000) }
    );
  },
  
  init_actions: function() {
    var max_check_intv = 3; 
    var check_new_timestamp = 0;
    $('.check_new').click(function() {
      var timestamp = new Date().getTime();
      var diff = parseInt((timestamp - check_new_timestamp) / 1000);
      if(diff >= max_check_intv) {
        Comment.check_new_comment();
        check_new_timestamp = timestamp;
      } else {
        //notify("잠시 기다려주세요! (" + (max_check_intv-diff) + "초 남음)"); 
      }
    });
    
    // 신고 모달 처리 
    $("#reportModal #submit").click(function() {
      var dialog = $(this).closest('.modal');
      var reason = $("#reason", dialog).val();
      if(reason == '') {
        notify("신고 이유를 입력해주세요");
        return;
      }

      var post_id = $("#post_id", dialog).val();
      var comment_id = $("#comment_id", dialog).val();
      var type = '2';

      $.ajax({ url: "/posts/"+post_id+"/comments/"+comment_id+"/reportabuse", method:'post', 
        data: { type: type, reason: reason }
      }).done(function() {
        $("#reason", dialog).val('');
        dialog.modal('hide');
      });
      
    });
  }, 
  
  init: function() {
    Comment.current_user_id = $('.comments').data('current_user_id');    
    Comment.post_id = $('.comments').data('post_id');    
    Comment.cmt_count = $('.cmt_count').data('cmt_count');    
    Comment.init_actions();
    Comment.set_main_form_event();
    Comment.set_reply_form_event();
  }
  
};

