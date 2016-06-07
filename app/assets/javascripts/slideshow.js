/* globals $ */

'use strict';
$(document).ready(function() {
  var $container = $('[data-behaviour=slideshow]');
    $container.cycle({
      fx: 'fade',
      pause:  1,
      random:  1,
      speed:   300, 
      timeout: 3000, 
      next:   '#s3'
  });
});