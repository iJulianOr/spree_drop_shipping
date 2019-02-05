// Placeholder manifest file.
// the installer will append this file to the app vendored assets here: vendor/assets/javascripts/spree/backend/all.js'
var lines = [];

function reload_stock_items(id){
    var form = '#stock-socios';
    var line = '#spree_product_' + id;
    window.clearTimeout($(form).data("timeout"));
    $(line).addClass('highlight-stock');
    $('.stock-info').addClass('active');
    lines.push(line);
    $(form).data("timeout", setTimeout(function(){
      $(form).submit();
      lines.forEach(function(li){
            $('.stock-info').removeClass('active');
            $(li).removeClass('highlight-stock');
        });
        $(window).scrollTop(0);
        $('#flash').delay(500).fadeIn('normal', function() {
            $(this).delay(2500).fadeOut();
        });
        lines.length = 0;
    }, 3000));
}

