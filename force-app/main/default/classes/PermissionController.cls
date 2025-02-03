public with sharing class PermissionController {
    
    @AuraEnabled(cacheable=true)
    public static Boolean UserhasPermissiontoSendOrder(){
        String permissionName = 'Access_Send_Order';
        return FeatureManagement.checkpermission(permissionName);
    }
}