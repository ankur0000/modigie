@RestResource(urlMapping='/AccountService/*')
global class SampleRestResource {

 @HttpGet
 global static List<Account> getAccounts() {
   List<Account> Accounts = [SELECT Id,Name from Account LIMIT 10];
   return Accounts;
 }

 @HttpPost 
 global static String createNewAccount(String Name) {
   Account a = new Account();
   if(FieldLevelSecurityCheck.canCreateObject('Account')
   && FieldLevelSecurityCheck.canCreateField('Account', 'Name')){
    a.Name = Name;
    insert a;
   }
   return 'Account Created';
 }

 @HttpDelete
 global static String deleteAccountById() {
 
   RestRequest req = RestContext.request;
   String Id = req.params.get('Id');
  
   List<Account> a = [ Select ID from Account where Id= :Id];

   if(FieldLevelSecurityCheck.canDeleteObject('Account')){
    delete a;
   }

   return 'Account Deleted';
 }

 @HttpPut
 global static String updateAccount(String Id, String NewName) {
  if(FieldLevelSecurityCheck.canCreateObject('Account')
  && FieldLevelSecurityCheck.canReadField('Account', 'Name')
  && FieldLevelSecurityCheck.canUpdateField('Account', 'Name')){
   Account a = [ Select ID, Name from Account where Id= :Id];
   a.Name = NewName;
   update a;
  }
   return 'Account Updated';
 }
}