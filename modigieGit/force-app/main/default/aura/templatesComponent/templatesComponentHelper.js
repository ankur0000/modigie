({
    hideToast : function(component) {
        component.set("v.configurationToast", false);
    },
    
    doDelete : function(component, event){

        var list = component.get('v.ruleSets');
        // console.log(list[1].title);
        for(let i = 0; i < list.length; i++){
            console.log(list[i].title,event.target.value);
            if(list[i].title == event.target.value && list[i].title != 'Default Ruleset'){

                list.splice(i,1);
                // console.log(list.splice(i,1));
            }
        }
        console.log(list);
        component.set('v.ruleSets', list);
    },

    getAllRulesets: function(component){
        var action2 = component.get('c.getAllRulesets');

        action2.setCallback(this, function(result){
            var state = result.getState();
            let rulesets = [];
            if(state == 'SUCCESS'){
                let returnValue = result.getReturnValue();
                console.log(returnValue);
                for(let i=0; i<returnValue.length; i++){
                    let ruleset = {};
                    console.log(returnValue[i].Name);
                    let automationTriggerValue;
                    if(returnValue[i].modigie__OnlyOnCreate__c){
                        automationTriggerValue = 'created ';
                    }
                    else{
                        automationTriggerValue = 'created/modified ';
                    }
                    // {title: 'Default Ruleset', description: 'Description for Default Ruleset', edit: 'Default Ruleset,Edit', delete: 'Default Ruleset,Delete', active: true, status: 'Default Ruleset,Status', analyse: 'Default Ruleset,Analyse'}
                    ruleset = {'Id': returnValue[i].Id, 'title': returnValue[i].modigie__Rule_Set_Name__c, 'description': returnValue[i].modigie__Rule_Set_Description__c, 'edit': returnValue[i].Id+',Edit', 'delete': returnValue[i].Id+',Delete', active: returnValue[i].modigie__isActive__c, 'status': returnValue[i].Id+',Status', 'analyse': returnValue[i].Id+',Analyse', 'automationTrigger': automationTriggerValue, 'creditTitle': returnValue[i].modigie__Credit_Title__c};
                    rulesets.push(ruleset);
                }
                console.log('---------------',rulesets);
                component.set('v.ruleSets', rulesets);
                component.set('v.spinner', true);
            }
        });
        action2.setParams({
            "isPerformance": component.get('v.isPerformance')
        })

        $A.enqueueAction(action2);
    }
})