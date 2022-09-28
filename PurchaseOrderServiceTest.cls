@IsTest
private class PurchaseOrderServiceTest {

    @testSetup static void setup() {
        List<Account> accs = new List<Account>();
        accs.add(new Account(Name = 'Vendor Account', RecordTypeId = '0127R000000dHr7QAE', Phone = '(653) 897-3540'));
        insert accs;

        Account vendor = [SELECT Id From Account LIMIT 1];
        List<Product2> product2s = new List<Product2>();
        product2s.add(new Product2(Vendor__c = vendor.Id, Name = 'Test1', Stock__c = 10, Family = 'Mobile phones', Product_Type__c = 'Smartphones', ProductCode = 'PC1'));
        product2s.add(new Product2(Vendor__c = vendor.Id, Name = 'Test2', Stock__c = 10, Family = 'Mobile computers', Product_Type__c = 'Laptop', ProductCode = 'PC2'));
        insert product2s;
    }

    @IsTest
    static void testUpdate_increase() {
        //given
        Account vendor = [SELECT Id From Account LIMIT 1];

        List<PurchaseOrder__c> purchaseOrders  = TestDataFactory.ListPOs(1, vendor.Id);
        insert purchaseOrders;

        PurchaseOrder__c purchaseOrder = [SELECT Id FROM PurchaseOrder__c LIMIT 1];
        List<String> Ids = new List<String>();
        Ids.add(purchaseOrder.Id);

        List<Product2> product2s = [SELECT Id FROM Product2];
        List<PurchaseOrderLineItem__c> purchaseOrderLines = TestDataFactory.ListPOLines(2, Ids, product2s);
        insert purchaseOrderLines;

        purchaseOrder.Status__c = 'Completed';

        //when
        Test.startTest();
        update purchaseOrder;
        Test.stopTest();

        //then
        List<Product2> product2s_after = [SELECT Id, Stock__c FROM Product2];
        for (Product2 p : product2s_after) {
            System.assertEquals(12, p.Stock__c);
        }
    }

    @IsTest
    static void testUpdate_increase_bulk() {
        //given
        Account vendor = [SELECT Id From Account LIMIT 1];

        List<PurchaseOrder__c> purchaseOrders  = TestDataFactory.ListPOs(200, vendor.Id);
        insert purchaseOrders;

        purchaseOrders = [SELECT Id FROM PurchaseOrder__c];
        List<Id> Ids = new List<Id>();
        for (PurchaseOrder__c po : purchaseOrders) {
            Ids.add(po.Id);
            po.Status__c = 'Completed';
        }

        List<Product2> product2s = [SELECT Id FROM Product2];
        List<PurchaseOrderLineItem__c> purchaseOrderLines = TestDataFactory.ListPOLines(3, Ids, product2s);
        insert purchaseOrderLines;


        //when
        Test.startTest();
        update purchaseOrders;
        Test.stopTest();

        //then
        List<Product2> product2s_after = [SELECT Id, Stock__c FROM Product2];
        for (Product2 p : product2s_after) {
            System.assertEquals(610, p.Stock__c);
        }
    }

    @IsTest
    static void testUpdate_decrease() {
        //given
        Account vendor = [SELECT Id From Account LIMIT 1];

        List<PurchaseOrder__c> purchaseOrders  = TestDataFactory.ListPOs(1, vendor.Id);
        insert purchaseOrders;
        PurchaseOrder__c purchaseOrder = [SELECT Id FROM PurchaseOrder__c LIMIT 1];
        List<Id> Ids = new List<Id>();
        Ids.add(purchaseOrder.Id);

        List<Product2> product2s = [SELECT Id FROM Product2];
        List<PurchaseOrderLineItem__c> purchaseOrderLines = TestDataFactory.ListPOLines(2, Ids, product2s);
        insert purchaseOrderLines;

        purchaseOrder.Status__c = 'Completed';
        update purchaseOrder;

        purchaseOrder.Status__c = 'Draft';

        //when
        Test.startTest();
        update purchaseOrder;
        Test.stopTest();

        //then
        List<Product2> product2s_after = [SELECT Id, Stock__c FROM Product2];
        for (Product2 p : product2s_after) {
            System.assertEquals(10, p.Stock__c);
        }
    }

    @IsTest
    static void testUpdate_negative() {
        //given
        Account vendor = [SELECT Id From Account WHERE RecordTypeId = '0127R000000dHr7QAE'];

        List<PurchaseOrder__c> purchaseOrders  = TestDataFactory.ListPOs(1, vendor.Id);
        insert purchaseOrders;
        PurchaseOrder__c purchaseOrder = [SELECT Id FROM PurchaseOrder__c LIMIT 1];
        List<Id> Ids = new List<Id>();
        Ids.add(purchaseOrder.Id);

        List<Product2> product2s = [SELECT Id, Stock__c FROM Product2];
        List<PurchaseOrderLineItem__c> purchaseOrderLines = TestDataFactory.ListPOLines(2, Ids, product2s);
        insert purchaseOrderLines;

        purchaseOrder.Status__c = 'Completed';
        update purchaseOrder;

        for (Product2 p : product2s) {
            p.Stock__c = 0;
        }
        update product2s;

        purchaseOrder.Status__c = 'Draft';


        //when
        Test.startTest();
        try {
            update purchaseOrder;
        }
        catch (DmlException e) {
            String err = e.getMessage();
        }
        Test.stopTest();

        //then
        List<Product2> product2s_after = [SELECT Id, Stock__c FROM Product2];
        for (Product2 p : product2s_after) {
            System.assertEquals(0, p.Stock__c);
        }
        System.assertEquals('Completed', [SELECT Id, Status__c FROM PurchaseOrder__c].Status__c);
    }

}