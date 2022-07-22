import { LightningElement,api,track } from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import getMobileInformation from '@salesforce/apex/GetPhoneInsightsButton.getMobileInformation';
import makeGetCallout from '@salesforce/apexContinuation/GetPhoneInsightsButton.makeGetCallout';
import dataToModigie from '@salesforce/apex/GetPhoneInsightsButton.dataToModigie';
import sendEmail from '@salesforce/apex/EmailServiceClass.sendEmail'; 
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";



export default class GetPhoneInsightsButtonComponent extends LightningElement {
    @api recordid;
    @track mobilePhoneData = {};//{"isContact":false,"Mobile":false,"Phone":false,"OtherPhone":false,"ModigieValNumber":false,"Alternate1":false,"Alternate2":false};
    modigieLogoUrl = MODIGIELOGO;
    toggleSpinner=true;
    disableSubmit = true;
    selectedFields = '';
    @track checkboxLabelColor={};
    credentialAvailable=false;
    alreadySynced = true;
    StatusMessage='';

    totalLimit;
    usedLimit;
    remainingLimit;
    resMap = {};
    showLimitError = false;
    limitErrorMessage = "";
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
                

        getMobileInformation({
            recid: this.recordid   
        }).then(result => {
            this.credentialAvailable=true;
            this.toggleSpinner=false;
            this.alreadySynced = false;
            
            if(result.startsWith('{')){
                this.mobilePhoneData = JSON.parse(result);
                for (var key in this.mobilePhoneData) {
                    if (this.mobilePhoneData.hasOwnProperty(key)) {
                        if(this.mobilePhoneData[key]){
                            this.checkboxLabelColor[key] = 'greyColor'; 
                        }
                    }
                }
            }
            else{
                this.alreadySynced=true;
                this.StatusMessage=result;
            }
        })
        .catch(error => {
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
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

    handleChange(event){
        
        if(this.selectedFields.indexOf(event.target.dataset.name + ',') != -1){
            this.selectedFields =this.selectedFields.replace(event.target.dataset.name + ',' ,'');    
        }
        else{
            this.selectedFields += event.target.dataset.name + ',';
        }
        
        if(this.selectedFields == ''){
            this.disableSubmit=true;
        }
        else{
            this.disableSubmit=false;
        }
        
    }


    closeModel(){
        const closeQA = new CustomEvent('close', { detail: this.errorToastMessage });
        this.dispatchEvent(closeQA);
    }

    handleSubmit(){
        this.disableSubmit=true;
        this.toggleSpinner=true;
        
        makeGetCallout({
            recid: this.recordid,
            inputNumbers:this.selectedFields  
        }).then(result => {
            var calloutResponse = JSON.parse(result);
            dataToModigie({
                resMap:result,
                recid:this.recordid,
                inputNumbers:this.selectedFields
            }).then(result1 =>{
                this.toggleSpinner=false;
                if(calloutResponse.hasOwnProperty("id")){
                    const event = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                        "variant": "success"
                    });
                    this.dispatchEvent(event);
                    
                    const closeQA = new CustomEvent('close');
                    this.dispatchEvent(closeQA);
                 }
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
                var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = error2.body.message;
                }
                else{
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": error2.body.message,
                    "variant": "error"
                });
                this.dispatchEvent(event);
            }
            });
            this.closeModel();
        });
    }

    cancelModel() {
        const cancelQA = new CustomEvent("cancel", { detail: '' });
        this.dispatchEvent(cancelQA);
        const closeQA = new CustomEvent("close", { detail: this.errorToastMessage });
        this.dispatchEvent(closeQA);
    }

    get hasNumberMissing() {
        if(this.mobilePhoneData.Phone || this.mobilePhoneData.Mobile || (this.mobilePhoneData.isContact && this.mobilePhoneData.OtherPhone)){
            return true;
        }
        return false;
    }
}