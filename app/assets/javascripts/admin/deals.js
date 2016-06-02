/* globals $ */

'use strict';

$(document).ready(function() {
  var $publishable_containers = $('[data-behaviour = publishable]');
  var $publishable_links = $publishable_containers.find('[data-behaviour = publish]');
  var $unpublishable_containers = $('[data-behaviour = unpublishable]');
  var $unpublishable_links = $unpublishable_containers.find('[data-behaviour = unpublish]');
  var $modal_container = $('[data-behaviour = modal]');
  var $modal_body = $modal_container.find('[data-behaviour = modal-body]');
  var $modal_title = $modal_container.find('[data-behaviour = modal-title]');

  function HideCurrentContainer($container) {
    $container.addClass('hidden');
  }

  function ShowSiblingContainer($container) {
    $container.siblings('div').removeClass('hidden');
  }

  function UpdateBlocks(event, data) {
    if (data.status === 'success') {
      var $parent = $(event.currentTarget).parent('div');
      HideCurrentContainer($parent);
      ShowSiblingContainer($parent);
    } else if (data.status === 'failure') {
      $modal_body.empty();
      $modal_body.addClass("alert alert-dismissible alert-danger");
      var errors = data.errors;
      $modal_title.text("'" + data.deal_title + "'   cannot be published because");
      $.each(errors, function(index, value) {
        var $paraElement = $('<p>');
        $paraElement.text(index + 1 + '  :  ' + value);
        $modal_body.append($paraElement);
      });
      $modal_container.modal();
    }
  }

  $publishable_links.on('ajax:success', function(event, data) {
    UpdateBlocks(event, data);
  });

  $unpublishable_links.on('ajax:success', function(event, data) {
    UpdateBlocks(event, data);
  });
});