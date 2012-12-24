/*
    QuoJS 2.2.0
    (c) 2011, 2012 Javi Jiménez Villar (@soyjavi)
    http://quojs.tapquo.com
*/

(function($$) {
  var ELEMENT_ID, EVENTS_DESKTOP, EVENT_METHODS, HANDLERS, _createProxy, _createProxyCallback, _environmentEvent, _findHandlers, _getElementId, _subscribe, _unsubscribe;
  ELEMENT_ID = 1;
  HANDLERS = {};
  EVENT_METHODS = {
    preventDefault: "isDefaultPrevented",
    stopImmediatePropagation: "isImmediatePropagationStopped",
    stopPropagation: "isPropagationStopped"
  };
  EVENTS_DESKTOP = {
    touchstart: "mousedown",
    touchmove: "mousemove",
    touchend: "mouseup",
    tap: "click",
    doubletap: "dblclick",
    orientationchange: "resize"
  };
  $$.Event = function(type, touch) {
    var event, property;
    event = document.createEvent("Events");
    event.initEvent(type, true, true, null, null, null, null, null, null, null, null, null, null, null, null);
    if (touch) {
      for (property in touch) {
        event[property] = touch[property];
      }
    }
    return event;
  };
  $$.fn.bind = function(event, callback) {
    return this.each(function() {
      _subscribe(this, event, callback);
    });
  };
  $$.fn.unbind = function(event, callback) {
    return this.each(function() {
      _unsubscribe(this, event, callback);
    });
  };
  $$.fn.delegate = function(selector, event, callback) {
    return this.each(function(i, element) {
      _subscribe(element, event, callback, selector, function(fn) {
        return function(e) {
          var evt, match;
          match = $$(e.target).closest(selector, element).get(0);
          if (match) {
            evt = $$.extend(_createProxy(e), {
              currentTarget: match,
              liveFired: element
            });
            return fn.apply(match, [evt].concat([].slice.call(arguments, 1)));
          }
        };
      });
    });
  };
  $$.fn.undelegate = function(selector, event, callback) {
    return this.each(function() {
      _unsubscribe(this, event, callback, selector);
    });
  };
  $$.fn.trigger = function(event, touch) {
    if ($$.toType(event) === "string") {
      event = $$.Event(event, touch);
    }
    return this.each(function() {
      this.dispatchEvent(event);
    });
  };
  $$.fn.addEvent = function(element, event_name, callback) {
    if (element.addEventListener) {
      return element.addEventListener(event_name, callback, false);
    } else if (element.attachEvent) {
      return element.attachEvent("on" + event_name, callback);
    } else {
      return element["on" + event_name] = callback;
    }
  };
  $$.fn.removeEvent = function(element, event_name, callback) {
    if (element.removeEventListener) {
      return element.removeEventListener(event_name, callback, false);
    } else if (element.detachEvent) {
      return element.detachEvent("on" + event_name, callback);
    } else {
      return element["on" + event_name] = null;
    }
  };
  _subscribe = function(element, event, callback, selector, delegate_callback) {
    var delegate, element_handlers, element_id, handler;
    event = _environmentEvent(event);
    element_id = _getElementId(element);
    element_handlers = HANDLERS[element_id] || (HANDLERS[element_id] = []);
    delegate = delegate_callback && delegate_callback(callback, event);
    handler = {
      event: event,
      callback: callback,
      selector: selector,
      proxy: _createProxyCallback(delegate, callback, element),
      delegate: delegate,
      index: element_handlers.length
    };
    element_handlers.push(handler);
    return $$.fn.addEvent(element, handler.event, handler.proxy);
  };
  _unsubscribe = function(element, event, callback, selector) {
    var element_id;
    event = _environmentEvent(event);
    element_id = _getElementId(element);
    return _findHandlers(element_id, event, callback, selector).forEach(function(handler) {
      delete HANDLERS[element_id][handler.index];
      return $$.fn.removeEvent(element, handler.event, handler.proxy);
    });
  };
  _getElementId = function(element) {
    return element._id || (element._id = ELEMENT_ID++);
  };
  _environmentEvent = function(event) {
    var environment_event;
    environment_event = ($$.isMobile() ? event : EVENTS_DESKTOP[event]);
    return environment_event || event;
  };
  _createProxyCallback = function(delegate, callback, element) {
    var proxy;
    callback = delegate || callback;
    proxy = function(event) {
      var result;
      result = callback.apply(element, [event].concat(event.data));
      if (result === false) {
        event.preventDefault();
      }
      return result;
    };
    return proxy;
  };
  _findHandlers = function(element_id, event, fn, selector) {
    return (HANDLERS[element_id] || []).filter(function(handler) {
      return handler && (!event || handler.event === event) && (!fn || handler.fn === fn) && (!selector || handler.selector === selector);
    });
  };
  _createProxy = function(event) {
    var proxy;
    proxy = $$.extend({
      originalEvent: event
    }, event);
    $$.each(EVENT_METHODS, function(name, method) {
      proxy[name] = function() {
        this[method] = function() {
          return true;
        };
        return event[name].apply(event, arguments);
      };
      return proxy[method] = function() {
        return false;
      };
    });
    return proxy;
  };
})(Quo);