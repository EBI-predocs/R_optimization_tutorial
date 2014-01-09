<?php
function show_scores() {
    # read array from file
    echo '<table><tr><th>Name</th><th>Speedup achieved</th></tr>';
    include("scores.php");

    # update array with post request
    if (isset($_POST["name"]) & isset($_POST["score"]))  {
        $name = htmlspecialchars($_POST["name"]);
        $score = htmlspecialchars($_POST["score"]);
        $scores[$name] = $score;
    }
    arsort($scores);

    # write array to file
    $handle = fopen("scores.php","w");
    $string = "<?php\n\$scores = " . var_export($scores,true) . ";\n?>";
    fwrite($handle,$string);
    fclose($handle);

    # display table
    foreach($scores as $key=>$value) {
        echo '<tr><td>' . $key . '</td><td>' . number_format($value,2) . ' x</td></tr>';
    }
    echo '</table>';

    //<?php show_scores(); 
}
?>


<!doctype html>
<!-- paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither/ -->
<!--[if lt IE 7]> <html class="no-js ie6 oldie" lang="en"> <![endif]-->
<!--[if IE 7]>    <html class="no-js ie7 oldie" lang="en"> <![endif]-->
<!--[if IE 8]>    <html class="no-js ie8 oldie" lang="en"> <![endif]-->
<!-- Consider adding an manifest.appcache: h5bp.com/d/Offline -->
<!--[if gt IE 8]><!--> <html class="no-js" lang="en"> <!--<![endif]-->
<head>
  <meta http-equiv="refresh" content="5">
  <meta charset="utf-8">

  <!-- Use the .htaccess and remove these lines to avoid edge case issues.
       More info: h5bp.com/b/378 -->
  <!-- <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"> -->   <!-- Not yet implemented -->

  <title>EMBL European Bioinformatics Institute</title>
  <meta name="description" content="EMBL-EBI"><!-- Describe what this page is about -->
  <meta name="keywords" content="bioinformatics, europe, institute"><!-- A few keywords that relate to the content of THIS PAGE (not the whol project) -->
  <meta name="author" content="EMBL-EBI"><!-- Your [project-name] here -->

  <!-- Mobile viewport optimized: j.mp/bplateviewport -->
  <meta name="viewport" content="width=device-width,initial-scale=1">

  <!-- Place favicon.ico and apple-touch-icon.png in the root directory: mathiasbynens.be/notes/touch-icons -->
  <link rel="shortcut icon" type="image/x-icon" href="/favicon.ico">

  <!-- CSS: implied media=all -->
  <!-- CSS concatenated and minified via ant build script-->
  <link rel="stylesheet" href="//www.ebi.ac.uk/web_guidelines/css/compliance/develop/boilerplate-style.css">  <link type="text/css" rel="stylesheet" href="//www.ebi.ac.uk/sites/ebi.ac.uk/files/css/css_pbm0lsQQJ7A7WCCIMgxLho6mI_kBNgznNUWmTWcnfoE.css" media="all" />
<link type="text/css" rel="stylesheet" href="//www.ebi.ac.uk/sites/ebi.ac.uk/files/css/css_6z9YLyvHu9hldkIQFm447bL5kIJd6aXLJo4jPwkIOuE.css" media="all" />
<link type="text/css" rel="stylesheet" href="//www.ebi.ac.uk/sites/ebi.ac.uk/files/css/css_lyC8Tmq5m_SQrlekAhI1rvsZIy_TEiOAiYrRtoQzF7I.css" media="all" />
<link type="text/css" rel="stylesheet" href="//www.ebi.ac.uk/sites/ebi.ac.uk/files/css/css_hJnkzdbYOVeTksHry-QpIWclJ4kZYBKc6kClzlcJOgU.css" media="all" />
  <link rel="stylesheet" href="//www.ebi.ac.uk/web_guidelines/css/compliance/mini/ebi-fluid-embl-noboilerplate.css" type="text/css" media="screen">  <!-- end CSS-->

  <!-- All JavaScript at the bottom, except for Modernizr / Respond.
       Modernizr enables HTML5 elements & feature detects; Respond is a polyfill for min/max-width CSS3 Media Queries
       For optimal performance, use a custom Modernizr build: www.modernizr.com/download/ -->

  <!-- Full build -->
  <!-- <script src="//www.ebi.ac.uk/web_guidelines/js/libs/modernizr.minified.2.1.6.js"></script> -->

  <!-- custom build (lacks most of the "advanced" HTML5 support -->
  <script src="//www.ebi.ac.uk/web_guidelines/js/libs/modernizr.custom.49274.js"></script>  <script type="text/javascript" src="//www.ebi.ac.uk/misc/jquery.js?v=1.4.4"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/misc/jquery.once.js?v=1.2"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/misc/drupal.js?mm0jbl"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/sites/ebi.ac.uk/modules/contrib/caption_filter/js/caption-filter.js?mm0jbl"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/sites/ebi.ac.uk/modules/contrib/lightbox2/js/auto_image_handling.js?mm0jbl"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/sites/ebi.ac.uk/modules/contrib/lightbox2/js/lightbox.js?1368126952"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/sites/ebi.ac.uk/modules/contrib/panels/js/panels.js?mm0jbl"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/sites/ebi.ac.uk/modules/custom/training_specific/training_specific.js?mm0jbl"></script>
<script type="text/javascript" src="//www.ebi.ac.uk/sites/ebi.ac.uk/libraries/tinymce/jscripts/tiny_mce/plugins/media/js/embed.js?mm0jbl"></script>
<script type="text/javascript">
<!--//--><![CDATA[//><!--
jQuery.extend(Drupal.settings, {"basePath":"\/","pathPrefix":"","ajaxPageState":{"theme":"ebicompliance","theme_token":"g6K-ZIFoPqkELodXen5LNONKejz_Z9DXg_UAb9D_Mc8","js":{"misc\/jquery.js":1,"misc\/jquery.once.js":1,"misc\/drupal.js":1,"sites\/ebi.ac.uk\/modules\/contrib\/caption_filter\/js\/caption-filter.js":1,"sites\/ebi.ac.uk\/modules\/contrib\/lightbox2\/js\/auto_image_handling.js":1,"sites\/ebi.ac.uk\/modules\/contrib\/lightbox2\/js\/lightbox.js":1,"sites\/ebi.ac.uk\/modules\/contrib\/panels\/js\/panels.js":1,"sites\/ebi.ac.uk\/modules\/custom\/training_specific\/training_specific.js":1,"sites\/ebi.ac.uk\/libraries\/tinymce\/jscripts\/tiny_mce\/plugins\/media\/js\/embed.js":1},"css":{"modules\/system\/system.base.css":1,"modules\/system\/system.menus.css":1,"modules\/system\/system.messages.css":1,"modules\/system\/system.theme.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/calendar\/css\/calendar_multiday.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/date\/date_api\/date.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/date\/date_popup\/themes\/datepicker.1.7.css":1,"modules\/field\/theme\/field.css":1,"modules\/node\/node.css":1,"modules\/search\/search.css":1,"modules\/user\/user.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/video_filter\/video_filter.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/views\/css\/views.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/caption_filter\/caption-filter.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/ctools\/css\/ctools.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/lightbox2\/css\/lightbox.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/panels\/css\/panels.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/shib_auth\/shib_auth.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/biblio\/biblio.css":1,"sites\/ebi.ac.uk\/modules\/contrib\/panels\/plugins\/layouts\/flexible\/flexible.css":1,"public:\/\/ctools\/css\/c37b9d5a6e614dd154d63ffa3ad123d8.css":1,"sites\/ebi.ac.uk\/themes\/custom\/ebicompliance\/css\/ebi-industry.css":1,"sites\/ebi.ac.uk\/themes\/custom\/ebicompliance\/css\/ebi-training.css":1,"sites\/ebi.ac.uk\/themes\/custom\/ebicompliance\/css\/calendar_multiday.css":1,"sites\/ebi.ac.uk\/themes\/custom\/ebicompliance\/css\/drupal-reset.css":1,"sites\/ebi.ac.uk\/themes\/custom\/ebicompliance\/css\/header-banners.css":1,"sites\/ebi.ac.uk\/themes\/custom\/ebicompliance\/css\/style.css":1}},"lightbox2":{"rtl":0,"file_path":"\/(\\w\\w\/)public:\/","default_image":"\/sites\/ebi.ac.uk\/modules\/contrib\/lightbox2\/images\/brokenimage.jpg","border_size":10,"font_color":"000","box_color":"fff","top_position":"","overlay_opacity":"0.8","overlay_color":"000","disable_close_click":1,"resize_sequence":0,"resize_speed":400,"fade_in_speed":400,"slide_down_speed":600,"use_alt_layout":0,"disable_resize":0,"disable_zoom":0,"force_show_nav":0,"show_caption":1,"loop_items":0,"node_link_text":"View Image Details","node_link_target":0,"image_count":"Image !current of !total","video_count":"Video !current of !total","page_count":"Page !current of !total","lite_press_x_close":"press \u003Ca href=\u0022#\u0022 onclick=\u0022hideLightbox(); return FALSE;\u0022\u003E\u003Ckbd\u003Ex\u003C\/kbd\u003E\u003C\/a\u003E to close","download_link_text":"","enable_login":false,"enable_contact":false,"keys_close":"c x 27","keys_previous":"p 37","keys_next":"n 39","keys_zoom":"z","keys_play_pause":"32","display_image_size":"original","image_node_sizes":"()","trigger_lightbox_classes":"","trigger_lightbox_group_classes":"","trigger_slideshow_classes":"","trigger_lightframe_classes":"","trigger_lightframe_group_classes":"","custom_class_handler":"lightbox_ungrouped","custom_trigger_classes":"img.lightbox-triggerclass","disable_for_gallery_lists":1,"disable_for_acidfree_gallery_lists":true,"enable_acidfree_videos":true,"slideshow_interval":5000,"slideshow_automatic_start":true,"slideshow_automatic_exit":true,"show_play_pause":true,"pause_on_next_click":false,"pause_on_previous_click":true,"loop_slides":false,"iframe_width":600,"iframe_height":400,"iframe_border":1,"enable_video":0},"ogContext":{"groupType":"node","gid":"494"}});
//--><!]]>
</script>

<? include('scripts.php') ?>
</head>

<body class="level1 html front not-logged-in no-sidebars page-node page-node- page-node-5956 node-type-panel og-context og-context-node og-context-node-494 role-anonymous-user user-0 page-home section-home subsection-overview domain-www">

<!-- page_top -->
    <!-- page -->
      <div id="skip-to">
        <ul>
            <li><a href="#content">Skip to main content</a></li>
            <li><a href="#local-nav">Skip to local navigation</a></li>
            <li><a href="#global-nav">Skip to EBI global navigation menu</a></li>
            <li><a href="#global-nav-expanded">Skip to expanded EBI global navigation menu (includes all sub-sections)</a></li>
        </ul>
    </div>


  <div id="wrapper" class="container_24 page">
    <header>
        <div id="global-masthead" class="masthead grid_24">
      <!--This has to be one line and no newline characters-->
            <a href="/" title="Go to the EMBL-EBI homepage"><img src="//www.ebi.ac.uk/web_guidelines/images/logos/EMBL-EBI/EMBL_EBI_Logo_white.png" alt="EMBL European Bioinformatics Institute"></a>
            
            <nav>
        <ul id="global_nav"><li class="menu-3273 menu-services first" id="services"><a href="/services" title="">Services</a></li>
<li class="menu-3274 menu-research" id="research"><a href="/research" title="">Research</a></li>
<li class="menu-3248 menu-training active" id="training"><a href="//www.ebi.ac.uk/training" title="">Training</a></li>
<li class="menu-3275 menu-industry" id="industry"><a href="/industry" title="">Industry</a></li>
<li class="menu-3272 menu-about-us last" id="about-us"><a href="/about" title="">About us</a></li>
</ul>           </nav>
            
        </div>
        
        <div id="local-masthead" class="masthead grid_24 nomenu">
                  <div class="grid_24" id="local-title">
          
  <!--
-->
  
  <div class="content">
  <? include('workshop2013/inc/header.php'); ?> 
  </div>

            </div>
      
                        
            
      
        </div>
    </header>

    <div id="content" role="main" class="grid_24 clearfix">
        
    <!-- Suggested layout containers -->
       
          
    
        
        <section class="grid_24">
                                                        
              
    
  <div class="content">
    <div id="node-5956" class="node node-panel clearfix" about="/home" typeof="sioc:Item foaf:Document">

  
      
  
  <div class="content">
    <div class="panels-flexible-column panels-flexible-column-service-main grid_16 alpha panels-flexible-column-first">
<div class="panels-flexible-row panels-flexible-row-service-4 panels-flexible-row-first clearfix ">
<div class="panels-flexible-region panels-flexible-region-service-top ">



<?php show_scores(); ?>


</div>
</div>
<div class="panels-flexible-row panels-flexible-row-service-main-row clearfix">
<div class="panels-flexible-region panels-flexible-region-service-left grid_8 alpha panels-flexible-region-first ">
</div>
<div class="panels-flexible-region panels-flexible-region-service-center grid_8">
</div>
<div class="panels-flexible-region panels-flexible-region-service-right grid_8 omega panels-flexible-region-last ">
</div>
</div>
<div class="panels-flexible-row panels-flexible-row-service-2 panels-flexible-row-last clearfix ">
<div class="panels-flexible-region panels-flexible-region-service-bottom ">
</div>
</div>
</div>
<div class="panels-flexible-column panels-flexible-column-service-1 grid_8 omega panels-flexible-column-last ">
<div class="panels-flexible-region panels-flexible-region-service-sidebar ">
<div class="shortcuts transparent"><div class="panel-pane pane-custom pane-1 clearfix" >
  
        <h3 class="pane-title">Popular</h3>
    
  
<!--   <div class="pane-content"> -->
    
<ul class="split">
 <li><a href="//www.ebi.ac.uk/services" class='icon icon-generic' data-icon='('>Services</a></li>
 <li><a href="//www.ebi.ac.uk/research" class='icon icon-generic' data-icon=')'>Research</a></li>
 <li><a href="//www.ebi.ac.uk/training" class='icon icon-generic' data-icon='f'>Training</a></li>
 <li><a href="//www.ebi.ac.uk/about/news" class='icon icon-generic' data-icon='N'>News</a></li>
</ul>
<ul class="split">
 <li><a href="//www.ebi.ac.uk/about/jobs" class='icon icon-generic' data-icon='c'>Jobs</a></li>
 <li><a href="//www.ebi.ac.uk/about/travel" class='icon icon-generic' data-icon=']'>Visit us</a></li>
 <li><a href="http://www.embl.de/aboutus/index.html" class='icon icon-generic icon-c8' data-icon='&'>EMBL</a></li>
 <li><a href="//www.ebi.ac.uk/about/contact" class='icon icon-generic' data-icon='C'>Contacts</a></li>
</ul>
<!--   </div> -->

  
  </div>
</div><div class="shortcuts transparent"><div class="panel-pane pane-views pane-training-eve clearfix" >
  
    <div class="view view-training-eve view-id-training_eve view-display-id-block_1 view-dom-id-928c8beb63f13361d3c470d74aaf0456">
        
      <div class="view-footer">
<!--      
<p>See all <a href="//www.ebi.ac.uk/training/handson/">courses and conferences</a><br />
<a href="//www.ebi.ac.uk/about/events">See other events at EMBL-EBI</a></p>
    </div>
  -->
  
</div><!--   </div> -->

  
  </div>
</div></div>
</div>
  </div>

  
  
</div>
  </div>

                                        
                                            
        </section> 

        
            <!-- End suggested layout containers -->
            
    </div>
    
    <footer>

    <!-- Optional local footer (insert citation / project-specific copyright / etc here -->
    <div id="local-footer" class="grid_24 clearfix">
            </div>
        <!-- End optional local footer -->
        
        <div id="global-footer" class="grid_24">
                        
            <nav id="global-nav-expanded">
                
                <div class="grid_4 alpha">
                    <h3 class="embl-ebi"><a href="//www.ebi.ac.uk/" title="EMBL-EBI">EMBL-EBI</a></h3>
                </div>
                
                <div class="grid_4">
                    <h3 class="services"><a href="//www.ebi.ac.uk/services">Services</a></h3>
                </div>
                
                <div class="grid_4">
                    <h3 class="research"><a href="//www.ebi.ac.uk/research">Research</a></h3>
                </div>
                
                <div class="grid_4">
                    <h3 class="training"><a href="//www.ebi.ac.uk/training">Training</a></h3>
                </div>
                
                <div class="grid_4">
                    <h3 class="industry"><a href="//www.ebi.ac.uk/industry">Industry</a></h3>
                </div>
                
                <div class="grid_4 omega">
                    <h3 class="about"><a href="//www.ebi.ac.uk/about">About us</a></h3>
                </div>

            </nav>
        
            <section id="ebi-footer-meta">
                <p class="address">EMBL-EBI, Wellcome Trust Genome Campus, Hinxton, Cambridgeshire, CB10 1SD, UK &nbsp; &nbsp; +44 (0)1223 49 44 44</p>
                <p class="legal">Copyright &copy; EMBL-EBI 2013 | EBI is an outstation of the <a href="http://www.embl.org">European Molecular Biology Laboratory</a> | <a href="/about/privacy">Privacy</a> | <a href="/about/cookies">Cookies</a> | <a href="/about/terms-of-use">Terms of use</a></p>    
            </section>

        </div>
        
    </footer>
  </div> <!--! end of #wrapper -->


  <!-- JavaScript at the bottom for fast page loading -->

  <!-- Grab Google CDN's jQuery, with a protocol relative URL; fall back to local if offline -->
  <!--
  <script src="//ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"></script>
  <script>window.jQuery || document.write('<script src="../js/libs/jquery-1.6.2.min.js"><\/script>')</script>
  -->


  <!-- Your custom JavaScript file scan go here... change names accordingly -->
  <!--
  <script defer="defer" src="//www.ebi.ac.uk/web_guidelines/js/plugins.js"></script>
  <script defer="defer" src="//www.ebi.ac.uk/web_guidelines/js/script.js"></script>
  -->
  <script defer="defer" src="//www.ebi.ac.uk/web_guidelines/js/cookiebanner.js"></script>  
  <script defer="defer" src="//www.ebi.ac.uk/web_guidelines/js/foot.js"></script>
  <!-- end scripts-->

  <!-- Google Analytics details... -->      
  <!-- Change UA-XXXXX-X to be your site's ID -->
  <!--
  <script>
    window._gaq = [['_setAccount','UAXXXXXXXX1'],['_trackPageview'],['_trackPageLoadTime']];
    Modernizr.load({
      load: ('https:' == location.protocol ? '//ssl' : '//www') + '.google-analytics.com/ga.js'
    });
  </script>
  -->


  <!-- Prompt IE 6 users to install Chrome Frame. Remove this if you want to support IE 6.
       chromium.org/developers/how-tos/chrome-frame-getting-started -->
  <!--[if lt IE 7 ]>
    <script src="//ajax.googleapis.com/ajax/libs/chrome-frame/1.0.3/CFInstall.min.js"></script>
    <script>window.attachEvent('onload',function(){CFInstall.check({mode:'overlay'})})</script>
  <![endif]-->

    
  
<!-- page_bottom -->
    
</body>
</html>

