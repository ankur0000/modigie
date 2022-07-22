import { LightningElement , api , track , wire } from 'lwc';
import getAssignee from '@salesforce/apex/AuthorizationClass.getAssignee';
import GetUser from '@salesforce/apex/AuthorizationClass.GetUser';
import saveAssignUserDetails from '@salesforce/apex/AuthorizationClass.saveAssignUserDetails';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class CreditAssigneeList extends LightningElement {
    @api recordId;
    @api encryptedId;
    @track UserDetails = [];
    @track isLoaded = false;
    @track searchTerm;
    @api title;
    @track noData;
    @track selectedUsersData = [];
    @api isPerformance;

    @track availableUsers = [];

    @track selectedUsers = [];
    @track defaultSelected = [];
    handleSave(){
        // console.log(JSON.stringify(this.selectedUsers),JSON.stringify(this.availableUsers));
        let detailsToSave = [];
        console.log('default selected----',JSON.stringify(this.defaultSelected));
        for(let i = 0; i < this.selectedUsers.length; i++){

            for(let j = 0; j < this.availableUsers.length; j++){
                if(this.selectedUsers[i] == this.availableUsers[j].value){
                    detailsToSave.push({
                        "userId": this.availableUsers[j].value,
                        "userName": this.availableUsers[j].label,
                        "recordId": this.recordId,
                        "creditTitle": this.title,
                    });
                }
            }
        }
        console.log('detailsToSave',JSON.stringify(detailsToSave));
        // console.log(JSON.stringify(this.selectedUsersData));
        let listToInsert = [];
        for(let i = 0; i < detailsToSave.length; i++){
            for(let j = 0; j < this.selectedUsersData.length; j++){
                if(detailsToSave[i].userId == this.selectedUsersData[j].value){
                    this.selectedUsersData.splice(j,1);
                    // detailsToSave.splice(i,1);
                }
                else if(detailsToSave[i].userId != this.selectedUsersData[j].value){
                    listToInsert.push(detailsToSave[i]);
                    // this.selectedUsersData.splice(j,1); 
                }
            }
        }
        // console.log('selectedUsers',JSON.stringify(this.selectedUsers));
        let listToDelete = this.selectedUsersData;
        // console.log('INSERT----',listToInsert);

        console.log('DELETE-------',JSON.stringify(listToDelete));
        
            saveAssignUserDetails({details: detailsToSave, defaultSelected: this.defaultSelected, recordsToDelete: listToDelete, isPerformance: this.isPerformance}).then(result => {
                console.log(result);
                const evt = new ShowToastEvent({
                    title: 'Success',
                    message: 'Users updated successfully!',
                    variant: 'Success',
                });
                this.dispatchEvent(evt);
                const closemodel  = new CustomEvent("closemodel" , {
            
                })
                this.dispatchEvent(closemodel);
            }).catch(error => {
                console.log('error', error);
            });
        
        
    }
    handleChange(event) {
        // Get the list of the "value" attribute on all the selected options
        const selectedOptionsList = event.detail.value;
        console.log('Event.detail',JSON.stringify(event.detail));
        this.selectedUsers = [];
        for(let i = 0; i < selectedOptionsList.length; i++){
            this.selectedUsers.push(selectedOptionsList[i]);
        }
        console.log('gs selectedUser',JSON.stringify(this.selectedUsers), this.selectedUsers.length);

        // this.searchTerm = '';
        // console.log(this.selectedUsers, selectedOptionsList);
        // for(let i = 0; i < this.availableUsers.length; i++){
        //     for(let j = 0; j < selectedOptionsList.length; j++){
        //         if(this.availableUsers[i].value == selectedOptionsList[j]){
        //             this.availableUsers.push({
        //                 label: this.availableUsers[i].label,
        //                 value: this.availableUsers[i].value
        //             })
        //         }
        //     }
        // }
        // alert(`Options selected: ${selectedOptionsList}`);
    }
    constructor(){
        super();
    }
    connectedCallback() {
        getAssignee({recordId: this.recordId}).then(response => {
            console.log('assignee' , JSON.parse(response));
            var Data = JSON.parse(response);
            var count  = Object.keys(Data).length;
            var arr = Object.keys(Data);
            console.log('ANkurlength..' ,count );
            this.noData = count == 0 ? true : false;
            // console.log('dataid...' , Data[arr[0]]);
            // console.log('dataid...' , JSON.parse(Data[arr[0]]).userid);



            for(var i=0; i<count;i++){
                var length1  = JSON.parse(Data[arr[i]]).PermissionSetName.length;
                console.log('length is..' , length1);
                var parsedData = JSON.parse(Data[arr[i]]);
                let textColor, isActive = 'True', permissionSets;
                if(parsedData.isActive == false || parsedData.PermissionSetName.substring(1, length1 - 1) == '')
                {
                    textColor = 'grayColor';
                }
                else{
                    textColor = 'blackColor';
                }
                if(parsedData.isActive == false){
                    isActive = 'False';
                }
                if(parsedData.PermissionSetName.substring(1, length1 - 1) == ''){
                    permissionSets = '-';
                }
                else{
                    permissionSets = parsedData.PermissionSetName.substring(1, length1 - 1);
                }
                this.UserDetails.push({
                   
                        "UserId": parsedData.userid,
                        "Name":  parsedData.Username,
                        "Active": isActive,
                        "PermissionSet":   permissionSets,
                        "TextColorClass": textColor,
                
                    });
                this.selectedUsers.push(parsedData.userid);
                this.defaultSelected.push(parsedData.userid);
                this.selectedUsersData.push({label: parsedData.Username, value: parsedData.userid});
                console.log('selectedUsers--------->',JSON.stringify(this.selectedUsers));
            }

            
            GetUser({searchTerm: '', creditRecordId: this.recordId, isPerformance: this.isPerformance}).then(result => {
                console.log('reslut-------->',result);
                this.availableUsers = [];
                if(result != null){
                    for(let i = 0; i < result.length; i++){
                    
                        this.availableUsers.push({
                            value: result[i].Id,
                            label: result[i].Name
                        });
                    }
                }
                
                this.isLoaded = true;
                console.log('--------->',JSON.stringify(this.availableUsers), JSON.stringify(this.selectedUsers));
            });
            
               
        });
        // console.log('--------->',this.availableUsers, this.selectedUsers);
    }
    handleClose(){
        const closemodel  = new CustomEvent("closemodel" , {
            
        })
        this.dispatchEvent(closemodel);
    }

    handleInputChange(event){
        console.log('gsb selectedUserSearch 224',JSON.stringify(this.selectedUsers));
        console.log('gsb availableUsers 225',JSON.stringify(this.availableUsers));
        let listToAppend = [];
        for(let j = 0; j < this.selectedUsers.length; j++){
            for(let i = 0; i < this.availableUsers.length; i++){
                if(this.selectedUsers[j] == this.availableUsers[i].value){
                    listToAppend.push({
                        label: this.availableUsers[i].label,
                        value: this.availableUsers[i].value
                    });
                    break;
                }
                
                // listToAppend.push(...this.availableUsers.get(this.selectedUsers[i]));
            }
        }
        console.log('listToAppend---->',listToAppend);
        GetUser({searchTerm: event.target.value, creditRecordId: this.recordId, selectedIds: this.selectedUsers, isPerformance: this.isPerformance}).then(result => {  
            this.availableUsers = [];
           
            if(result != null){
                for(let i = 0; i < result.length; i++){
                    // for(let j = 0; j < this.selectedUsersData.length; j++){
                    //     if(result[i].Id != this.selectedUsersData[j].value){
                            this.availableUsers.push({
                                value: result[i].Id,
                                label: result[i].Name
                            });
                    //     }
                        
                    // }
                    
                }
            }
            console.log('gs AvailableUser 242 from apex',JSON.stringify(this.availableUsers));
            if(listToAppend.length > 0){
                this.availableUsers.push(...listToAppend);
            }
            console.log('gs AvailableUser 246total',JSON.stringify(this.availableUsers));
        });
    }
}