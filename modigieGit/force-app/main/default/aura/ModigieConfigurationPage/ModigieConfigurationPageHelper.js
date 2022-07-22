({
	hideToast : function(component, calledFrom) {
		if(calledFrom == 'handleToast'){
			component.set("v.configurationToast", false);
		}
		else if(calledFrom == 'handleErrorToast'){
			component.set("v.configurationErrorToast", false);
		}
	}
})