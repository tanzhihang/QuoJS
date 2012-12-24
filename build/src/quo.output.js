/*
  QuoJS 2.2.1
  (c) 2011, 2012 Javi Jiménez Villar (@soyjavi)
  http://quojs.tapquo.com
*/

(function($$) {
  var _createElement;
  $$.fn.text = function(value) {
    if (value || $$.toType(value) === "number") {
      return this.each(function() {
        return this.textContent = value;
      });
    } else {
      return this[0].textContent;
    }
  };
  $$.fn.html = function(value) {
    var type;
    type = $$.toType(value);
    if (value || type === "number" || type === "null") {
      return this.each(function() {
        if (type === "string" || type === "number" || type === "null") {
          return this.innerHTML = value;
        } else {
          this.innerHTML = null;
          return this.appendChild(value);
        }
      });
    } else {
      return this[0].innerHTML;
    }
  };
  $$.fn.append = function(value) {
    return this.each(function() {
      if ($$.toType(value) === "string") {
        if (value) {
          return this.appendChild(_createElement(value));
        }
      } else {
        return this.insertBefore(value);
      }
    });
  };
  $$.fn.prepend = function(value) {
    return this.each(function() {
      var parent;
      if ($$.toType(value) === "string") {
        return this.innerHTML = value + this.innerHTML;
      } else {
        parent = this.parentNode;
        return parent.insertBefore(value, parent.firstChild);
      }
    });
  };
  $$.fn.replaceWith = function(content) {
    return this.each(function() {
      var parent;
      if ($$.toType(content) === "string") {
        content = _createElement(content);
      }
      parent = this.parentNode;
      if (parent) {
        parent.insertBefore(content, this);
      }
      return $$(this).remove();
    });
  };
  $$.fn.empty = function() {
    return this.each(function() {
      this.innerHTML = null;
    });
  };
  _createElement = function(content) {
    var div;
    div = document.createElement("div");
    div.innerHTML = content;
    return div;
  };
})(Quo);