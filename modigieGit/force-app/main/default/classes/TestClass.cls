public class TestClass {
    @AuraEnabled
    public static void creditUserDetail(){
        
       List<Integer> defau = new List<Integer>{1,2,3,9};
       List<Integer> updated = new List<Integer>{1,2,6,8,9};
       List<Integer> saveUpdatedValue = new List<Integer>();
       List<Integer> deletedValue = new List<Integer>();
       for(Integer upd : updated){
           integer count = 0;
           for(Integer def : defau){
               if(upd == def){
                   count ++;
                   break;
               }
           }
           if(count == 0){
                   saveUpdatedValue.add(upd);
          }
       }
        
        for(Integer def : defau){
            boolean flag = true ;
            for(Integer upd : updated){
                if(def == upd){
                    flag = false;
                    break;
                }
            }
            if(flag == true)
            {
                deletedValue.add(def);
            }
        }
       
       system.debug('save value.... '+ saveUpdatedValue);
       system.debug('deleted value.... '+deletedValue);
       //return saveUpdatedValue;
    }
}