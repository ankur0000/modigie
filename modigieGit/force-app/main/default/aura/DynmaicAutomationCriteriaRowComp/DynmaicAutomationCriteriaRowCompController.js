({
    doinit : function(component, event, helper) {
        var action = component.get('c.getObjectFieldInfo');
        action.setCallback(this, function (response) {
            console.log('Result -->> ', response.getReturnValue());
            var result = response.getReturnValue();
            console.log('result[0]' , result[0]);
            component.set('v.fieldsLabel',result[0]);
            component.set('v.fieldsDataType',result[1]);
            var fields = [];
            for (var key in result[0]) {
                fields.push({label:result[0][key], apiname:key});
            }
            console.log('fields -->> ' , fields);
            component.set('v.fields', fields);
            //console.log('Result -->> ', JSON.parse(response.getReturnValue()));
        })
        //  $A.enqueueAction(action);
        
        component.set('v.picklistValues', new Object());
        component.set('v.oldSelectedPicklistValues', new Object());
        // var selectedField = component.get('v.selectedField');
        // console.log('component.get(v.selectedField)', selectedField);
        // var dataTypeObj = component.get('v.fieldsDataType');
        // console.log('Datatype -->> ', dataTypeObj[selectedField]);
        // var selectedFieldDataType = dataTypeObj[selectedField];
        
        // component.set('v.selectedFieldDataType', selectedFieldDataType);
        
        //var a = component.get('c.handleSelectFieldChange');
    //    $A.enqueueAction(a);
        var selectedField = component.get('v.selectedField');
        console.log('component.get(v.selectedField)', selectedField);
        var dataTypeObj = component.get('v.fieldsDataType');
        console.log('Datatype -->> ', dataTypeObj[selectedField]);
        var selectedFieldDataType = dataTypeObj[selectedField];
        component.set('v.selectedFieldDataType', selectedFieldDataType);

        if(selectedFieldDataType == 'PICKLIST'){
            var action3 = component.get('c.getPicklistvalues');
            action3.setParams({objectName : component.get('v.objectName'),
                                field_apiname : selectedField});
            action3.setCallback(this, function (response) {
            console.log('Result PICKLIST -->> ', response.getReturnValue());
            var picklistValuesObj = new Object();
            picklistValuesObj[selectedField] = response.getReturnValue();
            
            var availableOptions = [];
            
            for (const option of picklistValuesObj[selectedField]){
                availableOptions.push({label: option, value:option});
            }
            component.set('v.availableOptions',availableOptions);
            component.set('v.picklistValues', picklistValuesObj);
          
            var selectedOptions = component.get('v.criteriaValue').split(", ");
            component.set('v.selectedOptions',selectedOptions);
            component.set('v.alreadySelectedOptions',selectedOptions);
           // component.set('v.selectedPicklistOptionStr', oldSelectedPicklistValues[selectedField].join(', '));
            //component.set('v.criteriaValue', oldSelectedPicklistValues[selectedField].join(', '));
        })    
            
            $A.enqueueAction(action3);
        }

        if(component.get('v.selectedOperator') == 'null' || selectedFieldDataType == 'BOOLEAN'){
            component.set('v.isNullSelected',true);
           if( component.get('v.criteriaValue') == ''){
            component.set('v.criteriaValue','true');
           }
        }
       
    },
    handleOperatorChange : function(component, event, helper){
        const stringopr =["ct","nct","sw","nsw","ew","new"];
        console.log('component.get(v.selectedOperator) --> ', component.get('v.selectedOperator'));
        if(stringopr.includes(component.get('v.selectedOperator'))){
            component.set('v.isExtraStringOprSel', true);
        }else{
            component.set('v.isExtraStringOprSel', false);
        }

        if(component.get('v.selectedOperator') == 'null' || component.get('v.selectedFieldDataType') == 'BOOLEAN'){
            component.set('v.isNullSelected',true);
            // component.set('v.criteriaValue','true');
        }
        else if(component.get('v.isNullSelected')){
            component.set('v.isNullSelected',false);    
            component.set('v.criteriaValue','');
        }
    },
    openModal : function(component,event,helper){
        console.log('Focus recieved');
        component.set('v.testVar','tarun');
        component.set('v.modalHeader',component.get('v.fieldsLabel')[component.get('v.selectedField')]);
        component.set('v.showModal',true);
        component.set('v.selectedOptions',component.get('v.alreadySelectedOptions'));
    },
    closeModal : function(component, event, helper){
        component.set('v.showModal',false);
    }, 
    handleSelectFieldChange : function(component,event,helper){
        var selectedField = component.get('v.selectedField');
        console.log('component.get(v.selectedField)', selectedField);
        var dataTypeObj = component.get('v.fieldsDataType');
        console.log('Datatype -->> ', dataTypeObj[selectedField]);
        var selectedFieldDataType = dataTypeObj[selectedField];
        
        component.set('v.selectedFieldDataType', selectedFieldDataType);
        
        // if(selectedFieldDataType == 'PICKLIST'){
        //     var picklistValuesObj = component.get('v.picklistValues');
        //     console.log('picklistValuesObj --> ', JSON.parse(JSON.stringify(picklistValuesObj)));
        //     console.log('selectedField in picklistValuesObj -->' , selectedField in picklistValuesObj);
        //     if(picklistValuesObj != null && selectedField in picklistValuesObj){
        //         console.log('Values already exists --> ',picklistValuesObj[selectedField]); 
        //         var availableOptions = [];
        //         for (const option of picklistValuesObj[selectedField]){
        //             availableOptions.push({label: option, value:option});
        //         }
        //         component.set('v.availableOptions',availableOptions);
        //     }
        //     else{
        //         var action = component.get('c.getPicklistvalues');
        //         action.setParams({objectName : component.get('v.objectName'),
        //                           field_apiname : selectedField});
        //         action.setCallback(this, function (response) {
        //             console.log('Result PICKLIST -->> ', response.getReturnValue());
        //             picklistValuesObj[selectedField] = response.getReturnValue();
                    
        //             var availableOptions = [];
                    
        //             for (const option of picklistValuesObj[selectedField]){
        //                 availableOptions.push({label: option, value:option});
        //             }
        //             component.set('v.availableOptions',availableOptions);
        //             component.set('v.picklistValues', picklistValuesObj);
        //         })    
        //         $A.enqueueAction(action);
        //     }  
        //     var oldSelectedPicklistValues = component.get('v.oldSelectedPicklistValues');
        //     if(selectedField in oldSelectedPicklistValues ){
        //         component.set('v.selectedOptions',oldSelectedPicklistValues[selectedField]);
        //         component.set('v.alreadySelectedOptions',oldSelectedPicklistValues[selectedField]);
        //         component.set('v.selectedPicklistOptionStr', oldSelectedPicklistValues[selectedField].join(', '));
        //     	component.set('v.criteriaValue', oldSelectedPicklistValues[selectedField].join(', '));
        //     }
        //     else{
        //         component.set('v.selectedOptions',new Array());
        //         component.set('v.alreadySelectedOptions',new Array());
        //         component.set('v.selectedPicklistOptionStr', '');
        //     	component.set('v.criteriaValue', '');
        //     }
            
        // }
        // else if(selectedFieldDataType == 'BOOLEAN'){
        //     component.set('v.isNullSelected',true);
        //     component.set('v.criteriaValue','true');
        // }
        // else{
        // 	component.set('v.criteriaValue', '');   
        // }

        var a = component.get('c.handleOperatorChange');
        $A.enqueueAction(a);
    }, 
    handleSelectionChange : function(component,event, helper){
        console.log('alreadySelectedOptions -->> ',  component.get('v.selectedOptions'));
    },
    
    handleSave : function(component, event,helper){
        component.set('v.alreadySelectedOptions',component.get('v.selectedOptions'));
        component.set('v.showModal',false);
        component.set('v.selectedPicklistOptionStr', component.get('v.selectedOptions').join(', '));
        component.set('v.criteriaValue',component.get('v.selectedOptions').join(', '));
        var oldSelectedPicklistValues = component.get('v.oldSelectedPicklistValues');
        oldSelectedPicklistValues[component.get('v.selectedField')] = component.get('v.selectedOptions');
        component.set('v.oldSelectedPicklistValues',oldSelectedPicklistValues);
    },
    removeRow : function(component, event, helper){
        component.getEvent("DeleteRowEvt").setParams({"indexVar" : component.get("v.rowIndex") }).fire();
    }, 
    
    testChange : function(component,event,helper){
        console.log('criteriaValue --> ',component.get('v.criteriaValue'));
    },
    getCustomSelectedValue : function(component, event, helper) {
        var a = event.getSource();
        var id = a.getLocalId();   
        console.log(id);  
        var a = component.get('c.handleSelectFieldChange');
        $A.enqueueAction(a);
        // component.set('v.criteriaValue', '');   
        //find autocomplete component using aura id
        console.log('Fired');
		const autoCompleteComponent = component.find(id);
        const dataTypeObj = component.get('v.fieldsDataType');
        if(autoCompleteComponent){
            //get selected option from auto complete component's selectedOption attribute
            const selectedOption = autoCompleteComponent.get("v.selectedOption");
            //set selected value in component attribute
            component.set("v.selectedField", selectedOption);
            const selectedField = component.get("v.selectedField");
            //console.log('Datatype -->> ', dataTypeObj[selectedField]);
            component.set("v.selectedFieldDataType", dataTypeObj[selectedField]);

            if(component.get('v.selectedFieldDataType') == 'PICKLIST'){
                var action3 = component.get('c.getPicklistvalues');
                action3.setParams({objectName : component.get('v.objectName'),
                                    field_apiname : selectedField});
                action3.setCallback(this, function (response) {
                console.log('Result PICKLIST -->> ', response.getReturnValue());
                var picklistValuesObj = new Object();
                picklistValuesObj[selectedField] = response.getReturnValue();
                
                var availableOptions = [];
                
                for (const option of picklistValuesObj[selectedField]){
                    availableOptions.push({label: option, value:option});
                }
                component.set('v.availableOptions',availableOptions);
                component.set('v.picklistValues', picklistValuesObj);
              
                var selectedOptions = component.get('v.criteriaValue').split(", ");
                component.set('v.selectedOptions',selectedOptions);
                component.set('v.alreadySelectedOptions',selectedOptions);
               // component.set('v.selectedPicklistOptionStr', oldSelectedPicklistValues[selectedField].join(', '));
                //component.set('v.criteriaValue', oldSelectedPicklistValues[selectedField].join(', '));
            })    
                
                $A.enqueueAction(action3);
            }
        }
	}
})