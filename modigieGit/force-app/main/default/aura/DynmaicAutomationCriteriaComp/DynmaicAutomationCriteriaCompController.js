({
    doInit: function(component, event, helper) {
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
        var action2 = component.get('c.getAutomationCriteria');
        action2.setCallback(this, function (response) {
            let state = response.getState();
            if(state === "SUCCESS"){
                console.log('Result2 -->> ', response.getReturnValue());
                component.set('v.critriaList',response.getReturnValue()[0]);
                component.set('v.contactCriteriaList',response.getReturnValue()[1]);
                component.set('v.isCriteriaLoaded', true);
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
        $A.enqueueAction(action2);
        var action3 = component.get('c.getLogicCriteria');
        action3.setCallback(this, function (response) {
            let state = response.getState();
            if(state === "SUCCESS"){
                console.log('Result3 -->> ', response.getReturnValue());
                component.set('v.selectedLogic',response.getReturnValue()[0]);
                component.set('v.leadLogic',response.getReturnValue()[1]);
                component.set('v.contactSelectedLogic',response.getReturnValue()[2]);
                component.set('v.contactLogic',response.getReturnValue()[3]);
                component.set('v.isLogicLoaded', true);
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
        $A.enqueueAction(action3);
    },
    addNewRow : function(component, event, helper) {
        helper.createObjectData(component, event);
        console.log('List Of Objects --> ', component.get("v.critriaList"));
    },
    removeDeletedRow: function(component, event, helper) {
        var index = event.getParam("indexVar");
        var AllRowsList;
        console.log('component.get(\'v.selectedObject\')',component.get('v.seletedObject'));
        if(component.get('v.seletedObject') == 'Lead'){
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
    saveCriteria : function(component,event,helper){
        console.log('savecriteria');
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
        
        var lstCritria = new Array();
        var tempCriteriaList = component.get('v.critriaList');
        var conTempCriteriaList = component.get('v.contactCriteriaList');
        lstCritria.push(tempCriteriaList);
        lstCritria.push(conTempCriteriaList);
        
        console.log('criteira list -->> ', lstCritria);

        const pToken = ['AND', 'OR', '(', ')'];

        var logicCriteriaList = new Array();
        //0th
        var lLogic = component.get('v.selectedLogic');
        logicCriteriaList.push(lLogic);
        if(lLogic !== '3') {
            component.set('v.leadLogic', '');
        }else{
            //validate and on fail return null and show toast error
            var tToken = new Array();
            let logicString = component.get('v.leadLogic');
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

        }
        //1st
        logicCriteriaList.push(component.get('v.leadLogic'));
        var cLogic = component.get('v.contactSelectedLogic');
        //2nd
        logicCriteriaList.push(cLogic);
        if(cLogic !== '3') {
            component.set('v.contactLogic', '');
        }else{
            //validate and on fail return null and show toast error
            var tToken = new Array();
            let logicString = component.get('v.contactLogic');
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
                    //console.log(`Contact Criteria ${num} is not Referenced`);
                    return;
                }
            }

            try {
                eval(tempLogicString);
            } catch (error) {
                component.set('v.isSaveClicked', false);
                component.set('{!v.contactLogicError}', true);
                component.set('{!v.contactErrors}', 'Syntax Error!');
                //console.log('Contact Unknown Error-->', 'error')
                return;
            }
        }
        //3rd
        logicCriteriaList.push(component.get('v.contactLogic'));
        
        var action = component.get('c.setAutomationCriteria');
        
        
        action.setParams({
            criteriaData : lstCritria,
            logicCriteria : logicCriteriaList
        })
        
        action.setCallback(this, function (response) {
            console.log('In call back');
            let state = response.getState();
            component.set('v.isSaveClicked', false);
            if(state === "ERROR"){
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
            var a = component.get('v.onclose');
            $A.enqueueAction(a);    
        })
        
        $A.enqueueAction(action);
    },
    handleLogicInput : function(component,event,helper) {
        var name = event.getSource().get("v.name");
        if(name == 'customLeadLogic') {
            component.set('{!v.logicError}', false);
        }else if(name == 'customContactLogic') {
            component.set('{!v.contactLogicError}', false);
        }
    }
})