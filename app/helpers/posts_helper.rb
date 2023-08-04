module PostsHelper

  def tinymce_with_default_option
    tinymce theme: 'modern', 
      height: '400', 
      language: "ko_KR", 
      plugins: ["uploadimage", "link", "textcolor", "code", "table", "lists", "charmap", "lineheight", "media"], 
      toolbar: 'fontselect | fontsizeselect | bold italic underline forecolor backcolor hilitecolor removeformat | alignleft aligncenter alignright styleselect | ' +
        'lineheightselect | ' +
        'bullist numlist outdent indent blockquote  | insert link uploadimage | table | code',
      font_formats:
        "나눔고딕='Nanum Gothic', 나눔고딕;"+
		    "맑은고딕='Malgun Gothic', 맑은고딕;"+
        "굴림체=Gulim,굴림체;"+
        "돋움체=Dotum,굴림체;"+
        "명조체=Myungjo,명조체;"+
        "Arial=Arial,Helvetica,Sans-serif;"+
        "Book Antiqua=Book antiqua,Palatino;"+
        "Comic Sans MS=Comic sans ms,Sans-serif;"+
        "Helvetica=Helvetica;"+
        "Tahoma=Tahoma,Arial,Helvetica,Sans-serif;"+
        "Times New Roman=Times new roman,Times;"+
        "Verdana=Verdana,Geneva;",
      #content_style: "div {margin: 0; padding: 0px}, p { margin:0; padding:0; margin-block-start:0; margin-block-end:0; } ",
      fontsize_formats: "10px 12px 14px 16px 18px 24px 36px",
      lineheight_formats: "100% 130% 150% 160% 180% 200%",
      default_font_family: "Nanum Gothic",
      uploadimage: true, 
      uploadimage_hint_key: 'hint',
      uploadimage_hint: (@post.nil? ? 0 : @post.id), 
      #uploadimage_form_url: '/upload_image', #This option lets you specify a URL to where you want images to be uploaded when you call editor.uploadImages. 
      #uploadimage_form_url: '/',  #This option lets you specify a URL to where you want images to be uploaded when you call editor.uploadImages.
      images_upload_base_path: '/', # This option lets you specify a basepath to prepend to urls returned from the configured images_upload_url page. 
      #relative_urls : false, <== error 
      #remove_script_host : false, <== error 
      #images_upload_handler: "function(blobInfo, success, failure) { console.log(blobInfo);  }",
      # images_upload_handler: "function (blobInfo, success, failure) {
    # setTimeout(function () {
      # success('http://moxiecode.cachefly.net/tinymce/v9/images/logo.png');
    # }, 2000);
  # }",
      convert_urls: false,
      statusbar: false, 
      menubar: false, 
      style_formats: [
        {
          title: '이미지 왼쪽',
          selector: 'img',
          styles: {
            'float': 'left',
            'margin': '5px 10px 5px 0'
          }
        },
        {
          title: '이미지 오른쪽',
          selector: 'img',
          styles: {
            'float': 'right',
            'margin': '5px 0 5px 10px'
          }
        }
      ],
      style_formats_merge: true,
      content_css: [ '/css/tinymce_wysiwyg.css' ],
      setup:
        "function (ed) {
          ed.on('init', function (e) {
            //ed.execCommand('fontName', false, '나눔고딕');
            //ed.execCommand('fontSize', false, '16px');
          });
        }",
     media_url_resolver: 
      "function (data, resolve/*, reject*/) { 
        if (data.url.indexOf('youtube.com') !== -1 || data.url.indexOf('youtu.be') !== -1) {
          var youtube_id = get_youtube_id(data.url);
          var embedHtml = '<iframe src=\"https://www.youtube.com/embed/' + youtube_id +'\" width=\"640\" height=\"360\" frameborder=\"0\" allow=\"accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture\" allowfullscreen></iframe>';
          resolve({html: embedHtml});
        } else {
          resolve({html: ''});
        }
      }"
  end 

  def get_post(post_or_post_index, use_cached=true)
    return nil if post_or_post_index.nil?
    post_or_post_index.respond_to?(:post) ? 
      (use_cached ? 
        cached_post(post_or_post_index.post_id) : 
        post_or_post_index.post) :  # PostIndex => Post 
      post_or_post_index # Post 
  end 

  def get_post_for_listing(post_or_post_index, use_cached=true) # ignore content 
    return nil if post_or_post_index.nil?
    post_id = post_or_post_index.post_id
    post_or_post_index.respond_to?(:post) ? 
      (use_cached ? 
        cached_post_for_listing(post_id) : 
        post_for_listing(post_id)) :  # PostIndex => Post 
      post_or_post_index # Post 
  end 
    
  def cached_post(post_id)
    Rails.cache.fetch("posts/#{post_id}", expires_in: 10.minutes) do
      begin
        Post.find(post_id)
      rescue ActiveRecord::RecordNotFound => e 
        nil
      end
    end
  end 
  
  def cached_post_for_listing(post_id)
    Rails.cache.fetch("posts_for_list/#{post_id}", expires_in: 10.minutes) do
      begin
        Post.post_for_listing(post_id)
      rescue ActiveRecord::RecordNotFound => e 
        nil
      end
    end
  end 
  
  def post_for_listing(post_id)
    Post.post_for_listing(post_id)
  end 
  
  
  # 이미지추출
  def get_imgs(code, type)     
    return [] if code.nil?
    #src[ =]+[\'"]([^\'"]+.*(?:png|jpg|jpeg|gif))[\'"]
    #r = %r{src[ =]+[\'"]([^\'"]+.*(?:#{type}))[\'"]}i    
    r = %r{src[ =]+[\'"]([^\'"]+[.]*)[\'"]}i
    match = code.match(r)
    [ $1 ]
  end 
  
  # image url 추출 
  def get_upload_image(content, ext = 'png|jpg|jpeg|gif', upfiles = nil)
    # imgs = get_imgs(content, ext)    
    # return imgs[0] if (!upfiles && imgs[0])    
    # return upfiles.kind_of?(Array) ? upfiles[0] : upfiles

    upfile = upfiles.kind_of?(Array) ? upfiles[0] : upfiles
    if upfile.nil?
      imgs = get_imgs(content, ext)
      return imgs[0] if imgs&.length > 0
      #return imgs unless imgs.nil?
    end
    
    upfile
  end
  
  def ipstr(ip)
    return "" if ip.nil?
    ips = ip.split('.')
    return ip if ips.length < 4
    ips[1] = '♧';
    ips[2] = '♧';
    return ips.join(".")
  end
  
end
