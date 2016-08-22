
var WBNativeJSBridge = {
    callbacksCount : 1,
    callbacks : {},
    
    
    // Automatically called by native layer when a result is available
    resultForCallback : function resultForCallback(callbackId, resultArray) {
        try {
            var callback = WBNativeJSBridge.callbacks[callbackId];
            if (!callback) return;
            
            callback.apply(null,resultArray);
        } catch(e) {alert(e)}
    },
    
    // Use this in javascript to request native objective-c code
    // functionName : string (I think the name is explicit :p)
    // args : array of arguments
    // callback : function with n-arguments that is going to be called when the native code returned
    call : function call(functionName, args, callback) {
        
        var hasCallback = callback && typeof callback == "function";
        var callbackId = hasCallback ? WBNativeJSBridge.callbacksCount++ : 0;
//        var PROTOCOL_SCHEME = "wbweb";
        
        if (hasCallback)
            WBNativeJSBridge.callbacks[callbackId] = callback;
        
        var iframe = document.createElement("IFRAME");
        iframe.setAttribute("src", "wbweb" + ":" + functionName + ":" + callbackId+ ":" + encodeURIComponent(JSON.stringify(args)));
        document.documentElement.appendChild(iframe);
        iframe.parentNode.removeChild(iframe);
        iframe = null;
        
        
    }
    
};


