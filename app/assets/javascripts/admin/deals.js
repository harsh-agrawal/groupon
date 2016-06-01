/* globals $ */

'use strict';

$(document).ready(function() {
  var $publishable_containers = $('[data-behaviour = publishable]');
  var $unpublishable_containers = $('[data-behaviour = unpublishable]');
  var $modal_container = $('[data-behaviour = modal_for_publish]');
  var $modal_body = $modal_container.find('[data-behaviour = modal-body]');
  var $modal_title = $modal_container.find('[data-behaviour = modal-title]');

  $publishable_containers.on('ajax:success', function(event, data) {

    if (data.status == 'success') {
      $(this).siblings('[data-behaviour = unpublishable]').removeClass('hidden').addClass('show');
      $(this).removeClass('show').addClass('hidden');
    } else if (data.status == 'failure') {
      $modal_body.empty();
      var errors = data.errors;
      $modal_title.text("'" + data.deal_title + "'   cannot be published because");
      $.each(errors, function(index, value) {
        var $paraElement = $('<p>');
        $paraElement.text(index + 1 + '  :  ' + value);
        $modal_body.append($paraElement);
      });
      $modal_container.modal();
    }
  });



  $unpublishable_containers.on('ajax:success', function(event, data) {
    if (data.status == 'failure') {
      $modal_body.empty();
      var errors = data.errors;
      $modal_title.text("'" + data.deal_title + "'   cannot be published because");
      $.each(errors, function(index, value) {
        var $paraElement = $('<p>');
        $paraElement.text(index + 1 + '  :  ' + value);
        $modal_body.append($paraElement);
      });
      $modal_container.modal();
    } else {
      $(this).siblings('[data-behaviour = publishable]').removeClass('hidden').addClass('show');
      $(this).removeClass('show').addClass('hidden');
    }
  });
});