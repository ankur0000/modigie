import { LightningElement,track, api } from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMobileInformation from '@salesforce/apex/GetPhoneInsightsCampaignButton.getMobileInformation';
import requestPhoneIntelJobs from '@salesforce/apex/GetPhoneInsightsCampaignButton.requestPhoneIntelJobs';
import sendEmail from '@salesforce/apex/EmailServiceClass.sendEmail'; 
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";


export default class  extends LightningElement {
    @track BookCalClass = 'slds-section slds-is-open'; //this starts as section open
    toggleSpinner = true;
    @track mobilePhoneData={};
    @api recordid;
    @track selectedFields = {selectedFieldsContact:'',selectedFieldsLead:''};
    disableSubmit = true;
    modigieLogoUrl = MODIGIELOGO;
    activeSections = ['A', 'B'];
    sampleVar='';
    credentialAvailable=false;

    totalLimit;
    usedLimit;
    remainingLimit;
    @track errorToastMessage="";
    @track limitsData = {Ad_Hoc_Limits:false};


    connectedCallback(){
        sendAPILimitData({})
         .then((result1) => {
        this.limitsData = JSON.parse(result1);
        this.totalLimit = this.limitsData.Total_API_Limit;
        this.usedLimit = this.limitsData.Used_API_Limit;

        if(this.limitsData.Total_API_Limit - this.limitsData.Used_API_Limit > 0){
            this.remainingLimit = this.limitsData.Total_API_Limit - this.limitsData.Used_API_Limit; 
        }
        else{
            this.remainingLimit = 0;
        }

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

        this.sampleVar='customClass';
        getMobileInformation({
            recid: this.recordid   
        }).then(result => {
            this.toggleSpinner=false;
            this.mobilePhoneData = JSON.parse(result);
            this.credentialAvailable=true;
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
    }

    renderedCallback(){
        const statusEle = this.template.querySelector('[data-name="SampleAtt"]');
        if(statusEle != null){
            statusEle.style="font-size:large";
        }
        
    }
    handleChangeContact(event){
        
        if(this.selectedFields.selectedFieldsContact.indexOf(event.target.dataset.name + ',') != -1){
            this.selectedFields.selectedFieldsContact =this.selectedFields.selectedFieldsContact.replace(event.target.dataset.name + ',' ,'');    
        }
        else{
            this.selectedFields.selectedFieldsContact += event.target.dataset.name + ',';
        }
        
        if(this.selectedFields.selectedFieldsContact == '' && this.selectedFields.selectedFieldsLead == ''){ 
            this.disableSubmit=true;
        }
        else{
            this.disableSubmit=false;
        }
        
    }
    
    handleChangeLead(event){
        
        if(this.selectedFields.selectedFieldsLead.indexOf(event.target.dataset.name + ',') != -1){
            this.selectedFields.selectedFieldsLead =this.selectedFields.selectedFieldsLead.replace(event.target.dataset.name + ',' ,'');    
        }
        else{
            this.selectedFields.selectedFieldsLead += event.target.dataset.name + ',';
        }
        
        if(this.selectedFields.selectedFieldsContact == '' && this.selectedFields.selectedFieldsLead == ''){
            this.disableSubmit=true;
        }
        else{
            this.disableSubmit=false;
        }
        
    }
    
    closeModel(){
        const closeQA = new CustomEvent('close',{detail:this.errorToastMessage}); 
        this.dispatchEvent(closeQA); 
    }

    syncNewRecords(){
        this.disableSubmit=true; 
        this.toggleSpinner=true;

        requestPhoneIntelJobs({
            recid: this.recordid,
            inputNumbers:JSON.stringify(this.selectedFields),
            syncNewOrAll : 'New'
        }).then(result => {
            const event = new ShowToastEvent({
                "title": "Success!",
                "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                "variant": "success"
            });

            this.dispatchEvent(event);

            const closeQA = new CustomEvent("close",{ detail: '0' });
            this.dispatchEvent(closeQA);
            //this.closeModel();
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
               /* sendEmail({
                    message:error.body.message
                }).then(result2 => {
                }).catch(error2 => {
                });*/
                this.closeModel();
        });
    }

    syncAllRecords(){
        this.disableSubmit=true; 
        this.toggleSpinner=true;

        requestPhoneIntelJobs({
            recid: this.recordid,
            inputNumbers:JSON.stringify(this.selectedFields),
            syncNewOrAll : 'All'
        }).then(result => {
            const event = new ShowToastEvent({
                "title": "Success!",
                "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                "variant": "success"
            });

            this.dispatchEvent(event);

            const closeQA = new CustomEvent("close",{ detail: '0' });
            this.dispatchEvent(closeQA);
            //this.closeModel();
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
                /*sendEmail({
                    message:error.body.message
                }).then(result2 => {
                }).catch(error2 => {
                });*/
                this.closeModel();
        });    
    }
    handleSubmit(){
        this.toggleSpinner=true;
        this.closeModel();
    }
}