import { LightningElement,api,wire} from 'lwc';
/*import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
import checkValidateRecord from '@salesforce/apex/GetPhoneIntelligence.checkValidateRecord';
import makeGetCallout from '@salesforce/apexContinuation/GetPhoneIntelligence.makeGetCallout';

//import makeGetCallout from '@salesforce/apexContinuation/GetLinkedinButton.makeGetCallout';
//import dataToModigie from '@salesforce/apex/GetLinkedinButton.dataToModigie';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import dataToModigie from '@salesforce/apex/GetPhoneIntelligence.dataToModigie';*/

export default class GetNumberIntelligenceButtonLWC extends LightningElement { 
    @api recordid;
   /* alreadySynced = false;
    modigieLogoUrl = MODIGIELOGO;
    toggleSpinner=true;
    
   
    alreadySyncedMessage='';
    disableSubmit=false;
    getModigie=true;
    returnMap={};
    modirecordid='';
    StatusCheck=false;
    StatusMessage='';
    creditsAvailable=false;

  
    connectedCallback(){
        checkValidateRecord({
            recid: this.recordid   
        }).then(result => {
            this.toggleSpinner=false;
            if(result == 'Insufficient Credits.'){
                const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": result,
                    "variant": "error"
                });
                this.dispatchEvent(event);  
                this.closeModel();
            }
            else{
                this.creditsAvailable=true;
            }
          

            if(result.endsWith('"Phone Insights" ?')){
                this.alreadySynced=true;
                this.StatusMessage=result;
            }
          
            else{
                this.StatusCheck=true;
                this.StatusMessage=result;
            }
        })
        .catch(error => {
            //this.error = error;
        });
    }
    

    openModel(){
        this.disableSubmit=true;
        this.toggleSpinner=true;
        
        makeGetCallout({
            recid: this.recordid   
        }).then(result => {
            var calloutResponse = JSON.parse(result);
            dataToModigie({
                resMap:result,
                recids:this.recordid
            }).then(result1 =>{
                this.toggleSpinner=false;
                if(calloutResponse.hasOwnProperty("id")){
                    const event = new ShowToastEvent({
                        "title": "Success!",
                        "message": "Thank you, the record has been successfully submitted to Modigie.",
                        "variant": "success"
                    });
                    this.dispatchEvent(event);
                    
                    const closeQA = new CustomEvent('close',{detail:result1});
                    this.dispatchEvent(closeQA);

                //    window.location.reload();
                   }
                   else{
                    const event = new ShowToastEvent({
                    "title": "Error!",
                    "message": calloutResponse.message,
                    "variant": "error"
                });
                this.dispatchEvent(event);    
                
                const closeQA = new CustomEvent('close');
                this.dispatchEvent(closeQA);
               } 
            })
            .catch(error1 => {
            })
        })
        .catch(error => {
        });
    }
    closeModel() {
        
        
        const closeQA = new CustomEvent('close');
        this.dispatchEvent(closeQA);
    }*/
}