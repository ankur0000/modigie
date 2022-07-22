import { LightningElement, track, api, wire } from "lwc";
import getOrgStopUntilTimeAndReason from '@salesforce/apex/ModigieLightningTabController.getOrgStopUntilTimeAndReason';
import getModigieInformationCustom from "@salesforce/apex/ModigieLightningTabController.getModigieInformationCustom";
import updateBestTimeToCall from "@salesforce/apex/ModigieLightningTabController.updateBestTimeToCall";
import getTimeZone from "@salesforce/apex/ModigieLightningTabController.getTimeZone";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { loadStyle } from "lightning/platformResourceLoader";
import ModigieCSS from "@salesforce/resourceUrl/ModigieCSS";
import {
  subscribe,
  unsubscribe,
  onError,
  setDebugFlag,
  isEmpEnabled
} from "lightning/empApi";

export default class ModigieCustomLightningTab extends LightningElement {
  @track monday;
  @track tuesday;
  @track wednesday;
  @track thursday;
  @track friday;
  @api recordId;
  @track previousModigieStatus = "NA";
  @track recordData = {};
  @track buttonClickedInfo = {};
  recordPageUrl;
  toggleSpinner = true;
  needToRun = true;
  @track buttonColors = {
    modigie: "slds-button slds-button_brand",
    linkedIn: "slds-button slds-button_brand ",
    phoneIntelligence: "slds-button slds-button_brand ",
    verifyEmployer: "slds-button slds-button_brand ",
    mobileNumber: "slds-button slds-button_brand  "
  };
  @track modigieJobStatus = {
    modigie: "Not started",
    linkedIn: "Not started",
    phoneIntelligence: "Not started",
    verifyEmployer: "Not started"
  };
  @track accordionLabels = {
    modigie: "Get Modigie - Not started",
    linkedIn: "Get LinkedIn - Not started",
    phoneIntelligence: "Get Phone Insights - Not started",
    verifyEmployer: "Verify Employer - Not started"
  };
  @track phoneInsightsData = [];

  isModalOpen = false;
  @track modigieValNumberInsigts = {};
  isReadable = true;
  alternateNumbersInfo = [];
  numbersToSplice = 0;
  showAlternateAccordion = false;
  modigieStatusFontColor = "";
  toastVisible = false;
  classicMessage = "";
  errorToastVisible = false;
  classicErrorMessage = "";
  resultMessage = "";
  modigieAdditional = false;
  alternateNumber1;
  alternateNumber2;
  isGetModigieValidated = false;
  isCompanyNameMatches = false;
  isCompanyNameMatchesVerifyEmployer = false;
  isVerifyEmployer = false;
  timeCode;
  varval;
  isEmbeddedInClassic = false;
  channelName = "/event/modigie__Modigie_Tab_Refresh__e";
  subscription = {};
  BusinessMails = [];
  PrivateMails = [];
  modigieMobilePhoneNumber = "";
  showVerifyEmployerStatus = false;
  isModigieUser = true;
  isOrgCalloutsDisabled = false;
  orgStopReasonString;
  isSelectedCreditAccountInactive = false;
  stopReason
  isCreditAccountStopped = false;
  showErrorMessage = false;

  connectedCallback() {
    loadStyle(this, ModigieCSS + "/ModigieCSS/AccordionStyle.css"),
      getTimeZone()
        .then((result) => {
          this.timeCode = result;
        })
        .catch((error) => {});

    this.recordPageUrl = window.location.href;

    if (this.recordPageUrl.includes("visualforce.com")) {
      this.isEmbeddedInClassic = true;
    }
    this.refreshComponent();

    this.registerErrorListener();

    this.handleSubscribe();

    getOrgStopUntilTimeAndReason().then(result => {
      console.log('line 102',result);
      if(result['isStopCallouts']){
        this.isOrgCalloutsDisabled = true;
        this.orgStopReasonString = result['reasonString'];
      }
      else if(result['isCreditAccountStopped']){
        this.isCreditAccountStopped = true;
        this.stopReason = result['stopReason'];
      }
      else if(result['isSelectedCreditAccountInactive']){
        this.isSelectedCreditAccountInactive = true;
      }

      if(result['isStopCallouts'] || result['isCreditAccountStopped'] || result['isSelectedCreditAccountInactive']){
        this.showErrorMessage = true;
      }
    });
  }

  openModal(event) {
    this.buttonClickedInfo = {};
    var buttonPressed = event.target.dataset.name;
    this.buttonClickedInfo[buttonPressed] = true;
    this.isModalOpen = true;
    this.modigieAdditional = false;
  }
  closeModal(event) {
    this.resultMessage = event.detail;
    if (event.detail == null) {
      var currentPageURL = window.location.href.toString();
      if (
        currentPageURL.includes("visualforce.com") ||
        currentPageURL.includes("visual.force.com")
      ) {
        this.toastVisible = true;
        this.classicMessage =
          "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.";
        let delay = 3000;
        setTimeout(() => {
          this.toastVisible = false;
        }, delay);
      }
    } else if (
      event.detail != "" &&
      event.detail != "Called from get modigie support"
    ) {
      var currentPageURL = window.location.href.toString();
      if (
        currentPageURL.includes("visualforce.com") ||
        currentPageURL.includes("visual.force.com")
      ) {
        this.errorToastVisible = true;
        this.classicErrorMessage = this.resultMessage;
        let delay = 3000;
        setTimeout(() => {
          this.errorToastVisible = false;
        }, delay);
      }
    }
    this.isModalOpen = false;
    this.refreshComponent();
  }

  RedirectToLinkedin() {
    this.buttonClickedInfo = {};
    this.buttonClickedInfo.GetLinkedIn = true;
  }

  additionalModigieServices() {
    this.modigieAdditional = true;
  }

  closeAdditionalModigie(event) {
    this.modigieAdditional = false;
  }

  refreshComponent() {
    getModigieInformationCustom({
      recid: this.recordId
    })
      .then((result) => {
        console.log('result--------->'+JSON.stringify(result));
        this.toggleSpinner = false;
        this.alternateNumber1 = this.alternateNumber2 = "";

        this.isGetModigieValidated = false;
        if (result != "No Record Available" && result != "Non Modigie User and No Record Available") {
          // var parsedResult = JSON.parse(result);

          var val = JSON.parse(JSON.stringify(result));

          this.isModigieUser = val[0].ModigieUser;

          var recordDetails = val[0].ModigieData;

          this.BusinessMails = [];
          this.PrivateMails = [];
          if (recordDetails.modigie__Business_Email_1__c != null) {
            this.BusinessMails.push(recordDetails.modigie__Business_Email_1__c);
          }
          if (recordDetails.modigie__Business_Email_2__c != null) {
            this.BusinessMails.push(recordDetails.modigie__Business_Email_2__c);
          }
          if (recordDetails.modigie__Business_Email_3__c != null) {
            this.BusinessMails.push(recordDetails.modigie__Business_Email_3__c);
          }
          if (recordDetails.modigie__Business_Email_3__c != null) {
            this.BusinessMails.push(recordDetails.modigie__Business_Email_4__c);
          }
          if (recordDetails.modigie__Private_Email_1__c != null) {
            this.PrivateMails.push(recordDetails.modigie__Private_Email_1__c);
          }
          if (recordDetails.modigie__Private_Email_2__c != null) {
            this.PrivateMails.push(recordDetails.modigie__Private_Email_2__c);
          }
          console.log("Busines Mail is ", result);
          console.log("Private Mail is ", this.PrivateMails);

          this.phoneInsightsData = JSON.parse(JSON.stringify(result));
          
          this.phoneInsightsData.shift();
          this.recordData = recordDetails;
          if (this.recordData.modigie__Status__c) {
            if (this.recordData.modigie__Status__c == "Validated") {
              this.modigieMobilePhoneNumber =
                this.recordData.modigie__Mobile__c;
            } else {
              this.modigieMobilePhoneNumber =
                this.recordData.modigie__Status__c;
            }
          }

          this.showVerifyEmployerStatus = false;
          if(this.recordData.modigie__Validate_Employer_Status__c){
            if (this.recordData.modigie__Validate_Employer_Status__c == "Validated") {
                this.showVerifyEmployerStatus = true;
            } 
          }

          //varval = this.recordData.modigie__Company_Name_Matches_Public_Records__c;

          // if(this.recordData.modigie__Validate_Employer_Status__c != null)
          // {

          //     this.isVerifyEmployer = true;
          // }
          if (
            this.recordData.modigie__Company_Name_Matches_Public_Records__c ==
            "Yes"
          ) {
            this.isCompanyNameMatchesVerifyEmployer = true;
          }

          if (this.recordData.modigie__Status__c == "Validated") {
            this.isGetModigieValidated = true;
          }

          if (
            this.recordData
              .modigie__Company_Name_Matches_Records_Get_Modigie__c == "Yes"
          ) {
            this.isCompanyNameMatches = true;
          }

          this.modigieJobStatus.linkedIn =
            recordDetails.modigie__Linkedin_Status__c;
          this.modigieJobStatus.modigie = recordDetails.modigie__Status__c;
          this.modigieJobStatus.phoneIntelligence =
            result[0].phoneInsightsMainStatus;
          this.modigieJobStatus.verifyEmployer =
            recordDetails.modigie__Validate_Employer_Status__c;

          if (
            recordDetails.modigie__Status__c != "Not started" &&
            recordDetails.modigie__Status__c != "Unavailable" &&
            this.buttonColors.modigie.indexOf("buttonColor") == -1
          ) {
            this.buttonColors.modigie += " buttonColor";
            this.modigieStatusFontColor += "modigieStatusColor";
          } else if (
            recordDetails.modigie__Status__c == "Not started" ||
            recordDetails.modigie__Status__c == "Unavailable"
          ) {
            this.buttonColors.modigie = this.buttonColors.modigie.replace(
              " buttonColor",
              ""
            );
          }

          if (
            recordDetails.modigie__Linkedin_Status__c != "Not started" &&
            recordDetails.modigie__Linkedin_Status__c != "Unavailable" &&
            this.buttonColors.linkedIn.indexOf("buttonColor") == -1
          ) {
            this.buttonColors.linkedIn += " buttonColor";
          } else if (
            recordDetails.modigie__Linkedin_Status__c == "Not started" ||
            recordDetails.modigie__Linkedin_Status__c == "Unavailable"
          ) {
            this.buttonColors.linkedIn = this.buttonColors.linkedIn.replace(
              " buttonColor",
              ""
            );
          }

          if (
            this.modigieJobStatus.phoneIntelligence != "Not started" &&
            this.modigieJobStatus.phoneIntelligence != "Unavailable" &&
            this.buttonColors.phoneIntelligence.indexOf("buttonColor") == -1
          ) {
            this.buttonColors.phoneIntelligence += " buttonColor";
          } else if (
            this.modigieJobStatus.phoneIntelligence == "Not started" ||
            this.modigieJobStatus.phoneIntelligence == "Unavailable"
          ) {
            this.buttonColors.phoneIntelligence =
              this.buttonColors.phoneIntelligence.replace(" buttonColor", "");
          }

          if (
            recordDetails.modigie__Validate_Employer_Status__c !=
              "Not started" &&
            recordDetails.modigie__Validate_Employer_Status__c !=
              "Unavailable" &&
            this.buttonColors.verifyEmployer.indexOf("buttonColor") == -1
          ) {
            this.buttonColors.verifyEmployer += " buttonColor";
          } else if (
            recordDetails.modigie__Validate_Employer_Status__c ==
              "Not started" ||
            recordDetails.modigie__Validate_Employer_Status__c == "Unavailable"
          ) {
            this.buttonColors.verifyEmployer =
              this.buttonColors.verifyEmployer.replace(" buttonColor", "");
          }

          if (
            this.recordData.modigie__Validation_Date_Get_Mobile_Number__c !=
            undefined
          ) {
            var temp =
              this.recordData.modigie__Validation_Date_Get_Mobile_Number__c +
              "";

            this.recordData.modigie__Validation_Date_Get_Mobile_Number__c =
              temp.substring(0, 10);
          }
          if (
            this.recordData.modigie__Validation_Date_Verify_Employer__c !=
            undefined
          ) {
            var temp =
              this.recordData.modigie__Validation_Date_Verify_Employer__c + "";

            this.recordData.modigie__Validation_Date_Verify_Employer__c =
              temp.substring(0, 10);
          }
          if (
            this.recordData.modigie__Validation_Date_Get_LinkedIn__c !=
            undefined
          ) {
            var temp =
              this.recordData.modigie__Validation_Date_Get_LinkedIn__c + "";

            this.recordData.modigie__Validation_Date_Get_LinkedIn__c =
              temp.substring(0, 10);
          }

          if (this.previousModigieStatus != "NA") {
            if (
              recordDetails.modigie__Linkedin_Status__c == "Validated" &&
              this.previousModigieStatus.GetLinkedin != "Validated"
            ) {
              var currentPageURL = window.location.href.toString();
              if (
                currentPageURL.includes("visualforce.com") ||
                currentPageURL.includes("visual.force.com")
              ) {
                this.toastVisible = true;
                this.classicMessage =
                  "Verified LinkedIn information is available.";
                let delay = 3000;
                setTimeout(() => {
                  this.toastVisible = false;
                }, delay);
              } else {
                const event = new ShowToastEvent({
                  title: "Success!",
                  message: "Verified LinkedIn information is available.",
                  variant: "success"
                });

                this.dispatchEvent(event);
              }
            }

            if (
              recordDetails.modigie__Validate_Employer_Status__c ==
                "Validated" &&
              this.previousModigieStatus.VerifyEmployer != "Validated"
            ) {
              var currentPageURL = window.location.href.toString();
              if (
                currentPageURL.includes("visualforce.com") ||
                currentPageURL.includes("visual.force.com")
              ) {
                this.toastVisible = true;
                this.classicMessage =
                  "Verified employer information is available.";
                let delay = 3000;
                setTimeout(() => {
                  this.toastVisible = false;
                }, delay);
              } else {
                const event = new ShowToastEvent({
                  title: "Success!",
                  message: "Verified employer information is available.",
                  variant: "success"
                });

                this.dispatchEvent(event);
              }
            }

            if (
              recordDetails.modigie__Phone_Intelligence_Status__c ==
                "Validated" &&
              this.previousModigieStatus.GetPhoneInsights != "Validated"
            ) {
              var currentPageURL = window.location.href.toString();
              if (
                currentPageURL.includes("visualforce.com") ||
                currentPageURL.includes("visual.force.com")
              ) {
                this.toastVisible = true;
                this.classicMessage =
                  "Verified mobile phone insights information is available.";
                let delay = 3000;
                setTimeout(() => {
                  this.toastVisible = false;
                }, delay);
              } else {
                const event = new ShowToastEvent({
                  title: "Success!",
                  message:
                    "Verified mobile phone insights information is available.",
                  variant: "success"
                });

                this.dispatchEvent(event);
              }
            }
            if (
              recordDetails.modigie__Phone_Intelligence_Status_Phone__c ==
                "Validated" &&
              this.previousModigieStatus.GetPhoneInsightsPhone != "Validated"
            ) {
              var currentPageURL = window.location.href.toString();
              if (
                currentPageURL.includes("visualforce.com") ||
                currentPageURL.includes("visual.force.com")
              ) {
                this.toastVisible = true;
                this.classicMessage =
                  "Verified phone insights information is available.";
                let delay = 3000;
                setTimeout(() => {
                  this.toastVisible = false;
                }, delay);
              } else {
                const event = new ShowToastEvent({
                  title: "Success!",
                  message: "Verified phone insights information is available.",
                  variant: "success"
                });

                this.dispatchEvent(event);
              }
            }

            if (
              recordDetails.modigie__Phone_Intelligence_Status_Other_Phone__c ==
                "Validated" &&
              this.previousModigieStatus.GetPhoneInsightsOtherPhone !=
                "Validated"
            ) {
              var currentPageURL = window.location.href.toString();
              if (
                currentPageURL.includes("visualforce.com") ||
                currentPageURL.includes("visual.force.com")
              ) {
                this.toastVisible = true;
                this.classicMessage =
                  "Verified other phone insights information is available.";
                let delay = 3000;
                setTimeout(() => {
                  this.toastVisible = false;
                }, delay);
              } else {
                const event = new ShowToastEvent({
                  title: "Success!",
                  message:
                    "Verified other phone insights information is available.",
                  variant: "success"
                });

                this.dispatchEvent(event);
              }
            }

            if (
              recordDetails.modigie__Status__c == "Validated" &&
              this.previousModigieStatus.GetModigieMobile != "Validated"
            ) {
              var currentPageURL = window.location.href.toString();
              if (
                currentPageURL.includes("visualforce.com") ||
                currentPageURL.includes("visual.force.com")
              ) {
                this.toastVisible = true;
                this.classicMessage = "Get Modigie information is available.";
                let delay = 3000;
                setTimeout(() => {
                  this.toastVisible = false;
                }, delay);
              } else {
                const event = new ShowToastEvent({
                  title: "Success!",
                  message: "Get Modigie information is available.",
                  variant: "success"
                });

                this.dispatchEvent(event);
              }
            }
          }
          this.alternateNumbersInfo = [];

          this.numbersToSplice = 0;
          console.log('phoneInsightsData-------------------->'+JSON.stringify(this.phoneInsightsData));
          for (var i = 0; i < this.phoneInsightsData.length; i++) {
            if (this.phoneInsightsData[i].ValidatedPhoneNumber != undefined) {
              if (
                this.phoneInsightsData[i].ValidatedPhoneNumber.includes(
                  "Modigie Validated Mobile Number"
                )
              ) {
                this.modigieValNumberInsigts = this.phoneInsightsData[i];
              }
            }
            console.log('Best time to call ------------>'+JSON.stringify(this.phoneInsightsData[i]));
            if (
              this.phoneInsightsData[i].DayOfWeekDetail != null &&
              this.phoneInsightsData[i].DayOfWeekDetail != undefined
            ) {
              var bestTimetoCallLoc = JSON.parse(
                JSON.stringify(this.phoneInsightsData[i].DayOfWeekDetail)
              ); //this.bestTimeToCall = recordDetails.modigie__Day_of_Week_Detail__c;

              var arrayForTableLoc = []; //this.arrayForTable=[];
                //console.log(bestTimetoCallLoc);
              var strArr = bestTimetoCallLoc.split(";");

              // if(i == 0){
                
              for (var j = 0; j < 6; j++) {
                console.log('strArr====>', strArr[j]);
                if (strArr[j] == "1") {
                  arrayForTableLoc.push("12am - 2am");
                } else if (strArr[j] == "2") {
                  arrayForTableLoc.push("2am - 4am");
                } else if (strArr[j] == "3") {
                  arrayForTableLoc.push("4am - 6am");
                } else if (strArr[j] == "4") {
                  arrayForTableLoc.push("6am - 8am");
                } else if (strArr[j] == "5") {
                  arrayForTableLoc.push("8am - 10am");
                } else if (strArr[j] == "6") {
                  arrayForTableLoc.push("10am - 12pm");
                } else if (strArr[j] == "7") {
                  arrayForTableLoc.push("12pm - 2pm");
                } else if (strArr[j] == "8") {
                  arrayForTableLoc.push("2pm - 4pm");
                } else if (strArr[j] == "9") {
                  arrayForTableLoc.push("4pm - 6pm");
                } else if (strArr[j] == "10") {
                  arrayForTableLoc.push("6pm - 8pm");
                } else if (strArr[j] == "11") {
                  arrayForTableLoc.push("8pm - 10pm");
                } else if (strArr[j] == "12") {
                  arrayForTableLoc.push("10pm - 12am ");
                } else {
                  arrayForTableLoc.push("NA");
                }
              }
              
            // }
            // if( i == 0){
              var overallTimeLoc = arrayForTableLoc.shift(); //this.overallTime = this.arrayForTable.shift();
              this.phoneInsightsData[i]["DayOfWeekDetailTable"] = arrayForTableLoc;
              this.phoneInsightsData[i]["OverallTime"] = overallTimeLoc + " " + this.timeCode;
              console.log('OverallTime--------->'+this.phoneInsightsData[i]["DayOfWeekDetailTable"]+'----------->' + arrayForTableLoc);
              this.monday = arrayForTableLoc[0];
              this.tuesday = arrayForTableLoc[1];
              this.wednesday = arrayForTableLoc[2];
              this.thursday = arrayForTableLoc[3];
              this.friday = arrayForTableLoc[4];
              
                var str = updateBestTimeToCall({recId: this.recordId, arr: arrayForTableLoc});
              // }
              // console.log(str);
            }
            if (this.phoneInsightsData[i].ValidatedPhoneNumber != undefined) {
              if (
                this.phoneInsightsData[i].ValidatedPhoneNumber.includes(
                  "Modigie Validated Mobile Number"
                )
              ) {
                this.modigieValNumberInsigts = this.phoneInsightsData[i];
                this.numbersToSplice++;
                // this.phoneInsightsData.splice(i,1);
              }
              if (
                this.phoneInsightsData[i].ValidatedPhoneNumber.includes(
                  "Modigie Alternate"
                )
              ) {
                this.alternateNumbersInfo.push(this.phoneInsightsData[i]);

                //   this.phoneInsightsData.splice(i,1);
                this.numbersToSplice++;
              }
              if (this.alternateNumbersInfo.length > 0) {
                this.alternateNumber1 =
                  this.alternateNumbersInfo[0].ValidatedPhoneNumberValue;
                if (this.alternateNumbersInfo.length > 1) {
                  this.alternateNumber2 =
                    this.alternateNumbersInfo[1].ValidatedPhoneNumberValue;
                }
              }
            }
          }
          if (this.numbersToSplice > 0) {
            this.phoneInsightsData.splice(
              this.phoneInsightsData.length - this.numbersToSplice,
              this.numbersToSplice
            );
          }
          if (this.alternateNumbersInfo.length > 0) {
            this.showAlternateAccordion = true;
          }

          this.previousModigieStatus = {
            GetModigieMobile: recordDetails.modigie__Status__c,
            GetPhoneInsights:
              recordDetails.modigie__Phone_Intelligence_Status__c,
            VerifyEmployer: recordDetails.modigie__Validate_Employer_Status__c,
            GetLinkedin: recordDetails.modigie__Linkedin_Status__c,
            GetPhoneInsightsPhone:
              recordDetails.modigie__Phone_Intelligence_Status_Phone__c,
            GetPhoneInsightsOtherPhone:
              recordDetails.modigie__Phone_Intelligence_Status_Other_Phone__c
          };
          //this.modigieJobStatus.modigie.style.fontSize = "smaller ";
          this.accordionLabels.modigie =
            "Get Modigie - " + this.modigieJobStatus.modigie;
          this.accordionLabels.linkedIn =
            "Get LinkedIn - " + this.modigieJobStatus.linkedIn;
          this.accordionLabels.phoneIntelligence =
            "Get Phone Insights - " + this.modigieJobStatus.phoneIntelligence;
          this.accordionLabels.verifyEmployer =
            "Verify Employer - " + this.modigieJobStatus.verifyEmployer;
          this.toggleSpinner = false;
        }
        if(result == "Non Modigie User and No Record Available"){
          this.isModigieUser = false;
        }
      })
      .catch((error) => {
        if(error.body.message.includes('You do not have access to the Apex class')){
            this.isReadable = false;
        }
        else{
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error.body.message,
                "variant": "error"
            });
            this.dispatchEvent(event);
        }
      });
  }
  showAdditionalAccordionModal(event) {
    this.modigieAdditional = true;
  }
  doBack() {
    window.history.back();
  }
  navigateToRecordPage(event) {
    window.open(
      this.recordPageUrl.substring(0, this.recordPageUrl.indexOf("/") + 1) +
        this.recordId,
      "_self"
    );
  }

  handleSubscribe() {
    // Callback invoked whenever a new event message is received
    const messageCallback = (response) => {
      console.log(
        "New message received: ",
        JSON.parse(JSON.stringify(response))
      );

      if (
        response &&
        response.data &&
        response.data.payload &&
        response.data.payload.modigie__LeadOrContactRecordId__c &&
        response.data.payload.modigie__LeadOrContactRecordId__c == this.recordId
      ) {
        console.log("Inside response");
        console.log("Inside response.date");
        console.log("Inside response.date.payload");

        console.log(
          "Inside response.date.payload.modigie__LeadOrContactRecordId__c -- > " +
            response.data.payload.modigie__LeadOrContactRecordId__c
        );
        console.log("this.recordId --> ", this.recordId);
        console.log(
          "response.data.payload.modigie__LeadOrContactRecordId__c == this.recordId --> ",
          response.data.payload.modigie__LeadOrContactRecordId__c ==
            this.recordId
        );
        console.log("Refresh component called");
        this.refreshComponent();
      }
      // Response contains the payload of the new message received
    };

    // Invoke subscribe method of empApi. Pass reference to messageCallback
    subscribe(this.channelName, -1, messageCallback).then((response) => {
      // Response contains the subscription information on subscribe call
      console.log(
        "Subscription request sent to: ",
        JSON.stringify(response.channel)
      );
      console.log("this.recordId --> ", this.recordId);
      this.subscription = response;
    });
  }

  registerErrorListener() {
    // Invoke onError empApi method
    onError((error) => {
      console.log("Received error from server: ", JSON.stringify(error));
      // Error contains the server-side error
    });
  }
}