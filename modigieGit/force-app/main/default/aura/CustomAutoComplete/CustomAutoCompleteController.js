({
    doinit : function(component, event, helper) {
        var url_String = window.location.href.toString();
        if (url_String.includes("visualforce.com") || url_String.includes("visual.force.com")) {
            component.set("v.sfdcClassic", true);
        }
        const getOption = component.get("v.allOption");
        const selectedOption = component.get("v.selectedOption");
        console.log(selectedOption ,' in getOption-->',getOption);
        for(const i_temp of getOption){
            if(i_temp.apiname == selectedOption){
                component.set("v.inputValue", i_temp.label);
                component.set("v.openDropDown", false);
            }
        }
    },
    searchHandler : function (component, event, helper) {
        let searchString = event.target.value;
        searchString = searchString.toUpperCase();
        if (searchString.length > 0) {
            const getOption = component.get("v.allOption");
            console.log('All Option passed from parent - ', getOption);
            const results = [];
            for(const i_temp of getOption){
                if(i_temp.label.toUpperCase().includes(searchString)){
                    console.log("matched");
                    results.push(i_temp);
                }
            }
            console.log('Result set ->', results);
            component.set("v.results", results);
            if(results.length > 0){
                component.set("v.openDropDown", true);
            }
        } else{
            component.set("v.results", []);
            component.set("v.openDropDown", false);
        }
    },

    optionClickHandler : function (component, event, helper) {
        console.log('event-->', event);
        const selectedId = event.target.closest('li').dataset.id;
        const selectedValue = event.target.closest('li').dataset.value;
        console.log(selectedId,'-------',selectedValue);
        component.set("v.inputValue", selectedValue);
        component.set("v.openDropDown", false);
        component.set("v.selectedOption", selectedId);   
        var applicationEvent = $A.get("e.c:modigieRuleSelectedField");
        applicationEvent.fire();
    },

    clearOption : function (component, event, helper) {
        component.set("v.results", []);
        component.set("v.openDropDown", false);
        component.set("v.inputValue", "");
        component.set("v.selectedOption", "");
        var applicationEvent = $A.get("e.c:modigieRuleSelectedField");
        applicationEvent.fire();
    },
})