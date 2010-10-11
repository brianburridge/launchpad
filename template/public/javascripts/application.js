jQuery(document).ready(function() {


  jQuery('a[data-post=true]').click(function () { 
		datareplace = jQuery(this).attr('data-replace');
		jQuery.post(jQuery(this).attr('href'), function(html) {
			jQuery(datareplace).replaceWith(html);
		});
    return false;  
  });

  jQuery('a[data-get=true]').click(function () { 
		datareplace = jQuery(this).attr('data-replace');
		jQuery.get(jQuery(this).attr('href'), function(html) {
			jQuery(datareplace).replaceWith(html);
		});
    return false;  
  });


})

jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) {xhr.setRequestHeader("Accept", "text/javascript")}
})
