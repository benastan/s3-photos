function app() {
  var images;
  images = Array.prototype.slice.apply(document.querySelectorAll('[data-src]'))
  
  function callback() {
    var target, src, image;
    target = images.shift();
    src = target.dataset.src;
    
    image = new Image();
    image.onload = function() {
      image.src = src;
      callback();
    };
    
    image.src = src;
  }
  
  callback();
}

app();