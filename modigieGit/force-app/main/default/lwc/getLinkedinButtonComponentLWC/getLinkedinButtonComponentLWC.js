import { LightningElement,api,wire, track} from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import checkValidateRecord from '@salesforce/apex/GetLinkedinButton.checkValidateRecord';
import makeGetCallout from '@salesforce/apexContinuation/GetLinkedinButton.makeGetCallout';
import dataToModigie from '@salesforce/apex/GetLinkedinButton.dataToModigie'; 
import sendEmail from '@salesforce/apex/EmailServiceClass.sendEmail'; 
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'; 
import { refreshApex } from '@salesforce/apex';
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";

export default class GetLinkedinButtonComponentLWC extends LightningElement { 
    @api recordid;
    alreadySynced = false;
    modigieLogoUrl = MODIGIELOGO;
    toggleSpinner=true;
    trySpinner = true;
   
    alreadySyncedMessage='';
    disableSubmit=false;
    getModigie=true;
    returnMap={};
    modiRecordid='';
    StatusCheck=false;
    StatusMessage='';
    credentialAvailable=false;

    totalLimit;
    usedLimit;
    remainingLimit;
    resMap = {};
    showLimitError = false;
    limitErrorMessage = "";
    showErrorToast=false;
    @track errorToastMessage="";
  
    connectedCallback(){
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
            .then(result => {
                this.toggleSpinner=false;
                    this.credentialAvailable=true;
                if(result == 'Validated'){
                    this.StatusCheck=true;
                    this.StatusMessage="LinkedIn already exists in your system.  Please delete existing LinkedIn and re-submit the request.";
                       
                }
                else if(result == 'Not Available'){
                     this.StatusCheck=true;
                     this.StatusMessage="LinkedIn for this record is not available.";
                 }
                 else if(result == 'Available'){
                     this.alreadySynced=true;
                 }
                else{
                     this.StatusCheck=true;
                     this.StatusMessage=result;
                }
            })
            .catch(error => {
                var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes("visual.force.com")){
                    this.errorToastMessage = error.body.message;
                }
                else{
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": error.body.message,
                    "variant": "error"
                });
                this.dispatchEvent(event); 
            }
                this.closeModel();
            });
        })
        .catch((error1) => {
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes("visual.force.com")){
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

    openModel(){
        this.disableSubmit=true;
        this.toggleSpinner=true;
       
        makeGetCallout({
            recid: this.recordid   
        }).then(result => {
            
            var calloutResponse = JSON.parse(result);
            var stringresponse = result;
                dataToModigie({
                    resMap: result,
                    recids: this.recordid,
                }).then(result1=>{ 
                    this.toggleSpinner=false;
                   
                    const event = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                        "variant": "success"
                    });
                    this.dispatchEvent(event);
                    
                    //const closeQA = new CustomEvent('close',{detail:result1});
                    const closeQA = new CustomEvent('close');
                    this.dispatchEvent(closeQA);
                
                }).catch(error1 => {
                    const event = new ShowToastEvent({
                        "title": "Error!",
                        "message": error1.body.message,
                        "variant": "error"
                    });
                    this.dispatchEvent(event); 
                })
            
        })
        .catch(error => {
            var errorMap = JSON.parse(error.body.message);
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes("visual.force.com")){
                    this.errorToastMessage = errorMap.DisplayMessage;
                }
                else{
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": errorMap.DisplayMessage,
                "variant": "error"
            });
            this.dispatchEvent(event);
        }
            sendEmail({
                message:error.body.message
            }).then(result2 => {
            }).catch(error2 => {
            });
            this.closeModel();
        });
    }
    closeModel() {
         
        const closeQA = new CustomEvent('close',{detail:this.errorToastMessage});
        this.dispatchEvent(closeQA);
        return refreshApex(this.StatusMessage);
    }
    cancelModel() {
        const cancelQA = new CustomEvent("cancel", { detail: '' });
        this.dispatchEvent(cancelQA);
        const closeQA = new CustomEvent("close", { detail: this.errorToastMessage });
        this.dispatchEvent(closeQA);
      }

}