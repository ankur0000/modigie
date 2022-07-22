import { LightningElement,api,wire, track} from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import checkValidateRecord from '@salesforce/apex/ValidateEmployer.checkValidateRecord';
import makeGetCallout from '@salesforce/apexContinuation/ValidateEmployer.makeGetCallout';
import dataToModigie from '@salesforce/apex/ValidateEmployer.dataToModigie';
import sendEmail from '@salesforce/apex/EmailServiceClass.sendEmail'; 
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";

export default class ValidateEmployerButtonLWC extends LightningElement {
    @api recordid;
    alreadySynced = false;
    modigieLogoUrl = MODIGIELOGO;
    toggleSpinner=true;
    
   
    alreadySyncedMessage='';
    disableSubmit=false;
    getModigie=true;
    returnMap={};
    modirecordid='';
    StatusCheck=false;
    StatusMessage='';
    GetLinkedInRedirect=false;
    credentialAvailable=false;

    totalLimit;
    usedLimit;
    remainingLimit;
    resMap = {};
    showLimitError = false;
    limitErrorMessage = "";
    classicMessage="";
    toastVisible=false;
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
        }).then(result => {
            this.toggleSpinner=false;
            this.credentialAvailable=true;
            if(result == 'Available'){
                this.alreadySynced=true;
            }
            else if(result.endsWith("Get LinkedIn.")){
                this.StatusCheck=true;
                this.StatusMessage=result;
                this.GetLinkedInRedirect=true;
            }
            else{
                this.StatusCheck=true;
                this.StatusMessage=result;
            }
        })
        .catch(error => {
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = error1.body.message;
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
    
    openModel(){
        this.disableSubmit=true;
        this.toggleSpinner=true;
        
        makeGetCallout({
            recid: this.recordid   
        }).then(result => {
            
            dataToModigie({
                resMap:result,
                recids:this.recordid
            }).then(result1 =>{
                this.toggleSpinner=false;
                        const event = new ShowToastEvent({
                            "title": "Success!",
                            "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                            "variant": "success"
                        });
                        this.dispatchEvent(event);
                        
                        const closeQA = new CustomEvent('close');
                        this.dispatchEvent(closeQA);
                        
            })
            .catch(error1 => {
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
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
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
    }
    RedirectLinkedIn(){
        const closeQA = new CustomEvent('redirect');
        this.dispatchEvent(closeQA);
    }
    cancelModel() {
        const cancelQA = new CustomEvent("cancel", { detail: '' });
        this.dispatchEvent(cancelQA);
        const closeQA = new CustomEvent("close", { detail: this.errorToastMessage });
        this.dispatchEvent(closeQA);
      }
}