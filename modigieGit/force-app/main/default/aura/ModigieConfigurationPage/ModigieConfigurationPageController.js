({
  /*New js  starts*/

  handleHome: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", true);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);
  },

  handleAuthorization: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", true);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleSchedule_Job: function (component, event, helper) {
    component.set("v.selectedItem", "Schedule_Job");
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", true);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleModigie_TOM: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", true);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleModigie_Job_Automation: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set('v.isPerformance', false);
    component.set("v.Modigie_Job_Automation", true);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);
    

  },

  handleModigie_Performance_Automation: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set('v.isPerformance', true);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", true);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleUser_Limits_Settings: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", true);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleSelect_LinkedIn_Field: function(component, event, helper) {
    component.set("v.selectedItem", "Select_LinkedIn_Field");
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", true);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleMessage_Center: function(component, event, helper) {
    component.set("v.Message_Center", true);
    component.set("v.Select_Linkedin_Field", false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);

  },

  handleShowCredits: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set("v.showCreditsTab", true);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);
  },
  handleLinkedInRefrence: function (component, event, helper) {
    component.set("v.Message_Center", false);
      //component.set("v.Select_Linkedin_Field", false);
      component.set('v.automationRefrence', false);
      component.set('v.authorizationRefrence', false);
      component.set('v.scheduleJobRefrence', false);
      component.set('v.userLimitRefrence', false);
      component.set("v.User_Limits_Settings", false);
      component.set("v.TOM", false);
      component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
      component.set("v.Authorization", false);
      component.set("v.Home", false);
      component.set("v.showCreditsTab", false);
      component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", true);
      component.set("v.MessageCenterRefrence", false);
  },
  handleAutomationRefrence: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set('v.automationRefrence', true);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);


  },

  handleAuthorizationRefrence: function (component, event, helper) {
    component.set("v.selectedItem", "Authorization");
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    //component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', true);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);


  },

  handleScheduleJobRefrence: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', true);
    component.set('v.userLimitRefrence', false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    //component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);


  },

  handleUserLimitsSettingsRefrence: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', true);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
      component.set("v.MessageCenterRefrence", false);



  },

  handleAdvancedAutomation: function (component, event, helper) {
    component.set("v.Message_Center", false);
    component.set("v.Select_Linkedin_Field", false);
    component.set('v.automationRefrence', false);
    component.set('v.authorizationRefrence', false);
    component.set('v.scheduleJobRefrence', false);
    component.set('v.userLimitRefrence', false);
    component.set("v.User_Limits_Settings", false);
    component.set("v.TOM", false);
    component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
    component.set("v.Authorization", false);
    component.set("v.Home", false);
    component.set("v.showCreditsTab", false);
    component.set("v.showCreditsTab", false);
    component.set("v.advanceAutomation", true);
    component.set("v.Select_Linkedin_FieldRefrence", false);
    component.set("v.MessageCenterRefrence", false);


  },

  handleMessageCenterRefrence: function (component, event, helper) {
    component.set("v.selectedItem", "Message_Center");
    component.set("v.MessageCenterRefrence", true);
    //component.set("v.Message_Center", false);
      component.set("v.Select_Linkedin_Field", false);
      component.set('v.automationRefrence', false);
      component.set('v.authorizationRefrence', false);
      component.set('v.scheduleJobRefrence', false);
      component.set('v.userLimitRefrence', false);
      component.set("v.User_Limits_Settings", false);
      component.set("v.TOM", false);
      component.set("v.Modigie_Job_Automation", false);
    component.set("v.Modigie_Performance_Automation", false);
    component.set("v.Schedule_Job", false);
      component.set("v.Authorization", false);
      component.set("v.Home", false);
      component.set("v.showCreditsTab", false);
      component.set("v.advanceAutomation", false);
      component.set("v.Select_Linkedin_FieldRefrence", false);
  },



  /*new js ends*/

  doinit: function (component, event, helper) {

    var actionNeg1 = component.get("c.getUserAndCredetialInfo");

    actionNeg1.setParams({
    });
    actionNeg1.setCallback(this, function (response) {
      if (response.getState() == "SUCCESS") {
        if(response.getReturnValue()!='Not an Modigie Admin'){
          component.set("v.modigieAdminUser", true);
          component.set("v.spinnerCheckModigieUser", false);
        }else{
          component.set("v.spinnerCheckModigieUser", false);
        }
      }
      else if (response.getState() === "ERROR") {
        var errors = response.getError();
        var errStr = '';
        if (errors && errors[0] && errors[0].message && errors[0].message == 'You are not an authorized user.'){
          component.set("v.modigieAdminUser", true);
        }
      }

    });
    $A.enqueueAction(actionNeg1);

    component.set("v.toggleSpinner", true);
    component.set("v.edit_Button", true);





    var lstOptions = [];

    var lstoptionshourinter = [];
    lstoptionshourinter.push("00");

    for (var i = 1; i <= 11; i++) {
      var str = "";

      if (i < 10) {
        str = "0" + i;
      } else {
        str = i + "";
      }

      lstOptions.push(str);
      //lstoptionshourinter.push(str);
    }
    lstOptions.push(12 + "");

    component.set("v.optionsHourTime", lstOptions);
    component.set("v.optionsHoursInterval", lstoptionshourinter);

    var lstOptionsMinInterval = [];
    var lstOptionsMinTime = [];

    /*lstOptionsMinInterval.push("00");
    for (var i = 0; i < 60; i++) {
      var str = "";

      if (i == 1) {
        lstOptionsMinInterval.push("0.5");
      }

      if (i < 10) {
        str = "0" + i;
      } else {
        str = i + "";
      }

      if (60 % i == 0) {
        lstOptionsMinInterval.push(str);
      }

      lstOptionsMinTime.push(str);
    }*/
    lstOptionsMinInterval.push("0.5");
    lstOptionsMinInterval.push("01");

    component.set("v.optionsMinuteInterval", lstOptionsMinInterval);
    component.set("v.optionsMinuteTime", lstOptionsMinTime);


    var action0 = component.get("c.getRemainingCreditsInfo");
    action0.setParams({});
    action0.setCallback(this, function (response0) {
      var remainingCredits = response0.getReturnValue();
      component.set('v.remainingCredits', remainingCredits);

      if (remainingCredits == null) {
        component.set('v.showRemainingCredits', false);
      }
    })
    $A.enqueueAction(action0);


    if (component.get('v.isInitially')) {
      var action1 = component.get("c.checkToken");

      action1.setParams({});
      action1.setCallback(this, function (response1) {
        var url_String = window.location.href.toString();

        console.log('Response 1 -->> ', response1.getReturnValue());

        if (response1.getReturnValue().apiKey == null || response1.getReturnValue().creditsId == null || response1.getReturnValue().privateKey == null || response1.getReturnValue().serviceCredential == null) {

          component.set("v.selectedItem", 'Authorization');
          component.set("v.Authorization", true);
        }

        else {

          component.set('v.showNavigation', true)
          component.set("v.selectedItem", 'Modigie_Job_Automation');
          component.set('v.Modigie_Job_Automation', true);
        }




        if (url_String.includes("visualforce.com") || url_String.includes("visual.force.com")) {
          var url = new URL(window.location.href.toString());
          var customerIdfromURL = url.searchParams.get("modigie__customerId");

          if (customerIdfromURL == null) {
            component.set("v.tokenCheck", true);
            component.set("v.creditsId", response1.getReturnValue().creditsId);
            component.set("v.apiKey", response1.getReturnValue().apiKey);
            component.set(
              "v.serviceCredentials",
              response1.getReturnValue().serviceCredential
            );
            component.set("v.customerId", response1.getReturnValue().customerId);
            component.set("v.privateKey", response1.getReturnValue().privateKey);
          }
          else {
            component.set("v.customerId", customerIdfromURL);
          }

        }
        else {
          //component.set("v.selectedItem", 'Authorization');
          if (component.get("v.pageReference.state.modigie__customerId") == null) {
            if (response1.getReturnValue().apiKey != null) {
              //component.set("v.selectedItem", 'Authorization');
              component.set("v.tokenCheck", true);
              component.set("v.creditsId", response1.getReturnValue().creditsId);
              component.set("v.apiKey", response1.getReturnValue().apiKey);
              component.set(
                "v.serviceCredentials",
                response1.getReturnValue().serviceCredential
              );
              component.set("v.customerId", response1.getReturnValue().customerId);
              component.set("v.privateKey", response1.getReturnValue().privateKey);
              //component.set("v.privateKey", response1.getReturnValue().privateKey);
            }
          } else {
            component.set(
              "v.customerId",
              component.get("v.pageReference.state.modigie__customerId")

            );
            component.set("v.privateKey", null);
            // component.set("v.Home", false);
            // component.set("v.Authorization", true);
            //component.set("v.selectedItem", 'Authorization');
          }
        }

        if (response1.getReturnValue().apiKey != null) {
          component.set("v.showTabs", true);
        }

        component.set("v.toggleSpinner", false);
        component.set("v.baseUrl", response1.getReturnValue().baseUrl);
        component.set("v.isProduction", response1.getReturnValue().isProduction);
        component.set("v.userName", response1.getReturnValue().userName);
        component.set("v.orgId", response1.getReturnValue().orgId);
        console.log('Ankur-----f>',response1.getReturnValue().userName);
        component.set("v.canCreateToken", response1.getReturnValue().TokenCreate);
      });
      $A.enqueueAction(action1);
    }


    var action2 = component.get("c.getJobTimeDetails");
    action2.setParams({});
    action2.setCallback(this, function (response1) {
      component.set("v.jobTimeDetails", null);
      console.log(response1.getReturnValue());
      if (response1.getReturnValue() != null) {
        component.set("v.isInterval", false);
        component.set("v.isIntervalPick", false);
        component.set("v.isTime", false);
        component.set("v.isTimePick", false);
        var result = JSON.parse(response1.getReturnValue());

        var hour = result.Hour;
        var minute = result.Minute;
        if(hour==0 && minute <=1){
          component.set("v.isUnderMinuteInterval", true);
        }

        if (!result.Interval) {
          component.set("v.isTime", true);
          component.set("v.isTimePick", true);

          if (result.Hour < 12) {
            component.set("v.selectedmeridiem", "AM");
          } else {
            component.set("v.selectedmeridiem", "PM");
            if (result.Hour > 12) {
              result.Hour -= 12;
            }
          }
        }
        if (result.Hour < 10) {
          hour = "0" + result.Hour;
        }
        if (result.Minute < 10) {
          if (result.Minute > 0 && result.Minute < 1) {
            minute = "" + result.Minute;
          } else {
            minute = "0" + result.Minute;
          }
        }

        if (result.Interval) {
          component.set("v.isInterval", true);
          component.set("v.isIntervalPick", true);
          component.set("v.selectedHourInterval", hour);
          component.set("v.selectedMinuteInterval", minute);

          var obj = { Hour: hour, Minute: minute, isTime: false };
          component.set("v.jobTimeDetails", obj);
        } else {
          if (hour == 0) {
            hour = "12";
          }
          component.set("v.selectedHourTime", hour);
          component.set("v.selectedMinuteTime", minute);

          var obj = {
            Hour: hour,
            Minute: minute,
            isTime: true,
            Meridian: component.get("v.selectedmeridiem")
          };
          component.set("v.jobTimeDetails", obj);
        }
        console.log('inside get job details-->',component.get('v.toggleSpinner'));
        component.set("v.toggleSpinner", false);
        console.log('inside get job details-->',component.get('v.toggleSpinner'));
      }
    });
    $A.enqueueAction(action2);

    var action3 = component.get("c.getScheduleJobsInfo");
    action3.setParams({});
    action3.setCallback(this, function (response3) {
      var parsedObj = JSON.parse(response3.getReturnValue());

      if (parsedObj.DataAvailable) {
        component.set("v.batchJobsInfoOriginal", parsedObj);
        component.set(
          "v.batchJobsInfo",
          JSON.parse(JSON.stringify(component.get("v.batchJobsInfoOriginal")))
        );
      }
    });
    $A.enqueueAction(action3);

    var action4 = component.get("c.getActiveUsers");
    action4.setParams({});
    action4.setCallback(this, function(response4){
      //alert(response4.getState());
      var opt = [];
      var result = response4.getReturnValue();
      for(let k in result){
        opt.push({label: result[k].Name, value: result[k].Id});
        console.log(result[k].Name);
      }
      console.log("Response 4---------->"+response4.getReturnValue());
      component.set("v.options", opt);
    });
    $A.enqueueAction(action4);

    

    var action6 = component.get("c.getAllCheckBoxes");
    action6.setParams({});
    action6.setCallback(this, function(response6){
      console.log("Response 6---------->"+JSON.stringify(response6.getReturnValue()['modigie__AdhoqLimitReached__c']));
      component.set("v.unexpectedExceptionCheckBox",(response6.getReturnValue()['modigie__UnexpectedException__c']));
      component.set("v.securityExceptionCheckBox",(response6.getReturnValue()['modigie__SecurityException__c']));
      component.set("v.noDataFoundExceptionCheckBox",(response6.getReturnValue()['modigie__NoDataFoundException__c']));
      component.set("v.limitExceptionCheckBox",(response6.getReturnValue()['modigie__LimitException__c']));
      component.set("v.emailExceptionCheckBox",(response6.getReturnValue()['modigie__EmailException__c']));
      component.set("v.calloutExceptionCheckBox",(response6.getReturnValue()['modigie__CalloutException__c']));
      component.set("v.dmlExceptionCheckBox",(response6.getReturnValue()['modigie__DMLException__c']));
      component.set("v.allExceptionCheckBox",(response6.getReturnValue()['modigie__AllException__c']));
      component.set("v.calloutResponseCheckBox",(response6.getReturnValue()['modigie__CalloutResponse__c']));
      
      component.set("v.creditErrorCheckBox",(response6.getReturnValue()['modigie__CreditError__c']));
      
      component.set("v.invocableLimitCheckBox",(response6.getReturnValue()['modigie__InvocableLimitExceeded__c']));
      
      component.set("v.adhoqLimitCheckBox",(response6.getReturnValue()['modigie__AdhoqLimitReached__c']));

      console.log(component.get("v.unexpectedExceptionCheckBox"));
      component.set("v.unexpectedExceptionDisable",!(response6.getReturnValue()['modigie__UnexpectedException__c']));
      component.set("v.securityExceptionDisable",!(response6.getReturnValue()['modigie__SecurityException__c']));
      component.set("v.noDataFoundExceptionDisable",!(response6.getReturnValue()['modigie__NoDataFoundException__c']));
      component.set("v.limitExceptionDisable",!(response6.getReturnValue()['modigie__LimitException__c']));
      component.set("v.emailExceptionDisable",!(response6.getReturnValue()['modigie__EmailException__c']));
      component.set("v.calloutExceptionDisable",!(response6.getReturnValue()['modigie__CalloutException__c']));
      component.set("v.dmlExceptionDisable",!(response6.getReturnValue()['modigie__DMLException__c']));
      component.set("v.allExceptionDisable",!(response6.getReturnValue()['modigie__AllException__c']));
      component.set("v.calloutResponseDisable",!(response6.getReturnValue()['modigie__CalloutResponse__c']));
      component.set("v.creditErrorDisable",!(response6.getReturnValue()['modigie__CreditError__c']));
      component.set("v.invocableLimitDisable",!(response6.getReturnValue()['modigie__InvocableLimitExceeded__c']));
      component.set("v.adhoqLimitDisable",!(response6.getReturnValue()['modigie__AdhoqLimitReached__c']));
      
      if(component.get("v.allExceptionCheckBox") == true){
        component.set("v.dmlExceptionDisable",true);
        component.set("v.calloutExceptionDisable",true);
        component.set("v.limitExceptionDisable",true);
        component.set("v.emailExceptionDisable",true);
        component.set("v.noDataFoundExceptionDisable",true);
        component.set("v.securityExceptionDisable",true);
        component.set("v.unexpectedExceptionDisable",true);
        // omponent.set("v.calloutResponseDisable",true);
      }
      // for(let i in response6.getReturnValue().split(",")){
      //   list.push(response6.getReturnValue().split(",")[i].split("\"")[1]);
      // }
      // console.log("----------",list);
      // component.set("v.alreadySelectedOptions", list);
      console.log('after doinit',component.get('v.toggleSpinner'));
    });
    
    $A.enqueueAction(action6);
    console.log('after doinit',component.get('v.toggleSpinner'));
  },

  // handleFilesChange: function (component, event, helper) {
  //   var fileName = 'No File Selected..';
  //   var fileOutput = {};
  //   if (event.getSource().get("v.files").length > 0) 
  //   {
  //     var file = event.getSource().get("v.files")[0];
  //     fileName = file['name'];
      
  //     if (fileName.split('.').pop() == 'json') 
  //     {
  //       var reader = new FileReader();
  //       reader.onload = function (e) 
  //       {
  //         var contents = e.target.result;
  //         fileOutput = JSON.parse(contents);

  //         console.log('json is :::: ', fileOutput);
  //         //will display the file text in console
  //         if(fileOutput.private_key && fileOutput.client_email)
  //         {
  //           var privatekey = fileOutput.private_key.replace('-----BEGIN PRIVATE KEY-----\n', '');
  //           privatekey = privatekey.replace('\n-----END PRIVATE KEY-----\n', '');

  //           component.set('v.privateKeyFile ', privatekey);
  //           component.set("v.SAC", fileOutput.client_email);

  //           component.set("v.edit_Button", false);
  //           component.set("v.uploadJsonButton", false);
  //         }

  //         else
  //         {
  //           alert('Invalid JSON file')
  //         }
          
  //       }
  //       reader.readAsText(file);
  //     }

  //     else
  //     {
  //       alert('Please Insert a JSON file')
  //     }
  //   }
  // },

  scheduleEdit: function (component, event, helper) {
    component.set("v.scheduleEdit", false);
  },

  handleToast: function (component, event, helper) {

    window.setTimeout(
      $A.getCallback(function () {
        helper.hideToast(component, 'handleToast')
      }), 1000
    );


  },

  handleErrorToast: function (component, event, helper) {
    window.setTimeout(
      $A.getCallback(function () {
        helper.hideToast(component, 'handleErrorToast')
      }), 1000
    );
  },

  getAPIToken: function (component, event, helper) {
    var currentURL;
    currentURL = window.location.hostname;
    component.set("v.edit_Button", true);

    if (component.get("v.canCreateToken") == "true") {
      var customerId = component.get("v.customerId");
      var creditsId = component.get("v.creditsId");
      var apiKey = component.get("v.apiKey");
      var serviceCredentials = component.get("v.serviceCredentials");
      var privateKey = component.get("v.privateKey");


      

      if (apiKey && creditsId && serviceCredentials && privateKey && customerId) 
      {
       
          var obj = {
          customerId: component.get("v.customerId"),
          creditsId: creditsId,
          apiKey: apiKey,
          serviceCredentials: serviceCredentials,
          privateKey: privateKey.replace("\n", "")
        };
        var action1 = component.get("c.getToken");
        component.set("v.toggleSpinner", true);

        action1.setParams({
          resMap: obj
        });
        action1.setCallback(this, function (response1) {
          if (response1.getState() == "SUCCESS") {
            var action2 = component.get("c.getJobTimeDetails");
            action2.setParams({});
            action2.setCallback(this, function (response1) {
              component.set("v.jobTimeDetails", null);

              if (response1.getReturnValue() != null) {
                component.set("v.isInterval", false);
                component.set("v.isIntervalPick", false);
                component.set("v.isTime", false);
                component.set("v.isTimePick", false);
                var result = JSON.parse(response1.getReturnValue());

                var hour = result.Hour;
                var minute = result.Minute;

                if (!result.Interval) {
                  component.set("v.isTime", true);
                  component.set("v.isTimePick", true);

                  if (result.Hour < 12) {
                    component.set("v.selectedmeridiem", "AM");
                  } else {
                    component.set("v.selectedmeridiem", "PM");
                    if (result.Hour > 12) {
                      result.Hour -= 12;
                    }
                  }
                }
                if (result.Hour < 10) {
                  hour = "0" + result.Hour;
                }
                if (result.Minute < 10) {
                  if (result.Minute > 0 && result.Minute < 1) {
                    minute = "" + result.Minute;
                  } else {
                    minute = "0" + result.Minute;
                  }
                }

                if (result.Interval) {
                  component.set("v.isInterval", true);
                  component.set("v.isIntervalPick", true);
                  component.set("v.selectedHourInterval", hour);
                  component.set("v.selectedMinuteInterval", minute);

                  var obj = { Hour: hour, Minute: minute, isTime: false };
                  component.set("v.jobTimeDetails", obj);
                } else {
                  if (hour == 0) {
                    hour = "12";
                  }
                  component.set("v.selectedHourTime", hour);
                  component.set("v.selectedMinuteTime", minute);

                  var obj = {
                    Hour: hour,
                    Minute: minute,
                    isTime: true,
                    Meridian: component.get("v.selectedmeridiem")
                  };
                  component.set("v.jobTimeDetails", obj);
                }

                component.set("v.toggleSpinner", false);
              }
            });
            $A.enqueueAction(action2);
            if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {

              component.set('v.showNavigation', true)
              //component.set("v.selectedItem", 'Home');
              //component.set('v.Home', true);

              component.set(
                "v.toastMessage",
                "Credentials Submitted Successfully."
              );
              component.set("v.configurationToast", true);
              $A.enqueueAction(component.get("c.handleToast"));
            } else {

              component.set('v.showNavigation', true)
              // component.set("v.selectedItem", 'Home');
              //component.set('v.Home', true);

              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                type: "success",
                title: "Success!",
                message: "Credentials Submitted Successfully."
              });
              toastEvent.fire();
            }

            component.set("v.showTabs", true);
            component.set("v.toggleSpinner", false);

            component.set("v.tokenCheck", true);
          } else {
            if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {
              component.set("v.toastMessage", response1.getReturnValue());
              component.set("v.configurationErrorToast", true);
              $A.enqueueAction(component.get("c.handleErrorToast"));
              component.set("v.showTabs", true);
              component.set("v.toggleSpinner", false);

              component.set("v.tokenCheck", true);
            } else {
              var toastEvent = $A.get("e.force:showToast");
              toastEvent.setParams({
                type: "error",
                title: "Error!",
                message: response1.getReturnValue()
              });
              toastEvent.fire();
            }
          }
        });
        $A.enqueueAction(action1);
      } 
      
      else 
      {

        
        if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {
          component.set("v.toastMessage", "Fill out all the fields.");
          component.set("v.configurationErrorToast", true);
          $A.enqueueAction(component.get("c.handleErrorToast"));
          component.set("v.showTabs", true);
          component.set("v.toggleSpinner", false);
          component.set("v.tokenCheck", false);
          component.set("v.edit_Button", false);
        } else {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            type: "error",
            title: "Error!",
            message: "Fill out all the fields."
          });
          toastEvent.fire();
          component.set("v.edit_Button", false);
        }
      }
    } else {
      if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {
        component.set("v.toastMessage", "You can not authorize the app.");
        component.set("v.configurationErrorToast", true);
        $A.enqueueAction(component.get("c.handleErrorToast"));
        component.set("v.showTabs", true);
        component.set("v.toggleSpinner", false);
        component.set("v.tokenCheck", true);
      } else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          type: "error",
          title: "Error!",
          message: "You can not authorize the app"
        });
        toastEvent.fire();
      }
    }
  },

  navigate: function (component, event, helper) {


    var action = component.get('c.getRedirectUrl');
    action.setCallback(this, function(response){
      if(response.getReturnValue() != null){
        console.log(response.getReturnValue());
        var currentURL = window.location.hostname;
        if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {
          window.open(
            response.getReturnValue() + '/' + component.get('v.orgId') + ':authorize?callback=' +
            component.get("v.baseUrl")+ "/modigie/ModigieConfigurationRedirectionAppClassic.app" + 
            '&subject=' + component.get('v.userName') + '&isProduction=' + component.get('v.isProduction'),
            "_self"
          );
        } else {
          window.open(
            response.getReturnValue() + '/' + component.get('v.orgId') + ':authorize?callback=' +
            component.get("v.baseUrl")+ "/modigie/ModigieConfigurationRedirectionApp.app" + 
            '&subject=' + component.get('v.userName') + '&isProduction=' + component.get('v.isProduction'),
            "_self"
          );

          component.set("v.redirectAuthenticate", false);
        }
      }
    });
    $A.enqueueAction(action);
  },
  navigateModigie: function (component, event, helper) {

    var action1 = component.get("c.getUserAndCredetialInfo");

    action1.setParams({
    });
    action1.setCallback(this, function (response) {
      if (response.getState() == "SUCCESS") {


        var resultMap = JSON.parse(response.getReturnValue());
        var userInfo = resultMap.UserInfo;

        var userString = '\n\nUser Information\n\nUser Name : ' + userInfo.Username + '\nUser Email : ' + userInfo.Email;

        var credentialInfo = resultMap.CredentialInfo;

        var subject = 'Modigie credits request from ' + userInfo.Name + ' for \'' + credentialInfo.modigie__Service_Account_Credentials__c + '\' service account.';

        var emailBody = '';

        emailBody = 'Organization Id : ' + resultMap.OrganizationInfo + '\n\n' + 'GCP Credentials\n\nCustomer Id : ' + credentialInfo.modigie__Customer_Id__c + '\n\nCredits account Id : ' + credentialInfo.modigie__Credits_Account_Id__c + '\n\nService account credentials : ' + credentialInfo.modigie__Service_Account_Credentials__c + '\n\nApi key : ' + credentialInfo.modigie__Api_key__c;

        emailBody += '\n' + userString;

        var emailTo = 'support@modigie.com,khoppe@modigie.com,kleclaire@modigie.com';

        emailBody = encodeURIComponent(emailBody);

        window.open('https://mail.google.com/mail/?view=cm&fs=1&to=' + emailTo + '&su=' + subject + '&body=' + emailBody);
      }
      else if (state === "ERROR") {
        var errors = response.getError();
        var errStr = '';
        if (errors) {
          if (errors[0] && errors[0].message) {
            errStr = errors[0].message;
          }
        }
        else {
          errStr = 'Some error occurred.';
        }

        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          "type": "error",
          "title": "Error!",
          "message": errStr
        });
        toastEvent.fire();
      }

    });
    $A.enqueueAction(action1);
    // var urlEvent = $A.get("e.force:navigateToURL");
    // urlEvent.setParams({
    //   url: "https://modigie.com"
    // });
    // urlEvent.fire();

    //window.open("https://modigie.com/");

  },
  edit: function (component, event, helper) {
    component.set("v.tokenCheck", false);
    component.set("v.edit_Button", false);
  },

  // closeModel: function (component, event, helper) {
  //   component.set("v.tokenGenerated", false);
  //   component.set("v.tokenCheck", true);
  //   component.set("v.uname", "");
  //   component.set("v.passwd", "");
  //   component.set("v.edit_Button", true);
  //   // var a = component.get("c.doinit");
  //   // $A.enqueueAction(a);




  //   var action1 = component.get("c.checkToken");

  //   action1.setParams({});
  //   action1.setCallback(this, function (response1) {
  //     console.log('----->',response1);
  //     var url_String = window.location.href.toString();

  //     if (url_String.includes("visualforce.com") || url_String.includes("visual.force.com")) {
  //       var url = new URL(window.location.href.toString());
  //       var customerIdfromURL = url.searchParams.get("modigie__customerId");
  //       if (customerIdfromURL == null) {
  //         component.set("v.tokenCheck", true);
  //         component.set("v.creditsId", response1.getReturnValue().creditsId);
  //         component.set("v.apiKey", response1.getReturnValue().apiKey);
  //         component.set(
  //           "v.serviceCredentials",
  //           response1.getReturnValue().serviceCredential
  //         );
  //         component.set("v.customerId", response1.getReturnValue().customerId);
  //         component.set("v.privateKey", response1.getReturnValue().privateKey);
  //       } else {
  //         component.set("v.customerId", customerIdfromURL);
  //       }

  //     }
  //     else {
  //       component.set("v.selectedItem", 'Authorization');
  //       if (component.get("v.pageReference.state.modigie__customerId") == null) {
  //         if (response1.getReturnValue().apiKey != null) {
  //           component.set("v.selectedItem", 'Authorization');
  //           component.set("v.tokenCheck", true);
  //           component.set("v.creditsId", response1.getReturnValue().creditsId);
  //           component.set("v.apiKey", response1.getReturnValue().apiKey);
  //           component.set(
  //             "v.serviceCredentials",
  //             response1.getReturnValue().serviceCredential
  //           );
  //           component.set("v.customerId", response1.getReturnValue().customerId);
  //           component.set("v.privateKey", response1.getReturnValue().privateKey);
  //           //component.set("v.privateKey", response1.getReturnValue().privateKey);
  //         }
  //       } else {
  //         component.set(
  //           "v.customerId",
  //           component.get("v.pageReference.state.modigie__customerId")

  //         );
  //         component.set("v.privateKey", null);
  //         component.set("v.Home", false);
  //         component.set("v.Authorization", true);
  //         component.set("v.selectedItem", 'Authorization');
  //       }
  //     }

  //     if (response1.getReturnValue().apiKey != null) {
  //       component.set("v.showTabs", true);
  //     }

  //     component.set("v.toggleSpinner", false);
  //     component.set("v.baseUrl", response1.getReturnValue().baseUrl);
  //     component.set("v.canCreateToken", response1.getReturnValue().TokenCreate);
  //   });
  //   $A.enqueueAction(action1);


  //   //  $A.get('e.force:refreshView').fire();
  // },
  handleAction: function (component, event, helper) {
    component.set("v.isTimePick", !component.get("v.isTimePick"));
    component.set("v.isIntervalPick", !component.get("v.isIntervalPick"));
  },

  handleSubmit: function (component, event, helper) {
    var hour;
    var minute;
    var type = "Interval";
    var currentURL;
    currentURL = window.location.hostname;
    /*if (component.get("v.isTimePick")) {
      hour = parseInt(component.get("v.selectedHourTime"));
      minute = parseInt(component.get("v.selectedMinuteTime"));
      if (component.get("v.selectedmeridiem") == "PM") {
        if (hour != 12) {
          hour = hour + 12;
        }
      } else if (component.get("v.selectedmeridiem") == "AM") {
        if (hour == 12) {
          hour = 0;
        }
      }
      type = "Time";
    } else {*/
      hour = 0;
      minute = parseFloat(component.get("v.selectedMinuteInterval"));
      if(minute>1){
        minute = 1;
      }
      "minute interval --->>>", minute;
      if (hour == 0 && minute == 0) {
        if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {
          component.set("v.toastMessage", "Invalid Interval");
          component.set("v.configurationErrorToast", true);
          $A.enqueueAction(component.get("c.handleErrorToast"));
        } else {
          var toastEvent = $A.get("e.force:showToast");
          toastEvent.setParams({
            type: "Error",
            title: "Error!",
            message: "Invalid Interval"
          });
          toastEvent.fire();
        }
        return;
      }
    //}
    component.set("v.toggleSpinner", true);
    var action1 = component.get("c.scheduleBatchClass");
    action1.setParams({
      hours: hour,
      minutes: minute,
      types: type
    });
    action1.setCallback(this, function (response1) {
      console.log('---->',response1.getReturnValue());
      component.set("v.toggleSpinner", false);
      console.log(component.get("v.toggleSpinner"));
      var obj = {
        GetLinkedIn: false,
        GetMobileNumber: false,
        GetPhoneInsights: false,
        VerifyEmployer: false
      };
      component.set("v.batchJobsInfo", obj);
      component.set(
        "v.batchJobsInfoOriginal",
        JSON.parse(JSON.stringify(component.get("v.batchJobsInfo")))
      );
      if (currentURL.includes("visualforce.com") || currentURL.includes("visual.force.com")) {
        component.set(
          "v.toastMessage",
          "The Batch Schedule Class Time saved sucessfully."
        );
        component.set("v.configurationToast", true);
        $A.enqueueAction(component.get("c.handleToast"));
        // component.set('v.showTabs',true);
        // component.set("v.toggleSpinner", false);
        // component.set('v.tokenCheck',true);
      } else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          type: "Success",
          title: "Success!",
          message: "The Batch Schedule Class Time saved sucessfully."
        });
        toastEvent.fire();
      }
      component.set("v.isInitially", false);
      var a = component.get("c.doinit");
      $A.enqueueAction(a);
    });
    $A.enqueueAction(action1);
    component.set("v.scheduleEdit", true);


  },


  cancelAction: function (component, event, helper) {
    // var a = component.get("c.doinit");
    // $A.enqueueAction(a);


    var action2 = component.get("c.getJobTimeDetails");
    action2.setParams({});
    action2.setCallback(this, function (response1) {
      component.set("v.jobTimeDetails", null);

      if (response1.getReturnValue() != null) {
        component.set("v.isInterval", false);
        component.set("v.isIntervalPick", false);
        component.set("v.isTime", false);
        component.set("v.isTimePick", false);
        var result = JSON.parse(response1.getReturnValue());

        var hour = result.Hour;
        var minute = result.Minute;

        if (!result.Interval) {
          component.set("v.isTime", true);
          component.set("v.isTimePick", true);

          if (result.Hour < 12) {
            component.set("v.selectedmeridiem", "AM");
          } else {
            component.set("v.selectedmeridiem", "PM");
            if (result.Hour > 12) {
              result.Hour -= 12;
            }
          }
        }
        if (result.Hour < 10) {
          hour = "0" + result.Hour;
        }
        if (result.Minute < 10) {
          if (result.Minute > 0 && result.Minute < 1) {
            minute = "" + result.Minute;
          } else {
            minute = "0" + result.Minute;
          }
        }

        if (result.Interval) {
          component.set("v.isInterval", true);
          component.set("v.isIntervalPick", true);
          component.set("v.selectedHourInterval", hour);
          component.set("v.selectedMinuteInterval", minute);

          var obj = { Hour: hour, Minute: minute, isTime: false };
          component.set("v.jobTimeDetails", obj);
        } else {
          if (hour == 0) {
            hour = "12";
          }
          component.set("v.selectedHourTime", hour);
          component.set("v.selectedMinuteTime", minute);

          var obj = {
            Hour: hour,
            Minute: minute,
            isTime: true,
            Meridian: component.get("v.selectedmeridiem")
          };
          component.set("v.jobTimeDetails", obj);
        }

        component.set("v.toggleSpinner", false);
      }
    });
    $A.enqueueAction(action2);

    component.set("v.scheduleEdit", true);
  },



  abortScheduledJobs: function (component, event, helper) {
    component.set("v.openAbortModal", false);
    var action1 = component.get("c.abortModigieJobs");
    component.set("v.toggleSpinner", true);
    var obj = component.get("v.batchJobsInfo");
    action1.setParams({
      strObj: JSON.stringify(obj)
    });
    action1.setCallback(this, function (response1) {
      component.set("v.toggleSpinner", false);
      console.log('Return Value------>',response1.getReturnValue());
      if (response1.getReturnValue() == "success") {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          type: "Success",
          title: "Success!",
          message: "Selected jobs aborted successfully."
        });
        toastEvent.fire();
        component.set(
          "v.batchJobsInfoOriginal",
          JSON.parse(JSON.stringify(component.get("v.batchJobsInfo")))
        );

        //component.set("v.isInitially", false);
        var a = component.get("c.doinit");
        $A.enqueueAction(a);
      } else {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          type: "error",
          title: "Error!",
          message: response1.getReturnValue()
        });
        toastEvent.fire();
      }
    });
    $A.enqueueAction(action1);
  },
  navigteToScheduleTab: function (component, event, helper) {
    component.set("v.selectedTab", "two");
  },

  shceduleForOneMinute: function (component, event, helper) {
    component.set("v.toggleSpinner", true);

    var action1 = component.get("c.scheduleBatchClass");

    action1.setParams({
      hours: 0,
      minutes: 1,
      types: "Interval"
    });
    action1.setCallback(this, function (response1) {
      component.set("v.toggleSpinner", false);

      var toastEvent = $A.get("e.force:showToast");
      toastEvent.setParams({
        type: "Success",
        title: "Success!",
        message: "The Batch Schedule Class Time saved sucessfully."
      });
      toastEvent.fire();
    });
    $A.enqueueAction(action1);
  },
  openAbortModal: function (component, event, helper) {
    component.set("v.openAbortModal", true);
  },
  closeAbortModal: function (component, event, helper) {
    component.set("v.openAbortModal", false);
    var obj = component.get("v.batchJobsInfoOriginal");

    component.set("v.batchJobsInfo", JSON.parse(JSON.stringify(obj)));
  },
  handleCheckBoxChange: function (component, event, helper) {
    var obj = component.get("v.batchJobsInfo");
  },

  killScheduledJobs: function (component, event, helper) {
    console.log('killSchduledJobs Called');
    component.set("v.toggleSpinner", true);

    var action1 = component.get("c.killScheduledBatchJobs");

  
    action1.setCallback(this, function (response1) {
      console.log('In set call back ->> ', response1.getState());
      component.set("v.toggleSpinner", false);
      if(response1.getState() == 'SUCCESS'){
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          type: "Success",
          title: "Success!",
          message: "Jobs are aborted successfully."
        });
        toastEvent.fire();
        component.set('v.jobTimeDetails', null);
      }
      else{
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
          type: "Error",
          title: "Error!",
          message: "Some Error Occured."
        });
        toastEvent.fire();

      }
    });
    $A.enqueueAction(action1);
  },

  handleChange: function (component, event) {
    // This will contain an array of the "value" attribute of the selected options
    var selectedOptionValue = event.getParam("value");
    console.log(selectedOptionValue);
    var lst = [];
    for(let key in selectedOptionValue){
      lst.push(selectedOptionValue[key]);
    }
    component.set("v.SelectedUnexpectedExceptionUserId",lst);  
    console.log(component.get("v.SelectedUnexpectedExceptionUserId"));
    //alert("Option selected with value: '" + selectedOptionValue.toString() + "'");
},

handleAdhoqLimit : function (component, event, helper){
  component.set('v.AdhoqLimitModal', true);
  var action5 = component.get("c.getSelectedUsersAdhoqLimit");
  action5.setParams({});
  //var list = response5.getReturnValue().split(",");
  //console.log('sdfadsf-----'+ list);
  var list = [];
  action5.setCallback(this, function(response5){
    if(response5.getReturnValue() != null){
      console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsAdhoqLimit", list);
      component.set('v.loadedAlreadySelectedOptionsAdhoqLimit', true)
    }
  });
  
  $A.enqueueAction(action5);
},

handleInvocableLimit : function (component, event, helper){
  component.set('v.InvocableLimitModal', true);
  var action5 = component.get("c.getSelectedUsersInvocableLimit");
  action5.setParams({});
  //var list = response5.getReturnValue().split(",");
  //console.log('sdfadsf-----'+ list);
  var list = [];
  action5.setCallback(this, function(response5){
    if(response5.getReturnValue() != null){
      console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsInvocableLimit", list);
      component.set("v.loadedAlreadySelectedOptionsInvocableLimit", true);
    }
  });
  
  $A.enqueueAction(action5);
},

// handleCreditError : function (component, event, helper){
//   component.set('v.AdhoqLimitModal', true);
//   var action5 = component.get("c.getSelectedUsersAdhoqLimit");
//   action5.setParams({});
//   //var list = response5.getReturnValue().split(",");
//   //console.log('sdfadsf-----'+ list);
//   var list = [];
//   action5.setCallback(this, function(response5){
//     if(response5.getReturnValue() != null){
//       console.log("Response 5---------->"+response5.getReturnValue().split(","));
//       for(let i in response5.getReturnValue().split(",")){
//         list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
//       }
//       console.log("----------",list);
//       component.set("v.alreadySelectedOptionsAdhoqLimit", list);
//     }
//   });
  
//   $A.enqueueAction(action5);
// },

handleCreditError : function (component, event, helper){
  component.set('v.CreditErrorModal', true);
  var action5 = component.get("c.getSelectedUsersCreditError");
  action5.setParams({});
  //var list = response5.getReturnValue().split(",");
  //console.log('sdfadsf-----'+ list);
  var list = [];
  action5.setCallback(this, function(response5){
    if(response5.getReturnValue() != null){
      console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsCreditError", list);
      component.set("v.loadedAlreadySelectedOptionsCreditError", true);
    }
  });
  
  $A.enqueueAction(action5);
},

handleCalloutResponse : function (component, event, helper){
  component.set('v.CalloutResponseModal', true);
  var action5 = component.get("c.getSelectedUsersCalloutResponse");
  action5.setParams({});
  //var list = response5.getReturnValue().split(",");
  //console.log('sdfadsf-----'+ list);
  var list = [];
  action5.setCallback(this, function(response5){
    if(response5.getReturnValue() != null){
      console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsCalloutResponse", list);
      component.set("v.loadedAlreadySelectedOptionsCalloutResponse", true);
    }
  });
  
  $A.enqueueAction(action5);
},

  handleUnexpectedException : function (component, event, helper){
    component.set('v.UnexpectedExceptionModal', true);
    var action5 = component.get("c.getSelectedUsersUnexpected");
    action5.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action5.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
        for(let i in response5.getReturnValue().split(",")){
          list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
        }
        console.log("----------",list);
        component.set("v.alreadySelectedOptionsUnexpected", list);
        component.set("v.loadedAlreadySelectedOptionsUnexpected", true);
      }
    });
    
    $A.enqueueAction(action5);
  },

  handleSecurityException : function (component, event, helper){
    component.set('v.SecurityExceptionModal', true);
    var action5 = component.get("c.getSelectedUsersSecurity");
    action5.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action5.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
        for(let i in response5.getReturnValue().split(",")){
          list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
        }
        console.log("----------",list);
        component.set("v.alreadySelectedOptionsSecurity", list);
        component.set("v.loadedAlreadySelectedOptionsSecurity", true);
      }
    });
    
    $A.enqueueAction(action5);
  },

  handleNoDataFoundException : function (component, event, helper){
    component.set('v.NoDataFoundExceptionModal', true);
    var action = component.get("c.getSelectedUsersNoDataFound");
    action.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
        for(let i in response5.getReturnValue().split(",")){
          list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
        }
        console.log("----------",list);
        component.set("v.alreadySelectedOptionsNoDataFound", list);
        component.set("v.loadedAlreadySelectedOptionsNoDataFound", true);
      }
    });
    
    $A.enqueueAction(action);
  },

  handleEmailException : function (component, event, helper){
    component.set('v.EmailExceptionModal', true);
    var action = component.get("c.getSelectedUsersEmail");
    action.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsEmail", list);
      component.set("v.loadedAlreadySelectedOptionsEmail", true);
      }
      
    });
    
    $A.enqueueAction(action);
  },


  // handleLimitException : function (component, event, helper){
  //   component.set('v.LimitExceptionModal', true);
  //   var action = component.get("c.getSelectedUsersLimit");
  //   action.setParams({});
  //   //var list = response5.getReturnValue().split(",");
  //   //console.log('sdfadsf-----'+ list);
  //   var list = [];
  //   action.setCallback(this, function(response5){
  //     console.log(response5.getReturnValue());
  //     if(response5.getReturnValue() != null){
  //       console.log("Response 5---------->"+response5.getReturnValue().split(","));
  //       for(let i in response5.getReturnValue().split(",")){
  //         list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
  //       }
  //       console.log("----------",list);
  //       component.set("v.alreadySelectedOptionsLimit", list);
  //     }
      
  //   });
    
  //   $A.enqueueAction(action);
  // },

  handleCalloutException : function (component, event, helper){
    component.set('v.CalloutExceptionModal', true);
    var action = component.get("c.getSelectedUsersCallout");
    action.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsCallout", list);
      component.set("v.loadedAlreadySelectedOptionsCallout", true);
      }
      
    });
    
    $A.enqueueAction(action);
  },

  handleDmlException : function (component, event, helper){
    component.set('v.DmlExceptionModal', true);
    var action = component.get("c.getSelectedUsersDml");
    action.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsDml", list);
      component.set("v.loadedAlreadySelectedOptionsDml", true);
      }
      
    });
    
    $A.enqueueAction(action);
  },

  handleAllException : function (component, event, helper){
    component.set('v.AllExceptionModal', true);
    var action = component.get("c.getSelectedUsersAll");
    action.setParams({});
    //var list = response5.getReturnValue().split(",");
    //console.log('sdfadsf-----'+ list);
    var list = [];
    action.setCallback(this, function(response5){
      if(response5.getReturnValue() != null){
        console.log("Response 5---------->"+response5.getReturnValue().split(","));
      for(let i in response5.getReturnValue().split(",")){
        list.push(response5.getReturnValue().split(",")[i].split("\"")[1]);
      }
      console.log("----------",list);
      component.set("v.alreadySelectedOptionsAll", list);
      component.set("v.loadedAlreadySelectedOptionsAll", true);
      }
      
    });
    
    $A.enqueueAction(action);
  },

  closeAdhoqLimitModal: function(component, event, helper){
    component.set('v.AdhoqLimitModal', false);
  },

  closeInvocableLimitModal: function(component, event, helper){
    component.set('v.InvocableLimitModal', false);
  },

  closeCreditErrorModal: function(component, event, helper){
    component.set('v.CreditErrorModal', false);
  },

  closeCalloutResponseModal: function(component, event, helper){
    component.set('v.CalloutResponseModal', false);
  },

  closeUnexpectedExceptionModal: function(component, event, helper){
    component.set('v.UnexpectedExceptionModal', false);
  },

  closeSecurityExceptionModal: function(component, event, helper){
    component.set('v.SecurityExceptionModal', false);
  },

  closeNoDataFoundExceptionModal: function(component, event, helper){
    component.set('v.NoDataFoundExceptionModal', false);
  },

  closeEmailExceptionModal: function(component, event, helper){
    component.set('v.EmailExceptionModal', false);
  },

  // closeLimitExceptionModal: function(component, event, helper){
  //   component.set('v.LimitExceptionModal', false);
  // },

  closeCalloutExceptionModal: function(component, event, helper){
    component.set('v.CalloutExceptionModal', false);
  },

  closeDmlExceptionModal: function(component, event, helper){
    component.set('v.DmlExceptionModal', false);
  },

  closeAllExceptionModal: function(component, event, helper){
    component.set('v.AllExceptionModal', false);
  },

  doSave: function(component, event, helper){
    var typeOfException = document.getElementById('TypeOfException').value;
    var users;
    users = JSON.stringify(component.get("v.SelectedUnexpectedExceptionUserId"));
    
    console.log(typeOfException,'-------',users)
    if(users != '[]'){
      var action = component.get("c.unexpectedExceptionSave");
      
      action.setParams({exceptionType: typeOfException, selectedUsers: users});
      action.setCallback(this, function(response){});
      $A.enqueueAction(action);
    }
    
    component.set('v.NoDataFoundExceptionModal', false);
    component.set('v.SecurityExceptionModal', false);
    component.set('v.UnexpectedExceptionModal', false);
    component.set('v.LimitExceptionModal', false);
    component.set('v.EmailExceptionModal', false);
    component.set('v.CalloutExceptionModal', false);
    component.set('v.DmlExceptionModal', false);
    component.set('v.AllExceptionModal', false);
    component.set('v.CalloutResponseModal', false);
    component.set('v.CreditErrorModal', false);
    component.set('v.InvocableLimitModal', false);
    component.set('v.AdhoqLimitModal', false);
  },

  // getActiveUsers: function(component, event, helper){
  //   var action = component.get("c.getActiveUsers");
  //   action.setParams();
  //   action.setCallback(this, function(response){
  //     alert(response.getReturnValue);
  //   });
  //   $A.enqueueAction(action);
  // }

  onCheckForInvocable: function(component){
    component.set("v.invocableLimitDisable",!component.get("v.invocableLimitDisable"));
    let value = component.get("v.invocableLimitDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForInvocableLimit");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForAdhoq: function(component){
    component.set("v.adhoqLimitDisable",!component.get("v.adhoqLimitDisable"));
    let value = component.get("v.adhoqLimitDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForAdhoqLimit");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForCredit: function(component){
    component.set("v.creditErrorDisable",!component.get("v.creditErrorDisable"));
    let value = component.get("v.creditErrorDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForCreditError");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },
  
  onCheckForCalloutResponse: function(component){
    component.set("v.calloutResponseDisable",!component.get("v.calloutResponseDisable"));
    let value = component.get("v.calloutResponseDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForCalloutResponse");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForUnexpected: function(component){
    component.set("v.unexpectedExceptionDisable",!component.get("v.unexpectedExceptionDisable"));
    let value = component.get("v.unexpectedExceptionDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForUnexpected");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForSecurity: function(component){
    component.set("v.securityExceptionDisable",!component.get("v.securityExceptionDisable"));
    let value = component.get("v.securityExceptionDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForSecurity");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForNoDataFound: function(component){
    component.set("v.noDataFoundExceptionDisable",!component.get("v.noDataFoundExceptionDisable"));
    let value = component.get("v.noDataFoundExceptionDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForNoDataFound");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForEmail: function(component){
    component.set("v.emailExceptionDisable",!component.get("v.emailExceptionDisable"));
    let value = component.get("v.emailExceptionDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForEmail");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  // onCheckForLimit: function(component){
  //   component.set("v.limitExceptionDisable",!component.get("v.limitExceptionDisable"));
  //   let value = component.get("v.limitExceptionDisable");
    
  //   console.log('value'+value);
  //   var action = component.get("c.saveCheckBoxForLimit");
    
  //   action.setParams({checkBox: value});
  //   action.setCallback(this, function(response){});
  //   $A.enqueueAction(action);
  // },

  onCheckForCallout: function(component){
    component.set("v.calloutExceptionDisable",!component.get("v.calloutExceptionDisable"));
    let value = component.get("v.calloutExceptionDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForCallout");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForDml: function(component){
    component.set("v.dmlExceptionDisable",!component.get("v.dmlExceptionDisable"));
    let value = component.get("v.dmlExceptionDisable");
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForDml");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  },

  onCheckForAllException: function(component){
    component.set("v.allExceptionDisable",!component.get("v.allExceptionDisable"));
    let value = component.get("v.allExceptionDisable");
    console.log('-----------'+value);
    if(component.get("v.allExceptionCheckBox") == true){
      component.set("v.dmlExceptionDisable",true);
      component.set("v.calloutExceptionDisable",true);
      component.set("v.limitExceptionDisable",true);
      component.set("v.emailExceptionDisable",true);
      component.set("v.noDataFoundExceptionDisable",true);
      component.set("v.securityExceptionDisable",true);
      component.set("v.unexpectedExceptionDisable",true);
    }
    else{
      component.set("v.dmlExceptionDisable",!component.get("v.dmlExceptionCheckBox"));
      component.set("v.calloutExceptionDisable",!component.get("v.calloutExceptionCheckBox"));
      component.set("v.limitExceptionDisable",!component.get("v.limitExceptionCheckBox"));
      component.set("v.emailExceptionDisable",!component.get("v.emailExceptionCheckBox"));
      component.set("v.noDataFoundExceptionDisable",!component.get("v.noDataFoundExceptionCheckBox"));
      component.set("v.securityExceptionDisable",!component.get("v.securityExceptionCheckBox"));
      component.set("v.unexpectedExceptionDisable",!component.get("v.unexpectedExceptionCheckBox"));
    }
    

    
    
    console.log('value'+value);
    var action = component.get("c.saveCheckBoxForAll");
    
    action.setParams({checkBox: value});
    action.setCallback(this, function(response){});
    $A.enqueueAction(action);
  }

});