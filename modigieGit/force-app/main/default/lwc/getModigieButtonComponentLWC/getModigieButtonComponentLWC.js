import { LightningElement, api, wire, track } from "lwc";
import MODIGIELOGO from "@salesforce/resourceUrl/ModigieLogo";
import checkValidateRecord from "@salesforce/apex/GetModigieButton.checkValidateRecord";
import makeGetCallout from "@salesforce/apexContinuation/GetModigieButton.makeGetCallout";
import dataToModigie from "@salesforce/apex/GetModigieButton.dataToModigie";
import sendEmail from "@salesforce/apex/EmailServiceClass.sendEmail";
import { refreshApex } from "@salesforce/apex";
import { NavigationMixin } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";

export default class GetModigieButtonComponentLWC extends NavigationMixin(
  LightningElement
) {
  
  @api recordid;
  @api modalLabel;
  @api modallabel;
  @track alreadySynced = true;
  @track normalVar;
  trySpinner = true;
  modigieLogoUrl = MODIGIELOGO;
  toggleSpinner = true;
  disableSubmit = false;
  returnMap = {};
  modirecordid = "";
  StatusMessage = "";
  //StatusCheck=false;
  // getModigie=true;
  credentialAvailable = false;
  refresh = true;

  totalLimit;
  usedLimit;
  remainingLimit;
  resMap = {};
  showLimitError = false;
  limitErrorMessage = "";
  classicMessage="";
  toastVisible=false;
  @track errorToastMessage="";
  

  connectedCallback() {
    sendAPILimitData({})
      .then((result1) => {
        this.resMap = JSON.parse(result1);
        if(this.resMap.Ad_Hoc_Limits){
          this.totalLimit = this.resMap.Total_API_Limit;
          this.usedLimit = this.resMap.Used_API_Limit;
          if(this.resMap.Total_API_Limit - this.resMap.Used_API_Limit > 0){
            this.remainingLimit = this.resMap.Total_API_Limit - this.resMap.Used_API_Limit; 
        }
        else{
            this.remainingLimit = 0;
        }

          if(this.remainingLimit == 0){
            //this.alreadySynced = true;
            this.showLimitError = true;
            this.limitErrorMessage = "Your remaining daily API Limit is 0, Please contact administrator. ";
          }
        }
        

        checkValidateRecord({
          recid: this.recordid
        })
          .then((result) => {
            this.credentialAvailable = true;
            this.toggleSpinner = false;

            if (result == "Validated") {
              // this.StatusCheck=true;
              this.StatusMessage = "The record is already validated";
            } else if (result == "Unvalidated") {
              //this.StatusCheck=true;
              this.StatusMessage = "The record is unvalidated";
            } else if (result == "Available" || result == "Modigie used") {
              this.alreadySynced = false;
              this.StatusMessage = 'Do you want to "Get Modigie"?';
            } else {
            /*else if(result == 'Modigie used'){
                this.alreadySynced=false;
                this.StatusMessage = 'You have already used "Get Modigie".<br/>Do you want to "Get Modigie"?';
            }*/
              // this.StatusCheck=true;
              this.StatusMessage = result;
            }
          })
          .catch((error) => {
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = error.body.message;
                }
                else{
            const event = new ShowToastEvent({
              title: "Error!",
              message: error.body.message,
              variant: "error"
            });
            this.dispatchEvent(event);
          }
            this.closeModel();
          });
      })
      .catch((error1) => {
        var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = error1.body.message;
                }
                else{
        const event = new ShowToastEvent({
          title: "Error!",
          message: error1.body.message,
          variant: "error"
        });
        this.dispatchEvent(event);
      }
        this.closeModel();
      });
  }

  openModel() {
    this.disableSubmit = true;
    this.toggleSpinner = true;
    makeGetCallout({
      recid: this.recordid
    })
      .then((result) => {
        console.log('Get Modigie Response Body --> ' + result);
        var calloutResponse = JSON.parse(result);
        var stringresponse = result;
        dataToModigie({
          resMap: stringresponse,
          recids: this.recordid
        })
          .then((result1) => {
            this.toggleSpinner = false;

            if (calloutResponse.hasOwnProperty("id")) {

              const event = new ShowToastEvent({
                title: "Success!",
                message:
                  "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                variant: "success"
              });
              this.dispatchEvent(event);
              //this.refresh=false;
              //window.location.reload();

            
              const closeQA = new CustomEvent("close");
              this.dispatchEvent(closeQA);
          
            }
          })
          .catch((error1) => {
            const event = new ShowToastEvent({
              title: "Error!",
              message: error1.body.message,
              variant: "error"
            });
            this.dispatchEvent(event);
          });
      })
      .catch((error) => {
        var errorMap = JSON.parse(error.body.message);
        var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = errorMap.DisplayMessage;
                }
                else{
        const event = new ShowToastEvent({
          title: "Error!",
          message: errorMap.DisplayMessage,
          variant: "error"
        });
        this.dispatchEvent(event);
      }
        sendEmail({
          message: error.body.message
        })
          .then((result2) => {})
          .catch((error2) => {
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = error2.body.message;
                }
                else{
            const event = new ShowToastEvent({
              title: "Error!",
              message: error2.body.message,
              variant: "error"
            });
            this.dispatchEvent(event);
          }
          });
        this.closeModel();
      });
  }

  closeModel() {
    refreshApex(this.alreadySynced);
    const closeQA = new CustomEvent("close", { detail: this.errorToastMessage });
    this.dispatchEvent(closeQA);
  }
 
  
  cancelModel() {
    
    if(this.modallabel == 'Get Mobile Number'){
      const cancelQA = new CustomEvent("cancel", { detail: '' });
    this.dispatchEvent(cancelQA);
    }
    

    const closeQA = new CustomEvent("close", { detail: this.errorToastMessage });
    this.dispatchEvent(closeQA);
  }

}