$ ->
    #-----------------------------------------------------------------------------------
    #	SLIDER
    #-----------------------------------------------------------------------------------
    
    $('.fullwidthbanner').unslider
        delay: 3000
        keys: true
        dots: true
        fluid: true
    
    $('.banner').unslider
        delay: 3000
        keys: true
        dots: true
        fluid: true
        
    #-----------------------------------------------------------------------------------
    #	ELLIPSIS
    #-----------------------------------------------------------------------------------

    $('.post-content p').ellipsis
        live: true
        
    #-----------------------------------------------------------------------------------
    #	TOGGLE
    #-----------------------------------------------------------------------------------
    
    #Hide the tooglebox when page load
    $(".togglebox").hide
    
    #slide up and down when click over heading 2
    $("h4").click ->
        #slide toggle effect set to slow you can set it to fast too.
        $(this).toggleClass("active").next(".togglebox").slideToggle "slow"
        return true
        
    #-----------------------------------------------------------------------------------
    #	IMAGE HOVER
    #-----------------------------------------------------------------------------------		

    $('.items li a, .item a, .featured a').prepend '<span class="more"></span>'

    $('.item, .items li, .featured').mouseenter ->
        $(this).children('a').children('span').fadeIn 300
    
    $('.item, .items li, .featured').mouseleave ->
        $(this).children('a').children('span').fadeOut 200
        
    #-----------------------------------------------------------------------------------
    #	BUTTON HOVER
    #-----------------------------------------------------------------------------------

    $(".social li a").css "opacity", "1.0"
    $(".social li a").hover (
        -> $(this).stop().animate { opacity: 0.75 }, "fast"
        -> $(this).stop().animate { opacity: 1.0 }, "fast"  
    )
    
    #-----------------------------------------------------------------------------------
    #	VIDEO
    #-----------------------------------------------------------------------------------

    $('.media, .featured').fitVids()

    #-----------------------------------------------------------------------------------
    #	SELECTNAV
    #-----------------------------------------------------------------------------------

    selectnav 'tiny',
    	label: '--- Navigation --- '
    	indent: '-'