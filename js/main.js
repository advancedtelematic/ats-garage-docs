$.fn.visibleHeight = function() {
    var elBottom, elTop, scrollBot, scrollTop, visibleBottom, visibleTop;
    scrollTop = $(window).scrollTop();
    scrollBot = scrollTop + $(window).height();
    elTop = this.offset().top;
    elBottom = elTop + this.outerHeight();
    visibleTop = elTop < scrollTop ? scrollTop : elTop;
    visibleBottom = elBottom > scrollBot ? scrollBot : elBottom;
    return visibleBottom - visibleTop
}

function setNavigationHeight() {
	var windowHeight = $(window).height();
	var navHeight = $('.navbar.navbar-default').height();
	var visibleFooterHeight = Math.max(0, $("body > footer").visibleHeight());
	$('#navigation').height(windowHeight - navHeight - visibleFooterHeight);
}

function setNavbarHeight() {
	if($('#navbar-menu').hasClass('in')) {
		var windowHeight = $(window).height();
		var navHeight = $('.navbar.navbar-default').height();
		$('#navbar-menu').css('cssText', 'height:' + (windowHeight - navHeight) + 'px !important');
	}
}

$(document).ready(function() {
	setNavigationHeight();

	$('.to-top-small-logo-container').click(function (e) {
	    e.preventDefault();
	    $("html, body").animate({scrollTop: 0}, 400, "swing");
	    return false;
	});

	$('#navbar-menu').on('shown.bs.collapse', function (e) {
		setNavbarHeight();
	});

	$('#navbar-menu').on('hidden.bs.collapse', function (e) {
		$(this).css('cssText', 'height: 0 !important');
	});
});

$(window).resize(function() {
	setNavigationHeight();
	setNavbarHeight();
});

$(window).scroll(function() {
	setNavigationHeight();
});