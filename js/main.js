$('#to-top').click(function (e) {
    e.preventDefault();
    $("html, body").animate({scrollTop: 0}, 400, "swing");
    return false;
});