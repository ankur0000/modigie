({
    doInit: function(component, event, helper) {
        var url_String = window.location.href.toString();
        if (url_String.includes("visualforce.com") || url_String.includes("visual.force.com")) {
            component.set("v.sfdcClassic", true);
        }
        var action = component.get('c.getObjectFieldInfo');
        action.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('Result -->> ', response.getReturnValue());
                var result = response.getReturnValue();
                console.log('result[0]' , result[0]);
                component.set('v.fieldsLabel',result[0]);
                component.set('v.fieldsDataType',result[1]);
                
                var fields = [];
                for (var key in result[0]) {
                    fields.push({label:result[0][key], apiname:key});
                }
                component.set('v.fields', fields);
                
                component.set('v.contactFieldsLabel',result[2]);
                component.set('v.contactFieldsDataType',result[3]);
                
                fields = [];
                for (var key in result[2]) {
                    fields.push({label:result[2][key], apiname:key});
                }
                component.set('v.contactFields', fields);	
            }
            else if(state === "ERROR"){
                let errors = response.getError();
                let message = 'Unknown error'; // Default error message
                // Retrieve the error message sent by the server
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    message = errors[0].message;
                }
                
                console.error(message);
                // Fire error toast
                let toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({title: "Error",message: message, type: "error"});
                toastEvent.fire();    
            }
        })
        $A.enqueueAction(action);

        var action4 = component.get('c.getTomDetails');
                action4.setCallback(this, function(response){
                    let state = response.getState();
                    if(state === "SUCCESS"){
                        let returnedValue = response.getReturnValue();
                        console.log('=======ankur',response.getReturnValue());
                        
                        
                        component.set('v.selectedLogic', returnedValue.modigie__Lead_Logic_Type__c.toString());
                        component.set('v.contactSelectedLogic', returnedValue.modigie__Contact_Logic_Type__c.toString());
                        component.set('v.leadLogic', returnedValue.modigie__Lead_Custom_Logic__c);
                        component.set('v.contactLogic', returnedValue.modigie__Contact_Custom_Logic__c);
                        component.set('v.revertDateIn', returnedValue.modigie__revertDateIn__c);
                        component.set('v.isDetailsLoaded', true);
                    }
                });
                action4.setParams({
                    "tomOrUntom": component.get('v.tomOrUntom'),
                });
                $A.enqueueAction(action4);

        var action5 = component.get('c.getTomUntomCriteria');
            action5.setCallback(this, function(response){
                if(response.getState() == 'SUCCESS'){
                    console.log('result5-------->',response.getReturnValue());
                    component.set('v.critriaList',response.getReturnValue()[0]);
                    component.set('v.contactCriteriaList',response.getReturnValue()[1]);
                    component.set('v.isCriteriaLoaded', true);
                }
                component.set('v.isCriteriaLoaded', true);
            });
            action5.setParams({
                "tomOrUntom": component.get('v.tomOrUntom')
            });
            $A.enqueueAction(action5);


        // window.setTimeout(function(){
        //     console.log('id',component.get('v.rulesetId'));
        //     if(component.get('v.rulesetId')){
        //         component.set('v.isEdit', true);
                

                

        //         var action2 = component.get('c.getCurrentQueue');
        //         action2.setCallback(this, function(response){
        //             if(response.getState() == 'SUCCESS'){
        //                 console.log('Current Queue',response.getReturnValue());
        //                 component.set('v.currentQueue',response.getReturnValue());
        //             }
        //         });
        //         action2.setParams({
        //             "rulesetId": component.get('v.rulesetId')
        //         });
        //         $A.enqueueAction(action2);
                
        //     }
        //     else{
        //         component.set('v.isCriteriaLoaded', true);
        //     }
        // },100);
        
    },

    addNewRow : function(component, event, helper) {
        helper.createObjectData(component, event);
        console.log('List Of Objects --> ', component.get("v.critriaList"));
    },

    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList;
        console.log('component.get(\'v.selectedObject\')',component.get('v.selectedObject'));
        if(component.get('v.selectedObject') == 'Lead'){
            AllRowsList = component.get("v.critriaList");
            AllRowsList.splice(index, 1);
            component.set("v.critriaList", AllRowsList);
        }
        else{
            AllRowsList = component.get("v.contactCriteriaList");
            AllRowsList.splice(index, 1);
            component.set("v.contactCriteriaList", AllRowsList);    
        }
    },

    
    handleLogicInput : function(component,event,helper) {
        var name = event.getSource().get("v.name");
        if(name == 'customLeadLogic') {
            component.set('{!v.logicError}', false);
        }else if(name == 'customContactLogic') {
            component.set('{!v.contactLogicError}', false);
        }
    },

    saveCriteriaDetails : function(component, event, helper){
        var evt = component.getEvent('getTomUntomData');
        let leadSelectedLogic = component.get('v.selectedLogic');
        let contactSelectedLogic = component.get('v.contactSelectedLogic');
        let leadLogic = component.get('v.leadLogic');
        let contactLogic = component.get('v.contactLogic');
        let revertDateIn = component.get('v.revertDateIn');

        

        let leadCriteriaList = component.get('v.critriaList');
        let contactCriteriaList = component.get('v.contactCriteriaList');
        
        for(const checkLeadCriteria of leadCriteriaList){
            if(checkLeadCriteria.SelectedField == null || checkLeadCriteria.SelectedField == '' || checkLeadCriteria.SelectedField == undefined){
                component.set('v.isAnalysisClicked', false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'fieldName can\'t be blank (Lead)',
                    duration:' 3000',
                    type: 'Error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                return;
            }
        }
        for(const checkConCriteria of contactCriteriaList){
            if(checkConCriteria.SelectedField == null || checkConCriteria.SelectedField == '' || checkConCriteria.SelectedField == undefined){
                component.set('v.isAnalysisClicked', false);
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'fieldName can\'t be blank (Contact)',
                    duration:' 3000',
                    type: 'Error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                return;
            }
        }

        let rulesetId = component.get('v.rulesetId');
        // console.log(leadCriteriaList,'----------------',contactCriteriaList);
        // let myTarget = JSON.parse(JSON.stringify(contactCriteriaList));
        // console.log('==================',myTarget);
        // let contactCriteriaValue = false;
        // for(let i=0; i<myTarget.length; i++){
        //     console.log(myTarget[i]);
        //     if(myTarget[i].CriteriaValue == '' || myTarget[i].CriteriaValue == null || myTarget[i].CriteriaValue == 'undefined'){
        //         contactCriteriaValue = true;
        //     }
        // }
        // console.log(contactCriteriaValue);
        // if(contactCriteriaValue){
        //     var toastEvent = $A.get("e.force:showToast");
        //     toastEvent.setParams({
        //         title : 'Error',
        //         message: 'Please fill the required fields in conditions',
        //         duration:' 3000',
        //         type: 'Error',
        //         mode: 'dismissible'
        //     });
        //     toastEvent.fire();
        // }

        component.set('v.isSaveClicked', true);
        
        var critriaList = component.get('v.critriaList');
        
        for (const criteria of critriaList){
            if(criteria.CriteriaValue == ''){
                component.set('v.isSaveClicked', false);
                //put error toast
                return;
            }
        }
        
        critriaList = component.get('v.contactCriteriaList');
        
        for (const criteria of critriaList){
            if(criteria.CriteriaValue == ''){
                component.set('v.isSaveClicked', false);
                //put error toast
                return;
            }
        }

        // validation logic start
        var lstCritria = new Array();
        var tempCriteriaList = component.get('v.critriaList');
        var conTempCriteriaList = component.get('v.contactCriteriaList');
        lstCritria.push(tempCriteriaList);
        lstCritria.push(conTempCriteriaList);

        const pToken = ['AND', 'OR', '(', ')'];

        var logicCriteriaList = new Array();
        //0th
        var lLogic = component.get('v.selectedLogic');
        logicCriteriaList.push(lLogic);
        if(lLogic !== '3') {
            component.set('v.leadLogic', '');
        }else{
            if(leadCriteriaList.length != 0){
                //validate and on fail return null and show toast error
                var tToken = new Array();
                let logicString = component.get('v.leadLogic');
                if(logicString == null || logicString == undefined || logicString == ''){
                    component.set('v.isSaveClicked', false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Logic can\'t be blank (Lead)',
                        duration:' 3000',
                        type: 'Error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    return;
                }
                if(logicString.includes('  ')){
                    //error
                    component.set('v.isSaveClicked', false);
                    component.set('{!v.logicError}', true);
                    component.set('{!v.leadErrors}', 'Syntax Error! - Only single space allowed');
                    //console.log('Lead Double Spaces Detected');
                    return;
                }
                logicString = logicString.replace(/\(/g, " ( ");            
                logicString = logicString.replace(/\)/g, " ) ");           
                logicString = logicString.replace(/\s\s+/g, " ");
                logicString = logicString.trim();

                let tempLogicString  = logicString.replace(/AND/g, '&&');
                tempLogicString  = tempLogicString.replace(/OR/g, '||');

                let logicArr = logicString.split(' ');
                //console.log('logicString-->',logicString);
                //console.log('logicArr-->', logicArr);
                //console.log(tempCriteriaList);
                let criSize = tempCriteriaList.length;
                //console.log('criSize-->', criSize);
                for(let i = 1; i<= criSize; i++){
                    tToken.push(i.toString());
                }
                //console.log('Lead tToken-->', tToken);
                let countOpenPar = 0;
                var cpyTToken = new Array();
                var stackLogic = new Array();
                var toPush = 1;
                for(const token of logicArr){
                    if(pToken.includes(token) || tToken.includes(token)){
                        //console.log('Lead token-->',token);
                        if(token == '('){
                            countOpenPar++;
                        }else if(token == ')'){
                            if(countOpenPar > 0){
                                countOpenPar--;
                            }else{
                                //error
                                component.set('v.isSaveClicked', false);
                                component.set('{!v.logicError}', true);
                                component.set('{!v.leadErrors}', 'Syntax Error! - Open Paranthesis Missing');
                                //console.log('Lead Open Paranthesis Missing');
                                return;
                            }
                        }
                        
                        if(tToken.includes(token)){
                            cpyTToken.push(token);
                            tempLogicString = tempLogicString.replace(token, 'true');
                        }else{
                            if((toPush >= 1) && (token == 'AND' || token == 'OR')){
                                stackLogic.push(token);
                                //console.log('SL-->',stackLogic);
                                toPush--;
                            }else if(stackLogic.length !== 0){
                                let stackSize = stackLogic.length;
                                if(token == '('){
                                    toPush++;
                                }else if(token == ')'){
                                    let discardVal = stackLogic.pop();
                                    //console.log('dV-->', discardVal, stackLogic);
                                }else if((token != stackLogic[stackSize - 1]) && (token == 'AND' || token == 'OR')){
                                    //error
                                    component.set('v.isSaveClicked', false);
                                    component.set('{!v.logicError}', true);
                                    component.set('{!v.leadErrors}', 'Use Paranthesis b/w Success \'AND\' and \'OR\'.');
                                    //console.log('Lead token & lastElem-->', token, '&', stackLogic[stackSize - 1]);
                                    return;
                                }
                            }
                        }
                    }else{
                        //error
                        component.set('v.isSaveClicked', false);
                        component.set('{!v.logicError}', true);
                        if(token > tToken.length){
                            component.set('{!v.leadErrors}', `Some filter conditions are referenced in your filter logic but not defined.`);
                            //console.log(`Lead Criteria ${token} Mentioned is not defined`);
                        }else{
                            component.set('{!v.leadErrors}', 'Syntax Error!');
                            //console.log('Lead token error-->', token);
                        }
                        return;
                    }
                }
                if(countOpenPar != 0){
                    //error
                    component.set('v.isSaveClicked', false);
                    component.set('{!v.logicError}', true);
                    component.set('{!v.leadErrors}', 'Syntax Error! - Close Paranthesis Missing');
                    //console.log('Lead Close Paranthesis Missing');
                    return;
                }
                for(const num of tToken){
                    if(!cpyTToken.includes(num)){
                        //error
                        component.set('v.isSaveClicked', false);
                        component.set('{!v.logicError}', true);
                        component.set('{!v.leadErrors}', `Some filter conditions are defined but not reference in your filter logic.`);
                        //console.log(`Lead Criteria ${num} is not Referenced`);
                        return;
                    }
                }

                try {
                    eval(tempLogicString);
                } catch (error) {
                    component.set('v.isSaveClicked', false);
                    component.set('{!v.logicError}', true);
                    component.set('{!v.leadErrors}', 'Syntax Error!');
                    //console.log('Lead Unknown Error-->', 'error')
                    return;
                }
            }else{
                component.set('v.leadLogic', '');
            }
        }
        //1st
        // logicCriteriaList.push(component.get('v.leadLogic'));
        leadLogic = component.get('v.leadLogic');
        var cLogic = component.get('v.contactSelectedLogic');
        //2nd
        logicCriteriaList.push(cLogic);
        if(cLogic !== '3') {
            component.set('v.contactLogic', '');
        }else{
            if(contactCriteriaList.length != 0){
                //validate and on fail return null and show toast error
                var tToken = new Array();
                let logicString = component.get('v.contactLogic');
                if(logicString == null || logicString == undefined || logicString == ''){
                    component.set('v.isSaveClicked', false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error',
                        message: 'Logic can\'t be blank (Contact)',
                        duration:' 3000',
                        type: 'Error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                    return;
                }
                if(logicString.includes('  ')){
                    //error
                    component.set('v.isSaveClicked', false);
                    component.set('{!v.contactLogicError}', true);
                    component.set('{!v.contactErrors}', 'Syntax Error! - Only single space allowed');
                    //console.log('Contact Double Spaces Detected');
                    return;
                }
                logicString = logicString.replace(/\(/g, " ( ");            
                logicString = logicString.replace(/\)/g, " ) ");           
                logicString = logicString.replace(/\s\s+/g, " ");
                logicString = logicString.trim();

                let tempLogicString  = logicString.replace(/AND/g, '&&');
                tempLogicString  = tempLogicString.replace(/OR/g, '||');

                let logicArr = logicString.split(' ');
                //console.log('logicString-->',logicString);
                //console.log('logicArr-->', logicArr);
                //console.log(conTempCriteriaList);
                let criSize = conTempCriteriaList.length;
                //console.log('criSize-->', criSize);
                for(let i = 1; i<= criSize; i++){
                    tToken.push(i.toString());
                }
                //console.log('Contact tToken-->', tToken);
                let countOpenPar = 0;
                var cpyTToken = new Array();
                var stackLogic = new Array();
                var toPush = 1;
                for(const token of logicArr){
                    if(pToken.includes(token) || tToken.includes(token)){
                        //console.log('Contact token-->',token);
                        if(token == '('){
                            countOpenPar++;
                        }else if(token == ')'){
                            if(countOpenPar > 0){
                                countOpenPar--;
                            }else{
                                //error
                                component.set('v.isSaveClicked', false);
                                component.set('{!v.contactLogicError}', true);
                                component.set('{!v.contactErrors}', 'Syntax Error! - Open Paranthesis Missing');
                                //console.log('Contact Open Paranthesis Missing');
                                return;
                            }
                        }
                        
                        if(tToken.includes(token)){
                            cpyTToken.push(token);
                            tempLogicString = tempLogicString.replace(token, 'true');
                        }else{
                            if((toPush >= 1) && (token == 'AND' || token == 'OR')){
                                stackLogic.push(token);
                                //console.log('SL-->',stackLogic);
                                toPush--;
                            }else if(stackLogic.length !== 0){
                                let stackSize = stackLogic.length;
                                if(token == '('){
                                    toPush++;
                                }else if(token == ')'){
                                    let discardVal = stackLogic.pop();
                                }else if((token != stackLogic[stackSize - 1]) && (token == 'AND' || token == 'OR')){
                                    //error
                                    component.set('v.isSaveClicked', false);
                                    component.set('{!v.contactLogicError}', true);
                                    component.set('{!v.contactErrors}', 'Use Paranthesis b/w Success \'AND\' and \'OR\'.');
                                    //console.log('Contact token & lastElem-->', token, '&', stackLogic[stackSize - 1]);
                                    return;
                                }
                            }
                        }
                    }else{
                        //error
                        component.set('v.isSaveClicked', false);
                        component.set('{!v.contactLogicError}', true);
                        if(token > tToken.length){
                            component.set('{!v.contactErrors}', `Some filter conditions are referenced in your filter logic but not defined.`);
                            //console.log(`Contact Criteria ${token} Mentioned is not defined`);
                        }else{
                            component.set('{!v.contactErrors}', 'Syntax Error!');
                            //console.log('Contact token error-->', token);
                        }
                        return;
                    }
                }
                if(countOpenPar != 0){
                    //error
                    component.set('v.isSaveClicked', false);
                    component.set('{!v.contactLogicError}', true);
                    component.set('{!v.contactErrors}', 'Syntax Error! - Close Paranthesis Missing');
                    //console.log('Contact Close Paranthesis Missing');
                    return;
                }
                for(const num of tToken){
                    if(!cpyTToken.includes(num)){
                        //error
                        component.set('v.isSaveClicked', false);
                        component.set('{!v.contactLogicError}', true);
                        component.set('{!v.contactErrors}', 'Some filter conditions are defined but not reference in your filter logic.');
                        return;
                    }
                }

                try {
                    eval(tempLogicString);
                } catch (error) {
                    component.set('v.isSaveClicked', false);
                    component.set('{!v.contactLogicError}', true);
                    component.set('{!v.contactErrors}', 'Syntax Error!');
                    return;
                }
            }else{
                component.set('v.contactLogic', '');
            }
        }
        //3rd
        contactLogic = component.get('v.contactLogic');
        console.log(leadCriteriaList,'----',contactCriteriaList,'----');
        console.log(leadLogic,'lead and contact logic',contactLogic);
        // validation logic end
        var action = component.get("c.saveTomUntomCriteria");
        action.setCallback(this, function (response) {
            if(response.getState = 'SUCCESS'){
                console.log(response.getReturnValue());

            }
        })
        action.setParams({
            "criteriaDetails" : {
                "leadSelectedLogic": leadSelectedLogic, 
                "contactSelectedLogic": contactSelectedLogic,
                "leadLogic": leadLogic,
                "contactLogic": contactLogic,
                "isActive": true,
                "revertDateIn" : revertDateIn
            },
            "leadCriteriaList": leadCriteriaList,
            "contactCriteriaList": contactCriteriaList,
            "tomOrUntom": component.get('{!v.tomOrUntom}')
            
            
        });
        component.set('v.isSaveClicked', false);

        console.log(leadCriteriaList,'----',contactCriteriaList,'----');
        if(leadCriteriaList.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please add atleast one condition for Lead',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if(contactCriteriaList.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please add atleast one condition for Contact',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if(revertDateIn < 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Cadence period can\'t be less then zero days.',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if(revertDateIn > 99999){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Cadence period can\'t exceed 99,999 days.',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else{
            $A.enqueueAction(action);
            evt.fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success',
                message: 'Saved Successfully!!!',
                duration:' 3000',
                type: 'Success',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        
        // 
        
        
    },
})