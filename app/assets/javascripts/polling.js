/* globals $ */

'use strict';

$(document).ready(function() {
  setTimeout(countUpdater, 10000);
});

function countUpdater() {
  var $countContainer = $('[data-behaviour = count-container]');
  var target = $countContainer.data('url');
  $.ajax({  
    url: target,
    dataType: "json",
    success: function(data){
      var $quantityRemaining = $('[data-behaviour = quantity-remaining]');
      var $quantitySold = $('[data-behaviour = quantity-sold]');
      var $dealStatus = $('[data-behaviour = deal-status]');
      var $spanElement = $('<span>').addClass('label label-danger');
      if(data.expired) {
        $spanElement.text('Expired');
      } else if (data.sold_out) {
        $spanElement.text('Sold');
      } else {
        $quantityRemaining.text(data.quantity_available);
        $quantitySold.text(data.quantity_sold);
      }
      if (data.expired || data.sold_out) {
        $dealStatus.empty().append($spanElement);
        $quantityRemaining.closest('[data-behaviour=remaining-quantity]').remove();
        $quantitySold.closest('[data-behaviour=sold-quantity]').remove();
      }
      setTimeout(countUpdater, 10000);
    }
  });
}