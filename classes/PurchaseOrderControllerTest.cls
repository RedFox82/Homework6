@IsTest
private class PurchaseOrderControllerTest {

    @TestSetup
    static void setup() {
        List<Account> accs = new List<Account>();
        accs.addAll(TestDataFactory.createAccounts('Vendor', 1));
        accs.addAll(TestDataFactory.createAccounts('Customer', 1));
        insert accs;

        String vendorId = [SELECT Id FROM Account WHERE RecordType.Name = 'Vendor' LIMIT 1].Id;
        List<Product2> product2s = TestDataFactory.ListProduct2s(vendorId, 2);
        insert product2s;
    }

    @IsTest
    static void getProductsTest() {
        //given
        List<Product2> product2s = new List<Product2>();

        //when
        Test.startTest();
        product2s = PurchaseOrderController.getProducts();
        Test.stopTest();

        //then
        System.assertEquals(2, [SELECT COUNT() FROM Product2]);
    }

    @IsTest
    static void addLinesTest_positive() {
        //given
        Id accountId = [SELECT Id FROM Account WHERE RecordType.Name = 'Vendor' LIMIT 1].Id;
        String name_order = 'Test order';
        Product2 prod = [SELECT Id, Name FROM Product2 LIMIT 1];
        Integer qua = 1;
        String j_items = '{"' + prod.Id + '":{"0":' + qua + '}}';

        Pricebook2 standard_pricebook = New Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standard_pricebook;

        PricebookEntry standardPBE = new PricebookEntry(Pricebook2Id = standard_pricebook.Id, Product2Id = prod.Id, UnitPrice = 100);
        insert standardPBE;

        //when
        Test.startTest();
        PurchaseOrderController.addLines(accountId, name_order, j_items);
        Test.stopTest();

        //then
        System.assertEquals(1, [SELECT COUNT() FROM PurchaseOrder__c]);
        System.assertEquals(1, [SELECT COUNT() FROM PurchaseOrderLineItem__c]);
    }

    @IsTest
    static void addLinesTest_bulk() {
        //given
        Id accountId = [SELECT Id FROM Account WHERE RecordType.Name = 'Vendor' LIMIT 1].Id;
        String name_order = 'Test order';
        List<Product2> prods = [SELECT Id, Name FROM Product2];

        Pricebook2 standard_pricebook = New Pricebook2(Id = Test.getStandardPricebookId(), IsActive = true);
        update standard_pricebook;
        List<PricebookEntry> standardPBE = new List<PricebookEntry>();
        List<String> j_items = new List<String>();

        for (Product2 prod : prods) {
            standardPBE.add(new PricebookEntry(Pricebook2Id = standard_pricebook.Id, Product2Id = prod.Id, UnitPrice = 100));
        }

        insert standardPBE;

        String j_item = '{"' + prods[0].Id + '":{"0":1,"1":22},"' + prods[1].Id + '":{"2":4,"3":6}}';

        //when
        Test.startTest();
        PurchaseOrderController.addLines(accountId, name_order, j_item);
        Test.stopTest();

        //then
        System.assertEquals(1, [SELECT COUNT() FROM PurchaseOrder__c]);
        System.assertEquals(4, [SELECT COUNT() FROM PurchaseOrderLineItem__c]);
    }

}