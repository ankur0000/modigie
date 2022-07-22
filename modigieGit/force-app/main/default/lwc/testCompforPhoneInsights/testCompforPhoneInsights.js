/*import { LightningElement,track, api } from 'lwc';
import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getMobileInformation from '@salesforce/apex/GetPhoneInsightsCampaignButton.getMobileInformation';
import requestPhoneIntelJobs from '@salesforce/apex/GetPhoneInsightsCampaignButton.requestPhoneIntelJobs';

export default class TestCompforPhoneInsights extends LightningElement {
    @track BookCalClass = 'slds-section slds-is-open'; //this starts as section open
    toggleSpinner = true;
    @track mobilePhoneData={};
    @api recordid;
    @track selectedFields = {selectedFieldsContact:'',selectedFieldsLead:''};
    disableSubmit = true;
    modigieLogoUrl = MODIGIELOGO;
    activeSections = ['A', 'B'];
    sampleVar='';

    connectedCallback(){
        this.sampleVar='customClass';
        getMobileInformation({
            recid: this.recordid   
        }).then(result => {
            this.toggleSpinner=false;
            this.mobilePhoneData = JSON.parse(result);
        })
        .catch(error => {
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error,
                "variant": "error"
            });
            this.dispatchEvent(event);  
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
        const closeQA = new CustomEvent('close'); 
        this.dispatchEvent(closeQA); 
    }

    syncNewRecords(){
        this.disableSubmit=true; 
        this.toggleSpinner=true;

        requestPhoneIntelJobs({
            recid: this.recordid,
            inputNumbers:JSON.stringify(this.selectedFields)
        }).then(result => {
            const event = new ShowToastEvent({
                "title": "Success!",
                "message": "Modigie is actively identifying and validating the information you requested. Please check back here in a few minutes to see your results.",
                "variant": "success"
            });

            this.dispatchEvent(event);
            this.closeModel();
        })
        .catch(error => {
            const event = new ShowToastEvent({
                "title": "Error!",
                "message": error,
                "variant": "error"
            });

            this.dispatchEvent(event); 
            this.closeModel();
        });
    }

    handleSubmit(){
        this.toggleSpinner=true;
        this.closeModel();
    }
    ExpBookCalendar(){
        if(this.BookCalClass.includes('slds-is-open')){ // if section is open
          this.BookCalClass = 'slds-section'; //set class to close 
        }else{
          this.BookCalClass = 'slds-section slds-is-open'; //set class to be open
        }
    }
}*/