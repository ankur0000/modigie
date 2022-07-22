import { LightningElement,api, track} from 'lwc';
import { subscribe, unsubscribe, onError, setDebugFlag, isEmpEnabled } from 'lightning/empApi';
// import MODIGIELOGO from '@salesforce/resourceUrl/ModigieLogo';
// import getInProcessJobInformation from '@salesforce/apex/AbortJobComponentController.getInProcessJobInformation';

// import abortJob from '@salesforce/apex/AbortJobComponentController.abortJob';
// import { NavigationMixin } from 'lightning/navigation';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';


export default class AbortJobComponent extends LightningElement {
    
    channelName = '/event/modigie__Modigie_Tab_Refresh__e';
    subscription = {};
    connectedCallback() {       
        // Register error listener       
        this.registerErrorListener();    
        this.handleSubscribe();
    }

    handleSubscribe() {
        // Callback invoked whenever a new event message is received
        const messageCallback = function(response) {
            console.log('New message received: ', JSON.parse(JSON.stringify(response)));
            // Response contains the payload of the new message received
        };

        // Invoke subscribe method of empApi. Pass reference to messageCallback
        subscribe(this.channelName, -1, messageCallback).then(response => {
            // Response contains the subscription information on subscribe call
            console.log('Subscription request sent to: ', JSON.stringify(response.channel));
            this.subscription = response;
        });
    }

    registerErrorListener() {
        // Invoke onError empApi method
        onError(error => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
    }


    
    // @api recordid;
    // modigieLogoUrl = MODIGIELOGO 
    // toggleSpinner=true;
    // disableSubmit=true;
    // @track serviceUsageMap = {"VerifyEmployer":true,"GetPhoneIntelligence":true,"GetLinkedIn":true,"GetModigie":true};
    // selectedService;


    // connectedCallback(){
    //     getInProcessJobInformation({
    //         recId: this.recordid
    //     }).then(result1=>{
    //       this.toggleSpinner=false;
        
    //       this.serviceUsageMap = JSON.parse(result1);
    //     }).catch(error1 => {
    //     })
    // }
    // handleChange(event){
    //     this.disableSubmit=false;
    //     this.selectedService = event.target.dataset.name;
    // }
    // closeModel() {
    //     const closeQA = new CustomEvent('close');
    //     this.dispatchEvent(closeQA);
    // }

    // handleSubmit(){
    //     this.toggleSpinner =true;
    //     abortJob({
    //         recId: this.recordid,
    //         service:this.selectedService
    //     }).then(result1=>{
    //         this.toggleSpinner=false;
            
    //         ('Result True False-->> ',result1);

    //         if(result1.endsWith('successfully.')){
    //             const event = new ShowToastEvent({
    //                 "title": "Success!",
    //                 "message": result1,
    //                 "variant": "success"
    //             });
    //             this.dispatchEvent(event);
    //         }
            
    //         else{
    //             const event = new ShowToastEvent({
    //                 "title": "Error!",
    //                 "message": result1,
    //                 "variant": "error"
    //             });
    //             this.dispatchEvent(event);
    //         }
          
    //         this.closeModel();
    //     }).catch(error1 => {
    //     })
    // }
}