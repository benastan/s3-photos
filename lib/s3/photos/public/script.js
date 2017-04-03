function get(url, _callback) {
  var xhr;
  
  xhr = new XMLHttpRequest();
  
  function callback() {
    _callback(xhr.responseText);
  }
  
  xhr.addEventListener('load', callback);
  xhr.open('GET', url);
  xhr.setRequestHeader('x-requested-with', 'XMLHttpRequest');
  xhr.send();
}

function _each(collection, callback) {
  var _collection, item;
  
  _collection = _slice(collection);
  
  while (item = _collection.shift()) {
    callback(item);
  }
}

function _slice(arr) {
  return Array.prototype.slice.apply(arr);
}

function loadImages() {
  var images, totalWorkers;
  
  totalWorkers = 4;
  images = _slice(document.querySelectorAll('[data-src]'));
  
  function worker() {
    var target, src, image;
    target = images.shift();
    
    if (!target) return;
    src = target.dataset.src;
    
    image = new Image();
    image.onload = function() {
      target.src = src;
      worker();
    };
    
    image.src = src;
  }
  
  for (var i = 0; i < totalWorkers; i++) {
    setTimeout(worker, i * 25);
  }
}


function bindLoaders() {
  _each(document.querySelectorAll('[data-load]'), function(link) {
    link.addEventListener('click', function() {
      var el, url;
    
      el = this;
      url = el.dataset.load;
      
      get(url, function(html) {
        content.innerHTML = html;
        history.pushState({}, '', url);
        setTimeout(loadImages);
      });
    });
  });
}

function initializeModal() {
  _each(document.querySelectorAll('[data-modal-src]'), function(modalSource) {
    modalSource.addEventListener('click', function() {
      modalTitle.innerHTML = modalSource.dataset.key;
      modalPopoutImage.href = modalSource.dataset.modalSrc;
      
      modalImage.onload = function() {
        modal.style.display = 'block';
      };
      
      modalImage.src = modalSource.dataset.modalSrc;
    })
  });
  
  closeModal.addEventListener('click', function() {
    modal.style.display = 'none';
  });
}

function main() {
  loadImages();
  initializeModal();
  bindLoaders();
}

main();