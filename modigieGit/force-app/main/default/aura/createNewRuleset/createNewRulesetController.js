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
        window.setTimeout(function(){
            console.log('id',component.get('v.rulesetId'));
            if(component.get('v.rulesetId')){
                var getid = component.get('c.getCreditId');
        getid.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('Result -->> ', response.getReturnValue());
                var result = response.getReturnValue();
                var defaultId;
                let creditIds = [];
                let creditPick = [];
                for(let i=0;i<result.length;i++){
                    creditPick = {
                        id: result[i].Id,
                        label: result[i].modigie__Title__c,
                        selected: false
                    };
                    if(result[i].modigie__Default__c ){   
                        defaultId = result[i].Id;                    
                        console.log('let check defaultId ',defaultId);
                        creditPick.selected = true;
                    }
                    console.log(result[i].modigie__isPerformance__c);
                    if(result[i].modigie__isPerformance__c){
                        console.log('inside if');
                        component.set('v.performanceTitle', result[i].modigie__Title__c);
                    }
                    else{
                        console.log('inside else');
                        creditIds.push(creditPick);
                        // creditIds.push(result[i]);
                    }
                }
                component.set('v.creditId',creditIds);
                // component.set('v.creditIdValue','');
                // component.set('v.creditIdValue',defaultId);
                console.log('result[0]' , result[0]);
              
              console.log('heloooo....', component.get('v.creditId'));
              

            }
        })
        $A.enqueueAction(getid);
                component.set('v.isEdit', true);
                var action4 = component.get('c.getRulesetDetails');
                action4.setCallback(this, function(response){
                    let state = response.getState();
                    if(state === "SUCCESS"){
                        let returnedValue = response.getReturnValue();
                        console.log('=======ankur',response.getReturnValue());
                        component.set('v.ruleName',returnedValue.modigie__Rule_Set_Name__c);
                        component.set('v.description',returnedValue.modigie__Rule_Set_Description__c);
                        if(returnedValue.modigie__OnlyOnCreate__c == true){
                            component.set('v.automationTrigger', 1);
                        }
                        else{
                            component.set('v.automationTrigger', 2);
                        }
                        console.log(returnedValue.modigie__Credit_Record_Id__c);
                        component.set('v.creditIdValue', returnedValue.modigie__Credit_Record_Id__c);
                        component.set('v.requestLimit', returnedValue.modigie__Limit__c);
                        component.set('v.maintainQueue', returnedValue.modigie__Maintain_Queue__c);
                        if(returnedValue.modigie__isLimit__c == true){
                            component.set('v.Limits_No_Limits_Selection', 'Limits');
                        }
                        else{
                            component.set('v.Limits_No_Limits_Selection', 'No Limits');
                            component.set('v.showNumberOfRequests', false);
                        }
                        
                        component.set('v.selectedLogic', returnedValue.modigie__Lead_Logic_Type__c.toString());
                        component.set('v.contactSelectedLogic', returnedValue.modigie__Contact_Logic_Type__c.toString());
                        component.set('v.leadLogic', returnedValue.modigie__Lead_Custom_Logic__c);
                        component.set('v.contactLogic', returnedValue.modigie__Contact_Custom_Logic__c);
                        component.set('v.isDetailsLoaded', true);
                    }
                });
                action4.setParams({
                    "rulesetId": component.get('v.rulesetId'),
                });
                $A.enqueueAction(action4);

                var action5 = component.get('c.getCriteriaDetails');
                action5.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        console.log(response.getReturnValue());
                        component.set('v.critriaList',response.getReturnValue()[0]);
                        component.set('v.contactCriteriaList',response.getReturnValue()[1]);
                        component.set('v.isCriteriaLoaded', true);
                    }
                });
                action5.setParams({
                    "rulesetId": component.get('v.rulesetId')
                });
                $A.enqueueAction(action5);

                var action2 = component.get('c.getCurrentQueue');
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        console.log('Current Queue',response.getReturnValue());
                        component.set('v.currentQueue',response.getReturnValue());
                    }
                });
                action2.setParams({
                    "rulesetId": component.get('v.rulesetId')
                });
                $A.enqueueAction(action2);
                
            }
            else{
                var getid = component.get('c.getCreditId');
        getid.setCallback(this, function (response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                console.log('Result -->> ', response.getReturnValue());
                var result = response.getReturnValue();
                var defaultId;
                let creditIds = [];
                let creditPick = [];
                for(let i=0;i<result.length;i++){
                    creditPick = {
                        id: result[i].Id,
                        label: result[i].modigie__Title__c,
                        selected: false
                    };
                    if(result[i].modigie__Default__c ){   
                        defaultId = result[i].Id;                    
                        console.log('let check defaultId ',defaultId);
                        creditPick.selected = true;
                    }
                    console.log(result[i].modigie__isPerformance__c);
                    if(result[i].modigie__isPerformance__c){
                        console.log('inside if');
                        component.set('v.performanceTitle', result[i].modigie__Title__c);
                    }
                    else{
                        console.log('inside else');
                        creditIds.push(creditPick);
                        // creditIds.push(result[i]);
                    }
                }
                component.set('v.creditId',creditIds);
                // component.set('v.creditIdValue','');
                // component.set('v.creditIdValue',defaultId);
                console.log('result[0]' , result[0]);
              
              console.log('heloooo....', component.get('v.creditId'));
              component.set('v.isCriteriaLoaded', true);

            }
        })
        $A.enqueueAction(getid);
                
            }
        },100);
        
        // var action2 = component.get('c.getAutomationCriteria');
        // action2.setCallback(this, function (response) {
        //     let state = response.getState();
        //     if(state === "SUCCESS"){
        //         console.log('Result2 -->> ', response.getReturnValue());
        //         component.set('v.critriaList',response.getReturnValue()[0]);
        //         component.set('v.contactCriteriaList',response.getReturnValue()[1]);
        //         component.set('v.isCriteriaLoaded', true);
        //     }
        //     else if(state === "ERROR"){
        //         let errors = response.getError();
        //         let message = 'Unknown error'; // Default error message
        //         // Retrieve the error message sent by the server
        //         if (errors && Array.isArray(errors) && errors.length > 0) {
        //             message = errors[0].message;
        //         }
                
        //         console.error(message);
        //         // Fire error toast
        //         let toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({title: "Error",message: message, type: "error"});
        //         toastEvent.fire();    
        //     }
            
            
        // })
        // $A.enqueueAction(action2);
        // var action3 = component.get('c.getLogicCriteria');
        // action3.setCallback(this, function (response) {
        //     let state = response.getState();
        //     if(state === "SUCCESS"){
        //         console.log('Result3 -->> ', response.getReturnValue());
        //         component.set('v.selectedLogic',response.getReturnValue()[0]);
        //         component.set('v.leadLogic',response.getReturnValue()[1]);
        //         component.set('v.contactSelectedLogic',response.getReturnValue()[2]);
        //         component.set('v.contactLogic',response.getReturnValue()[3]);
        //         component.set('v.isLogicLoaded', true);
        //     }
        //     else if(state === "ERROR"){
        //         let errors = response.getError();
        //         let message = 'Unknown error'; // Default error message
        //         // Retrieve the error message sent by the server
        //         if (errors && Array.isArray(errors) && errors.length > 0) {
        //             message = errors[0].message;
        //         }
                
        //         console.error(message);
        //         // Fire error toast
        //         let toastEvent = $A.get("e.force:showToast");
        //         toastEvent.setParams({title: "Error",message: message, type: "error"});
        //         toastEvent.fire();    
        //     }
        // })
        // $A.enqueueAction(action3);
    },

    myAction : function(component, event, helper) {

    },
    createProxy: function() {
        const myArray = [Math.random(), Math.random()];
        return new Proxy(myArray, {});
    },
    
    

    saveRulesetDetails : function(component, event, helper){
        var evt = component.getEvent('getNewRulesetData');
        let rulesetName = component.get('v.ruleName');
        let description = component.get('v.description');
        let automationTrigger = component.get('v.automationTrigger');
        let numberOfRequests = component.get('v.requestLimit');
        let maintainQueue = component.get('v.maintainQueue');
        let Limits_No_Limits_Selection = component.get('v.Limits_No_Limits_Selection');
        let leadSelectedLogic = component.get('v.selectedLogic');
        let contactSelectedLogic = component.get('v.contactSelectedLogic');
        let leadLogic = component.get('v.leadLogic');
        let contactLogic = component.get('v.contactLogic');
        let creditIdValue = component.get('v.creditIdValue');

        console.log('description',description);
        if(description != null && description != 'undefined'){
            if(description.length > 255){
                description = description.substring(0,255);
            }
        }
        

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
            }else{
                component.set('v.contactLogic', '');
            }
        }
        //3rd
        // logicCriteriaList.push(component.get('v.contactLogic'));
        contactLogic = component.get('v.contactLogic')
        console.log(leadLogic,'lead and contact logic',contactLogic);
        // validation logic end

        evt.setParams({
            "newRulesetDetails" : {
                "title" : rulesetName,
                "description" : description,
                "automationTrigger" : automationTrigger,
                "numberOfRequests": numberOfRequests, 
                "maintainQueue": maintainQueue,
                "Limits_No_Limits_Selection": Limits_No_Limits_Selection,
                "leadSelectedLogic": leadSelectedLogic, 
                "contactSelectedLogic": contactSelectedLogic,
                "leadLogic": leadLogic,
                "contactLogic": contactLogic,
                "isActive": true,
                "creditRecordId": creditIdValue
            },
            "leadCriteriaList": leadCriteriaList,
            "contactCriteriaList": contactCriteriaList,
            "rulesetId": rulesetId
            
        });
        component.set('v.isSaveClicked', false);
        // console.log('==================',contactCriteriaValue);
        // let contactCriteriaValue = false;
        // for(let i=0; i<contactCriteriaList.length; i++){
        //     console.log(contactCriteriaList[i].CriteriaValue);
        //     if(contactCriteriaList[i].CriteriaValue == '' || contactCriteriaList[i].CriteriaValue == null || contactCriteriaList[i].CriteriaValue == 'undefined'){
        //         contactCriteriaValue = true;
        //     }
        // }

        console.log(leadCriteriaList,'----',contactCriteriaList,'----');
        if(rulesetName == null || rulesetName == 'undefined' || rulesetName == ''){
            // alert('asdfas');
            // component.set('v.showErrorToast', true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please fill the \"Rule Name\" field',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else if(Limits_No_Limits_Selection == 'Limits' && (numberOfRequests == null || numberOfRequests == 'undefined' || numberOfRequests == '')){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error',
                    message: 'Please fill the \"Number of Requests per day\" field',
                    duration:' 3000',
                    type: 'Error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
        }
        else if(leadCriteriaList.length == 0 && contactCriteriaList.length == 0){
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please add atleast one condition',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        // else if(contactCriteriaValue){
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
        else{
            evt.fire();
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Success',
                message: 'Ruleset saved successfully',
                duration:' 3000',
                type: 'Success',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        // evt.fire();
        // 
        
        
    },

    handleNext : function(component, event, helper){
        let nextStep = component.get('v.nextStep');
        let rulesetName = component.get('v.ruleName');
        if(rulesetName == null || rulesetName == 'undefined' || rulesetName == ''){
            // alert('asdfas');
            // component.set('v.showErrorToast', true);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please fill the \"Rule Name\" field',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
        }
        else{
            component.set('v.nextStep', !nextStep);
        }
        
        console.log(nextStep,component.get('v.nextStep'));
    },

    handleBack: function(component){
        let nextStep = component.get('v.nextStep');
        component.set('v.nextStep', !nextStep);
    },

    handleChange: function(component){
        let limitNoLimit = component.get('v.Limits_No_Limits_Selection');
        if(limitNoLimit == 'Limits'){
            component.set('v.showNumberOfRequests', true);
        }
        else{
            component.set('v.showNumberOfRequests', false);
        }
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

    runAnalysis: function(component){
        component.set('v.isAnalysisClicked', true);
        let leadCriteriaList = component.get('v.critriaList');
        let contactCriteriaList = component.get('v.contactCriteriaList');
        if(leadCriteriaList.length == 0 && contactCriteriaList.length == 0){
            component.set('v.isAnalysisClicked', false);
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                title : 'Error',
                message: 'Please add atleast one condition',
                duration:' 3000',
                type: 'Error',
                mode: 'dismissible'
            });
            toastEvent.fire();
            return;
        }
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
        let leadLogic, contactLogic;
        console.log(leadCriteriaList,'-----',contactCriteriaList);
    
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
                    component.set('v.isAnalysisClicked', false);
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
                    component.set('v.isAnalysisClicked', false);
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
                                component.set('v.isAnalysisClicked', false);
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
                                    component.set('v.isAnalysisClicked', false);
                                    component.set('{!v.logicError}', true);
                                    component.set('{!v.leadErrors}', 'Use Paranthesis b/w Success \'AND\' and \'OR\'.');
                                    //console.log('Lead token & lastElem-->', token, '&', stackLogic[stackSize - 1]);
                                    return;
                                }
                            }
                        }
                    }else{
                        //error
                        component.set('v.isAnalysisClicked', false);
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
                    component.set('v.isAnalysisClicked', false);
                    component.set('{!v.logicError}', true);
                    component.set('{!v.leadErrors}', 'Syntax Error! - Close Paranthesis Missing');
                    //console.log('Lead Close Paranthesis Missing');
                    return;
                }
                for(const num of tToken){
                    if(!cpyTToken.includes(num)){
                        //error
                        component.set('v.isAnalysisClicked', false);
                        component.set('{!v.logicError}', true);
                        component.set('{!v.leadErrors}', `Some filter conditions are defined but not reference in your filter logic.`);
                        //console.log(`Lead Criteria ${num} is not Referenced`);
                        return;
                    }
                }
        
                try {
                    eval(tempLogicString);
                } catch (error) {
                    component.set('v.isAnalysisClicked', false);
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
                    component.set('v.isAnalysisClicked', false);
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
                    component.set('v.isAnalysisClicked', false);
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
                                component.set('v.isAnalysisClicked', false);
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
                                    component.set('v.isAnalysisClicked', false);
                                    component.set('{!v.contactLogicError}', true);
                                    component.set('{!v.contactErrors}', 'Use Paranthesis b/w Success \'AND\' and \'OR\'.');
                                    //console.log('Contact token & lastElem-->', token, '&', stackLogic[stackSize - 1]);
                                    return;
                                }
                            }
                        }
                    }else{
                        //error
                        component.set('v.isAnalysisClicked', false);
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
                    component.set('v.isAnalysisClicked', false);
                    component.set('{!v.contactLogicError}', true);
                    component.set('{!v.contactErrors}', 'Syntax Error! - Close Paranthesis Missing');
                    //console.log('Contact Close Paranthesis Missing');
                    return;
                }
                for(const num of tToken){
                    if(!cpyTToken.includes(num)){
                        //error
                        component.set('v.isAnalysisClicked', false);
                        component.set('{!v.contactLogicError}', true);
                        component.set('{!v.contactErrors}', 'Some filter conditions are defined but not reference in your filter logic.');
                        //console.log(`Contact Criteria ${num} is not Referenced`);
                        return;
                    }
                }
        
                try {
                    eval(tempLogicString);
                } catch (error) {
                    component.set('v.isAnalysisClicked', false);
                    component.set('{!v.contactLogicError}', true);
                    component.set('{!v.contactErrors}', 'Syntax Error!');
                    //console.log('Contact Unknown Error-->', 'error')
                    return;
                }
            }else{
                component.set('v.contactLogic', '');
            }
        }
        //3rd
        // logicCriteriaList.push(component.get('v.contactLogic'));
        contactLogic = component.get('v.contactLogic')
        console.log(leadLogic,'lead and contact logic',contactLogic);
        let automationTrigger = component.get("v.automationTrigger");
        if(automationTrigger == '1'){
            component.set('v.automationTriggerForAnalysis','created ');
        }
        else{
            component.set('v.automationTriggerForAnalysis','created/modified ');
        }
    
        let leadLogicType = component.get('v.selectedLogic');
        let contactLogicType = component.get('v.contactSelectedLogic');
    
        var action2 = component.get('c.getPreAnalysis');
        action2.setCallback(this, function(response){
            let returnedValue = response.getReturnValue();
            if(response.getState() == 'SUCCESS'){
                console.log(returnedValue);
                component.set('v.anticipatedQueriesCalculation',returnedValue['Acticipated-Call']);
                component.set('v.leadCount',returnedValue['Lead-Count']);
                component.set('v.contactCount',returnedValue['Contact-Count']);
                component.set('v.mostActiveUserListLead',returnedValue['Lead-User']);
                component.set('v.mostActiveUserListContact',returnedValue['Contact-User']);
                component.set('v.showPreAnalysisModal',true);
                component.set('v.analyzeSpinner',true);

            }
            component.set('v.isAnalysisClicked', false);
        });
        action2.setParams({
            "leadCriteriaList": leadCriteriaList,
            "contactCriteriaList": contactCriteriaList,
            "leadLogic": leadLogic,
            "contactLogic": contactLogic,
            "automationTrigger": component.get("v.automationTrigger"),
            "leadLogicType": leadLogicType,
            "contactLogicType": contactLogicType
        });
        $A.enqueueAction(action2);
                
        // var action = component.get('c.getCurrentQueue');
        // action.setCallback(this, function(response){
        //     if(response.getState() == 'SUCCESS'){
        //         console.log("hii");
        //     }
        // });
        // action.setParams({
        //     'leadCriteriaList': leadCriteriaList,
        //     'contactCriteriaList': contactCriteriaList,
        //     'leadLogic': leadLogic,
        //     'contactLogic': contactLogic,
        //     'automationTrigger': component.get("v.automationTrigger")
        // });
        // $A.enqueueAction(action);
    },

    closePreAnalysisModal: function(component){
        component.set('v.showPreAnalysisModal', false);
    },

    handleRadioChange: function(component){
        console.log(component.get('v.selectedObject'));
        if(component.get('v.selectedObjectForAnalysis') == 'Contact'){
            component.set('v.showContactUserList', true);
        }
        else{
            component.set('v.showContactUserList', false);
        }
        
    },
    showLogicToolTip : function(c, e, h) {
        c.set("v.logicTooltip" , true);
        
    },
    HideLogicToolTip : function(c,e,h){
        c.set("v.logicTooltip" , false);
    }
})