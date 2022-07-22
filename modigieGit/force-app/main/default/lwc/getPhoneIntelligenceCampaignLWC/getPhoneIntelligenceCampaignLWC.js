/*import {LightningElement,api,wire, track} from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import CampaignCallout from '@salesforce/apex/GetPhoneIntelligenceCampaignButton.CampaignCallout';
import campaignCalloutForNewMembers from '@salesforce/apex/GetPhoneIntelligenceCampaignButton.campaignCalloutForNewMembers';
import checkBatchJobStatus from '@salesforce/apex/GetModigieCampaignButton.checkBatchJobStatus';

export default class GetPhoneIntelligenceCampaignLWC extends LightningElement {
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
    lstPendingJobIds=[];

    
    connectedCallback(){
        this.refreshComponent();
    }
    syncNewRecords(){
       this.disableSubmit=true; 
       if(this.memberCount == 0)
        {
            
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": "No records available to process",
                "variant": "error",
            });

            this.dispatchEvent(event);
            
            

            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA);
        }

        else if(this.creditCount >= this.memberCount || this.creditCount < this.memberCount)
        {
            this.toggleSpinner=true;

            campaignCalloutForNewMembers({
                recid: this.recordid
             }).then(result => {

                if(result == null){
                    const event = new ShowToastEvent({
                        "title": "Error!",
                        "message": "Some error occured!",
                        "variant": "error"
                    });
        
                    this.dispatchEvent(event);  
                    this.closeModel();
                }

                else if(result.length == 0){
                    const event = new ShowToastEvent({
                        "title": "Error!",
                        "message": "No records were found!",
                        "variant": "error"
                    });
        
                    this.dispatchEvent(event);
                    this.closeModel();
                }

                else{
                    this.lstPendingJobIds = result;    
                    this.checkJobsStatus();
                }            
            })
            .catch(error => {
                this.error = error;
            });
        }

        else if(this.creditCount < this.memberCount){
            var redSize = this.memberCount - this.creditCount;

            const event = new ShowToastEvent({
                "title": "Error!",
                "message": "The batch size is "+this.memberCount+" and the available credits are not enough. Please reduce the number of selected records to "+redSize,
                "variant": "error"
            });

            this.dispatchEvent(event);

            const closeQA = new CustomEvent('close');
            this.dispatchEvent(closeQA);
        }
    }

    closeModel(){
        const closeQA = new CustomEvent('close');
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
                this.closeModel();
            }
        })
        .catch(error => {
            
        });
    }

    refreshComponent(){
        CampaignCallout({
            recid: this.recordid
         }).then(result => {
            this.toggleSpinner=false;
           this.resMap=JSON.parse(result); 
           var count = JSON.parse(result);
           if(count.TokenExist == 1){
               this.haveRecordsToProcess = true;
                this.showModel=true;
               this.memberCount=this.resMap.recordsToProcess;
               this.creditCount = this.resMap.remainingCredit;
                this.toggleSpinner=false;
           }

           else if(count.TokenExist == 0){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "You are not an authorised user",
                    "variant": "error"
                });
                this.dispatchEvent(event);
                const closeQA = new CustomEvent('close'); 
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -1){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "Insuffiecient Credits",
                    "variant": "error"
                });
                this.dispatchEvent(event);
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -2){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": "You doesn't have permissions to modigie object.",
                    "variant": "error"
                });
                this.dispatchEvent(event);
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
            }
            else if(count.TokenExist == -3){
                this.showModel = true;
                
            }
        })
        .catch(error => {
            this.error = error;
        });
    }
}*/