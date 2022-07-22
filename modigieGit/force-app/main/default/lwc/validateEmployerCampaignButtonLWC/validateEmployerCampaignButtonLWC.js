import {LightningElement,api,wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent'
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import CampaignCallout from '@salesforce/apex/ValidateEmployerCampaignButton.CampaignCallout';
import campaignCalloutForNewMembers from '@salesforce/apex/ValidateEmployerCampaignButton.campaignCalloutForNewMembers';
import campaignCalloutForAllMembers from '@salesforce/apex/ValidateEmployerCampaignButton.campaignCalloutForAllMembers';

import checkBatchJobStatus from '@salesforce/apex/GetModigieCampaignButton.checkBatchJobStatus';
import sendEmail from '@salesforce/apex/EmailServiceClass.sendEmail'; 
import sendAPILimitData from "@salesforce/apex/LimitsMapClass.sendAPILimitData";



export default class ValidateEmployerCampaignButtonLWC extends LightningElement {
    @api recordid;
    @track resMap = {totalSize:0,recordsRunning:0,alreadyValidated:0,recordsToProcess:0,invalidatedRecords:0,notFulfill:0,userFilled:0};  
    showModel = false;
    totalCampaignMembers;
    modigieLogoUrl = MODIGIELOGO; 
    alreadyValidatedMembers;
    recordsToProcess;
    memberCount;
    creditCount;
    disableSubmit = false;
    toggleSpinner = true;
    notfulfillingRecords;
    haveRecordsToProcess = false;
    haveTotalRecordsToProcess = false;
    lstPendingJobIds=[];

    totalLimit;
    usedLimit;
    remainingLimit;
    @track errorToastMessage="";

    @track limitsData = {Ad_Hoc_Limits:false};


    connectedCallback(){
        this.refreshComponent();
    }
    syncNewRecords(){
       this.disableSubmit=true; 
       

        //if(this.creditCount >= this.memberCount || this.creditCount < this.memberCount){
            this.toggleSpinner=true;
            
            campaignCalloutForNewMembers({
                recid: this.recordid
             }).then(result => {

                if(result == null){
                    var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = "Some error occured!";
                }
                else{
                    const event = new ShowToastEvent({
                        "title": "Error!",
                        "message": "Some error occured!",
                        "variant": "error"
                    });
        
                    this.dispatchEvent(event); 
                } 
                    this.closeModel();
                }

                else if(result.length == 0){
                    var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = "No records were found!";
                }
                else{
                    const event = new ShowToastEvent({
                        "title": "Error!",
                        "message": "No records were found!",
                        "variant": "error"
                    });
        
                    this.dispatchEvent(event);
                }
                    this.closeModel();
                }

                else{
                    this.lstPendingJobIds = result;    
                    this.checkJobsStatus();
                }
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
                if(errorMap.ErrorMessage != undefined){
                   /* sendEmail({
                        message:error.body.message
                    }).then(result2 => {
                    }).catch(error2 => {
                    });*/
                    
                }
                this.closeModel();
            });
       // }
    }


    syncAllRecords(){
        this.disableSubmit=true; 
        
 
         //if(this.creditCount >= this.memberCount || this.creditCount < this.memberCount){
             this.toggleSpinner=true;
             
             campaignCalloutForAllMembers({
                 recid: this.recordid
              }).then(result => {
                 if(result == null){
                     var currentPageURL = window.location.href.toString();
                 if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                     this.errorToastMessage = "Some error occured!";
                 }
                 else{
                     const event = new ShowToastEvent({
                         "title": "Error!",
                         "message": "Some error occured!",
                         "variant": "error"
                     });
         
                     this.dispatchEvent(event); 
                 } 
                     this.closeModel();
                 }
 
                 else if(result.length == 0){
                     var currentPageURL = window.location.href.toString();
                 if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                     this.errorToastMessage = "No records were found!";
                 }
                 else{
                     const event = new ShowToastEvent({
                         "title": "Error!",
                         "message": "No records were found!",
                         "variant": "error"
                     });
         
                     this.dispatchEvent(event);
                 }
                     this.closeModel();
                 }
 
                 else{
                     this.lstPendingJobIds = result;    
                     this.checkJobsStatus();
                 }
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
                 if(errorMap.ErrorMessage != undefined){
                    /* sendEmail({
                         message:error.body.message
                     }).then(result2 => {
                     }).catch(error2 => {
                     });*/
                     
                 }
                 this.closeModel();
             });
        
     }

    closeModel(){
        const closeQA = new CustomEvent('close', { detail: this.errorToastMessage });
        this.dispatchEvent(closeQA);
    }
    checkJobsStatus(){
        checkBatchJobStatus({
            lstIds: this.lstPendingJobIds
         }).then(result => {
            
            if(result != 0){
                this.checkJobsStatus();
            }
            else{
                const event = new ShowToastEvent({
                    "title": "Success!",
                    "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                    "variant": "success"
                });
    
                this.dispatchEvent(event);

                const closeQA = new CustomEvent("close", { detail: result });
                this.dispatchEvent(closeQA);
                //this.closeModel();
            }
        })
        .catch(error => {
            this.error = error;
        });
    }

    refreshComponent(){
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

        CampaignCallout({
            recid: this.recordid
         }).then(result => {
            this.toggleSpinner=false;
           this.resMap=JSON.parse(result); 
           
           var count = JSON.parse(result);

           if(this.resMap.TokenExist == 1){
            this.showModel=true;
            this.memberCount=this.resMap.recordsToProcess;
            this.creditCount = this.resMap.remainingCredit;
            this.toggleSpinner=false;

            this.haveTotalRecordsToProcess = true;

            if(this.memberCount > 0 && this.resMap.totalSize != this.resMap.newRecordsToProcess && this.resMap.newRecordsToProcess > 0){
                this.haveRecordsToProcess = true;
            }

        }




        

           

           else if(count.TokenExist == 0){
            var currentPageURL = window.location.href.toString();
            if(currentPageURL.includes('visualforce.com') || currentPageURL.includes('visual.force.com')){
                this.errorToastMessage = "You are not an authorised user";
            }
            else{
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "You are not an authorised user",
                    "variant": "error"
                });
                this.dispatchEvent(event);
            }
                const closeQA = new CustomEvent('close'); 
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -1){
                var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com')  || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = "Insuffiecient Credits";
                }
                else{
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "Insuffiecient Credits",
                    "variant": "error"
                });
                this.dispatchEvent(event);
            }
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -2){
                var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com')  || currentPageURL.includes('visual.force.com')){
                    this.errorToastMessage = "You doesn't have permissions to modigie object.";
                }
                else{
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "You doesn't have permissions to modigie object.",
                    "variant": "error"
                });
                this.dispatchEvent(event);
            }
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -3){
                this.showModel = true;
                
            }

            else
            {
            }
        })
        .catch(error => {
            var currentPageURL = window.location.href.toString();
                if(currentPageURL.includes('visualforce.com')  || currentPageURL.includes('visual.force.com')){
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
}