public with sharing class PurchaseOrderTriggerHandler {
    public static void handle(List<PurchaseOrder__c> triggerNewPurchaseOrder, List<PurchaseOrder__c> triggerOldPurchaseOrder, System.TriggerOperation triggerOperation) {

        switch on triggerOperation {
            when BEFORE_UPDATE {
                PurchaseOrderService.PurchaseOrderRollback(triggerOldPurchaseOrder, triggerNewPurchaseOrder);
            }
            when AFTER_UPDATE {
                PurchaseOrderService.PurchaseOrderUpdate(triggerOldPurchaseOrder, triggerNewPurchaseOrder);
            }
        }
    }
}